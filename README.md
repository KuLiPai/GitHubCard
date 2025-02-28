
[中文](README_zh.md)

# GithubCard

A Flutter app to generate beautiful GitHub cards for your profile.

## 🌟 Features

* Supports **Windows** (fullscreen) and **Web** (fullscreen).
* Automatically **scrapes** GitHub profiles for display.
* Provides a **gallery** of generated cards.

## Gallery 🖼️

A picture is worth a thousand words:

​![7a16f473c383cbcd1795d735b9979c82](assets/7a16f473c383cbcd1795d735b9979c82-20250228131755-2rd8xo3.png)​![屏幕截图 2025-02-28 130451](assets/11-20250228133121-q86fld2.png)​![3bc51480d52c41fa44a747c529a24f01](assets/3bc51480d52c41fa44a747c529a24f01-20250228131800-4kc7gen.png)​

## ⚠️ Known Issues

* **CORS Issue on Web**: The web version requires users to handle CORS manually.
* **Some profiles may not be parsed correctly**.

## 

## 🛠️ Installation & Usage

1. **Clone the repository:**   

    ```shell
    git clone https://github.com/yourusername/GithubCard.git
    cd GithubCard
    ```

2. **Install dependencies:**

    ```sh
    flutter pub get
    ```
3. **Run the app:**

    * **Windows:**

      ```sh
      flutter run -d windows
      ```
    * **Web:**

      ```sh
      flutter run -d chrome
      ```

      (Ensure you have set up CORS properly)

## 📜 License

[MIT License](https://chatgpt.com/c/LICENSE)
