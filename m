Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43611 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932230Ab2CZNNx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Mar 2012 09:13:53 -0400
Received: by mail-gx0-f174.google.com with SMTP id e5so3751115ggh.19
        for <linux-media@vger.kernel.org>; Mon, 26 Mar 2012 06:13:52 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: linux-media@vger.kernel.org, mchehab@infradead.org
Cc: rsalvaterra@gmail.com, crope@iki.fi, gennarone@gmail.com,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH 3/5] em28xx: Move em28xx_register_i2c_ir() to em28xx-input.c
Date: Mon, 26 Mar 2012 10:13:33 -0300
Message-Id: <1332767615-24218-3-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1332767615-24218-1-git-send-email-elezegarcia@gmail.com>
References: <1332767615-24218-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This function is only used in em28xx-input.c so it
makes no sense to have it anywhere but in em28xx-input.c.

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/video/em28xx/em28xx-cards.c |   48 -----------------------------
 drivers/media/video/em28xx/em28xx-input.c |   44 ++++++++++++++++++++++++++
 2 files changed, 44 insertions(+), 48 deletions(-)

diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index ba99e22..1cc244c 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -2582,54 +2582,6 @@ static int em28xx_hint_board(struct em28xx *dev)
 	return -1;
 }
 
-/* ----------------------------------------------------------------------- */
-void em28xx_register_i2c_ir(struct em28xx *dev)
-{
-	/* Leadtek winfast tv USBII deluxe can find a non working IR-device */
-	/* at address 0x18, so if that address is needed for another board in */
-	/* the future, please put it after 0x1f. */
-	struct i2c_board_info info;
-	const unsigned short addr_list[] = {
-		 0x1f, 0x30, 0x47, I2C_CLIENT_END
-	};
-
-	if (disable_ir)
-		return;
-
-	memset(&info, 0, sizeof(struct i2c_board_info));
-	memset(&dev->init_data, 0, sizeof(dev->init_data));
-	strlcpy(info.type, "ir_video", I2C_NAME_SIZE);
-
-	/* detect & configure */
-	switch (dev->model) {
-	case EM2800_BOARD_TERRATEC_CINERGY_200:
-	case EM2820_BOARD_TERRATEC_CINERGY_250:
-		dev->init_data.ir_codes = RC_MAP_EM_TERRATEC;
-		dev->init_data.get_key = em28xx_get_key_terratec;
-		dev->init_data.name = "i2c IR (EM28XX Terratec)";
-		break;
-	case EM2820_BOARD_PINNACLE_USB_2:
-		dev->init_data.ir_codes = RC_MAP_PINNACLE_GREY;
-		dev->init_data.get_key = em28xx_get_key_pinnacle_usb_grey;
-		dev->init_data.name = "i2c IR (EM28XX Pinnacle PCTV)";
-		break;
-	case EM2820_BOARD_HAUPPAUGE_WINTV_USB_2:
-		dev->init_data.ir_codes = RC_MAP_HAUPPAUGE;
-		dev->init_data.get_key = em28xx_get_key_em_haup;
-		dev->init_data.name = "i2c IR (EM2840 Hauppauge)";
-		break;
-	case EM2820_BOARD_LEADTEK_WINFAST_USBII_DELUXE:
-		dev->init_data.ir_codes = RC_MAP_WINFAST_USBII_DELUXE;
-		dev->init_data.get_key = em28xx_get_key_winfast_usbii_deluxe;
-		dev->init_data.name = "i2c IR (EM2820 Winfast TV USBII Deluxe)";
-		break;
-	}
-
-	if (dev->init_data.name)
-		info.platform_data = &dev->init_data;
-	i2c_new_probed_device(&dev->i2c_adap, &info, addr_list, NULL);
-}
-
 void em28xx_card_setup(struct em28xx *dev)
 {
 	/*
diff --git a/drivers/media/video/em28xx/em28xx-input.c b/drivers/media/video/em28xx/em28xx-input.c
index dd6e3f2..0a58ba8 100644
--- a/drivers/media/video/em28xx/em28xx-input.c
+++ b/drivers/media/video/em28xx/em28xx-input.c
@@ -387,6 +387,50 @@ int em28xx_ir_change_protocol(struct rc_dev *rc_dev, u64 rc_type)
 	return rc;
 }
 
+void em28xx_register_i2c_ir(struct em28xx *dev)
+{
+	/* Leadtek winfast tv USBII deluxe can find a non working IR-device */
+	/* at address 0x18, so if that address is needed for another board in */
+	/* the future, please put it after 0x1f. */
+	struct i2c_board_info info;
+	const unsigned short addr_list[] = {
+		 0x1f, 0x30, 0x47, I2C_CLIENT_END
+	};
+
+	memset(&info, 0, sizeof(struct i2c_board_info));
+	memset(&dev->init_data, 0, sizeof(dev->init_data));
+	strlcpy(info.type, "ir_video", I2C_NAME_SIZE);
+
+	/* detect & configure */
+	switch (dev->model) {
+	case EM2800_BOARD_TERRATEC_CINERGY_200:
+	case EM2820_BOARD_TERRATEC_CINERGY_250:
+		dev->init_data.ir_codes = RC_MAP_EM_TERRATEC;
+		dev->init_data.get_key = em28xx_get_key_terratec;
+		dev->init_data.name = "i2c IR (EM28XX Terratec)";
+		break;
+	case EM2820_BOARD_PINNACLE_USB_2:
+		dev->init_data.ir_codes = RC_MAP_PINNACLE_GREY;
+		dev->init_data.get_key = em28xx_get_key_pinnacle_usb_grey;
+		dev->init_data.name = "i2c IR (EM28XX Pinnacle PCTV)";
+		break;
+	case EM2820_BOARD_HAUPPAUGE_WINTV_USB_2:
+		dev->init_data.ir_codes = RC_MAP_HAUPPAUGE;
+		dev->init_data.get_key = em28xx_get_key_em_haup;
+		dev->init_data.name = "i2c IR (EM2840 Hauppauge)";
+		break;
+	case EM2820_BOARD_LEADTEK_WINFAST_USBII_DELUXE:
+		dev->init_data.ir_codes = RC_MAP_WINFAST_USBII_DELUXE;
+		dev->init_data.get_key = em28xx_get_key_winfast_usbii_deluxe;
+		dev->init_data.name = "i2c IR (EM2820 Winfast TV USBII Deluxe)";
+		break;
+	}
+
+	if (dev->init_data.name)
+		info.platform_data = &dev->init_data;
+	i2c_new_probed_device(&dev->i2c_adap, &info, addr_list, NULL);
+}
+
 int em28xx_ir_init(struct em28xx *dev)
 {
 	struct em28xx_IR *ir;
-- 
1.7.3.4

