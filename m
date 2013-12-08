Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48702 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759955Ab3LHWby (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Dec 2013 17:31:54 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH REVIEW 01/18] em28xx: add support for Empia EM28178
Date: Mon,  9 Dec 2013 00:31:18 +0200
Message-Id: <1386541895-8634-2-git-send-email-crope@iki.fi>
In-Reply-To: <1386541895-8634-1-git-send-email-crope@iki.fi>
References: <1386541895-8634-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

New chip version, which is very similar than EM28174.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 5 +++++
 drivers/media/usb/em28xx/em28xx-core.c  | 9 ++++++---
 drivers/media/usb/em28xx/em28xx-input.c | 2 ++
 drivers/media/usb/em28xx/em28xx-reg.h   | 1 +
 4 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index a519669..62332a6 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -2968,6 +2968,11 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 			dev->wait_after_write = 0;
 			dev->eeprom_addrwidth_16bit = 1;
 			break;
+		case CHIP_ID_EM28178:
+			chip_name = "em28178";
+			dev->wait_after_write = 0;
+			dev->eeprom_addrwidth_16bit = 1;
+			break;
 		case CHIP_ID_EM2883:
 			chip_name = "em2882/3";
 			dev->wait_after_write = 0;
diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index fc157af..0c5fdba 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -482,8 +482,10 @@ int em28xx_audio_setup(struct em28xx *dev)
 	int vid1, vid2, feat, cfg;
 	u32 vid;
 
-	if (dev->chip_id == CHIP_ID_EM2870 || dev->chip_id == CHIP_ID_EM2874
-		|| dev->chip_id == CHIP_ID_EM28174) {
+	if (dev->chip_id == CHIP_ID_EM2870 ||
+	    dev->chip_id == CHIP_ID_EM2874 ||
+	    dev->chip_id == CHIP_ID_EM28174 ||
+	    dev->chip_id == CHIP_ID_EM28178) {
 		/* Digital only device - don't load any alsa module */
 		dev->audio_mode.has_audio = false;
 		dev->has_audio_class = false;
@@ -606,7 +608,8 @@ int em28xx_capture_start(struct em28xx *dev, int start)
 
 	if (dev->chip_id == CHIP_ID_EM2874 ||
 	    dev->chip_id == CHIP_ID_EM2884 ||
-	    dev->chip_id == CHIP_ID_EM28174) {
+	    dev->chip_id == CHIP_ID_EM28174 ||
+	    dev->chip_id == CHIP_ID_EM28178) {
 		/* The Transport Stream Enable Register moved in em2874 */
 		if (!start) {
 			rc = em28xx_write_reg_bits(dev, EM2874_R5F_TS_ENABLE,
diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index ea181e4..d4a0a75 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -442,6 +442,7 @@ static int em28xx_ir_change_protocol(struct rc_dev *rc_dev, u64 *rc_type)
 	case CHIP_ID_EM2884:
 	case CHIP_ID_EM2874:
 	case CHIP_ID_EM28174:
+	case CHIP_ID_EM28178:
 		return em2874_ir_change_protocol(rc_dev, rc_type);
 	default:
 		printk("Unrecognized em28xx chip id 0x%02x: IR not supported\n",
@@ -633,6 +634,7 @@ static int em28xx_ir_init(struct em28xx *dev)
 		case CHIP_ID_EM2884:
 		case CHIP_ID_EM2874:
 		case CHIP_ID_EM28174:
+		case CHIP_ID_EM28178:
 			ir->get_key = em2874_polling_getkey;
 			rc->allowed_protos = RC_BIT_RC5 | RC_BIT_NEC |
 					     RC_BIT_RC6_0;
diff --git a/drivers/media/usb/em28xx/em28xx-reg.h b/drivers/media/usb/em28xx/em28xx-reg.h
index 0e04778..b769ceb 100644
--- a/drivers/media/usb/em28xx/em28xx-reg.h
+++ b/drivers/media/usb/em28xx/em28xx-reg.h
@@ -245,6 +245,7 @@ enum em28xx_chip_id {
 	CHIP_ID_EM2874 = 65,
 	CHIP_ID_EM2884 = 68,
 	CHIP_ID_EM28174 = 113,
+	CHIP_ID_EM28178 = 114,
 };
 
 /*
-- 
1.8.4.2

