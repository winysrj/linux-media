Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33664 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756977AbcB1L0k (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Feb 2016 06:26:40 -0500
From: Matthieu Rogez <matthieu.rogez@gmail.com>
To: mchehab@osg.samsung.com, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Matthieu Rogez <matthieu.rogez@gmail.com>
Subject: [PATCH 1/3] [media] em28xx: add support for Terratec Grabby REC button
Date: Sun, 28 Feb 2016 12:26:21 +0100
Message-Id: <1456658783-32345-2-git-send-email-matthieu.rogez@gmail.com>
In-Reply-To: <1456658783-32345-1-git-send-email-matthieu.rogez@gmail.com>
References: <1456658783-32345-1-git-send-email-matthieu.rogez@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Terratec Grabby (hw rev 2) REC button uses the standard snapshot button
configuration.

Signed-off-by: Matthieu Rogez <matthieu.rogez@gmail.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 1f4047b..4051146 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -2015,6 +2015,7 @@ struct em28xx_board em28xx_boards[] = {
 			.vmux     = SAA7115_SVIDEO3,
 			.amux     = EM28XX_AMUX_LINE_IN,
 		} },
+		.buttons         = std_snapshot_button,
 	},
 	[EM2860_BOARD_TERRATEC_AV350] = {
 		.name            = "Terratec AV350",
-- 
2.7.1

