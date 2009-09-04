Return-path: <linux-media-owner@vger.kernel.org>
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:53254 "EHLO
	QMTA10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750764AbZIDRFy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Sep 2009 13:05:54 -0400
Message-ID: <4AA148F3.10700@xyzw.org>
Date: Fri, 04 Sep 2009 10:05:55 -0700
From: Brian Rogers <brian@xyzw.org>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: linux-media@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Barton C Massey <bart@cs.pdx.edu>
Subject: Fix memory corruption during IR initialization for various tuner
 cards
Content-Type: multipart/mixed;
 boundary="------------090504040808010509000506"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090504040808010509000506
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Mauro,

The attached git-formatted patch fixes a regression I just found that 
was introduced in 2.6.31-rc1. I hope it can make it into the release.

Brian


--------------090504040808010509000506
Content-Type: text/x-patch;
 name="0001-Fix-memory-corruption-during-IR-initialization-for-v.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-Fix-memory-corruption-during-IR-initialization-for-v.pa";
 filename*1="tch"

>From d238e150805a0710fa626f9a7f65816aa15b741c Mon Sep 17 00:00:00 2001
From: Brian Rogers <brian@xyzw.org>
Date: Fri, 4 Sep 2009 05:55:01 -0700
Subject: [PATCH] Fix memory corruption during IR initialization for various tuner cards

In two different places the IR_i2c_init_data structure is used to store some
data for particular cards that will later override the settings that would
otherwise be used by the ir-kbd-i2c driver in ir_probe(). The way those
settings get there is problematic: init_data is on the stack, and a pointer to
it is stored to be used after the function that sets it up returns. Not good.

init_data might be overwritten by the time ir_probe() runs. ir_probe() will
then call ir_input_init(), which proceeds to fill out the dev->keybit bit
array with a 1 in the appropriate slot for every key on the tuner's remote.

But if the keymap pointer now points to random garbage, that will be used
instead to determine where to write each 1. And since IR_KEYTAB_TYPE is u32,
it can be write millions of bits past the end of dev->keybit. Essentially
this bug writes a 1 to up to 128 random bits in memory, stopping early (and
oopsing) if or when it hits an invalid page.

To fix this, I define a static IR_i2c_init_data struct for each card that
needs one rather than creating the data on the stack. This way, I can supply a
pointer that will remain valid. Also I don't have to allocate memory just to
store information that's already known at compile time and I don't have bother
freeing it, either.

This fixes a regression caused by commit 4d7a2d6721.

Signed-off-by: Brian Rogers <brian@xyzw.org>
---
 drivers/media/video/em28xx/em28xx-cards.c   |   36 +++++++++-----
 drivers/media/video/saa7134/saa7134-input.c |   71 ++++++++++++++++++---------
 2 files changed, 70 insertions(+), 37 deletions(-)

diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index 1c2e544..be9a4e8 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -2167,11 +2167,29 @@ static int em28xx_hint_board(struct em28xx *dev)
 	return -1;
 }
 
+static struct IR_i2c_init_data init_data_em28xx_terratec = {
+	.name = "i2c IR (EM28XX Terratec)",
+	.ir_codes = ir_codes_em_terratec,
+	.get_key = em28xx_get_key_terratec,
+};
+
+static struct IR_i2c_init_data init_data_em28xx_pinnacle = {
+	.name = "i2c IR (EM28XX Pinnacle PCTV)",
+	.ir_codes = ir_codes_pinnacle_grey,
+	.get_key = em28xx_get_key_pinnacle_usb_grey,
+};
+
+static struct IR_i2c_init_data init_data_em28xx_hauppauge = {
+	.name = "i2c IR (EM2840 Hauppauge)",
+	.ir_codes = ir_codes_hauppauge_new,
+	.get_key = em28xx_get_key_em_haup,
+};
+
 /* ----------------------------------------------------------------------- */
 void em28xx_register_i2c_ir(struct em28xx *dev)
 {
 	struct i2c_board_info info;
-	struct IR_i2c_init_data init_data;
+	struct IR_i2c_init_data *init_data = NULL;
 	const unsigned short addr_list[] = {
 		 0x30, 0x47, I2C_CLIENT_END
 	};
@@ -2180,7 +2198,6 @@ void em28xx_register_i2c_ir(struct em28xx *dev)
 		return;
 
 	memset(&info, 0, sizeof(struct i2c_board_info));
-	memset(&init_data, 0, sizeof(struct IR_i2c_init_data));
 	strlcpy(info.type, "ir_video", I2C_NAME_SIZE);
 
 	/* detect & configure */
@@ -2191,19 +2208,13 @@ void em28xx_register_i2c_ir(struct em28xx *dev)
 		break;
 	case (EM2800_BOARD_TERRATEC_CINERGY_200):
 	case (EM2820_BOARD_TERRATEC_CINERGY_250):
-		init_data.ir_codes = ir_codes_em_terratec;
-		init_data.get_key = em28xx_get_key_terratec;
-		init_data.name = "i2c IR (EM28XX Terratec)";
+		init_data = &init_data_em28xx_terratec;
 		break;
 	case (EM2820_BOARD_PINNACLE_USB_2):
-		init_data.ir_codes = ir_codes_pinnacle_grey;
-		init_data.get_key = em28xx_get_key_pinnacle_usb_grey;
-		init_data.name = "i2c IR (EM28XX Pinnacle PCTV)";
+		init_data = &init_data_em28xx_pinnacle;
 		break;
 	case (EM2820_BOARD_HAUPPAUGE_WINTV_USB_2):
-		init_data.ir_codes = ir_codes_hauppauge_new;
-		init_data.get_key = em28xx_get_key_em_haup;
-		init_data.name = "i2c IR (EM2840 Hauppauge)";
+		init_data = &init_data_em28xx_hauppauge;
 		break;
 	case (EM2820_BOARD_MSI_VOX_USB_2):
 		break;
@@ -2215,8 +2226,7 @@ void em28xx_register_i2c_ir(struct em28xx *dev)
 		break;
 	}
 
-	if (init_data.name)
-		info.platform_data = &init_data;
+	info.platform_data = init_data;
 	i2c_new_probed_device(&dev->i2c_adap, &info, addr_list);
 }
 
diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index 6e219c2..bb17bb9 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -682,10 +682,46 @@ void saa7134_input_fini(struct saa7134_dev *dev)
 	dev->remote = NULL;
 }
 
+static struct IR_i2c_init_data init_data_pinnacle_color = {
+	.name = "Pinnacle PCTV",
+	.get_key = get_key_pinnacle_color,
+	.ir_codes = ir_codes_pinnacle_color,
+};
+
+static struct IR_i2c_init_data init_data_pinnacle_grey = {
+	.name = "Pinnacle PCTV",
+	.get_key = get_key_pinnacle_grey,
+	.ir_codes = ir_codes_pinnacle_grey,
+};
+
+static struct IR_i2c_init_data init_data_purpletv = {
+	.name = "Purple TV",
+	.get_key = get_key_purpletv,
+	.ir_codes = ir_codes_purpletv,
+};
+
+static struct IR_i2c_init_data init_data_msi_tvanywhere_plus = {
+	.name = "MSI TV@nywhere Plus",
+	.get_key = get_key_msi_tvanywhere_plus,
+	.ir_codes = ir_codes_msi_tvanywhere_plus,
+};
+
+static struct IR_i2c_init_data init_data_hauppauge = {
+	.name = "HVR 1110",
+	.get_key = get_key_hvr1110,
+	.ir_codes = ir_codes_hauppauge_new,
+};
+
+static struct IR_i2c_init_data init_data_behold = {
+	.name = "BeholdTV",
+	.get_key = get_key_beholdm6xx,
+	.ir_codes = ir_codes_behold,
+};
+
 void saa7134_probe_i2c_ir(struct saa7134_dev *dev)
 {
 	struct i2c_board_info info;
-	struct IR_i2c_init_data init_data;
+	struct IR_i2c_init_data *init_data = NULL;
 	const unsigned short addr_list[] = {
 		0x7a, 0x47, 0x71, 0x2d,
 		I2C_CLIENT_END
@@ -706,30 +742,22 @@ void saa7134_probe_i2c_ir(struct saa7134_dev *dev)
 	}
 
 	memset(&info, 0, sizeof(struct i2c_board_info));
-	memset(&init_data, 0, sizeof(struct IR_i2c_init_data));
 	strlcpy(info.type, "ir_video", I2C_NAME_SIZE);
 
 	switch (dev->board) {
 	case SAA7134_BOARD_PINNACLE_PCTV_110i:
 	case SAA7134_BOARD_PINNACLE_PCTV_310i:
-		init_data.name = "Pinnacle PCTV";
-		if (pinnacle_remote == 0) {
-			init_data.get_key = get_key_pinnacle_color;
-			init_data.ir_codes = ir_codes_pinnacle_color;
-		} else {
-			init_data.get_key = get_key_pinnacle_grey;
-			init_data.ir_codes = ir_codes_pinnacle_grey;
-		}
+		if (pinnacle_remote == 0)
+			init_data = &init_data_pinnacle_color;
+		else
+			init_data = &init_data_pinnacle_grey;
+		info.addr = 0x47;
 		break;
 	case SAA7134_BOARD_UPMOST_PURPLE_TV:
-		init_data.name = "Purple TV";
-		init_data.get_key = get_key_purpletv;
-		init_data.ir_codes = ir_codes_purpletv;
+		init_data = &init_data_purpletv;
 		break;
 	case SAA7134_BOARD_MSI_TVATANYWHERE_PLUS:
-		init_data.name = "MSI TV@nywhere Plus";
-		init_data.get_key = get_key_msi_tvanywhere_plus;
-		init_data.ir_codes = ir_codes_msi_tvanywhere_plus;
+		init_data = &init_data_msi_tvanywhere_plus;
 		info.addr = 0x30;
 		/* MSI TV@nywhere Plus controller doesn't seem to
 		   respond to probes unless we read something from
@@ -741,9 +769,7 @@ void saa7134_probe_i2c_ir(struct saa7134_dev *dev)
 			(1 == rc) ? "yes" : "no");
 		break;
 	case SAA7134_BOARD_HAUPPAUGE_HVR1110:
-		init_data.name = "HVR 1110";
-		init_data.get_key = get_key_hvr1110;
-		init_data.ir_codes = ir_codes_hauppauge_new;
+		init_data = &init_data_hauppauge;
 		break;
 	case SAA7134_BOARD_BEHOLD_607FM_MK3:
 	case SAA7134_BOARD_BEHOLD_607FM_MK5:
@@ -757,9 +783,7 @@ void saa7134_probe_i2c_ir(struct saa7134_dev *dev)
 	case SAA7134_BOARD_BEHOLD_M63:
 	case SAA7134_BOARD_BEHOLD_M6_EXTRA:
 	case SAA7134_BOARD_BEHOLD_H6:
-		init_data.name = "BeholdTV";
-		init_data.get_key = get_key_beholdm6xx;
-		init_data.ir_codes = ir_codes_behold;
+		init_data = &init_data_behold;
 		break;
 	case SAA7134_BOARD_AVERMEDIA_CARDBUS_501:
 	case SAA7134_BOARD_AVERMEDIA_CARDBUS_506:
@@ -767,8 +791,7 @@ void saa7134_probe_i2c_ir(struct saa7134_dev *dev)
 		break;
 	}
 
-	if (init_data.name)
-		info.platform_data = &init_data;
+	info.platform_data = init_data;
 	/* No need to probe if address is known */
 	if (info.addr) {
 		i2c_new_device(&dev->i2c_adap, &info);
-- 
1.6.3.3


--------------090504040808010509000506--
