Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fk-out-0910.google.com ([209.85.128.186])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <don@syst.com.br>) id 1KcBNR-0002ME-GL
	for linux-dvb@linuxtv.org; Sun, 07 Sep 2008 05:55:55 +0200
Received: by fk-out-0910.google.com with SMTP id f40so825161fka.1
	for <linux-dvb@linuxtv.org>; Sat, 06 Sep 2008 20:55:49 -0700 (PDT)
Message-ID: <a86be8e70809062055v6157e476nfbff0cba13dbd444@mail.gmail.com>
Date: Sun, 7 Sep 2008 00:55:49 -0300
From: "Daniel Oliveira Nascimento" <don@syst.com.br>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_61807_13647873.1220759749497"
Subject: [linux-dvb] [PATCH] support YUAN High-Tech STK7700D (1164:1f08)
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

------=_Part_61807_13647873.1220759749497
Content-Type: multipart/alternative;
	boundary="----=_Part_61808_27097693.1220759749497"

------=_Part_61808_27097693.1220759749497
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi List,

attached is a patch that extends the dib0700 driver to support the
DVB-part of the Asus notebook M51Sn tv-tunner (USB-ID 1164:1f08).

Following this thread:
http://thread.gmane.org/gmane.linux.drivers.dvb/39269/focus=39298

I reproduced the same behavior that Albert Comerma had with his card.
So I think that the same code will work with this card.
I can't test if the card work properly with the patch because a live
in Brazil and the digital tv standard is different.
But I think that this information will be useful for someone trying to
make this card work.

Did someone make the analog part of any of these cards "Terratec
Cinergy HT USB XE", "Pinnacle Expresscard 320cx" or "Terratec Cinergy
HT Express" work ?

------=_Part_61808_27097693.1220759749497
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr"><pre>Hi List,<br><br>attached is a patch that extends the dib0700 driver to support the DVB-part of the Asus notebook M51Sn tv-tunner (USB-ID 1164:1f08).<br><br>Following this thread:<br><a href="http://thread.gmane.org/gmane.linux.drivers.dvb/39269/focus=39298">http://thread.gmane.org/gmane.linux.drivers.dvb/39269/focus=39298</a><br>
<br>I reproduced the same behavior that Albert Comerma had with his card. So I think that the same code will work with this card.<br>I can&#39;t test if the card work properly with the patch because a live in Brazil and the digital tv standard is different. <br>
But I think that this information will be useful for someone trying to make this card work.<br><br>Did someone make the analog part of any of these cards &quot;Terratec Cinergy HT USB XE&quot;, &quot;Pinnacle Expresscard 320cx&quot; or &quot;Terratec Cinergy HT Express&quot; work ?<br>
<br></pre></div>

------=_Part_61808_27097693.1220759749497--

------=_Part_61807_13647873.1220759749497
Content-Type: text/x-patch; name=YUAN_STK7700.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fkt4lj3f0
Content-Disposition: attachment; filename=YUAN_STK7700.patch

ZGlmZiAtTmF1ciB2NGwtZHZiLm9yaWcvbGludXgvZHJpdmVycy9tZWRpYS9kdmIvZHZiLXVzYi9k
aWIwNzAwX2RldmljZXMuYyB2NGwtZHZiLTIwMDgwOTA3L2xpbnV4L2RyaXZlcnMvbWVkaWEvZHZi
L2R2Yi11c2IvZGliMDcwMF9kZXZpY2VzLmMKLS0tIHY0bC1kdmIub3JpZy9saW51eC9kcml2ZXJz
L21lZGlhL2R2Yi9kdmItdXNiL2RpYjA3MDBfZGV2aWNlcy5jCTIwMDgtMDktMDcgMDA6MTE6Mjcu
MDAwMDAwMDAwIC0wMzAwCisrKyB2NGwtZHZiLTIwMDgwOTA3L2xpbnV4L2RyaXZlcnMvbWVkaWEv
ZHZiL2R2Yi11c2IvZGliMDcwMF9kZXZpY2VzLmMJMjAwOC0wOS0wNyAwMDoxODo1My4wMDAwMDAw
MDAgLTAzMDAKQEAgLTExMTksNiArMTExOSw3IEBACiAJeyBVU0JfREVWSUNFKFVTQl9WSURfTEVB
RFRFSywgICBVU0JfUElEX1dJTkZBU1RfRFRWX0RPTkdMRV9TVEs3NzAwUF8yKSB9LAogLyogMzUg
Ki97IFVTQl9ERVZJQ0UoVVNCX1ZJRF9IQVVQUEFVR0UsIFVTQl9QSURfSEFVUFBBVUdFX05PVkFf
VERfU1RJQ0tfNTIwMDkpIH0sCiAJeyBVU0JfREVWSUNFKFVTQl9WSURfSEFVUFBBVUdFLCBVU0Jf
UElEX0hBVVBQQVVHRV9OT1ZBX1RfNTAwXzMpIH0sCisJeyBVU0JfREVWSUNFKFVTQl9WSURfWVVB
TiwgICAgICBVU0JfUElEX1lVQU5fU1RLNzcwMCkgfSwKIAl7IDAgfQkJLyogVGVybWluYXRpbmcg
ZW50cnkgKi8KIH07CiBNT0RVTEVfREVWSUNFX1RBQkxFKHVzYiwgZGliMDcwMF91c2JfaWRfdGFi
bGUpOwpAQCAtMTQwOCw3ICsxNDA5LDcgQEAKIAkJCX0sCiAJCX0sCiAKLQkJLm51bV9kZXZpY2Vf
ZGVzY3MgPSAzLAorCQkubnVtX2RldmljZV9kZXNjcyA9IDQsCiAJCS5kZXZpY2VzID0gewogCQkJ
eyAgICJUZXJyYXRlYyBDaW5lcmd5IEhUIFVTQiBYRSIsCiAJCQkJeyAmZGliMDcwMF91c2JfaWRf
dGFibGVbMjddLCBOVUxMIH0sCkBAIC0xNDIyLDYgKzE0MjMsMTAgQEAKIAkJCQl7ICZkaWIwNzAw
X3VzYl9pZF90YWJsZVszMl0sIE5VTEwgfSwKIAkJCQl7IE5VTEwgfSwKIAkJCX0sCisgICAgICAg
ICAgICAgICAgICAgICAgICB7ICAgIllVQU4gSGlnaC1UZWNoIFNUSzc3MDBEIiwKKyAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgeyAmZGliMDcwMF91c2JfaWRfdGFibGVbMzddLCBOVUxM
IH0sCisgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHsgTlVMTCB9LAorICAgICAgICAg
ICAgICAgICAgICAgICAgfSwKIAkJfSwKIAkJLnJjX2ludGVydmFsICAgICAgPSBERUZBVUxUX1JD
X0lOVEVSVkFMLAogCQkucmNfa2V5X21hcCAgICAgICA9IGRpYjA3MDBfcmNfa2V5cywKZGlmZiAt
TmF1ciB2NGwtZHZiLm9yaWcvbGludXgvZHJpdmVycy9tZWRpYS9kdmIvZHZiLXVzYi9kdmItdXNi
LWlkcy5oIHY0bC1kdmItMjAwODA5MDcvbGludXgvZHJpdmVycy9tZWRpYS9kdmIvZHZiLXVzYi9k
dmItdXNiLWlkcy5oCi0tLSB2NGwtZHZiLm9yaWcvbGludXgvZHJpdmVycy9tZWRpYS9kdmIvZHZi
LXVzYi9kdmItdXNiLWlkcy5oCTIwMDgtMDktMDcgMDA6MTE6MjcuMDAwMDAwMDAwIC0wMzAwCisr
KyB2NGwtZHZiLTIwMDgwOTA3L2xpbnV4L2RyaXZlcnMvbWVkaWEvZHZiL2R2Yi11c2IvZHZiLXVz
Yi1pZHMuaAkyMDA4LTA5LTA3IDAwOjE4OjM3LjAwMDAwMDAwMCAtMDMwMApAQCAtMjA4LDYgKzIw
OCw3IEBACiAjZGVmaW5lIFVTQl9QSURfQVNVU19VMzAwMAkJCQkweDE3MWYKICNkZWZpbmUgVVNC
X1BJRF9BU1VTX1UzMTAwCQkJCTB4MTczZgogI2RlZmluZSBVU0JfUElEX1lVQU5fRUMzNzJTCQkJ
CTB4MWVkYworI2RlZmluZSBVU0JfUElEX1lVQU5fU1RLNzcwMAkJCQkweDFmMDgKICNkZWZpbmUg
VVNCX1BJRF9EVzIxMDIJCQkJCTB4MjEwMgogCiAjZW5kaWYK
------=_Part_61807_13647873.1220759749497
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
------=_Part_61807_13647873.1220759749497--
