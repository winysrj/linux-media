Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43703 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbcA2MOA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jan 2016 07:14:00 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] em28xx: fix tuner detection for Pixelview Prolink PlayTV USB 2.0
Date: Fri, 29 Jan 2016 10:12:53 -0200
Message-Id: <73d6eb1657ddaa8d09432551dbd90ba4455e0f93.1454069572.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The tuner is at address 0x60. This address is not probed by
default by tuner anymore, so we need to explicitly add it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index dfc83c716a0b..75aee171dd50 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -1555,6 +1555,7 @@ struct em28xx_board em28xx_boards[] = {
 		.buttons = std_snapshot_button,
 		.tda9887_conf = TDA9887_PRESENT,
 		.tuner_type   = TUNER_YMEC_TVF_5533MF,
+		.tuner_addr   = 0x60,
 		.decoder      = EM28XX_SAA711X,
 		.input        = { {
 			.type     = EM28XX_VMUX_TELEVISION,
-- 
2.5.0

