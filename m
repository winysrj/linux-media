Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49381 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124AbaCCKH5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:07:57 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 42/79] [media] em28xx: add support for PCTV 80e remote controller
Date: Mon,  3 Mar 2014 07:06:36 -0300
Message-Id: <1393841233-24840-43-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This stick uses the same RC-5 remote controll found on other
PCTV devices. So, just use the existing keymap.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index ed0edfdb56b5..138659b23cbb 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -2145,6 +2145,7 @@ struct em28xx_board em28xx_boards[] = {
 		.has_dvb      = 1,
 		.dvb_gpio     = em2874_pctv_80e_digital,
 		.decoder      = EM28XX_NODECODER,
+		.ir_codes     = RC_MAP_PINNACLE_PCTV_HD,
 	},
 	/* 1ae7:9003/9004 SpeedLink Vicious And Devine Laplace webcam
 	 * Empia EM2765 + OmniVision OV2640 */
-- 
1.8.5.3

