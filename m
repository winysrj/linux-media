Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f48.google.com ([209.85.214.48]:37981 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887Ab3I1LIT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Sep 2013 07:08:19 -0400
Received: by mail-bk0-f48.google.com with SMTP id my13so1299222bkb.21
        for <linux-media@vger.kernel.org>; Sat, 28 Sep 2013 04:08:18 -0700 (PDT)
MIME-Version: 1.0
From: =?UTF-8?Q?Nuno_Gon=C3=A7alves?= <nunojpg@gmail.com>
Date: Sat, 28 Sep 2013 12:07:58 +0100
Message-ID: <CAEXMXLQVj+4t5yi0mL8=1Kb9kXn8V40=W0ED9Zz7YeCjjzMcMQ@mail.gmail.com>
Subject: Initial scan files for PT
To: linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary=20cf30223bf5cc617504e76f9eab
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--20cf30223bf5cc617504e76f9eab
Content-Type: text/plain; charset=UTF-8

Here goes the initial scan files for Portugal DVB-T. Please commit them.

Portugal is schedule to migrate from a SFN to a MFN, but for now this
is how it is.

Files in attach and also the hg diff:


diff -r 3ee111da5b3a util/scan/dvb-t/pt-Azores-Faial
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/pt-Azores-Faial Sat Sep 28 11:49:03 2013 +0100
@@ -0,0 +1,5 @@
+# PT, Azores, Faial
+# Generated from http://tdt-portugal.blogspot.pt/
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 698000000 8MHz  2/3 NONE    QAM64   8k  1/4 NONE
+
diff -r 3ee111da5b3a util/scan/dvb-t/pt-Azores-Pico
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/pt-Azores-Pico Sat Sep 28 11:49:03 2013 +0100
@@ -0,0 +1,5 @@
+# PT, Azores, Pico
+# Generated from http://tdt-portugal.blogspot.pt/
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 754000000 8MHz  2/3 NONE    QAM64   8k  1/4 NONE
+
diff -r 3ee111da5b3a util/scan/dvb-t/pt-Azores-SaoJorge
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/pt-Azores-SaoJorge Sat Sep 28 11:49:03 2013 +0100
@@ -0,0 +1,5 @@
+# PT, Azores, Sao Jorge
+# Generated from http://tdt-portugal.blogspot.pt/
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 682000000 8MHz  2/3 NONE    QAM64   8k  1/4 NONE
+
diff -r 3ee111da5b3a util/scan/dvb-t/pt-Azores-SaoMiguel-Graciosa
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/pt-Azores-SaoMiguel-Graciosa Sat Sep 28 11:49:03
2013 +0100
@@ -0,0 +1,5 @@
+# PT, Azores, Sao Miguel and Graciosa
+# Generated from http://tdt-portugal.blogspot.pt/
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 690000000 8MHz  2/3 NONE    QAM64   8k  1/4 NONE
+
diff -r 3ee111da5b3a util/scan/dvb-t/pt-Azores-Terceira-SMaria-Flores-Corvo
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/pt-Azores-Terceira-SMaria-Flores-Corvo Sat Sep
28 11:49:03 2013 +0100
@@ -0,0 +1,5 @@
+# PT, Azores, Terceira and S. Maria and Graciosa
+# Generated from http://tdt-portugal.blogspot.pt/
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 738000000 8MHz  2/3 NONE    QAM64   8k  1/4 NONE
+
diff -r 3ee111da5b3a util/scan/dvb-t/pt-Madeira
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/pt-Madeira Sat Sep 28 11:49:03 2013 +0100
@@ -0,0 +1,5 @@
+# PT, Madeira
+# Generated from http://tdt-portugal.blogspot.pt/
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 738000000 8MHz  2/3 NONE    QAM64   8k  1/4 NONE
+
diff -r 3ee111da5b3a util/scan/dvb-t/pt-mainland
--- /dev/null Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/pt-mainland Sat Sep 28 11:49:03 2013 +0100
@@ -0,0 +1,7 @@
+# PT, mainland
+# Generated from http://tdt-portugal.blogspot.pt/
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 642000000 8MHz  2/3 NONE    QAM64   8k  1/4 NONE # Monte da Virgem
+T 674000000 8MHz  2/3 NONE    QAM64   8k  1/4 NONE # Lousa (Trevim)
+T 698000000 8MHz  2/3 NONE    QAM64   8k  1/4 NONE # Montejunto
+T 754000000 8MHz  2/3 NONE    QAM64   8k  1/4 NONE # Mainland SFN


Regards,
Nuno Goncalves

--20cf30223bf5cc617504e76f9eab
Content-Type: application/octet-stream; name=pt-Azores-Faial
Content-Disposition: attachment; filename=pt-Azores-Faial
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hm4p8es30

IyBQVCwgQXpvcmVzLCBGYWlhbAojIEdlbmVyYXRlZCBmcm9tIGh0dHA6Ly90ZHQtcG9ydHVnYWwu
YmxvZ3Nwb3QucHQvCiMgVCBmcmVxIGJ3IGZlY19oaSBmZWNfbG8gbW9kIHRyYW5zbWlzc2lvbi1t
b2RlIGd1YXJkLWludGVydmFsIGhpZXJhcmNoeQpUIDY5ODAwMDAwMCA4TUh6ICAyLzMgTk9ORSAg
ICBRQU02NCAgIDhrICAxLzQgTk9ORQoK
--20cf30223bf5cc617504e76f9eab
Content-Type: application/octet-stream; name=pt-Azores-Pico
Content-Disposition: attachment; filename=pt-Azores-Pico
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hm4p8esh1

IyBQVCwgQXpvcmVzLCBQaWNvCiMgR2VuZXJhdGVkIGZyb20gaHR0cDovL3RkdC1wb3J0dWdhbC5i
bG9nc3BvdC5wdC8KIyBUIGZyZXEgYncgZmVjX2hpIGZlY19sbyBtb2QgdHJhbnNtaXNzaW9uLW1v
ZGUgZ3VhcmQtaW50ZXJ2YWwgaGllcmFyY2h5ClQgNzU0MDAwMDAwIDhNSHogIDIvMyBOT05FICAg
IFFBTTY0ICAgOGsgIDEvNCBOT05FCgo=
--20cf30223bf5cc617504e76f9eab
Content-Type: application/octet-stream; name=pt-Azores-SaoJorge
Content-Disposition: attachment; filename=pt-Azores-SaoJorge
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hm4p8esn2

IyBQVCwgQXpvcmVzLCBTYW8gSm9yZ2UKIyBHZW5lcmF0ZWQgZnJvbSBodHRwOi8vdGR0LXBvcnR1
Z2FsLmJsb2dzcG90LnB0LwojIFQgZnJlcSBidyBmZWNfaGkgZmVjX2xvIG1vZCB0cmFuc21pc3Np
b24tbW9kZSBndWFyZC1pbnRlcnZhbCBoaWVyYXJjaHkKVCA2ODIwMDAwMDAgOE1IeiAgMi8zIE5P
TkUgICAgUUFNNjQgICA4ayAgMS80IE5PTkUKCg==
--20cf30223bf5cc617504e76f9eab
Content-Type: application/octet-stream; name=pt-Azores-SaoMiguel-Graciosa
Content-Disposition: attachment; filename=pt-Azores-SaoMiguel-Graciosa
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hm4p8ess3

IyBQVCwgQXpvcmVzLCBTYW8gTWlndWVsIGFuZCBHcmFjaW9zYQojIEdlbmVyYXRlZCBmcm9tIGh0
dHA6Ly90ZHQtcG9ydHVnYWwuYmxvZ3Nwb3QucHQvCiMgVCBmcmVxIGJ3IGZlY19oaSBmZWNfbG8g
bW9kIHRyYW5zbWlzc2lvbi1tb2RlIGd1YXJkLWludGVydmFsIGhpZXJhcmNoeQpUIDY5MDAwMDAw
MCA4TUh6ICAyLzMgTk9ORSAgICBRQU02NCAgIDhrICAxLzQgTk9ORQoK
--20cf30223bf5cc617504e76f9eab
Content-Type: application/octet-stream;
	name=pt-Azores-Terceira-SMaria-Flores-Corvo
Content-Disposition: attachment;
	filename=pt-Azores-Terceira-SMaria-Flores-Corvo
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hm4p8esx4

IyBQVCwgQXpvcmVzLCBUZXJjZWlyYSBhbmQgUy4gTWFyaWEgYW5kIEdyYWNpb3NhCiMgR2VuZXJh
dGVkIGZyb20gaHR0cDovL3RkdC1wb3J0dWdhbC5ibG9nc3BvdC5wdC8KIyBUIGZyZXEgYncgZmVj
X2hpIGZlY19sbyBtb2QgdHJhbnNtaXNzaW9uLW1vZGUgZ3VhcmQtaW50ZXJ2YWwgaGllcmFyY2h5
ClQgNzM4MDAwMDAwIDhNSHogIDIvMyBOT05FICAgIFFBTTY0ICAgOGsgIDEvNCBOT05FCgo=
--20cf30223bf5cc617504e76f9eab
Content-Type: application/octet-stream; name=pt-Madeira
Content-Disposition: attachment; filename=pt-Madeira
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hm4p8et25

IyBQVCwgTWFkZWlyYQojIEdlbmVyYXRlZCBmcm9tIGh0dHA6Ly90ZHQtcG9ydHVnYWwuYmxvZ3Nw
b3QucHQvCiMgVCBmcmVxIGJ3IGZlY19oaSBmZWNfbG8gbW9kIHRyYW5zbWlzc2lvbi1tb2RlIGd1
YXJkLWludGVydmFsIGhpZXJhcmNoeQpUIDczODAwMDAwMCA4TUh6ICAyLzMgTk9ORSAgICBRQU02
NCAgIDhrICAxLzQgTk9ORQoK
--20cf30223bf5cc617504e76f9eab
Content-Type: application/octet-stream; name=pt-mainland
Content-Disposition: attachment; filename=pt-mainland
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hm4p8et76

IyBQVCwgbWFpbmxhbmQKIyBHZW5lcmF0ZWQgZnJvbSBodHRwOi8vdGR0LXBvcnR1Z2FsLmJsb2dz
cG90LnB0LwojIFQgZnJlcSBidyBmZWNfaGkgZmVjX2xvIG1vZCB0cmFuc21pc3Npb24tbW9kZSBn
dWFyZC1pbnRlcnZhbCBoaWVyYXJjaHkKVCA2NDIwMDAwMDAgOE1IeiAgMi8zIE5PTkUgICAgUUFN
NjQgICA4ayAgMS80IE5PTkUJIyBNb250ZSBkYSBWaXJnZW0KVCA2NzQwMDAwMDAgOE1IeiAgMi8z
IE5PTkUgICAgUUFNNjQgICA4ayAgMS80IE5PTkUJIyBMb3VzYSAoVHJldmltKQpUIDY5ODAwMDAw
MCA4TUh6ICAyLzMgTk9ORSAgICBRQU02NCAgIDhrICAxLzQgTk9ORQkjIE1vbnRlanVudG8KVCA3
NTQwMDAwMDAgOE1IeiAgMi8zIE5PTkUgICAgUUFNNjQgICA4ayAgMS80IE5PTkUJIyBNYWlubGFu
ZCBTRk4K
--20cf30223bf5cc617504e76f9eab--
