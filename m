Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:55984 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756782AbbEVN76 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 May 2015 09:59:58 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 02/11] cobalt: fix 64-bit division link error
Date: Fri, 22 May 2015 15:59:35 +0200
Message-Id: <1432303184-8594-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1432303184-8594-1-git-send-email-hverkuil@xs4all.nl>
References: <1432303184-8594-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

[linuxtv-media:master 1023/1029] ERROR: "__aeabi_uldivmod" [drivers/media/pci/cobalt/cobalt.ko] undefined!

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: kbuild test robot <fengguang.wu@intel.com>
---
 drivers/media/pci/cobalt/cobalt-v4l2.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/pci/cobalt/cobalt-v4l2.c b/drivers/media/pci/cobalt/cobalt-v4l2.c
index bf80f11..6e8d25b 100644
--- a/drivers/media/pci/cobalt/cobalt-v4l2.c
+++ b/drivers/media/pci/cobalt/cobalt-v4l2.c
@@ -22,6 +22,7 @@
 
 #include <linux/dma-mapping.h>
 #include <linux/delay.h>
+#include <linux/math64.h>
 #include <linux/pci.h>
 #include <linux/v4l2-dv-timings.h>
 
@@ -314,8 +315,8 @@ static int cobalt_start_streaming(struct vb2_queue *q, unsigned int count)
 	cvi->frame_height = bt->height;
 	tot_size = V4L2_DV_BT_FRAME_WIDTH(bt) * V4L2_DV_BT_FRAME_HEIGHT(bt);
 	vmr->hsync_timeout_val =
-		((u64)V4L2_DV_BT_FRAME_WIDTH(bt) * COBALT_CLK * 4) /
-		bt->pixelclock;
+		div_u64((u64)V4L2_DV_BT_FRAME_WIDTH(bt) * COBALT_CLK * 4,
+			bt->pixelclock);
 	vmr->control = M00233_CONTROL_BITMAP_ENABLE_MEASURE_MSK;
 	clkloss->ref_clk_cnt_val = fw->clk_freq / 1000000;
 	/* The lower bound for the clock frequency is 0.5% lower as is
@@ -324,7 +325,7 @@ static int cobalt_start_streaming(struct vb2_queue *q, unsigned int count)
 		(((u64)bt->pixelclock * 995) / 1000) / 1000000;
 	/* will be enabled after the first frame has been received */
 	fw->active_length = bt->width * bt->height;
-	fw->total_length = ((u64)fw->clk_freq * tot_size) / bt->pixelclock;
+	fw->total_length = div_u64((u64)fw->clk_freq * tot_size, bt->pixelclock);
 	vmr->irq_triggers = M00233_IRQ_TRIGGERS_BITMAP_VACTIVE_AREA_MSK |
 		M00233_IRQ_TRIGGERS_BITMAP_HACTIVE_AREA_MSK;
 	cvi->control = 0;
-- 
2.1.4

