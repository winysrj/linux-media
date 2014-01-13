Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52126 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094AbaAMQkH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jan 2014 11:40:07 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: [PATCH 1/2] [media] sh_vou: comment unused vars
Date: Mon, 13 Jan 2014 11:36:20 -0200
Message-Id: <1389620181-22601-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix two warns below, by commenting the unused code:

drivers/media/platform/sh_vou.c: In function 'sh_vou_configure_geometry':
drivers/media/platform/sh_vou.c:446:49: warning: variable 'height_max' set but not used [-Wunused-but-set-variable]
  unsigned int black_left, black_top, width_max, height_max,
                                                 ^
drivers/media/platform/sh_vou.c: In function 'sh_vou_isr':
drivers/media/platform/sh_vou.c:1056:13: warning: variable 'side' set but not used [-Wunused-but-set-variable]
  static int side;
             ^

Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/platform/sh_vou.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index 65c9f180a309..e5f1d4c14f2c 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -443,7 +443,7 @@ static void sh_vou_configure_geometry(struct sh_vou_device *vou_dev,
 				      int pix_idx, int w_idx, int h_idx)
 {
 	struct sh_vou_fmt *fmt = vou_fmt + pix_idx;
-	unsigned int black_left, black_top, width_max, height_max,
+	unsigned int black_left, black_top, width_max,
 		frame_in_height, frame_out_height, frame_out_top;
 	struct v4l2_rect *rect = &vou_dev->rect;
 	struct v4l2_pix_format *pix = &vou_dev->pix;
@@ -451,10 +451,10 @@ static void sh_vou_configure_geometry(struct sh_vou_device *vou_dev,
 
 	if (vou_dev->std & V4L2_STD_525_60) {
 		width_max = 858;
-		height_max = 262;
+		/* height_max = 262; */
 	} else {
 		width_max = 864;
-		height_max = 312;
+		/* height_max = 312; */
 	}
 
 	frame_in_height = pix->height / 2;
@@ -1053,7 +1053,6 @@ static irqreturn_t sh_vou_isr(int irq, void *dev_id)
 	static unsigned long j;
 	struct videobuf_buffer *vb;
 	static int cnt;
-	static int side;
 	u32 irq_status = sh_vou_reg_a_read(vou_dev, VOUIR), masked;
 	u32 vou_status = sh_vou_reg_a_read(vou_dev, VOUSTR);
 
@@ -1081,7 +1080,7 @@ static irqreturn_t sh_vou_isr(int irq, void *dev_id)
 		irq_status, masked, vou_status, cnt);
 
 	cnt++;
-	side = vou_status & 0x10000;
+	/* side = vou_status & 0x10000; */
 
 	/* Clear only set interrupts */
 	sh_vou_reg_a_write(vou_dev, VOUIR, masked);
-- 
1.8.3.1

