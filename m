Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:59078 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752707AbcADVQ6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jan 2016 16:16:58 -0500
Received: from [192.168.6.10] ([88.217.181.124]) by mail.gmx.com (mrgmx001)
 with ESMTPSA (Nemesis) id 0M7Gj8-1a3Mwo1sne-00x71b for
 <linux-media@vger.kernel.org>; Mon, 04 Jan 2016 22:16:56 +0100
From: =?UTF-8?Q?Stefan_P=c3=b6schel?= <basic.master@gmx.de>
Subject: [PATCH] af9035: add support for 2nd tuner of MSI DigiVox Diversity
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <568AE147.6070908@gmx.de>
Date: Mon, 4 Jan 2016 22:16:55 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

PIP tested with VLC. Diversity tested with the Windows driver.

Signed-off-by: Stefan Pöschel <basic.master@gmx.de>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 4 ++--
 drivers/media/usb/dvb-usb-v2/af9035.h | 3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 6e02a15..b3c09fe 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -684,7 +684,7 @@ static int af9035_download_firmware(struct dvb_usb_device *d,
 	if (ret < 0)
 		goto err;

-	if (tmp == 1 || tmp == 3) {
+	if (tmp == 1 || tmp == 3 || tmp == 5) {
 		/* configure gpioh1, reset & power slave demod */
 		ret = af9035_wr_reg_mask(d, 0x00d8b0, 0x01, 0x01);
 		if (ret < 0)
@@ -823,7 +823,7 @@ static int af9035_read_config(struct dvb_usb_device *d)
 	if (ret < 0)
 		goto err;

-	if (tmp == 1 || tmp == 3)
+	if (tmp == 1 || tmp == 3 || tmp == 5)
 		state->dual_mode = true;

 	dev_dbg(&d->udev->dev, "%s: ts mode=%d dual mode=%d\n", __func__,
diff --git a/drivers/media/usb/dvb-usb-v2/af9035.h b/drivers/media/usb/dvb-usb-v2/af9035.h
index 416a97f..df22001 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.h
+++ b/drivers/media/usb/dvb-usb-v2/af9035.h
@@ -112,9 +112,10 @@ static const u32 clock_lut_it9135[] = {
  * 0  TS
  * 1  DCA + PIP
  * 3  PIP
+ * 5  DCA + PIP
  * n  DCA
  *
- * Values 0 and 3 are seen to this day. 0 for single TS and 3 for dual TS.
+ * Values 0, 3 and 5 are seen to this day. 0 for single TS and 3/5 for dual TS.
  */

 #define EEPROM_BASE_AF9035        0x42fd
-- 
2.6.4
