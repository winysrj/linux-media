Return-path: <linux-media-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.243]:16645 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734AbZCYGE4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Mar 2009 02:04:56 -0400
Received: by an-out-0708.google.com with SMTP id d14so2233401and.1
        for <linux-media@vger.kernel.org>; Tue, 24 Mar 2009 23:04:53 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 25 Mar 2009 03:04:53 -0300
Message-ID: <68cac7520903242304k4082d078ve7a833ca218772c7@mail.gmail.com>
Subject: zc3xx: Add .driver_info to DLink DSB - C320
From: Douglas Schilling Landgraf <dougsland@gmail.com>
To: moinejf@free.fr
Cc: linux-media@vger.kernel.org,
	"bruna@griebeler.com" <bruna@griebeler.com>
Content-Type: multipart/mixed; boundary=000325550d62379ee80465eb47e0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--000325550d62379ee80465eb47e0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello Jean,

Attached patch for the following:

zc3xx: Add .driver_info to DLink DSB - C320

Added .driver_info = SENSOR_PAS106 to 0x0ac8, 0x0302 (D-Link DSB - C320)
Thanks to Bruna Griebeler <bruna@griebeler.com> for reporting and test.

Reported-by: Bruna Griebeler <bruna@griebeler.com>
Tested-by: Bruna Griebeler <bruna@griebeler.com>
Signed-off-by: Douglas Schilling Landgraf <dougsland@redhat.com>

Thanks,
Douglas

--000325550d62379ee80465eb47e0
Content-Type: application/octet-stream; name="zc3xx-add-driver-info.diff"
Content-Disposition: attachment; filename="zc3xx-add-driver-info.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fspm0moh0

ZGlmZiAtciA1NmNmMGYxNzcyZjcgbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9nc3BjYS96YzN4
eC5jCi0tLSBhL2xpbnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8vZ3NwY2EvemMzeHguYwlNb24gTWFy
IDIzIDE5OjE4OjM0IDIwMDkgLTAzMDAKKysrIGIvbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9n
c3BjYS96YzN4eC5jCVdlZCBNYXIgMjUgMDI6Mzc6NDggMjAwOSAtMDMwMApAQCAtNzY2Miw3ICs3
NjYyLDcgQEAKIAl7VVNCX0RFVklDRSgweDA1NWYsIDB4ZDAwNCl9LAogCXtVU0JfREVWSUNFKDB4
MDY5OCwgMHgyMDAzKX0sCiAJe1VTQl9ERVZJQ0UoMHgwYWM4LCAweDAzMDEpLCAuZHJpdmVyX2lu
Zm8gPSBTRU5TT1JfUEFTMTA2fSwKLQl7VVNCX0RFVklDRSgweDBhYzgsIDB4MDMwMil9LAorCXtV
U0JfREVWSUNFKDB4MGFjOCwgMHgwMzAyKSwgLmRyaXZlcl9pbmZvID0gU0VOU09SX1BBUzEwNn0s
CiAJe1VTQl9ERVZJQ0UoMHgwYWM4LCAweDMwMWIpfSwKIAl7VVNCX0RFVklDRSgweDBhYzgsIDB4
MzAzYil9LAogCXtVU0JfREVWSUNFKDB4MGFjOCwgMHgzMDViKSwgLmRyaXZlcl9pbmZvID0gU0VO
U09SX1RBUzUxMzBDX1ZGMDI1MH0sCg==
--000325550d62379ee80465eb47e0--
