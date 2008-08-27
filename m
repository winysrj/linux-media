Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from main.gmane.org ([80.91.229.2] helo=ciao.gmane.org)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gldd-linux-dvb@m.gmane.org>) id 1KYMpa-00081Z-KP
	for linux-dvb@linuxtv.org; Wed, 27 Aug 2008 17:21:12 +0200
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1KYMpT-0004a9-BI
	for linux-dvb@linuxtv.org; Wed, 27 Aug 2008 15:21:03 +0000
Received: from c83-254-20-12.bredband.comhem.se ([83.254.20.12])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Wed, 27 Aug 2008 15:21:03 +0000
Received: from elupus by c83-254-20-12.bredband.comhem.se with local (Gmexim
	0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Wed, 27 Aug 2008 15:21:03 +0000
To: linux-dvb@linuxtv.org
From: elupus <elupus@ecce.se>
Date: Wed, 27 Aug 2008 17:20:58 +0200
Message-ID: <10d98cn4rdklb.sc6i17qzg4hh.dlg@40tude.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="--456C902C42E246E3_message_boundary--"
Subject: [linux-dvb] [PATCH] Yuan STK7700D support
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

----456C902C42E246E3_message_boundary--
Content-type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi, 

I've posted a similar patch before, but it hasn't been added to source yet.
So here is a updated patch.

This device is what AOpen sells as a MC770A. Let's hope this can get
integrated soon.

ps. anybody ever though of changing the hardcoded magic numbers in the
device setup. ie dib0700_usb_id_table[36], it's kinda messy when you are
trying to maintain a patch :/.

Regards
Joakim
----456C902C42E246E3_message_boundary--
Content-type: text/x-patch; charset=iso-8859-1
Content-Transfer-Encoding: Base64
Content-Disposition: attachment; filename=yuan.patch
Content-Description: Attached file: yuan.patch

ZGlmZiAtciBhNDg0M2UxMzA0ZTYgbGludXgvZHJpdmVycy9tZWRpYS9kdmIvZHZiLXVzYi9k
aWIwNzAwX2RldmljZXMuYw0KLS0tIGEvbGludXgvZHJpdmVycy9tZWRpYS9kdmIvZHZiLXVz
Yi9kaWIwNzAwX2RldmljZXMuYwlTdW4gQXVnIDI0IDEyOjI4OjExIDIwMDggLTAzMDANCisr
KyBiL2xpbnV4L2RyaXZlcnMvbWVkaWEvZHZiL2R2Yi11c2IvZGliMDcwMF9kZXZpY2VzLmMJ
V2VkIEF1ZyAyNyAxNzoxNjoxMyAyMDA4ICswMjAwDQpAQCAtMTExOCw2ICsxMTE4LDcgQEAg
c3RydWN0IHVzYl9kZXZpY2VfaWQgZGliMDcwMF91c2JfaWRfdGFibA0KIAl7IFVTQl9ERVZJ
Q0UoVVNCX1ZJRF9URVJSQVRFQywJVVNCX1BJRF9URVJSQVRFQ19DSU5FUkdZX1RfWFhTKSB9
LA0KIAl7IFVTQl9ERVZJQ0UoVVNCX1ZJRF9MRUFEVEVLLCAgIFVTQl9QSURfV0lORkFTVF9E
VFZfRE9OR0xFX1NUSzc3MDBQXzIpIH0sDQogCXsgVVNCX0RFVklDRShVU0JfVklEX0hBVVBQ
QVVHRSwgVVNCX1BJRF9IQVVQUEFVR0VfTk9WQV9URF9TVElDS181MjAwOSkgfSwNCisJeyBV
U0JfREVWSUNFKFVTQl9WSURfWVVBTiwJVVNCX1BJRF9ZVUFOX1NUSzc3MDBEKSB9LA0KIAl7
IDAgfQkJLyogVGVybWluYXRpbmcgZW50cnkgKi8NCiB9Ow0KIE1PRFVMRV9ERVZJQ0VfVEFC
TEUodXNiLCBkaWIwNzAwX3VzYl9pZF90YWJsZSk7DQpAQCAtMTQwMyw3ICsxNDA0LDcgQEAg
c3RydWN0IGR2Yl91c2JfZGV2aWNlX3Byb3BlcnRpZXMgZGliMDcwMA0KIAkJCX0sDQogCQl9
LA0KIA0KLQkJLm51bV9kZXZpY2VfZGVzY3MgPSAzLA0KKwkJLm51bV9kZXZpY2VfZGVzY3Mg
PSA0LA0KIAkJLmRldmljZXMgPSB7DQogCQkJeyAgICJUZXJyYXRlYyBDaW5lcmd5IEhUIFVT
QiBYRSIsDQogCQkJCXsgJmRpYjA3MDBfdXNiX2lkX3RhYmxlWzI3XSwgTlVMTCB9LA0KQEAg
LTE0MTcsNiArMTQxOCwxMCBAQCBzdHJ1Y3QgZHZiX3VzYl9kZXZpY2VfcHJvcGVydGllcyBk
aWIwNzAwDQogCQkJCXsgJmRpYjA3MDBfdXNiX2lkX3RhYmxlWzMyXSwgTlVMTCB9LA0KIAkJ
CQl7IE5VTEwgfSwNCiAJCQl9LA0KKwkJCXsgICAiWXVhbiBTVEs3NzAwRCIsDQorCQkJCXsg
JmRpYjA3MDBfdXNiX2lkX3RhYmxlWzM2XSwgTlVMTCB9LA0KKwkJCQl7IE5VTEwgfSwNCisJ
CQl9LA0KIAkJfSwNCiAJCS5yY19pbnRlcnZhbCAgICAgID0gREVGQVVMVF9SQ19JTlRFUlZB
TCwNCiAJCS5yY19rZXlfbWFwICAgICAgID0gZGliMDcwMF9yY19rZXlzLA0KZGlmZiAtciBh
NDg0M2UxMzA0ZTYgbGludXgvZHJpdmVycy9tZWRpYS9kdmIvZHZiLXVzYi9kdmItdXNiLWlk
cy5oDQotLS0gYS9saW51eC9kcml2ZXJzL21lZGlhL2R2Yi9kdmItdXNiL2R2Yi11c2ItaWRz
LmgJU3VuIEF1ZyAyNCAxMjoyODoxMSAyMDA4IC0wMzAwDQorKysgYi9saW51eC9kcml2ZXJz
L21lZGlhL2R2Yi9kdmItdXNiL2R2Yi11c2ItaWRzLmgJV2VkIEF1ZyAyNyAxNzoxNjoxMyAy
MDA4ICswMjAwDQpAQCAtMjA3LDYgKzIwNyw3IEBADQogI2RlZmluZSBVU0JfUElEX0FTVVNf
VTMwMDAJCQkJMHgxNzFmDQogI2RlZmluZSBVU0JfUElEX0FTVVNfVTMxMDAJCQkJMHgxNzNm
DQogI2RlZmluZSBVU0JfUElEX1lVQU5fRUMzNzJTCQkJCTB4MWVkYw0KKyNkZWZpbmUgVVNC
X1BJRF9ZVUFOX1NUSzc3MDBECQkJCTB4MWYwOA0KICNkZWZpbmUgVVNCX1BJRF9EVzIxMDIJ
CQkJCTB4MjEwMg0KIA0KICNlbmRpZg==

----456C902C42E246E3_message_boundary--
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
----456C902C42E246E3_message_boundary----
