\NeedsTeXFormat{LaTeX2e}

\ProvidesClass{my-latex-class}[2024/09/26 v0.0.1 LaTeX GOST class for xetex]

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{extreport}}
\ProcessOptions\relax

% Установка базового класса
\LoadClass[a4paper,oneside,14pt]{extreport}

% Настройка кодировки и языков
\RequirePackage[T1,T2A]{fontenc}
\RequirePackage[utf8]{inputenc}
\RequirePackage[english,russian]{babel}
\RequirePackage{fix-cm}

% Установка шрифта
\usepackage{fontspec}
\setmainfont{Times New Roman}
\setsansfont{Arial}
\setmonofont{Consolas}

% Настройка полей
\RequirePackage[
	left=30mm,
	right=15mm,
	top=20mm,
	bottom=20mm,
]{geometry}

% Выравнивание по ширине
\RequirePackage{ragged2e}
\justifying 

% Настройка переносов
% \RequirePackage{microtype}
\sloppy

% Настройка межстрочного интервала
\RequirePackage{setspace}
\onehalfspacing

% Настройка абзацного отступа
\RequirePackage{indentfirst}
\setlength{\parindent}{12.5mm}

% Настройка заголовков
\makeatletter
\renewcommand\LARGE{\@setfontsize\LARGE{20pt}{18}}
\renewcommand\Large{\@setfontsize\Large{18pt}{18}}
\renewcommand\large{\@setfontsize\large{16pt}{18}}
\renewcommand\small{\@setfontsize\small{12pt}{18}}
\renewcommand\footnotesize{\@setfontsize\footnotesize{10pt}{18}}
\makeatother
\RequirePackage{titlesec}
% Размер и выравнивание заголовков 
\titleformat{\chapter}[block]{\hspace{\parindent}\bfseries\large}{\thechapter}{0.5em}{\large\bfseries\raggedright}
\titleformat{name=\chapter,numberless}[block]{\hspace{\parindent}}{}{0pt}{\large\bfseries\raggedright}
\titleformat{\section}[block]{\hspace{\parindent}\bfseries\large}{\thesection}{0.5em}{\large\bfseries\raggedright}
\titleformat{\subsection}[block]{\hspace{\parindent}\bfseries\large}{\thesubsection}{0.5em}{\large\bfseries\raggedright}
\titleformat{\subsubsection}[block]{\hspace{\parindent}\bfseries\large}{\thesubsection}{0.5em}{\large\bfseries\raggedright}
% Отступы у заголовков
\titlespacing{\chapter}{12.5mm}{-22pt}{12pt}
\titlespacing{\section}{12.5mm}{12pt}{12pt}
\titlespacing{\subsection}{12.5mm}{12pt}{12pt}
\titlespacing{\subsubsection}{12.5mm}{12pt}{12pt}

% Начинать subsection с новой страницы
%\newcommand{\sectionbreak}{\ifnum\value{section}>0 \clearpage\fi}

% Подключение пакетов для альбомной ориентации
\RequirePackage{lscape}
\RequirePackage{afterpage}

% Подключение математических пакетов
\RequirePackage{amsmath}
\RequirePackage{amssymb}
\RequirePackage{icomma}
\RequirePackage{mathtools}
\allowdisplaybreaks

% Сквозная нумерация формул
\RequirePackage{chngcntr}
\counterwithout{equation}{chapter}

% Подключение пакета гиперссылок
\RequirePackage[unicode,hidelinks,final]{hyperref}

% Подключение пакета многострочных комментариев
\RequirePackage{comment}

% Кликабельные интернет-ссылки
\RequirePackage{url}

% Колонки в тексте
\RequirePackage{multicol}

% Вставка страниц из PDF документов
\usepackage{pdfpages}

% Вотермарка Черновик
\RequirePackage[
	color={[gray]{0.85}}, 
	fontsize=32pt, 
	scale=5, 
	text=Черновик, 
	angle=60,
	stamp=false
]{draftwatermark}

% Включение вотермарки при параметрах класса draft или build
\newcommand{\checkclassopts}[1]{
	\ifthenelse{\equal{#1}{draft}}{\DraftwatermarkOptions{stamp=true}}{}
	\ifthenelse{\equal{#1}{build}}{\DraftwatermarkOptions{stamp=true}}{}
	\ifthenelse{\equal{#1}{monochrome}}{\RequirePackage[monochrome]{xcolor}}{\RequirePackage{xcolor}}
}

% Вставка кода в преамбулу
\AtBeginDocument{
	\checkclassopts{\classopts}
}

% Отступы в списках
\RequirePackage{enumitem}
\setlist[itemize]{labelsep=0.3cm,labelwidth=0.3cm,itemindent=0.6cm,leftmargin=1.25cm}
\setlist[enumerate]{labelsep=0.3cm,labelwidth=0.3cm,itemindent=0.6cm,leftmargin=1.25cm}
\setlist{topsep=0.4em,itemsep=0pt,parsep=0pt,partopsep=0pt}

% Дерево директории
\RequirePackage{dirtree}

% Подключение созданных пакетов
\RequirePackage{./my_latex_class/my-bibliography}
\RequirePackage{./my_latex_class/my-essay}
\RequirePackage{./my_latex_class/my-abbreviations}
\RequirePackage{./my_latex_class/my-toc}
\RequirePackage{./my_latex_class/my-figures-tables}
\RequirePackage{./my_latex_class/my-bmstu-titlepage}
\RequirePackage{./my_latex_class/my-listing}
\RequirePackage{./my_latex_class/my-appendix}