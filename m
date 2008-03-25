Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from main.gmane.org ([80.91.229.2] helo=ciao.gmane.org)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gldd-linux-dvb@m.gmane.org>) id 1JeHTF-0007C5-BT
	for linux-dvb@linuxtv.org; Tue, 25 Mar 2008 23:18:18 +0100
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1JeHT9-0006y3-OI
	for linux-dvb@linuxtv.org; Tue, 25 Mar 2008 22:18:11 +0000
Received: from c83-254-20-12.bredband.comhem.se ([83.254.20.12])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Tue, 25 Mar 2008 22:18:11 +0000
Received: from elupus by c83-254-20-12.bredband.comhem.se with local (Gmexim
	0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Tue, 25 Mar 2008 22:18:11 +0000
To: linux-dvb@linuxtv.org
From: elupus <elupus@ecce.se>
Date: Tue, 25 Mar 2008 23:18:02 +0100
Message-ID: <19apj9y5ari7e$.iq8vatom4e8q.dlg@40tude.net>
References: <timjkg4t68k0.u9vss0x6vh17$.dlg@40tude.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="--4F2E585F347939E0_message_boundary--"
Subject: Re: [linux-dvb] STK7700-PH ( dib7700 + ConexantCX25842 + Xceive
	XC3028 )
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

----4F2E585F347939E0_message_boundary--
Content-type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


Okey, I finally got this up and running.

I used patrick's repository at http://linuxtv.org/hg/~pb/v4l-dvb/ with the
attached patch, and it alsmost worked directly :).

I found out that the standard dibcom0700 firmware, didn't work properly. By
using that it failed to load the Xceive firmware later. By however using
the code posted earlier on this list with a utility for extracting the
dibcom firmware (dibextract.c) from the windows drivers things started
working.

The utility found two firmwares in the file.  The first one failed to work
even worse, the second one however worked better (even if the utility
complained about it not matching what it expected).

Maybe it's a later version of the dibcom drivers. If anybody is interested
let me know where to upload them.

Regards
Joakim
----4F2E585F347939E0_message_boundary--
Content-type: text/x-patch; charset=iso-8859-1
Content-Transfer-Encoding: Base64
Content-Disposition: attachment; filename=yuan.patch
Content-Description: Attached file: yuan.patch

ZGlmZiAtciAzZDI1MmMyNTI4NjkgbGludXgvZHJpdmVycy9tZWRpYS9kdmIvZHZiLXVzYi9k
aWIwNzAwX2RldmljZXMuYwotLS0gYS9saW51eC9kcml2ZXJzL21lZGlhL2R2Yi9kdmItdXNi
L2RpYjA3MDBfZGV2aWNlcy5jCVNhdCBNYXIgMjIgMjM6MTk6MzggMjAwOCArMDEwMAorKysg
Yi9saW51eC9kcml2ZXJzL21lZGlhL2R2Yi9kdmItdXNiL2RpYjA3MDBfZGV2aWNlcy5jCVR1
ZSBNYXIgMjUgMjM6MDU6NDYgMjAwOCArMDEwMApAQCAtMTExNSw2ICsxMTE1LDcgQEAgc3Ry
dWN0IHVzYl9kZXZpY2VfaWQgZGliMDcwMF91c2JfaWRfdGFibAogCXsgVVNCX0RFVklDRShV
U0JfVklEX1lVQU4sCVVTQl9QSURfWVVBTl9FQzM3MlMpIH0sCiAJeyBVU0JfREVWSUNFKFVT
Ql9WSURfVEVSUkFURUMsCVVTQl9QSURfVEVSUkFURUNfQ0lORVJHWV9IVF9FWFBSRVNTKSB9
LAogCXsgVVNCX0RFVklDRShVU0JfVklEX1RFUlJBVEVDLAlVU0JfUElEX1RFUlJBVEVDX0NJ
TkVSR1lfVF9YWFMpIH0sCisJeyBVU0JfREVWSUNFKFVTQl9WSURfWVVBTiwgCVVTQl9QSURf
WVVBTl9NQzc3MEEpIH0sCiAJeyAwIH0JCS8qIFRlcm1pbmF0aW5nIGVudHJ5ICovCiB9Owog
TU9EVUxFX0RFVklDRV9UQUJMRSh1c2IsIGRpYjA3MDBfdXNiX2lkX3RhYmxlKTsKQEAgLTE0
MTUsNiArMTQxNiwyOSBAQCBzdHJ1Y3QgZHZiX3VzYl9kZXZpY2VfcHJvcGVydGllcyBkaWIw
NzAwCiAJCS5yY19rZXlfbWFwICAgICAgID0gZGliMDcwMF9yY19rZXlzLAogCQkucmNfa2V5
X21hcF9zaXplICA9IEFSUkFZX1NJWkUoZGliMDcwMF9yY19rZXlzKSwKIAkJLnJjX3F1ZXJ5
ICAgICAgICAgPSBkaWIwNzAwX3JjX3F1ZXJ5CisJfSwgeyBESUIwNzAwX0RFRkFVTFRfREVW
SUNFX1BST1BFUlRJRVMsCisKKwkJLm51bV9hZGFwdGVycyA9IDEsCisJCS5hZGFwdGVyID0g
eworCQkJeworCQkJCS5mcm9udGVuZF9hdHRhY2ggID0gc3RrNzcwMHBoX2Zyb250ZW5kX2F0
dGFjaCwKKwkJCQkudHVuZXJfYXR0YWNoICAgICA9IHN0azc3MDBwaF90dW5lcl9hdHRhY2gs
CisKKwkJCQlESUIwNzAwX0RFRkFVTFRfU1RSRUFNSU5HX0NPTkZJRygweDAyKSwKKworCQkJ
CS5zaXplX29mX3ByaXYgPSBzaXplb2Yoc3RydWN0CisJCQkJCQlkaWIwNzAwX2FkYXB0ZXJf
c3RhdGUpLAorCQkJfSwKKwkJfSwKKworCQkubnVtX2RldmljZV9kZXNjcyA9IDEsCisJCS5k
ZXZpY2VzID0geworCQkJeyAgICJZdWFuIE1DNzcwQSIsCisJCQkJeyAmZGliMDcwMF91c2Jf
aWRfdGFibGVbMzRdLCBOVUxMIH0sCisJCQkJeyBOVUxMIH0sCisJCQl9LAorCQl9LAorCQku
cmNfaW50ZXJ2YWwgICAgICA9IERFRkFVTFRfUkNfSU5URVJWQUwsCiAJfSwKIH07CiAKZGlm
ZiAtciAzZDI1MmMyNTI4NjkgbGludXgvZHJpdmVycy9tZWRpYS9kdmIvZHZiLXVzYi9kdmIt
dXNiLWlkcy5oCi0tLSBhL2xpbnV4L2RyaXZlcnMvbWVkaWEvZHZiL2R2Yi11c2IvZHZiLXVz
Yi1pZHMuaAlTYXQgTWFyIDIyIDIzOjE5OjM4IDIwMDggKzAxMDAKKysrIGIvbGludXgvZHJp
dmVycy9tZWRpYS9kdmIvZHZiLXVzYi9kdmItdXNiLWlkcy5oCVR1ZSBNYXIgMjUgMjM6MDU6
NDYgMjAwOCArMDEwMApAQCAtMTk1LDUgKzE5NSw2IEBACiAjZGVmaW5lIFVTQl9QSURfQVNV
U19VMzAwMAkJCQkweDE3MWYKICNkZWZpbmUgVVNCX1BJRF9BU1VTX1UzMTAwCQkJCTB4MTcz
ZgogI2RlZmluZSBVU0JfUElEX1lVQU5fRUMzNzJTCQkJCTB4MWVkYworI2RlZmluZSBVU0Jf
UElEX1lVQU5fTUM3NzBBCQkJCTB4MWYwOAogCiAjZW5kaWYK

----4F2E585F347939E0_message_boundary--
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
----4F2E585F347939E0_message_boundary----
