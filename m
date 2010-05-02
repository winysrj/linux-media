Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <davoremard@gmail.com>) id 1O8NBZ-0000hs-C8
	for linux-dvb@linuxtv.org; Sun, 02 May 2010 02:37:31 +0200
Received: from mail-bw0-f219.google.com ([209.85.218.219])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-a) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1O8NBY-0001eH-Bq; Sun, 02 May 2010 02:37:28 +0200
Received: by bwz19 with SMTP id 19so726357bwz.1
	for <linux-dvb@linuxtv.org>; Sat, 01 May 2010 17:37:27 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 2 May 2010 02:37:27 +0200
Message-ID: <i2qbeee72201005011737r125f99adp8754a4b04f065a5f@mail.gmail.com>
From: davor emard <davoremard@gmail.com>
To: linux-dvb@linuxtv.org
Content-Type: multipart/mixed; boundary=0015175cd0c846c0f2048591ae26
Subject: [linux-dvb] Compro Videomate T750F DVB-T patch
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--0015175cd0c846c0f2048591ae26
Content-Type: multipart/alternative; boundary=0015175cd0c846c0e2048591ae24

--0015175cd0c846c0e2048591ae24
Content-Type: text/plain; charset=ISO-8859-1

HI

I have european version of Compro Videomate T750F Vista
hybrid dvb-t + tv (pal) / radio card. In kernels up to date (2.6.33.3)
it didn't want to initialize in analog mode (tuner xc2028 always failed).

Here's sligthly adapted patch from
http://www.linuxtv.org/pipermail/linux-dvb/2008-May/025945.html
that works for me. It disables analog tuner xc2028 and anables
digital tuner that consists of zarlink 10353 and qt1010.
Tested and works on kernel 2.6.33.3

Best regards, Emard

--0015175cd0c846c0e2048591ae24
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

HI<br><br>I have european version of Compro Videomate T750F Vista <br>hybri=
d dvb-t + tv (pal) / radio card. In kernels up to date (2.6.33.3)<br>it did=
n&#39;t want to initialize in analog mode (tuner xc2028 always failed).<br>
<br>Here&#39;s sligthly adapted patch from<br><a href=3D"http://www.linuxtv=
.org/pipermail/linux-dvb/2008-May/025945.html">http://www.linuxtv.org/piper=
mail/linux-dvb/2008-May/025945.html</a><br>that works for me. It disables a=
nalog tuner xc2028 and anables <br>
digital tuner that consists of zarlink 10353 and qt1010.<br>Tested and work=
s on kernel 2.6.33.3<br><br>Best regards, Emard<br><br><br>

--0015175cd0c846c0e2048591ae24--

--0015175cd0c846c0f2048591ae26
Content-Type: text/x-patch; charset=US-ASCII; name="compro-videomate-t750f-v5.patch"
Content-Disposition: attachment; filename="compro-videomate-t750f-v5.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g8p4svsj0

LS0tIGxpbnV4LTIuNi4zMy4zL2RyaXZlcnMvbWVkaWEvdmlkZW8vc2FhNzEzNC9zYWE3MTM0LWNh
cmRzLmMub3JpZwkyMDEwLTA1LTAyIDAwOjA2OjQ1LjAwMDAwMDAwMCArMDIwMAorKysgbGludXgt
Mi42LjMzLjMvZHJpdmVycy9tZWRpYS92aWRlby9zYWE3MTM0L3NhYTcxMzQtY2FyZHMuYwkyMDEw
LTA1LTAyIDAxOjIwOjUwLjAwMDAwMDAwMCArMDIwMApAQCAtNDg4MywxMCArNDg4MywxMSBAQCBz
dHJ1Y3Qgc2FhNzEzNF9ib2FyZCBzYWE3MTM0X2JvYXJkc1tdID0KIAkJLyogSm9obiBOZXdiaWdp
biA8am5AaXQuc3dpbi5lZHUuYXU+ICovCiAJCS5uYW1lICAgICAgICAgICA9ICJDb21wcm8gVmlk
ZW9NYXRlIFQ3NTAiLAogCQkuYXVkaW9fY2xvY2sgICAgPSAweDAwMTg3ZGU3LAotCQkudHVuZXJf
dHlwZSAgICAgPSBUVU5FUl9YQzIwMjgsCisJCS50dW5lcl90eXBlICAgICA9IFRVTkVSX0FCU0VO
VCwKIAkJLnJhZGlvX3R5cGUgICAgID0gVU5TRVQsCiAJCS50dW5lcl9hZGRyCT0gQUREUl9VTlNF
VCwKIAkJLnJhZGlvX2FkZHIJPSBBRERSX1VOU0VULAorCQkubXBlZyAgICAgICAgICAgPSBTQUE3
MTM0X01QRUdfRFZCLAogCQkuaW5wdXRzID0ge3sKIAkJCS5uYW1lICAgPSBuYW1lX3R2LAogCQkJ
LnZtdXggICA9IDMsCkBAIC03MTkyLDYgKzcxOTMsNyBAQCBpbnQgc2FhNzEzNF9ib2FyZF9pbml0
MihzdHJ1Y3Qgc2FhNzEzNF9kCiAJY2FzZSBTQUE3MTM0X0JPQVJEX0FWRVJNRURJQV9TVVBFUl8w
MDc6CiAJY2FzZSBTQUE3MTM0X0JPQVJEX1RXSU5IQU5fRFRWX0RWQl8zMDU2OgogCWNhc2UgU0FB
NzEzNF9CT0FSRF9DUkVBVElYX0NUWDk1MzoKKyAgICAgICAgY2FzZSBTQUE3MTM0X0JPQVJEX1ZJ
REVPTUFURV9UNzUwOgogCXsKIAkJLyogdGhpcyBpcyBhIGh5YnJpZCBib2FyZCwgaW5pdGlhbGl6
ZSB0byBhbmFsb2cgbW9kZQogCQkgKiBhbmQgY29uZmlndXJlIGZpcm13YXJlIGVlcHJvbSBhZGRy
ZXNzCi0tLSBsaW51eC0yLjYuMzMuMy9kcml2ZXJzL21lZGlhL3ZpZGVvL3NhYTcxMzQvc2FhNzEz
NC1kdmIuYy5vcmlnCTIwMTAtMDUtMDEgMjM6NTc6MDguMDAwMDAwMDAwICswMjAwCisrKyBsaW51
eC0yLjYuMzMuMy9kcml2ZXJzL21lZGlhL3ZpZGVvL3NhYTcxMzQvc2FhNzEzNC1kdmIuYwkyMDEw
LTA1LTAyIDAwOjUxOjQ0LjAwMDAwMDAwMCArMDIwMApAQCAtNTUsNiArNTUsNyBAQAogI2luY2x1
ZGUgInRkYTgyOTAuaCIKIAogI2luY2x1ZGUgInpsMTAzNTMuaCIKKyNpbmNsdWRlICJxdDEwMTAu
aCIKIAogI2luY2x1ZGUgInpsMTAwMzYuaCIKICNpbmNsdWRlICJ6bDEwMDM5LmgiCkBAIC04ODYs
NiArODg3LDE3IEBAIHN0YXRpYyBzdHJ1Y3QgemwxMDM1M19jb25maWcgYmVob2xkX3g3X2MKIAku
ZGlzYWJsZV9pMmNfZ2F0ZV9jdHJsID0gMSwKIH07CiAKK3N0YXRpYyBzdHJ1Y3QgemwxMDM1M19j
b25maWcgdmlkZW9tYXRlX3Q3NTBfemwxMDM1M19jb25maWcgPSB7CisgICAgICAgLmRlbW9kX2Fk
ZHJlc3MgID0gMHgwZiwKKyAgICAgICAubm9fdHVuZXIgPSAxLAorICAgICAgIC5wYXJhbGxlbF90
cyA9IDEsCit9OworCitzdGF0aWMgc3RydWN0IHF0MTAxMF9jb25maWcgdmlkZW9tYXRlX3Q3NTBf
cXQxMDEwX2NvbmZpZyA9IHsKKyAgICAgICAuaTJjX2FkZHJlc3MgPSAweDYyCit9OworCisKIC8q
ID09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PQogICogdGRhMTAwODYgYmFzZWQgRFZCLVMgY2FyZHMsIGhlbHBlciBmdW5jdGlv
bnMKICAqLwpAQCAtMTU1Niw2ICsxNTY4LDI2IEBAIHN0YXRpYyBpbnQgZHZiX2luaXQoc3RydWN0
IHNhYTcxMzRfZGV2ICoKIAkJCQkJX19mdW5jX18pOwogCiAJCWJyZWFrOworICAgICAgICAvKkZJ
WE1FOiBXaGF0IGZyb250ZW5kIGRvZXMgVmlkZW9tYXRlIFQ3NTAgdXNlPyAqLworICAgICAgICBj
YXNlIFNBQTcxMzRfQk9BUkRfVklERU9NQVRFX1Q3NTA6CisgICAgICAgICAgICAgICAgcHJpbnRr
KCJDb21wcm8gVmlkZW9NYXRlIFQ3NTAgRFZCIHNldHVwXG4iKTsKKyAgICAgICAgICAgICAgICBm
ZTAtPmR2Yi5mcm9udGVuZCA9IGR2Yl9hdHRhY2goemwxMDM1M19hdHRhY2gsCisgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAmdmlkZW9tYXRlX3Q3NTBfemwx
MDM1M19jb25maWcsCisgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAmZGV2LT5pMmNfYWRhcCk7CisgICAgICAgICAgICAgICAgaWYgKGZlMC0+ZHZiLmZyb250
ZW5kICE9IE5VTEwpIHsKKyAgICAgICAgICAgICAgICAgICAgICAgIHByaW50aygiQXR0YWNoaW5n
IHBsbFxuIik7CisgICAgICAgICAgICAgICAgICAgICAgICAvLyBpZiB0aGVyZSBpcyBhIGdhdGUg
ZnVuY3Rpb24gdGhlbiB0aGUgaTJjIGJ1cyBicmVha3MuLi4uLiEKKyAgICAgICAgICAgICAgICAg
ICAgICAgIGZlMC0+ZHZiLmZyb250ZW5kLT5vcHMuaTJjX2dhdGVfY3RybCA9IDA7CisgCisgICAg
ICAgICAgICAgICAgICAgICAgICBpZiAoZHZiX2F0dGFjaChxdDEwMTBfYXR0YWNoLAorICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgZmUwLT5kdmIuZnJvbnRlbmQsCisgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAmZGV2LT5pMmNfYWRhcCwKKyAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICZ2aWRlb21hdGVfdDc1MF9xdDEwMTBf
Y29uZmlnKSA9PSBOVUxMKQorICAgICAgICAgICAgICAgICAgICAgICAgeworICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICB3cHJpbnRrKCJlcnJvciBhdHRhY2hpbmcgUVQxMDEwXG4iKTsK
KyAgICAgICAgICAgICAgICAgICAgICAgIH0KKyAgICAgICAgICAgICAgICB9CisgICAgICAgICAg
ICAgICAgYnJlYWs7CiAJY2FzZSBTQUE3MTM0X0JPQVJEX1pPTElEX0hZQlJJRF9QQ0k6CiAJCWZl
MC0+ZHZiLmZyb250ZW5kID0gZHZiX2F0dGFjaCh0ZGExMDA0OF9hdHRhY2gsCiAJCQkJCSAgICAg
ICAmem9saWRfdGRhMTAwNDhfY29uZmlnLAo=
--0015175cd0c846c0f2048591ae26
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--0015175cd0c846c0f2048591ae26--
