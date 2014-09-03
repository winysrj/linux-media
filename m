Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44271 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991AbaICUd1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 16:33:27 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 09/46] [media] em28xx: use true/false for boolean vars
Date: Wed,  3 Sep 2014 17:32:41 -0300
Message-Id: <339e7a9901904bcadc6d9d25d1b628d58756adab.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using 0 or 1 for boolean, use the true/false
defines.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index ed843bd221ea..e978a2ae6f21 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -609,17 +609,17 @@ static int em28xx_register_snapshot_button(struct em28xx *dev)
 static void em28xx_init_buttons(struct em28xx *dev)
 {
 	u8  i = 0, j = 0;
-	bool addr_new = 0;
+	bool addr_new = false;
 
 	dev->button_polling_interval = EM28XX_BUTTONS_DEBOUNCED_QUERY_INTERVAL;
 	while (dev->board.buttons[i].role >= 0 &&
 			 dev->board.buttons[i].role < EM28XX_NUM_BUTTON_ROLES) {
 		struct em28xx_button *button = &dev->board.buttons[i];
 		/* Check if polling address is already on the list */
-		addr_new = 1;
+		addr_new = true;
 		for (j = 0; j < dev->num_button_polling_addresses; j++) {
 			if (button->reg_r == dev->button_polling_addresses[j]) {
-				addr_new = 0;
+				addr_new = false;
 				break;
 			}
 		}
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index f6cf99fa30b2..3642438bc7d4 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -721,7 +721,7 @@ static inline void process_frame_data_em25xx(struct em28xx *dev,
 	struct em28xx_buffer    *buf = dev->usb_ctl.vid_buf;
 	struct em28xx_dmaqueue  *dmaq = &dev->vidq;
 	struct em28xx_v4l2      *v4l2 = dev->v4l2;
-	bool frame_end = 0;
+	bool frame_end = false;
 
 	/* Check for header */
 	/* NOTE: at least with bulk transfers, only the first packet
@@ -2308,7 +2308,7 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 	v4l2->v4l2_dev.ctrl_handler = hdl;
 
 	if (dev->board.is_webcam)
-		v4l2->progressive = 1;
+		v4l2->progressive = true;
 
 	/*
 	 * Default format, used for tvp5150 or saa711x output formats
-- 
1.9.3

