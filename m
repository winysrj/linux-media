Return-path: <linux-media-owner@vger.kernel.org>
Received: from 219-87-157-213.static.tfn.net.tw ([219.87.157.213]:17211 "EHLO
	ironport.ite.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbaHRFeu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Aug 2014 01:34:50 -0400
Subject: linux-firmware: Add firmware v3.25.0.0 for ITEtech IT9135 DVB-T
 USB driver
From: Bimow Chen <Bimow.Chen@ite.com.tw>
To: linux-firmware@kernel.org
Cc: linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary="=-DOkdUlWQFnRW6fDETCiX"
Date: Mon, 18 Aug 2014 13:36:11 +0800
Message-ID: <1408340171.7346.4.camel@ite-desktop>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-DOkdUlWQFnRW6fDETCiX
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Add two firmwares for ITEtech IT9135 Ax and Bx chip versions.

--=-DOkdUlWQFnRW6fDETCiX
Content-Disposition: attachment; filename*0=0001-it9135-add-firmware-v3.25.0.0-for-ITEtech-IT9135-DVB.pat; filename*1=ch
Content-Type: text/x-patch; name="0001-it9135-add-firmware-v3.25.0.0-for-ITEtech-IT9135-DVB.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From 7f12471b97ff0a81a97d9133e10a5ebe4e7c0c11 Mon Sep 17 00:00:00 2001
From: Bimow Chen <Bimow.Chen@ite.com.tw>
Date: Fri, 15 Aug 2014 13:44:19 +0800
Subject: [PATCH] it9135: add firmware v3.25.0.0 for ITEtech IT9135 DVB-T USB driver

Signed-off-by: Bimow Chen <Bimow.Chen@ite.com.tw>
---
 WHENCE               |   10 ++++++++++
 dvb-usb-it9135-01.fw |  Bin 0 -> 8128 bytes
 dvb-usb-it9135-02.fw |  Bin 0 -> 5834 bytes
 3 files changed, 10 insertions(+), 0 deletions(-)
 create mode 100644 dvb-usb-it9135-01.fw
 create mode 100644 dvb-usb-it9135-02.fw

diff --git a/WHENCE b/WHENCE
index bd65d8c..9c0ca10 100644
--- a/WHENCE
+++ b/WHENCE
@@ -2503,3 +2503,13 @@ File: intel/fw_sst_0f28.bin-48kHz_i2s_master
 License: Redistributable. See LICENCE.fw_sst_0f28 for details
 
 --------------------------------------------------------------------------
+
+Driver: it9135 -- ITEtech IT913x DVB-T USB driver
+
+File: dvb-usb-it9135-01.fw
+File: dvb-usb-it9135-02.fw
+Version: 3.25.0.0
+
+Licence: GPLv2 or later
+
+--------------------------------------------------------------------------
diff --git a/dvb-usb-it9135-01.fw b/dvb-usb-it9135-01.fw
new file mode 100644
index 0000000000000000000000000000000000000000..ffb51223d26700a3691c19f006bb4cf043db33c5
GIT binary patch
literal 8128
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

literal 0
HcmV?d00001

diff --git a/dvb-usb-it9135-02.fw b/dvb-usb-it9135-02.fw
new file mode 100644
index 0000000000000000000000000000000000000000..e4dadd150fde91090aa90e82cf90641b2ae52ab0
GIT binary patch
literal 5834
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
LU?mD4v+VkRwhnde

literal 0
HcmV?d00001

-- 
1.7.0.4


--=-DOkdUlWQFnRW6fDETCiX--

