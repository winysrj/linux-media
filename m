Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:56480 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527Ab3FBVY5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Jun 2013 17:24:57 -0400
Received: by mail-wi0-f173.google.com with SMTP id hi5so2120564wib.0
        for <linux-media@vger.kernel.org>; Sun, 02 Jun 2013 14:24:56 -0700 (PDT)
From: Gianluca Gennari <gennarone@gmail.com>
To: linux-media@vger.kernel.org, mchehab@redhat.com, crope@iki.fi
Cc: mkrufky@linuxtv.org, Gianluca Gennari <gennarone@gmail.com>
Subject: [PATCH v2] rtl28xxu: fix buffer overflow when probing Rafael Micro r820t tuner
Date: Sun,  2 Jun 2013 23:24:24 +0200
Message-Id: <1370208264-10276-1-git-send-email-gennarone@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As suggested by Antti, this patch replaces:
https://patchwork.kernel.org/patch/2649861/

The buffer overflow is fixed by reading only the r820t ID register.

Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 22015fe..2cc8ec7 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -376,7 +376,7 @@ static int rtl2832u_read_config(struct dvb_usb_device *d)
 	struct rtl28xxu_req req_mxl5007t = {0xd9c0, CMD_I2C_RD, 1, buf};
 	struct rtl28xxu_req req_e4000 = {0x02c8, CMD_I2C_RD, 1, buf};
 	struct rtl28xxu_req req_tda18272 = {0x00c0, CMD_I2C_RD, 2, buf};
-	struct rtl28xxu_req req_r820t = {0x0034, CMD_I2C_RD, 5, buf};
+	struct rtl28xxu_req req_r820t = {0x0034, CMD_I2C_RD, 1, buf};
 
 	dev_dbg(&d->udev->dev, "%s:\n", __func__);
 
@@ -481,9 +481,9 @@ static int rtl2832u_read_config(struct dvb_usb_device *d)
 		goto found;
 	}
 
-	/* check R820T by reading tuner stats at I2C addr 0x1a */
+	/* check R820T ID register; reg=00 val=69 */
 	ret = rtl28xxu_ctrl_msg(d, &req_r820t);
-	if (ret == 0) {
+	if (ret == 0 && buf[0] == 0x69) {
 		priv->tuner = TUNER_RTL2832_R820T;
 		priv->tuner_name = "R820T";
 		goto found;
-- 
1.8.3

