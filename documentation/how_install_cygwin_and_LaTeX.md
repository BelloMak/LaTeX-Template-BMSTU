# Базовая установка **Cygwin** и **LaTeX**

- [Базовая установка **Cygwin** и **LaTeX**](#базовая-установка-cygwin-и-latex)
  - [Назначение документа](#назначение-документа)
  - [Установка **Cygwin**](#установка-cygwin)
  - [Установка **MiK TeX**](#установка-mik-tex)
  - [Установка **TeX Live**](#установка-tex-live)


## Назначение документа

В настоящем файле написаны шаги, которые необходимо выполнить для установки
эмулятора терминала **Cygwin** на ПК под управлением ОС *Windows* и всех
компонентов, необходимых для работы с системой верстки *LaTeX*.

## Установка **Cygwin**

Для установки **Cygwin** необходимо следовать следующим пунктам:

1. Скачать установочный файл ([ссылка на скачивание для 64-битной версии Windows](https://www.cygwin.com/setup-x86_64.exe)) с официального
   [сайта](https://www.cygwin.com/install.html);
2. Установить основные компоненты **Cygwin**, для этого:
    - запустить скаченный ранее файл;
    - в окне *Choose A Download Source* удостовериться, что выбрано *Install
      from Internet*;
    - выбрать место установки, рекомендуется оставить выбор по умолчанию;
    - в окне *Select Local Package Directory* ничего не менять;
    - в окне *Select Your Internet Connection* удостовериться, что выбрано *Use 
    System Proxy Settings*;
    - в окне *Choose A Download Site* выбрать любую доступную ссылку;
    - в окне *Select Packages* в выпадающем списке *View* выбрать *Full*, в
      строке поиска набрать wget и установить последнюю версию этого пакета;
    - два раза нажать *Next* и дождаться завершения установки;
3. Установить дополнительные компоненты **Cygwin**, для этого:
    - открыть терминал **Cygwin**;
    - скопировать код, написанный ниже, и выполнить его в терминале (можно
      вставить весь блок сразу):
      ```
      # install apt-cyg
      wget rawgit.com/transcode-open/apt-cyg/master/apt-cyg
      install apt-cyg /bin
      
      # install main required packages
      apt-cyg install curl
      apt-cyg install git
      apt-cyg install grep
      apt-cyg install make
      apt-cyg install nano
      
      # install required packages for TeX Live
      apt-cyg install fontconfig
      apt-cyg install ghostscript
      apt-cyg install ncurses
      apt-cyg install libXaw7
      apt-cyg install perl
      ```
    - дождаться завершения установки
4. Доставить необходимые компоненты **Cygwin**, для этого ещё раз запустить
   установочный файл и быстро пройти все шаги еще раз (выбранные ранее пункты
   должны были сохраниться). Ничего нового выбирать не требуется. В результате
   будут автоматически докачены компоненты, необходимые для работы установленных
   ранее пакетов.

## Установка **MiK TeX**

Для пользователей ОС **Windows** рекомендуется установка дистрибутива **MiK
TeX** в случае предполагаемой работы с сетевыми расположениями. Официальный
[сайт](https://miktex.org) **MiK TeX**.

Для установки требуется скачать установщик с официального сайта и пройти
стандартную процедуру установки. 

После установки необходимо добавить **MiK TeX** в *PATH* **Cygwin** с помощью
команды 
```
export PATH=$PATH:"/cygdrive/some/path/MiKTeX/miktex/bin/x64/"
```
либо, если у вас установлен **fish** (что крайне рекомендуется, инструкция по
его установке находится в файле [how_upgrade_cygwin.md](how_upgrade_cygwin.md)),
командой 
```
fish_add_path /cygdrive/some/path/MiKTeX/miktex/bin/x64/
```

## Установка **TeX Live**

Альтернативная опция - установка **TeX Live**. Официальный
[сайт](https://www.tug.org/texlive/) **TeX Live**, на котором 
подробно описаны все возможности по его установке и настройке.

Будем придерживаться стандартной процедуры быстрой установки **TeX Live**,
которая состоит из следующих пунктов:
1. Скачать установщик **TeX Live**: 
    ```
    cd /tmp
    wget https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
    zcat < install-tl-unx.tar.gz | tar xf -
    rm install-tl-unx.tar.gz
    cd install-tl-*
    ```
2.  Запустить скачивание **TeX Live** (После выполнения команды начнется
    скачивание пакетов  **TeX Live**, которое может занять более 3-х часов)
    ```
    perl ./install-tl --no-interaction
    ```
3. Выполнить команды
    ```
    cd ~
    rm -r /tmp/install-tl-*
    ```
4. Выполнить команду
    ```
    fish_add_path /usr/local/texlive/20??/bin/x86_64-cygwin/
    ```
    если установлен **fish** (что крайне рекомендуется, инструкция по
    его установке находится в файле
    [how_upgrade_cygwin.md](how_upgrade_cygwin.md)), или команду 
    ```
    export PATH=$PATH: /usr/local/texlive/20??/bin/x86_64-cygwin/
    ```
    в ином случае для добавления **TeX Live** в *PATH* **Cygwin**.

> Если вы не использовали путь по умолчанию, то надо указать актуальное
> расположение установленного **TeX Live**.

> Если у вас до этого уже был установлен **TeX Live** другой версии, то
> необходимо заменить знаки вопроса в последней команде на год издания
> установленного в предыдущем пункте дистрибутива **TeX Live**.

На этом установка основных компонентов, необходимых для работы с **LaTeX** с
использованием **TeX Live**, завершена. 