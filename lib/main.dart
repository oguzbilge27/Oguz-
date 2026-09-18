import 'package:flutter/material.dart';

void main() {
  runApp(const OguzApp());
}

class OguzApp extends StatefulWidget {
  const OguzApp({super.key});

  @override
  State<OguzApp> createState() => _OguzAppState();
}

class _OguzAppState extends State<OguzApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OguzApp',
      themeMode: _themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.deepOrange,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepOrange,
        useMaterial3: true,
      ),
      home: LoginScreen(onToggleTheme: toggleTheme),
    );
  }
}

// Model Yapıları
class ChatUser {
  final String id;
  final String username;
  final String avatarUrl;

  ChatUser({required this.id, required this.username, required this.avatarUrl});
}

enum MessageType { text, image, location }

class Message {
  final String senderId;
  final String? text;
  final String? imageUrl;
  final String? locationText; // Konum bilgisi
  final MessageType type;
  final DateTime timestamp;

  Message({
    required this.senderId,
    this.text,
    this.imageUrl,
    this.locationText,
    required this.type,
    required this.timestamp,
  });
}

// --- EKRAN 1: GİRİŞ EKRANI ---
class LoginScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const LoginScreen({super.key, required this.onToggleTheme});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();

  void _login() {
    String username = _usernameController.text.trim();
    if (username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen geçerli bir kullanıcı adı girin!')),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          currentUsername: username,
          onToggleTheme: widget.onToggleTheme,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giriş Yap / Kaydol'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.account_circle, size: 80, color: Colors.deepOrange),
            const SizedBox(height: 20),
            const Text(
              'Uygulamaya Hoş Geldiniz',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Devam etmek için bir kullanıcı adı belirleyin.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Kullanıcı Adı',
                hintText: 'Örn: oguz_06',
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Giriş Yap', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

// --- EKRAN 2: ANA EKRAN ---
class HomeScreen extends StatefulWidget {
  final String currentUsername;
  final VoidCallback onToggleTheme;

  const HomeScreen({
    super.key,
    required this.currentUsername,
    required this.onToggleTheme,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<ChatUser> _allUsers = [
    ChatUser(id: '1', username: 'ahmet_06', avatarUrl: 'https://picsum.photos/id/1012/150'),
    ChatUser(id: '2', username: 'mehmet_dev', avatarUrl: 'https://picsum.photos/id/1025/150'),
    ChatUser(id: '3', username: 'zeynep_art', avatarUrl: 'https://picsum.photos/id/1062/150'),
    ChatUser(id: '4', username: 'can_gamer', avatarUrl: 'https://picsum.photos/id/1074/150'),
  ];

  List<ChatUser> _filteredUsers = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredUsers = _allUsers;
  }

  void _filterUsers(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredUsers = _allUsers;
      } else {
        _filteredUsers = _allUsers
            .where((user) =>
                user.username.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hoş geldin, ${widget.currentUsername}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: widget.onToggleTheme,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(onToggleTheme: widget.onToggleTheme),
                ),
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterUsers,
              decoration: InputDecoration(
                hintText: 'Kullanıcı adı ile ara...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterUsers('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          Expanded(
            child: _filteredUsers.isEmpty
                ? const Center(child: Text('Kullanıcı bulunamadı.'))
                : ListView.builder(
                    itemCount: _filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = _filteredUsers[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(user.avatarUrl),
                        ),
                        title: Text(user.username),
                        subtitle: const Text('Sohbet etmek için tıklayın'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatDetailScreen(
                                targetUser: user,
                                currentUsername: widget.currentUsername,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// --- EKRAN 3: SOHBET (EMOJİ + KONUM + FOTOĞRAF) ---
class ChatDetailScreen extends StatefulWidget {
  final ChatUser targetUser;
  final String currentUsername;

  const ChatDetailScreen({
    super.key,
    required this.targetUser,
    required this.currentUsername,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final List<Message> _messages = [];
  final TextEditingController _messageController = TextEditingController();
  bool _showEmojiPicker = false;

  final List<String> _emojis = ['😊', '😂', '🔥', '👍', '❤️', '🎉', '🚀', '😎'];

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        Message(
          senderId: widget.currentUsername,
          text: _messageController.text.trim(),
          type: MessageType.text,
          timestamp: DateTime.now(),
        ),
      );
    });

    _messageController.clear();
  }

  void _sendImage() {
    setState(() {
      _messages.add(
        Message(
          senderId: widget.currentUsername,
          imageUrl: 'https://picsum.photos/400/300',
          type: MessageType.image,
          timestamp: DateTime.now(),
        ),
      );
    });
  }

  // Canlı Konum Gönderme Simülasyonu
  void _sendLocation() {
    setState(() {
      _messages.add(
        Message(
          senderId: widget.currentUsername,
          locationText: '📍 Canlı Konum Paylaşıldı (37.0662° N, 37.3833° E)',
          type: MessageType.location,
          timestamp: DateTime.now(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(widget.targetUser.avatarUrl),
            ),
            const SizedBox(width: 10),
            Text(widget.targetUser.username),
          ],
        ),
      ),
      body: Column(
        children: [
          // Mesaj Akışı
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Text(
                      '${widget.targetUser.username} ile sohbeti başlatın!',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      final isMe = msg.senderId == widget.currentUsername;
                      return Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isMe
                                ? Theme.of(context).primaryColor
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: _buildMessageContent(msg, isMe),
                        ),
                      );
                    },
                  ),
          ),

          // Emoji Paneli Görünümü (Açılıp Kapanabilir)
          if (_showEmojiPicker)
            Container(
              height: 60,
              color: Colors.grey.shade200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _emojis.length,
                itemBuilder: (context, index) {
                  return IconButton(
                    icon: Text(_emojis[index], style: const TextStyle(fontSize: 24)),
                    onPressed: () {
                      _messageController.text += _emojis[index];
                    },
                  );
                },
              ),
            ),

          // Alt Mesaj Yazma Çubuğu
          Container(
            padding: const EdgeInsets.all(8.0),
            color: Theme.of(context).cardColor,
            child: Row(
              children: [
                // Emoji Paneli Butonu
                IconButton(
                  icon: const Icon(Icons.insert_emoticon),
                  onPressed: () {
                    setState(() {
                      _showEmojiPicker = !_showEmojiPicker;
                    });
                  },
                ),
                // Fotoğraf Gönderme Butonu
                IconButton(
                  icon: const Icon(Icons.camera_alt),
                  onPressed: _sendImage,
                ),
                // Konum Paylaşma Butonu
                IconButton(
                  icon: const Icon(Icons.location_on, color: Colors.red),
                  onPressed: _sendLocation,
                  tooltip: 'Canlı Konum Gönder',
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Mesaj yazın...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: Theme.of(context).primaryColor,
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Mesaj Tipine Göre Görünüm Oluşturucu
  Widget _buildMessageContent(Message msg, bool isMe) {
    if (msg.type == MessageType.image) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          msg.imageUrl!,
          width: 200,
          height: 150,
          fit: BoxFit.cover,
        ),
      );
    } else if (msg.type == MessageType.location) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.my_location, color: Colors.white, size: 18),
              const SizedBox(width: 6),
              Text(
                'Canlı Konum',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isMe ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            msg.locationText!,
            style: TextStyle(
              fontSize: 12,
              color: isMe ? Colors.white70 : Colors.black87,
            ),
          ),
        ],
      );
    } else {
      return Text(
        msg.text ?? '',
        style: TextStyle(
          fontSize: 16,
          color: isMe ? Colors.white : Colors.black,
        ),
      );
    }
  }
}
