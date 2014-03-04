Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57029 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552AbaCDXw0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Mar 2014 18:52:26 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] [media] em28xx: only enable PCTV 80e led when streaming
Date: Tue,  4 Mar 2014 20:51:45 -0300
Message-Id: <1393977105-2091-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of keeping the led always on, use it to indicate
when DVB is streaming.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 66d9c8798c82..2fb300e882f0 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -228,8 +228,8 @@ static struct em28xx_reg_seq terratec_cinergy_USB_XS_FR_digital[] = {
    7:   LED on, active high */
 static struct em28xx_reg_seq em2874_pctv_80e_digital[] = {
 	{EM28XX_R06_I2C_CLK,    0x45,   0xff,		  10}, /*400 KHz*/
-	{EM2874_R80_GPIO_P0_CTRL, 0x80,   0xff,		  100},/*Demod reset*/
-	{EM2874_R80_GPIO_P0_CTRL, 0xc0,   0xff,		  10},
+	{EM2874_R80_GPIO_P0_CTRL, 0x00,   0xff,		  100},/*Demod reset*/
+	{EM2874_R80_GPIO_P0_CTRL, 0x40,   0xff,		  10},
 	{  -1,			-1,	-1,		  -1},
 };
 
@@ -526,6 +526,16 @@ static struct em28xx_led kworld_ub435q_v3_leds[] = {
 	{-1, 0, 0, 0},
 };
 
+static struct em28xx_led pctv_80e_leds[] = {
+	{
+		.role      = EM28XX_LED_DIGITAL_CAPTURING,
+		.gpio_reg  = EM2874_R80_GPIO_P0_CTRL,
+		.gpio_mask = 0x80,
+		.inverted  = 0,
+	},
+	{-1, 0, 0, 0},
+};
+
 
 /*
  *  Board definitions
@@ -2179,6 +2189,7 @@ struct em28xx_board em28xx_boards[] = {
 		.dvb_gpio     = em2874_pctv_80e_digital,
 		.decoder      = EM28XX_NODECODER,
 		.ir_codes     = RC_MAP_PINNACLE_PCTV_HD,
+		.leds         = pctv_80e_leds,
 	},
 	/* 1ae7:9003/9004 SpeedLink Vicious And Devine Laplace webcam
 	 * Empia EM2765 + OmniVision OV2640 */
-- 
1.8.5.3

