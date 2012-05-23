Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:44907 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755014Ab2EWHoH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 03:44:07 -0400
Received: by wgbdr13 with SMTP id dr13so6853965wgb.1
        for <linux-media@vger.kernel.org>; Wed, 23 May 2012 00:44:05 -0700 (PDT)
Message-ID: <4FBC9542.2060609@smidovi.eu>
Date: Wed, 23 May 2012 09:44:02 +0200
From: David Smid <david@smidovi.eu>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH dvb-apps] Update/addition of Czech DVB-T scan files
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


This is an update of the outdated Czech initial scan files for DVB-T.
In case of problems with non-english characters in this mail message, you can 
also download this patch here:
http://david.smidovi.eu/scan_data_dvb-t_cz.patch
or here (scan files tarball):
http://david.smidovi.eu/dvbtgen.tar.gz

David Smid

---
# HG changeset patch
# User dsmid
# Date 1337757593 -7200
# Node ID ebce5e2f10bad804826fb2d03706e42fdfa82922
# Parent 4030c51d6e7baef760e65d4ff2e8f61af91bec02
Update/add czech dvb-t scan data

diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz--Multiplex_1
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz--Multiplex_1 Wed May 23 09:19:53 2012 +0200
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
+# ^-- MUX 1 - Česká televize, vysílač Barvičova (Brno), [16°34′47″,49°11′56″], 
kanál 29, výkon 10 kW
+# ^-- MUX 1 - Česká televize, vysílač Hády (Brno), [16°40′28″,49°13′22″], kanál 
29, výkon 10 kW
+# ^-- MUX 1 - Česká televize, vysílač Kojál (Brno), [16°48′58″,49°22′12″], 
kanál 29, výkon 100 kW
+# ^-- MUX 1 - Česká televize, vysílač Děvín (Mikulov), [16°39′01″,48°52′10″], 
kanál 29, výkon 25 kW
+# ^-- MUX 1 - Česká televize, vysílač Praha (Příbram), [13°49′04″,49°39′30″], 
kanál 29, výkon 1 kW
+# ^-- MUX 1 - Česká televize, vysílač Březové hory (Příbram), 
[13°59′49″,49°41′08″], kanál 29, výkon 10 W
+# ^-- MUX 1 - Česká televize, vysílač Kamenná Horka (Svitavy), 
[16°34′10″,49°44′22″], kanál 29, výkon 100 W
+# ^-- MUX 1 - Česká televize, vysílač ul. Zborovská (Náměšť nad Oslavou), 
[16°08′56″,49°12′11″], kanál 29, výkon 10 W
+# ^-- MUX 1 - Česká televize, vysílač U Sivků (Huslenky), 
[18°05′48″,49°19′20″], kanál 29, výkon 25 W
+# ^-- MUX 1 - Česká televize, vysílač Čížovky (Boskovice), 
[16°40′43″,49°29′17″], kanál 29, výkon 10 W
+# ^-- MUX 1 - Česká televize, vysílač Strážnice (Jablonné nad Orlicí), 
[16°35′34″,50°01′59″], kanál 29, výkon 10 W
+T 562000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 1 - Česká televize, vysílač Krásné (Pardubice), 
[15°44′15″,49°49′21″], kanál 32, výkon 25 kW
+# ^-- MUX 1 - Česká televize, vysílač Olešná (Blansko), [16°38′41″,49°20′24″], 
kanál 32, výkon 20 W
+# ^-- MUX 1 - Česká televize, vysílač ul. Údolní (Havlíčkův Brod), 
[15°34′44″,49°35′49″], kanál 32, výkon 10 W
+T 570000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 1 - Česká televize, vysílač Buková hora (Ústí n./L.), 
[14°13′44″,50°40′19″], kanál 33, výkon 100 kW
+# ^-- MUX 1 - Česká televize, vysílač Desná III (), [15°21′07″,50°45′47″], 
kanál 33, výkon 3 W
+# ^-- MUX 1 - Česká televize, vysílač Jedlová hora (Chomutov), 
[13°27′43″,50°32′55″], kanál 33, výkon 32 kW
+# ^-- MUX 1 - Česká televize, vysílač Javořice (Jihlava), 
[15°20′22″,49°14′17″], kanál 33, výkon 100 kW
+# ^-- MUX 1 - Česká televize, vysílač Tlustá hora (Zlín), 
[17°38′47″,49°12′30″], kanál 33, výkon 100 kW
+# ^-- MUX 1 - Česká televize, vysílač Ploštiny (Valašské Klobouky), 
[18°03′22″,49°08′20″], kanál 33, výkon 25 kW
+# ^-- MUX 1 - Česká televize, vysílač Vaňov (Ústí nad Labem), 
[14°02′15″,50°38′41″], kanál 33, výkon 10 W
+# ^-- MUX 1 - Česká televize, vysílač Popovický vrch (Děčín), 
[14°10′33″,50°46′11″], kanál 33, výkon 20 W
+# ^-- MUX 1 - Česká televize, vysílač Ječný vrch (Velký Šenov), 
[14°19′26″,51°00′22″], kanál 33, výkon 20 W
+# ^-- MUX 1 - Česká televize, vysílač vrch Pytlák (Šluknov), 
[14°30′34″,50°59′57″], kanál 33, výkon 20 W
+# ^-- MUX 1 - Česká televize, vysílač Hřebenáč (Jindřichovice pod Smrkem), 
[15°14′26″,50°56′18″], kanál 33, výkon 10 W
+# ^-- MUX 1 - Česká televize, vysílač Strážný vrch (Třebíč), 
[15°52′28″,49°12′36″], kanál 33, výkon 5 W
+# ^-- MUX 1 - Česká televize, vysílač Humenec (Nový Hrozenkov), 
[18°12′42″,49°21′17″], kanál 33, výkon 25 W
+# ^-- MUX 1 - Česká televize, vysílač Branka (Luhačovice), 
[17°45′18″,49°05′50″], kanál 33, výkon 46 W
+# ^-- MUX 1 - Česká televize, vysílač Rokštejnská (Brtnice), 
[15°41′07″,49°18′14″], kanál 33, výkon 10 W
+T 578000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 1 - Česká televize, vysílač Krašov (Plzeň), [13°04′46″,49°59′45″], 
kanál 34, výkon 100 kW
+# ^-- MUX 1 - Česká televize, vysílač Vraní vrch (Domažlice), 
[12°46′41″,49°28′21″], kanál 34, výkon 10 kW
+# ^-- MUX 1 - Česká televize, vysílač Vranovský vrch (Nemanice), 
[12°43′49″,49°28′18″], kanál 34, výkon 10 W
+# ^-- MUX 1 - Česká televize, vysílač Suchý kámen (Nýrsko), 
[13°07′50″,49°16′36″], kanál 34, výkon 10 W
+# ^-- MUX 1 - Česká televize, vysílač Rozvodí (Železná Ruda), 
[13°11′52″,49°10′28″], kanál 34, výkon 10 W
+# ^-- MUX 1 - Česká televize, vysílač Fajtův vrch (Velké Meziříčí), 
[16°01′27″,49°21′34″], kanál 34, výkon 10 W
+# ^-- MUX 1 - Česká televize, vysílač ul. Okružní (Rakovník), 
[13°43′55″,50°05′43″], kanál 34, výkon 10 W
+T 594000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 1 - Česká televize, vysílač Zelená hora (Cheb), 
[12°18′29″,50°04′10″], kanál 36, výkon 20 kW
+# ^-- MUX 1 - Česká televize, vysílač Háj (Aš), [12°12′04″,50°14′01″], kanál 
36, výkon 50 W
+# ^-- MUX 1 - Česká televize, vysílač Klínovec (Jáchymov), 
[12°58′04″,50°23′49″], kanál 36, výkon 50 kW
+# ^-- MUX 1 - Česká televize, vysílač Monty (Mariánské Lázně), 
[12°41′58″,49°58′06″], kanál 36, výkon 10 W
+# ^-- MUX 1 - Česká televize, vysílač pod hřbitovem (Rotava), 
[12°34′09″,50°17′49″], kanál 36, výkon 5 W
+# ^-- MUX 1 - Česká televize, vysílač Sněžná (Kraslice), [12°30′20″,50°18′41″], 
kanál 36, výkon 10 W
+# ^-- MUX 1 - Česká televize, vysílač Tři kříže (Karlovy Vary), 
[12°53′12″,50°13′39″], kanál 36, výkon 25 W
+# ^-- MUX 1 - Česká televize, vysílač Praděd (Jeseník), [17°13′52″,50°04′59″], 
kanál 36, výkon 100 kW
+# ^-- MUX 1 - Česká televize, vysílač Biskupská kupa (Zlaté Hory), 
[17°25′45″,50°15′14″], kanál 36, výkon 20 W
+# ^-- MUX 1 - Česká televize, vysílač Na Rozárce (Žamberk), 
[16°27′25″,50°05′16″], kanál 36, výkon 16 W
+# ^-- MUX 1 - Česká televize, vysílač Jírová hora (Hronov), 
[16°10′32″,50°29′14″], kanál 36, výkon 10 W
+# ^-- MUX 1 - Česká televize, vysílač Zlatý Chlum (Jeseník), 
[17°14′15″,50°14′17″], kanál 36, výkon 100 W
+T 626000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 1 - Česká televize, vysílač Černá hora (Trutnov), 
[15°44′30″,50°39′09″], kanál 40, výkon 100 kW
+# ^-- MUX 1 - Česká televize, vysílač u nádraží (Horní Lipová), 
[17°04′58″,50°13′33″], kanál 40, výkon ?
+# ^-- MUX 1 - Česká televize, vysílač Hvězda (Broumov), [16°15′57″,50°34′04″], 
kanál 40, výkon 25 W
+T 650000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 1 - Česká televize, vysílač Ještěd (Liberec), [14°59′05″,50°43′58″], 
kanál 43, výkon 50 kW
+# ^-- MUX 1 - Česká televize, vysílač U rozhledny (Frýdlant v Čechách), 
[15°04′34″,50°56′07″], kanál 43, výkon 25 W
+# ^-- MUX 1 - Česká televize, vysílač Dubina (Strání), [17°40′56″,48°54′54″], 
kanál 43, výkon 25 W
+# ^-- MUX 1 - Česká televize, vysílač Suchý vrch (Králíky), 
[16°41′21″,50°03′07″], kanál 43, výkon 50 W
+# ^-- MUX 1 - Česká televize, vysílač Pálenisko (Jablůnka), 
[17°58′27″,49°24′09″], kanál 43, výkon 5 W
+T 698000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 1 - Česká televize, vysílač Kleť (České Budějovice), 
[14°16′53″,48°52′03″], kanál 49, výkon 100 kW
+# ^-- MUX 1 - Česká televize, vysílač Svatobor (Sušice), [13°29′23″,49°14′06″], 
kanál 49, výkon 100 kW
+# ^-- MUX 1 - Česká televize, vysílač Mařský vrch (Vimperk), 
[13°50′49″,49°04′20″], kanál 49, výkon 20 kW
+# ^-- MUX 1 - Česká televize, vysílač Horní Sněžná (Volary), 
[13°56′06″,48°53′13″], kanál 49, výkon 20 W
+# ^-- MUX 1 - Česká televize, vysílač Krásná pole (Loučovice), 
[14°14′18″,48°36′17″], kanál 49, výkon 10 W
+# ^-- MUX 1 - Česká televize, vysílač Novotných vršek (Zdíkov), 
[13°41′23″,49°05′11″], kanál 49, výkon 10 W
+# ^-- MUX 1 - Česká televize, vysílač Semenec (Týn nad Vltavou), 
[14°24′38″,49°14′00″], kanál 49, výkon 10 W
+# ^-- MUX 1 - Česká televize, vysílač Šeptouchov (Ledeč nad Sázavou), 
[15°16′06″,49°41′43″], kanál 49, výkon 13 W
+# ^-- MUX 1 - Česká televize, vysílač Harusův kopec (Žďár nad Sázavou), 
[16°02′39″,49°34′21″], kanál 49, výkon 100 W
+T 730000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 1 - Česká televize, vysílač Cukrák (Praha), [14°21′21″,49°56′12″], 
kanál 53, výkon 100 kW
+# ^-- MUX 1 - Česká televize, vysílač Žižkov (Praha), [14°27′04″,50°04′52″], 
kanál 53, výkon 32 kW
+# ^-- MUX 1 - Česká televize, vysílač Mezivrata (Votice), 
[14°40′16″,49°36′10″], kanál 53, výkon 32 kW
+# ^-- MUX 1 - Česká televize, vysílač nad hřbitovem (Jince), 
[13°58′18″,49°46′58″], kanál 53, výkon 10 W
+# ^-- MUX 1 - Česká televize, vysílač Na Vrážích (Husinec), 
[13°58′36″,49°03′21″], kanál 53, výkon 10 W
+# ^-- MUX 1 - Česká televize, vysílač Komorní Hrádek (Chocerady), 
[14°47′53″,49°52′06″], kanál 53, výkon 5 W
+# ^-- MUX 1 - Česká televize, vysílač Na Vlkaňáku (Sázava), 
[14°53′31″,49°52′56″], kanál 53, výkon 10 W
+# ^-- MUX 1 - Česká televize, vysílač Vyhlídka (Náchod), [16°10′41″,50°24′17″], 
kanál 53, výkon ?
+# ^-- MUX 1 - Česká televize, vysílač Větruše (Ústí nad Labem), 
[14°02′23″,50°39′18″], kanál 53, výkon 10 W
+T 738000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 1 - Česká televize, vysílač Hladnov (Ostrava), [18°18′19″,49°50′51″], 
kanál 54, výkon 10 kW
+# ^-- MUX 1 - Česká televize, vysílač Hošťálkovice (Ostrava), 
[18°12′45″,49°51′41″], kanál 54, výkon 14 kW
+# ^-- MUX 1 - Česká televize, vysílač Lysá hora (Frýdek-Místek), 
[18°26′56″,49°32′47″], kanál 54, výkon 25 kW
+# ^-- MUX 1 - Česká televize, vysílač Radhošť (Valašské Meziřičí), 
[18°13′20″,49°29′31″], kanál 54, výkon 100 W
+# ^-- MUX 1 - Česká televize, vysílač Bečevná (Vsetín), [17°59′32″,49°19′45″], 
kanál 54, výkon 20 W
+# ^-- MUX 1 - Česká televize, vysílač Na Kyčerce (Velké Karlovice), 
[18°17′09″,49°21′05″], kanál 54, výkon 25 W
+# ^-- MUX 1 - Česká televize, vysílač nad ZD (Letohrad), [16°31′32″,50°01′56″], 
kanál 54, výkon 10 W
+# ^-- MUX 1 - Česká televize, vysílač Dolní Dobrouč (), [16°30′03″,49°59′42″], 
kanál 54, výkon 22 W
+# ^-- MUX 1 - Česká televize, vysílač Vadín (Okrouhlice), 
[15°29′15″,49°38′15″], kanál 54, výkon 100 W
+# ^-- MUX 1 - Česká televize, vysílač Gagarinova (Hlubočky), 
[17°24′00″,49°37′26″], kanál 54, výkon 22 W
+# ^-- MUX 1 - Česká televize, vysílač Kubincův kopec (Ústí nad Orlicí), 
[16°22′40″,49°58′32″], kanál 54, výkon 10 W
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz--Multiplex_2
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz--Multiplex_2 Wed May 23 09:19:53 2012 +0200
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
+# ^-- MUX 2 - České Radiokomunikace, vysílač Tři kříže (Karlovy Vary), 
[12°53′12″,50°13′39″], kanál 35, výkon 25 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač Háj (Aš), [12°12′04″,50°14′01″], 
kanál 35, výkon 50 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač Monty (Mariánské Lázně), 
[12°41′58″,49°58′06″], kanál 35, výkon 10 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač Sněžná (Kraslice), 
[12°30′20″,50°18′41″], kanál 35, výkon 10 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač pod hřbitovem (Rotava), 
[12°34′09″,50°17′49″], kanál 35, výkon 5 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač Javořice (Jihlava), 
[15°20′22″,49°14′17″], kanál 35, výkon 100 kW
+# ^-- MUX 2 - České Radiokomunikace, vysílač Strážný vrch (Třebíč), 
[15°52′28″,49°12′36″], kanál 35, výkon 5 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač nad ZD (Letohrad), 
[16°31′32″,50°01′56″], kanál 35, výkon 10 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač Na Vyhlídce (Náchod), 
[16°10′41″,50°24′17″], kanál 35, výkon 25 W
+T 602000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač Hošťálkovice (Ostrava), 
[18°12′45″,49°51′41″], kanál 37, výkon 100 kW
+# ^-- MUX 2 - České Radiokomunikace, vysílač Hladnov (Ostrava), 
[18°18′19″,49°50′51″], kanál 37, výkon 10 kW
+# ^-- MUX 2 - České Radiokomunikace, vysílač Lysá hora (Frýdek-Místek), 
[18°26′56″,49°32′47″], kanál 37, výkon 25 kW
+# ^-- MUX 2 - České Radiokomunikace, vysílač Jírová hora (Hronov), 
[16°10′32″,50°29′14″], kanál 37, výkon 10 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač Radhošť (Valašské Meziřičí), 
[18°13′20″,49°29′31″], kanál 37, výkon 100 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač Na Kyčerce (Velké Karlovice), 
[18°17′09″,49°21′05″], kanál 37, výkon 12,5 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač Strážnice (Jablonné nad Orlicí), 
[16°35′34″,50°01′59″], kanál 37, výkon 10 W
+T 610000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač Šeptouchov (Ledeč nad Sázavou), 
[15°16′06″,49°41′43″], kanál 38, výkon 10 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač Fajtův vrch (Velké Meziříčí), 
[16°01′27″,49°21′34″], kanál 38, výkon 10 W
+T 618000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač Kleť (České Budějovice), 
[14°16′53″,48°52′03″], kanál 39, výkon 100 kW
+# ^-- MUX 2 - České Radiokomunikace, vysílač Mařský vrch (Vimperk), 
[13°50′49″,49°04′20″], kanál 39, výkon 20 kW
+# ^-- MUX 2 - České Radiokomunikace, vysílač Krásné (Pardubice), 
[15°44′15″,49°49′21″], kanál 39, výkon 25 kW
+# ^-- MUX 2 - České Radiokomunikace, vysílač Horní Sněžná (Volary), 
[13°56′06″,48°53′13″], kanál 39, výkon 20 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač Krásná pole (Loučovice), 
[14°14′18″,48°36′17″], kanál 39, výkon 10 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač Novotných vršek (Zdíkov), 
[13°41′23″,49°05′11″], kanál 39, výkon 10 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač Semenec (Týn nad Vltavou), 
[14°24′38″,49°14′00″], kanál 39, výkon 10 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač Olešná (Blansko), 
[16°38′41″,49°20′24″], kanál 39, výkon 20 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač ul. Údolní (Havlíčkův Brod), 
[15°34′44″,49°35′49″], kanál 39, výkon 10 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač Kamenná Horka (Svitavy), 
[16°34′10″,49°44′22″], kanál 39, výkon 100 W
+T 626000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač Hády (Brno), 
[16°40′28″,49°13′22″], kanál 40, výkon 10 kW
+# ^-- MUX 2 - České Radiokomunikace, vysílač Barvičova (Brno), 
[16°34′47″,49°11′56″], kanál 40, výkon 10 kW
+# ^-- MUX 2 - České Radiokomunikace, vysílač Děvín (Mikulov), 
[16°39′01″,48°52′10″], kanál 40, výkon 25 kW
+# ^-- MUX 2 - České Radiokomunikace, vysílač Kojál (Brno), 
[16°48′58″,49°22′12″], kanál 40, výkon 100 kW
+# ^-- MUX 2 - České Radiokomunikace, vysílač Harusův kopec (Žďár nad Sázavou), 
[16°02′39″,49°34′21″], kanál 40, výkon 100 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač ul. Zborovská (Náměšť nad 
Oslavou), [16°08′56″,49°12′11″], kanál 40, výkon 10 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač Čížovky (Boskovice), 
[16°40′43″,49°29′17″], kanál 40, výkon 10 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač U Sivků (Huslenky), 
[18°05′48″,49°19′20″], kanál 40, výkon 25 W
+T 634000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač Žižkov (Praha), 
[14°27′04″,50°04′52″], kanál 41, výkon 32 kW
+# ^-- MUX 2 - České Radiokomunikace, vysílač Cukrák (Praha), 
[14°21′21″,49°56′12″], kanál 41, výkon 100 kW
+# ^-- MUX 2 - České Radiokomunikace, vysílač Mezivrata (Votice), 
[14°40′16″,49°36′10″], kanál 41, výkon 32 kW
+# ^-- MUX 2 - České Radiokomunikace, vysílač Březové hory (Příbram), 
[13°59′49″,49°41′08″], kanál 41, výkon 10 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač nad hřbitovem (Jince), 
[13°58′18″,49°46′58″], kanál 41, výkon 10 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač Na Vrážích (Husinec), 
[13°58′36″,49°03′21″], kanál 41, výkon 10 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač Komorní Hrádek (Chocerady), 
[14°47′53″,49°52′06″], kanál 41, výkon 5 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač Na Vlkaňáku (Sázava), 
[14°53′31″,49°52′56″], kanál 41, výkon 10 W
+T 690000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač Krašov (Plzeň), 
[13°04′46″,49°59′45″], kanál 48, výkon 100 kW
+# ^-- MUX 2 - České Radiokomunikace, vysílač Vraní vrch (Domažlice), 
[12°46′41″,49°28′21″], kanál 48, výkon 10 kW
+# ^-- MUX 2 - České Radiokomunikace, vysílač Vranovský vrch (Nemanice), 
[12°43′49″,49°28′18″], kanál 48, výkon 10 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač Svatobor (Sušice), 
[13°29′23″,49°14′06″], kanál 48, výkon 100 kW
+# ^-- MUX 2 - České Radiokomunikace, vysílač Suchý kámen (Nýrsko), 
[13°07′50″,49°16′36″], kanál 48, výkon 10 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač Rozvodí (Železná Ruda), 
[13°11′52″,49°10′28″], kanál 48, výkon 10 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač ul. Okružní (Rakovník), 
[13°43′55″,50°05′43″], kanál 48, výkon 10 W
+T 698000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač Na Rozárce (Žamberk), 
[16°27′25″,50°05′16″], kanál 49, výkon 16 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač Kubincův kopec (Ústí nad Orlicí), 
[16°22′40″,49°58′32″], kanál 49, výkon 2 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač Tlustá hora (Zlín), 
[17°38′47″,49°12′30″], kanál 49, výkon 100 kW
+# ^-- MUX 2 - České Radiokomunikace, vysílač Ploštiny (Valašské Klobouky), 
[18°03′22″,49°08′20″], kanál 49, výkon 25 kW
+# ^-- MUX 2 - České Radiokomunikace, vysílač Pálenisko (Jablůnka), 
[17°58′27″,49°24′09″], kanál 49, výkon 10 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač Humenec (Nový Hrozenkov), 
[18°12′42″,49°21′17″], kanál 49, výkon 25 kW
+T 722000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač Ještěd (Liberec), 
[14°59′05″,50°43′58″], kanál 52, výkon 50 kW
+# ^-- MUX 2 - České Radiokomunikace, vysílač U rozhledny (Frýdlant v Čechách), 
[15°04′34″,50°56′07″], kanál 52, výkon 25 W
+T 730000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač Praděd (Jeseník), 
[17°13′52″,50°04′59″], kanál 53, výkon 100 kW
+# ^-- MUX 2 - České Radiokomunikace, vysílač Biskupská kupa (Zlaté Hory), 
[17°25′45″,50°15′14″], kanál 53, výkon 20 W
+T 770000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač Buková hora (Ústí n./L.), 
[14°13′44″,50°40′19″], kanál 58, výkon 100 kW
+# ^-- MUX 2 - České Radiokomunikace, vysílač Jedlová hora (Chomutov), 
[13°27′43″,50°32′55″], kanál 58, výkon 32 kW
+# ^-- MUX 2 - České Radiokomunikace, vysílač Vaňov (Ústí nad Labem), 
[14°02′15″,50°38′41″], kanál 58, výkon 10 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač Popovický vrch (Děčín), 
[14°10′33″,50°46′11″], kanál 58, výkon 20 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač Ječný vrch (Velký Šenov), 
[14°19′26″,51°00′22″], kanál 58, výkon 20 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač vrch Pytlák (Šluknov), 
[14°30′34″,50°59′57″], kanál 58, výkon 20 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač Hřebenáč (Jindřichovice pod 
Smrkem), [15°14′26″,50°56′18″], kanál 58, výkon 10 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač Lázně Libverda nad hřbitovem 
(Hejnice), [15°13′17″,50°53′15″], kanál 58, výkon 10 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač Bečevná (Vsetín), 
[17°59′32″,49°19′45″], kanál 58, výkon 20 W
+T 794000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač Černá hora (Trutnov), 
[15°44′30″,50°39′09″], kanál 61, výkon 100 kW
+T 834000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač Zelená hora (Cheb), 
[12°18′29″,50°04′10″], kanál 66, výkon 20 kW
+# ^-- MUX 2 - České Radiokomunikace, vysílač Klínovec (Jáchymov), 
[12°58′04″,50°23′49″], kanál 66, výkon 50 kW
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz--Multiplex_3
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz--Multiplex_3 Wed May 23 09:19:53 2012 +0200
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
+# ^-- MUX 3 - Czech Digital Group, vysílač Kleť (České Budějovice), 
[14°16′53″,48°52′03″], kanál 22, výkon 100 kW
+T 506000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+# ^-- MUX 3 - Czech Digital Group, vysílač Tlustá hora (Zlín), 
[17°38′47″,49°12′30″], kanál 25, výkon 100 kW
+T 546000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+# ^-- MUX 3 - Czech Digital Group, vysílač Javořice (Jihlava), 
[15°20′22″,49°14′17″], kanál 30, výkon 100 kW
+T 578000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+# ^-- MUX 3 - Czech Digital Group, vysílač Krásné (Pardubice), 
[15°44′15″,49°49′21″], kanál 34, výkon 10 kW (snížený)
+T 690000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+# ^-- MUX 3 - Czech Digital Group, vysílač Hošťálkovice (Ostrava), 
[18°12′45″,49°51′41″], kanál 48, výkon 100 kW
+# ^-- MUX 3 - Czech Digital Group, vysílač Hladnov (Ostrava), 
[18°18′19″,49°50′51″], kanál 48, výkon 10 kW
+T 698000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+# ^-- MUX 3 - Czech Digital Group, vysílač Kraví hora (Znojmo), 
[16°02′14″,48°50′46″], kanál 49, výkon 25 W
+T 714000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+# ^-- MUX 3 - Czech Digital Group, vysílač Praděd (Jeseník), 
[17°13′52″,50°04′59″], kanál 51, výkon 100 kW
+T 722000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+# ^-- MUX 3 - Czech Digital Group, vysílač Krašov (Plzeň), 
[13°04′46″,49°59′45″], kanál 52, výkon 100 kW
+# ^-- MUX 3 - Czech Digital Group, vysílač Svatobor (Sušice), 
[13°29′23″,49°14′06″], kanál 52, výkon 100 kW
+# ^-- MUX 3 - Czech Digital Group, vysílač Rokycany (), [13°35′34″,49°44′39″], 
kanál 52, výkon 2 W
+T 746000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+# ^-- MUX 3 - Czech Digital Group, vysílač Buková hora (Ústí n./L.), 
[14°13′44″,50°40′19″], kanál 55, výkon 100 kW
+# ^-- MUX 3 - Czech Digital Group, vysílač Desná III (), [15°21′07″,50°45′47″], 
kanál 55, výkon 4 W
+# ^-- MUX 3 - Czech Digital Group, vysílač Holoubkov (), [13°41′25″,49°46′32″], 
kanál 55, výkon 4 W
+# ^-- MUX 3 - Czech Digital Group, vysílač Strašice (), [13°45′26″,49°44′04″], 
kanál 55, výkon 4 W
+T 778000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+# ^-- MUX 3 - Czech Digital Group, vysílač Žižkov (Praha), 
[14°27′04″,50°04′52″], kanál 59, výkon 32 kW
+# ^-- MUX 3 - Czech Digital Group, vysílač Cukrák (Praha), 
[14°21′21″,49°56′12″], kanál 59, výkon 100 kW
+# ^-- MUX 3 - Czech Digital Group, vysílač Hády (Brno), [16°40′28″,49°13′22″], 
kanál 59, výkon 10 kW
+# ^-- MUX 3 - Czech Digital Group, vysílač Barvičova (Brno), 
[16°34′47″,49°11′56″], kanál 59, výkon 10 kW
+# ^-- MUX 3 - Czech Digital Group, vysílač Zbiroh (), [13°46′06″,49°51′26″], 
kanál 59, výkon 15 W
+# ^-- MUX 3 - Czech Digital Group, vysílač Kojál (Brno), [16°48′58″,49°22′12″], 
kanál 59, výkon 100 kW
+T 786000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+# ^-- MUX 3 - Czech Digital Group, vysílač Černá hora (Trutnov), 
[15°44′30″,50°39′09″], kanál 60, výkon 100 kW
+# ^-- MUX 3 - Czech Digital Group, vysílač Tři kříže (Karlovy Vary), 
[12°53′12″,50°13′39″], kanál 60, výkon 25 W
+# ^-- MUX 3 - Czech Digital Group, vysílač Ještěd (Liberec), 
[14°59′05″,50°43′58″], kanál 60, výkon 20 kW
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz--Multiplex_4
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz--Multiplex_4 Wed May 23 09:19:53 2012 +0200
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
+# ^-- MUX 4 - Digital Broadcasting, vysílač 1. máje (Ostrava), 
[18°15′32″,49°49′39″], kanál 63, výkon 0,81 kW
+T 818000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+# ^-- MUX 4 - Digital Broadcasting, vysílač ÚTB Olšanská (Praha), 
[14°28′09″,50°05′01″], kanál 64, výkon 2 kW
+# ^-- MUX 4 - Digital Broadcasting, vysílač FN Bohunice (Brno), 
[16°34′14″,49°10′33″], kanál 64, výkon 2 kW
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-1_maje_Ostrava
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-1_maje_Ostrava Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,12 @@
+# Czech Republic, 1. máje Ostrava
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
+# ^-- MUX 4 - Digital Broadcasting, vysílač 1. máje (Ostrava), 
[18°15′32″,49°49′39″], kanál 63, výkon 0,81 kW
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-All
--- a/util/scan/dvb-t/cz-All Tue Apr 10 16:44:06 2012 +0200
+++ b/util/scan/dvb-t/cz-All Wed May 23 09:19:53 2012 +0200
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
+# ^-- MUX 3 - Czech Digital Group, vysílač Kleť (České Budějovice), 
[14°16′53″,48°52′03″], kanál 22, výkon 100 kW
+T 506000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+# ^-- MUX 3 - Czech Digital Group, vysílač Tlustá hora (Zlín), 
[17°38′47″,49°12′30″], kanál 25, výkon 100 kW
T 538000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
-T 546000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 1 - Česká televize, vysílač Barvičova (Brno), [16°34′47″,49°11′56″], 
kanál 29, výkon 10 kW
+# ^-- MUX 1 - Česká televize, vysílač Hády (Brno), [16°40′28″,49°13′22″], kanál 
29, výkon 10 kW
+# ^-- MUX 1 - Česká televize, vysílač Kojál (Brno), [16°48′58″,49°22′12″], 
kanál 29, výkon 100 kW
+# ^-- MUX 1 - Česká televize, vysílač Děvín (Mikulov), [16°39′01″,48°52′10″], 
kanál 29, výkon 25 kW
+# ^-- MUX 1 - Česká televize, vysílač Praha (Příbram), [13°49′04″,49°39′30″], 
kanál 29, výkon 1 kW
+# ^-- MUX 1 - Česká televize, vysílač Březové hory (Příbram), 
[13°59′49″,49°41′08″], kanál 29, výkon 10 W
+# ^-- MUX 1 - Česká televize, vysílač Kamenná Horka (Svitavy), 
[16°34′10″,49°44′22″], kanál 29, výkon 100 W
+# ^-- MUX 1 - Česká televize, vysílač ul. Zborovská (Náměšť nad Oslavou), 
[16°08′56″,49°12′11″], kanál 29, výkon 10 W
+# ^-- MUX 1 - Česká televize, vysílač U Sivků (Huslenky), 
[18°05′48″,49°19′20″], kanál 29, výkon 25 W
+# ^-- MUX 1 - Česká televize, vysílač Čížovky (Boskovice), 
[16°40′43″,49°29′17″], kanál 29, výkon 10 W
+# ^-- MUX 1 - Česká televize, vysílač Strážnice (Jablonné nad Orlicí), 
[16°35′34″,50°01′59″], kanál 29, výkon 10 W
+T 546000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+# ^-- MUX 3 - Czech Digital Group, vysílač Javořice (Jihlava), 
[15°20′22″,49°14′17″], kanál 30, výkon 100 kW
T 562000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 1 - Česká televize, vysílač Krásné (Pardubice), 
[15°44′15″,49°49′21″], kanál 32, výkon 25 kW
+# ^-- MUX 1 - Česká televize, vysílač Olešná (Blansko), [16°38′41″,49°20′24″], 
kanál 32, výkon 20 W
+# ^-- MUX 1 - Česká televize, vysílač ul. Údolní (Havlíčkův Brod), 
[15°34′44″,49°35′49″], kanál 32, výkon 10 W
T 570000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 1 - Česká televize, vysílač Buková hora (Ústí n./L.), 
[14°13′44″,50°40′19″], kanál 33, výkon 100 kW
+# ^-- MUX 1 - Česká televize, vysílač Desná III (), [15°21′07″,50°45′47″], 
kanál 33, výkon 3 W
+# ^-- MUX 1 - Česká televize, vysílač Jedlová hora (Chomutov), 
[13°27′43″,50°32′55″], kanál 33, výkon 32 kW
+# ^-- MUX 1 - Česká televize, vysílač Javořice (Jihlava), 
[15°20′22″,49°14′17″], kanál 33, výkon 100 kW
+# ^-- MUX 1 - Česká televize, vysílač Tlustá hora (Zlín), 
[17°38′47″,49°12′30″], kanál 33, výkon 100 kW
+# ^-- MUX 1 - Česká televize, vysílač Ploštiny (Valašské Klobouky), 
[18°03′22″,49°08′20″], kanál 33, výkon 25 kW
+# ^-- MUX 1 - Česká televize, vysílač Vaňov (Ústí nad Labem), 
[14°02′15″,50°38′41″], kanál 33, výkon 10 W
+# ^-- MUX 1 - Česká televize, vysílač Popovický vrch (Děčín), 
[14°10′33″,50°46′11″], kanál 33, výkon 20 W
+# ^-- MUX 1 - Česká televize, vysílač Ječný vrch (Velký Šenov), 
[14°19′26″,51°00′22″], kanál 33, výkon 20 W
+# ^-- MUX 1 - Česká televize, vysílač vrch Pytlák (Šluknov), 
[14°30′34″,50°59′57″], kanál 33, výkon 20 W
+# ^-- MUX 1 - Česká televize, vysílač Hřebenáč (Jindřichovice pod Smrkem), 
[15°14′26″,50°56′18″], kanál 33, výkon 10 W
+# ^-- MUX 1 - Česká televize, vysílač Strážný vrch (Třebíč), 
[15°52′28″,49°12′36″], kanál 33, výkon 5 W
+# ^-- MUX 1 - Česká televize, vysílač Humenec (Nový Hrozenkov), 
[18°12′42″,49°21′17″], kanál 33, výkon 25 W
+# ^-- MUX 1 - Česká televize, vysílač Branka (Luhačovice), 
[17°45′18″,49°05′50″], kanál 33, výkon 46 W
+# ^-- MUX 1 - Česká televize, vysílač Rokštejnská (Brtnice), 
[15°41′07″,49°18′14″], kanál 33, výkon 10 W
T 578000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 1 - Česká televize, vysílač Krašov (Plzeň), [13°04′46″,49°59′45″], 
kanál 34, výkon 100 kW
+# ^-- MUX 1 - Česká televize, vysílač Vraní vrch (Domažlice), 
[12°46′41″,49°28′21″], kanál 34, výkon 10 kW
+# ^-- MUX 1 - Česká televize, vysílač Vranovský vrch (Nemanice), 
[12°43′49″,49°28′18″], kanál 34, výkon 10 W
+# ^-- MUX 1 - Česká televize, vysílač Suchý kámen (Nýrsko), 
[13°07′50″,49°16′36″], kanál 34, výkon 10 W
+# ^-- MUX 1 - Česká televize, vysílač Rozvodí (Železná Ruda), 
[13°11′52″,49°10′28″], kanál 34, výkon 10 W
+# ^-- MUX 1 - Česká televize, vysílač Fajtův vrch (Velké Meziříčí), 
[16°01′27″,49°21′34″], kanál 34, výkon 10 W
+# ^-- MUX 1 - Česká televize, vysílač ul. Okružní (Rakovník), 
[13°43′55″,50°05′43″], kanál 34, výkon 10 W
+T 578000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+# ^-- MUX 3 - Czech Digital Group, vysílač Krásné (Pardubice), 
[15°44′15″,49°49′21″], kanál 34, výkon 10 kW (snížený)
T 586000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač Tři kříže (Karlovy Vary), 
[12°53′12″,50°13′39″], kanál 35, výkon 25 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač Háj (Aš), [12°12′04″,50°14′01″], 
kanál 35, výkon 50 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač Monty (Mariánské Lázně), 
[12°41′58″,49°58′06″], kanál 35, výkon 10 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač Sněžná (Kraslice), 
[12°30′20″,50°18′41″], kanál 35, výkon 10 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač pod hřbitovem (Rotava), 
[12°34′09″,50°17′49″], kanál 35, výkon 5 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač Javořice (Jihlava), 
[15°20′22″,49°14′17″], kanál 35, výkon 100 kW
+# ^-- MUX 2 - České Radiokomunikace, vysílač Strážný vrch (Třebíč), 
[15°52′28″,49°12′36″], kanál 35, výkon 5 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač nad ZD (Letohrad), 
[16°31′32″,50°01′56″], kanál 35, výkon 10 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač Na Vyhlídce (Náchod), 
[16°10′41″,50°24′17″], kanál 35, výkon 25 W
T 594000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 1 - Česká televize, vysílač Zelená hora (Cheb), 
[12°18′29″,50°04′10″], kanál 36, výkon 20 kW
+# ^-- MUX 1 - Česká televize, vysílač Háj (Aš), [12°12′04″,50°14′01″], kanál 
36, výkon 50 W
+# ^-- MUX 1 - Česká televize, vysílač Klínovec (Jáchymov), 
[12°58′04″,50°23′49″], kanál 36, výkon 50 kW
+# ^-- MUX 1 - Česká televize, vysílač Monty (Mariánské Lázně), 
[12°41′58″,49°58′06″], kanál 36, výkon 10 W
+# ^-- MUX 1 - Česká televize, vysílač pod hřbitovem (Rotava), 
[12°34′09″,50°17′49″], kanál 36, výkon 5 W
+# ^-- MUX 1 - Česká televize, vysílač Sněžná (Kraslice), [12°30′20″,50°18′41″], 
kanál 36, výkon 10 W
+# ^-- MUX 1 - Česká televize, vysílač Tři kříže (Karlovy Vary), 
[12°53′12″,50°13′39″], kanál 36, výkon 25 W
+# ^-- MUX 1 - Česká televize, vysílač Praděd (Jeseník), [17°13′52″,50°04′59″], 
kanál 36, výkon 100 kW
+# ^-- MUX 1 - Česká televize, vysílač Biskupská kupa (Zlaté Hory), 
[17°25′45″,50°15′14″], kanál 36, výkon 20 W
+# ^-- MUX 1 - Česká televize, vysílač Na Rozárce (Žamberk), 
[16°27′25″,50°05′16″], kanál 36, výkon 16 W
+# ^-- MUX 1 - Česká televize, vysílač Jírová hora (Hronov), 
[16°10′32″,50°29′14″], kanál 36, výkon 10 W
+# ^-- MUX 1 - Česká televize, vysílač Zlatý Chlum (Jeseník), 
[17°14′15″,50°14′17″], kanál 36, výkon 100 W
T 602000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač Hošťálkovice (Ostrava), 
[18°12′45″,49°51′41″], kanál 37, výkon 100 kW
+# ^-- MUX 2 - České Radiokomunikace, vysílač Hladnov (Ostrava), 
[18°18′19″,49°50′51″], kanál 37, výkon 10 kW
+# ^-- MUX 2 - České Radiokomunikace, vysílač Lysá hora (Frýdek-Místek), 
[18°26′56″,49°32′47″], kanál 37, výkon 25 kW
+# ^-- MUX 2 - České Radiokomunikace, vysílač Jírová hora (Hronov), 
[16°10′32″,50°29′14″], kanál 37, výkon 10 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač Radhošť (Valašské Meziřičí), 
[18°13′20″,49°29′31″], kanál 37, výkon 100 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač Na Kyčerce (Velké Karlovice), 
[18°17′09″,49°21′05″], kanál 37, výkon 12,5 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač Strážnice (Jablonné nad Orlicí), 
[16°35′34″,50°01′59″], kanál 37, výkon 10 W
+T 610000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač Šeptouchov (Ledeč nad Sázavou), 
[15°16′06″,49°41′43″], kanál 38, výkon 10 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač Fajtův vrch (Velké Meziříčí), 
[16°01′27″,49°21′34″], kanál 38, výkon 10 W
T 618000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač Kleť (České Budějovice), 
[14°16′53″,48°52′03″], kanál 39, výkon 100 kW
+# ^-- MUX 2 - České Radiokomunikace, vysílač Mařský vrch (Vimperk), 
[13°50′49″,49°04′20″], kanál 39, výkon 20 kW
+# ^-- MUX 2 - České Radiokomunikace, vysílač Krásné (Pardubice), 
[15°44′15″,49°49′21″], kanál 39, výkon 25 kW
+# ^-- MUX 2 - České Radiokomunikace, vysílač Horní Sněžná (Volary), 
[13°56′06″,48°53′13″], kanál 39, výkon 20 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač Krásná pole (Loučovice), 
[14°14′18″,48°36′17″], kanál 39, výkon 10 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač Novotných vršek (Zdíkov), 
[13°41′23″,49°05′11″], kanál 39, výkon 10 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač Semenec (Týn nad Vltavou), 
[14°24′38″,49°14′00″], kanál 39, výkon 10 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač Olešná (Blansko), 
[16°38′41″,49°20′24″], kanál 39, výkon 20 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač ul. Údolní (Havlíčkův Brod), 
[15°34′44″,49°35′49″], kanál 39, výkon 10 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač Kamenná Horka (Svitavy), 
[16°34′10″,49°44′22″], kanál 39, výkon 100 W
T 626000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 1 - Česká televize, vysílač Černá hora (Trutnov), 
[15°44′30″,50°39′09″], kanál 40, výkon 100 kW
+# ^-- MUX 1 - Česká televize, vysílač u nádraží (Horní Lipová), 
[17°04′58″,50°13′33″], kanál 40, výkon ?
+# ^-- MUX 1 - Česká televize, vysílač Hvězda (Broumov), [16°15′57″,50°34′04″], 
kanál 40, výkon 25 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač Hády (Brno), 
[16°40′28″,49°13′22″], kanál 40, výkon 10 kW
+# ^-- MUX 2 - České Radiokomunikace, vysílač Barvičova (Brno), 
[16°34′47″,49°11′56″], kanál 40, výkon 10 kW
+# ^-- MUX 2 - České Radiokomunikace, vysílač Děvín (Mikulov), 
[16°39′01″,48°52′10″], kanál 40, výkon 25 kW
+# ^-- MUX 2 - České Radiokomunikace, vysílač Kojál (Brno), 
[16°48′58″,49°22′12″], kanál 40, výkon 100 kW
+# ^-- MUX 2 - České Radiokomunikace, vysílač Harusův kopec (Žďár nad Sázavou), 
[16°02′39″,49°34′21″], kanál 40, výkon 100 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač ul. Zborovská (Náměšť nad 
Oslavou), [16°08′56″,49°12′11″], kanál 40, výkon 10 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač Čížovky (Boskovice), 
[16°40′43″,49°29′17″], kanál 40, výkon 10 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač U Sivků (Huslenky), 
[18°05′48″,49°19′20″], kanál 40, výkon 25 W
T 634000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
-T 642000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač Žižkov (Praha), 
[14°27′04″,50°04′52″], kanál 41, výkon 32 kW
+# ^-- MUX 2 - České Radiokomunikace, vysílač Cukrák (Praha), 
[14°21′21″,49°56′12″], kanál 41, výkon 100 kW
+# ^-- MUX 2 - České Radiokomunikace, vysílač Mezivrata (Votice), 
[14°40′16″,49°36′10″], kanál 41, výkon 32 kW
+# ^-- MUX 2 - České Radiokomunikace, vysílač Březové hory (Příbram), 
[13°59′49″,49°41′08″], kanál 41, výkon 10 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač nad hřbitovem (Jince), 
[13°58′18″,49°46′58″], kanál 41, výkon 10 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač Na Vrážích (Husinec), 
[13°58′36″,49°03′21″], kanál 41, výkon 10 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač Komorní Hrádek (Chocerady), 
[14°47′53″,49°52′06″], kanál 41, výkon 5 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač Na Vlkaňáku (Sázava), 
[14°53′31″,49°52′56″], kanál 41, výkon 10 W
T 650000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
-T 658000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 666000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 674000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+# ^-- MUX 1 - Česká televize, vysílač Ještěd (Liberec), [14°59′05″,50°43′58″], 
kanál 43, výkon 50 kW
+# ^-- MUX 1 - Česká televize, vysílač U rozhledny (Frýdlant v Čechách), 
[15°04′34″,50°56′07″], kanál 43, výkon 25 W
+# ^-- MUX 1 - Česká televize, vysílač Dubina (Strání), [17°40′56″,48°54′54″], 
kanál 43, výkon 25 W
+# ^-- MUX 1 - Česká televize, vysílač Suchý vrch (Králíky), 
[16°41′21″,50°03′07″], kanál 43, výkon 50 W
+# ^-- MUX 1 - Česká televize, vysílač Pálenisko (Jablůnka), 
[17°58′27″,49°24′09″], kanál 43, výkon 5 W
T 690000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač Krašov (Plzeň), 
[13°04′46″,49°59′45″], kanál 48, výkon 100 kW
+# ^-- MUX 2 - České Radiokomunikace, vysílač Vraní vrch (Domažlice), 
[12°46′41″,49°28′21″], kanál 48, výkon 10 kW
+# ^-- MUX 2 - České Radiokomunikace, vysílač Vranovský vrch (Nemanice), 
[12°43′49″,49°28′18″], kanál 48, výkon 10 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač Svatobor (Sušice), 
[13°29′23″,49°14′06″], kanál 48, výkon 100 kW
+# ^-- MUX 2 - České Radiokomunikace, vysílač Suchý kámen (Nýrsko), 
[13°07′50″,49°16′36″], kanál 48, výkon 10 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač Rozvodí (Železná Ruda), 
[13°11′52″,49°10′28″], kanál 48, výkon 10 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač ul. Okružní (Rakovník), 
[13°43′55″,50°05′43″], kanál 48, výkon 10 W
+T 690000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+# ^-- MUX 3 - Czech Digital Group, vysílač Hošťálkovice (Ostrava), 
[18°12′45″,49°51′41″], kanál 48, výkon 100 kW
+# ^-- MUX 3 - Czech Digital Group, vysílač Hladnov (Ostrava), 
[18°18′19″,49°50′51″], kanál 48, výkon 10 kW
T 698000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
-T 706000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
-T 714000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 1 - Česká televize, vysílač Kleť (České Budějovice), 
[14°16′53″,48°52′03″], kanál 49, výkon 100 kW
+# ^-- MUX 1 - Česká televize, vysílač Svatobor (Sušice), [13°29′23″,49°14′06″], 
kanál 49, výkon 100 kW
+# ^-- MUX 1 - Česká televize, vysílač Mařský vrch (Vimperk), 
[13°50′49″,49°04′20″], kanál 49, výkon 20 kW
+# ^-- MUX 1 - Česká televize, vysílač Horní Sněžná (Volary), 
[13°56′06″,48°53′13″], kanál 49, výkon 20 W
+# ^-- MUX 1 - Česká televize, vysílač Krásná pole (Loučovice), 
[14°14′18″,48°36′17″], kanál 49, výkon 10 W
+# ^-- MUX 1 - Česká televize, vysílač Novotných vršek (Zdíkov), 
[13°41′23″,49°05′11″], kanál 49, výkon 10 W
+# ^-- MUX 1 - Česká televize, vysílač Semenec (Týn nad Vltavou), 
[14°24′38″,49°14′00″], kanál 49, výkon 10 W
+# ^-- MUX 1 - Česká televize, vysílač Šeptouchov (Ledeč nad Sázavou), 
[15°16′06″,49°41′43″], kanál 49, výkon 13 W
+# ^-- MUX 1 - Česká televize, vysílač Harusův kopec (Žďár nad Sázavou), 
[16°02′39″,49°34′21″], kanál 49, výkon 100 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač Na Rozárce (Žamberk), 
[16°27′25″,50°05′16″], kanál 49, výkon 16 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač Kubincův kopec (Ústí nad Orlicí), 
[16°22′40″,49°58′32″], kanál 49, výkon 2 W
+T 698000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+# ^-- MUX 3 - Czech Digital Group, vysílač Kraví hora (Znojmo), 
[16°02′14″,48°50′46″], kanál 49, výkon 25 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač Tlustá hora (Zlín), 
[17°38′47″,49°12′30″], kanál 49, výkon 100 kW
+# ^-- MUX 2 - České Radiokomunikace, vysílač Ploštiny (Valašské Klobouky), 
[18°03′22″,49°08′20″], kanál 49, výkon 25 kW
+# ^-- MUX 2 - České Radiokomunikace, vysílač Pálenisko (Jablůnka), 
[17°58′27″,49°24′09″], kanál 49, výkon 10 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač Humenec (Nový Hrozenkov), 
[18°12′42″,49°21′17″], kanál 49, výkon 25 kW
+T 714000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+# ^-- MUX 3 - Czech Digital Group, vysílač Praděd (Jeseník), 
[17°13′52″,50°04′59″], kanál 51, výkon 100 kW
T 722000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač Ještěd (Liberec), 
[14°59′05″,50°43′58″], kanál 52, výkon 50 kW
+# ^-- MUX 2 - České Radiokomunikace, vysílač U rozhledny (Frýdlant v Čechách), 
[15°04′34″,50°56′07″], kanál 52, výkon 25 W
+T 722000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+# ^-- MUX 3 - Czech Digital Group, vysílač Krašov (Plzeň), 
[13°04′46″,49°59′45″], kanál 52, výkon 100 kW
+# ^-- MUX 3 - Czech Digital Group, vysílač Svatobor (Sušice), 
[13°29′23″,49°14′06″], kanál 52, výkon 100 kW
+# ^-- MUX 3 - Czech Digital Group, vysílač Rokycany (), [13°35′34″,49°44′39″], 
kanál 52, výkon 2 W
T 730000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 1 - Česká televize, vysílač Cukrák (Praha), [14°21′21″,49°56′12″], 
kanál 53, výkon 100 kW
+# ^-- MUX 1 - Česká televize, vysílač Žižkov (Praha), [14°27′04″,50°04′52″], 
kanál 53, výkon 32 kW
+# ^-- MUX 1 - Česká televize, vysílač Mezivrata (Votice), 
[14°40′16″,49°36′10″], kanál 53, výkon 32 kW
+# ^-- MUX 1 - Česká televize, vysílač nad hřbitovem (Jince), 
[13°58′18″,49°46′58″], kanál 53, výkon 10 W
+# ^-- MUX 1 - Česká televize, vysílač Na Vrážích (Husinec), 
[13°58′36″,49°03′21″], kanál 53, výkon 10 W
+# ^-- MUX 1 - Česká televize, vysílač Komorní Hrádek (Chocerady), 
[14°47′53″,49°52′06″], kanál 53, výkon 5 W
+# ^-- MUX 1 - Česká televize, vysílač Na Vlkaňáku (Sázava), 
[14°53′31″,49°52′56″], kanál 53, výkon 10 W
+# ^-- MUX 1 - Česká televize, vysílač Vyhlídka (Náchod), [16°10′41″,50°24′17″], 
kanál 53, výkon ?
+# ^-- MUX 1 - Česká televize, vysílač Větruše (Ústí nad Labem), 
[14°02′23″,50°39′18″], kanál 53, výkon 10 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač Praděd (Jeseník), 
[17°13′52″,50°04′59″], kanál 53, výkon 100 kW
+# ^-- MUX 2 - České Radiokomunikace, vysílač Biskupská kupa (Zlaté Hory), 
[17°25′45″,50°15′14″], kanál 53, výkon 20 W
T 738000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
-T 746000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 1 - Česká televize, vysílač Hladnov (Ostrava), [18°18′19″,49°50′51″], 
kanál 54, výkon 10 kW
+# ^-- MUX 1 - Česká televize, vysílač Hošťálkovice (Ostrava), 
[18°12′45″,49°51′41″], kanál 54, výkon 14 kW
+# ^-- MUX 1 - Česká televize, vysílač Lysá hora (Frýdek-Místek), 
[18°26′56″,49°32′47″], kanál 54, výkon 25 kW
+# ^-- MUX 1 - Česká televize, vysílač Radhošť (Valašské Meziřičí), 
[18°13′20″,49°29′31″], kanál 54, výkon 100 W
+# ^-- MUX 1 - Česká televize, vysílač Bečevná (Vsetín), [17°59′32″,49°19′45″], 
kanál 54, výkon 20 W
+# ^-- MUX 1 - Česká televize, vysílač Na Kyčerce (Velké Karlovice), 
[18°17′09″,49°21′05″], kanál 54, výkon 25 W
+# ^-- MUX 1 - Česká televize, vysílač nad ZD (Letohrad), [16°31′32″,50°01′56″], 
kanál 54, výkon 10 W
+# ^-- MUX 1 - Česká televize, vysílač Dolní Dobrouč (), [16°30′03″,49°59′42″], 
kanál 54, výkon 22 W
+# ^-- MUX 1 - Česká televize, vysílač Vadín (Okrouhlice), 
[15°29′15″,49°38′15″], kanál 54, výkon 100 W
+# ^-- MUX 1 - Česká televize, vysílač Gagarinova (Hlubočky), 
[17°24′00″,49°37′26″], kanál 54, výkon 22 W
+# ^-- MUX 1 - Česká televize, vysílač Kubincův kopec (Ústí nad Orlicí), 
[16°22′40″,49°58′32″], kanál 54, výkon 10 W
+T 746000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+# ^-- MUX 3 - Czech Digital Group, vysílač Buková hora (Ústí n./L.), 
[14°13′44″,50°40′19″], kanál 55, výkon 100 kW
+# ^-- MUX 3 - Czech Digital Group, vysílač Desná III (), [15°21′07″,50°45′47″], 
kanál 55, výkon 4 W
+# ^-- MUX 3 - Czech Digital Group, vysílač Holoubkov (), [13°41′25″,49°46′32″], 
kanál 55, výkon 4 W
+# ^-- MUX 3 - Czech Digital Group, vysílač Strašice (), [13°45′26″,49°44′04″], 
kanál 55, výkon 4 W
T 770000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
-T 778000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
-T 786000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač Buková hora (Ústí n./L.), 
[14°13′44″,50°40′19″], kanál 58, výkon 100 kW
+# ^-- MUX 2 - České Radiokomunikace, vysílač Jedlová hora (Chomutov), 
[13°27′43″,50°32′55″], kanál 58, výkon 32 kW
+# ^-- MUX 2 - České Radiokomunikace, vysílač Vaňov (Ústí nad Labem), 
[14°02′15″,50°38′41″], kanál 58, výkon 10 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač Popovický vrch (Děčín), 
[14°10′33″,50°46′11″], kanál 58, výkon 20 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač Ječný vrch (Velký Šenov), 
[14°19′26″,51°00′22″], kanál 58, výkon 20 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač vrch Pytlák (Šluknov), 
[14°30′34″,50°59′57″], kanál 58, výkon 20 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač Hřebenáč (Jindřichovice pod 
Smrkem), [15°14′26″,50°56′18″], kanál 58, výkon 10 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač Lázně Libverda nad hřbitovem 
(Hejnice), [15°13′17″,50°53′15″], kanál 58, výkon 10 W
+# ^-- MUX 2 - České Radiokomunikace, vysílač Bečevná (Vsetín), 
[17°59′32″,49°19′45″], kanál 58, výkon 20 W
+T 778000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+# ^-- MUX 3 - Czech Digital Group, vysílač Žižkov (Praha), 
[14°27′04″,50°04′52″], kanál 59, výkon 32 kW
+# ^-- MUX 3 - Czech Digital Group, vysílač Cukrák (Praha), 
[14°21′21″,49°56′12″], kanál 59, výkon 100 kW
+# ^-- MUX 3 - Czech Digital Group, vysílač Hády (Brno), [16°40′28″,49°13′22″], 
kanál 59, výkon 10 kW
+# ^-- MUX 3 - Czech Digital Group, vysílač Barvičova (Brno), 
[16°34′47″,49°11′56″], kanál 59, výkon 10 kW
+# ^-- MUX 3 - Czech Digital Group, vysílač Zbiroh (), [13°46′06″,49°51′26″], 
kanál 59, výkon 15 W
+# ^-- MUX 3 - Czech Digital Group, vysílač Kojál (Brno), [16°48′58″,49°22′12″], 
kanál 59, výkon 100 kW
+T 786000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+# ^-- MUX 3 - Czech Digital Group, vysílač Černá hora (Trutnov), 
[15°44′30″,50°39′09″], kanál 60, výkon 100 kW
+# ^-- MUX 3 - Czech Digital Group, vysílač Tři kříže (Karlovy Vary), 
[12°53′12″,50°13′39″], kanál 60, výkon 25 W
+# ^-- MUX 3 - Czech Digital Group, vysílač Ještěd (Liberec), 
[14°59′05″,50°43′58″], kanál 60, výkon 20 kW
T 794000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
-T 802000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač Černá hora (Trutnov), 
[15°44′30″,50°39′09″], kanál 61, výkon 100 kW
T 810000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+# ^-- MUX 4 - Digital Broadcasting, vysílač 1. máje (Ostrava), 
[18°15′32″,49°49′39″], kanál 63, výkon 0,81 kW
T 818000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 826000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+# ^-- MUX 4 - Digital Broadcasting, vysílač ÚTB Olšanská (Praha), 
[14°28′09″,50°05′01″], kanál 64, výkon 2 kW
+# ^-- MUX 4 - Digital Broadcasting, vysílač FN Bohunice (Brno), 
[16°34′14″,49°10′33″], kanál 64, výkon 2 kW
T 834000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač Zelená hora (Cheb), 
[12°18′29″,50°04′10″], kanál 66, výkon 20 kW
+# ^-- MUX 2 - České Radiokomunikace, vysílač Klínovec (Jáchymov), 
[12°58′04″,50°23′49″], kanál 66, výkon 50 kW
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Barvicova_Brno
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Barvicova_Brno Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,16 @@
+# Czech Republic, Barvičova Brno
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
+# ^-- MUX 1 - Česká televize, vysílač Barvičova (Brno), [16°34′47″,49°11′56″], 
kanál 29, výkon 10 kW
+T 626000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač Barvičova (Brno), 
[16°34′47″,49°11′56″], kanál 40, výkon 10 kW
+T 778000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+# ^-- MUX 3 - Czech Digital Group, vysílač Barvičova (Brno), 
[16°34′47″,49°11′56″], kanál 59, výkon 10 kW
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Becevna_Vsetin
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Becevna_Vsetin Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Bečevná Vsetín
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
+# ^-- MUX 1 - Česká televize, vysílač Bečevná (Vsetín), [17°59′32″,49°19′45″], 
kanál 54, výkon 20 W
+T 770000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač Bečevná (Vsetín), 
[17°59′32″,49°19′45″], kanál 58, výkon 20 W
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Biskupska_kupa_Zlate_Hory
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Biskupska_kupa_Zlate_Hory Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Biskupská kupa Zlaté Hory
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
+# ^-- MUX 1 - Česká televize, vysílač Biskupská kupa (Zlaté Hory), 
[17°25′45″,50°15′14″], kanál 36, výkon 20 W
+T 730000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač Biskupská kupa (Zlaté Hory), 
[17°25′45″,50°15′14″], kanál 53, výkon 20 W
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Branka_Luhacovice
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Branka_Luhacovice Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,12 @@
+# Czech Republic, Branka Luhačovice
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
+# ^-- MUX 1 - Česká televize, vysílač Branka (Luhačovice), 
[17°45′18″,49°05′50″], kanál 33, výkon 46 W
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Brezove_hory_Pribram
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Brezove_hory_Pribram Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Březové hory Příbram
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
+# ^-- MUX 1 - Česká televize, vysílač Březové hory (Příbram), 
[13°59′49″,49°41′08″], kanál 29, výkon 10 W
+T 634000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač Březové hory (Příbram), 
[13°59′49″,49°41′08″], kanál 41, výkon 10 W
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Bukova_hora_Usti_nL
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Bukova_hora_Usti_nL Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,16 @@
+# Czech Republic, Buková hora Ústí n./L.
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
+# ^-- MUX 1 - Česká televize, vysílač Buková hora (Ústí n./L.), 
[14°13′44″,50°40′19″], kanál 33, výkon 100 kW
+T 746000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+# ^-- MUX 3 - Czech Digital Group, vysílač Buková hora (Ústí n./L.), 
[14°13′44″,50°40′19″], kanál 55, výkon 100 kW
+T 770000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač Buková hora (Ústí n./L.), 
[14°13′44″,50°40′19″], kanál 58, výkon 100 kW
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Cerna_hora_Trutnov
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Cerna_hora_Trutnov Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,16 @@
+# Czech Republic, Černá hora Trutnov
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
+# ^-- MUX 1 - Česká televize, vysílač Černá hora (Trutnov), 
[15°44′30″,50°39′09″], kanál 40, výkon 100 kW
+T 786000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+# ^-- MUX 3 - Czech Digital Group, vysílač Černá hora (Trutnov), 
[15°44′30″,50°39′09″], kanál 60, výkon 100 kW
+T 794000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač Černá hora (Trutnov), 
[15°44′30″,50°39′09″], kanál 61, výkon 100 kW
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Cizovky_Boskovice
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Cizovky_Boskovice Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Čížovky Boskovice
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
+# ^-- MUX 1 - Česká televize, vysílač Čížovky (Boskovice), 
[16°40′43″,49°29′17″], kanál 29, výkon 10 W
+T 626000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač Čížovky (Boskovice), 
[16°40′43″,49°29′17″], kanál 40, výkon 10 W
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Cukrak_Praha
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Cukrak_Praha Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,16 @@
+# Czech Republic, Cukrák Praha
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
+# ^-- MUX 2 - České Radiokomunikace, vysílač Cukrák (Praha), 
[14°21′21″,49°56′12″], kanál 41, výkon 100 kW
+T 730000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 1 - Česká televize, vysílač Cukrák (Praha), [14°21′21″,49°56′12″], 
kanál 53, výkon 100 kW
+T 778000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+# ^-- MUX 3 - Czech Digital Group, vysílač Cukrák (Praha), 
[14°21′21″,49°56′12″], kanál 59, výkon 100 kW
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Desna_III_
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Desna_III_ Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Desná III
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
+# ^-- MUX 1 - Česká televize, vysílač Desná III (), [15°21′07″,50°45′47″], 
kanál 33, výkon 3 W
+T 746000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+# ^-- MUX 3 - Czech Digital Group, vysílač Desná III (), [15°21′07″,50°45′47″], 
kanál 55, výkon 4 W
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Devin_Mikulov
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Devin_Mikulov Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Děvín Mikulov
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
+# ^-- MUX 1 - Česká televize, vysílač Děvín (Mikulov), [16°39′01″,48°52′10″], 
kanál 29, výkon 25 kW
+T 626000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač Děvín (Mikulov), 
[16°39′01″,48°52′10″], kanál 40, výkon 25 kW
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Dolni_Dobrouc_
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Dolni_Dobrouc_ Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,12 @@
+# Czech Republic, Dolní Dobrouč
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
+# ^-- MUX 1 - Česká televize, vysílač Dolní Dobrouč (), [16°30′03″,49°59′42″], 
kanál 54, výkon 22 W
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Dubina_Strani
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Dubina_Strani Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,12 @@
+# Czech Republic, Dubina Strání
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
+# ^-- MUX 1 - Česká televize, vysílač Dubina (Strání), [17°40′56″,48°54′54″], 
kanál 43, výkon 25 W
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-FN_Bohunice_Brno
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-FN_Bohunice_Brno Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,12 @@
+# Czech Republic, FN Bohunice Brno
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
+# ^-- MUX 4 - Digital Broadcasting, vysílač FN Bohunice (Brno), 
[16°34′14″,49°10′33″], kanál 64, výkon 2 kW
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Fajtuv_vrch_Velke_Mezirici
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Fajtuv_vrch_Velke_Mezirici Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Fajtův vrch Velké Meziříčí
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
+# ^-- MUX 1 - Česká televize, vysílač Fajtův vrch (Velké Meziříčí), 
[16°01′27″,49°21′34″], kanál 34, výkon 10 W
+T 610000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač Fajtův vrch (Velké Meziříčí), 
[16°01′27″,49°21′34″], kanál 38, výkon 10 W
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Gagarinova_Hlubocky
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Gagarinova_Hlubocky Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,12 @@
+# Czech Republic, Gagarinova Hlubočky
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
+# ^-- MUX 1 - Česká televize, vysílač Gagarinova (Hlubočky), 
[17°24′00″,49°37′26″], kanál 54, výkon 22 W
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Hady_Brno
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Hady_Brno Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,16 @@
+# Czech Republic, Hády Brno
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
+# ^-- MUX 1 - Česká televize, vysílač Hády (Brno), [16°40′28″,49°13′22″], kanál 
29, výkon 10 kW
+T 626000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač Hády (Brno), 
[16°40′28″,49°13′22″], kanál 40, výkon 10 kW
+T 778000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+# ^-- MUX 3 - Czech Digital Group, vysílač Hády (Brno), [16°40′28″,49°13′22″], 
kanál 59, výkon 10 kW
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Haj_As
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Haj_As Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Háj Aš
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
+# ^-- MUX 2 - České Radiokomunikace, vysílač Háj (Aš), [12°12′04″,50°14′01″], 
kanál 35, výkon 50 W
+T 594000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 1 - Česká televize, vysílač Háj (Aš), [12°12′04″,50°14′01″], kanál 
36, výkon 50 W
diff -r 4030c51d6e7b -r ebce5e2f10ba 
util/scan/dvb-t/cz-Harusuv_kopec_Zdar_nad_Sazavou
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Harusuv_kopec_Zdar_nad_Sazavou Wed May 23 09:19:53 2012 
+0200
@@ -0,0 +1,14 @@
+# Czech Republic, Harusův kopec Žďár nad Sázavou
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
+# ^-- MUX 2 - České Radiokomunikace, vysílač Harusův kopec (Žďár nad Sázavou), 
[16°02′39″,49°34′21″], kanál 40, výkon 100 W
+T 698000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 1 - Česká televize, vysílač Harusův kopec (Žďár nad Sázavou), 
[16°02′39″,49°34′21″], kanál 49, výkon 100 W
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Hladnov_Ostrava
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Hladnov_Ostrava Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,16 @@
+# Czech Republic, Hladnov Ostrava
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
+# ^-- MUX 2 - České Radiokomunikace, vysílač Hladnov (Ostrava), 
[18°18′19″,49°50′51″], kanál 37, výkon 10 kW
+T 690000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+# ^-- MUX 3 - Czech Digital Group, vysílač Hladnov (Ostrava), 
[18°18′19″,49°50′51″], kanál 48, výkon 10 kW
+T 738000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 1 - Česká televize, vysílač Hladnov (Ostrava), [18°18′19″,49°50′51″], 
kanál 54, výkon 10 kW
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Holoubkov_
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Holoubkov_ Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,12 @@
+# Czech Republic, Holoubkov
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
+# ^-- MUX 3 - Czech Digital Group, vysílač Holoubkov (), [13°41′25″,49°46′32″], 
kanál 55, výkon 4 W
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Horni_Snezna_Volary
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Horni_Snezna_Volary Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Horní Sněžná Volary
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
+# ^-- MUX 2 - České Radiokomunikace, vysílač Horní Sněžná (Volary), 
[13°56′06″,48°53′13″], kanál 39, výkon 20 W
+T 698000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 1 - Česká televize, vysílač Horní Sněžná (Volary), 
[13°56′06″,48°53′13″], kanál 49, výkon 20 W
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Hostalkovice_Ostrava
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Hostalkovice_Ostrava Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,16 @@
+# Czech Republic, Hošťálkovice Ostrava
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
+# ^-- MUX 2 - České Radiokomunikace, vysílač Hošťálkovice (Ostrava), 
[18°12′45″,49°51′41″], kanál 37, výkon 100 kW
+T 690000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+# ^-- MUX 3 - Czech Digital Group, vysílač Hošťálkovice (Ostrava), 
[18°12′45″,49°51′41″], kanál 48, výkon 100 kW
+T 738000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 1 - Česká televize, vysílač Hošťálkovice (Ostrava), 
[18°12′45″,49°51′41″], kanál 54, výkon 14 kW
diff -r 4030c51d6e7b -r ebce5e2f10ba 
util/scan/dvb-t/cz-Hrebenac_Jindrichovice_pod_Smrkem
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Hrebenac_Jindrichovice_pod_Smrkem Wed May 23 09:19:53 
2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Hřebenáč Jindřichovice pod Smrkem
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
+# ^-- MUX 1 - Česká televize, vysílač Hřebenáč (Jindřichovice pod Smrkem), 
[15°14′26″,50°56′18″], kanál 33, výkon 10 W
+T 770000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač Hřebenáč (Jindřichovice pod 
Smrkem), [15°14′26″,50°56′18″], kanál 58, výkon 10 W
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Humenec_Novy_Hrozenkov
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Humenec_Novy_Hrozenkov Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Humenec Nový Hrozenkov
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
+# ^-- MUX 1 - Česká televize, vysílač Humenec (Nový Hrozenkov), 
[18°12′42″,49°21′17″], kanál 33, výkon 25 W
+T 698000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač Humenec (Nový Hrozenkov), 
[18°12′42″,49°21′17″], kanál 49, výkon 25 kW
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Hvezda_Broumov
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Hvezda_Broumov Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,12 @@
+# Czech Republic, Hvězda Broumov
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
+# ^-- MUX 1 - Česká televize, vysílač Hvězda (Broumov), [16°15′57″,50°34′04″], 
kanál 40, výkon 25 W
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Javorice_Jihlava
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Javorice_Jihlava Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,16 @@
+# Czech Republic, Javořice Jihlava
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
+# ^-- MUX 3 - Czech Digital Group, vysílač Javořice (Jihlava), 
[15°20′22″,49°14′17″], kanál 30, výkon 100 kW
+T 570000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 1 - Česká televize, vysílač Javořice (Jihlava), 
[15°20′22″,49°14′17″], kanál 33, výkon 100 kW
+T 586000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač Javořice (Jihlava), 
[15°20′22″,49°14′17″], kanál 35, výkon 100 kW
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Javorovy_vrch_Trinec
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Javorovy_vrch_Trinec Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,10 @@
+# Czech Republic, Javorový vrch Třinec
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
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Jecny_vrch_Velky_Senov
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Jecny_vrch_Velky_Senov Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Ječný vrch Velký Šenov
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
+# ^-- MUX 1 - Česká televize, vysílač Ječný vrch (Velký Šenov), 
[14°19′26″,51°00′22″], kanál 33, výkon 20 W
+T 770000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač Ječný vrch (Velký Šenov), 
[14°19′26″,51°00′22″], kanál 58, výkon 20 W
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Jedlova_hora_Chomutov
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Jedlova_hora_Chomutov Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Jedlová hora Chomutov
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
+# ^-- MUX 1 - Česká televize, vysílač Jedlová hora (Chomutov), 
[13°27′43″,50°32′55″], kanál 33, výkon 32 kW
+T 770000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač Jedlová hora (Chomutov), 
[13°27′43″,50°32′55″], kanál 58, výkon 32 kW
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Jested_Liberec
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Jested_Liberec Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,16 @@
+# Czech Republic, Ještěd Liberec
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
+# ^-- MUX 1 - Česká televize, vysílač Ještěd (Liberec), [14°59′05″,50°43′58″], 
kanál 43, výkon 50 kW
+T 722000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač Ještěd (Liberec), 
[14°59′05″,50°43′58″], kanál 52, výkon 50 kW
+T 786000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+# ^-- MUX 3 - Czech Digital Group, vysílač Ještěd (Liberec), 
[14°59′05″,50°43′58″], kanál 60, výkon 20 kW
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Jirova_hora_Hronov
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Jirova_hora_Hronov Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Jírová hora Hronov
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
+# ^-- MUX 1 - Česká televize, vysílač Jírová hora (Hronov), 
[16°10′32″,50°29′14″], kanál 36, výkon 10 W
+T 602000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač Jírová hora (Hronov), 
[16°10′32″,50°29′14″], kanál 37, výkon 10 W
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Kamenna_Horka_Svitavy
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Kamenna_Horka_Svitavy Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Kamenná Horka Svitavy
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
+# ^-- MUX 1 - Česká televize, vysílač Kamenná Horka (Svitavy), 
[16°34′10″,49°44′22″], kanál 29, výkon 100 W
+T 618000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač Kamenná Horka (Svitavy), 
[16°34′10″,49°44′22″], kanál 39, výkon 100 W
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Klet_Ceske_Budejovice
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Klet_Ceske_Budejovice Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,16 @@
+# Czech Republic, Kleť České Budějovice
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
+# ^-- MUX 3 - Czech Digital Group, vysílač Kleť (České Budějovice), 
[14°16′53″,48°52′03″], kanál 22, výkon 100 kW
+T 618000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač Kleť (České Budějovice), 
[14°16′53″,48°52′03″], kanál 39, výkon 100 kW
+T 698000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 1 - Česká televize, vysílač Kleť (České Budějovice), 
[14°16′53″,48°52′03″], kanál 49, výkon 100 kW
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Klinovec_Jachymov
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Klinovec_Jachymov Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Klínovec Jáchymov
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
+# ^-- MUX 1 - Česká televize, vysílač Klínovec (Jáchymov), 
[12°58′04″,50°23′49″], kanál 36, výkon 50 kW
+T 834000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač Klínovec (Jáchymov), 
[12°58′04″,50°23′49″], kanál 66, výkon 50 kW
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Kojal_Brno
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Kojal_Brno Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,16 @@
+# Czech Republic, Kojál Brno
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
+# ^-- MUX 1 - Česká televize, vysílač Kojál (Brno), [16°48′58″,49°22′12″], 
kanál 29, výkon 100 kW
+T 626000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač Kojál (Brno), 
[16°48′58″,49°22′12″], kanál 40, výkon 100 kW
+T 778000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+# ^-- MUX 3 - Czech Digital Group, vysílač Kojál (Brno), [16°48′58″,49°22′12″], 
kanál 59, výkon 100 kW
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Komorni_Hradek_Chocerady
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Komorni_Hradek_Chocerady Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Komorní Hrádek Chocerady
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
+# ^-- MUX 2 - České Radiokomunikace, vysílač Komorní Hrádek (Chocerady), 
[14°47′53″,49°52′06″], kanál 41, výkon 5 W
+T 730000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 1 - Česká televize, vysílač Komorní Hrádek (Chocerady), 
[14°47′53″,49°52′06″], kanál 53, výkon 5 W
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Krasna_pole_Loucovice
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Krasna_pole_Loucovice Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Krásná pole Loučovice
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
+# ^-- MUX 2 - České Radiokomunikace, vysílač Krásná pole (Loučovice), 
[14°14′18″,48°36′17″], kanál 39, výkon 10 W
+T 698000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 1 - Česká televize, vysílač Krásná pole (Loučovice), 
[14°14′18″,48°36′17″], kanál 49, výkon 10 W
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Krasne_Pardubice
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Krasne_Pardubice Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,16 @@
+# Czech Republic, Krásné Pardubice
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
+# ^-- MUX 1 - Česká televize, vysílač Krásné (Pardubice), 
[15°44′15″,49°49′21″], kanál 32, výkon 25 kW
+T 578000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+# ^-- MUX 3 - Czech Digital Group, vysílač Krásné (Pardubice), 
[15°44′15″,49°49′21″], kanál 34, výkon 10 kW (snížený)
+T 618000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač Krásné (Pardubice), 
[15°44′15″,49°49′21″], kanál 39, výkon 25 kW
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Krasov_Plzen
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Krasov_Plzen Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,16 @@
+# Czech Republic, Krašov Plzeň
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
+# ^-- MUX 1 - Česká televize, vysílač Krašov (Plzeň), [13°04′46″,49°59′45″], 
kanál 34, výkon 100 kW
+T 690000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač Krašov (Plzeň), 
[13°04′46″,49°59′45″], kanál 48, výkon 100 kW
+T 722000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+# ^-- MUX 3 - Czech Digital Group, vysílač Krašov (Plzeň), 
[13°04′46″,49°59′45″], kanál 52, výkon 100 kW
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Kravi_hora_Znojmo
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Kravi_hora_Znojmo Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,12 @@
+# Czech Republic, Kraví hora Znojmo
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
+# ^-- MUX 3 - Czech Digital Group, vysílač Kraví hora (Znojmo), 
[16°02′14″,48°50′46″], kanál 49, výkon 25 W
diff -r 4030c51d6e7b -r ebce5e2f10ba 
util/scan/dvb-t/cz-Kubincuv_kopec_Usti_nad_Orlici
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Kubincuv_kopec_Usti_nad_Orlici Wed May 23 09:19:53 2012 
+0200
@@ -0,0 +1,14 @@
+# Czech Republic, Kubincův kopec Ústí nad Orlicí
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
+# ^-- MUX 2 - České Radiokomunikace, vysílač Kubincův kopec (Ústí nad Orlicí), 
[16°22′40″,49°58′32″], kanál 49, výkon 2 W
+T 738000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 1 - Česká televize, vysílač Kubincův kopec (Ústí nad Orlicí), 
[16°22′40″,49°58′32″], kanál 54, výkon 10 W
diff -r 4030c51d6e7b -r ebce5e2f10ba 
util/scan/dvb-t/cz-Lazne_Libverda_nad_hrbitovem_Hejnice
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Lazne_Libverda_nad_hrbitovem_Hejnice Wed May 23 
09:19:53 2012 +0200
@@ -0,0 +1,12 @@
+# Czech Republic, Lázně Libverda nad hřbitovem Hejnice
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
+# ^-- MUX 2 - České Radiokomunikace, vysílač Lázně Libverda nad hřbitovem 
(Hejnice), [15°13′17″,50°53′15″], kanál 58, výkon 10 W
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Lysa_hora_Frydek-Mistek
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Lysa_hora_Frydek-Mistek Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Lysá hora Frýdek-Místek
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
+# ^-- MUX 2 - České Radiokomunikace, vysílač Lysá hora (Frýdek-Místek), 
[18°26′56″,49°32′47″], kanál 37, výkon 25 kW
+T 738000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 1 - Česká televize, vysílač Lysá hora (Frýdek-Místek), 
[18°26′56″,49°32′47″], kanál 54, výkon 25 kW
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Marsky_vrch_Vimperk
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Marsky_vrch_Vimperk Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Mařský vrch Vimperk
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
+# ^-- MUX 2 - České Radiokomunikace, vysílač Mařský vrch (Vimperk), 
[13°50′49″,49°04′20″], kanál 39, výkon 20 kW
+T 698000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 1 - Česká televize, vysílač Mařský vrch (Vimperk), 
[13°50′49″,49°04′20″], kanál 49, výkon 20 kW
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Mezivrata_Votice
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Mezivrata_Votice Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Mezivrata Votice
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
+# ^-- MUX 2 - České Radiokomunikace, vysílač Mezivrata (Votice), 
[14°40′16″,49°36′10″], kanál 41, výkon 32 kW
+T 730000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 1 - Česká televize, vysílač Mezivrata (Votice), 
[14°40′16″,49°36′10″], kanál 53, výkon 32 kW
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Monty_Marianske_Lazne
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Monty_Marianske_Lazne Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Monty Mariánské Lázně
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
+# ^-- MUX 2 - České Radiokomunikace, vysílač Monty (Mariánské Lázně), 
[12°41′58″,49°58′06″], kanál 35, výkon 10 W
+T 594000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 1 - Česká televize, vysílač Monty (Mariánské Lázně), 
[12°41′58″,49°58′06″], kanál 36, výkon 10 W
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Na_Kycerce_Velke_Karlovice
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Na_Kycerce_Velke_Karlovice Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Na Kyčerce Velké Karlovice
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
+# ^-- MUX 2 - České Radiokomunikace, vysílač Na Kyčerce (Velké Karlovice), 
[18°17′09″,49°21′05″], kanál 37, výkon 12,5 W
+T 738000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 1 - Česká televize, vysílač Na Kyčerce (Velké Karlovice), 
[18°17′09″,49°21′05″], kanál 54, výkon 25 W
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Na_Rozarce_Zamberk
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Na_Rozarce_Zamberk Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Na Rozárce Žamberk
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
+# ^-- MUX 1 - Česká televize, vysílač Na Rozárce (Žamberk), 
[16°27′25″,50°05′16″], kanál 36, výkon 16 W
+T 698000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač Na Rozárce (Žamberk), 
[16°27′25″,50°05′16″], kanál 49, výkon 16 W
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Na_Vlkanaku_Sazava
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Na_Vlkanaku_Sazava Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Na Vlkaňáku Sázava
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
+# ^-- MUX 2 - České Radiokomunikace, vysílač Na Vlkaňáku (Sázava), 
[14°53′31″,49°52′56″], kanál 41, výkon 10 W
+T 730000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 1 - Česká televize, vysílač Na Vlkaňáku (Sázava), 
[14°53′31″,49°52′56″], kanál 53, výkon 10 W
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Na_Vrazich_Husinec
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Na_Vrazich_Husinec Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Na Vrážích Husinec
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
+# ^-- MUX 2 - České Radiokomunikace, vysílač Na Vrážích (Husinec), 
[13°58′36″,49°03′21″], kanál 41, výkon 10 W
+T 730000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 1 - Česká televize, vysílač Na Vrážích (Husinec), 
[13°58′36″,49°03′21″], kanál 53, výkon 10 W
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Na_Vyhlidce_Nachod
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Na_Vyhlidce_Nachod Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,12 @@
+# Czech Republic, Na Vyhlídce Náchod
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
+# ^-- MUX 2 - České Radiokomunikace, vysílač Na Vyhlídce (Náchod), 
[16°10′41″,50°24′17″], kanál 35, výkon 25 W
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Novotnych_vrsek_Zdikov
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Novotnych_vrsek_Zdikov Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Novotných vršek Zdíkov
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
+# ^-- MUX 2 - České Radiokomunikace, vysílač Novotných vršek (Zdíkov), 
[13°41′23″,49°05′11″], kanál 39, výkon 10 W
+T 698000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 1 - Česká televize, vysílač Novotných vršek (Zdíkov), 
[13°41′23″,49°05′11″], kanál 49, výkon 10 W
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Olesna_Blansko
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Olesna_Blansko Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Olešná Blansko
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
+# ^-- MUX 1 - Česká televize, vysílač Olešná (Blansko), [16°38′41″,49°20′24″], 
kanál 32, výkon 20 W
+T 618000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač Olešná (Blansko), 
[16°38′41″,49°20′24″], kanál 39, výkon 20 W
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Palenisko_Jablunka
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Palenisko_Jablunka Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Pálenisko Jablůnka
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
+# ^-- MUX 1 - Česká televize, vysílač Pálenisko (Jablůnka), 
[17°58′27″,49°24′09″], kanál 43, výkon 5 W
+T 698000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač Pálenisko (Jablůnka), 
[17°58′27″,49°24′09″], kanál 49, výkon 10 W
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Plostiny_Valasske_Klobouky
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Plostiny_Valasske_Klobouky Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Ploštiny Valašské Klobouky
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
+# ^-- MUX 1 - Česká televize, vysílač Ploštiny (Valašské Klobouky), 
[18°03′22″,49°08′20″], kanál 33, výkon 25 kW
+T 698000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač Ploštiny (Valašské Klobouky), 
[18°03′22″,49°08′20″], kanál 49, výkon 25 kW
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Popovicky_vrch_Decin
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Popovicky_vrch_Decin Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Popovický vrch Děčín
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
+# ^-- MUX 1 - Česká televize, vysílač Popovický vrch (Děčín), 
[14°10′33″,50°46′11″], kanál 33, výkon 20 W
+T 770000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač Popovický vrch (Děčín), 
[14°10′33″,50°46′11″], kanál 58, výkon 20 W
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Praded_Jesenik
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Praded_Jesenik Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,16 @@
+# Czech Republic, Praděd Jeseník
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
+# ^-- MUX 1 - Česká televize, vysílač Praděd (Jeseník), [17°13′52″,50°04′59″], 
kanál 36, výkon 100 kW
+T 714000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+# ^-- MUX 3 - Czech Digital Group, vysílač Praděd (Jeseník), 
[17°13′52″,50°04′59″], kanál 51, výkon 100 kW
+T 730000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač Praděd (Jeseník), 
[17°13′52″,50°04′59″], kanál 53, výkon 100 kW
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Praha_Pribram
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Praha_Pribram Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,12 @@
+# Czech Republic, Praha Příbram
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
+# ^-- MUX 1 - Česká televize, vysílač Praha (Příbram), [13°49′04″,49°39′30″], 
kanál 29, výkon 1 kW
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Radhost_Valasske_Mezirici
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Radhost_Valasske_Mezirici Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Radhošť Valašské Meziřičí
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
+# ^-- MUX 2 - České Radiokomunikace, vysílač Radhošť (Valašské Meziřičí), 
[18°13′20″,49°29′31″], kanál 37, výkon 100 W
+T 738000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 1 - Česká televize, vysílač Radhošť (Valašské Meziřičí), 
[18°13′20″,49°29′31″], kanál 54, výkon 100 W
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Rokstejnska_Brtnice
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Rokstejnska_Brtnice Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,12 @@
+# Czech Republic, Rokštejnská Brtnice
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
+# ^-- MUX 1 - Česká televize, vysílač Rokštejnská (Brtnice), 
[15°41′07″,49°18′14″], kanál 33, výkon 10 W
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Rokycany_
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Rokycany_ Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,12 @@
+# Czech Republic, Rokycany
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
+# ^-- MUX 3 - Czech Digital Group, vysílač Rokycany (), [13°35′34″,49°44′39″], 
kanál 52, výkon 2 W
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Rozvodi_Zelezna_Ruda
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Rozvodi_Zelezna_Ruda Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Rozvodí Železná Ruda
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
+# ^-- MUX 1 - Česká televize, vysílač Rozvodí (Železná Ruda), 
[13°11′52″,49°10′28″], kanál 34, výkon 10 W
+T 690000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač Rozvodí (Železná Ruda), 
[13°11′52″,49°10′28″], kanál 48, výkon 10 W
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Semenec_Tyn_nad_Vltavou
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Semenec_Tyn_nad_Vltavou Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Semenec Týn nad Vltavou
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
+# ^-- MUX 2 - České Radiokomunikace, vysílač Semenec (Týn nad Vltavou), 
[14°24′38″,49°14′00″], kanál 39, výkon 10 W
+T 698000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 1 - Česká televize, vysílač Semenec (Týn nad Vltavou), 
[14°24′38″,49°14′00″], kanál 49, výkon 10 W
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Septouchov_Ledec_nad_Sazavou
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Septouchov_Ledec_nad_Sazavou Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Šeptouchov Ledeč nad Sázavou
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
+# ^-- MUX 2 - České Radiokomunikace, vysílač Šeptouchov (Ledeč nad Sázavou), 
[15°16′06″,49°41′43″], kanál 38, výkon 10 W
+T 698000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 1 - Česká televize, vysílač Šeptouchov (Ledeč nad Sázavou), 
[15°16′06″,49°41′43″], kanál 49, výkon 13 W
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Snezna_Kraslice
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Snezna_Kraslice Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Sněžná Kraslice
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
+# ^-- MUX 2 - České Radiokomunikace, vysílač Sněžná (Kraslice), 
[12°30′20″,50°18′41″], kanál 35, výkon 10 W
+T 594000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 1 - Česká televize, vysílač Sněžná (Kraslice), [12°30′20″,50°18′41″], 
kanál 36, výkon 10 W
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Strasice_
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Strasice_ Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,12 @@
+# Czech Republic, Strašice
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
+# ^-- MUX 3 - Czech Digital Group, vysílač Strašice (), [13°45′26″,49°44′04″], 
kanál 55, výkon 4 W
diff -r 4030c51d6e7b -r ebce5e2f10ba 
util/scan/dvb-t/cz-Straznice_Jablonne_nad_Orlici
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Straznice_Jablonne_nad_Orlici Wed May 23 09:19:53 2012 
+0200
@@ -0,0 +1,14 @@
+# Czech Republic, Strážnice Jablonné nad Orlicí
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
+# ^-- MUX 1 - Česká televize, vysílač Strážnice (Jablonné nad Orlicí), 
[16°35′34″,50°01′59″], kanál 29, výkon 10 W
+T 602000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač Strážnice (Jablonné nad Orlicí), 
[16°35′34″,50°01′59″], kanál 37, výkon 10 W
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Strazny_vrch_Trebic
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Strazny_vrch_Trebic Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Strážný vrch Třebíč
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
+# ^-- MUX 1 - Česká televize, vysílač Strážný vrch (Třebíč), 
[15°52′28″,49°12′36″], kanál 33, výkon 5 W
+T 586000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač Strážný vrch (Třebíč), 
[15°52′28″,49°12′36″], kanál 35, výkon 5 W
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Suchy_kamen_Nyrsko
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Suchy_kamen_Nyrsko Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Suchý kámen Nýrsko
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
+# ^-- MUX 1 - Česká televize, vysílač Suchý kámen (Nýrsko), 
[13°07′50″,49°16′36″], kanál 34, výkon 10 W
+T 690000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač Suchý kámen (Nýrsko), 
[13°07′50″,49°16′36″], kanál 48, výkon 10 W
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Suchy_vrch_Kraliky
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Suchy_vrch_Kraliky Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,12 @@
+# Czech Republic, Suchý vrch Králíky
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
+# ^-- MUX 1 - Česká televize, vysílač Suchý vrch (Králíky), 
[16°41′21″,50°03′07″], kanál 43, výkon 50 W
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Svatobor_Susice
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Svatobor_Susice Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,16 @@
+# Czech Republic, Svatobor Sušice
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
+# ^-- MUX 2 - České Radiokomunikace, vysílač Svatobor (Sušice), 
[13°29′23″,49°14′06″], kanál 48, výkon 100 kW
+T 698000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 1 - Česká televize, vysílač Svatobor (Sušice), [13°29′23″,49°14′06″], 
kanál 49, výkon 100 kW
+T 722000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+# ^-- MUX 3 - Czech Digital Group, vysílač Svatobor (Sušice), 
[13°29′23″,49°14′06″], kanál 52, výkon 100 kW
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Tlusta_hora_Zlin
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Tlusta_hora_Zlin Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,16 @@
+# Czech Republic, Tlustá hora Zlín
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
+# ^-- MUX 3 - Czech Digital Group, vysílač Tlustá hora (Zlín), 
[17°38′47″,49°12′30″], kanál 25, výkon 100 kW
+T 570000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 1 - Česká televize, vysílač Tlustá hora (Zlín), 
[17°38′47″,49°12′30″], kanál 33, výkon 100 kW
+T 698000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač Tlustá hora (Zlín), 
[17°38′47″,49°12′30″], kanál 49, výkon 100 kW
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Tri_krize_Karlovy_Vary
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Tri_krize_Karlovy_Vary Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,16 @@
+# Czech Republic, Tři kříže Karlovy Vary
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
+# ^-- MUX 2 - České Radiokomunikace, vysílač Tři kříže (Karlovy Vary), 
[12°53′12″,50°13′39″], kanál 35, výkon 25 W
+T 594000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 1 - Česká televize, vysílač Tři kříže (Karlovy Vary), 
[12°53′12″,50°13′39″], kanál 36, výkon 25 W
+T 786000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+# ^-- MUX 3 - Czech Digital Group, vysílač Tři kříže (Karlovy Vary), 
[12°53′12″,50°13′39″], kanál 60, výkon 25 W
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-UTB_Olsanska_Praha
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-UTB_Olsanska_Praha Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,12 @@
+# Czech Republic, ÚTB Olšanská Praha
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
+# ^-- MUX 4 - Digital Broadcasting, vysílač ÚTB Olšanská (Praha), 
[14°28′09″,50°05′01″], kanál 64, výkon 2 kW
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-U_Sivku_Huslenky
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-U_Sivku_Huslenky Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, U Sivků Huslenky
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
+# ^-- MUX 1 - Česká televize, vysílač U Sivků (Huslenky), 
[18°05′48″,49°19′20″], kanál 29, výkon 25 W
+T 626000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač U Sivků (Huslenky), 
[18°05′48″,49°19′20″], kanál 40, výkon 25 W
diff -r 4030c51d6e7b -r ebce5e2f10ba 
util/scan/dvb-t/cz-U_rozhledny_Frydlant_v_Cechach
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-U_rozhledny_Frydlant_v_Cechach Wed May 23 09:19:53 2012 
+0200
@@ -0,0 +1,14 @@
+# Czech Republic, U rozhledny Frýdlant v Čechách
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
+# ^-- MUX 1 - Česká televize, vysílač U rozhledny (Frýdlant v Čechách), 
[15°04′34″,50°56′07″], kanál 43, výkon 25 W
+T 722000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač U rozhledny (Frýdlant v Čechách), 
[15°04′34″,50°56′07″], kanál 52, výkon 25 W
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Vadin_Okrouhlice
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Vadin_Okrouhlice Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,12 @@
+# Czech Republic, Vadín Okrouhlice
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
+# ^-- MUX 1 - Česká televize, vysílač Vadín (Okrouhlice), 
[15°29′15″,49°38′15″], kanál 54, výkon 100 W
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Vanov_Usti_nad_Labem
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Vanov_Usti_nad_Labem Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Vaňov Ústí nad Labem
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
+# ^-- MUX 1 - Česká televize, vysílač Vaňov (Ústí nad Labem), 
[14°02′15″,50°38′41″], kanál 33, výkon 10 W
+T 770000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač Vaňov (Ústí nad Labem), 
[14°02′15″,50°38′41″], kanál 58, výkon 10 W
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Vetruse_Usti_nad_Labem
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Vetruse_Usti_nad_Labem Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,12 @@
+# Czech Republic, Větruše Ústí nad Labem
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
+# ^-- MUX 1 - Česká televize, vysílač Větruše (Ústí nad Labem), 
[14°02′23″,50°39′18″], kanál 53, výkon 10 W
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Vrani_vrch_Domazlice
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Vrani_vrch_Domazlice Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Vraní vrch Domažlice
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
+# ^-- MUX 1 - Česká televize, vysílač Vraní vrch (Domažlice), 
[12°46′41″,49°28′21″], kanál 34, výkon 10 kW
+T 690000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač Vraní vrch (Domažlice), 
[12°46′41″,49°28′21″], kanál 48, výkon 10 kW
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Vranovsky_vrch_Nemanice
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Vranovsky_vrch_Nemanice Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Vranovský vrch Nemanice
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
+# ^-- MUX 1 - Česká televize, vysílač Vranovský vrch (Nemanice), 
[12°43′49″,49°28′18″], kanál 34, výkon 10 W
+T 690000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač Vranovský vrch (Nemanice), 
[12°43′49″,49°28′18″], kanál 48, výkon 10 W
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Vyhlidka_Nachod
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Vyhlidka_Nachod Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,12 @@
+# Czech Republic, Vyhlídka Náchod
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
+# ^-- MUX 1 - Česká televize, vysílač Vyhlídka (Náchod), [16°10′41″,50°24′17″], 
kanál 53, výkon ?
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Zbiroh_
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Zbiroh_ Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,12 @@
+# Czech Republic, Zbiroh
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
+# ^-- MUX 3 - Czech Digital Group, vysílač Zbiroh (), [13°46′06″,49°51′26″], 
kanál 59, výkon 15 W
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Zelena_hora_Cheb
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Zelena_hora_Cheb Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, Zelená hora Cheb
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
+# ^-- MUX 1 - Česká televize, vysílač Zelená hora (Cheb), 
[12°18′29″,50°04′10″], kanál 36, výkon 20 kW
+T 834000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač Zelená hora (Cheb), 
[12°18′29″,50°04′10″], kanál 66, výkon 20 kW
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Zizkov_Praha
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Zizkov_Praha Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,16 @@
+# Czech Republic, Žižkov Praha
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
+# ^-- MUX 2 - České Radiokomunikace, vysílač Žižkov (Praha), 
[14°27′04″,50°04′52″], kanál 41, výkon 32 kW
+T 730000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 1 - Česká televize, vysílač Žižkov (Praha), [14°27′04″,50°04′52″], 
kanál 53, výkon 32 kW
+T 778000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+# ^-- MUX 3 - Czech Digital Group, vysílač Žižkov (Praha), 
[14°27′04″,50°04′52″], kanál 59, výkon 32 kW
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-Zlaty_Chlum_Jesenik
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-Zlaty_Chlum_Jesenik Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,12 @@
+# Czech Republic, Zlatý Chlum Jeseník
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
+# ^-- MUX 1 - Česká televize, vysílač Zlatý Chlum (Jeseník), 
[17°14′15″,50°14′17″], kanál 36, výkon 100 W
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-nad_ZD_Letohrad
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-nad_ZD_Letohrad Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, nad ZD Letohrad
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
+# ^-- MUX 2 - České Radiokomunikace, vysílač nad ZD (Letohrad), 
[16°31′32″,50°01′56″], kanál 35, výkon 10 W
+T 738000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 1 - Česká televize, vysílač nad ZD (Letohrad), [16°31′32″,50°01′56″], 
kanál 54, výkon 10 W
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-nad_hrbitovem_Jince
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-nad_hrbitovem_Jince Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, nad hřbitovem Jince
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
+# ^-- MUX 2 - České Radiokomunikace, vysílač nad hřbitovem (Jince), 
[13°58′18″,49°46′58″], kanál 41, výkon 10 W
+T 730000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 1 - Česká televize, vysílač nad hřbitovem (Jince), 
[13°58′18″,49°46′58″], kanál 53, výkon 10 W
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-pod_hrbitovem_Rotava
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-pod_hrbitovem_Rotava Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, pod hřbitovem Rotava
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
+# ^-- MUX 2 - České Radiokomunikace, vysílač pod hřbitovem (Rotava), 
[12°34′09″,50°17′49″], kanál 35, výkon 5 W
+T 594000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 1 - Česká televize, vysílač pod hřbitovem (Rotava), 
[12°34′09″,50°17′49″], kanál 36, výkon 5 W
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-u_nadrazi_Horni_Lipova
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-u_nadrazi_Horni_Lipova Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,12 @@
+# Czech Republic, u nádraží Horní Lipová
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
+# ^-- MUX 1 - Česká televize, vysílač u nádraží (Horní Lipová), 
[17°04′58″,50°13′33″], kanál 40, výkon ?
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-ul_Okruzni_Rakovnik
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-ul_Okruzni_Rakovnik Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, ul. Okružní Rakovník
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
+# ^-- MUX 1 - Česká televize, vysílač ul. Okružní (Rakovník), 
[13°43′55″,50°05′43″], kanál 34, výkon 10 W
+T 690000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač ul. Okružní (Rakovník), 
[13°43′55″,50°05′43″], kanál 48, výkon 10 W
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-ul_Udolni_Havlickuv_Brod
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-ul_Udolni_Havlickuv_Brod Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, ul. Údolní Havlíčkův Brod
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
+# ^-- MUX 1 - Česká televize, vysílač ul. Údolní (Havlíčkův Brod), 
[15°34′44″,49°35′49″], kanál 32, výkon 10 W
+T 618000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač ul. Údolní (Havlíčkův Brod), 
[15°34′44″,49°35′49″], kanál 39, výkon 10 W
diff -r 4030c51d6e7b -r ebce5e2f10ba 
util/scan/dvb-t/cz-ul_Zborovska_Namest_nad_Oslavou
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-ul_Zborovska_Namest_nad_Oslavou Wed May 23 09:19:53 
2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, ul. Zborovská Náměšť nad Oslavou
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
+# ^-- MUX 1 - Česká televize, vysílač ul. Zborovská (Náměšť nad Oslavou), 
[16°08′56″,49°12′11″], kanál 29, výkon 10 W
+T 626000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač ul. Zborovská (Náměšť nad 
Oslavou), [16°08′56″,49°12′11″], kanál 40, výkon 10 W
diff -r 4030c51d6e7b -r ebce5e2f10ba util/scan/dvb-t/cz-vrch_Pytlak_Sluknov
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/cz-vrch_Pytlak_Sluknov Wed May 23 09:19:53 2012 +0200
@@ -0,0 +1,14 @@
+# Czech Republic, vrch Pytlák Šluknov
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
+# ^-- MUX 1 - Česká televize, vysílač vrch Pytlák (Šluknov), 
[14°30′34″,50°59′57″], kanál 33, výkon 20 W
+T 770000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
+# ^-- MUX 2 - České Radiokomunikace, vysílač vrch Pytlák (Šluknov), 
[14°30′34″,50°59′57″], kanál 58, výkon 20 W

