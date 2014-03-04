Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55047 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbaCDPiJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Mar 2014 10:38:09 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 2/2] [media] em28xx: Add LED support for Kworld UB45-Q v3
Date: Tue,  4 Mar 2014 12:37:28 -0300
Message-Id: <1393947448-1738-2-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393947448-1738-1-git-send-email-m.chehab@samsung.com>
References: <1393947448-1738-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This device has a led at bit 7 of GPIO reg. 0x80 to indicate
when a DVB capture is happening.

Add support for it.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 5cd2df14bf1a..66d9c8798c82 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -516,6 +516,17 @@ static struct em28xx_led speedlink_vad_laplace_leds[] = {
 	{-1, 0, 0, 0},
 };
 
+static struct em28xx_led kworld_ub435q_v3_leds[] = {
+	{
+		.role      = EM28XX_LED_DIGITAL_CAPTURING,
+		.gpio_reg  = EM2874_R80_GPIO_P0_CTRL,
+		.gpio_mask = 0x80,
+		.inverted  = 1,
+	},
+	{-1, 0, 0, 0},
+};
+
+
 /*
  *  Board definitions
  */
@@ -2159,6 +2170,7 @@ struct em28xx_board em28xx_boards[] = {
 		.def_i2c_bus	= 1,
 		.i2c_speed      = EM28XX_I2C_CLK_WAIT_ENABLE |
 				  EM28XX_I2C_FREQ_100_KHZ,
+		.leds = kworld_ub435q_v3_leds,
 	},
 	[EM2874_BOARD_PCTV_HD_MINI_80E] = {
 		.name         = "Pinnacle PCTV HD Mini",
-- 
1.8.5.3

