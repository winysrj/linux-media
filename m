Return-path: <linux-media-owner@vger.kernel.org>
Received: from blu004-omc3s21.hotmail.com ([65.55.116.96]:62381 "EHLO
	BLU004-OMC3S21.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751605AbaJYUW3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Oct 2014 16:22:29 -0400
Message-ID: <BLU437-SMTP74723F476D15D78EEEA959BA900@phx.gbl>
From: Michael Krufky <mkrufky@hotmail.com>
To: linux-media <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Richard Vollkommer <linux@hauppauge.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Michael Ira Krufky <mkrufky@linuxtv.org>
Subject: [PATCH 1/3] xc5000: tuner firmware update
Date: Sat, 25 Oct 2014 16:17:21 -0400
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Richard Vollkommer <linux@hauppauge.com>

- Update the xc5000 tuner firmware to version 1.6.821

- Update the xc5000c tuner firmware to version 4.1.33

Firmware files can be downloaded from:

- http://hauppauge.lightpath.net/software/hvr950q/xc5000c-4.1.33.zip
- http://hauppauge.lightpath.net/software/hvr950q/xc5000-1.6.821.zip

Signed-off-by: Richard Vollkommer <linux@hauppauge.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Signed-off-by: Michael Ira Krufky <mkrufky@linuxtv.org>
---
 drivers/media/tuners/xc5000.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/media/tuners/xc5000.c b/drivers/media/tuners/xc5000.c
index e44c8ab..fafff4c 100644
--- a/drivers/media/tuners/xc5000.c
+++ b/drivers/media/tuners/xc5000.c
@@ -222,15 +222,15 @@ struct xc5000_fw_cfg {
 	u8 fw_checksum_supported;
 };
 
-#define XC5000A_FIRMWARE "dvb-fe-xc5000-1.6.114.fw"
-static const struct xc5000_fw_cfg xc5000a_1_6_114 = {
+#define XC5000A_FIRMWARE "dvb-fe-xc5000-1.6.821.fw"
+static const struct xc5000_fw_cfg xc5000a_fw_cfg = {
 	.name = XC5000A_FIRMWARE,
 	.size = 12401,
-	.pll_reg = 0x806c,
+	.pll_reg = 0x8067,
 };
 
-#define XC5000C_FIRMWARE "dvb-fe-xc5000c-4.1.30.7.fw"
-static const struct xc5000_fw_cfg xc5000c_41_024_5 = {
+#define XC5000C_FIRMWARE "dvb-fe-xc5000c-4.1.33.fw"
+static const struct xc5000_fw_cfg xc5000c_fw_cfg = {
 	.name = XC5000C_FIRMWARE,
 	.size = 16497,
 	.pll_reg = 0x13,
@@ -243,9 +243,9 @@ static inline const struct xc5000_fw_cfg *xc5000_assign_firmware(int chip_id)
 	switch (chip_id) {
 	default:
 	case XC5000A:
-		return &xc5000a_1_6_114;
+		return &xc5000a_fw_cfg;
 	case XC5000C:
-		return &xc5000c_41_024_5;
+		return &xc5000c_fw_cfg;
 	}
 }
 
-- 
1.9.1

