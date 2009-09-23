Return-path: <linux-media-owner@vger.kernel.org>
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:35121 "EHLO
	QMTA02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751189AbZIWKG6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Sep 2009 06:06:58 -0400
From: Brian Rogers <brian@xyzw.org>
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	Brian Rogers <brian@xyzw.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 1/2] em28xx: ir-kbd-i2c init data needs a persistent object
Date: Wed, 23 Sep 2009 03:05:02 -0700
Message-Id: <1253700303-15172-1-git-send-email-brian@xyzw.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

commit d2ebd0f806fdb6104903365e355675934eec22b2 upstream.

Original commit message:

ir-kbd-i2c's ir_probe() function can be called much later (i.e. at
ir-kbd-i2c module load), than the lifetime of a struct IR_i2c_init_data
allocated off of the stack in cx18_i2c_new_ir() at registration time.
Make sure we pass a pointer to a persistent IR_i2c_init_data object at
i2c registration time.

Thanks to Brian Rogers, Dustin Mitchell, Andy Walls and Jean Delvare to
rise this question.

Before this patch, if ir-kbd-i2c were probed after em28xx, trash data
were used. After the patch, no matter what order, it is properly
reported as tested by me:

input: i2c IR (i2c IR (EM2840 Hauppaug as /class/input/input10
ir-kbd-i2c: i2c IR (i2c IR (EM2840 Hauppaug detected at i2c-4/4-0030/ir0 [em28xx #0]

Original-patch-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
[brian@xyzw.org: backported for 2.6.31]
Signed-off-by: Brian Rogers <brian@xyzw.org>
---
 drivers/media/video/em28xx/em28xx-cards.c |   32 +++++++++++++---------------
 drivers/media/video/em28xx/em28xx.h       |    4 +++
 2 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index 1c2e544..ffe9306 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -2170,8 +2170,6 @@ static int em28xx_hint_board(struct em28xx *dev)
 /* ----------------------------------------------------------------------- */
 void em28xx_register_i2c_ir(struct em28xx *dev)
 {
-	struct i2c_board_info info;
-	struct IR_i2c_init_data init_data;
 	const unsigned short addr_list[] = {
 		 0x30, 0x47, I2C_CLIENT_END
 	};
@@ -2179,9 +2177,9 @@ void em28xx_register_i2c_ir(struct em28xx *dev)
 	if (disable_ir)
 		return;
 
-	memset(&info, 0, sizeof(struct i2c_board_info));
-	memset(&init_data, 0, sizeof(struct IR_i2c_init_data));
-	strlcpy(info.type, "ir_video", I2C_NAME_SIZE);
+	memset(&dev->info, 0, sizeof(&dev->info));
+	memset(&dev->init_data, 0, sizeof(dev->init_data));
+	strlcpy(dev->info.type, "ir_video", I2C_NAME_SIZE);
 
 	/* detect & configure */
 	switch (dev->model) {
@@ -2191,19 +2189,19 @@ void em28xx_register_i2c_ir(struct em28xx *dev)
 		break;
 	case (EM2800_BOARD_TERRATEC_CINERGY_200):
 	case (EM2820_BOARD_TERRATEC_CINERGY_250):
-		init_data.ir_codes = ir_codes_em_terratec;
-		init_data.get_key = em28xx_get_key_terratec;
-		init_data.name = "i2c IR (EM28XX Terratec)";
+		dev->init_data.ir_codes = ir_codes_em_terratec;
+		dev->init_data.get_key = em28xx_get_key_terratec;
+		dev->init_data.name = "i2c IR (EM28XX Terratec)";
 		break;
 	case (EM2820_BOARD_PINNACLE_USB_2):
-		init_data.ir_codes = ir_codes_pinnacle_grey;
-		init_data.get_key = em28xx_get_key_pinnacle_usb_grey;
-		init_data.name = "i2c IR (EM28XX Pinnacle PCTV)";
+		dev->init_data.ir_codes = ir_codes_pinnacle_grey;
+		dev->init_data.get_key = em28xx_get_key_pinnacle_usb_grey;
+		dev->init_data.name = "i2c IR (EM28XX Pinnacle PCTV)";
 		break;
 	case (EM2820_BOARD_HAUPPAUGE_WINTV_USB_2):
-		init_data.ir_codes = ir_codes_hauppauge_new;
-		init_data.get_key = em28xx_get_key_em_haup;
-		init_data.name = "i2c IR (EM2840 Hauppauge)";
+		dev->init_data.ir_codes = ir_codes_hauppauge_new;
+		dev->init_data.get_key = em28xx_get_key_em_haup;
+		dev->init_data.name = "i2c IR (EM2840 Hauppauge)";
 		break;
 	case (EM2820_BOARD_MSI_VOX_USB_2):
 		break;
@@ -2215,9 +2213,9 @@ void em28xx_register_i2c_ir(struct em28xx *dev)
 		break;
 	}
 
-	if (init_data.name)
-		info.platform_data = &init_data;
-	i2c_new_probed_device(&dev->i2c_adap, &info, addr_list);
+	if (dev->init_data.name)
+		dev->info.platform_data = &dev->init_data;
+	i2c_new_probed_device(&dev->i2c_adap, &dev->info, addr_list);
 }
 
 void em28xx_card_setup(struct em28xx *dev)
diff --git a/drivers/media/video/em28xx/em28xx.h b/drivers/media/video/em28xx/em28xx.h
index a2add61..cb2a70a 100644
--- a/drivers/media/video/em28xx/em28xx.h
+++ b/drivers/media/video/em28xx/em28xx.h
@@ -595,6 +595,10 @@ struct em28xx {
 	struct delayed_work sbutton_query_work;
 
 	struct em28xx_dvb *dvb;
+
+	/* I2C keyboard data */
+	struct i2c_board_info info;
+	struct IR_i2c_init_data init_data;
 };
 
 struct em28xx_ops {
-- 
1.6.3.3

