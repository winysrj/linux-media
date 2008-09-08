Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from main.gmane.org ([80.91.229.2] helo=ciao.gmane.org)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gldd-linux-dvb@m.gmane.org>) id 1Kcjyi-0005lg-5X
	for linux-dvb@linuxtv.org; Mon, 08 Sep 2008 18:52:41 +0200
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1Kcjyd-0006TE-0P
	for linux-dvb@linuxtv.org; Mon, 08 Sep 2008 16:52:35 +0000
Received: from c83-254-20-12.bredband.comhem.se ([83.254.20.12])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Mon, 08 Sep 2008 16:52:34 +0000
Received: from elupus by c83-254-20-12.bredband.comhem.se with local (Gmexim
	0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Mon, 08 Sep 2008 16:52:34 +0000
To: linux-dvb@linuxtv.org
From: elupus <elupus@ecce.se>
Date: Mon, 8 Sep 2008 18:52:28 +0200
Message-ID: <tih9ovrhiir9$.pski8ckx8xe6.dlg@40tude.net>
References: <10d98cn4rdklb.sc6i17qzg4hh.dlg@40tude.net>
	<ht6lq3h8puvv$.1f20vcvg13w7e.dlg@40tude.net>
	<alpine.LRH.1.10.0809062106340.6645@pub5.ifh.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="--387128B66CE7E590_message_boundary--"
Subject: Re: [linux-dvb] [PATCH] Yuan STK7700D support
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

----387128B66CE7E590_message_boundary--
Content-type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, 6 Sep 2008 21:07:48 +0200 (CEST), Patrick Boettcher wrote:

> Hi,
> 
> In order to add a patch I need a Signed-off-by line with your name and 
> email-address. See README.patches in v4l-dvb repository for more 
> information.
> 

Here we go, somebody had gone and added another device since my last patch,
so patch had merge conflicts ofcourse. 

People say mercurial should be easier than git. But hey, just adding a
Signed-Off-By message was hard. (then again first time I try it).

Here it is anyway.

Regards
----387128B66CE7E590_message_boundary--
Content-type: text/x-patch; charset=iso-8859-1
Content-Transfer-Encoding: Base64
Content-Disposition: attachment; filename=yuan.patch
Content-Description: Attached file: yuan.patch

IyBIRyBjaGFuZ2VzZXQgcGF0Y2gNCiMgVXNlciBKb2FraW0gUGxhdGUgPGVsdXB1c0BlY2Nl
LnNlPg0KIyBEYXRlIDEyMjA4OTI0NzQgLTcyMDANCiMgTm9kZSBJRCA5ODRiZjQ3YzExZWQ5
MDZkODgxZTM2YzQ4Y2NkZjI1ZTY2NDkyOWNiDQojIFBhcmVudCAgZmYwNTIwMTBjNGNiNmJi
MjBjZDM3YmFkYTAyNTE0OGI2OWZhNDBhZQ0KWXVhbiBTVEs3NzAwRCBzdXBwb3J0DQoNClNp
Z25lZC1PZmYtQnk6IEpvYWtpbSBQbGF0ZSA8ZWx1cHVzQGVjY2Uuc2U+DQoNCmRpZmYgLXIg
ZmYwNTIwMTBjNGNiIC1yIDk4NGJmNDdjMTFlZCBsaW51eC9kcml2ZXJzL21lZGlhL2R2Yi9k
dmItdXNiL2RpYjA3MDBfZGV2aWNlcy5jDQotLS0gYS9saW51eC9kcml2ZXJzL21lZGlhL2R2
Yi9kdmItdXNiL2RpYjA3MDBfZGV2aWNlcy5jCVN1biBTZXAgMDcgMTQ6NDY6NDQgMjAwOCAr
MDIwMA0KKysrIGIvbGludXgvZHJpdmVycy9tZWRpYS9kdmIvZHZiLXVzYi9kaWIwNzAwX2Rl
dmljZXMuYwlNb24gU2VwIDA4IDE4OjQ3OjU0IDIwMDggKzAyMDANCkBAIC0xMTE5LDYgKzEx
MTksNyBAQCBzdHJ1Y3QgdXNiX2RldmljZV9pZCBkaWIwNzAwX3VzYl9pZF90YWJsDQogCXsg
VVNCX0RFVklDRShVU0JfVklEX0xFQURURUssICAgVVNCX1BJRF9XSU5GQVNUX0RUVl9ET05H
TEVfU1RLNzcwMFBfMikgfSwNCiAvKiAzNSAqL3sgVVNCX0RFVklDRShVU0JfVklEX0hBVVBQ
QVVHRSwgVVNCX1BJRF9IQVVQUEFVR0VfTk9WQV9URF9TVElDS181MjAwOSkgfSwNCiAJeyBV
U0JfREVWSUNFKFVTQl9WSURfSEFVUFBBVUdFLCBVU0JfUElEX0hBVVBQQVVHRV9OT1ZBX1Rf
NTAwXzMpIH0sDQorCXsgVVNCX0RFVklDRShVU0JfVklEX1lVQU4sCVVTQl9QSURfWVVBTl9T
VEs3NzAwRCkgfSwNCiAJeyAwIH0JCS8qIFRlcm1pbmF0aW5nIGVudHJ5ICovDQogfTsNCiBN
T0RVTEVfREVWSUNFX1RBQkxFKHVzYiwgZGliMDcwMF91c2JfaWRfdGFibGUpOw0KQEAgLTE0
MDgsNyArMTQwOSw3IEBAIHN0cnVjdCBkdmJfdXNiX2RldmljZV9wcm9wZXJ0aWVzIGRpYjA3
MDANCiAJCQl9LA0KIAkJfSwNCiANCi0JCS5udW1fZGV2aWNlX2Rlc2NzID0gMywNCisJCS5u
dW1fZGV2aWNlX2Rlc2NzID0gNCwNCiAJCS5kZXZpY2VzID0gew0KIAkJCXsgICAiVGVycmF0
ZWMgQ2luZXJneSBIVCBVU0IgWEUiLA0KIAkJCQl7ICZkaWIwNzAwX3VzYl9pZF90YWJsZVsy
N10sIE5VTEwgfSwNCkBAIC0xNDIyLDYgKzE0MjMsMTAgQEAgc3RydWN0IGR2Yl91c2JfZGV2
aWNlX3Byb3BlcnRpZXMgZGliMDcwMA0KIAkJCQl7ICZkaWIwNzAwX3VzYl9pZF90YWJsZVsz
Ml0sIE5VTEwgfSwNCiAJCQkJeyBOVUxMIH0sDQogCQkJfSwNCisJCQl7ICAgIll1YW4gU1RL
NzcwMEQiLA0KKwkJCQl7ICZkaWIwNzAwX3VzYl9pZF90YWJsZVszN10sIE5VTEwgfSwNCisJ
CQkJeyBOVUxMIH0sDQorCQkJfSwNCiAJCX0sDQogCQkucmNfaW50ZXJ2YWwgICAgICA9IERF
RkFVTFRfUkNfSU5URVJWQUwsDQogCQkucmNfa2V5X21hcCAgICAgICA9IGRpYjA3MDBfcmNf
a2V5cywNCmRpZmYgLXIgZmYwNTIwMTBjNGNiIC1yIDk4NGJmNDdjMTFlZCBsaW51eC9kcml2
ZXJzL21lZGlhL2R2Yi9kdmItdXNiL2R2Yi11c2ItaWRzLmgNCi0tLSBhL2xpbnV4L2RyaXZl
cnMvbWVkaWEvZHZiL2R2Yi11c2IvZHZiLXVzYi1pZHMuaAlTdW4gU2VwIDA3IDE0OjQ2OjQ0
IDIwMDggKzAyMDANCisrKyBiL2xpbnV4L2RyaXZlcnMvbWVkaWEvZHZiL2R2Yi11c2IvZHZi
LXVzYi1pZHMuaAlNb24gU2VwIDA4IDE4OjQ3OjU0IDIwMDggKzAyMDANCkBAIC0yMDgsNiAr
MjA4LDcgQEANCiAjZGVmaW5lIFVTQl9QSURfQVNVU19VMzAwMAkJCQkweDE3MWYNCiAjZGVm
aW5lIFVTQl9QSURfQVNVU19VMzEwMAkJCQkweDE3M2YNCiAjZGVmaW5lIFVTQl9QSURfWVVB
Tl9FQzM3MlMJCQkJMHgxZWRjDQorI2RlZmluZSBVU0JfUElEX1lVQU5fU1RLNzcwMEQJCQkJ
MHgxZjA4DQogI2RlZmluZSBVU0JfUElEX0RXMjEwMgkJCQkJMHgyMTAyDQogDQogI2VuZGlm

----387128B66CE7E590_message_boundary--
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
----387128B66CE7E590_message_boundary----
