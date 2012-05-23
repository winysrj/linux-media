Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49865 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278Ab2EWJoA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 05:44:00 -0400
Received: by eaak11 with SMTP id k11so1952398eaa.19
        for <linux-media@vger.kernel.org>; Wed, 23 May 2012 02:43:58 -0700 (PDT)
Message-ID: <4FBCB15A.8060106@smidovi.eu>
Date: Wed, 23 May 2012 11:43:54 +0200
From: David Smid <david@smidovi.eu>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [PATCH dvb-apps] Update/addition of Czech DVB-T scan files
References: <4FBC9542.2060609@smidovi.eu>
In-Reply-To: <4FBC9542.2060609@smidovi.eu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dne 23.5.2012 09:44, David Smid napsal(a):
>
> This is an update of the outdated Czech initial scan files for DVB-T.
> In case of problems with non-english characters in this mail message, you can 
> also download this patch here:
> http://david.smidovi.eu/scan_data_dvb-t_cz.patch
> or here (scan files tarball):
> http://david.smidovi.eu/dvbtgen.tar.gz
>
> David Smid

Ignore this patch, please.
Use this one instead. The contents are more or less the same but I used a better 
file naming scheme.
As before,  in case of problems with non-english characters in this mail 
message, you can also download this patch here:
http://david.smidovi.eu/scan_data_dvb-t_cz.patch
or here (scan files tarball):
http://david.smidovi.eu/dvbtgen.tar.gz

I'm sorry for any inconvenience.

David Smid

---
# HG changeset patch
# User dsmid
# Date 1337765767 -7200
# Node ID 2bded15bc90c48bbbfd53ce1aae371586aa88d54
# Parent  4030c51d6e7baef760e65d4ff2e8f61af91bec02
update Czech scan files

diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz--Auto
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz--Auto    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,67 @@
+# Czech Republic, automatic scanning
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 177500000 8MHz AUTO NONE QAM64 8k AUTO NONE # Kanál 5
+T 184500000 8MHz AUTO NONE QAM64 8k AUTO NONE # Kanál 6
+T 191500000 8MHz AUTO NONE QAM64 8k AUTO NONE # Kanál 7
+T 198500000 8MHz AUTO NONE QAM64 8k AUTO NONE # Kanál 8
+T 205500000 8MHz AUTO NONE QAM64 8k AUTO NONE # Kanál 9
+T 212500000 8MHz AUTO NONE QAM64 8k AUTO NONE # Kanál 10
+T 219500000 8MHz AUTO NONE QAM64 8k AUTO NONE # Kanál 11
+T 226500000 8MHz AUTO NONE QAM64 8k AUTO NONE # Kanál 12
+T 474000000 8MHz AUTO NONE QAM64 8k AUTO NONE # Kanál 21
+T 482000000 8MHz AUTO NONE QAM64 8k AUTO NONE # Kanál 22
+T 490000000 8MHz AUTO NONE QAM64 8k AUTO NONE # Kanál 23
+T 498000000 8MHz AUTO NONE QAM64 8k AUTO NONE # Kanál 24
+T 506000000 8MHz AUTO NONE QAM64 8k AUTO NONE # Kanál 25
+T 514000000 8MHz AUTO NONE QAM64 8k AUTO NONE # Kanál 26
+T 522000000 8MHz AUTO NONE QAM64 8k AUTO NONE # Kanál 27
+T 530000000 8MHz AUTO NONE QAM64 8k AUTO NONE # Kanál 28
+T 538000000 8MHz AUTO NONE QAM64 8k AUTO NONE # Kanál 29
+T 546000000 8MHz AUTO NONE QAM64 8k AUTO NONE # Kanál 30
+T 554000000 8MHz AUTO NONE QAM64 8k AUTO NONE # Kanál 31
+T 562000000 8MHz AUTO NONE QAM64 8k AUTO NONE # Kanál 32
+T 570000000 8MHz AUTO NONE QAM64 8k AUTO NONE # Kanál 33
+T 578000000 8MHz AUTO NONE QAM64 8k AUTO NONE # Kanál 34
+T 586000000 8MHz AUTO NONE QAM64 8k AUTO NONE # Kanál 35
+T 594000000 8MHz AUTO NONE QAM64 8k AUTO NONE # Kanál 36
+T 602000000 8MHz AUTO NONE QAM64 8k AUTO NONE # Kanál 37
+T 610000000 8MHz AUTO NONE QAM64 8k AUTO NONE # Kanál 38
+T 618000000 8MHz AUTO NONE QAM64 8k AUTO NONE # Kanál 39
+T 626000000 8MHz AUTO NONE QAM64 8k AUTO NONE # Kanál 40
+T 634000000 8MHz AUTO NONE QAM64 8k AUTO NONE # Kanál 41
+T 642000000 8MHz AUTO NONE QAM64 8k AUTO NONE # Kanál 42
+T 650000000 8MHz AUTO NONE QAM64 8k AUTO NONE # Kanál 43
+T 658000000 8MHz AUTO NONE QAM64 8k AUTO NONE # Kanál 44
+T 666000000 8MHz AUTO NONE QAM64 8k AUTO NONE # Kanál 45
+T 674000000 8MHz AUTO NONE QAM64 8k AUTO NONE # Kanál 46
+T 682000000 8MHz AUTO NONE QAM64 8k AUTO NONE # Kanál 47
+T 690000000 8MHz AUTO NONE QAM64 8k AUTO NONE # Kanál 48
+T 698000000 8MHz AUTO NONE QAM64 8k AUTO NONE # Kanál 49
+T 706000000 8MHz AUTO NONE QAM64 8k AUTO NONE # Kanál 50
+T 714000000 8MHz AUTO NONE QAM64 8k AUTO NONE # Kanál 51
+T 722000000 8MHz AUTO NONE QAM64 8k AUTO NONE # Kanál 52
+T 730000000 8MHz AUTO NONE QAM64 8k AUTO NONE # Kanál 53
+T 738000000 8MHz AUTO NONE QAM64 8k AUTO NONE # Kanál 54
+T 746000000 8MHz AUTO NONE QAM64 8k AUTO NONE # Kanál 55
+T 754000000 8MHz AUTO NONE QAM64 8k AUTO NONE # Kanál 56
+T 762000000 8MHz AUTO NONE QAM64 8k AUTO NONE # Kanál 57
+T 770000000 8MHz AUTO NONE QAM64 8k AUTO NONE # Kanál 58
+T 778000000 8MHz AUTO NONE QAM64 8k AUTO NONE # Kanál 59
+T 786000000 8MHz AUTO NONE QAM64 8k AUTO NONE # Kanál 60
+T 794000000 8MHz AUTO NONE QAM64 8k AUTO NONE # Kanál 61
+T 802000000 8MHz AUTO NONE QAM64 8k AUTO NONE # Kanál 62
+T 810000000 8MHz AUTO NONE QAM64 8k AUTO NONE # Kanál 63
+T 818000000 8MHz AUTO NONE QAM64 8k AUTO NONE # Kanál 64
+T 826000000 8MHz AUTO NONE QAM64 8k AUTO NONE # Kanál 65
+T 834000000 8MHz AUTO NONE QAM64 8k AUTO NONE # Kanál 66
+T 842000000 8MHz AUTO NONE QAM64 8k AUTO NONE # Kanál 67
+T 850000000 8MHz AUTO NONE QAM64 8k AUTO NONE # Kanál 68
+T 858000000 8MHz AUTO NONE QAM64 8k AUTO NONE # Kanál 69
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz--Multiplex_1
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz--Multiplex_1    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,105 @@
+# Czech Republic, Multiplex 1 - Česká televize
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 538000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Barvičova (Brno), 
[16°34′47″,49°11′56″], kanál 29, výkon 10 kW
+#   ^-- MUX 1 - Česká televize, vysílač Hády (Brno), [16°40′28″,49°13′22″], 
kanál 29, výkon 10 kW
+#   ^-- MUX 1 - Česká televize, vysílač Kojál (Brno), [16°48′58″,49°22′12″], 
kanál 29, výkon 100 kW
+#   ^-- MUX 1 - Česká televize, vysílač Děvín (Mikulov), [16°39′01″,48°52′10″], 
kanál 29, výkon 25 kW
+#   ^-- MUX 1 - Česká televize, vysílač Praha (Příbram), [13°49′04″,49°39′30″], 
kanál 29, výkon 1 kW
+#   ^-- MUX 1 - Česká televize, vysílač Březové hory (Příbram), 
[13°59′49″,49°41′08″], kanál 29, výkon 10 W
+#   ^-- MUX 1 - Česká televize, vysílač Kamenná Horka (Svitavy), 
[16°34′10″,49°44′22″], kanál 29, výkon 100 W
+#   ^-- MUX 1 - Česká televize, vysílač ul. Zborovská (Náměšť nad Oslavou), 
[16°08′56″,49°12′11″], kanál 29, výkon 10 W
+#   ^-- MUX 1 - Česká televize, vysílač U Sivků (Huslenky), 
[18°05′48″,49°19′20″], kanál 29, výkon 25 W
+#   ^-- MUX 1 - Česká televize, vysílač Čížovky (Boskovice), 
[16°40′43″,49°29′17″], kanál 29, výkon 10 W
+#   ^-- MUX 1 - Česká televize, vysílač Strážnice (Jablonné nad Orlicí), 
[16°35′34″,50°01′59″], kanál 29, výkon 10 W
+T 562000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Krásné (Pardubice), 
[15°44′15″,49°49′21″], kanál 32, výkon 25 kW
+#   ^-- MUX 1 - Česká televize, vysílač Olešná (Blansko), 
[16°38′41″,49°20′24″], kanál 32, výkon 20 W
+#   ^-- MUX 1 - Česká televize, vysílač ul. Údolní (Havlíčkův Brod), 
[15°34′44″,49°35′49″], kanál 32, výkon 10 W
+T 570000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Buková hora (Ústí n./L.), 
[14°13′44″,50°40′19″], kanál 33, výkon 100 kW
+#   ^-- MUX 1 - Česká televize, vysílač Desná III (), [15°21′07″,50°45′47″], 
kanál 33, výkon 3 W
+#   ^-- MUX 1 - Česká televize, vysílač Jedlová hora (Chomutov), 
[13°27′43″,50°32′55″], kanál 33, výkon 32 kW
+#   ^-- MUX 1 - Česká televize, vysílač Javořice (Jihlava), 
[15°20′22″,49°14′17″], kanál 33, výkon 100 kW
+#   ^-- MUX 1 - Česká televize, vysílač Tlustá hora (Zlín), 
[17°38′47″,49°12′30″], kanál 33, výkon 100 kW
+#   ^-- MUX 1 - Česká televize, vysílač Ploštiny (Valašské Klobouky), 
[18°03′22″,49°08′20″], kanál 33, výkon 25 kW
+#   ^-- MUX 1 - Česká televize, vysílač Vaňov (Ústí nad Labem), 
[14°02′15″,50°38′41″], kanál 33, výkon 10 W
+#   ^-- MUX 1 - Česká televize, vysílač Popovický vrch (Děčín), 
[14°10′33″,50°46′11″], kanál 33, výkon 20 W
+#   ^-- MUX 1 - Česká televize, vysílač Ječný vrch (Velký Šenov), 
[14°19′26″,51°00′22″], kanál 33, výkon 20 W
+#   ^-- MUX 1 - Česká televize, vysílač vrch Pytlák (Šluknov), 
[14°30′34″,50°59′57″], kanál 33, výkon 20 W
+#   ^-- MUX 1 - Česká televize, vysílač Hřebenáč (Jindřichovice pod Smrkem), 
[15°14′26″,50°56′18″], kanál 33, výkon 10 W
+#   ^-- MUX 1 - Česká televize, vysílač Strážný vrch (Třebíč), 
[15°52′28″,49°12′36″], kanál 33, výkon 5 W
+#   ^-- MUX 1 - Česká televize, vysílač Humenec (Nový Hrozenkov), 
[18°12′42″,49°21′17″], kanál 33, výkon 25 W
+#   ^-- MUX 1 - Česká televize, vysílač Branka (Luhačovice), 
[17°45′18″,49°05′50″], kanál 33, výkon 46 W
+#   ^-- MUX 1 - Česká televize, vysílač Rokštejnská (Brtnice), 
[15°41′07″,49°18′14″], kanál 33, výkon 10 W
+T 578000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Krašov (Plzeň), [13°04′46″,49°59′45″], 
kanál 34, výkon 100 kW
+#   ^-- MUX 1 - Česká televize, vysílač Vraní vrch (Domažlice), 
[12°46′41″,49°28′21″], kanál 34, výkon 10 kW
+#   ^-- MUX 1 - Česká televize, vysílač Vranovský vrch (Nemanice), 
[12°43′49″,49°28′18″], kanál 34, výkon 10 W
+#   ^-- MUX 1 - Česká televize, vysílač Suchý kámen (Nýrsko), 
[13°07′50″,49°16′36″], kanál 34, výkon 10 W
+#   ^-- MUX 1 - Česká televize, vysílač Rozvodí (Železná Ruda), 
[13°11′52″,49°10′28″], kanál 34, výkon 10 W
+#   ^-- MUX 1 - Česká televize, vysílač Fajtův vrch (Velké Meziříčí), 
[16°01′27″,49°21′34″], kanál 34, výkon 10 W
+#   ^-- MUX 1 - Česká televize, vysílač ul. Okružní (Rakovník), 
[13°43′55″,50°05′43″], kanál 34, výkon 10 W
+T 594000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Zelená hora (Cheb), 
[12°18′29″,50°04′10″], kanál 36, výkon 20 kW
+#   ^-- MUX 1 - Česká televize, vysílač Háj (Aš), [12°12′04″,50°14′01″], kanál 
36, výkon 50 W
+#   ^-- MUX 1 - Česká televize, vysílač Klínovec (Jáchymov), 
[12°58′04″,50°23′49″], kanál 36, výkon 50 kW
+#   ^-- MUX 1 - Česká televize, vysílač Monty (Mariánské Lázně), 
[12°41′58″,49°58′06″], kanál 36, výkon 10 W
+#   ^-- MUX 1 - Česká televize, vysílač pod hřbitovem (Rotava), 
[12°34′09″,50°17′49″], kanál 36, výkon 5 W
+#   ^-- MUX 1 - Česká televize, vysílač Sněžná (Kraslice), 
[12°30′20″,50°18′41″], kanál 36, výkon 10 W
+#   ^-- MUX 1 - Česká televize, vysílač Tři kříže (Karlovy Vary), 
[12°53′12″,50°13′39″], kanál 36, výkon 25 W
+#   ^-- MUX 1 - Česká televize, vysílač Praděd (Jeseník), 
[17°13′52″,50°04′59″], kanál 36, výkon 100 kW
+#   ^-- MUX 1 - Česká televize, vysílač Biskupská kupa (Zlaté Hory), 
[17°25′45″,50°15′14″], kanál 36, výkon 20 W
+#   ^-- MUX 1 - Česká televize, vysílač Na Rozárce (Žamberk), 
[16°27′25″,50°05′16″], kanál 36, výkon 16 W
+#   ^-- MUX 1 - Česká televize, vysílač Jírová hora (Hronov), 
[16°10′32″,50°29′14″], kanál 36, výkon 10 W
+#   ^-- MUX 1 - Česká televize, vysílač Zlatý Chlum (Jeseník), 
[17°14′15″,50°14′17″], kanál 36, výkon 100 W
+T 626000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Černá hora (Trutnov), 
[15°44′30″,50°39′09″], kanál 40, výkon 100 kW
+#   ^-- MUX 1 - Česká televize, vysílač u nádraží (Horní Lipová), 
[17°04′58″,50°13′33″], kanál 40, výkon ?
+#   ^-- MUX 1 - Česká televize, vysílač Hvězda (Broumov), 
[16°15′57″,50°34′04″], kanál 40, výkon 25 W
+T 650000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Ještěd (Liberec), 
[14°59′05″,50°43′58″], kanál 43, výkon 50 kW
+#   ^-- MUX 1 - Česká televize, vysílač U rozhledny (Frýdlant v Čechách), 
[15°04′34″,50°56′07″], kanál 43, výkon 25 W
+#   ^-- MUX 1 - Česká televize, vysílač Dubina (Strání), [17°40′56″,48°54′54″], 
kanál 43, výkon 25 W
+#   ^-- MUX 1 - Česká televize, vysílač Suchý vrch (Králíky), 
[16°41′21″,50°03′07″], kanál 43, výkon 50 W
+#   ^-- MUX 1 - Česká televize, vysílač Pálenisko (Jablůnka), 
[17°58′27″,49°24′09″], kanál 43, výkon 5 W
+T 698000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Kleť (České Budějovice), 
[14°16′53″,48°52′03″], kanál 49, výkon 100 kW
+#   ^-- MUX 1 - Česká televize, vysílač Svatobor (Sušice), 
[13°29′23″,49°14′06″], kanál 49, výkon 100 kW
+#   ^-- MUX 1 - Česká televize, vysílač Mařský vrch (Vimperk), 
[13°50′49″,49°04′20″], kanál 49, výkon 20 kW
+#   ^-- MUX 1 - Česká televize, vysílač Horní Sněžná (Volary), 
[13°56′06″,48°53′13″], kanál 49, výkon 20 W
+#   ^-- MUX 1 - Česká televize, vysílač Krásná pole (Loučovice), 
[14°14′18″,48°36′17″], kanál 49, výkon 10 W
+#   ^-- MUX 1 - Česká televize, vysílač Novotných vršek (Zdíkov), 
[13°41′23″,49°05′11″], kanál 49, výkon 10 W
+#   ^-- MUX 1 - Česká televize, vysílač Semenec (Týn nad Vltavou), 
[14°24′38″,49°14′00″], kanál 49, výkon 10 W
+#   ^-- MUX 1 - Česká televize, vysílač Šeptouchov (Ledeč nad Sázavou), 
[15°16′06″,49°41′43″], kanál 49, výkon 13 W
+#   ^-- MUX 1 - Česká televize, vysílač Harusův kopec (Žďár nad Sázavou), 
[16°02′39″,49°34′21″], kanál 49, výkon 100 W
+T 730000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Cukrák (Praha), [14°21′21″,49°56′12″], 
kanál 53, výkon 100 kW
+#   ^-- MUX 1 - Česká televize, vysílač Žižkov (Praha), [14°27′04″,50°04′52″], 
kanál 53, výkon 32 kW
+#   ^-- MUX 1 - Česká televize, vysílač Mezivrata (Votice), 
[14°40′16″,49°36′10″], kanál 53, výkon 32 kW
+#   ^-- MUX 1 - Česká televize, vysílač nad hřbitovem (Jince), 
[13°58′18″,49°46′58″], kanál 53, výkon 10 W
+#   ^-- MUX 1 - Česká televize, vysílač Na Vrážích (Husinec), 
[13°58′36″,49°03′21″], kanál 53, výkon 10 W
+#   ^-- MUX 1 - Česká televize, vysílač Komorní Hrádek (Chocerady), 
[14°47′53″,49°52′06″], kanál 53, výkon 5 W
+#   ^-- MUX 1 - Česká televize, vysílač Na Vlkaňáku (Sázava), 
[14°53′31″,49°52′56″], kanál 53, výkon 10 W
+#   ^-- MUX 1 - Česká televize, vysílač Vyhlídka (Náchod), 
[16°10′41″,50°24′17″], kanál 53, výkon ?
+#   ^-- MUX 1 - Česká televize, vysílač Větruše (Ústí nad Labem), 
[14°02′23″,50°39′18″], kanál 53, výkon 10 W
+T 738000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Hladnov (Ostrava), 
[18°18′19″,49°50′51″], kanál 54, výkon 10 kW
+#   ^-- MUX 1 - Česká televize, vysílač Hošťálkovice (Ostrava), 
[18°12′45″,49°51′41″], kanál 54, výkon 14 kW
+#   ^-- MUX 1 - Česká televize, vysílač Lysá hora (Frýdek-Místek), 
[18°26′56″,49°32′47″], kanál 54, výkon 25 kW
+#   ^-- MUX 1 - Česká televize, vysílač Radhošť (Valašské Meziřičí), 
[18°13′20″,49°29′31″], kanál 54, výkon 100 W
+#   ^-- MUX 1 - Česká televize, vysílač Bečevná (Vsetín), 
[17°59′32″,49°19′45″], kanál 54, výkon 20 W
+#   ^-- MUX 1 - Česká televize, vysílač Na Kyčerce (Velké Karlovice), 
[18°17′09″,49°21′05″], kanál 54, výkon 25 W
+#   ^-- MUX 1 - Česká televize, vysílač nad ZD (Letohrad), 
[16°31′32″,50°01′56″], kanál 54, výkon 10 W
+#   ^-- MUX 1 - Česká televize, vysílač Dolní Dobrouč (), 
[16°30′03″,49°59′42″], kanál 54, výkon 22 W
+#   ^-- MUX 1 - Česká televize, vysílač Vadín (Okrouhlice), 
[15°29′15″,49°38′15″], kanál 54, výkon 100 W
+#   ^-- MUX 1 - Česká televize, vysílač Gagarinova (Hlubočky), 
[17°24′00″,49°37′26″], kanál 54, výkon 22 W
+#   ^-- MUX 1 - Česká televize, vysílač Kubincův kopec (Ústí nad Orlicí), 
[16°22′40″,49°58′32″], kanál 54, výkon 10 W
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz--Multiplex_2
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz--Multiplex_2    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,96 @@
+# Czech Republic, Multiplex 2 - České Radiokomunikace
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 586000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Tři kříže (Karlovy Vary), 
[12°53′12″,50°13′39″], kanál 35, výkon 25 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Háj (Aš), [12°12′04″,50°14′01″], 
kanál 35, výkon 50 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Monty (Mariánské Lázně), 
[12°41′58″,49°58′06″], kanál 35, výkon 10 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Sněžná (Kraslice), 
[12°30′20″,50°18′41″], kanál 35, výkon 10 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač pod hřbitovem (Rotava), 
[12°34′09″,50°17′49″], kanál 35, výkon 5 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Javořice (Jihlava), 
[15°20′22″,49°14′17″], kanál 35, výkon 100 kW
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Strážný vrch (Třebíč), 
[15°52′28″,49°12′36″], kanál 35, výkon 5 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač nad ZD (Letohrad), 
[16°31′32″,50°01′56″], kanál 35, výkon 10 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Na Vyhlídce (Náchod), 
[16°10′41″,50°24′17″], kanál 35, výkon 25 W
+T 602000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Hošťálkovice (Ostrava), 
[18°12′45″,49°51′41″], kanál 37, výkon 100 kW
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Hladnov (Ostrava), 
[18°18′19″,49°50′51″], kanál 37, výkon 10 kW
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Lysá hora (Frýdek-Místek), 
[18°26′56″,49°32′47″], kanál 37, výkon 25 kW
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Jírová hora (Hronov), 
[16°10′32″,50°29′14″], kanál 37, výkon 10 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Radhošť (Valašské Meziřičí), 
[18°13′20″,49°29′31″], kanál 37, výkon 100 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Na Kyčerce (Velké Karlovice), 
[18°17′09″,49°21′05″], kanál 37, výkon 12,5 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Strážnice (Jablonné nad Orlicí), 
[16°35′34″,50°01′59″], kanál 37, výkon 10 W
+T 610000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Šeptouchov (Ledeč nad Sázavou), 
[15°16′06″,49°41′43″], kanál 38, výkon 10 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Fajtův vrch (Velké Meziříčí), 
[16°01′27″,49°21′34″], kanál 38, výkon 10 W
+T 618000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Kleť (České Budějovice), 
[14°16′53″,48°52′03″], kanál 39, výkon 100 kW
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Mařský vrch (Vimperk), 
[13°50′49″,49°04′20″], kanál 39, výkon 20 kW
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Krásné (Pardubice), 
[15°44′15″,49°49′21″], kanál 39, výkon 25 kW
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Horní Sněžná (Volary), 
[13°56′06″,48°53′13″], kanál 39, výkon 20 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Krásná pole (Loučovice), 
[14°14′18″,48°36′17″], kanál 39, výkon 10 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Novotných vršek (Zdíkov), 
[13°41′23″,49°05′11″], kanál 39, výkon 10 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Semenec (Týn nad Vltavou), 
[14°24′38″,49°14′00″], kanál 39, výkon 10 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Olešná (Blansko), 
[16°38′41″,49°20′24″], kanál 39, výkon 20 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač ul. Údolní (Havlíčkův Brod), 
[15°34′44″,49°35′49″], kanál 39, výkon 10 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Kamenná Horka (Svitavy), 
[16°34′10″,49°44′22″], kanál 39, výkon 100 W
+T 626000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Hády (Brno), 
[16°40′28″,49°13′22″], kanál 40, výkon 10 kW
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Barvičova (Brno), 
[16°34′47″,49°11′56″], kanál 40, výkon 10 kW
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Děvín (Mikulov), 
[16°39′01″,48°52′10″], kanál 40, výkon 25 kW
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Kojál (Brno), 
[16°48′58″,49°22′12″], kanál 40, výkon 100 kW
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Harusův kopec (Žďár nad 
Sázavou), [16°02′39″,49°34′21″], kanál 40, výkon 100 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač ul. Zborovská (Náměšť nad 
Oslavou), [16°08′56″,49°12′11″], kanál 40, výkon 10 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Čížovky (Boskovice), 
[16°40′43″,49°29′17″], kanál 40, výkon 10 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač U Sivků (Huslenky), 
[18°05′48″,49°19′20″], kanál 40, výkon 25 W
+T 634000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Žižkov (Praha), 
[14°27′04″,50°04′52″], kanál 41, výkon 32 kW
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Cukrák (Praha), 
[14°21′21″,49°56′12″], kanál 41, výkon 100 kW
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Mezivrata (Votice), 
[14°40′16″,49°36′10″], kanál 41, výkon 32 kW
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Březové hory (Příbram), 
[13°59′49″,49°41′08″], kanál 41, výkon 10 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač nad hřbitovem (Jince), 
[13°58′18″,49°46′58″], kanál 41, výkon 10 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Na Vrážích (Husinec), 
[13°58′36″,49°03′21″], kanál 41, výkon 10 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Komorní Hrádek (Chocerady), 
[14°47′53″,49°52′06″], kanál 41, výkon 5 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Na Vlkaňáku (Sázava), 
[14°53′31″,49°52′56″], kanál 41, výkon 10 W
+T 690000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Krašov (Plzeň), 
[13°04′46″,49°59′45″], kanál 48, výkon 100 kW
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Vraní vrch (Domažlice), 
[12°46′41″,49°28′21″], kanál 48, výkon 10 kW
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Vranovský vrch (Nemanice), 
[12°43′49″,49°28′18″], kanál 48, výkon 10 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Svatobor (Sušice), 
[13°29′23″,49°14′06″], kanál 48, výkon 100 kW
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Suchý kámen (Nýrsko), 
[13°07′50″,49°16′36″], kanál 48, výkon 10 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Rozvodí (Železná Ruda), 
[13°11′52″,49°10′28″], kanál 48, výkon 10 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač ul. Okružní (Rakovník), 
[13°43′55″,50°05′43″], kanál 48, výkon 10 W
+T 698000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Na Rozárce (Žamberk), 
[16°27′25″,50°05′16″], kanál 49, výkon 16 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Kubincův kopec (Ústí nad 
Orlicí), [16°22′40″,49°58′32″], kanál 49, výkon 2 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Tlustá hora (Zlín), 
[17°38′47″,49°12′30″], kanál 49, výkon 100 kW
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Ploštiny (Valašské Klobouky), 
[18°03′22″,49°08′20″], kanál 49, výkon 25 kW
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Pálenisko (Jablůnka), 
[17°58′27″,49°24′09″], kanál 49, výkon 10 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Humenec (Nový Hrozenkov), 
[18°12′42″,49°21′17″], kanál 49, výkon 25 kW
+T 722000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Ještěd (Liberec), 
[14°59′05″,50°43′58″], kanál 52, výkon 50 kW
+#   ^-- MUX 2 - České Radiokomunikace, vysílač U rozhledny (Frýdlant v 
Čechách), [15°04′34″,50°56′07″], kanál 52, výkon 25 W
+T 730000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Praděd (Jeseník), 
[17°13′52″,50°04′59″], kanál 53, výkon 100 kW
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Biskupská kupa (Zlaté Hory), 
[17°25′45″,50°15′14″], kanál 53, výkon 20 W
+T 770000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Buková hora (Ústí n./L.), 
[14°13′44″,50°40′19″], kanál 58, výkon 100 kW
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Jedlová hora (Chomutov), 
[13°27′43″,50°32′55″], kanál 58, výkon 32 kW
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Vaňov (Ústí nad Labem), 
[14°02′15″,50°38′41″], kanál 58, výkon 10 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Popovický vrch (Děčín), 
[14°10′33″,50°46′11″], kanál 58, výkon 20 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Ječný vrch (Velký Šenov), 
[14°19′26″,51°00′22″], kanál 58, výkon 20 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač vrch Pytlák (Šluknov), 
[14°30′34″,50°59′57″], kanál 58, výkon 20 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Hřebenáč (Jindřichovice pod 
Smrkem), [15°14′26″,50°56′18″], kanál 58, výkon 10 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Lázně Libverda nad hřbitovem 
(Hejnice), [15°13′17″,50°53′15″], kanál 58, výkon 10 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Bečevná (Vsetín), 
[17°59′32″,49°19′45″], kanál 58, výkon 20 W
+T 794000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Černá hora (Trutnov), 
[15°44′30″,50°39′09″], kanál 61, výkon 100 kW
+T 834000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Zelená hora (Cheb), 
[12°18′29″,50°04′10″], kanál 66, výkon 20 kW
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Klínovec (Jáchymov), 
[12°58′04″,50°23′49″], kanál 66, výkon 50 kW
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz--Multiplex_3
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz--Multiplex_3    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,45 @@
+# Czech Republic, Multiplex 3 - Czech Digital Group
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 482000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+#   ^-- MUX 3 - Czech Digital Group, vysílač Kleť (České Budějovice), 
[14°16′53″,48°52′03″], kanál 22, výkon 100 kW
+T 506000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+#   ^-- MUX 3 - Czech Digital Group, vysílač Tlustá hora (Zlín), 
[17°38′47″,49°12′30″], kanál 25, výkon 100 kW
+T 546000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+#   ^-- MUX 3 - Czech Digital Group, vysílač Javořice (Jihlava), 
[15°20′22″,49°14′17″], kanál 30, výkon 100 kW
+T 578000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+#   ^-- MUX 3 - Czech Digital Group, vysílač Krásné (Pardubice), 
[15°44′15″,49°49′21″], kanál 34, výkon 10 kW (snížený)
+T 690000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+#   ^-- MUX 3 - Czech Digital Group, vysílač Hošťálkovice (Ostrava), 
[18°12′45″,49°51′41″], kanál 48, výkon 100 kW
+#   ^-- MUX 3 - Czech Digital Group, vysílač Hladnov (Ostrava), 
[18°18′19″,49°50′51″], kanál 48, výkon 10 kW
+T 698000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+#   ^-- MUX 3 - Czech Digital Group, vysílač Kraví hora (Znojmo), 
[16°02′14″,48°50′46″], kanál 49, výkon 25 W
+T 714000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+#   ^-- MUX 3 - Czech Digital Group, vysílač Praděd (Jeseník), 
[17°13′52″,50°04′59″], kanál 51, výkon 100 kW
+T 722000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+#   ^-- MUX 3 - Czech Digital Group, vysílač Krašov (Plzeň), 
[13°04′46″,49°59′45″], kanál 52, výkon 100 kW
+#   ^-- MUX 3 - Czech Digital Group, vysílač Svatobor (Sušice), 
[13°29′23″,49°14′06″], kanál 52, výkon 100 kW
+#   ^-- MUX 3 - Czech Digital Group, vysílač Rokycany (), 
[13°35′34″,49°44′39″], kanál 52, výkon 2 W
+T 746000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+#   ^-- MUX 3 - Czech Digital Group, vysílač Buková hora (Ústí n./L.), 
[14°13′44″,50°40′19″], kanál 55, výkon 100 kW
+#   ^-- MUX 3 - Czech Digital Group, vysílač Desná III (), 
[15°21′07″,50°45′47″], kanál 55, výkon 4 W
+#   ^-- MUX 3 - Czech Digital Group, vysílač Holoubkov (), 
[13°41′25″,49°46′32″], kanál 55, výkon 4 W
+#   ^-- MUX 3 - Czech Digital Group, vysílač Strašice (), 
[13°45′26″,49°44′04″], kanál 55, výkon 4 W
+T 778000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+#   ^-- MUX 3 - Czech Digital Group, vysílač Žižkov (Praha), 
[14°27′04″,50°04′52″], kanál 59, výkon 32 kW
+#   ^-- MUX 3 - Czech Digital Group, vysílač Cukrák (Praha), 
[14°21′21″,49°56′12″], kanál 59, výkon 100 kW
+#   ^-- MUX 3 - Czech Digital Group, vysílač Hády (Brno), 
[16°40′28″,49°13′22″], kanál 59, výkon 10 kW
+#   ^-- MUX 3 - Czech Digital Group, vysílač Barvičova (Brno), 
[16°34′47″,49°11′56″], kanál 59, výkon 10 kW
+#   ^-- MUX 3 - Czech Digital Group, vysílač Zbiroh (), [13°46′06″,49°51′26″], 
kanál 59, výkon 15 W
+#   ^-- MUX 3 - Czech Digital Group, vysílač Kojál (Brno), 
[16°48′58″,49°22′12″], kanál 59, výkon 100 kW
+T 786000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+#   ^-- MUX 3 - Czech Digital Group, vysílač Černá hora (Trutnov), 
[15°44′30″,50°39′09″], kanál 60, výkon 100 kW
+#   ^-- MUX 3 - Czech Digital Group, vysílač Tři kříže (Karlovy Vary), 
[12°53′12″,50°13′39″], kanál 60, výkon 25 W
+#   ^-- MUX 3 - Czech Digital Group, vysílač Ještěd (Liberec), 
[14°59′05″,50°43′58″], kanál 60, výkon 20 kW
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz--Multiplex_4
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz--Multiplex_4    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,15 @@
+# Czech Republic, Multiplex 4 - Digital Broadcasting
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 810000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+#   ^-- MUX 4 - Digital Broadcasting, vysílač ul. 1. máje (Ostrava), 
[18°15′32″,49°49′39″], kanál 63, výkon 0,81 kW
+T 818000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+#   ^-- MUX 4 - Digital Broadcasting, vysílač ÚTB Olšanská (Praha), 
[14°28′09″,50°05′01″], kanál 64, výkon 2 kW
+#   ^-- MUX 4 - Digital Broadcasting, vysílač FN Bohunice (Brno), 
[16°34′14″,49°10′33″], kanál 64, výkon 2 kW
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-All
--- a/util/scan/dvb-t/cz-All    Tue Apr 10 16:44:06 2012 +0200
+++ b/util/scan/dvb-t/cz-All    Wed May 23 11:36:07 2012 +0200
@@ -3,39 +3,226 @@
  # and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
  # and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
  # and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
  # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 482000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
-T 506000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+
+T 482000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+#   ^-- MUX 3 - Czech Digital Group, vysílač Kleť (České Budějovice), 
[14°16′53″,48°52′03″], kanál 22, výkon 100 kW
+T 506000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+#   ^-- MUX 3 - Czech Digital Group, vysílač Tlustá hora (Zlín), 
[17°38′47″,49°12′30″], kanál 25, výkon 100 kW
  T 538000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
-T 546000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Barvičova (Brno), 
[16°34′47″,49°11′56″], kanál 29, výkon 10 kW
+#   ^-- MUX 1 - Česká televize, vysílač Hády (Brno), [16°40′28″,49°13′22″], 
kanál 29, výkon 10 kW
+#   ^-- MUX 1 - Česká televize, vysílač Kojál (Brno), [16°48′58″,49°22′12″], 
kanál 29, výkon 100 kW
+#   ^-- MUX 1 - Česká televize, vysílač Děvín (Mikulov), [16°39′01″,48°52′10″], 
kanál 29, výkon 25 kW
+#   ^-- MUX 1 - Česká televize, vysílač Praha (Příbram), [13°49′04″,49°39′30″], 
kanál 29, výkon 1 kW
+#   ^-- MUX 1 - Česká televize, vysílač Březové hory (Příbram), 
[13°59′49″,49°41′08″], kanál 29, výkon 10 W
+#   ^-- MUX 1 - Česká televize, vysílač Kamenná Horka (Svitavy), 
[16°34′10″,49°44′22″], kanál 29, výkon 100 W
+#   ^-- MUX 1 - Česká televize, vysílač ul. Zborovská (Náměšť nad Oslavou), 
[16°08′56″,49°12′11″], kanál 29, výkon 10 W
+#   ^-- MUX 1 - Česká televize, vysílač U Sivků (Huslenky), 
[18°05′48″,49°19′20″], kanál 29, výkon 25 W
+#   ^-- MUX 1 - Česká televize, vysílač Čížovky (Boskovice), 
[16°40′43″,49°29′17″], kanál 29, výkon 10 W
+#   ^-- MUX 1 - Česká televize, vysílač Strážnice (Jablonné nad Orlicí), 
[16°35′34″,50°01′59″], kanál 29, výkon 10 W
+T 546000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+#   ^-- MUX 3 - Czech Digital Group, vysílač Javořice (Jihlava), 
[15°20′22″,49°14′17″], kanál 30, výkon 100 kW
  T 562000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Krásné (Pardubice), 
[15°44′15″,49°49′21″], kanál 32, výkon 25 kW
+#   ^-- MUX 1 - Česká televize, vysílač Olešná (Blansko), 
[16°38′41″,49°20′24″], kanál 32, výkon 20 W
+#   ^-- MUX 1 - Česká televize, vysílač ul. Údolní (Havlíčkův Brod), 
[15°34′44″,49°35′49″], kanál 32, výkon 10 W
  T 570000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Buková hora (Ústí n./L.), 
[14°13′44″,50°40′19″], kanál 33, výkon 100 kW
+#   ^-- MUX 1 - Česká televize, vysílač Desná III (), [15°21′07″,50°45′47″], 
kanál 33, výkon 3 W
+#   ^-- MUX 1 - Česká televize, vysílač Jedlová hora (Chomutov), 
[13°27′43″,50°32′55″], kanál 33, výkon 32 kW
+#   ^-- MUX 1 - Česká televize, vysílač Javořice (Jihlava), 
[15°20′22″,49°14′17″], kanál 33, výkon 100 kW
+#   ^-- MUX 1 - Česká televize, vysílač Tlustá hora (Zlín), 
[17°38′47″,49°12′30″], kanál 33, výkon 100 kW
+#   ^-- MUX 1 - Česká televize, vysílač Ploštiny (Valašské Klobouky), 
[18°03′22″,49°08′20″], kanál 33, výkon 25 kW
+#   ^-- MUX 1 - Česká televize, vysílač Vaňov (Ústí nad Labem), 
[14°02′15″,50°38′41″], kanál 33, výkon 10 W
+#   ^-- MUX 1 - Česká televize, vysílač Popovický vrch (Děčín), 
[14°10′33″,50°46′11″], kanál 33, výkon 20 W
+#   ^-- MUX 1 - Česká televize, vysílač Ječný vrch (Velký Šenov), 
[14°19′26″,51°00′22″], kanál 33, výkon 20 W
+#   ^-- MUX 1 - Česká televize, vysílač vrch Pytlák (Šluknov), 
[14°30′34″,50°59′57″], kanál 33, výkon 20 W
+#   ^-- MUX 1 - Česká televize, vysílač Hřebenáč (Jindřichovice pod Smrkem), 
[15°14′26″,50°56′18″], kanál 33, výkon 10 W
+#   ^-- MUX 1 - Česká televize, vysílač Strážný vrch (Třebíč), 
[15°52′28″,49°12′36″], kanál 33, výkon 5 W
+#   ^-- MUX 1 - Česká televize, vysílač Humenec (Nový Hrozenkov), 
[18°12′42″,49°21′17″], kanál 33, výkon 25 W
+#   ^-- MUX 1 - Česká televize, vysílač Branka (Luhačovice), 
[17°45′18″,49°05′50″], kanál 33, výkon 46 W
+#   ^-- MUX 1 - Česká televize, vysílač Rokštejnská (Brtnice), 
[15°41′07″,49°18′14″], kanál 33, výkon 10 W
  T 578000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Krašov (Plzeň), [13°04′46″,49°59′45″], 
kanál 34, výkon 100 kW
+#   ^-- MUX 1 - Česká televize, vysílač Vraní vrch (Domažlice), 
[12°46′41″,49°28′21″], kanál 34, výkon 10 kW
+#   ^-- MUX 1 - Česká televize, vysílač Vranovský vrch (Nemanice), 
[12°43′49″,49°28′18″], kanál 34, výkon 10 W
+#   ^-- MUX 1 - Česká televize, vysílač Suchý kámen (Nýrsko), 
[13°07′50″,49°16′36″], kanál 34, výkon 10 W
+#   ^-- MUX 1 - Česká televize, vysílač Rozvodí (Železná Ruda), 
[13°11′52″,49°10′28″], kanál 34, výkon 10 W
+#   ^-- MUX 1 - Česká televize, vysílač Fajtův vrch (Velké Meziříčí), 
[16°01′27″,49°21′34″], kanál 34, výkon 10 W
+#   ^-- MUX 1 - Česká televize, vysílač ul. Okružní (Rakovník), 
[13°43′55″,50°05′43″], kanál 34, výkon 10 W
+T 578000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+#   ^-- MUX 3 - Czech Digital Group, vysílač Krásné (Pardubice), 
[15°44′15″,49°49′21″], kanál 34, výkon 10 kW (snížený)
  T 586000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Tři kříže (Karlovy Vary), 
[12°53′12″,50°13′39″], kanál 35, výkon 25 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Háj (Aš), [12°12′04″,50°14′01″], 
kanál 35, výkon 50 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Monty (Mariánské Lázně), 
[12°41′58″,49°58′06″], kanál 35, výkon 10 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Sněžná (Kraslice), 
[12°30′20″,50°18′41″], kanál 35, výkon 10 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač pod hřbitovem (Rotava), 
[12°34′09″,50°17′49″], kanál 35, výkon 5 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Javořice (Jihlava), 
[15°20′22″,49°14′17″], kanál 35, výkon 100 kW
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Strážný vrch (Třebíč), 
[15°52′28″,49°12′36″], kanál 35, výkon 5 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač nad ZD (Letohrad), 
[16°31′32″,50°01′56″], kanál 35, výkon 10 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Na Vyhlídce (Náchod), 
[16°10′41″,50°24′17″], kanál 35, výkon 25 W
  T 594000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Zelená hora (Cheb), 
[12°18′29″,50°04′10″], kanál 36, výkon 20 kW
+#   ^-- MUX 1 - Česká televize, vysílač Háj (Aš), [12°12′04″,50°14′01″], kanál 
36, výkon 50 W
+#   ^-- MUX 1 - Česká televize, vysílač Klínovec (Jáchymov), 
[12°58′04″,50°23′49″], kanál 36, výkon 50 kW
+#   ^-- MUX 1 - Česká televize, vysílač Monty (Mariánské Lázně), 
[12°41′58″,49°58′06″], kanál 36, výkon 10 W
+#   ^-- MUX 1 - Česká televize, vysílač pod hřbitovem (Rotava), 
[12°34′09″,50°17′49″], kanál 36, výkon 5 W
+#   ^-- MUX 1 - Česká televize, vysílač Sněžná (Kraslice), 
[12°30′20″,50°18′41″], kanál 36, výkon 10 W
+#   ^-- MUX 1 - Česká televize, vysílač Tři kříže (Karlovy Vary), 
[12°53′12″,50°13′39″], kanál 36, výkon 25 W
+#   ^-- MUX 1 - Česká televize, vysílač Praděd (Jeseník), 
[17°13′52″,50°04′59″], kanál 36, výkon 100 kW
+#   ^-- MUX 1 - Česká televize, vysílač Biskupská kupa (Zlaté Hory), 
[17°25′45″,50°15′14″], kanál 36, výkon 20 W
+#   ^-- MUX 1 - Česká televize, vysílač Na Rozárce (Žamberk), 
[16°27′25″,50°05′16″], kanál 36, výkon 16 W
+#   ^-- MUX 1 - Česká televize, vysílač Jírová hora (Hronov), 
[16°10′32″,50°29′14″], kanál 36, výkon 10 W
+#   ^-- MUX 1 - Česká televize, vysílač Zlatý Chlum (Jeseník), 
[17°14′15″,50°14′17″], kanál 36, výkon 100 W
  T 602000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Hošťálkovice (Ostrava), 
[18°12′45″,49°51′41″], kanál 37, výkon 100 kW
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Hladnov (Ostrava), 
[18°18′19″,49°50′51″], kanál 37, výkon 10 kW
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Lysá hora (Frýdek-Místek), 
[18°26′56″,49°32′47″], kanál 37, výkon 25 kW
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Jírová hora (Hronov), 
[16°10′32″,50°29′14″], kanál 37, výkon 10 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Radhošť (Valašské Meziřičí), 
[18°13′20″,49°29′31″], kanál 37, výkon 100 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Na Kyčerce (Velké Karlovice), 
[18°17′09″,49°21′05″], kanál 37, výkon 12,5 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Strážnice (Jablonné nad Orlicí), 
[16°35′34″,50°01′59″], kanál 37, výkon 10 W
+T 610000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Šeptouchov (Ledeč nad Sázavou), 
[15°16′06″,49°41′43″], kanál 38, výkon 10 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Fajtův vrch (Velké Meziříčí), 
[16°01′27″,49°21′34″], kanál 38, výkon 10 W
  T 618000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Kleť (České Budějovice), 
[14°16′53″,48°52′03″], kanál 39, výkon 100 kW
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Mařský vrch (Vimperk), 
[13°50′49″,49°04′20″], kanál 39, výkon 20 kW
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Krásné (Pardubice), 
[15°44′15″,49°49′21″], kanál 39, výkon 25 kW
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Horní Sněžná (Volary), 
[13°56′06″,48°53′13″], kanál 39, výkon 20 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Krásná pole (Loučovice), 
[14°14′18″,48°36′17″], kanál 39, výkon 10 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Novotných vršek (Zdíkov), 
[13°41′23″,49°05′11″], kanál 39, výkon 10 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Semenec (Týn nad Vltavou), 
[14°24′38″,49°14′00″], kanál 39, výkon 10 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Olešná (Blansko), 
[16°38′41″,49°20′24″], kanál 39, výkon 20 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač ul. Údolní (Havlíčkův Brod), 
[15°34′44″,49°35′49″], kanál 39, výkon 10 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Kamenná Horka (Svitavy), 
[16°34′10″,49°44′22″], kanál 39, výkon 100 W
  T 626000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Černá hora (Trutnov), 
[15°44′30″,50°39′09″], kanál 40, výkon 100 kW
+#   ^-- MUX 1 - Česká televize, vysílač u nádraží (Horní Lipová), 
[17°04′58″,50°13′33″], kanál 40, výkon ?
+#   ^-- MUX 1 - Česká televize, vysílač Hvězda (Broumov), 
[16°15′57″,50°34′04″], kanál 40, výkon 25 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Hády (Brno), 
[16°40′28″,49°13′22″], kanál 40, výkon 10 kW
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Barvičova (Brno), 
[16°34′47″,49°11′56″], kanál 40, výkon 10 kW
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Děvín (Mikulov), 
[16°39′01″,48°52′10″], kanál 40, výkon 25 kW
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Kojál (Brno), 
[16°48′58″,49°22′12″], kanál 40, výkon 100 kW
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Harusův kopec (Žďár nad 
Sázavou), [16°02′39″,49°34′21″], kanál 40, výkon 100 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač ul. Zborovská (Náměšť nad 
Oslavou), [16°08′56″,49°12′11″], kanál 40, výkon 10 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Čížovky (Boskovice), 
[16°40′43″,49°29′17″], kanál 40, výkon 10 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač U Sivků (Huslenky), 
[18°05′48″,49°19′20″], kanál 40, výkon 25 W
  T 634000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
-T 642000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Žižkov (Praha), 
[14°27′04″,50°04′52″], kanál 41, výkon 32 kW
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Cukrák (Praha), 
[14°21′21″,49°56′12″], kanál 41, výkon 100 kW
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Mezivrata (Votice), 
[14°40′16″,49°36′10″], kanál 41, výkon 32 kW
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Březové hory (Příbram), 
[13°59′49″,49°41′08″], kanál 41, výkon 10 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač nad hřbitovem (Jince), 
[13°58′18″,49°46′58″], kanál 41, výkon 10 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Na Vrážích (Husinec), 
[13°58′36″,49°03′21″], kanál 41, výkon 10 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Komorní Hrádek (Chocerady), 
[14°47′53″,49°52′06″], kanál 41, výkon 5 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Na Vlkaňáku (Sázava), 
[14°53′31″,49°52′56″], kanál 41, výkon 10 W
  T 650000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
-T 658000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 666000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 674000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Ještěd (Liberec), 
[14°59′05″,50°43′58″], kanál 43, výkon 50 kW
+#   ^-- MUX 1 - Česká televize, vysílač U rozhledny (Frýdlant v Čechách), 
[15°04′34″,50°56′07″], kanál 43, výkon 25 W
+#   ^-- MUX 1 - Česká televize, vysílač Dubina (Strání), [17°40′56″,48°54′54″], 
kanál 43, výkon 25 W
+#   ^-- MUX 1 - Česká televize, vysílač Suchý vrch (Králíky), 
[16°41′21″,50°03′07″], kanál 43, výkon 50 W
+#   ^-- MUX 1 - Česká televize, vysílač Pálenisko (Jablůnka), 
[17°58′27″,49°24′09″], kanál 43, výkon 5 W
  T 690000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Krašov (Plzeň), 
[13°04′46″,49°59′45″], kanál 48, výkon 100 kW
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Vraní vrch (Domažlice), 
[12°46′41″,49°28′21″], kanál 48, výkon 10 kW
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Vranovský vrch (Nemanice), 
[12°43′49″,49°28′18″], kanál 48, výkon 10 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Svatobor (Sušice), 
[13°29′23″,49°14′06″], kanál 48, výkon 100 kW
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Suchý kámen (Nýrsko), 
[13°07′50″,49°16′36″], kanál 48, výkon 10 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Rozvodí (Železná Ruda), 
[13°11′52″,49°10′28″], kanál 48, výkon 10 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač ul. Okružní (Rakovník), 
[13°43′55″,50°05′43″], kanál 48, výkon 10 W
+T 690000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+#   ^-- MUX 3 - Czech Digital Group, vysílač Hošťálkovice (Ostrava), 
[18°12′45″,49°51′41″], kanál 48, výkon 100 kW
+#   ^-- MUX 3 - Czech Digital Group, vysílač Hladnov (Ostrava), 
[18°18′19″,49°50′51″], kanál 48, výkon 10 kW
  T 698000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
-T 706000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
-T 714000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Kleť (České Budějovice), 
[14°16′53″,48°52′03″], kanál 49, výkon 100 kW
+#   ^-- MUX 1 - Česká televize, vysílač Svatobor (Sušice), 
[13°29′23″,49°14′06″], kanál 49, výkon 100 kW
+#   ^-- MUX 1 - Česká televize, vysílač Mařský vrch (Vimperk), 
[13°50′49″,49°04′20″], kanál 49, výkon 20 kW
+#   ^-- MUX 1 - Česká televize, vysílač Horní Sněžná (Volary), 
[13°56′06″,48°53′13″], kanál 49, výkon 20 W
+#   ^-- MUX 1 - Česká televize, vysílač Krásná pole (Loučovice), 
[14°14′18″,48°36′17″], kanál 49, výkon 10 W
+#   ^-- MUX 1 - Česká televize, vysílač Novotných vršek (Zdíkov), 
[13°41′23″,49°05′11″], kanál 49, výkon 10 W
+#   ^-- MUX 1 - Česká televize, vysílač Semenec (Týn nad Vltavou), 
[14°24′38″,49°14′00″], kanál 49, výkon 10 W
+#   ^-- MUX 1 - Česká televize, vysílač Šeptouchov (Ledeč nad Sázavou), 
[15°16′06″,49°41′43″], kanál 49, výkon 13 W
+#   ^-- MUX 1 - Česká televize, vysílač Harusův kopec (Žďár nad Sázavou), 
[16°02′39″,49°34′21″], kanál 49, výkon 100 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Na Rozárce (Žamberk), 
[16°27′25″,50°05′16″], kanál 49, výkon 16 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Kubincův kopec (Ústí nad 
Orlicí), [16°22′40″,49°58′32″], kanál 49, výkon 2 W
+T 698000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+#   ^-- MUX 3 - Czech Digital Group, vysílač Kraví hora (Znojmo), 
[16°02′14″,48°50′46″], kanál 49, výkon 25 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Tlustá hora (Zlín), 
[17°38′47″,49°12′30″], kanál 49, výkon 100 kW
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Ploštiny (Valašské Klobouky), 
[18°03′22″,49°08′20″], kanál 49, výkon 25 kW
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Pálenisko (Jablůnka), 
[17°58′27″,49°24′09″], kanál 49, výkon 10 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Humenec (Nový Hrozenkov), 
[18°12′42″,49°21′17″], kanál 49, výkon 25 kW
+T 714000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+#   ^-- MUX 3 - Czech Digital Group, vysílač Praděd (Jeseník), 
[17°13′52″,50°04′59″], kanál 51, výkon 100 kW
  T 722000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Ještěd (Liberec), 
[14°59′05″,50°43′58″], kanál 52, výkon 50 kW
+#   ^-- MUX 2 - České Radiokomunikace, vysílač U rozhledny (Frýdlant v 
Čechách), [15°04′34″,50°56′07″], kanál 52, výkon 25 W
+T 722000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+#   ^-- MUX 3 - Czech Digital Group, vysílač Krašov (Plzeň), 
[13°04′46″,49°59′45″], kanál 52, výkon 100 kW
+#   ^-- MUX 3 - Czech Digital Group, vysílač Svatobor (Sušice), 
[13°29′23″,49°14′06″], kanál 52, výkon 100 kW
+#   ^-- MUX 3 - Czech Digital Group, vysílač Rokycany (), 
[13°35′34″,49°44′39″], kanál 52, výkon 2 W
  T 730000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Cukrák (Praha), [14°21′21″,49°56′12″], 
kanál 53, výkon 100 kW
+#   ^-- MUX 1 - Česká televize, vysílač Žižkov (Praha), [14°27′04″,50°04′52″], 
kanál 53, výkon 32 kW
+#   ^-- MUX 1 - Česká televize, vysílač Mezivrata (Votice), 
[14°40′16″,49°36′10″], kanál 53, výkon 32 kW
+#   ^-- MUX 1 - Česká televize, vysílač nad hřbitovem (Jince), 
[13°58′18″,49°46′58″], kanál 53, výkon 10 W
+#   ^-- MUX 1 - Česká televize, vysílač Na Vrážích (Husinec), 
[13°58′36″,49°03′21″], kanál 53, výkon 10 W
+#   ^-- MUX 1 - Česká televize, vysílač Komorní Hrádek (Chocerady), 
[14°47′53″,49°52′06″], kanál 53, výkon 5 W
+#   ^-- MUX 1 - Česká televize, vysílač Na Vlkaňáku (Sázava), 
[14°53′31″,49°52′56″], kanál 53, výkon 10 W
+#   ^-- MUX 1 - Česká televize, vysílač Vyhlídka (Náchod), 
[16°10′41″,50°24′17″], kanál 53, výkon ?
+#   ^-- MUX 1 - Česká televize, vysílač Větruše (Ústí nad Labem), 
[14°02′23″,50°39′18″], kanál 53, výkon 10 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Praděd (Jeseník), 
[17°13′52″,50°04′59″], kanál 53, výkon 100 kW
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Biskupská kupa (Zlaté Hory), 
[17°25′45″,50°15′14″], kanál 53, výkon 20 W
  T 738000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
-T 746000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Hladnov (Ostrava), 
[18°18′19″,49°50′51″], kanál 54, výkon 10 kW
+#   ^-- MUX 1 - Česká televize, vysílač Hošťálkovice (Ostrava), 
[18°12′45″,49°51′41″], kanál 54, výkon 14 kW
+#   ^-- MUX 1 - Česká televize, vysílač Lysá hora (Frýdek-Místek), 
[18°26′56″,49°32′47″], kanál 54, výkon 25 kW
+#   ^-- MUX 1 - Česká televize, vysílač Radhošť (Valašské Meziřičí), 
[18°13′20″,49°29′31″], kanál 54, výkon 100 W
+#   ^-- MUX 1 - Česká televize, vysílač Bečevná (Vsetín), 
[17°59′32″,49°19′45″], kanál 54, výkon 20 W
+#   ^-- MUX 1 - Česká televize, vysílač Na Kyčerce (Velké Karlovice), 
[18°17′09″,49°21′05″], kanál 54, výkon 25 W
+#   ^-- MUX 1 - Česká televize, vysílač nad ZD (Letohrad), 
[16°31′32″,50°01′56″], kanál 54, výkon 10 W
+#   ^-- MUX 1 - Česká televize, vysílač Dolní Dobrouč (), 
[16°30′03″,49°59′42″], kanál 54, výkon 22 W
+#   ^-- MUX 1 - Česká televize, vysílač Vadín (Okrouhlice), 
[15°29′15″,49°38′15″], kanál 54, výkon 100 W
+#   ^-- MUX 1 - Česká televize, vysílač Gagarinova (Hlubočky), 
[17°24′00″,49°37′26″], kanál 54, výkon 22 W
+#   ^-- MUX 1 - Česká televize, vysílač Kubincův kopec (Ústí nad Orlicí), 
[16°22′40″,49°58′32″], kanál 54, výkon 10 W
+T 746000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+#   ^-- MUX 3 - Czech Digital Group, vysílač Buková hora (Ústí n./L.), 
[14°13′44″,50°40′19″], kanál 55, výkon 100 kW
+#   ^-- MUX 3 - Czech Digital Group, vysílač Desná III (), 
[15°21′07″,50°45′47″], kanál 55, výkon 4 W
+#   ^-- MUX 3 - Czech Digital Group, vysílač Holoubkov (), 
[13°41′25″,49°46′32″], kanál 55, výkon 4 W
+#   ^-- MUX 3 - Czech Digital Group, vysílač Strašice (), 
[13°45′26″,49°44′04″], kanál 55, výkon 4 W
  T 770000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
-T 778000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
-T 786000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Buková hora (Ústí n./L.), 
[14°13′44″,50°40′19″], kanál 58, výkon 100 kW
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Jedlová hora (Chomutov), 
[13°27′43″,50°32′55″], kanál 58, výkon 32 kW
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Vaňov (Ústí nad Labem), 
[14°02′15″,50°38′41″], kanál 58, výkon 10 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Popovický vrch (Děčín), 
[14°10′33″,50°46′11″], kanál 58, výkon 20 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Ječný vrch (Velký Šenov), 
[14°19′26″,51°00′22″], kanál 58, výkon 20 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač vrch Pytlák (Šluknov), 
[14°30′34″,50°59′57″], kanál 58, výkon 20 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Hřebenáč (Jindřichovice pod 
Smrkem), [15°14′26″,50°56′18″], kanál 58, výkon 10 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Lázně Libverda nad hřbitovem 
(Hejnice), [15°13′17″,50°53′15″], kanál 58, výkon 10 W
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Bečevná (Vsetín), 
[17°59′32″,49°19′45″], kanál 58, výkon 20 W
+T 778000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+#   ^-- MUX 3 - Czech Digital Group, vysílač Žižkov (Praha), 
[14°27′04″,50°04′52″], kanál 59, výkon 32 kW
+#   ^-- MUX 3 - Czech Digital Group, vysílač Cukrák (Praha), 
[14°21′21″,49°56′12″], kanál 59, výkon 100 kW
+#   ^-- MUX 3 - Czech Digital Group, vysílač Hády (Brno), 
[16°40′28″,49°13′22″], kanál 59, výkon 10 kW
+#   ^-- MUX 3 - Czech Digital Group, vysílač Barvičova (Brno), 
[16°34′47″,49°11′56″], kanál 59, výkon 10 kW
+#   ^-- MUX 3 - Czech Digital Group, vysílač Zbiroh (), [13°46′06″,49°51′26″], 
kanál 59, výkon 15 W
+#   ^-- MUX 3 - Czech Digital Group, vysílač Kojál (Brno), 
[16°48′58″,49°22′12″], kanál 59, výkon 100 kW
+T 786000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+#   ^-- MUX 3 - Czech Digital Group, vysílač Černá hora (Trutnov), 
[15°44′30″,50°39′09″], kanál 60, výkon 100 kW
+#   ^-- MUX 3 - Czech Digital Group, vysílač Tři kříže (Karlovy Vary), 
[12°53′12″,50°13′39″], kanál 60, výkon 25 W
+#   ^-- MUX 3 - Czech Digital Group, vysílač Ještěd (Liberec), 
[14°59′05″,50°43′58″], kanál 60, výkon 20 kW
  T 794000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
-T 802000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Černá hora (Trutnov), 
[15°44′30″,50°39′09″], kanál 61, výkon 100 kW
  T 810000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+#   ^-- MUX 4 - Digital Broadcasting, vysílač ul. 1. máje (Ostrava), 
[18°15′32″,49°49′39″], kanál 63, výkon 0,81 kW
  T 818000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 826000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+#   ^-- MUX 4 - Digital Broadcasting, vysílač ÚTB Olšanská (Praha), 
[14°28′09″,50°05′01″], kanál 64, výkon 2 kW
+#   ^-- MUX 4 - Digital Broadcasting, vysílač FN Bohunice (Brno), 
[16°34′14″,49°10′33″], kanál 64, výkon 2 kW
  T 834000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Zelená hora (Cheb), 
[12°18′29″,50°04′10″], kanál 66, výkon 20 kW
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Klínovec (Jáchymov), 
[12°58′04″,50°23′49″], kanál 66, výkon 50 kW
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-As_Haj
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-As_Haj    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Aš Háj
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 586000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Háj (Aš), [12°12′04″,50°14′01″], 
kanál 35, výkon 50 W
+T 594000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Háj (Aš), [12°12′04″,50°14′01″], kanál 
36, výkon 50 W
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Blansko_Olesna
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Blansko_Olesna    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Blansko Olešná
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 562000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Olešná (Blansko), 
[16°38′41″,49°20′24″], kanál 32, výkon 20 W
+T 618000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Olešná (Blansko), 
[16°38′41″,49°20′24″], kanál 39, výkon 20 W
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Boskovice_Cizovky
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Boskovice_Cizovky    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Boskovice Čížovky
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 538000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Čížovky (Boskovice), 
[16°40′43″,49°29′17″], kanál 29, výkon 10 W
+T 626000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Čížovky (Boskovice), 
[16°40′43″,49°29′17″], kanál 40, výkon 10 W
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Brno_Barvicova
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Brno_Barvicova    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,16 @@
+# Czech Republic, Brno Barvičova
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 538000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Barvičova (Brno), 
[16°34′47″,49°11′56″], kanál 29, výkon 10 kW
+T 626000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Barvičova (Brno), 
[16°34′47″,49°11′56″], kanál 40, výkon 10 kW
+T 778000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+#   ^-- MUX 3 - Czech Digital Group, vysílač Barvičova (Brno), 
[16°34′47″,49°11′56″], kanál 59, výkon 10 kW
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Brno_FN_Bohunice
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Brno_FN_Bohunice    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,12 @@
+# Czech Republic, Brno FN Bohunice
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 818000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+#   ^-- MUX 4 - Digital Broadcasting, vysílač FN Bohunice (Brno), 
[16°34′14″,49°10′33″], kanál 64, výkon 2 kW
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Brno_Hady
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Brno_Hady    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,16 @@
+# Czech Republic, Brno Hády
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 538000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Hády (Brno), [16°40′28″,49°13′22″], 
kanál 29, výkon 10 kW
+T 626000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Hády (Brno), 
[16°40′28″,49°13′22″], kanál 40, výkon 10 kW
+T 778000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+#   ^-- MUX 3 - Czech Digital Group, vysílač Hády (Brno), 
[16°40′28″,49°13′22″], kanál 59, výkon 10 kW
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Brno_Kojal
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Brno_Kojal    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,16 @@
+# Czech Republic, Brno Kojál
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 538000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Kojál (Brno), [16°48′58″,49°22′12″], 
kanál 29, výkon 100 kW
+T 626000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Kojál (Brno), 
[16°48′58″,49°22′12″], kanál 40, výkon 100 kW
+T 778000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+#   ^-- MUX 3 - Czech Digital Group, vysílač Kojál (Brno), 
[16°48′58″,49°22′12″], kanál 59, výkon 100 kW
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Broumov_Hvezda
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Broumov_Hvezda    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,12 @@
+# Czech Republic, Broumov Hvězda
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 626000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Hvězda (Broumov), 
[16°15′57″,50°34′04″], kanál 40, výkon 25 W
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Brtnice_Rokstejnska
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Brtnice_Rokstejnska    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,12 @@
+# Czech Republic, Brtnice Rokštejnská
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 570000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Rokštejnská (Brtnice), 
[15°41′07″,49°18′14″], kanál 33, výkon 10 W
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Ceske_Budejovice_Klet
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Ceske_Budejovice_Klet    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,16 @@
+# Czech Republic, České Budějovice Kleť
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 482000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+#   ^-- MUX 3 - Czech Digital Group, vysílač Kleť (České Budějovice), 
[14°16′53″,48°52′03″], kanál 22, výkon 100 kW
+T 618000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Kleť (České Budějovice), 
[14°16′53″,48°52′03″], kanál 39, výkon 100 kW
+T 698000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Kleť (České Budějovice), 
[14°16′53″,48°52′03″], kanál 49, výkon 100 kW
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Cheb_Zelena_hora
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Cheb_Zelena_hora    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Cheb Zelená hora
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 594000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Zelená hora (Cheb), 
[12°18′29″,50°04′10″], kanál 36, výkon 20 kW
+T 834000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Zelená hora (Cheb), 
[12°18′29″,50°04′10″], kanál 66, výkon 20 kW
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Chocerady_Komorni_Hradek
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Chocerady_Komorni_Hradek    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Chocerady Komorní Hrádek
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 634000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Komorní Hrádek (Chocerady), 
[14°47′53″,49°52′06″], kanál 41, výkon 5 W
+T 730000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Komorní Hrádek (Chocerady), 
[14°47′53″,49°52′06″], kanál 53, výkon 5 W
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Chomutov_Jedlova_hora
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Chomutov_Jedlova_hora    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Chomutov Jedlová hora
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 570000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Jedlová hora (Chomutov), 
[13°27′43″,50°32′55″], kanál 33, výkon 32 kW
+T 770000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Jedlová hora (Chomutov), 
[13°27′43″,50°32′55″], kanál 58, výkon 32 kW
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Decin_Popovicky_vrch
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Decin_Popovicky_vrch    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Děčín Popovický vrch
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 570000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Popovický vrch (Děčín), 
[14°10′33″,50°46′11″], kanál 33, výkon 20 W
+T 770000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Popovický vrch (Děčín), 
[14°10′33″,50°46′11″], kanál 58, výkon 20 W
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Domazlice_Vrani_vrch
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Domazlice_Vrani_vrch    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Domažlice Vraní vrch
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 578000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Vraní vrch (Domažlice), 
[12°46′41″,49°28′21″], kanál 34, výkon 10 kW
+T 690000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Vraní vrch (Domažlice), 
[12°46′41″,49°28′21″], kanál 48, výkon 10 kW
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Frydek-Mistek_Lysa_hora
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Frydek-Mistek_Lysa_hora    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Frýdek-Místek Lysá hora
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 602000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Lysá hora (Frýdek-Místek), 
[18°26′56″,49°32′47″], kanál 37, výkon 25 kW
+T 738000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Lysá hora (Frýdek-Místek), 
[18°26′56″,49°32′47″], kanál 54, výkon 25 kW
diff -r 4030c51d6e7b -r 2bded15bc90c 
util/scan/dvb-t/cz-Frydlant_v_Cechach_U_rozhledny
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Frydlant_v_Cechach_U_rozhledny    Wed May 23 11:36:07 
2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Frýdlant v Čechách U rozhledny
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 650000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač U rozhledny (Frýdlant v Čechách), 
[15°04′34″,50°56′07″], kanál 43, výkon 25 W
+T 722000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač U rozhledny (Frýdlant v 
Čechách), [15°04′34″,50°56′07″], kanál 52, výkon 25 W
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Havlickuv_Brod_ul_Udolni
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Havlickuv_Brod_ul_Udolni    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Havlíčkův Brod ul. Údolní
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 562000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač ul. Údolní (Havlíčkův Brod), 
[15°34′44″,49°35′49″], kanál 32, výkon 10 W
+T 618000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač ul. Údolní (Havlíčkův Brod), 
[15°34′44″,49°35′49″], kanál 39, výkon 10 W
diff -r 4030c51d6e7b -r 2bded15bc90c 
util/scan/dvb-t/cz-Hejnice_Lazne_Libverda_nad_hrbitovem
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Hejnice_Lazne_Libverda_nad_hrbitovem    Wed May 23 
11:36:07 2012 +0200
@@ -0,0 +1,12 @@
+# Czech Republic, Hejnice Lázně Libverda nad hřbitovem
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 770000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Lázně Libverda nad hřbitovem 
(Hejnice), [15°13′17″,50°53′15″], kanál 58, výkon 10 W
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Hlubocky_Gagarinova
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Hlubocky_Gagarinova    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,12 @@
+# Czech Republic, Hlubočky Gagarinova
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 738000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Gagarinova (Hlubočky), 
[17°24′00″,49°37′26″], kanál 54, výkon 22 W
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Horni_Lipova_u_nadrazi
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Horni_Lipova_u_nadrazi    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,12 @@
+# Czech Republic, Horní Lipová u nádraží
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 626000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač u nádraží (Horní Lipová), 
[17°04′58″,50°13′33″], kanál 40, výkon ?
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Hronov_Jirova_hora
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Hronov_Jirova_hora    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Hronov Jírová hora
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 594000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Jírová hora (Hronov), 
[16°10′32″,50°29′14″], kanál 36, výkon 10 W
+T 602000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Jírová hora (Hronov), 
[16°10′32″,50°29′14″], kanál 37, výkon 10 W
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Husinec_Na_Vrazich
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Husinec_Na_Vrazich    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Husinec Na Vrážích
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 634000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Na Vrážích (Husinec), 
[13°58′36″,49°03′21″], kanál 41, výkon 10 W
+T 730000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Na Vrážích (Husinec), 
[13°58′36″,49°03′21″], kanál 53, výkon 10 W
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Huslenky_U_Sivku
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Huslenky_U_Sivku    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Huslenky U Sivků
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 538000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač U Sivků (Huslenky), 
[18°05′48″,49°19′20″], kanál 29, výkon 25 W
+T 626000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač U Sivků (Huslenky), 
[18°05′48″,49°19′20″], kanál 40, výkon 25 W
diff -r 4030c51d6e7b -r 2bded15bc90c 
util/scan/dvb-t/cz-Jablonne_nad_Orlici_Straznice
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Jablonne_nad_Orlici_Straznice    Wed May 23 11:36:07 
2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Jablonné nad Orlicí Strážnice
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 538000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Strážnice (Jablonné nad Orlicí), 
[16°35′34″,50°01′59″], kanál 29, výkon 10 W
+T 602000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Strážnice (Jablonné nad Orlicí), 
[16°35′34″,50°01′59″], kanál 37, výkon 10 W
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Jablunka_Palenisko
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Jablunka_Palenisko    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Jablůnka Pálenisko
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 650000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Pálenisko (Jablůnka), 
[17°58′27″,49°24′09″], kanál 43, výkon 5 W
+T 698000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Pálenisko (Jablůnka), 
[17°58′27″,49°24′09″], kanál 49, výkon 10 W
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Jachymov_Klinovec
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Jachymov_Klinovec    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Jáchymov Klínovec
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 594000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Klínovec (Jáchymov), 
[12°58′04″,50°23′49″], kanál 36, výkon 50 kW
+T 834000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Klínovec (Jáchymov), 
[12°58′04″,50°23′49″], kanál 66, výkon 50 kW
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Jesenik_Praded
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Jesenik_Praded    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,16 @@
+# Czech Republic, Jeseník Praděd
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 594000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Praděd (Jeseník), 
[17°13′52″,50°04′59″], kanál 36, výkon 100 kW
+T 714000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+#   ^-- MUX 3 - Czech Digital Group, vysílač Praděd (Jeseník), 
[17°13′52″,50°04′59″], kanál 51, výkon 100 kW
+T 730000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Praděd (Jeseník), 
[17°13′52″,50°04′59″], kanál 53, výkon 100 kW
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Jesenik_Zlaty_Chlum
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Jesenik_Zlaty_Chlum    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,12 @@
+# Czech Republic, Jeseník Zlatý Chlum
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 594000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Zlatý Chlum (Jeseník), 
[17°14′15″,50°14′17″], kanál 36, výkon 100 W
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Jihlava_Javorice
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Jihlava_Javorice    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,16 @@
+# Czech Republic, Jihlava Javořice
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 546000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+#   ^-- MUX 3 - Czech Digital Group, vysílač Javořice (Jihlava), 
[15°20′22″,49°14′17″], kanál 30, výkon 100 kW
+T 570000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Javořice (Jihlava), 
[15°20′22″,49°14′17″], kanál 33, výkon 100 kW
+T 586000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Javořice (Jihlava), 
[15°20′22″,49°14′17″], kanál 35, výkon 100 kW
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Jince_nad_hrbitovem
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Jince_nad_hrbitovem    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Jince nad hřbitovem
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 634000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač nad hřbitovem (Jince), 
[13°58′18″,49°46′58″], kanál 41, výkon 10 W
+T 730000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač nad hřbitovem (Jince), 
[13°58′18″,49°46′58″], kanál 53, výkon 10 W
diff -r 4030c51d6e7b -r 2bded15bc90c 
util/scan/dvb-t/cz-Jindrichovice_pod_Smrkem_Hrebenac
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Jindrichovice_pod_Smrkem_Hrebenac    Wed May 23 
11:36:07 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Jindřichovice pod Smrkem Hřebenáč
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 570000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Hřebenáč (Jindřichovice pod Smrkem), 
[15°14′26″,50°56′18″], kanál 33, výkon 10 W
+T 770000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Hřebenáč (Jindřichovice pod 
Smrkem), [15°14′26″,50°56′18″], kanál 58, výkon 10 W
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Karlovy_Vary_Tri_krize
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Karlovy_Vary_Tri_krize    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,16 @@
+# Czech Republic, Karlovy Vary Tři kříže
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 586000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Tři kříže (Karlovy Vary), 
[12°53′12″,50°13′39″], kanál 35, výkon 25 W
+T 594000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Tři kříže (Karlovy Vary), 
[12°53′12″,50°13′39″], kanál 36, výkon 25 W
+T 786000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+#   ^-- MUX 3 - Czech Digital Group, vysílač Tři kříže (Karlovy Vary), 
[12°53′12″,50°13′39″], kanál 60, výkon 25 W
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Kraliky_Suchy_vrch
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Kraliky_Suchy_vrch    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,12 @@
+# Czech Republic, Králíky Suchý vrch
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 650000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Suchý vrch (Králíky), 
[16°41′21″,50°03′07″], kanál 43, výkon 50 W
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Kraslice_Snezna
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Kraslice_Snezna    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Kraslice Sněžná
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 586000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Sněžná (Kraslice), 
[12°30′20″,50°18′41″], kanál 35, výkon 10 W
+T 594000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Sněžná (Kraslice), 
[12°30′20″,50°18′41″], kanál 36, výkon 10 W
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Ledec_nad_Sazavou_Septouchov
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Ledec_nad_Sazavou_Septouchov    Wed May 23 11:36:07 
2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Ledeč nad Sázavou Šeptouchov
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 610000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Šeptouchov (Ledeč nad Sázavou), 
[15°16′06″,49°41′43″], kanál 38, výkon 10 W
+T 698000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Šeptouchov (Ledeč nad Sázavou), 
[15°16′06″,49°41′43″], kanál 49, výkon 13 W
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Letohrad_nad_ZD
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Letohrad_nad_ZD    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Letohrad nad ZD
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 586000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač nad ZD (Letohrad), 
[16°31′32″,50°01′56″], kanál 35, výkon 10 W
+T 738000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač nad ZD (Letohrad), 
[16°31′32″,50°01′56″], kanál 54, výkon 10 W
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Liberec_Jested
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Liberec_Jested    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,16 @@
+# Czech Republic, Liberec Ještěd
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 650000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Ještěd (Liberec), 
[14°59′05″,50°43′58″], kanál 43, výkon 50 kW
+T 722000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Ještěd (Liberec), 
[14°59′05″,50°43′58″], kanál 52, výkon 50 kW
+T 786000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+#   ^-- MUX 3 - Czech Digital Group, vysílač Ještěd (Liberec), 
[14°59′05″,50°43′58″], kanál 60, výkon 20 kW
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Loucovice_Krasna_pole
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Loucovice_Krasna_pole    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Loučovice Krásná pole
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 618000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Krásná pole (Loučovice), 
[14°14′18″,48°36′17″], kanál 39, výkon 10 W
+T 698000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Krásná pole (Loučovice), 
[14°14′18″,48°36′17″], kanál 49, výkon 10 W
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Luhacovice_Branka
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Luhacovice_Branka    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,12 @@
+# Czech Republic, Luhačovice Branka
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 570000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Branka (Luhačovice), 
[17°45′18″,49°05′50″], kanál 33, výkon 46 W
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Marianske_Lazne_Monty
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Marianske_Lazne_Monty    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Mariánské Lázně Monty
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 586000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Monty (Mariánské Lázně), 
[12°41′58″,49°58′06″], kanál 35, výkon 10 W
+T 594000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Monty (Mariánské Lázně), 
[12°41′58″,49°58′06″], kanál 36, výkon 10 W
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Mikulov_Devin
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Mikulov_Devin    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Mikulov Děvín
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 538000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Děvín (Mikulov), [16°39′01″,48°52′10″], 
kanál 29, výkon 25 kW
+T 626000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Děvín (Mikulov), 
[16°39′01″,48°52′10″], kanál 40, výkon 25 kW
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Nachod_Na_Vyhlidce
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Nachod_Na_Vyhlidce    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,12 @@
+# Czech Republic, Náchod Na Vyhlídce
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 586000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Na Vyhlídce (Náchod), 
[16°10′41″,50°24′17″], kanál 35, výkon 25 W
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Nachod_Vyhlidka
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Nachod_Vyhlidka    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,12 @@
+# Czech Republic, Náchod Vyhlídka
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 730000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Vyhlídka (Náchod), 
[16°10′41″,50°24′17″], kanál 53, výkon ?
diff -r 4030c51d6e7b -r 2bded15bc90c 
util/scan/dvb-t/cz-Namest_nad_Oslavou_ul_Zborovska
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Namest_nad_Oslavou_ul_Zborovska    Wed May 23 11:36:07 
2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Náměšť nad Oslavou ul. Zborovská
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 538000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač ul. Zborovská (Náměšť nad Oslavou), 
[16°08′56″,49°12′11″], kanál 29, výkon 10 W
+T 626000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač ul. Zborovská (Náměšť nad 
Oslavou), [16°08′56″,49°12′11″], kanál 40, výkon 10 W
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Nemanice_Vranovsky_vrch
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Nemanice_Vranovsky_vrch    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Nemanice Vranovský vrch
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 578000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Vranovský vrch (Nemanice), 
[12°43′49″,49°28′18″], kanál 34, výkon 10 W
+T 690000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Vranovský vrch (Nemanice), 
[12°43′49″,49°28′18″], kanál 48, výkon 10 W
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Novy_Hrozenkov_Humenec
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Novy_Hrozenkov_Humenec    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Nový Hrozenkov Humenec
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 570000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Humenec (Nový Hrozenkov), 
[18°12′42″,49°21′17″], kanál 33, výkon 25 W
+T 698000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Humenec (Nový Hrozenkov), 
[18°12′42″,49°21′17″], kanál 49, výkon 25 kW
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Nyrsko_Suchy_kamen
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Nyrsko_Suchy_kamen    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Nýrsko Suchý kámen
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 578000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Suchý kámen (Nýrsko), 
[13°07′50″,49°16′36″], kanál 34, výkon 10 W
+T 690000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Suchý kámen (Nýrsko), 
[13°07′50″,49°16′36″], kanál 48, výkon 10 W
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Okrouhlice_Vadin
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Okrouhlice_Vadin    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,12 @@
+# Czech Republic, Okrouhlice Vadín
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 738000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Vadín (Okrouhlice), 
[15°29′15″,49°38′15″], kanál 54, výkon 100 W
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Ostrava_Hladnov
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Ostrava_Hladnov    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,16 @@
+# Czech Republic, Ostrava Hladnov
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 602000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Hladnov (Ostrava), 
[18°18′19″,49°50′51″], kanál 37, výkon 10 kW
+T 690000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+#   ^-- MUX 3 - Czech Digital Group, vysílač Hladnov (Ostrava), 
[18°18′19″,49°50′51″], kanál 48, výkon 10 kW
+T 738000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Hladnov (Ostrava), 
[18°18′19″,49°50′51″], kanál 54, výkon 10 kW
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Ostrava_Hostalkovice
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Ostrava_Hostalkovice    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,16 @@
+# Czech Republic, Ostrava Hošťálkovice
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 602000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Hošťálkovice (Ostrava), 
[18°12′45″,49°51′41″], kanál 37, výkon 100 kW
+T 690000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+#   ^-- MUX 3 - Czech Digital Group, vysílač Hošťálkovice (Ostrava), 
[18°12′45″,49°51′41″], kanál 48, výkon 100 kW
+T 738000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Hošťálkovice (Ostrava), 
[18°12′45″,49°51′41″], kanál 54, výkon 14 kW
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Ostrava_ul_1_maje
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Ostrava_ul_1_maje    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,12 @@
+# Czech Republic, Ostrava ul. 1. máje
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 810000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+#   ^-- MUX 4 - Digital Broadcasting, vysílač ul. 1. máje (Ostrava), 
[18°15′32″,49°49′39″], kanál 63, výkon 0,81 kW
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Pardubice_Krasne
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Pardubice_Krasne    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,16 @@
+# Czech Republic, Pardubice Krásné
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 562000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Krásné (Pardubice), 
[15°44′15″,49°49′21″], kanál 32, výkon 25 kW
+T 578000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+#   ^-- MUX 3 - Czech Digital Group, vysílač Krásné (Pardubice), 
[15°44′15″,49°49′21″], kanál 34, výkon 10 kW (snížený)
+T 618000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Krásné (Pardubice), 
[15°44′15″,49°49′21″], kanál 39, výkon 25 kW
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Plzen_Krasov
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Plzen_Krasov    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,16 @@
+# Czech Republic, Plzeň Krašov
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 578000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Krašov (Plzeň), [13°04′46″,49°59′45″], 
kanál 34, výkon 100 kW
+T 690000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Krašov (Plzeň), 
[13°04′46″,49°59′45″], kanál 48, výkon 100 kW
+T 722000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+#   ^-- MUX 3 - Czech Digital Group, vysílač Krašov (Plzeň), 
[13°04′46″,49°59′45″], kanál 52, výkon 100 kW
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Praha_Cukrak
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Praha_Cukrak    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,16 @@
+# Czech Republic, Praha Cukrák
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 634000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Cukrák (Praha), 
[14°21′21″,49°56′12″], kanál 41, výkon 100 kW
+T 730000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Cukrák (Praha), [14°21′21″,49°56′12″], 
kanál 53, výkon 100 kW
+T 778000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+#   ^-- MUX 3 - Czech Digital Group, vysílač Cukrák (Praha), 
[14°21′21″,49°56′12″], kanál 59, výkon 100 kW
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Praha_UTB_Olsanska
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Praha_UTB_Olsanska    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,12 @@
+# Czech Republic, Praha ÚTB Olšanská
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 818000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+#   ^-- MUX 4 - Digital Broadcasting, vysílač ÚTB Olšanská (Praha), 
[14°28′09″,50°05′01″], kanál 64, výkon 2 kW
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Praha_Zizkov
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Praha_Zizkov    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,16 @@
+# Czech Republic, Praha Žižkov
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 634000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Žižkov (Praha), 
[14°27′04″,50°04′52″], kanál 41, výkon 32 kW
+T 730000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Žižkov (Praha), [14°27′04″,50°04′52″], 
kanál 53, výkon 32 kW
+T 778000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+#   ^-- MUX 3 - Czech Digital Group, vysílač Žižkov (Praha), 
[14°27′04″,50°04′52″], kanál 59, výkon 32 kW
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Pribram_Brezove_hory
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Pribram_Brezove_hory    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Příbram Březové hory
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 538000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Březové hory (Příbram), 
[13°59′49″,49°41′08″], kanál 29, výkon 10 W
+T 634000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Březové hory (Příbram), 
[13°59′49″,49°41′08″], kanál 41, výkon 10 W
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Pribram_Praha
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Pribram_Praha    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,12 @@
+# Czech Republic, Příbram Praha
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 538000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Praha (Příbram), [13°49′04″,49°39′30″], 
kanál 29, výkon 1 kW
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Rakovnik_ul_Okruzni
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Rakovnik_ul_Okruzni    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Rakovník ul. Okružní
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 578000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač ul. Okružní (Rakovník), 
[13°43′55″,50°05′43″], kanál 34, výkon 10 W
+T 690000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač ul. Okružní (Rakovník), 
[13°43′55″,50°05′43″], kanál 48, výkon 10 W
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Rotava_pod_hrbitovem
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Rotava_pod_hrbitovem    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Rotava pod hřbitovem
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 586000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač pod hřbitovem (Rotava), 
[12°34′09″,50°17′49″], kanál 35, výkon 5 W
+T 594000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač pod hřbitovem (Rotava), 
[12°34′09″,50°17′49″], kanál 36, výkon 5 W
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Sazava_Na_Vlkanaku
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Sazava_Na_Vlkanaku    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Sázava Na Vlkaňáku
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 634000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Na Vlkaňáku (Sázava), 
[14°53′31″,49°52′56″], kanál 41, výkon 10 W
+T 730000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Na Vlkaňáku (Sázava), 
[14°53′31″,49°52′56″], kanál 53, výkon 10 W
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Sluknov_vrch_Pytlak
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Sluknov_vrch_Pytlak    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Šluknov vrch Pytlák
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 570000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač vrch Pytlák (Šluknov), 
[14°30′34″,50°59′57″], kanál 33, výkon 20 W
+T 770000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač vrch Pytlák (Šluknov), 
[14°30′34″,50°59′57″], kanál 58, výkon 20 W
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Strani_Dubina
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Strani_Dubina    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,12 @@
+# Czech Republic, Strání Dubina
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 650000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Dubina (Strání), [17°40′56″,48°54′54″], 
kanál 43, výkon 25 W
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Susice_Svatobor
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Susice_Svatobor    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,16 @@
+# Czech Republic, Sušice Svatobor
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 690000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Svatobor (Sušice), 
[13°29′23″,49°14′06″], kanál 48, výkon 100 kW
+T 698000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Svatobor (Sušice), 
[13°29′23″,49°14′06″], kanál 49, výkon 100 kW
+T 722000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+#   ^-- MUX 3 - Czech Digital Group, vysílač Svatobor (Sušice), 
[13°29′23″,49°14′06″], kanál 52, výkon 100 kW
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Svitavy_Kamenna_Horka
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Svitavy_Kamenna_Horka    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Svitavy Kamenná Horka
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 538000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Kamenná Horka (Svitavy), 
[16°34′10″,49°44′22″], kanál 29, výkon 100 W
+T 618000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Kamenná Horka (Svitavy), 
[16°34′10″,49°44′22″], kanál 39, výkon 100 W
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Trebic_Strazny_vrch
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Trebic_Strazny_vrch    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Třebíč Strážný vrch
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 570000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Strážný vrch (Třebíč), 
[15°52′28″,49°12′36″], kanál 33, výkon 5 W
+T 586000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Strážný vrch (Třebíč), 
[15°52′28″,49°12′36″], kanál 35, výkon 5 W
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Trinec_Javorovy_vrch
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Trinec_Javorovy_vrch    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,10 @@
+# Czech Republic, Třinec Javorový vrch
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Trutnov_Cerna_hora
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Trutnov_Cerna_hora    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,16 @@
+# Czech Republic, Trutnov Černá hora
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 626000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Černá hora (Trutnov), 
[15°44′30″,50°39′09″], kanál 40, výkon 100 kW
+T 786000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+#   ^-- MUX 3 - Czech Digital Group, vysílač Černá hora (Trutnov), 
[15°44′30″,50°39′09″], kanál 60, výkon 100 kW
+T 794000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Černá hora (Trutnov), 
[15°44′30″,50°39′09″], kanál 61, výkon 100 kW
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Tyn_nad_Vltavou_Semenec
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Tyn_nad_Vltavou_Semenec    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Týn nad Vltavou Semenec
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 618000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Semenec (Týn nad Vltavou), 
[14°24′38″,49°14′00″], kanál 39, výkon 10 W
+T 698000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Semenec (Týn nad Vltavou), 
[14°24′38″,49°14′00″], kanál 49, výkon 10 W
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Usti_nL_Bukova_hora
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Usti_nL_Bukova_hora    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,16 @@
+# Czech Republic, Ústí n./L. Buková hora
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 570000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Buková hora (Ústí n./L.), 
[14°13′44″,50°40′19″], kanál 33, výkon 100 kW
+T 746000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+#   ^-- MUX 3 - Czech Digital Group, vysílač Buková hora (Ústí n./L.), 
[14°13′44″,50°40′19″], kanál 55, výkon 100 kW
+T 770000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Buková hora (Ústí n./L.), 
[14°13′44″,50°40′19″], kanál 58, výkon 100 kW
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Usti_nad_Labem_Vanov
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Usti_nad_Labem_Vanov    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Ústí nad Labem Vaňov
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 570000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Vaňov (Ústí nad Labem), 
[14°02′15″,50°38′41″], kanál 33, výkon 10 W
+T 770000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Vaňov (Ústí nad Labem), 
[14°02′15″,50°38′41″], kanál 58, výkon 10 W
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Usti_nad_Labem_Vetruse
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Usti_nad_Labem_Vetruse    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,12 @@
+# Czech Republic, Ústí nad Labem Větruše
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 730000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Větruše (Ústí nad Labem), 
[14°02′23″,50°39′18″], kanál 53, výkon 10 W
diff -r 4030c51d6e7b -r 2bded15bc90c 
util/scan/dvb-t/cz-Usti_nad_Orlici_Kubincuv_kopec
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Usti_nad_Orlici_Kubincuv_kopec    Wed May 23 11:36:07 
2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Ústí nad Orlicí Kubincův kopec
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 698000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Kubincův kopec (Ústí nad 
Orlicí), [16°22′40″,49°58′32″], kanál 49, výkon 2 W
+T 738000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Kubincův kopec (Ústí nad Orlicí), 
[16°22′40″,49°58′32″], kanál 54, výkon 10 W
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Valasske_Klobouky_Plostiny
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Valasske_Klobouky_Plostiny    Wed May 23 11:36:07 2012 
+0200
@@ -0,0 +1,14 @@
+# Czech Republic, Valašské Klobouky Ploštiny
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 570000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Ploštiny (Valašské Klobouky), 
[18°03′22″,49°08′20″], kanál 33, výkon 25 kW
+T 698000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Ploštiny (Valašské Klobouky), 
[18°03′22″,49°08′20″], kanál 49, výkon 25 kW
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Valasske_Mezirici_Radhost
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Valasske_Mezirici_Radhost    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Valašské Meziřičí Radhošť
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 602000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Radhošť (Valašské Meziřičí), 
[18°13′20″,49°29′31″], kanál 37, výkon 100 W
+T 738000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Radhošť (Valašské Meziřičí), 
[18°13′20″,49°29′31″], kanál 54, výkon 100 W
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Velke_Karlovice_Na_Kycerce
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Velke_Karlovice_Na_Kycerce    Wed May 23 11:36:07 2012 
+0200
@@ -0,0 +1,14 @@
+# Czech Republic, Velké Karlovice Na Kyčerce
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 602000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Na Kyčerce (Velké Karlovice), 
[18°17′09″,49°21′05″], kanál 37, výkon 12,5 W
+T 738000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Na Kyčerce (Velké Karlovice), 
[18°17′09″,49°21′05″], kanál 54, výkon 25 W
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Velke_Mezirici_Fajtuv_vrch
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Velke_Mezirici_Fajtuv_vrch    Wed May 23 11:36:07 2012 
+0200
@@ -0,0 +1,14 @@
+# Czech Republic, Velké Meziříčí Fajtův vrch
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 578000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Fajtův vrch (Velké Meziříčí), 
[16°01′27″,49°21′34″], kanál 34, výkon 10 W
+T 610000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Fajtův vrch (Velké Meziříčí), 
[16°01′27″,49°21′34″], kanál 38, výkon 10 W
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Velky_Senov_Jecny_vrch
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Velky_Senov_Jecny_vrch    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Velký Šenov Ječný vrch
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 570000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Ječný vrch (Velký Šenov), 
[14°19′26″,51°00′22″], kanál 33, výkon 20 W
+T 770000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Ječný vrch (Velký Šenov), 
[14°19′26″,51°00′22″], kanál 58, výkon 20 W
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Vimperk_Marsky_vrch
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Vimperk_Marsky_vrch    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Vimperk Mařský vrch
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 618000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Mařský vrch (Vimperk), 
[13°50′49″,49°04′20″], kanál 39, výkon 20 kW
+T 698000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Mařský vrch (Vimperk), 
[13°50′49″,49°04′20″], kanál 49, výkon 20 kW
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Volary_Horni_Snezna
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Volary_Horni_Snezna    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Volary Horní Sněžná
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 618000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Horní Sněžná (Volary), 
[13°56′06″,48°53′13″], kanál 39, výkon 20 W
+T 698000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Horní Sněžná (Volary), 
[13°56′06″,48°53′13″], kanál 49, výkon 20 W
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Votice_Mezivrata
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Votice_Mezivrata    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Votice Mezivrata
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 634000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Mezivrata (Votice), 
[14°40′16″,49°36′10″], kanál 41, výkon 32 kW
+T 730000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Mezivrata (Votice), 
[14°40′16″,49°36′10″], kanál 53, výkon 32 kW
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Vsetin_Becevna
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Vsetin_Becevna    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Vsetín Bečevná
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 738000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Bečevná (Vsetín), 
[17°59′32″,49°19′45″], kanál 54, výkon 20 W
+T 770000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Bečevná (Vsetín), 
[17°59′32″,49°19′45″], kanál 58, výkon 20 W
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Zamberk_Na_Rozarce
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Zamberk_Na_Rozarce    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Žamberk Na Rozárce
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 594000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Na Rozárce (Žamberk), 
[16°27′25″,50°05′16″], kanál 36, výkon 16 W
+T 698000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Na Rozárce (Žamberk), 
[16°27′25″,50°05′16″], kanál 49, výkon 16 W
diff -r 4030c51d6e7b -r 2bded15bc90c 
util/scan/dvb-t/cz-Zdar_nad_Sazavou_Harusuv_kopec
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Zdar_nad_Sazavou_Harusuv_kopec    Wed May 23 11:36:07 
2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Žďár nad Sázavou Harusův kopec
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 626000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Harusův kopec (Žďár nad 
Sázavou), [16°02′39″,49°34′21″], kanál 40, výkon 100 W
+T 698000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Harusův kopec (Žďár nad Sázavou), 
[16°02′39″,49°34′21″], kanál 49, výkon 100 W
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Zdikov_Novotnych_vrsek
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Zdikov_Novotnych_vrsek    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Zdíkov Novotných vršek
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 618000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Novotných vršek (Zdíkov), 
[13°41′23″,49°05′11″], kanál 39, výkon 10 W
+T 698000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Novotných vršek (Zdíkov), 
[13°41′23″,49°05′11″], kanál 49, výkon 10 W
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Zelezna_Ruda_Rozvodi
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Zelezna_Ruda_Rozvodi    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Železná Ruda Rozvodí
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 578000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Rozvodí (Železná Ruda), 
[13°11′52″,49°10′28″], kanál 34, výkon 10 W
+T 690000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Rozvodí (Železná Ruda), 
[13°11′52″,49°10′28″], kanál 48, výkon 10 W
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Zlate_Hory_Biskupska_kupa
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Zlate_Hory_Biskupska_kupa    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Zlaté Hory Biskupská kupa
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 594000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Biskupská kupa (Zlaté Hory), 
[17°25′45″,50°15′14″], kanál 36, výkon 20 W
+T 730000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Biskupská kupa (Zlaté Hory), 
[17°25′45″,50°15′14″], kanál 53, výkon 20 W
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Zlin_Tlusta_hora
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Zlin_Tlusta_hora    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,16 @@
+# Czech Republic, Zlín Tlustá hora
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 506000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+#   ^-- MUX 3 - Czech Digital Group, vysílač Tlustá hora (Zlín), 
[17°38′47″,49°12′30″], kanál 25, výkon 100 kW
+T 570000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Tlustá hora (Zlín), 
[17°38′47″,49°12′30″], kanál 33, výkon 100 kW
+T 698000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 2 - České Radiokomunikace, vysílač Tlustá hora (Zlín), 
[17°38′47″,49°12′30″], kanál 49, výkon 100 kW
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-Znojmo_Kravi_hora
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Znojmo_Kravi_hora    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,12 @@
+# Czech Republic, Znojmo Kraví hora
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 698000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+#   ^-- MUX 3 - Czech Digital Group, vysílač Kraví hora (Znojmo), 
[16°02′14″,48°50′46″], kanál 49, výkon 25 W
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-_Desna_III
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-_Desna_III    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic,  Desná III
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 570000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Desná III (), [15°21′07″,50°45′47″], 
kanál 33, výkon 3 W
+T 746000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+#   ^-- MUX 3 - Czech Digital Group, vysílač Desná III (), 
[15°21′07″,50°45′47″], kanál 55, výkon 4 W
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-_Dolni_Dobrouc
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-_Dolni_Dobrouc    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,12 @@
+# Czech Republic,  Dolní Dobrouč
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 738000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+#   ^-- MUX 1 - Česká televize, vysílač Dolní Dobrouč (), 
[16°30′03″,49°59′42″], kanál 54, výkon 22 W
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-_Holoubkov
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-_Holoubkov    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,12 @@
+# Czech Republic,  Holoubkov
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 746000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+#   ^-- MUX 3 - Czech Digital Group, vysílač Holoubkov (), 
[13°41′25″,49°46′32″], kanál 55, výkon 4 W
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-_Rokycany
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-_Rokycany    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,12 @@
+# Czech Republic,  Rokycany
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 722000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+#   ^-- MUX 3 - Czech Digital Group, vysílač Rokycany (), 
[13°35′34″,49°44′39″], kanál 52, výkon 2 W
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-_Strasice
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-_Strasice    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,12 @@
+# Czech Republic,  Strašice
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 746000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+#   ^-- MUX 3 - Czech Digital Group, vysílač Strašice (), 
[13°45′26″,49°44′04″], kanál 55, výkon 4 W
diff -r 4030c51d6e7b -r 2bded15bc90c util/scan/dvb-t/cz-_Zbiroh
--- /dev/null    Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-_Zbiroh    Wed May 23 11:36:07 2012 +0200
@@ -0,0 +1,12 @@
+# Czech Republic,  Zbiroh
+# Created from 
http://www.digizone.cz/texty/mapy-pokryti-multiplex-1-ceska-televize/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-2-radiokomunikace/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-3-czech-digital-group/
+# and http://www.digizone.cz/texty/mapy-pokryti-multiplex-4-telefonica-o2/
+# and 
http://www.ceskatelevize.cz/vse-o-ct/technika/digitalni-vysilani-dvb-obecne/kmitocty-televiznich-kanalu/
+# and http://www.digistranky.cz/dvbt/divaci/regiony/terminy-spousteni-dvb-t.html
+# and http://www.mapavysilacu.cz
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+
+T 778000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+#   ^-- MUX 3 - Czech Digital Group, vysílač Zbiroh (), [13°46′06″,49°51′26″], 
kanál 59, výkon 15 W

