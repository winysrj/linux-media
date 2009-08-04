Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:51714 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526AbZHDTiM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Aug 2009 15:38:12 -0400
From: Pete Hildebrandt <send2ph@googlemail.com>
To: linux-media@vger.kernel.org
Subject: [patch] Added Support for STK7700D (DVB)
Date: Tue, 4 Aug 2009 21:38:11 +0200
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_j4IeKyyCu12e2Rh"
Message-Id: <200908042138.11938.send2ph@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_j4IeKyyCu12e2Rh
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,

To this mail I attached two patch-files to add support for the STK7700D
USB-DVB-Device.

lsusb identifies it as:
idVendor           0x1164 YUAN High-Tech Development Co., Ltd
idProduct          0x1efc
 iProduct                2 STK7700D

My two patches mainly just add the new product-ID.

I have tested the modification with the 2.6.28 and the 2.6.30 kernel. The
patches are for the 2.6.30 kernel.

The device is build into my laptop (Samsung R55-T5500) and works great after
applying the patches.

Bye
Pete

--Boundary-00=_j4IeKyyCu12e2Rh
Content-Type: text/x-diff;
  charset="us-ascii";
  name="patch_dib0700-devices_c.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="patch_dib0700-devices_c.patch"

LS0tIGEvbGludXgvZHJpdmVycy9tZWRpYS9kdmIvZHZiLXVzYi9kaWIwNzAwX2RldmljZXMuYwky
MDA5LTA1LTI1IDIxOjUwOjA5LjAwMDAwMDAwMCArMDIwMAorKysgYi9saW51eC9kcml2ZXJzL21l
ZGlhL2R2Yi9kdmItdXNiL2RpYjA3MDBfZGV2aWNlcy5jCTIwMDktMDYtMTEgMTg6MDg6MDQuMDAw
MDAwMDAwICswMjAwCkBAIC0xNDkzLDYgKzE0OTMsNyBAQAogCXsgVVNCX0RFVklDRShVU0JfVklE
X0hBVVBQQVVHRSwgVVNCX1BJRF9IQVVQUEFVR0VfVElHRVJfQVRTQ19CMjEwKSB9LAogCXsgVVNC
X0RFVklDRShVU0JfVklEX1lVQU4sCVVTQl9QSURfWVVBTl9NQzc3MCkgfSwKIAl7IFVTQl9ERVZJ
Q0UoVVNCX1ZJRF9FTEdBVE8sCVVTQl9QSURfRUxHQVRPX0VZRVRWX0RUVCkgfSwKKy8qIDUwICov
eyBVU0JfREVWSUNFKFVTQl9WSURfWVVBTiwgICAgICBVU0JfUElEX1lVQU5fU1RLNzcwMEQpIH0s
CiAJeyAwIH0JCS8qIFRlcm1pbmF0aW5nIGVudHJ5ICovCiB9OwogTU9EVUxFX0RFVklDRV9UQUJM
RSh1c2IsIGRpYjA3MDBfdXNiX2lkX3RhYmxlKTsKQEAgLTE4MTIsNyArMTgxMyw3IEBACiAJCQl9
LAogCQl9LAogCi0JCS5udW1fZGV2aWNlX2Rlc2NzID0gNywKKwkJLm51bV9kZXZpY2VfZGVzY3Mg
PSA4LAogCQkuZGV2aWNlcyA9IHsKIAkJCXsgICAiVGVycmF0ZWMgQ2luZXJneSBIVCBVU0IgWEUi
LAogCQkJCXsgJmRpYjA3MDBfdXNiX2lkX3RhYmxlWzI3XSwgTlVMTCB9LApAQCAtMTg0Miw2ICsx
ODQzLDExIEBACiAJCQkJeyAmZGliMDcwMF91c2JfaWRfdGFibGVbNDhdLCBOVUxMIH0sCiAJCQkJ
eyBOVUxMIH0sCiAJCQl9LAorCQkJeyAgICJZVUFOIEhpZ2gtVGVjaCBTVEs3NzAwRCIsCisJCQkJ
eyAmZGliMDcwMF91c2JfaWRfdGFibGVbNTBdLCBOVUxMIH0sCisJCQkJeyBOVUxMIH0sCisJCQl9
LAorCiAJCX0sCiAJCS5yY19pbnRlcnZhbCAgICAgID0gREVGQVVMVF9SQ19JTlRFUlZBTCwKIAkJ
LnJjX2tleV9tYXAgICAgICAgPSBkaWIwNzAwX3JjX2tleXMsCg==
--Boundary-00=_j4IeKyyCu12e2Rh
Content-Type: text/x-diff;
  charset="us-ascii";
  name="patch_dvb-usb-ids_h.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="patch_dvb-usb-ids_h.patch"

LS0tIGEvbGludXgvZHJpdmVycy9tZWRpYS9kdmIvZHZiLXVzYi9kdmItdXNiLWlkcy5oCTIwMDkt
MDUtMjUgMjE6NTA6MDkuMDAwMDAwMDAwICswMjAwCisrKyBiL2xpbnV4L2RyaXZlcnMvbWVkaWEv
ZHZiL2R2Yi11c2IvZHZiLXVzYi1pZHMuaAkyMDA5LTA2LTIzIDE5OjM0OjIwLjAwMDAwMDAwMCAr
MDIwMApAQCAtMjQ1LDYgKzI0NSw3IEBACiAjZGVmaW5lIFVTQl9QSURfWVVBTl9TVEs3NzAwUEgJ
CQkJMHgxZjA4CiAjZGVmaW5lIFVTQl9QSURfWVVBTl9QRDM3OFMJCQkJMHgyZWRjCiAjZGVmaW5l
IFVTQl9QSURfWVVBTl9NQzc3MAkJCQkweDA4NzEKKyNkZWZpbmUgVVNCX1BJRF9ZVUFOX1NUSzc3
MDBECQkJCTB4MWVmYwogI2RlZmluZSBVU0JfUElEX0RXMjEwMgkJCQkJMHgyMTAyCiAjZGVmaW5l
IFVTQl9QSURfWFRFTlNJT05TX1hEXzM4MAkJCTB4MDM4MQogI2RlZmluZSBVU0JfUElEX1RFTEVT
VEFSX1NUQVJTVElDS18yCQkJMHg4MDAwCg==
--Boundary-00=_j4IeKyyCu12e2Rh--
