---
title: "Agent based economics z użyciem R i NetLogo. Przykład Zero Intelligence Trading."
author: "Karol Ciulkin"
date: "28 czerwca 2016"
output: html_document
---

Niniejszy dokument stanowi przykład analizy modelu wieloagentowego. Aby samodzielnie wygenerować taki plik konieczne jest zainstalowanie NetLogo (najlepiej w wersji 5.3.1) oraz następujących pakietów: `RNetLogo`, `ggplot2` oraz `data.table`.


```r
library(RNetLogo)
library(ggplot2)
library(data.table)
```

Pierwszy z pakietów służy do komunikacji pomiędzy R a NetLogo. Używa przy tym Javy i pakietu `rJava`. Aktualność tychże zostanie prawdopodobnie zweryfikowana przy instalacji powyższego pakietu, ale warto o tym pamiętać.
Na początku należy wczytać do środowiska pracy wspomniane pakiety:

Użyty w niniejszym raporcie model pochodzi z `https://github.com/memcbride/ZITrading`. Jest to klasyczny model Gode i Sunder (1993) napisany w języku NetLogo. Zmodyfikowano jedynie ograniczenia co do wielkości parametrów modelu (podniesione maksymalne dopuszczalne liczby agentów).

## Opis modelu
Celem Gode i Sunder (1993) była weryfikacja hipotezy, że do efektywnego działania rynków konieczne jest klasyczne dla nauk ekonomicznych założenie racjonalności podmiotów działających na rynku. W tym celu napisali oni model symulacyjny, w którym dwa rodzaje agentów (sprzedający i kupujący) handlują na rynku, na którym ceny są ustalane z użyciem mechanizmu podwójnej aukcji (ang. *double action*).
Następnie przeprowadzili eksperymenty obliczeniowe (*computational experiments*) oraz eksperyment ekonomiczny, w którym brali udział studenci.

W pierwszym eksperymencie w rynkach uczestniczyli agenci "głupi" (*zero intelligence*), którzy zgłaszali losowe ceny. Rynki takie nie osiągały wysokiej efektywności.

W drugim na rynku działali agenci o ograniczonej racjonalności. W ich przypadku cena, którą mieli zgłosić (generowanaz użyciem procesu losowego) była przez nich zgłaszana zgłaszana tylko jeśli spełniała ich ograniczenie budżetowe.

Autorom udało się udowodnić, że do osiągnięcia satysfakcjonującej efektywności wystarczy jedynie ograniczona racjonalność agentów działających na rynku. Wyniki osiągane przez takich agentów były porównywalne z tymi, które osiągali uczestniczący w eksperymentach studenci.

## Sesja NetLogo

W kolejnym kroku inicjalizuje się sesję NetLogo. Aby poniższy kod działał prawidłowo, zmienna`path` powinna wskazywać ścieżkę do folderu zawierającego plik wykonywalny NetLogo. Zmienna `modelPath` opisuje z kolei ścieżkę względną z tego miejsca do modelu (od folderu zawierającego plik wykonywalny NetLogo).



```r
oldPath <- getwd()
NLStart(nl.path = path, gui = F) # uwaga, ta funkcja zmiennia katalog roboczy
setwd(oldPath)
```

### W tym momecnie inicjalizowane są funkcje, w które opakowano te dostępne w pakiecie  RNetLogo. Dla przejrzystości dokumentu ich kod został umieszczony na końcu dokumentu.



Wynikiem symulacji (2000 iteracji) z użyciem pakietu mogą być różne zestawy zmiennych. Na przykład efektywność:


```r
df <- parametrizeAndRun(constReport = T)
```

```
## [1] "Java-Object{Nothing named CONSTRAINED has been defined at position 37 in }"
```

```
## Error in NLCommand(paste0("set constrained ", constr)):
```

```r
ggplot(df) + geom_line(mapping = aes(x = ticks, y = efficiency))
```

```
## Error: ggplot2 doesn't know how to deal with data of class function
```

You can also embed plots, for example:

![plot of chunk unnamed-chunk-6](figure/unnamed-chunk-6-1.png)

Note that the `echo = FALSE` parameter was added to the code chunk to prevent printing of the R code that generated the plot.

## Bibliografia
(@) Gode, D. K., & Sunder, S. (1993). Allocative efficiency of markets with zero-intelligence traders: Market as a partial substitute for individual rationality. Journal of political economy, 119-137.
(@) Thiele, J. C. (2014). R marries NetLogo: introduction to the RNetLogo package.
(@) https://github.com/memcbride/ZITrading
