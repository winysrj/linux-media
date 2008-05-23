Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp1.dnainternet.fi ([87.94.96.108])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1JzaR3-0003hG-4S
	for linux-dvb@linuxtv.org; Fri, 23 May 2008 18:48:08 +0200
Message-ID: <4836F51E.7070403@iki.fi>
Date: Fri, 23 May 2008 19:47:26 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Christoph Pfister <christophpfister@gmail.com>
Content-Type: multipart/mixed; boundary="------------040801080106080408070407"
Cc: linux-dvb@linuxtv.org
Subject: [linux-dvb] [PATCH] update Finland initial DVB-T tuning files
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--------------040801080106080408070407
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

moikka
patch updates Finland DVB-T tuning files.

regards,
Antti
-- 
http://palosaari.fi/

--------------040801080106080408070407
Content-Type: application/x-perl;
 name="fi-intial-tuning.pl"
Content-Disposition: inline;
 filename="fi-intial-tuning.pl"
Content-Transfer-Encoding: quoted-printable

#!/usr/bin/python -OO
# -*- coding: utf-8 -*-
# (c) 2008 Antti Palosaari <crope@iki.fi>
# v1.1

# download pdf from http://www.digitv.fi/sivu.asp?path=3D1;8224;9519
# pdftotext -raw 2008_Kanavat\ ja\ taajuudet.pdf=20

import os
import sys
import re
import struct
import string
import codecs

fread =3D file( sys.argv[1], "r" )

# Finland uses UHF channels 21-69
ch_min =3D 21
ch_max =3D 69

for line in fread.readlines():
#	print "raw line: " + line
	m =3D re.match(r'^[\w\s,.=C3=84=C3=A4=C3=96=C3=B6=C3=85=C3=A5\*\-]*[\d]{=
1,2}[\s]{1}[\d]{3}.*$', line)
	if not m:
		print "SKIPPED: " + line
	else:
		# replace scandic characters
		line =3D re.sub(r'=C3=84', "A", line)
		line =3D re.sub(r'=C3=A4', "a", line)
		line =3D re.sub(r'=C3=96', "O", line)
		line =3D re.sub(r'=C3=B6', "o", line)
		line =3D re.sub(r'=C3=85', "A", line)
		line =3D re.sub(r'=C3=A5', "a", line)

		# remove all unspecified chars from beginning of line
		line =3D re.sub(r'^[^a-zA-Z=C3=84=C3=A4=C3=96=C3=B6=C3=85=C3=A5]*', "",=
 line)

		line =3D re.sub(r'[,]', "", line) # remove ','
		line =3D re.sub(r'[,]', "", line) # remove ','
		line =3D re.sub(r'[\ ](?=3D[\D])', '_', line); # replace ' ' with '_'
		line =3D "fi-" + line # add "fi-"
#		print line

		elem =3D re.split( ' ', line )
		for i in range(len(elem)):
			elem[i] =3D elem[i].strip()

		for i in range(len(elem)):
			if i =3D=3D 0:
				data =3D  "# automatically generated from http://www.digitv.fi/sivu.a=
sp?path=3D1;8224;9519\n"
				data +=3D "# T freq bw fec_hi fec_lo mod transmission-mode guard-inte=
rval hierarchy\n"
				fwrite =3D open("./data/" + elem[i], "wb")
			elif (i % 2): # ch number
				if int(elem[i]) < ch_min or int(elem[i]) > ch_max:
					print "ERROR: chan number not valid " + str(elem[i])
			elif (not i % 2): # freq
				data +=3D "T " + str(elem[i]) + "000000 8MHz 2/3 NONE QAM64 8k 1/8 NO=
NE\n"
		fwrite.write(data)
fread.close()
fwrite.close()

--------------040801080106080408070407
Content-Type: text/x-patch;
 name="fi-update_2008-05-23.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fi-update_2008-05-23.patch"

diff -r 31a6dd437b9a util/scan/dvb-t/fi-Enontekio_Ahovaara_Raattama
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Enontekio_Ahovaara_Raattama	Fri May 23 19:44:35 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 514000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 570000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Haapavesi
--- a/util/scan/dvb-t/fi-Haapavesi	Wed May 14 19:15:22 2008 +0200
+++ b/util/scan/dvb-t/fi-Haapavesi	Fri May 23 19:44:35 2008 +0300
@@ -3,3 +3,4 @@ T 578000000 8MHz 2/3 NONE QAM64 8k 1/8 N
 T 578000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 642000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 730000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 762000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Hyrynsalmi
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Hyrynsalmi	Fri May 23 19:44:35 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 626000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 658000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Hyrynsalmi_Kyparavaara
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Hyrynsalmi_Kyparavaara	Fri May 23 19:44:35 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 626000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 658000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Hyrynsalmi_Paljakka
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Hyrynsalmi_Paljakka	Fri May 23 19:44:35 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 482000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 522000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Ii_Raiskio
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Ii_Raiskio	Fri May 23 19:44:35 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 578000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 690000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Jamsa_Ouninpohja
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Jamsa_Ouninpohja	Fri May 23 19:44:35 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 498000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 530000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Joroinen_Puukkola
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Joroinen_Puukkola	Fri May 23 19:44:35 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 482000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 514000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Joutseno
--- a/util/scan/dvb-t/fi-Joutseno	Wed May 14 19:15:22 2008 +0200
+++ b/util/scan/dvb-t/fi-Joutseno	Fri May 23 19:44:35 2008 +0300
@@ -3,3 +3,4 @@ T 682000000 8MHz 2/3 NONE QAM64 8k 1/8 N
 T 682000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 586000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 762000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 562000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Juupajoki_Kopsamo
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Juupajoki_Kopsamo	Fri May 23 19:44:35 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 578000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 490000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Jyvaskylan_mlk_Vaajakoski
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Jyvaskylan_mlk_Vaajakoski	Fri May 23 19:44:35 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 546000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 786000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Kaavi_Sivakkavaara_Luikonlahti
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Kaavi_Sivakkavaara_Luikonlahti	Fri May 23 19:44:35 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 530000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 650000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Kalajoki
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Kalajoki	Fri May 23 19:44:35 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 578000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 642000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Karkkila
--- a/util/scan/dvb-t/fi-Karkkila	Wed May 14 19:15:22 2008 +0200
+++ b/util/scan/dvb-t/fi-Karkkila	Fri May 23 19:44:35 2008 +0300
@@ -1,6 +1,6 @@
 # automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 594000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 650000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 618000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 762000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 698000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Kemijarvi_Suomutunturi
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Kemijarvi_Suomutunturi	Fri May 23 19:44:35 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 602000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 706000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Kerimaki
--- a/util/scan/dvb-t/fi-Kerimaki	Wed May 14 19:15:22 2008 +0200
+++ b/util/scan/dvb-t/fi-Kerimaki	Fri May 23 19:44:35 2008 +0300
@@ -3,3 +3,4 @@ T 546000000 8MHz 2/3 NONE QAM64 8k 1/8 N
 T 546000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 602000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 570000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 770000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Kolari_Vuolittaja
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Kolari_Vuolittaja	Fri May 23 19:44:35 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 506000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 530000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Koli
--- a/util/scan/dvb-t/fi-Koli	Wed May 14 19:15:22 2008 +0200
+++ b/util/scan/dvb-t/fi-Koli	Fri May 23 19:44:35 2008 +0300
@@ -3,3 +3,4 @@ T 506000000 8MHz 2/3 NONE QAM64 8k 1/8 N
 T 506000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 626000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 682000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 714000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Kruunupyy
--- a/util/scan/dvb-t/fi-Kruunupyy	Wed May 14 19:15:22 2008 +0200
+++ b/util/scan/dvb-t/fi-Kruunupyy	Fri May 23 19:44:35 2008 +0300
@@ -2,4 +2,5 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 522000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 482000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 634000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 658000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Kuhmo_Iivantiira
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Kuhmo_Iivantiira	Fri May 23 19:44:35 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 490000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 506000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Kuhmoinen_Puukkoinen
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Kuhmoinen_Puukkoinen	Fri May 23 19:44:35 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 562000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 610000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Kyyjarvi_Noposenaho
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Kyyjarvi_Noposenaho	Fri May 23 19:44:35 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 530000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 586000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Lavia_Lavianjarvi
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Lavia_Lavianjarvi	Fri May 23 19:44:35 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 498000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 554000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Lieksa_Vieki
--- a/util/scan/dvb-t/fi-Lieksa_Vieki	Wed May 14 19:15:22 2008 +0200
+++ b/util/scan/dvb-t/fi-Lieksa_Vieki	Fri May 23 19:44:35 2008 +0300
@@ -2,3 +2,4 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 610000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 698000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 594000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Loimaa
--- a/util/scan/dvb-t/fi-Loimaa	Wed May 14 19:15:22 2008 +0200
+++ b/util/scan/dvb-t/fi-Loimaa	Fri May 23 19:44:35 2008 +0300
@@ -1,5 +1,5 @@
 # automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 650000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 754000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 682000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 722000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Mikkeli
--- a/util/scan/dvb-t/fi-Mikkeli	Wed May 14 19:15:22 2008 +0200
+++ b/util/scan/dvb-t/fi-Mikkeli	Fri May 23 19:44:35 2008 +0300
@@ -3,3 +3,4 @@ T 538000000 8MHz 2/3 NONE QAM64 8k 1/8 N
 T 538000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 650000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 778000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 610000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Nilsia_Keski-Siikajarvi
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Nilsia_Keski-Siikajarvi	Fri May 23 19:44:35 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 706000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 730000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Nilsia_Pisa
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Nilsia_Pisa	Fri May 23 19:44:35 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 498000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 554000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Orivesi_Langelmaki_Talviainen
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Orivesi_Langelmaki_Talviainen	Fri May 23 19:44:35 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 610000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 698000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Paltamo_Kivesvaara
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Paltamo_Kivesvaara	Fri May 23 19:44:35 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 514000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 618000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Pieksamaki_Halkokumpu
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Pieksamaki_Halkokumpu	Fri May 23 19:44:35 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 714000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 762000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Pihtipudas
--- a/util/scan/dvb-t/fi-Pihtipudas	Wed May 14 19:15:22 2008 +0200
+++ b/util/scan/dvb-t/fi-Pihtipudas	Fri May 23 19:44:35 2008 +0300
@@ -2,3 +2,4 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 706000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 666000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 770000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Pudasjarvi_Kangasvaara
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Pudasjarvi_Kangasvaara	Fri May 23 19:44:35 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 514000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 538000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Puolanka
--- a/util/scan/dvb-t/fi-Puolanka	Wed May 14 19:15:22 2008 +0200
+++ b/util/scan/dvb-t/fi-Puolanka	Fri May 23 19:44:35 2008 +0300
@@ -2,3 +2,4 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 642000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 666000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 650000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Pylkonmaki_Karankajarvi
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Pylkonmaki_Karankajarvi	Fri May 23 19:44:35 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 594000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 642000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Raahe_Mestauskallio
--- a/util/scan/dvb-t/fi-Raahe_Mestauskallio	Wed May 14 19:15:22 2008 +0200
+++ b/util/scan/dvb-t/fi-Raahe_Mestauskallio	Fri May 23 19:44:35 2008 +0300
@@ -2,3 +2,4 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 546000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 618000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 658000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Raahe_Piehinki
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Raahe_Piehinki	Fri May 23 19:44:35 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 578000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 642000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Ranua_Leppiaho
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Ranua_Leppiaho	Fri May 23 19:44:35 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 562000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 594000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Rovaniemi
--- a/util/scan/dvb-t/fi-Rovaniemi	Wed May 14 19:15:22 2008 +0200
+++ b/util/scan/dvb-t/fi-Rovaniemi	Fri May 23 19:44:35 2008 +0300
@@ -2,3 +2,4 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 650000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 674000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 730000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Rovaniemi_Karhuvaara_Marrasjarvi
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Rovaniemi_Karhuvaara_Marrasjarvi	Fri May 23 19:44:35 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 506000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 530000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Rovaniemi_Marasenkallio
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Rovaniemi_Marasenkallio	Fri May 23 19:44:35 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 650000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 674000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Rovaniemi_Sonka
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Rovaniemi_Sonka	Fri May 23 19:44:35 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 650000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 674000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Saarijarvi_Kalmari
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Saarijarvi_Kalmari	Fri May 23 19:44:35 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 594000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 642000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Saarijarvi_Mahlu
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Saarijarvi_Mahlu	Fri May 23 19:44:35 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 482000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 522000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Salla_Hirvasvaara
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Salla_Hirvasvaara	Fri May 23 19:44:35 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 626000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 658000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Salla_Sallatunturi
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Salla_Sallatunturi	Fri May 23 19:44:35 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 514000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 610000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Salo_Isokyla
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Salo_Isokyla	Fri May 23 19:44:35 2008 +0300
@@ -0,0 +1,6 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 482000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 666000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 682000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 570000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Savukoski_Martti_Haarahonganmaa
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Savukoski_Martti_Haarahonganmaa	Fri May 23 19:44:35 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 522000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 594000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Savukoski_Tanhua
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Savukoski_Tanhua	Fri May 23 19:44:35 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 514000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 602000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Taivalkoski_Taivalvaara
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Taivalkoski_Taivalvaara	Fri May 23 19:44:35 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 594000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 626000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Tammela
--- a/util/scan/dvb-t/fi-Tammela	Wed May 14 19:15:22 2008 +0200
+++ b/util/scan/dvb-t/fi-Tammela	Fri May 23 19:44:35 2008 +0300
@@ -3,3 +3,4 @@ T 482000000 8MHz 2/3 NONE QAM64 8k 1/8 N
 T 482000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 522000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 706000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 650000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Tervola
--- a/util/scan/dvb-t/fi-Tervola	Wed May 14 19:15:22 2008 +0200
+++ b/util/scan/dvb-t/fi-Tervola	Fri May 23 19:44:35 2008 +0300
@@ -2,3 +2,4 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 626000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 642000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 658000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Turku
--- a/util/scan/dvb-t/fi-Turku	Wed May 14 19:15:22 2008 +0200
+++ b/util/scan/dvb-t/fi-Turku	Fri May 23 19:44:35 2008 +0300
@@ -1,6 +1,6 @@
 # automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 714000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 698000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 538000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 738000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 762000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 786000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Utsjoki_Nuorgam_Njallavaara
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Utsjoki_Nuorgam_Njallavaara	Fri May 23 19:44:35 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 594000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 674000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Utsjoki_Nuorgam_raja
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Utsjoki_Nuorgam_raja	Fri May 23 19:44:35 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 594000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 674000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Utsjoki_Outakoski
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Utsjoki_Outakoski	Fri May 23 19:44:35 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 706000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 698000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Utsjoki_Polvarniemi
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Utsjoki_Polvarniemi	Fri May 23 19:44:35 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 706000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 698000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Utsjoki_Rovisuvanto
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Utsjoki_Rovisuvanto	Fri May 23 19:44:35 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 530000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 578000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Utsjoki_Tenola
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Utsjoki_Tenola	Fri May 23 19:44:35 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 610000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 634000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Uusikaupunki_Orivo
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Uusikaupunki_Orivo	Fri May 23 19:44:35 2008 +0300
@@ -0,0 +1,5 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 482000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 514000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 554000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Vammala_Jyranvuori
--- a/util/scan/dvb-t/fi-Vammala_Jyranvuori	Wed May 14 19:15:22 2008 +0200
+++ b/util/scan/dvb-t/fi-Vammala_Jyranvuori	Fri May 23 19:44:35 2008 +0300
@@ -1,5 +1,5 @@
 # automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 594000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 746000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 754000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 690000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Vammala_Roismala
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Vammala_Roismala	Fri May 23 19:44:35 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 514000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 562000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Vammala_Savi
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Vammala_Savi	Fri May 23 19:44:35 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 674000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 698000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Vuokatti
--- a/util/scan/dvb-t/fi-Vuokatti	Wed May 14 19:15:22 2008 +0200
+++ b/util/scan/dvb-t/fi-Vuokatti	Fri May 23 19:44:35 2008 +0300
@@ -2,4 +2,5 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 546000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 722000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 746000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 754000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 778000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 31a6dd437b9a util/scan/dvb-t/fi-Ylitornio_Raanujarvi
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/fi-Ylitornio_Raanujarvi	Fri May 23 19:44:35 2008 +0300
@@ -0,0 +1,4 @@
+# automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 570000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 618000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE

--------------040801080106080408070407
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------040801080106080408070407--
