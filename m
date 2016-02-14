Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51613 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399AbcBNPXQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Feb 2016 10:23:16 -0500
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 7063313A6A
	for <linux-media@vger.kernel.org>; Sun, 14 Feb 2016 15:23:16 +0000 (UTC)
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH tvtime 2/2] Add Catalan translation
Date: Sun, 14 Feb 2016 16:23:08 +0100
Message-Id: <1455463388-23954-2-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1455463388-23954-1-git-send-email-hdegoede@redhat.com>
References: <1455463388-23954-1-git-send-email-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: https://fedora.zanata.org/project/view/tvtime

BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1306596
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 po/LINGUAS |    2 +-
 po/ca.po   | 1347 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 1348 insertions(+), 1 deletion(-)
 create mode 100644 po/ca.po

diff --git a/po/LINGUAS b/po/LINGUAS
index e07a8ae..6586ddd 100644
--- a/po/LINGUAS
+++ b/po/LINGUAS
@@ -1 +1 @@
-cs de es fi fr hu ko nl nn pl pt pt_BR ru sv lv
+ca cs de es fi fr hu ko nl nn pl pt pt_BR ru sv lv
diff --git a/po/ca.po b/po/ca.po
new file mode 100644
index 0000000..d47ddb1
--- /dev/null
+++ b/po/ca.po
@@ -0,0 +1,1347 @@
+# Robert Antoni Buj Gelonch <rbuj@fedoraproject.org>, 2015. #zanata
+msgid ""
+msgstr ""
+"Project-Id-Version: PACKAGE VERSION\n"
+"Report-Msgid-Bugs-To: http://tvtime.net/\n"
+"POT-Creation-Date: 2015-10-17 12:12-0300\n"
+"PO-Revision-Date: 2015-11-26 05:02-0500\n"
+"Last-Translator: Robert Antoni Buj Gelonch <rbuj@fedoraproject.org>\n"
+"Language-Team: Catalan\n"
+"Language: ca\n"
+"MIME-Version: 1.0\n"
+"Content-Type: text/plain; charset=UTF-8\n"
+"Content-Transfer-Encoding: 8bit\n"
+"X-Generator: Zanata 3.8.2\n"
+"Plural-Forms: nplurals=2; plural=(n != 1);\n"
+
+#: src/tvtime.c:793 src/commands.c:1421 src/commands.c:1446
+msgid "Deinterlacer configuration"
+msgstr "Configuració de l'eina de desentrellaçat"
+
+#: src/tvtime.c:823 src/tvtime.c:842 src/tvtime.c:877 src/tvtime.c:958
+#: src/tvtime.c:986 src/tvtime.c:1121 src/commands.c:413 src/commands.c:454
+#: src/commands.c:654 src/commands.c:688 src/commands.c:708 src/commands.c:777
+#: src/commands.c:812 src/commands.c:870 src/commands.c:941 src/commands.c:990
+#: src/commands.c:1253 src/commands.c:1305 src/commands.c:1366
+#: src/commands.c:1438 src/commands.c:1518 src/commands.c:1530
+#: src/commands.c:1586 src/commands.c:1599 src/commands.c:1630
+#: src/commands.c:1663 src/commands.c:1696 src/commands.c:1728
+msgid "Back"
+msgstr "Enrere"
+
+#: src/tvtime.c:855 src/tvtime.c:998
+#, c-format
+msgid "Full rate: %.2f fps"
+msgstr "Taxa completa: %.2f fps"
+
+#: src/tvtime.c:863 src/tvtime.c:1002
+#, c-format
+msgid "Half rate, deinterlace top fields: %.2f fps"
+msgstr "Taxa mitja, desentrellaça els camps superiors: %.2f fps"
+
+#: src/tvtime.c:870 src/tvtime.c:1006
+#, c-format
+msgid "Half rate, deinterlace bottom fields: %.2f fps"
+msgstr "Taxa mitja, desentrellaça els camps inferiors: %.2f fps"
+
+#: src/tvtime.c:895
+msgid "Overscan setting"
+msgstr "Ajust de la sobre-exploració"
+
+#: src/tvtime.c:902 src/commands.c:1398
+msgid "Apply matte"
+msgstr "Aplica l'estora"
+
+#: src/tvtime.c:910
+msgid "16:9 output"
+msgstr "sortida 16:9"
+
+#: src/tvtime.c:917
+msgid "Resize window to match contents"
+msgstr "Redimensiona la finestra perquè coincideixi amb el contingut"
+
+#: src/tvtime.c:926
+msgid "Fullscreen"
+msgstr "Pantalla completa"
+
+#: src/tvtime.c:933
+msgid "Set fullscreen position"
+msgstr "Estableix la posició de la pantalla completa"
+
+#: src/tvtime.c:943
+msgid "Always-on-top"
+msgstr "Sempre per damunt"
+
+#: src/tvtime.c:952
+msgid "Quiet screenshots"
+msgstr "Captures de pantalla en silenci"
+
+#: src/tvtime.c:969
+msgid "Centre"
+msgstr "Centre"
+
+#: src/tvtime.c:976
+msgid "Top"
+msgstr "Superior"
+
+#: src/tvtime.c:982
+msgid "Bottom"
+msgstr "Inferior"
+
+#: src/tvtime.c:996 src/commands.c:1430 src/commands.c:1460
+msgid "Attempted framerate"
+msgstr "S'ha intentat la taxa de fotogrames"
+
+#: src/tvtime.c:1023
+msgid "Performance estimates"
+msgstr "Estimacions del rendiment"
+
+#: src/tvtime.c:1025
+msgid "Deinterlacer"
+msgstr "Eina de desentrellaçat"
+
+#: src/tvtime.c:1028
+#, c-format
+msgid "Input: %s at %dx%d pixels"
+msgstr "Entrada: %s a %dx%d píxels"
+
+#: src/tvtime.c:1032
+#, c-format
+msgid "Attempted framerate: %.2f fps"
+msgstr "Taxa de fotogrames que es va provar: %.2f fps"
+
+#: src/tvtime.c:1036
+#, c-format
+msgid "Average blit time: %.2f ms (%.0f MB/sec)"
+msgstr "Temps mitjà del BLIT: %.2f ms (%.0f MB/s)"
+
+#: src/tvtime.c:1040
+#, c-format
+msgid "Average render time: %5.2f ms"
+msgstr "Temps mitjà de l'eina de renderitzat: %5.2f ms"
+
+#: src/tvtime.c:1044
+#, c-format
+msgid "Dropped frames: %d"
+msgstr "Fotogrames rebutjats: %d"
+
+#: src/tvtime.c:1050
+#, c-format
+msgid "Blit spacing: %4.1f/%4.1f ms (want %4.1f ms)"
+msgstr "Espai del BLIT: %4.1f/%4.1f ms (vol %4.1f ms)"
+
+#: src/tvtime.c:1069 src/tvtime.c:1131
+msgid "16:9 + Overscan"
+msgstr "16:9 + sobre-exploració"
+
+#: src/tvtime.c:1074 src/tvtime.c:1110
+msgid "1.85:1"
+msgstr "1.85:1"
+
+#: src/tvtime.c:1079 src/tvtime.c:1115
+msgid "2.35:1"
+msgstr "2.35:1"
+
+#: src/tvtime.c:1084 src/tvtime.c:1134
+msgid "4:3 centre"
+msgstr "centre 4:3"
+
+#: src/tvtime.c:1089 src/tvtime.c:1105
+msgid "16:10"
+msgstr "16:10"
+
+#: src/tvtime.c:1095 src/tvtime.c:1138
+msgid "4:3 + Overscan"
+msgstr "4:3 + sobre-exploració"
+
+#: src/tvtime.c:1100
+msgid "16:9"
+msgstr "16:9"
+
+#: src/tvtime.c:1130
+msgid "Matte setting (Anamorphic input)"
+msgstr "Ajust de l'estora (entrada anamòrfica)"
+
+#: src/tvtime.c:1137
+msgid "Matte setting (4:3 input)"
+msgstr "Ajust de l'estora (entrada 4:3)"
+
+#: src/tvtime.c:1216 src/tvtime.c:1269 src/tvtime.c:1313 src/tvtime.c:1321
+#: src/tvtime.c:1421 src/tvtime.c:1471 src/tvtime.c:1492 src/tvtime.c:1506
+#: src/tvtime.c:1520 src/tvtimeconf.c:1010 src/tvtimeconf.c:1220
+#: src/tvtime-command.c:56 src/tvtime-command.c:71 src/tvtime-configure.c:48
+#: src/tvtime-scanner.c:62 src/tvtime-scanner.c:98
+#, c-format
+msgid "%s: Cannot allocate memory.\n"
+msgstr "%s: No pot assignar memòria.\n"
+
+#: src/tvtime.c:1337
+#, c-format
+msgid "Cannot open capture device %s."
+msgstr "No es pot obrir el dispositiu de captura %s."
+
+#: src/tvtime.c:1342
+#, c-format
+msgid ""
+"\n"
+"    Your capture card driver, %s, does not seem\n"
+"    to support full framerate capture.  Please check to see if it is\n"
+"    misconfigured, or if you have selected the wrong capture\n"
+"    device (%s).\n"
+"\n"
+msgstr ""
+"\n"
+"    La vostra targeta capturadora, %s, no sembla\n"
+"    que admeti la captura de tota la taxa de fotogrames. Si us plau, "
+"comproveu\n"
+"    que estigui configurada correctament, o que no hàgiu seleccionat un\n"
+"    dispositiu equivocat (%s).\n"
+"\n"
+
+#: src/tvtime.c:1387
+#, c-format
+msgid ""
+"\n"
+"    Your capture card driver, %s, is not providing\n"
+"    enough buffers for tvtime to process the video.  Please check with\n"
+"    your driver documentation to see if you can increase the number\n"
+"    of buffers provided to applications, and report this to the tvtime\n"
+"    bug tracker at %s\n"
+"\n"
+msgstr ""
+"\n"
+"    La vostra targeta capturadora, %s, no està proporcionant\n"
+"    prou memòria temporal perquè tvtime processi el vídeo. Si us plau, "
+"comproveu\n"
+"    la documentació del vostre controlador per veure si podeu incrementar "
+"la\n"
+"    memòria temporal que es proporciona a les aplicacions, i informeu d'això "
+"a\n"
+"    l'eina de seguiment d'errors de programari del tvtime a %s\n"
+"\n"
+
+#: src/tvtime.c:1440
+msgid "On screen display failed to initialize, disabled.\n"
+msgstr "La visualització en pantalla no es pot inicialitzar i s'inhabilita.\n"
+
+#: src/tvtime.c:1452
+msgid "No video source"
+msgstr "Sense origen de vídeo"
+
+#: src/tvtime.c:1496
+msgid "Cannot create FIFO, remote control of tvtime disabled.\n"
+msgstr ""
+"No es pot crear la FIFO, el control remot de tvtime està deshabilitat.\n"
+
+#: src/tvtime.c:1514
+msgid "Closed caption display failed to initialize, disabled.\n"
+msgstr "No s'han pogut inicialitzar els subtítols i s'inhabiliten.\n"
+
+#: src/tvtime.c:1738
+msgid "Always-on-top enabled."
+msgstr "Sempre per damunt està habilitat."
+
+#: src/tvtime.c:1743
+msgid "Always-on-top disabled."
+msgstr "Sempre per damunt està deshabilitat."
+
+#: src/tvtime.c:1763
+msgid "16:9 display mode active."
+msgstr "El mode de visualització 16:9 està actiu."
+
+#: src/tvtime.c:1772
+msgid "4:3 display mode active."
+msgstr "El mode de visualització 4:3 està actiu."
+
+#: src/tvtime.c:1822
+msgid "Screenshot messages disabled."
+msgstr "Els missatges de captura de pantalla estan deshabilitats."
+
+#: src/tvtime.c:1824
+msgid "Screenshot messages enabled."
+msgstr "Els missatges de captura de pantalla estan habilitats."
+
+#: src/tvtime.c:1915
+msgid "2-3 pulldown inversion disabled."
+msgstr "La inversió desplegable 2-3 està inhabilitada."
+
+#: src/tvtime.c:1918
+msgid "2-3 pulldown inversion enabled."
+msgstr "La inversió desplegable 2-3 està habilitada."
+
+#: src/tvtime.c:1924
+msgid "2-3 pulldown inversion is not valid with your TV norm."
+msgstr "La inversió desplegable 2-3 no és vàlida amb la vostra norma de TV."
+
+#: src/tvtime.c:2324 src/tvtime.c:2470
+#, c-format
+msgid "Screenshot: %s"
+msgstr "Captura de pantalla: %s"
+
+#: src/tvtime.c:2615
+msgid "Restarting tvtime.\n"
+msgstr "S'està reiniciant tvtime.\n"
+
+#: src/tvtime.c:2619
+msgid "Thank you for using tvtime.\n"
+msgstr "Gràcies per utilitzar tvtime.\n"
+
+#: src/tvtime.c:2637 src/tvtime.c:2696
+#, c-format
+msgid ""
+"\n"
+"    Failed to drop root privileges: %s.\n"
+"    tvtime will now exit to avoid security problems.\n"
+"\n"
+msgstr ""
+"\n"
+"    No s'ha pogut baixar els privilegis de root: %s.\n"
+"    tvtime sortirà ara per evitar problemes de seguretat.\n"
+"\n"
+
+#: src/tvtime.c:2655
+#, c-format
+msgid "Running %s.\n"
+msgstr "Execució de %s.\n"
+
+#: src/commands.c:187 src/commands.c:925 src/commands.c:1237
+#: src/commands.c:1614 src/commands.c:1647 src/commands.c:1680
+#: src/commands.c:1713
+msgid "Current"
+msgstr "Actual"
+
+#. TRANSLATORS: This refers to a TV program, not a computer program.
+#: src/commands.c:219 src/commands.c:226
+msgid "No program information available"
+msgstr "No hi ha cap informació del programa"
+
+#: src/commands.c:282
+#, c-format
+msgid "Next: %s"
+msgstr "Següent: %s"
+
+#: src/commands.c:325
+msgid "Renumber current channel"
+msgstr "Torna a numerar el canal actual"
+
+#: src/commands.c:333 src/commands.c:336
+msgid "Current channel active in list"
+msgstr "Canal actiu actualment a la llista"
+
+#: src/commands.c:346
+msgid "Stop channel scan"
+msgstr "Atura l'exploració dels canals"
+
+#: src/commands.c:350
+msgid "Scan channels for signal"
+msgstr "Exploració dels canals pel senyal"
+
+#: src/commands.c:358
+msgid "Reset all channels as active"
+msgstr "Restableix tots els canals com a actius"
+
+#: src/commands.c:364
+msgid "Finetune current channel"
+msgstr "Afina el canal actual"
+
+#: src/commands.c:371
+msgid "Change NTSC cable mode"
+msgstr "Canvia al mode NTSC de cable"
+
+#: src/commands.c:377
+msgid "Set current channel as SECAM"
+msgstr "Estableix el canal actual com a SECAM"
+
+#: src/commands.c:378
+msgid "Set current channel as PAL"
+msgstr "Estableix el canal actual com a PAL"
+
+#: src/commands.c:393
+msgid "Switch audio standard"
+msgstr "Canvia l'estàndard de l'àudio"
+
+#: src/commands.c:400
+msgid "Change frequency table"
+msgstr "Canvia la taula de les freqüències"
+
+#: src/commands.c:406
+msgid "Disable signal detection"
+msgstr "Inhabilita de detecció del senyal"
+
+#: src/commands.c:407
+msgid "Enable signal detection"
+msgstr "Habilita de detecció del senyal"
+
+#: src/commands.c:431 src/commands.c:2006
+msgid "Default language"
+msgstr "Idioma per defecte"
+
+#: src/commands.c:447 src/commands.c:2011
+msgid "Unknown language"
+msgstr "Idioma desconegut"
+
+#: src/commands.c:614 src/commands.c:1275 src/commands.c:1342
+msgid "Preferred audio mode"
+msgstr "Mode d'àudio preferit"
+
+#: src/commands.c:629
+msgid "Change default audio standard"
+msgstr "Canvia l'estàndard d'àudio per defecte"
+
+#: src/commands.c:636 src/commands.c:1280 src/commands.c:1348
+msgid "Audio volume boost"
+msgstr "Potenciació del volum de l'àudio"
+
+#: src/commands.c:642 src/commands.c:1285 src/commands.c:1357
+msgid "Television standard"
+msgstr "Estàndard de televisió"
+
+#: src/commands.c:648 src/commands.c:1290 src/commands.c:1332
+msgid "Horizontal resolution"
+msgstr "Resolució horitzontal"
+
+#: src/commands.c:668 src/commands.c:695
+msgid "Cable"
+msgstr "Cable"
+
+#: src/commands.c:676 src/commands.c:703
+msgid "Broadcast"
+msgstr "Redifusió"
+
+#: src/commands.c:683
+msgid "Cable with channels 100+"
+msgstr "Cable amb 100+ canals"
+
+#: src/commands.c:715
+msgid "Europe"
+msgstr "Europa"
+
+#: src/commands.c:723
+msgid "Russia"
+msgstr "Rússia"
+
+#: src/commands.c:730
+msgid "France"
+msgstr "França"
+
+#: src/commands.c:737
+msgid "Australia"
+msgstr "Austràlia"
+
+#: src/commands.c:744
+msgid "Australia (Optus)"
+msgstr "Austràlia (Optus)"
+
+#: src/commands.c:751
+msgid "New Zealand"
+msgstr "Nova Zelanda"
+
+#: src/commands.c:758
+msgid "China Broadcast"
+msgstr "Redifusió xinesa"
+
+#: src/commands.c:765
+msgid "South Africa"
+msgstr "Sud-àfrica"
+
+#: src/commands.c:772
+msgid "Custom (first run tvtime-scanner)"
+msgstr "Personalitzat (primer executeu tvtime-scanner)"
+
+#: src/commands.c:789
+msgid "Disabled"
+msgstr "Inhabilitat"
+
+#: src/commands.c:795
+msgid "Quiet"
+msgstr "Silenciós"
+
+#: src/commands.c:801
+msgid "Medium"
+msgstr "Mitjà"
+
+#: src/commands.c:807
+msgid "Full"
+msgstr "Complet"
+
+#: src/commands.c:823
+#, c-format
+msgid "%s  Current: %d pixels"
+msgstr "%s actual: %d píxels"
+
+#: src/commands.c:830
+msgid "Low (360 pixels)"
+msgstr "Baix (360 píxels)"
+
+#: src/commands.c:836
+msgid "Moderate (576 pixels)"
+msgstr "Moderat (576 píxels)"
+
+#: src/commands.c:842
+msgid "Standard (720 pixels)"
+msgstr "Estàndard (720 píxels)"
+
+#: src/commands.c:848
+msgid "High (768 pixels)"
+msgstr "Elevat (768 píxels)"
+
+#: src/commands.c:854
+#, c-format
+msgid "%s  Maximum (%d pixels)"
+msgstr "%s màxim (%d píxels)"
+
+#: src/commands.c:864 src/commands.c:1361
+msgid "Restart with new settings"
+msgstr "Reinicia amb els nous ajusts"
+
+#: src/commands.c:931 src/commands.c:1243 src/commands.c:1620
+#: src/commands.c:1653 src/commands.c:1686 src/commands.c:1718
+msgid "Increase"
+msgstr "Incrementa"
+
+#: src/commands.c:936 src/commands.c:1248 src/commands.c:1625
+#: src/commands.c:1658 src/commands.c:1691 src/commands.c:1723
+msgid "Decrease"
+msgstr "Disminueix"
+
+#: src/commands.c:959
+msgid "2-3 pulldown inversion"
+msgstr "Inversió desplegable 2-3"
+
+#: src/commands.c:968
+msgid "Colour invert"
+msgstr "Inversió del color"
+
+#: src/commands.c:976
+msgid "Mirror"
+msgstr "Emmirallament"
+
+#: src/commands.c:984
+msgid "Chroma killer"
+msgstr "Assassí de la croma"
+
+#: src/commands.c:1129 src/commands.c:1169 src/commands.c:1201
+#: src/commands.c:1221 src/commands.c:1233 src/commands.c:1261
+#: src/commands.c:1314 src/commands.c:1332 src/commands.c:1342
+#: src/commands.c:1348 src/commands.c:1357 src/commands.c:1392
+#: src/commands.c:1398 src/commands.c:1404 src/commands.c:1411
+#: src/commands.c:1417 src/commands.c:1445 src/commands.c:1451
+#: src/commands.c:1459 src/commands.c:1465 src/commands.c:1476
+#: src/commands.c:1537 src/commands.c:1610 src/commands.c:1643
+#: src/commands.c:1676 src/commands.c:1709
+msgid "Setup"
+msgstr "Ajust"
+
+#: src/commands.c:1132
+msgid "Last Channel"
+msgstr "Últim canal"
+
+#: src/commands.c:1137 src/commands.c:1201 src/commands.c:1222
+#: src/commands.c:1234
+msgid "Channel management"
+msgstr "Gestió del canal"
+
+#: src/commands.c:1142 src/commands.c:1173 src/commands.c:1262
+#: src/commands.c:1314 src/commands.c:1332 src/commands.c:1342
+#: src/commands.c:1348 src/commands.c:1357
+msgid "Input configuration"
+msgstr "Configuració de l'entrada"
+
+#: src/commands.c:1147 src/commands.c:1178
+msgid "Picture settings"
+msgstr "Ajusts de la imatge"
+
+#: src/commands.c:1152 src/commands.c:1183 src/commands.c:1417
+#: src/commands.c:1446 src/commands.c:1452 src/commands.c:1460
+#: src/commands.c:1466
+msgid "Video processing"
+msgstr "Processament del vídeo"
+
+#: src/commands.c:1157 src/commands.c:1188 src/commands.c:1392
+#: src/commands.c:1398 src/commands.c:1404 src/commands.c:1411
+msgid "Output configuration"
+msgstr "Configuració de la sortida"
+
+#: src/commands.c:1162
+msgid "Quit"
+msgstr "Surt"
+
+#: src/commands.c:1193
+msgid "Exit menu"
+msgstr "Menú de sortida"
+
+#: src/commands.c:1222
+msgid "Frequency table"
+msgstr "Taula de freqüències"
+
+#: src/commands.c:1234 src/commands.c:2968
+msgid "Finetune"
+msgstr "Afina"
+
+#: src/commands.c:1266 src/commands.c:1269 src/commands.c:1318
+#: src/commands.c:1321 src/commands.c:3082 src/commands.c:3112
+msgid "Change video source"
+msgstr "Canvia l'origen del vídeo"
+
+#: src/commands.c:1295
+msgid "Toggle closed captions"
+msgstr "Commuta els subtítols"
+
+#: src/commands.c:1300
+msgid "Toggle XDS decoding"
+msgstr "Commuta la descodificació XDS"
+
+#: src/commands.c:1404
+msgid "Overscan"
+msgstr "Sobre-exploració"
+
+#: src/commands.c:1411
+msgid "Fullscreen position"
+msgstr "Posició de la pantalla completa"
+
+#: src/commands.c:1426
+msgid "Current deinterlacer description"
+msgstr "Descripció de l'eina actual de desentrellaçat"
+
+#: src/commands.c:1434 src/commands.c:1466
+msgid "Input filters"
+msgstr "Filtres d'entrada"
+
+#: src/commands.c:1452
+msgid "Deinterlacer description"
+msgstr "Descripció de l'eina de desentrellaçat"
+
+#: src/commands.c:1476 src/commands.c:1537 src/commands.c:1610
+#: src/commands.c:1643 src/commands.c:1676 src/commands.c:1709
+msgid "Picture"
+msgstr "Imatge"
+
+#: src/commands.c:1480 src/commands.c:1542 src/commands.c:1610
+#: src/commands.c:3142 src/commands.c:3183
+msgid "Brightness"
+msgstr "Brillantor"
+
+#: src/commands.c:1485 src/commands.c:1547 src/commands.c:1643
+#: src/commands.c:3156 src/commands.c:3186
+msgid "Contrast"
+msgstr "Contrast"
+
+#: src/commands.c:1489 src/commands.c:1551 src/commands.c:1676
+#: src/commands.c:3170 src/commands.c:3189
+msgid "Saturation"
+msgstr "Saturació"
+
+#: src/commands.c:1497 src/commands.c:1558 src/commands.c:1709
+#: src/commands.c:3128 src/commands.c:3192
+msgid "Hue"
+msgstr "To"
+
+#: src/commands.c:1506
+msgid "Save current settings as defaults"
+msgstr "Desa els ajusts actuals com als predeterminats"
+
+#: src/commands.c:1512 src/commands.c:1524 src/commands.c:1580
+#: src/commands.c:1593
+msgid "Reset to global defaults"
+msgstr "Restableix als predeterminats globalment"
+
+#: src/commands.c:1567
+msgid "Save current settings as global defaults"
+msgstr "Desa els ajusts actuals com als predeterminats globalment"
+
+#: src/commands.c:1574
+msgid "Save current settings as channel defaults"
+msgstr "Desa els ajusts actuals com als predeterminats del canal"
+
+#: src/commands.c:1742 src/commands.c:2005
+msgid "Preferred XMLTV language"
+msgstr "Idioma preferit del XMLTV"
+
+#: src/commands.c:1837
+msgid "Favorites"
+msgstr "Preferits"
+
+#: src/commands.c:1844
+msgid "Add current channel"
+msgstr "Afegeix el canal actual"
+
+#: src/commands.c:1846
+msgid "Exit"
+msgstr "Surt"
+
+#: src/commands.c:2208
+#, c-format
+msgid "Sleep in %d minutes."
+msgstr "Repòs en %d minuts."
+
+#: src/commands.c:2211
+#, c-format
+msgid "Sleep off."
+msgstr "Repòs apagat."
+
+#: src/commands.c:2250
+#, c-format
+msgid "Using PAL-I audio decoding for this channel."
+msgstr "S'està utilitzant la descodificació d'àudio PAL-I per aquest canal."
+
+#: src/commands.c:2253
+#, c-format
+msgid "Using PAL-DK audio decoding for this channel."
+msgstr "S'està utilitzant la descodificació d'àudio PAL-DK per aquest canal."
+
+#: src/commands.c:2256
+#, c-format
+msgid "Using PAL-BG audio decoding for this channel."
+msgstr "S'està utilitzant la descodificació d'àudio PAL-BG per aquest canal."
+
+#: src/commands.c:2287
+#, c-format
+msgid "Defaulting to PAL-I audio decoding."
+msgstr "S'està definint com per defecte la descodificació d'àudio PAL-I."
+
+#: src/commands.c:2290
+#, c-format
+msgid "Defaulting to PAL-DK audio decoding."
+msgstr "S'està definint com per defecte la descodificació d'àudio PAL-DK."
+
+#: src/commands.c:2293
+#, c-format
+msgid "Defaulting to PAL-BG audio decoding."
+msgstr "S'està definint com per defecte la descodificació d'àudio PAL-BG."
+
+#: src/commands.c:2321
+msgid "Channel marked as active in the browse list."
+msgstr "El canal s'ha marcat com a actiu a la llista d'exploració."
+
+#: src/commands.c:2324
+msgid "Channel disabled from the browse list."
+msgstr "El canal s'ha deshabilitat de la llista d'exploració."
+
+#: src/commands.c:2356
+#, c-format
+msgid "Capture card volume will not be set by tvtime."
+msgstr "El volum de la targeta de captura no s'establirà amb tvtime."
+
+#: src/commands.c:2359
+#, c-format
+msgid "Setting capture card volume to %d%%."
+msgstr "S'està establint el volum de la targeta de captura al %d%%."
+
+#: src/commands.c:2392
+msgid "Processing every input field."
+msgstr "S'està processant tot el camp d'entrada."
+
+#: src/commands.c:2395
+msgid "Processing every top field."
+msgstr "S'està processant tot el camp superior."
+
+#: src/commands.c:2398
+msgid "Processing every bottom field."
+msgstr "S'està processant tot el camp inferior."
+
+#: src/commands.c:2412
+#, c-format
+msgid "Horizontal resolution will be %d pixels on restart."
+msgstr "La resolució horitzontal serà de %d píxels en reiniciar."
+
+#: src/commands.c:2469
+#, c-format
+msgid "Television standard will be %s on restart."
+msgstr "L'estàndard de televisió serà %s en reiniciar."
+
+#: src/commands.c:2497
+#, c-format
+msgid "Using default language for XMLTV data."
+msgstr "S'està utilitzant l'idioma per defecte per a les dades del XMLTV."
+
+#: src/commands.c:2500
+#, c-format
+msgid "Using unknown language (%s) for XMLTV data."
+msgstr "S'està utilitzant un idioma desconegut (%s) per a les dades del XMLTV."
+
+#: src/commands.c:2504
+#, c-format
+msgid "XMLTV language set to %s (%s)."
+msgstr "L'idioma XMLTV està establert a %s (%s)."
+
+#: src/commands.c:2539
+msgid "All channels re-activated."
+msgstr "Tots els canals estan reactivats."
+
+#: src/commands.c:2560
+#, c-format
+msgid "Remapping %d.  Enter new channel number."
+msgstr "Reassignació %d. Introduïu el nou número del canal."
+
+#: src/commands.c:2572
+msgid "Scanner unavailable with signal checking disabled."
+msgstr ""
+"L'eina d'exploració no està disponible amb la comprovació inhabilitada del "
+"senyal."
+
+#: src/commands.c:2602
+msgid "Scanning for channels being broadcast."
+msgstr "Exploració dels canals que s'estan transmetent."
+
+#: src/commands.c:2620
+msgid "Closed captions disabled."
+msgstr "Els subtítols estan inhabilitats."
+
+#: src/commands.c:2626
+msgid "Closed captions enabled."
+msgstr "Els subtítols estan habilitats."
+
+#: src/commands.c:2638
+msgid "No VBI device configured for CC decoding."
+msgstr ""
+"No hi ha cap dispositiu VBI que estigui configurat per a la descodificació "
+"CC."
+
+#: src/commands.c:2654
+#, c-format
+msgid "Colour decoding for this channel set to %s."
+msgstr "La descodificació del color d'aquest canal està establerta a %s."
+
+#: src/commands.c:2703
+#, c-format
+msgid "Running: %s"
+msgstr "Execució: %s"
+
+#: src/commands.c:2747
+msgid "Signal detection enabled."
+msgstr "La detecció del senyal està habilitada."
+
+#: src/commands.c:2750
+msgid "Signal detection disabled."
+msgstr "La detecció del senyal està inhabilitada."
+
+#: src/commands.c:2763
+msgid "XDS decoding enabled."
+msgstr "La descodificació XDS està habilitada."
+
+#: src/commands.c:2766
+msgid "XDS decoding disabled."
+msgstr "La descodificació XDS està inhabilitada."
+
+#: src/commands.c:2811
+msgid "Colour invert enabled."
+msgstr "La inversió del color està habilitada."
+
+#: src/commands.c:2813
+msgid "Colour invert disabled."
+msgstr "La inversió del color està inhabilitada."
+
+#: src/commands.c:2834
+msgid "Mirror enabled."
+msgstr "L'emmirallament està habilitat."
+
+#: src/commands.c:2836
+msgid "Mirror disabled."
+msgstr "L'emmirallament està inhabilitat."
+
+#: src/commands.c:2857
+msgid "Chroma kill enabled."
+msgstr "L'assassinat de la croma està habilitat."
+
+#: src/commands.c:2859
+msgid "Chroma kill disabled."
+msgstr "L'assassinat de la croma està inhabilitat."
+
+#: src/commands.c:2871
+#, c-format
+msgid "Overscan: %.1f%%"
+msgstr "Sobre-exploració: %.1f%%"
+
+#: src/commands.c:2903
+msgid "Picture settings reset to defaults."
+msgstr "Els ajusts de la imatge s'han restablert als predeterminats."
+
+#: src/commands.c:2931
+msgid "Using nominal NTSC cable frequencies."
+msgstr "S'estan utilitzant les freqüències de cable nominals de NTSC. "
+
+#: src/commands.c:2937
+msgid "Using IRC cable frequencies."
+msgstr "S'utilitzen les freqüències IRC de cable."
+
+#: src/commands.c:2943
+msgid "Using HRC cable frequencies."
+msgstr "S'utilitzen les freqüències HRC de cable."
+
+#: src/commands.c:3027 src/commands.c:3049
+msgid "Volume"
+msgstr "Volum"
+
+#: src/commands.c:3229
+msgid "Saved current picture settings as global defaults.\n"
+msgstr ""
+"S'han desat els ajusts actuals de la imatge com als predeterminats "
+"globalment.\n"
+
+#: src/commands.c:3242
+#, c-format
+msgid "Saved current picture settings on channel %d.\n"
+msgstr "S'han desat els ajusts actuals d'imatge al canal %d.\n"
+
+#: src/commands.c:3329
+msgid "Paused."
+msgstr "Pausat."
+
+#: src/commands.c:3329
+msgid "Resumed."
+msgstr "Reprès."
+
+#: src/tvtimeconf.c:491
+#, c-format
+msgid "Error parsing configuration file %s.\n"
+msgstr "S'ha produït un error en analitzar el fitxer %s.\n"
+
+#: src/tvtimeconf.c:498
+#, c-format
+msgid "No XML root element found in %s.\n"
+msgstr "No s'ha trobat l'element arrel XML a %s.\n"
+
+#: src/tvtimeconf.c:506 src/tvtimeconf.c:580
+#, c-format
+msgid "%s is not a tvtime configuration file.\n"
+msgstr "%s no és un fitxer de configuració de tvtime.\n"
+
+#: src/tvtimeconf.c:538
+msgid "Config file cannot be parsed. Settings will not be saved.\n"
+msgstr ""
+"No es pot analitzar el fitxer de configuració. No es desaran els ajusts.\n"
+
+#: src/tvtimeconf.c:545
+msgid "Could not create new config file.\n"
+msgstr "No s'ha pogut crear el nou fitxer de configuració.\n"
+
+#: src/tvtimeconf.c:569
+msgid "Error creating configuration file.\n"
+msgstr "S'ha produït un error en crear el fitxer de configuració.\n"
+
+#: src/tvtimeconf.c:590 src/utils.c:134
+#, c-format
+msgid "Cannot change owner of %s: %s.\n"
+msgstr "No es pot canviar el propietari de %s: %s.\n"
+
+#: src/tvtimeconf.c:599
+msgid ""
+"\n"
+"tvtime is free software, written by Billy Biggs, Doug Bell and many\n"
+"others.  For details and copying conditions, please see our website\n"
+"at http://tvtime.net/\n"
+"\n"
+"tvtime is Copyright (C) 2001, 2002, 2003 by Billy Biggs, Doug Bell,\n"
+"Alexander S. Belov, and Achim Schneider.\n"
+msgstr ""
+"\n"
+"tvtime és programari lliure, l'ha escrit en Billy Biggs, en Doug Bell i "
+"molts\n"
+"altres. Per als detalls i condicions de còpia, si us plau, visiteu la "
+"nostra\n"
+"pàgina web a http://tvtime.net/\n"
+"\n"
+"tvtime està sota el Copyright (C) 2001, 2002, 2003 de Billy Biggs, Doug "
+"Bell,\n"
+"Alexander S. Belov i Achim Schneider.\n"
+
+#: src/tvtimeconf.c:610 src/tvtimeconf.c:665 src/tvtimeconf.c:724
+#, c-format
+msgid ""
+"usage: %s [OPTION]...\n"
+"\n"
+msgstr ""
+"ús: %s [OPCIÓ]...\n"
+"\n"
+
+#: src/tvtimeconf.c:611 src/tvtimeconf.c:666
+msgid "  -a, --widescreen           16:9 mode.\n"
+msgstr "  -a, --widescreen           Mode 16:9.\n"
+
+#: src/tvtimeconf.c:612 src/tvtimeconf.c:667
+msgid "  -A, --nowidescreen         4:3 mode.\n"
+msgstr "  -A, --nowidescreen         Mode 4:3.\n"
+
+#: src/tvtimeconf.c:613 src/tvtimeconf.c:668
+msgid "  -b, --vbidevice=DEVICE     VBI device (defaults to /dev/vbi0).\n"
+msgstr ""
+"  -b, --vbidevice=DISPOSITIU Dispositiu VBI (per defecte és /dev/vbi0).\n"
+
+#: src/tvtimeconf.c:614 src/tvtimeconf.c:669
+msgid ""
+"  -c, --channel=CHANNEL      Tune to the specified channel on startup.\n"
+msgstr ""
+"  -c, --channel=CANAL        Sintonitza el canal especificat a l'inici.\n"
+
+#: src/tvtimeconf.c:615 src/tvtimeconf.c:670 src/tvtimeconf.c:725
+msgid ""
+"  -d, --device=DEVICE        video4linux device (defaults to /dev/video0).\n"
+msgstr ""
+"  -d, --device=DISPOSITIU    Dispositiu video4linux (per defecte és /dev/"
+"video0).\n"
+
+#: src/tvtimeconf.c:616 src/tvtimeconf.c:671
+msgid ""
+"  -f, --frequencies=NAME     The frequency table to use for the tuner.\n"
+"                             (defaults to us-cable).\n"
+"\n"
+"                             Valid values are:\n"
+"                                 us-cable\n"
+"                                 us-cable100\n"
+"                                 us-broadcast\n"
+"                                 china-broadcast\n"
+"                                 southafrica\n"
+"                                 japan-cable\n"
+"                                 japan-broadcast\n"
+"                                 europe\n"
+"                                 australia\n"
+"                                 australia-optus\n"
+"                                 newzealand\n"
+"                                 france\n"
+"                                 russia\n"
+"                                 custom (first run tvtime-scanner)\n"
+"\n"
+msgstr ""
+"  -f, --frequencies=NOM      La taula de freqüències per utilitzar amb el "
+"sintonitzador.\n"
+"                             (per defecte és us-cable).\n"
+"\n"
+"                             Els valors vàlids són:\n"
+"                                 us-cable\n"
+"                                 us-cable100\n"
+"                                 us-broadcast\n"
+"                                 china-broadcast\n"
+"                                 southafrica\n"
+"                                 japan-cable\n"
+"                                 japan-broadcast\n"
+"                                 europe\n"
+"                                 australia\n"
+"                                 australia-optus\n"
+"                                 newzealand\n"
+"                                 france\n"
+"                                 russia\n"
+"                                 custom (primer executeu tvtime-scanner)\n"
+"\n"
+
+#: src/tvtimeconf.c:633 src/tvtimeconf.c:688 src/tvtimeconf.c:726
+msgid ""
+"  -F, --configfile=FILE      Additional config file to load settings from.\n"
+msgstr ""
+"  -F, --configfile=FITXER    Fitxer addicional de configuració per carregar "
+"els ajusts.\n"
+
+#: src/tvtimeconf.c:634 src/tvtimeconf.c:689 src/tvtimeconf.c:727
+msgid "  -h, --help                 Show this help message.\n"
+msgstr "  -h, --help                 Mostra aquest missatge d'ajuda.\n"
+
+#: src/tvtimeconf.c:635 src/tvtimeconf.c:690
+msgid "  -g, --geometry=GEOMETRY    Sets the output window size.\n"
+msgstr ""
+"  -g, --geometry=GEOMETRIA   Estableix les mides de la finestra de sortida.\n"
+
+#: src/tvtimeconf.c:636 src/tvtimeconf.c:691 src/tvtimeconf.c:728
+msgid ""
+"  -i, --input=INPUTNUM       video4linux input number (defaults to 0).\n"
+msgstr ""
+"  -i, --input=NUMENTRADA     Número d'entrada de video4linux (per defecte és "
+"0).\n"
+
+#: src/tvtimeconf.c:637 src/tvtimeconf.c:692
+msgid ""
+"  -I, --inputwidth=SAMPLING  Horizontal resolution of input\n"
+"                             (defaults to 720 pixels).\n"
+msgstr ""
+"  -I, --inputwidth=MOSTREIG  Resolució horitzontal de l'entrada\n"
+"                             (per defecte són 720 píxels).\n"
+
+#: src/tvtimeconf.c:639
+msgid ""
+"  -k, --slave                Disables input handling in tvtime (slave "
+"mode).\n"
+msgstr ""
+"  -k, --slave                Inhabilita el tractament de l'entrada al tvtime "
+"(mode esclau).\n"
+
+#: src/tvtimeconf.c:640 src/tvtimeconf.c:694
+msgid "  -m, --fullscreen           Start tvtime in fullscreen mode.\n"
+msgstr ""
+"  -m, --fullscreen           Inicia tvtime en mode pantalla completa.\n"
+
+#: src/tvtimeconf.c:641 src/tvtimeconf.c:695
+msgid "  -l, --borderless           Start tvtime without a window border.\n"
+msgstr ""
+"  -l, --borderless           Inicia tvtime sense vores a la finestra.\n"
+
+#: src/tvtimeconf.c:642 src/tvtimeconf.c:696
+msgid "  -M, --window               Start tvtime in window mode.\n"
+msgstr "  -M, --window               Inicia tvtime en mode finestra.\n"
+
+#: src/tvtimeconf.c:643 src/tvtimeconf.c:697 src/tvtimeconf.c:729
+msgid ""
+"  -n, --norm=NORM            The norm to use for the input.  tvtime "
+"supports:\n"
+"                             NTSC, NTSC-JP, SECAM, PAL, PAL-Nc, PAL-M,\n"
+"                             PAL-N or PAL-60 (defaults to NTSC).\n"
+msgstr ""
+"  -n, --norm=NORMA           La norma a utilitzar per a l'entrada. tvtime "
+"admet:\n"
+"                             NTSC, NTSC-JP, SECAM, PAL, PAL-Nc, PAL-M,\n"
+"                             PAL-N o PAL-60 (per defecte és NTSC).\n"
+
+#: src/tvtimeconf.c:646
+msgid ""
+"  -s, --showdrops            Print stats on frame drops (for debugging).\n"
+msgstr ""
+"  -s, --showdrops            Mostra les estadístiques quant als fotogrames "
+"rebutjats (depuració).\n"
+
+#: src/tvtimeconf.c:647
+msgid ""
+"  -S, --saveoptions          Save command line options to the config file.\n"
+msgstr ""
+"  -S, --saveoptions          Desa les opcions de la línia d'ordres al fitxer "
+"de configuració.\n"
+
+#: src/tvtimeconf.c:648 src/tvtimeconf.c:701
+msgid "  -t, --xmltv=FILE           Read XMLTV listings from the given file.\n"
+msgstr ""
+"  -t, --xmltv=FITXER         Llegeix els llistats XMLTV del fitxer indicat.\n"
+
+#: src/tvtimeconf.c:649 src/tvtimeconf.c:702
+msgid ""
+"  -l, --xmltvlanguage=LANG   Use XMLTV data in given language, if "
+"available.\n"
+msgstr ""
+"  -l, --xmltvlanguage=LANG   Utilitza les dades XMLTV en l'idioma indicat, "
+"si estan disponibles.\n"
+
+#: src/tvtimeconf.c:650
+msgid "  -v, --verbose              Print debugging messages to stderr.\n"
+msgstr ""
+"  -v, --verbose              Imprimeix els missatges de depuració al "
+"stderr.\n"
+
+#: src/tvtimeconf.c:651
+msgid "  -X, --display=DISPLAY      Use the given X display to connect to.\n"
+msgstr ""
+"  -X, --display=DISPLAY      Utilitza el monitor indicat de les X per "
+"connectar.\n"
+
+#: src/tvtimeconf.c:652 src/tvtimeconf.c:703
+msgid ""
+"  -x, --mixer=<DEVICE[:CH]>|<DEVICE/CH>\n"
+"                             The mixer device and channel to control. The "
+"first\n"
+"                             variant sets the OSS mixer the second one "
+"ALSA.\n"
+"                             (defaults to default/Master)\n"
+"\n"
+"                             Valid channels for OSS are:\n"
+"                                 vol, bass, treble, synth, pcm, speaker, "
+"line,\n"
+"                                 mic, cd, mix, pcm2, rec, igain, ogain, "
+"line1,\n"
+"                                 line2, line3, dig1, dig2, dig3, phin, "
+"phout,\n"
+"                                 video, radio, monitor\n"
+msgstr ""
+"  -x, --mixer=<DISPOSITIU[:CANAL]>|<DISPOSITIU/CANAL>\n"
+"                             El dispositiu mesclador i el canal a controlar. "
+"La primera\n"
+"                             variant estableix el mesclador OSS i la segona "
+"el d'ALSA.\n"
+"                             (per defecte és default/Master)\n"
+"\n"
+"                             Els canals vàlids per OSS són:\n"
+"                                 vol, bass, treble, synth, pcm, speaker, "
+"line,\n"
+"                                 mic, cd, mix, pcm2, rec, igain, ogain, "
+"line1,\n"
+"                                 line2, line3, dig1, dig2, dig3, phin, "
+"phout,\n"
+"                                 video, radio, monitor\n"
+
+#: src/tvtimeconf.c:700
+msgid ""
+"  -R, --priority=PRI         Sets the process priority to run tvtime at.\n"
+msgstr ""
+"  -R, --priority=PRI         Estableix la prioritat per a l'execució de "
+"tvtime.\n"
+
+#: src/tvtimeconf.c:712
+msgid ""
+"  -p, --alsainputdev=DEV     Specifies an ALSA device to read input on\n"
+"                                 Examples:\n"
+"                                          hw:1,0\n"
+"                                          disabled\n"
+msgstr ""
+"  -p, --alsainputdev=DEV     Especifica un dispositiu ALSA per llegir "
+"l'entrada\n"
+"                                 Exemples:\n"
+"                                          hw:1,0\n"
+"                                          disabled\n"
+
+#: src/tvtimeconf.c:716
+msgid ""
+"  -P, --alsaoutputdev=DEV    Specifies an ALSA device to write output to\n"
+"                                 Examples:\n"
+"                                          hw:0,0\n"
+"                                          disabled\n"
+msgstr ""
+"  -P, --alsaoutputdev=DEV    Especifica un dispositiu ALSA per escriure-hi "
+"la sortida\n"
+"                                 Exemples:\n"
+"                                          hw:0,0\n"
+"                                          disabled\n"
+
+#: src/tvtimeconf.c:896 src/tvtimeconf.c:905 src/tvtimeconf.c:979
+#: src/tvtimeconf.c:1120 src/tvtimeconf.c:1307
+#, c-format
+msgid "Reading configuration from %s\n"
+msgstr "Lectura de la configuració de %s\n"
+
+#: src/tvtimeconf.c:1017
+msgid "Cannot run two instances of tvtime with the same configuration.\n"
+msgstr ""
+"No es poden executar dues instàncies de tvtime amb la mateixa configuració.\n"
+
+#: src/tvtimeconf.c:1028
+msgid "Saving command line options.\n"
+msgstr "S'estan desant les opcions de la línia d'ordres.\n"
+
+#: src/tvtimeconf.c:1227
+msgid "Cannot update configuration while tvtime running.\n"
+msgstr ""
+"No es pot actualitzar la configuració mentre tvtime s'estigui executant.\n"
+
+#: src/tvtimeosd.c:344 src/tvtime-scanner.c:145
+msgid "No signal"
+msgstr "Sense senyal"
+
+#: src/tvtimeosd.c:455
+msgid "Mute"
+msgstr "Silencia"
+
+#: src/utils.c:118
+#, c-format
+msgid "Cannot create %s: %s\n"
+msgstr "No es pot crear %s: %s\n"
+
+#: src/utils.c:124
+#, c-format
+msgid "Cannot open %s: %s\n"
+msgstr "No es pot obrir %s: %s\n"
+
+#: src/utils.c:663
+#, c-format
+msgid "Failed to initialize UTF-8 to %s converter: iconv_open failed (%s).\n"
+msgstr ""
+"No s'ha pogut inicialitzar UTF-8 al convertidor %s: iconv_open ha fallat "
+"(%s).\n"
+
+#: src/utils.c:674
+#, c-format
+msgid ""
+"\n"
+"    Failed to enter UTF-8 mode using bind_textdomain_codeset()\n"
+"    (returned %s.)  This may cause messages\n"
+"    to be displayed incorrectly!  Please report this bug at\n"
+"    %s.\n"
+"\n"
+msgstr ""
+"\n"
+"    No s'ha pogut entrar al mode UTF-8 mitjançant bind_textdomain_codeset()\n"
+"    (va retornar %s.) Això pot provocar que els missatges\n"
+"    no es mostrin correctament! Si us plau, informeu d'aquest error a\n"
+"    %s.\n"
+"\n"
+
+#: src/tvtime-command.c:61
+#, c-format
+msgid ""
+"\n"
+"Available commands:\n"
+msgstr ""
+"\n"
+"Ordres disponibles:\n"
+
+#: src/tvtime-command.c:80
+#, c-format
+msgid "tvtime not running.\n"
+msgstr "tvtime no s'està executant.\n"
+
+#: src/tvtime-command.c:82 src/tvtime-command.c:92
+#, c-format
+msgid "%s: Cannot open %s: %s\n"
+msgstr "%s: No es pot obrir %s: %s\n"
+
+#: src/tvtime-command.c:103
+#, c-format
+msgid "%s: Invalid command '%s'\n"
+msgstr "%s: L'ordre «%s» no és vàlida\n"
+
+#: src/tvtime-command.c:108
+#, c-format
+msgid "%s: Sending command %s with argument %s.\n"
+msgstr "%s: S'està enviant l'ordre %s amb l'argument %s.\n"
+
+#: src/tvtime-command.c:113
+#, c-format
+msgid "%s: Sending command %s.\n"
+msgstr "%s: S'està enviant l'ordre %s.\n"
+
+#: src/tvtime-scanner.c:92
+#, c-format
+msgid "Scanning using TV standard %s.\n"
+msgstr "Exploració mitjançant l'estàndard %s de TV.\n"
+
+#: src/tvtime-scanner.c:116
+#, c-format
+msgid ""
+"\n"
+"    No tuner found on input %d.  If you have a tuner, please\n"
+"    select a different input using --input=<num>.\n"
+"\n"
+msgstr ""
+"\n"
+"    No s'ha trobat cap sintonitzador en l'entrada %d. Si teniu un "
+"sintonitzador, si us plau,\n"
+"    seleccioneu una entrada diferent mitjançant --input=<núm>.\n"
+"\n"
+
+#: src/tvtime-scanner.c:127
+#, c-format
+msgid "Scanning from %6.2f MHz to %6.2f MHz.\n"
+msgstr "Exploració dels %6.2f MHz als %6.2f MHz.\n"
+
+#: src/tvtime-scanner.c:138
+#, c-format
+msgid "Checking %6.2f MHz:"
+msgstr "Comprovant %6.2f MHz:"
+
+#: src/tvtime-scanner.c:149 src/tvtime-scanner.c:156
+msgid "Signal detected"
+msgstr "Senyal detectat"
+
+#: src/tvtime-scanner.c:168
+#, c-format
+msgid ""
+"Found a channel at %6.2f MHz (%.2f - %.2f MHz), adding to channel list.\n"
+msgstr ""
+"S'ha trobat un canal als %6.2f MHz (%.2f - %.2f MHz) i s'afegeix a la llista "
+"dels canals.\n"
+
+#~ msgid "Mono"
+#~ msgstr "Mono"
+
+#~ msgid "Stereo"
+#~ msgstr "Estèreo"
+
+#~ msgid "SAP"
+#~ msgstr "SAP"
+
+#~ msgid "Primary Language"
+#~ msgstr "Idioma primari"
+
+#~ msgid "Secondary Language"
+#~ msgstr "Idioma secundari"
-- 
2.7.1

