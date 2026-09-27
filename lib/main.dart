import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(const MyApp());
}

// Помощник для вызова Toast-уведомлений
void showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.indigo.shade800,
    textColor: Colors.white,
    fontSize: 14.0,
  );
}

// общее оформление приложения (themedata)
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter UI Lab 3',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          primary: Colors.indigo,
          secondary: Colors.amber,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
        ),
        cardTheme: CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
        ),
      ),
      home: const MainHomeScreen(),
    );
  }
}

// drawer
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text(
              'Улпан Нургалиева',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: Text('ulpan@gmail.com'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.indigo),
            ),
            decoration: BoxDecoration(color: Colors.indigo),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Главная'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MainHomeScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Профиль'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.style),
            title: const Text('Карточки товаров'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CardsScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Настройки'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.red),
            title: const Text('Выход', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              showToast('Выход из аккаунта');
            },
          ),
        ],
      ),
    );
  }
}

// Главный экран с вкладками
class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  // Список товаров для ListView
  final List<Map<String, String>> _products = List.generate(
    10,
    (index) => {
      'title': 'Товар №${index + 1}',
      'subtitle': 'Описание товара №${index + 1}',
    },
  );

  // Состояние цветов для GridView 
  final List<bool> _gridItemStates = List.generate(6, (_) => false);

  // Дополнительное задание
  void _addNewProductDialog() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Добавить новый товар'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Название товара'),
              ),
              TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'Описание'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  setState(() {
                    _products.add({
                      'title': titleController.text,
                      'subtitle': descController.text.isNotEmpty
                          ? descController.text
                          : 'Новое описание',
                    });
                  });
                  showToast('Добавлен: ${titleController.text}');
                  Navigator.pop(context);
                }
              },
              child: const Text('Добавить'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Мое приложение'),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.amber,
            tabs: [
              Tab(icon: Icon(Icons.list), text: 'Список'),
              Tab(icon: Icon(Icons.grid_on), text: 'Сетка'),
            ],
          ),
        ),
        drawer: const AppDrawer(),
        body: TabBarView(
          children: [
            // Вкладка 1: ListView 
            ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final item = _products[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.indigo.shade100,
                      child: Icon(Icons.shopping_bag, color: Colors.indigo.shade700),
                    ),
                    title: Text(item['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(item['subtitle']!),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Toast при клике 
                      showToast('Вы выбрали: ${item['title']}');
                    },
                  ),
                );
              },
            ),

            // Вкладка 2: GridView 
            GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                final isClicked = _gridItemStates[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      // Изменение цвета при нажатии (StatefulWidget)
                      _gridItemStates[index] = !_gridItemStates[index];
                    });
                    showToast('Элемент сетки №${index + 1}');
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: isClicked ? Colors.green : Colors.blue,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        // FloatingActionButton для добавления элементов (Дополнительное задание ⭐)
        floatingActionButton: FloatingActionButton(
          onPressed: _addNewProductDialog,
          tooltip: 'Добавить элемент',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

//  (Card)

class CardsScreen extends StatelessWidget {
  const CardsScreen({super.key});

  final List<Map<String, String>> items = const [
    {
      'title': 'Смартфон',
      'desc': 'Флагманский смартфон с отличной камерой и мощным процессором.',
      'detail': 'Экран 120 Гц, 12 ГБ ОЗУ, АКБ 5000 мАч, камера 108 Мп.',
      'icon': 'phone_android'
    },
    {
      'title': 'Ноутбук',
      'desc': 'Ультрабук для работы, программирования и учебы.',
      'detail': 'Процессор Intel Core i7, 16 ГБ ОЗУ, SSD 1 ТБ, весит всего 1.2 кг.',
      'icon': 'laptop'
    },
    {
      'title': 'Беспроводные наушники',
      'desc': 'Чистый звук и активное шумоподавление.',
      'detail': 'До 30 часов работы с кейсом, Bluetooth 5.3, водозащита IPX4.',
      'icon': 'headphones'
    },
    {
      'title': 'Умные часы',
      'desc': 'Отслеживание активности, пульса и сна.',
      'detail': 'AMOLED экран, GPS, датчик кислорода в крови, 14 дней автономности.',
      'icon': 'watch'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Карточки товаров')),
      drawer: const AppDrawer(),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Имитация изображения карточки
                Container(
                  height: 140,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade100,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Center(
                    child: Icon(
                      index == 0
                          ? Icons.phone_android
                          : index == 1
                              ? Icons.laptop
                              : index == 2
                                  ? Icons.headphones
                                  : Icons.watch,
                      size: 64,
                      color: Colors.indigo,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title']!,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(item['desc']!),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {
                            // Переход на экран деталей
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailScreen(item: item),
                              ),
                            );
                          },
                          child: const Text('Подробнее'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Экран детальной информации карточки (Задание 4)
class DetailScreen extends StatelessWidget {
  final Map<String, String> item;

  const DetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item['title']!)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.devices, size: 100, color: Colors.indigo),
            ),
            const SizedBox(height: 20),
            Text(
              item['title']!,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'Описание:',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(item['desc']!, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Text(
              'Характеристики:',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(item['detail']!, style: const TextStyle(fontSize: 16, color: Colors.black87)),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  showToast('Товар добавлен в корзину');
                },
                icon: const Icon(Icons.shopping_cart),
                label: const Text('Купить'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// ЭКРАН ПРОФИЛЯ (Задание 5)
// ==========================================
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      drawer: const AppDrawer(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 60,
                backgroundColor: Colors.indigo,
                child: Icon(Icons.person, size: 80, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Text(
                'Улпан Нургалиева',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              const Text(
                'ulpan@gmail.com',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => showToast('Профиль обновлен'),
                icon: const Icon(Icons.edit),
                label: const Text('Редактировать профиль'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// ЭКРАН НАСТРОЕК (Задание 5 & 6)
// ==========================================
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkMode = false;
  double _volume = 50.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      drawer: const AppDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Задание 6: Кнопка «Показать приветствие»
          Card(
            color: Colors.amber.shade50,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  const Text(
                    'Тест Toast-уведомления (Задание 6):',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      showToast('Hello, Flutter!');
                    },
                    child: const Text('Показать приветствие'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Элементы управления (Задание 5: Switch, Slider)
          SwitchListTile(
            title: const Text('Включить уведомления'),
            value: _notificationsEnabled,
            onChanged: (val) {
              setState(() => _notificationsEnabled = val);
              showToast(val ? 'Уведомления включены' : 'Уведомления отключены');
            },
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Тёмная тема'),
            value: _darkMode,
            onChanged: (val) {
              setState(() => _darkMode = val);
              showToast('Настройки сохранены');
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Громкость уведомлений'),
            subtitle: Slider(
              value: _volume,
              min: 0,
              max: 100,
              divisions: 10,
              label: '${_volume.round()}%',
              onChanged: (double value) {
                setState(() => _volume = value);
              },
            ),
          ),
        ],
      ),
    );
  }
}