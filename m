Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from cinke.fazekas.hu ([195.199.244.225])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <cus@fazekas.hu>) id 1JbKxX-0000nU-Gt
	for linux-dvb@linuxtv.org; Mon, 17 Mar 2008 20:25:28 +0100
Received: from localhost (localhost [127.0.0.1])
	by cinke.fazekas.hu (Postfix) with ESMTP id 5A0D133CC3
	for <linux-dvb@linuxtv.org>; Mon, 17 Mar 2008 20:25:15 +0100 (CET)
Received: from cinke.fazekas.hu ([127.0.0.1])
	by localhost (cinke.fazekas.hu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id O2P9qj6t8WoO for <linux-dvb@linuxtv.org>;
	Mon, 17 Mar 2008 20:25:09 +0100 (CET)
Received: from cinke.fazekas.hu (cinke.fazekas.hu [195.199.244.225])
	by cinke.fazekas.hu (Postfix) with ESMTP id 2399533CC5
	for <linux-dvb@linuxtv.org>; Mon, 17 Mar 2008 20:25:09 +0100 (CET)
Date: Mon, 17 Mar 2008 20:25:09 +0100 (CET)
From: Balint Marton <cus@fazekas.hu>
To: linux-dvb@linuxtv.org
Message-ID: <Pine.LNX.4.64.0803171240170.19667@cinke.fazekas.hu>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-943463948-535334313-1205781908=:26436"
Subject: [linux-dvb] [PATCH] cx88: detect stereo output instead of mono
	fallback
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

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---943463948-535334313-1205781908=:26436
Content-Type: TEXT/PLAIN; charset=US-ASCII

Hi, 

On my Leadtek WinFast 2000 Expert XP card the automatic detection of 
stereo channels does not work. If the sound system is not NICAM, it 
falls back to mono on both mono and stereo tv channels. 

I had no idea how to detect it, and falling back to EN_A2_AUTO_STEREO 
instead of EN_A2_FORCE_MONO1 did not help either. (The card changed the 
audio mode periodically on both mono and stereo channels) Forcing STEREO 
mode also did not help, because it resulted a loud static noise on mono tv 
channels.

Testing proved that AUD_NICAM_STATUS1 and AUD_NICAM_STATUS2 registers 
change randomly if and only if the second audio channel is missing, so if 
these registers are constant (Usually 0x0000 and 0x01), we can assume that 
the tv channel has two audio channels, so we can use STEREO mode. This 
method seems a bit ugly, but nicam detection works the same way. And 
now stereo channel detection also works for me :)

Since my cable TV provider only broadcasts in PAL BG mode with A2 sound 
system, i couldn't test other systems, but they should work just like 
before.

   Marton


Signed-off-by: Marton Balint <cus@fazekas.hu>
---943463948-535334313-1205781908=:26436
Content-Type: TEXT/x-patch; charset=US-ASCII; name=cx88-stereo.patch
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0803172025080.26436@cinke.fazekas.hu>
Content-Description: 
Content-Disposition: attachment; filename=cx88-stereo.patch

LS0tIGRyaXZlcnMvbWVkaWEvdmlkZW8vY3g4OC9jeDg4LXR2YXVkaW8uYy5v
bGQJMjAwOC0wMy0xNiAyMDoxMzo0NS4wMDAwMDAwMDAgKzAxMDANCisrKyBk
cml2ZXJzL21lZGlhL3ZpZGVvL2N4ODgvY3g4OC10dmF1ZGlvLmMJMjAwOC0w
My0xNyAyMDowMDo1Mi4wMDAwMDAwMDAgKzAxMDANCkBAIC03MTQsMzEgKzcx
NCw0MiBAQCBzdGF0aWMgdm9pZCBzZXRfYXVkaW9fc3RhbmRhcmRfRk0oc3Ry
dWN0DQogDQogLyogLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0gKi8NCiANCi1zdGF0aWMgaW50
IGN4ODhfZGV0ZWN0X25pY2FtKHN0cnVjdCBjeDg4X2NvcmUgKmNvcmUpDQor
c3RhdGljIGludCBjeDg4X2RldGVjdF9uaWNhbV9vcl9zdGVyZW8oc3RydWN0
IGN4ODhfY29yZSAqY29yZSkNCiB7DQotCWludCBpLCBqID0gMDsNCisJaW50
IGksIHN0ZXJlbyA9IDA7DQorCXUzMiBzdGF0dXMxLCBzdGF0dXMyOw0KKwl1
MzIgbGFzdF9zdGF0dXMxID0gMHhmZmZmZmZmZiwgbGFzdF9zdGF0dXMyID0g
MHhmZmZmZmZmZjsNCiANCiAJZHByaW50aygic3RhcnQgbmljYW0gYXV0b2Rl
dGVjdC5cbiIpOw0KIA0KIAlmb3IgKGkgPSAwOyBpIDwgNjsgaSsrKSB7DQor
CQlzdGF0dXMxID0gY3hfcmVhZChBVURfTklDQU1fU1RBVFVTMSk7DQorCQlz
dGF0dXMyID0gY3hfcmVhZChBVURfTklDQU1fU1RBVFVTMik7DQorCQkNCiAJ
CS8qIGlmIGJpdDE9MSB0aGVuIG5pY2FtIGlzIGRldGVjdGVkICovDQotCQlq
ICs9ICgoY3hfcmVhZChBVURfTklDQU1fU1RBVFVTMikgJiAweDAyKSA+PiAx
KTsNCi0NCi0JCWlmIChqID09IDEpIHsNCisJCWlmIChzdGF0dXMyICYgMHgw
Mikgew0KIAkJCWRwcmludGsoIm5pY2FtIGlzIGRldGVjdGVkLlxuIik7DQog
CQkJcmV0dXJuIDE7DQogCQl9DQogDQorCQlpZiAobGFzdF9zdGF0dXMxID09
IHN0YXR1czEgJiYgbGFzdF9zdGF0dXMyID09IHN0YXR1czIpDQorCQkJc3Rl
cmVvKys7CQ0KKwkJbGFzdF9zdGF0dXMxID0gc3RhdHVzMTsNCisJCWxhc3Rf
c3RhdHVzMiA9IHN0YXR1czI7DQorDQogCQkvKiB3YWl0IGEgbGl0dGxlIGJp
dCBmb3IgbmV4dCByZWFkaW5nIHN0YXR1cyAqLw0KIAkJbXNsZWVwKDEwKTsN
CiAJfQ0KIA0KKwlkcHJpbnRrKCJzdGVyZW8gZGV0ZWN0aW9uIHJlc3VsdDog
JWRcbiIsIHN0ZXJlbyk7DQogCWRwcmludGsoIm5pY2FtIGlzIG5vdCBkZXRl
Y3RlZC5cbiIpOw0KLQlyZXR1cm4gMDsNCisJcmV0dXJuIHN0ZXJlbyA+PSAz
ID8gMiA6IDA7DQogfQ0KIA0KIHZvaWQgY3g4OF9zZXRfdHZhdWRpbyhzdHJ1
Y3QgY3g4OF9jb3JlICpjb3JlKQ0KIHsNCisJaW50IG5pY2FtX29yX3N0ZXJl
bzsNCisNCiAJc3dpdGNoIChjb3JlLT50dmF1ZGlvKSB7DQogCWNhc2UgV1df
QlRTQzoNCiAJCXNldF9hdWRpb19zdGFuZGFyZF9CVFNDKGNvcmUsIDAsIEVO
X0JUU0NfQVVUT19TVEVSRU8pOw0KQEAgLTc1MywxMiArNzY0LDEzIEBAIHZv
aWQgY3g4OF9zZXRfdHZhdWRpbyhzdHJ1Y3QgY3g4OF9jb3JlICoNCiAJCS8q
IHNldCBuaWNhbSBtb2RlIC0gb3RoZXJ3aXNlDQogCQkgICBBVURfTklDQU1f
U1RBVFVTMiBjb250YWlucyB3cm9uZyB2YWx1ZXMgKi8NCiAJCXNldF9hdWRp
b19zdGFuZGFyZF9OSUNBTShjb3JlLCBFTl9OSUNBTV9BVVRPX1NURVJFTyk7
DQotCQlpZiAoMCA9PSBjeDg4X2RldGVjdF9uaWNhbShjb3JlKSkgew0KLQkJ
CS8qIGZhbGwgYmFjayB0byBmbSAvIGFtIG1vbm8gKi8NCi0JCQlzZXRfYXVk
aW9fc3RhbmRhcmRfQTIoY29yZSwgRU5fQTJfRk9SQ0VfTU9OTzEpOw0KLQkJ
CWNvcmUtPnVzZV9uaWNhbSA9IDA7DQotCQl9IGVsc2Ugew0KKwkJbmljYW1f
b3Jfc3RlcmVvID0gY3g4OF9kZXRlY3RfbmljYW1fb3Jfc3RlcmVvKGNvcmUp
Ow0KKwkJaWYgKG5pY2FtX29yX3N0ZXJlbyA9PSAxKSB7DQogCQkJY29yZS0+
dXNlX25pY2FtID0gMTsNCisJCX0gZWxzZSB7DQorCQkJLyogZmFsbCBiYWNr
IHRvIGZtIC8gYW0gc3RlcmVvIG9yIG1vbm8gKi8NCisJCQlzZXRfYXVkaW9f
c3RhbmRhcmRfQTIoY29yZSwgbmljYW1fb3Jfc3RlcmVvID09IDIgPyBFTl9B
Ml9GT1JDRV9TVEVSRU8gOiBFTl9BMl9GT1JDRV9NT05PMSk7DQorCQkJY29y
ZS0+dXNlX25pY2FtID0gMDsNCiAJCX0NCiAJCWJyZWFrOw0KIAljYXNlIFdX
X0VJQUo6DQo=

---943463948-535334313-1205781908=:26436
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
---943463948-535334313-1205781908=:26436--
