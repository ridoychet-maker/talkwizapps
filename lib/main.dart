import 'package:flutter/material.dart';

void main() {
  runApp(const TalkWizAppsApp());
}

const green = Color(0xFF008751);
const lightGreen = Color(0xFFF0F4F1);

class TalkWizAppsApp extends StatelessWidget {
  const TalkWizAppsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TalkWizApps',
      theme: ThemeData(
        primaryColor: green,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: green),
        appBarTheme: const AppBarTheme(
          backgroundColor: green,
          foregroundColor: Colors.white,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class ChatContact {
  final String name;
  final String message;
  final String time;
  final Color color;

  const ChatContact(
    this.name,
    this.message,
    this.time,
    this.color,
  );
}

const contacts = <ChatContact>[
  ChatContact('Ahon Rikay', 'Hey! How are you?', '9:12 AM', Colors.orange),
  ChatContact('Ratul Hasan', 'Okay bro 👍', 'Yesterday', Colors.blue),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  String selectedFilter = 'All';

  final titles = const [
    'TalkWizApps',
    'Updates',
    'Communities',
    'Calls',
  ];

  void openChat(ChatContact contact) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatScreen(contact: contact),
      ),
    );
  }

  void openSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SearchScreen(),
      ),
    );
  }

  void openPage(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  void showMenu(String value) {
    switch (value) {
      case 'Profile':
        openPage(const InfoScreen(
          title: 'Profile',
          message: 'Your profile will appear here.',
          icon: Icons.person,
        ));
        break;
      case 'Settings':
        openPage(const InfoScreen(
          title: 'Settings',
          message: 'App settings will appear here.',
          icon: Icons.settings,
        ));
        break;
      case 'New group':
        openPage(const InfoScreen(
          title: 'New group',
          message: 'Group creation will be added later.',
          icon: Icons.group_add,
        ));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          titles[currentIndex],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Search',
            icon: const Icon(Icons.search),
            onPressed: openSearch,
          ),
          PopupMenuButton<String>(
            onSelected: showMenu,
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'New group',
                child: Text('New group'),
              ),
              PopupMenuItem(
                value: 'Profile',
                child: Text('Profile'),
              ),
              PopupMenuItem(
                value: 'Settings',
                child: Text('Settings'),
              ),
            ],
          ),
        ],
      ),
      body: IndexedStack(
        index: currentIndex,
        children: [
          buildChats(),
          const UpdatesScreen(),
          const CommunitiesScreen(),
          const CallsScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: green,
        unselectedItemColor: Colors.grey,
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() => currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.update),
            label: 'Updates',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups),
            label: 'Communities',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.call),
            label: 'Calls',
          ),
        ],
      ),
    );
  }

  Widget buildChats() {
    final visibleContacts = contacts.where((contact) {
      if (selectedFilter == 'Favourites ⭐️') {
        return contact.name == 'Ahon Rikay';
      }
      if (selectedFilter == 'Groups 👥') {
        return false;
      }
      return true;
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: openSearch,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                color: lightGreen,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Row(
                children: [
                  Icon(Icons.search, color: Colors.grey),
                  SizedBox(width: 10),
                  Text(
                    'Ask Meta AI or Search',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              buildFilter('All'),
              buildFilter('Favourites ⭐️'),
              buildFilter('Groups 👥'),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: visibleContacts.isEmpty
              ? const Center(child: Text('No groups yet'))
              : ListView.builder(
                  itemCount: visibleContacts.length,
                  itemBuilder: (_, index) {
                    final contact = visibleContacts[index];
                    return ListTile(
                      onTap: () => openChat(contact),
                      leading: CircleAvatar(
                        backgroundColor: contact.color,
                        child: Text(
                          contact.name.substring(0, 1).toUpperCase(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        contact.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(contact.message),
                      trailing: Text(
                        contact.time,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget buildFilter(String label) {
    final selected = selectedFilter == label;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        selectedColor: green,
        backgroundColor: lightGreen,
        labelStyle: TextStyle(
          color: selected ? Colors.white : Colors.black87,
        ),
        onSelected: (_) {
          setState(() => selectedFilter = label);
        },
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final ChatContact contact;

  const ChatScreen({super.key, required this.contact});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final controller = TextEditingController();
  final messages = <String>[];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void sendMessage() {
    final text = controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add(text);
      controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: widget.contact.color,
              child: Text(
                widget.contact.name.substring(0, 1),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.contact.name,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Audio call',
            onPressed: () => showInfo(context, 'Audio call'),
            icon: const Icon(Icons.call),
          ),
          IconButton(
            tooltip: 'Video call',
            onPressed: () => showInfo(context, 'Video call'),
            icon: const Icon(Icons.videocam),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty
                ? const Center(
                    child: Text(
                      'Your conversation starts here.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: messages.length,
                    itemBuilder: (_, index) => Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(12),
                        constraints: const BoxConstraints(maxWidth: 280),
                        decoration: BoxDecoration(
                          color: lightGreen,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(messages[index]),
                      ),
                    ),
                  ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      onSubmitted: (_) => sendMessage(),
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        filled: true,
                        fillColor: lightGreen,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: sendMessage,
                    style: IconButton.styleFrom(
                      backgroundColor: green,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = controller.text.toLowerCase();
    final results = contacts.where((contact) {
      return contact.name.toLowerCase().contains(query) ||
          contact.message.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: controller,
              autofocus: true,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search chats...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: lightGreen,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: results.map((contact) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: contact.color,
                    child: Text(contact.name.substring(0, 1)),
                  ),
                  title: Text(contact.name),
                  subtitle: Text(contact.message),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(contact: contact),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class UpdatesScreen extends StatelessWidget {
  const UpdatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Status updates',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ListTile(
          leading: const CircleAvatar(
            backgroundColor: green,
            child: Icon(Icons.add, color: Colors.white),
          ),
          title: const Text('My status'),
          subtitle: const Text('Share a status update'),
          onTap: () => showInfo(context, 'Status updates'),
        ),
        const Divider(),
        const ListTile(
          leading: CircleAvatar(child: Icon(Icons.person)),
          title: Text('No recent updates'),
          subtitle: Text('New updates will appear here.'),
        ),
      ],
    );
  }
}

class CommunitiesScreen extends StatelessWidget {
  const CommunitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.groups, size: 64, color: green),
            const SizedBox(height: 12),
            const Text(
              'Communities',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Bring groups together in one place.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => showInfo(context, 'New community'),
              icon: const Icon(Icons.add),
              label: const Text('New community'),
              style: FilledButton.styleFrom(backgroundColor: green),
            ),
          ],
        ),
      ),
    );
  }
}

class CallsScreen extends StatelessWidget {
  const CallsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const CircleAvatar(
            backgroundColor: lightGreen,
            child: Icon(Icons.call, color: green),
          ),
          title: const Text('No recent calls'),
          subtitle: const Text('Your call history will appear here.'),
          onTap: () => showInfo(context, 'Calls'),
        ),
      ],
    );
  }
}

class InfoScreen extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;

  const InfoScreen({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 64, color: green),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(message, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

void showInfo(BuildContext context, String feature) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        '$feature is a placeholder. Real functionality will be added later.',
      ),
    ),
  );
}