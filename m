Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-ew0-f225.google.com ([209.85.219.225])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <rigolo@gmail.com>) id 1MBMkj-0000ZF-PI
	for linux-dvb@linuxtv.org; Tue, 02 Jun 2009 07:41:38 +0200
Received: by ewy25 with SMTP id 25so5513726ewy.17
	for <linux-dvb@linuxtv.org>; Mon, 01 Jun 2009 22:41:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <205146930906011430me1a1327ka9da449169a4e984@mail.gmail.com>
References: <205146930906011430me1a1327ka9da449169a4e984@mail.gmail.com>
Date: Tue, 2 Jun 2009 07:41:04 +0200
Message-ID: <205146930906012241m2e96458cw66f105e60d299cf3@mail.gmail.com>
From: Hein Rigolo <rigolo@gmail.com>
To: linux-dvb@linuxtv.org
Content-Type: multipart/mixed; boundary=0016367fa1681280b7046b56fd72
Subject: [linux-dvb] [PATCH] dvb-apps DVB-C nl-Ziggo initial tuning file
Reply-To: linux-media@vger.kernel.org
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

--0016367fa1681280b7046b56fd72
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

I have created an initial scanning file that can be used on all DVB-C
networks that make up the Ziggo DVB-C cable network in the
Netherlands. Ziggo is the result of a merger of 3 Cable Companies in
the Netherlands. Because of that the nl-Casema initial tuning file is
no longer needed (it was merged into nl-Ziggo)

This initial tuning file has the 4 main frequencies that are used
within the Ziggo DVB-C network for the main transport streams. From
there you can find all other Transport Streams.

Based on this document:
http://blob.ziggo.nl/dynamic/NL_HOME/PDF-UPLOAD/Gebruikers-Handleiding-Digi=
taleTV.pdf
chapter 4

Because Ziggo is making use of NIT Others to specify the actual
Frequencies of the other transport streams you really need to to use
the -n option of the scan utility in dvb-apps.

Based on the resulting channels.conf I have also constructed a more
detailed initial tuning file for my specific DVB-C network (Region
Zwolle). Here you do not need to use the -n option of scan.

diff -r 9655c8cfeed8 util/scan/dvb-c/nl-Casema
--- a/util/scan/dvb-c/nl-Casema=A0=A0=A0 Tue May 19 14:48:06 2009 +0200
+++ /dev/null=A0=A0=A0 Thu Jan 01 00:00:00 1970 +0000
@@ -1,3 +0,0 @@
-# Casema Netherlands
-# freq sr fec mod
-C 372000000 6875000 NONE QAM64
diff -r 9655c8cfeed8 util/scan/dvb-c/nl-Ziggo
--- /dev/null=A0=A0=A0 Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-c/nl-Ziggo=A0=A0=A0 Sun May 31 21:04:48 2009 +0200
@@ -0,0 +1,14 @@
+# Initial Tuning file for nl-Ziggo
+# This file only lists the main
+# frequencies. You still need to do
+# a network scan to find other
+# transponders.
+#
+# based on:
+# http://blob.ziggo.nl/dynamic/NL_HOME/PDF-UPLOAD/Gebruikers-Handleiding-D=
igitaleTV.pdf
+# Chapter 4
+#
+C 372000000 6875000 NONE QAM64 # Main Frequency Ziggo/Casema
+C 514000000 6875000 NONE QAM64 # Main Frequency Ziggo/Multikabel
+C 356000000 6875000 NONE QAM64 # Main Frequency Ziggo/@Home Zuid
+C 369000000 6875000 NONE QAM64 # Main Frequency Ziggo/@Home Noord
diff -r 9655c8cfeed8 util/scan/dvb-c/nl-Ziggo-Zwolle
--- /dev/null=A0=A0=A0 Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-c/nl-Ziggo-Zwolle=A0=A0=A0 Sun May 31 21:04:48 2009 +02=
00
@@ -0,0 +1,26 @@
+C 313000000 6875000 NONE QAM64 # TS=A0=A0 1
+C 361000000 6875000 NONE QAM64 # TS=A0=A0 2
+C 353000000 6875000 NONE QAM64 # TS=A0=A0 3
+C 345000000 6875000 NONE QAM64 # TS=A0=A0 4
+C 818000000 6875000 NONE QAM64 # TS=A0=A0 5
+C 329000000 6875000 NONE QAM64 # TS=A0=A0 6
+C 810000000 6875000 NONE QAM64 # TS=A0=A0 7
+C 305000000 6875000 NONE QAM64 # TS=A0=A0 8
+C 762000000 6875000 NONE QAM64 # TS=A0=A0 9
+C 618000000 6875000 NONE QAM64 # TS=A0 10
+C 610000000 6875000 NONE QAM64 # TS=A0 11
+C 337000000 6875000 NONE QAM64 # TS=A0 12
+C 321000000 6875000 NONE QAM64 # TS=A0 13
+C 385000000 6875000 NONE QAM64 # TS=A0 14
+C 393000000 6875000 NONE QAM64 # TS=A0 15
+C 401000000 6875000 NONE QAM64 # TS=A0 16
+C 369000000 6875000 NONE QAM64 # TS=A0 18 (main TS)
+C 297000000 6875000 NONE QAM64 # TS=A0 19
+C 377000000 6875000 NONE QAM64 # TS=A0 22
+C 754000000 6875000 NONE QAM64 # TS=A0 23
+C 642000000 6875000 NONE QAM64 # TS=A0 24
+C 650000000 6875000 NONE QAM64 # TS=A0 25
+C 794000000 6875000 NONE QAM64 # TS=A0 26
+C 409000000 6875000 NONE QAM64 # TS=A0 27
+C 425000000 6875000 NONE QAM64 # TS 206
+C 417000000 6875000 NONE QAM64 # TS 207

--0016367fa1681280b7046b56fd72
Content-Type: text/x-patch; charset=US-ASCII; name="nl-Ziggo-2009-05-31.patch"
Content-Disposition: attachment; filename="nl-Ziggo-2009-05-31.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fve4jvbk0

ZGlmZiAtciA5NjU1YzhjZmVlZDggdXRpbC9zY2FuL2R2Yi1jL25sLUNhc2VtYQotLS0gYS91dGls
L3NjYW4vZHZiLWMvbmwtQ2FzZW1hCVR1ZSBNYXkgMTkgMTQ6NDg6MDYgMjAwOSArMDIwMAorKysg
L2Rldi9udWxsCVRodSBKYW4gMDEgMDA6MDA6MDAgMTk3MCArMDAwMApAQCAtMSwzICswLDAgQEAK
LSMgQ2FzZW1hIE5ldGhlcmxhbmRzCi0jIGZyZXEgc3IgZmVjIG1vZAotQyAzNzIwMDAwMDAgNjg3
NTAwMCBOT05FIFFBTTY0CmRpZmYgLXIgOTY1NWM4Y2ZlZWQ4IHV0aWwvc2Nhbi9kdmItYy9ubC1a
aWdnbwotLS0gL2Rldi9udWxsCVRodSBKYW4gMDEgMDA6MDA6MDAgMTk3MCArMDAwMAorKysgYi91
dGlsL3NjYW4vZHZiLWMvbmwtWmlnZ28JU3VuIE1heSAzMSAyMTowNDo0OCAyMDA5ICswMjAwCkBA
IC0wLDAgKzEsMTQgQEAKKyMgSW5pdGlhbCBUdW5pbmcgZmlsZSBmb3IgbmwtWmlnZ28KKyMgVGhp
cyBmaWxlIG9ubHkgbGlzdHMgdGhlIG1haW4KKyMgZnJlcXVlbmNpZXMuIFlvdSBzdGlsbCBuZWVk
IHRvIGRvCisjIGEgbmV0d29yayBzY2FuIHRvIGZpbmQgb3RoZXIKKyMgdHJhbnNwb25kZXJzLgor
IworIyBiYXNlZCBvbjoKKyMgaHR0cDovL2Jsb2IuemlnZ28ubmwvZHluYW1pYy9OTF9IT01FL1BE
Ri1VUExPQUQvR2VicnVpa2Vycy1IYW5kbGVpZGluZy1EaWdpdGFsZVRWLnBkZgorIyBDaGFwdGVy
IDQKKyMKK0MgMzcyMDAwMDAwIDY4NzUwMDAgTk9ORSBRQU02NCAjIE1haW4gRnJlcXVlbmN5IFpp
Z2dvL0Nhc2VtYQorQyA1MTQwMDAwMDAgNjg3NTAwMCBOT05FIFFBTTY0ICMgTWFpbiBGcmVxdWVu
Y3kgWmlnZ28vTXVsdGlrYWJlbAorQyAzNTYwMDAwMDAgNjg3NTAwMCBOT05FIFFBTTY0ICMgTWFp
biBGcmVxdWVuY3kgWmlnZ28vQEhvbWUgWnVpZAorQyAzNjkwMDAwMDAgNjg3NTAwMCBOT05FIFFB
TTY0ICMgTWFpbiBGcmVxdWVuY3kgWmlnZ28vQEhvbWUgTm9vcmQKZGlmZiAtciA5NjU1YzhjZmVl
ZDggdXRpbC9zY2FuL2R2Yi1jL25sLVppZ2dvLVp3b2xsZQotLS0gL2Rldi9udWxsCVRodSBKYW4g
MDEgMDA6MDA6MDAgMTk3MCArMDAwMAorKysgYi91dGlsL3NjYW4vZHZiLWMvbmwtWmlnZ28tWndv
bGxlCVN1biBNYXkgMzEgMjE6MDQ6NDggMjAwOSArMDIwMApAQCAtMCwwICsxLDI2IEBACitDIDMx
MzAwMDAwMCA2ODc1MDAwIE5PTkUgUUFNNjQgIyBUUyAgIDEKK0MgMzYxMDAwMDAwIDY4NzUwMDAg
Tk9ORSBRQU02NCAjIFRTICAgMgorQyAzNTMwMDAwMDAgNjg3NTAwMCBOT05FIFFBTTY0ICMgVFMg
ICAzCitDIDM0NTAwMDAwMCA2ODc1MDAwIE5PTkUgUUFNNjQgIyBUUyAgIDQKK0MgODE4MDAwMDAw
IDY4NzUwMDAgTk9ORSBRQU02NCAjIFRTICAgNQorQyAzMjkwMDAwMDAgNjg3NTAwMCBOT05FIFFB
TTY0ICMgVFMgICA2CitDIDgxMDAwMDAwMCA2ODc1MDAwIE5PTkUgUUFNNjQgIyBUUyAgIDcKK0Mg
MzA1MDAwMDAwIDY4NzUwMDAgTk9ORSBRQU02NCAjIFRTICAgOAorQyA3NjIwMDAwMDAgNjg3NTAw
MCBOT05FIFFBTTY0ICMgVFMgICA5CitDIDYxODAwMDAwMCA2ODc1MDAwIE5PTkUgUUFNNjQgIyBU
UyAgMTAKK0MgNjEwMDAwMDAwIDY4NzUwMDAgTk9ORSBRQU02NCAjIFRTICAxMQorQyAzMzcwMDAw
MDAgNjg3NTAwMCBOT05FIFFBTTY0ICMgVFMgIDEyCitDIDMyMTAwMDAwMCA2ODc1MDAwIE5PTkUg
UUFNNjQgIyBUUyAgMTMKK0MgMzg1MDAwMDAwIDY4NzUwMDAgTk9ORSBRQU02NCAjIFRTICAxNAor
QyAzOTMwMDAwMDAgNjg3NTAwMCBOT05FIFFBTTY0ICMgVFMgIDE1CitDIDQwMTAwMDAwMCA2ODc1
MDAwIE5PTkUgUUFNNjQgIyBUUyAgMTYKK0MgMzY5MDAwMDAwIDY4NzUwMDAgTk9ORSBRQU02NCAj
IFRTICAxOCAobWFpbiBUUykKK0MgMjk3MDAwMDAwIDY4NzUwMDAgTk9ORSBRQU02NCAjIFRTICAx
OQorQyAzNzcwMDAwMDAgNjg3NTAwMCBOT05FIFFBTTY0ICMgVFMgIDIyCitDIDc1NDAwMDAwMCA2
ODc1MDAwIE5PTkUgUUFNNjQgIyBUUyAgMjMKK0MgNjQyMDAwMDAwIDY4NzUwMDAgTk9ORSBRQU02
NCAjIFRTICAyNAorQyA2NTAwMDAwMDAgNjg3NTAwMCBOT05FIFFBTTY0ICMgVFMgIDI1CitDIDc5
NDAwMDAwMCA2ODc1MDAwIE5PTkUgUUFNNjQgIyBUUyAgMjYKK0MgNDA5MDAwMDAwIDY4NzUwMDAg
Tk9ORSBRQU02NCAjIFRTICAyNworQyA0MjUwMDAwMDAgNjg3NTAwMCBOT05FIFFBTTY0ICMgVFMg
MjA2CitDIDQxNzAwMDAwMCA2ODc1MDAwIE5PTkUgUUFNNjQgIyBUUyAyMDcK
--0016367fa1681280b7046b56fd72
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--0016367fa1681280b7046b56fd72--
