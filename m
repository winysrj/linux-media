Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ey-out-2122.google.com ([74.125.78.27])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1KfRlW-0006VS-TT
	for linux-dvb@linuxtv.org; Tue, 16 Sep 2008 06:02:15 +0200
Received: by ey-out-2122.google.com with SMTP id 25so1102162eya.17
	for <linux-dvb@linuxtv.org>; Mon, 15 Sep 2008 21:02:11 -0700 (PDT)
Message-ID: <412bdbff0809152102j4faa675cw3134efe5403020bd@mail.gmail.com>
Date: Tue, 16 Sep 2008 00:02:10 -0400
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: linux-dvb <linux-dvb@linuxtv.org>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_1999_32737026.1221537731020"
Subject: [linux-dvb] [FIX] Use correct firmware for the ATI TV Wonder 600
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

------=_Part_1999_32737026.1221537731020
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Attached is a patch to use the proper firmware for the ATI TV Wonder
600.  It was previously configured to use the XC3028 firmware, as I
did not realize the device had an XC3028L until I got one myself for
testing purposes.

This should get pushed in ASAP since the wrong firmware causes the
device to overheat and could cause permanent damage.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

------=_Part_1999_32737026.1221537731020
Content-Type: text/x-diff; name=ati_600_xc3028l_tuner.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fl5zxdrz0
Content-Disposition: attachment; filename=ati_600_xc3028l_tuner.patch

VXNlIGNvcnJlY3QgWEMzMDI4TCBmaXJtd2FyZSBmb3IgQU1EIEFUSSBUViBXb25kZXIgNjAwCgpG
cm9tOiBEZXZpbiBIZWl0bXVlbGxlciA8ZGV2aW4uaGVpdG11ZWxsZXJAZ21haWwuY29tPgoKVGhl
IEFNRCBBVEkgVFYgV29uZGVyIDYwMCBoYXMgYW4gWEMzMDI4TCBhbmQgKm5vdCogYW4gWEMzMDI4
LCBzbyB3ZSBuZWVkIHRvIApsb2FkIHRoZSBwcm9wZXIgZmlybXdhcmUgdG8gcHJldmVudCB0aGUg
ZGV2aWNlIGZyb20gb3ZlcmhlYXRpbmcuCgpQcmlvcml0eTogaGlnaAoKU2lnbmVkLW9mZi1ieTog
RGV2aW4gSGVpdG11ZWxsZXIgPGRldmluLmhlaXRtdWVsbGVyQGdtYWlsLmNvbT4KCmRpZmYgLXIg
ZTVjYTQ1MzRiNTQzIGxpbnV4L2RyaXZlcnMvbWVkaWEvY29tbW9uL3R1bmVycy90dW5lci14YzIw
MjguaAotLS0gYS9saW51eC9kcml2ZXJzL21lZGlhL2NvbW1vbi90dW5lcnMvdHVuZXIteGMyMDI4
LmgJVHVlIFNlcCAwOSAwODoyOTo1NiAyMDA4IC0wNzAwCisrKyBiL2xpbnV4L2RyaXZlcnMvbWVk
aWEvY29tbW9uL3R1bmVycy90dW5lci14YzIwMjguaAlNb24gU2VwIDE1IDIzOjUxOjIwIDIwMDgg
LTA0MDAKQEAgLTEwLDYgKzEwLDcgQEAKICNpbmNsdWRlICJkdmJfZnJvbnRlbmQuaCIKIAogI2Rl
ZmluZSBYQzIwMjhfREVGQVVMVF9GSVJNV0FSRSAieGMzMDI4LXYyNy5mdyIKKyNkZWZpbmUgWEMz
MDI4TF9ERUZBVUxUX0ZJUk1XQVJFICJ4YzMwMjhMLXYzNi5mdyIKIAogLyogICAgICBEbW9kdWxl
cgkJSUYgKGtIeikgKi8KICNkZWZpbmUJWEMzMDI4X0ZFX0RFRkFVTFQJMAkJLyogRG9uJ3QgbG9h
ZCBTQ09ERSAqLwpkaWZmIC1yIGU1Y2E0NTM0YjU0MyBsaW51eC9kcml2ZXJzL21lZGlhL3ZpZGVv
L2VtMjh4eC9lbTI4eHgtY2FyZHMuYwotLS0gYS9saW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL2Vt
Mjh4eC9lbTI4eHgtY2FyZHMuYwlUdWUgU2VwIDA5IDA4OjI5OjU2IDIwMDggLTA3MDAKKysrIGIv
bGludXgvZHJpdmVycy9tZWRpYS92aWRlby9lbTI4eHgvZW0yOHh4LWNhcmRzLmMJTW9uIFNlcCAx
NSAyMzo1MToyMCAyMDA4IC0wNDAwCkBAIC0xNTM0LDkgKzE1MzQsMTIgQEAgc3RhdGljIHZvaWQg
ZW0yOHh4X3NldHVwX3hjMzAyOChzdHJ1Y3QgZQogCQkvKiBkamggLSBOb3Qgc3VyZSB3aGljaCBk
ZW1vZCB3ZSBuZWVkIGhlcmUgKi8KIAkJY3RsLT5kZW1vZCA9IFhDMzAyOF9GRV9ERUZBVUxUOwog
CQlicmVhazsKKwljYXNlIEVNMjg4MF9CT0FSRF9BTURfQVRJX1RWX1dPTkRFUl9IRF82MDA6CisJ
CWN0bC0+ZGVtb2QgPSBYQzMwMjhfRkVfREVGQVVMVDsKKwkJY3RsLT5mbmFtZSA9IFhDMzAyOExf
REVGQVVMVF9GSVJNV0FSRTsKKwkJYnJlYWs7CiAJY2FzZSBFTTI4ODNfQk9BUkRfSEFVUFBBVUdF
X1dJTlRWX0hWUl85NTA6CiAJY2FzZSBFTTI4ODBfQk9BUkRfUElOTkFDTEVfUENUVl9IRF9QUk86
Ci0JY2FzZSBFTTI4ODBfQk9BUkRfQU1EX0FUSV9UVl9XT05ERVJfSERfNjAwOgogCQkvKiBGSVhN
RTogQmV0dGVyIHRvIHNwZWNpZnkgdGhlIG5lZWRlZCBJRiAqLwogCQljdGwtPmRlbW9kID0gWEMz
MDI4X0ZFX0RFRkFVTFQ7CiAJCWJyZWFrOwo=
------=_Part_1999_32737026.1221537731020
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
------=_Part_1999_32737026.1221537731020--
