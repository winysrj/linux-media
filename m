Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34230 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757218AbcB1L0k (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Feb 2016 06:26:40 -0500
From: Matthieu Rogez <matthieu.rogez@gmail.com>
To: mchehab@osg.samsung.com, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Matthieu Rogez <matthieu.rogez@gmail.com>
Subject: [PATCH 2/3] [media] em28xx: add support for Terratec Grabby Record led
Date: Sun, 28 Feb 2016 12:26:22 +0100
Message-Id: <1456658783-32345-3-git-send-email-matthieu.rogez@gmail.com>
In-Reply-To: <1456658783-32345-1-git-send-email-matthieu.rogez@gmail.com>
References: <1456658783-32345-1-git-send-email-matthieu.rogez@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Terratec Grabby (hw rev 2) Record led is connected to GPIO 3
and its logic is inverted: (PIO3 = 0: on, PIO3 = 1: off).

Signed-off-by: Matthieu Rogez <matthieu.rogez@gmail.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 4051146..5e127e4 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -560,6 +560,16 @@ static struct em28xx_led pctv_80e_leds[] = {
 	{-1, 0, 0, 0},
 };
 
+static struct em28xx_led terratec_grabby_leds[] = {
+	{
+		.role      = EM28XX_LED_ANALOG_CAPTURING,
+		.gpio_reg  = EM2820_R08_GPIO_CTRL,
+		.gpio_mask = EM_GPIO_3,
+		.inverted  = 1,
+	},
+	{-1, 0, 0, 0},
+};
+
 /*
  *  Board definitions
  */
@@ -2016,6 +2026,7 @@ struct em28xx_board em28xx_boards[] = {
 			.amux     = EM28XX_AMUX_LINE_IN,
 		} },
 		.buttons         = std_snapshot_button,
+		.leds            = terratec_grabby_leds,
 	},
 	[EM2860_BOARD_TERRATEC_AV350] = {
 		.name            = "Terratec AV350",
-- 
2.7.1

