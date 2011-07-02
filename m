Return-path: <mchehab@pedra>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:43941 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452Ab1GBVcr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Jul 2011 17:32:47 -0400
Message-ID: <4E0F8E71.9020709@free.fr>
Date: Sat, 02 Jul 2011 23:32:33 +0200
From: mossroy <mossroy@free.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Johann Ollivier Lapeyre <johann.ollivierlapeyre@gmail.com>,
	Alexis de Lattre <alexis@via.ecp.fr>,
	Christoph Pfister <christophpfister@gmail.com>,
	n_estre@yahoo.fr, alkahan@free.fr, ben@geexbox.org,
	xavier@dalaen.com, jean-michel.baudrey@orange.fr,
	lissyx@lissyx.dyndns.org, sylvestre.cartier@gmail.com,
	brossard.damien@gmail.com, jean-michel-62@orange.fr
Subject: Re: Updates to French scan files
References: <4DFFA7B6.9070906@free.fr>	<4DFFA917.5060509@iki.fi>	<4E017D7D.4050307@free.fr>	<BANLkTimQymz5K6YhhUgPeWjMFkkVoU6j4A@mail.gmail.com>	<4E079E9F.7050004@free.fr>	<1309125622.5421.15.camel@wide> <BANLkTi=we3eOeFq6ru245i20e5uD-YRyMA@mail.gmail.com>
In-Reply-To: <BANLkTi=we3eOeFq6ru245i20e5uD-YRyMA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The following patch deletes the 19 remaining fr-* files, as most of them 
are outdated.

I tested auto-Default and it worked for me (I tested on tvheadend. See 
https://www.lonelycoder.com/redmine/issues/570 ).
Could the other French users test auto-Default (and 
auto-With167kHzOffsets if necessary) to confirm we don't need more 
frequencies?


diff -upN dvb-t-original/fr-Brest dvb-t/fr-Brest
--- dvb-t-original/fr-Brest    2011-06-26 17:32:59.000000000 +0200
+++ dvb-t/fr-Brest    1970-01-01 01:00:00.000000000 +0100
@@ -1,9 +0,0 @@
-# Brest - France
-# Emetteur du Roch Tredudon
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 546000000 8MHz 1/2 NONE QAM16 8k 1/32 NONE
-T 578000000 8MHz 1/2 NONE QAM16 8k 1/32 NONE
-T 586000000 8MHz 1/2 NONE QAM16 8k 1/32 NONE
-T 618000000 8MHz 1/2 NONE QAM16 8k 1/32 NONE
-T 650000000 8MHz 1/2 NONE QAM16 8k 1/32 NONE
-T 770000000 8MHz 1/2 NONE QAM16 8k 1/32 NONE
diff -upN dvb-t-original/fr-Chambery dvb-t/fr-Chambery
--- dvb-t-original/fr-Chambery    2011-06-26 17:32:59.000000000 +0200
+++ dvb-t/fr-Chambery    1970-01-01 01:00:00.000000000 +0100
@@ -1,24 +0,0 @@
-# Chambery - France (DVB-T transmitter of Chambery )
-# Chambery - France (signal DVB-T transmis depuis l'emetteur de Chambery )
-#
-# Ce fichier a ete ecrit par Yann Soubeyrand (04/2010)
-# Si vous constatez des problemes et voulez apporter des
-# modifications au fichier, envoyez le fichier modifie a
-# l'adresse linux-dvb@linuxtv.org (depot des fichiers d'init dvb)
-# ou au mainteneur du fichier :
-# Nicolas Estre <n_estre@yahoo.fr>
-#
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-#### Chambery - Defini par Alex le 23/05/2008 pour l'emetteur des monts
-# R1 canal 62
-T 802167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-# R2 canal 48
-T 690167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-# R3 canal 51
-T 714167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-# R4 canal 54
-T 738167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-# R5 canal 59
-T 778167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-# R6 canal 47
-T 682167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
diff -upN dvb-t-original/fr-Laval dvb-t/fr-Laval
--- dvb-t-original/fr-Laval    2011-06-26 17:32:59.000000000 +0200
+++ dvb-t/fr-Laval    1970-01-01 01:00:00.000000000 +0100
@@ -1,25 +0,0 @@
-# Laval - France (DVB-T transmitter of Laval ( MontRochard ) )
-# Laval - France (signal DVB-T transmis depuis l'émetteur de MontRochard )
-#
-# ATTENTION ! Ce fichier a ete construit automatiquement a partir
-# des frequences obtenues sur : 
http://www.tvnt.net/multiplex_frequences.htm
-# en Avril 2006. Si vous constatez des problemes et voulez apporter des
-# modifications au fichier, envoyez le fichier modifie a
-# l'adresse linux-dvb@linuxtv.org (depot des fichiers d'init dvb)
-# ou a l'auteur du fichier :
-# Nicolas Estre <n_estre@yahoo.fr>
-#
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-#### Laval - MontRochard ####
-#R1
-T 714000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-#R2
-T 570000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-#R3
-T 770000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-#R4
-T 762000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-#R5
-T 650000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-#R6
-T 786000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
diff -upN dvb-t-original/fr-LeMans dvb-t/fr-LeMans
--- dvb-t-original/fr-LeMans    2011-06-26 17:32:59.000000000 +0200
+++ dvb-t/fr-LeMans    1970-01-01 01:00:00.000000000 +0100
@@ -1,21 +0,0 @@
-# Le Mans - France (DVB-T transmitter of Mayet)
-# Le Mans - France (signal DVB-T transmis depuis l'émetteur de Mayet   )
-# Pour plus d'informations vous pouvez consulter :
-#  - le topic sur l'émetteur de Mayet sur le forum du site tvnt.net :
-# http://www.tvnt.net/forum/viewtopic.php?t=48
-#  - le site de TDF : http://tnt.niv2.com/72100-LE-MANS.html
-# contact : Matthieu Duchemin <alkahan@free.fr>
-
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-# R1 : Canal 26
-T 514000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-# R2 : Canal 23
-T 490000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-# R3 : Canal 56
-T 754000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-# R4 : Canal 31
-T 554000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-# R5 : Canal 37
-T 602000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-# R6 : Canal 36
-T 594000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
diff -upN dvb-t-original/fr-Lyon-Fourviere dvb-t/fr-Lyon-Fourviere
--- dvb-t-original/fr-Lyon-Fourviere    2011-06-26 17:32:59.000000000 +0200
+++ dvb-t/fr-Lyon-Fourviere    1970-01-01 01:00:00.000000000 +0100
@@ -1,18 +0,0 @@
-# Lyon - France (DVB-T transmitter of Fourvière)
-# Lyon - France (signal DVB-T transmis depuis l'émetteur de Fourvière)
-# see : http://tnt.niv2.com/69000-LYON.html
-# contact : Nicolas Estre <n_estre@yahoo.fr>
-
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-# R1 : Canal 56
-T 754167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-# R2 : Canal 36
-T 594167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-# R3 : Canal 21
-T 474167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-# R4 : Canal 54
-T 738167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-# R5 : Canal 27
-T 522167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-# R6 : Canal 24
-T 498167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
diff -upN dvb-t-original/fr-Lyon-Pilat dvb-t/fr-Lyon-Pilat
--- dvb-t-original/fr-Lyon-Pilat    2011-06-26 17:32:59.000000000 +0200
+++ dvb-t/fr-Lyon-Pilat    1970-01-01 01:00:00.000000000 +0100
@@ -1,17 +0,0 @@
-# Lyon - France (DVB-T transmitter of Mt Pilat)
-# Lyon - France (signal DVB-T transmis depuis l'émetteur du Mont Pilat)
-# see : http://tnt.niv2.com/69000-LYON.html
-# contact : Nicolas Estre <n_estre@yahoo.fr>
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-# R1 : Canal 45
-T 666000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-# R2 : Canal 36
-T 594000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-# R3 : Canal 39
-T 618000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-# R4 : Canal 54
-T 738000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-# R5 : Canal 42
-T 642000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-# R6 : Canal 47
-T 682000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
diff -upN dvb-t-original/fr-Marseille dvb-t/fr-Marseille
--- dvb-t-original/fr-Marseille    2011-06-26 17:32:59.000000000 +0200
+++ dvb-t/fr-Marseille    1970-01-01 01:00:00.000000000 +0100
@@ -1,6 +0,0 @@
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 506000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-T 530000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-T 546000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-T 778000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-T 802000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
diff -upN dvb-t-original/fr-Nancy dvb-t/fr-Nancy
--- dvb-t-original/fr-Nancy    2011-06-26 17:32:59.000000000 +0200
+++ dvb-t/fr-Nancy    1970-01-01 01:00:00.000000000 +0100
@@ -1,25 +0,0 @@
-# Nancy - France (DVB-T transmitter of Nancy ( Nondéfini ) )
-# Nancy - France (signal DVB-T transmis depuis l'émetteur de Nondéfini )
-#
-# ATTENTION ! Ce fichier a ete construit automatiquement a partir
-# des frequences obtenues sur : 
http://www.tvnt.net/multiplex_frequences.htm
-# en Avril 2006. Si vous constatez des problemes et voulez apporter des
-# modifications au fichier, envoyez le fichier modifie a
-# l'adresse linux-dvb@linuxtv.org (depot des fichiers d'init dvb)
-# ou a l'auteur du fichier :
-# Nicolas Estre <n_estre@yahoo.fr>
-#
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-#### Nancy - Nondéfini ####
-#R1
-T 522166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-#R2
-T 682166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-#R3
-T 794166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-#R4
-T 770166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-#R5
-T 498166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-#R6
-T 826166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
diff -upN dvb-t-original/fr-Niort dvb-t/fr-Niort
--- dvb-t-original/fr-Niort    2011-06-26 17:32:59.000000000 +0200
+++ dvb-t/fr-Niort    1970-01-01 01:00:00.000000000 +0100
@@ -1,7 +0,0 @@
-# Niort - France (DVB-T transmitter of Niort-Maisonnay)
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 498000000 8MHz 1/2 NONE QAM16 8k 1/32 NONE
-T 602000000 8MHz 1/2 NONE QAM16 8k 1/32 NONE
-T 738000000 8MHz 1/2 NONE QAM16 8k 1/32 NONE
-T 778000000 8MHz 1/2 NONE QAM16 8k 1/32 NONE
-T 802000000 8MHz 1/2 NONE QAM16 8k 1/32 NONE
diff -upN dvb-t-original/fr-Orleans dvb-t/fr-Orleans
--- dvb-t-original/fr-Orleans    2011-06-26 17:32:59.000000000 +0200
+++ dvb-t/fr-Orleans    1970-01-01 01:00:00.000000000 +0100
@@ -1,17 +0,0 @@
-# Orléans / France
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-#
-# R2: canal 38 : direct8 TMC Gulli europe2 bfm itélé
-T 610166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-
-# R1: canal 46 : F2 F3 F4 F5 arte LCP
-T 674166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-
-# R4: canal 48 : M6 W9 NT1
-T 690166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-
-# R6: canal 51 : TF1 NRJ12
-T 714166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-
-# R3: canal 63 : canalplus
-T 810166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
diff -upN dvb-t-original/fr-Paris dvb-t/fr-Paris
--- dvb-t-original/fr-Paris    2011-06-26 17:32:59.000000000 +0200
+++ dvb-t/fr-Paris    1970-01-01 01:00:00.000000000 +0100
@@ -1,19 +0,0 @@
-# Paris - France - various DVB-T transmitters
-# contributed by Alexis de Lattre <alexis@via.ecp.fr>
-# Paris - Tour Eiffel      : 21 24 27 29 32 35
-# Paris Est - Chennevières : 35 51 54 57 60 63
-# Paris Nord - Sannois     : 35 51 54 57 60 63
-# Paris Sud - Villebon     : 35 51 56 57 60 63
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 474166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-T 498166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-T 522166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-T 538166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-T 562166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-T 586166000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
-T 714166000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
-T 738166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-T 754166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-T 762166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-T 786166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-T 810166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
diff -upN dvb-t-original/fr-Rennes dvb-t/fr-Rennes
--- dvb-t-original/fr-Rennes    2011-06-26 17:32:59.000000000 +0200
+++ dvb-t/fr-Rennes    1970-01-01 01:00:00.000000000 +0100
@@ -1,7 +0,0 @@
-# Rennes - France
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 562000000 8MHz 1/2 NONE QAM16 8k 1/32 NONE
-T 586000000 8MHz 1/2 NONE QAM16 8k 1/32 NONE
-T 650000000 8MHz 1/2 NONE QAM16 8k 1/32 NONE
-T 674000000 8MHz 1/2 NONE QAM16 8k 1/32 NONE
-T 626000000 8MHz 1/2 NONE QAM16 8k 1/32 NONE
diff -upN dvb-t-original/fr-Rochefort-sur-mer dvb-t/fr-Rochefort-sur-mer
--- dvb-t-original/fr-Rochefort-sur-mer    2011-06-26 17:32:59.000000000 
+0200
+++ dvb-t/fr-Rochefort-sur-mer    1970-01-01 01:00:00.000000000 +0100
@@ -1,14 +0,0 @@
-# TNT à Rochefort (17)
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-
-#multiplex 6 ( TF1 LCI Eurosport TF6 NRJ12 TMC )
-T 498166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-
-#multiplex 4 ( M6 W9 NT1 Paris Première ARTE HD )
-T 738166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-
-#multiplex 1 ( France 2 France 3 France 5 ARTE LCP Chaîne locale ou 
France Ô )
-T 602166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-
-#multiplex 2 ( Direct 8 France 4 BFM TV Virgin 17 Gulli i>Télé  )
-T 778167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
diff -upN dvb-t-original/fr-Rouen dvb-t/fr-Rouen
--- dvb-t-original/fr-Rouen    2011-06-26 17:32:59.000000000 +0200
+++ dvb-t/fr-Rouen    1970-01-01 01:00:00.000000000 +0100
@@ -1,8 +0,0 @@
-# Rouen - France
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 538000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-T 474000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-T 522000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-T 498000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-T 602000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-T 562000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
diff -upN dvb-t-original/fr-Strasbourg dvb-t/fr-Strasbourg
--- dvb-t-original/fr-Strasbourg    2011-06-26 17:32:59.000000000 +0200
+++ dvb-t/fr-Strasbourg    1970-01-01 01:00:00.000000000 +0100
@@ -1,18 +0,0 @@
-# Strasbourg - France (DVB-T transmitter of Strasbourg (Nordheim))
-# contributed by Benjamin Zores <ben@geexbox.org>
-#
-# Strasbourg - Nordheim: 22 47 48 51 61 69
-# See 
http://www.tvnt.net/V2/pages/342/medias/pro-bo-doc-tk-frequences_tnt.pdf
-#
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 482000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-T 570000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE
-T 618000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE
-T 682000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-T 690000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-T 698000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE
-T 714000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-T 722000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE
-T 786000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE
-T 794000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-T 858000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
diff -upN dvb-t-original/fr-Toulouse dvb-t/fr-Toulouse
--- dvb-t-original/fr-Toulouse    2011-06-26 17:32:59.000000000 +0200
+++ dvb-t/fr-Toulouse    1970-01-01 01:00:00.000000000 +0100
@@ -1,8 +0,0 @@
-# Toulouse - France (DVB-T transmitter of Bohnoure)
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 754167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-T 698167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-T 722167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-T 714167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-T 746167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-T 730167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
diff -upN dvb-t-original/fr-Vannes dvb-t/fr-Vannes
--- dvb-t-original/fr-Vannes    2011-06-26 17:32:59.000000000 +0200
+++ dvb-t/fr-Vannes    1970-01-01 01:00:00.000000000 +0100
@@ -1,7 +0,0 @@
-# Vannes / France
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 674167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-T 698167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-T 762167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-T 778167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-T 818167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
diff -upN dvb-t-original/fr-Villebon dvb-t/fr-Villebon
--- dvb-t-original/fr-Villebon    2011-06-26 17:32:59.000000000 +0200
+++ dvb-t/fr-Villebon    1970-01-01 01:00:00.000000000 +0100
@@ -1,22 +0,0 @@
-# Paris - France (DVB-T transmitter of Villebon )
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-
-# Villebon - France (DVB-T transmitter of Villebon (South of Paris))
-# Villebon - France (signal DVB-T transmis depuis l'émetteur de 
Villebon (Sud de Paris))
-# see : http://tnt.niv2.com/91140-VILLEBON-SUR-YVETTE.html
-# contact : Nicolas Estre <n_estre@yahoo.fr>
-
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-#### VILLEBON SUR YVETTE ####
-#R1 35
-T 586000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
-#R2 56
-T 754000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-#R3 60
-T 786000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-#R4 63
-T 810000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-#R5 51
-T 714000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
-#R6 57
-T 762000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE

