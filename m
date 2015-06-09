Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f43.google.com ([209.85.192.43]:32811 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbbFIBVI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2015 21:21:08 -0400
Received: by qgfa66 with SMTP id a66so1448914qgf.0
        for <linux-media@vger.kernel.org>; Mon, 08 Jun 2015 18:21:08 -0700 (PDT)
From: =?UTF-8?q?Rafael=20Louren=C3=A7o=20de=20Lima=20Chehab?=
	<chehabrafael@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: =?UTF-8?q?Rafael=20Louren=C3=A7o=20de=20Lima=20Chehab?=
	<chehabrafael@gmail.com>
Subject: [PATCH 1/2 v3] au0828: move dev->boards atribuition to happen earlier
Date: Mon,  8 Jun 2015 22:20:45 -0300
Message-Id: <1433812846-7450-1-git-send-email-chehabrafael@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The attribution of dev->boards occured too late, which
would couse an OOPS in media controller registration.

Signed-off-by: Rafael Lourenço de Lima Chehab <chehabrafael@gmail.com>
---
 drivers/media/usb/au0828/au0828-cards.c | 2 --
 drivers/media/usb/au0828/au0828-core.c  | 2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-cards.c b/drivers/media/usb/au0828/au0828-cards.c
index edc27355f271..6b469e8c4c6e 100644
--- a/drivers/media/usb/au0828/au0828-cards.c
+++ b/drivers/media/usb/au0828/au0828-cards.c
@@ -195,8 +195,6 @@ void au0828_card_setup(struct au0828_dev *dev)
 
 	dprintk(1, "%s()\n", __func__);
 
-	dev->board = au0828_boards[dev->boardnr];
-
 	if (dev->i2c_rc == 0) {
 		dev->i2c_client.addr = 0xa0 >> 1;
 		tveeprom_read(&dev->i2c_client, eeprom, sizeof(eeprom));
diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 082ae6ba492f..0934024fb89d 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -222,6 +222,8 @@ static int au0828_usb_probe(struct usb_interface *interface,
 	mutex_init(&dev->dvb.lock);
 	dev->usbdev = usbdev;
 	dev->boardnr = id->driver_info;
+	dev->board = au0828_boards[dev->boardnr];
+
 
 #ifdef CONFIG_VIDEO_AU0828_V4L2
 	dev->v4l2_dev.release = au0828_usb_v4l2_release;
-- 
2.1.0

