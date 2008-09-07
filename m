Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stev391@email.com>) id 1KcCjd-0005b5-Lw
	for linux-dvb@linuxtv.org; Sun, 07 Sep 2008 07:22:54 +0200
Received: from wfilter3.us4.outblaze.com.int (wfilter3.us4.outblaze.com.int
	[192.168.8.242])
	by webmail-outgoing.us4.outblaze.com (Postfix) with QMQP id
	3152A1802D34
	for <linux-dvb@linuxtv.org>; Sun,  7 Sep 2008 05:22:19 +0000 (GMT)
Content-Transfer-Encoding: 7bit
Content-Type: multipart/mixed; boundary="_----------=_1220764938218240"
MIME-Version: 1.0
From: stev391@email.com
Date: Sun, 7 Sep 2008 15:22:18 +1000
Message-Id: <20080907052219.0E379164293@ws1-4.us4.outblaze.com>
Cc: linux dvb <linux-dvb@linuxtv.org>, jackden <jackden@gmail.com>
Subject: [linux-dvb] [PATCH] XC3028, fix firmware loading for D2620 DTV6
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

--_----------=_1220764938218240
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

The attached patch resolves an issue (in tuner xc2028.c) where the seek fir=
mware is required to=20
find the correct firmware for D2620 DTV6, as there is only one solution for=
 this firmware (D2620=20
DTV6 QAM) search through all firmwares as a last attempt to find out if the=
re is only one match=20
and try it. This bug was noticed while testing a Compro VideoMate E650 in T=
apei using tw-Taipei=20
as the dvb-t scan file.

Signed-off-by: Stephen Backway <stev391@email.com>

Regards,

Stephen.


--=20
Be Yourself @ mail.com!
Choose From 200+ Email Addresses
Get a Free Account at www.mail.com


--_----------=_1220764938218240
Content-Disposition: attachment; filename="D2620_DTV6_QAM_fix_v0.1.patch"
Content-Transfer-Encoding: base64
Content-Type: application/octet-stream; name="D2620_DTV6_QAM_fix_v0.1.patch"

WEMzMDI4OiBBZGRzIGFkZGl0aW9uYWwgY2hlY2sgZm9yIGNvcnJlY3QgZmly
bXdhcmUKCkZyb206IFN0ZXBoZW4gQmFja3dheSA8c3RldjM5MUBlbWFpbC5j
b20+CgpUaGlzIHBhdGNoIGZpeGVzIGZpcm13YXJlIGxvYWQgaXNzdWVzLCB3
aGVyZSBvbmx5IG9uZSBmaXJtd2FyZSBmaXRzIHRoZSAKcmVxdWlyZWQgdHlw
ZSwgYnV0IGhhcyBhbiBhZGRpdGlvbmFsIHR5cGUgKGUuZy4gUUFNKS4gIEl0
IGFjaGlldmVzIHRoaXMgYnkgCmFkZGluZyBhbiBhZGRpdGlvbmFsIGNoZWNr
IGlmIGFsbCBvdGhlcnMgaGF2ZSBmYWlsZWQuIFRoaXMgYnVnIG9jY3VyZWQg
d2hlbiAKc2Nhbm5pbmcgZm9yIGNoYW5uZWxzIHVzaW5nIHR3LVRhaXBlaS4K
ClNpZ25lZC1vZmYtYnk6IFN0ZXBoZW4gQmFja3dheSA8c3RldjM5MUBlbWFp
bC5jb20+CgpkaWZmIC1OYXVyIHY0bC1kdmIvbGludXgvZHJpdmVycy9tZWRp
YS9jb21tb24vdHVuZXJzL3R1bmVyLXhjMjAyOC5jIHY0bC1kdmJfdHVuZXJf
ZndfZml4L2xpbnV4L2RyaXZlcnMvbWVkaWEvY29tbW9uL3R1bmVycy90dW5l
ci14YzIwMjguYwotLS0gdjRsLWR2Yi9saW51eC9kcml2ZXJzL21lZGlhL2Nv
bW1vbi90dW5lcnMvdHVuZXIteGMyMDI4LmMJMjAwOC0wOC0wNCAxODo0Mzoy
OC4wMDAwMDAwMDAgKzEwMDAKKysrIHY0bC1kdmJfdHVuZXJfZndfZml4L2xp
bnV4L2RyaXZlcnMvbWVkaWEvY29tbW9uL3R1bmVycy90dW5lci14YzIwMjgu
YwkyMDA4LTA5LTA3IDEzOjM2OjI5LjAwMDAwMDAwMCArMTAwMApAQCAtNDcw
LDYgKzQ3MCwyMSBAQAogCQl9CiAJfQogCisJLyogU2VlayBmb3IgZmlybXdh
cmUgd2l0aCBvbmx5IG9uZSBtYXRjaCBwb3NzaWJsZSwgaS5lLiBEMjYyMCBE
VFY2IG1hdGNoIHdpdGggRDI2MjAgRFRWNiBRQU0gKi8KKwlpZiAoYmVzdF9u
cl9tYXRjaGVzID09IDApIHsKKwkJZm9yIChpID0gMDsgaSA8IHByaXYtPmZp
cm1fc2l6ZTsgaSsrKSB7CisJCQlpZiAoKHByaXYtPmZpcm1baV0udHlwZSAm
IHR5cGUpID09IHR5cGUpIHsKKwkJCQliZXN0X25yX21hdGNoZXMrKzsKKwkJ
CQliZXN0X2kgPSBpOworCQkJfQorCQkJLyogQ2hlY2sgdG8gc2VlIGlmIHNp
bmdsZSBtYXRjaCBoYXMgZmFpbGVkICovCisJCQlpZiAoYmVzdF9ucl9tYXRj
aGVzID4gMSkgeworCQkJCWJlc3RfbnJfbWF0Y2hlcyA9IDA7CisJCQkJYnJl
YWs7CisJCQl9CisJCX0KKwl9CisKIAlpZiAoYmVzdF9ucl9tYXRjaGVzID4g
MCkgewogCQl0dW5lcl9kYmcoIlNlbGVjdGluZyBiZXN0IG1hdGNoaW5nIGZp
cm13YXJlICglZCBiaXRzKSBmb3IgIgogCQkJICAidHlwZT0iLCBiZXN0X25y
X21hdGNoZXMpOwo=

--_----------=_1220764938218240
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--_----------=_1220764938218240--
