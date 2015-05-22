Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:49249 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757218AbbEVOAN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 May 2015 10:00:13 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 09/11] cobalt: fix sparse warnings
Date: Fri, 22 May 2015 15:59:42 +0200
Message-Id: <1432303184-8594-10-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1432303184-8594-1-git-send-email-hverkuil@xs4all.nl>
References: <1432303184-8594-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/pci/cobalt/cobalt-v4l2.c:189:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:191:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:192:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:193:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:194:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:195:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:196:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:197:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:198:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:199:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:201:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:202:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:203:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:234:17: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:240:17: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:246:17: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:266:17: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:267:17: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:271:28: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:275:17: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:276:17: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:312:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:313:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:314:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:315:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:317:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:320:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:321:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:321:36: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:324:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:327:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:328:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:328:41: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:329:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:331:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:332:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:334:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:335:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:336:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:362:17: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:367:17: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:368:17: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:420:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:421:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:422:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:423:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:516:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:516:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:518:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:518:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:518:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:525:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:525:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:531:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:531:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:531:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:531:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:531:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:531:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:531:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:546:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:546:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:548:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:549:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:550:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:551:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:552:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:553:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:554:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:555:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:556:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:556:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:556:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:563:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:564:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:564:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:569:9: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:595:16: warning: dereference of noderef expression
drivers/media/pci/cobalt/cobalt-v4l2.c:602:9: warning: dereference of noderef expression

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cobalt/cobalt-v4l2.c | 234 +++++++++++++++++----------------
 1 file changed, 124 insertions(+), 110 deletions(-)

diff --git a/drivers/media/pci/cobalt/cobalt-v4l2.c b/drivers/media/pci/cobalt/cobalt-v4l2.c
index 6e8d25b..8b14bec 100644
--- a/drivers/media/pci/cobalt/cobalt-v4l2.c
+++ b/drivers/media/pci/cobalt/cobalt-v4l2.c
@@ -156,7 +156,7 @@ static void cobalt_enable_output(struct cobalt_stream *s)
 {
 	struct cobalt *cobalt = s->cobalt;
 	struct v4l2_bt_timings *bt = &s->timings.bt;
-	volatile struct m00514_syncgen_flow_evcnt_regmap __iomem *vo =
+	struct m00514_syncgen_flow_evcnt_regmap __iomem *vo =
 		COBALT_TX_BASE(cobalt);
 	unsigned fmt = s->pixfmt != V4L2_PIX_FMT_BGR32 ?
 			M00514_CONTROL_BITMAP_FORMAT_16_BPP_MSK : 0;
@@ -186,30 +186,31 @@ static void cobalt_enable_output(struct cobalt_stream *s)
 	}
 	v4l2_subdev_call(s->sd, pad, set_fmt, NULL, &sd_fmt);
 
-	vo->control = 0;
+	iowrite32(0, &vo->control);
 	/* 1080p60 */
-	vo->sync_generator_h_sync_length = bt->hsync;
-	vo->sync_generator_h_backporch_length = bt->hbackporch;
-	vo->sync_generator_h_active_length = bt->width;
-	vo->sync_generator_h_frontporch_length = bt->hfrontporch;
-	vo->sync_generator_v_sync_length = bt->vsync;
-	vo->sync_generator_v_backporch_length = bt->vbackporch;
-	vo->sync_generator_v_active_length = bt->height;
-	vo->sync_generator_v_frontporch_length = bt->vfrontporch;
-	vo->error_color = 0x9900c1;
-
-	vo->control = M00514_CONTROL_BITMAP_SYNC_GENERATOR_LOAD_PARAM_MSK | fmt;
-	vo->control = M00514_CONTROL_BITMAP_EVCNT_CLEAR_MSK | fmt;
-	vo->control = M00514_CONTROL_BITMAP_SYNC_GENERATOR_ENABLE_MSK |
-		      M00514_CONTROL_BITMAP_FLOW_CTRL_OUTPUT_ENABLE_MSK |
-		      fmt;
+	iowrite32(bt->hsync, &vo->sync_generator_h_sync_length);
+	iowrite32(bt->hbackporch, &vo->sync_generator_h_backporch_length);
+	iowrite32(bt->width, &vo->sync_generator_h_active_length);
+	iowrite32(bt->hfrontporch, &vo->sync_generator_h_frontporch_length);
+	iowrite32(bt->vsync, &vo->sync_generator_v_sync_length);
+	iowrite32(bt->vbackporch, &vo->sync_generator_v_backporch_length);
+	iowrite32(bt->height, &vo->sync_generator_v_active_length);
+	iowrite32(bt->vfrontporch, &vo->sync_generator_v_frontporch_length);
+	iowrite32(0x9900c1, &vo->error_color);
+
+	iowrite32(M00514_CONTROL_BITMAP_SYNC_GENERATOR_LOAD_PARAM_MSK | fmt,
+		  &vo->control);
+	iowrite32(M00514_CONTROL_BITMAP_EVCNT_CLEAR_MSK | fmt, &vo->control);
+	iowrite32(M00514_CONTROL_BITMAP_SYNC_GENERATOR_ENABLE_MSK |
+		  M00514_CONTROL_BITMAP_FLOW_CTRL_OUTPUT_ENABLE_MSK |
+		  fmt, &vo->control);
 }
 
 static void cobalt_enable_input(struct cobalt_stream *s)
 {
 	struct cobalt *cobalt = s->cobalt;
 	int ch = (int)s->video_channel;
-	volatile struct m00235_fdma_packer_regmap __iomem *packer;
+	struct m00235_fdma_packer_regmap __iomem *packer;
 	struct v4l2_subdev_format sd_fmt_yuyv = {
 		.pad = s->pad_source,
 		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
@@ -231,21 +232,24 @@ static void cobalt_enable_input(struct cobalt_stream *s)
 	/* Set up FDMA packer */
 	switch (s->pixfmt) {
 	case V4L2_PIX_FMT_YUYV:
-		packer->control = M00235_CONTROL_BITMAP_ENABLE_MSK |
-			(1 << M00235_CONTROL_BITMAP_PACK_FORMAT_OFST);
+		iowrite32(M00235_CONTROL_BITMAP_ENABLE_MSK |
+			  (1 << M00235_CONTROL_BITMAP_PACK_FORMAT_OFST),
+			  &packer->control);
 		v4l2_subdev_call(s->sd, pad, set_fmt, NULL,
 				 &sd_fmt_yuyv);
 		break;
 	case V4L2_PIX_FMT_RGB24:
-		packer->control = M00235_CONTROL_BITMAP_ENABLE_MSK |
-			(2 << M00235_CONTROL_BITMAP_PACK_FORMAT_OFST);
+		iowrite32(M00235_CONTROL_BITMAP_ENABLE_MSK |
+			  (2 << M00235_CONTROL_BITMAP_PACK_FORMAT_OFST),
+			  &packer->control);
 		v4l2_subdev_call(s->sd, pad, set_fmt, NULL,
 				 &sd_fmt_rgb);
 		break;
 	case V4L2_PIX_FMT_BGR32:
-		packer->control = M00235_CONTROL_BITMAP_ENABLE_MSK |
-			M00235_CONTROL_BITMAP_ENDIAN_FORMAT_MSK |
-			(3 << M00235_CONTROL_BITMAP_PACK_FORMAT_OFST);
+		iowrite32(M00235_CONTROL_BITMAP_ENABLE_MSK |
+			  M00235_CONTROL_BITMAP_ENDIAN_FORMAT_MSK |
+			  (3 << M00235_CONTROL_BITMAP_PACK_FORMAT_OFST),
+			  &packer->control);
 		v4l2_subdev_call(s->sd, pad, set_fmt, NULL,
 				 &sd_fmt_rgb);
 		break;
@@ -256,24 +260,26 @@ static void cobalt_dma_start_streaming(struct cobalt_stream *s)
 {
 	struct cobalt *cobalt = s->cobalt;
 	int rx = s->video_channel;
-	volatile struct m00460_evcnt_regmap __iomem *evcnt =
+	struct m00460_evcnt_regmap __iomem *evcnt =
 		COBALT_CVI_EVCNT(cobalt, rx);
 	struct cobalt_buffer *cb;
 	unsigned long flags;
 
 	spin_lock_irqsave(&s->irqlock, flags);
 	if (!s->is_output) {
-		evcnt->control = M00460_CONTROL_BITMAP_CLEAR_MSK;
-		evcnt->control = M00460_CONTROL_BITMAP_ENABLE_MSK;
+		iowrite32(M00460_CONTROL_BITMAP_CLEAR_MSK, &evcnt->control);
+		iowrite32(M00460_CONTROL_BITMAP_ENABLE_MSK, &evcnt->control);
 	} else {
-		volatile struct m00514_syncgen_flow_evcnt_regmap __iomem *vo =
+		struct m00514_syncgen_flow_evcnt_regmap __iomem *vo =
 			COBALT_TX_BASE(cobalt);
-		u32 ctrl = vo->control;
+		u32 ctrl = ioread32(&vo->control);
 
 		ctrl &= ~(M00514_CONTROL_BITMAP_EVCNT_ENABLE_MSK |
 			  M00514_CONTROL_BITMAP_EVCNT_CLEAR_MSK);
-		vo->control = ctrl | M00514_CONTROL_BITMAP_EVCNT_CLEAR_MSK;
-		vo->control = ctrl | M00514_CONTROL_BITMAP_EVCNT_ENABLE_MSK;
+		iowrite32(ctrl | M00514_CONTROL_BITMAP_EVCNT_CLEAR_MSK,
+			  &vo->control);
+		iowrite32(ctrl | M00514_CONTROL_BITMAP_EVCNT_ENABLE_MSK,
+			  &vo->control);
 	}
 	cb = list_first_entry(&s->bufs, struct cobalt_buffer, list);
 	omni_sg_dma_start(s, &s->dma_desc_info[cb->vb.v4l2_buf.index]);
@@ -284,16 +290,15 @@ static int cobalt_start_streaming(struct vb2_queue *q, unsigned int count)
 {
 	struct cobalt_stream *s = q->drv_priv;
 	struct cobalt *cobalt = s->cobalt;
-	volatile struct m00233_video_measure_regmap __iomem *vmr;
-	volatile struct m00473_freewheel_regmap __iomem *fw;
-	volatile struct m00479_clk_loss_detector_regmap __iomem *clkloss;
+	struct m00233_video_measure_regmap __iomem *vmr;
+	struct m00473_freewheel_regmap __iomem *fw;
+	struct m00479_clk_loss_detector_regmap __iomem *clkloss;
 	int rx = s->video_channel;
-	volatile struct m00389_cvi_regmap __iomem *cvi =
-		COBALT_CVI(cobalt, rx);
-	volatile struct m00460_evcnt_regmap __iomem *evcnt =
-		COBALT_CVI_EVCNT(cobalt, rx);
+	struct m00389_cvi_regmap __iomem *cvi = COBALT_CVI(cobalt, rx);
+	struct m00460_evcnt_regmap __iomem *evcnt = COBALT_CVI_EVCNT(cobalt, rx);
 	struct v4l2_bt_timings *bt = &s->timings.bt;
 	u64 tot_size;
+	u32 clk_freq;
 
 	if (s->is_audio)
 		goto done;
@@ -309,32 +314,34 @@ static int cobalt_start_streaming(struct vb2_queue *q, unsigned int count)
 	vmr = COBALT_CVI_VMR(cobalt, rx);
 	clkloss = COBALT_CVI_CLK_LOSS(cobalt, rx);
 
-	evcnt->control = M00460_CONTROL_BITMAP_CLEAR_MSK;
-	evcnt->control = M00460_CONTROL_BITMAP_ENABLE_MSK;
-	cvi->frame_width = bt->width;
-	cvi->frame_height = bt->height;
+	iowrite32(M00460_CONTROL_BITMAP_CLEAR_MSK, &evcnt->control);
+	iowrite32(M00460_CONTROL_BITMAP_ENABLE_MSK, &evcnt->control);
+	iowrite32(bt->width, &cvi->frame_width);
+	iowrite32(bt->height, &cvi->frame_height);
 	tot_size = V4L2_DV_BT_FRAME_WIDTH(bt) * V4L2_DV_BT_FRAME_HEIGHT(bt);
-	vmr->hsync_timeout_val =
-		div_u64((u64)V4L2_DV_BT_FRAME_WIDTH(bt) * COBALT_CLK * 4,
-			bt->pixelclock);
-	vmr->control = M00233_CONTROL_BITMAP_ENABLE_MEASURE_MSK;
-	clkloss->ref_clk_cnt_val = fw->clk_freq / 1000000;
+	iowrite32(div_u64((u64)V4L2_DV_BT_FRAME_WIDTH(bt) * COBALT_CLK * 4,
+			  bt->pixelclock), &vmr->hsync_timeout_val);
+	iowrite32(M00233_CONTROL_BITMAP_ENABLE_MEASURE_MSK, &vmr->control);
+	clk_freq = ioread32(&fw->clk_freq);
+	iowrite32(clk_freq / 1000000, &clkloss->ref_clk_cnt_val);
 	/* The lower bound for the clock frequency is 0.5% lower as is
 	 * allowed by the spec */
-	clkloss->test_clk_cnt_val =
-		(((u64)bt->pixelclock * 995) / 1000) / 1000000;
+	iowrite32((((u64)bt->pixelclock * 995) / 1000) / 1000000,
+		  &clkloss->test_clk_cnt_val);
 	/* will be enabled after the first frame has been received */
-	fw->active_length = bt->width * bt->height;
-	fw->total_length = div_u64((u64)fw->clk_freq * tot_size, bt->pixelclock);
-	vmr->irq_triggers = M00233_IRQ_TRIGGERS_BITMAP_VACTIVE_AREA_MSK |
-		M00233_IRQ_TRIGGERS_BITMAP_HACTIVE_AREA_MSK;
-	cvi->control = 0;
-	vmr->control = M00233_CONTROL_BITMAP_ENABLE_MEASURE_MSK;
-
-	fw->output_color = 0xff;
-	clkloss->ctrl = M00479_CTRL_BITMAP_ENABLE_MSK;
-	fw->ctrl = M00473_CTRL_BITMAP_ENABLE_MSK |
-		   M00473_CTRL_BITMAP_FORCE_FREEWHEEL_MODE_MSK;
+	iowrite32(bt->width * bt->height, &fw->active_length);
+	iowrite32(div_u64((u64)clk_freq * tot_size, bt->pixelclock),
+		  &fw->total_length);
+	iowrite32(M00233_IRQ_TRIGGERS_BITMAP_VACTIVE_AREA_MSK |
+		  M00233_IRQ_TRIGGERS_BITMAP_HACTIVE_AREA_MSK,
+		  &vmr->irq_triggers);
+	iowrite32(0, &cvi->control);
+	iowrite32(M00233_CONTROL_BITMAP_ENABLE_MEASURE_MSK, &vmr->control);
+
+	iowrite32(0xff, &fw->output_color);
+	iowrite32(M00479_CTRL_BITMAP_ENABLE_MSK, &clkloss->ctrl);
+	iowrite32(M00473_CTRL_BITMAP_ENABLE_MSK |
+		  M00473_CTRL_BITMAP_FORCE_FREEWHEEL_MODE_MSK, &fw->ctrl);
 	s->unstable_frame = true;
 	s->enable_freewheel = false;
 	s->enable_cvi = false;
@@ -355,17 +362,17 @@ static void cobalt_dma_stop_streaming(struct cobalt_stream *s)
 	unsigned long flags;
 	int timeout_msec = 100;
 	int rx = s->video_channel;
-	volatile struct m00460_evcnt_regmap __iomem *evcnt =
+	struct m00460_evcnt_regmap __iomem *evcnt =
 		COBALT_CVI_EVCNT(cobalt, rx);
 
 	if (!s->is_output) {
-		evcnt->control = 0;
+		iowrite32(0, &evcnt->control);
 	} else if (!s->is_audio) {
-		volatile struct m00514_syncgen_flow_evcnt_regmap __iomem *vo =
+		struct m00514_syncgen_flow_evcnt_regmap __iomem *vo =
 			COBALT_TX_BASE(cobalt);
 
-		vo->control = M00514_CONTROL_BITMAP_EVCNT_CLEAR_MSK;
-		vo->control = 0;
+		iowrite32(M00514_CONTROL_BITMAP_EVCNT_CLEAR_MSK, &vo->control);
+		iowrite32(0, &vo->control);
 	}
 
 	/* Try to stop the DMA engine gracefully */
@@ -393,9 +400,9 @@ static void cobalt_stop_streaming(struct vb2_queue *q)
 	struct cobalt_stream *s = q->drv_priv;
 	struct cobalt *cobalt = s->cobalt;
 	int rx = s->video_channel;
-	volatile struct m00233_video_measure_regmap __iomem *vmr;
-	volatile struct m00473_freewheel_regmap __iomem *fw;
-	volatile struct m00479_clk_loss_detector_regmap __iomem *clkloss;
+	struct m00233_video_measure_regmap __iomem *vmr;
+	struct m00473_freewheel_regmap __iomem *fw;
+	struct m00479_clk_loss_detector_regmap __iomem *clkloss;
 	struct cobalt_buffer *cb;
 	struct list_head *p, *safe;
 	unsigned long flags;
@@ -417,10 +424,10 @@ static void cobalt_stop_streaming(struct vb2_queue *q)
 	fw = COBALT_CVI_FREEWHEEL(cobalt, rx);
 	vmr = COBALT_CVI_VMR(cobalt, rx);
 	clkloss = COBALT_CVI_CLK_LOSS(cobalt, rx);
-	vmr->control = 0;
-	vmr->control = M00233_CONTROL_BITMAP_ENABLE_MEASURE_MSK;
-	fw->ctrl = 0;
-	clkloss->ctrl = 0;
+	iowrite32(0, &vmr->control);
+	iowrite32(M00233_CONTROL_BITMAP_ENABLE_MEASURE_MSK, &vmr->control);
+	iowrite32(0, &fw->ctrl);
+	iowrite32(0, &clkloss->ctrl);
 }
 
 static const struct vb2_ops cobalt_qops = {
@@ -500,80 +507,87 @@ static int cobalt_querycap(struct file *file, void *priv_fh,
 
 static void cobalt_video_input_status_show(struct cobalt_stream *s)
 {
-	volatile struct m00389_cvi_regmap __iomem *cvi;
-	volatile struct m00233_video_measure_regmap __iomem *vmr;
-	volatile struct m00473_freewheel_regmap __iomem *fw;
-	volatile struct m00479_clk_loss_detector_regmap __iomem *clkloss;
-	volatile struct m00235_fdma_packer_regmap __iomem *packer;
+	struct m00389_cvi_regmap __iomem *cvi;
+	struct m00233_video_measure_regmap __iomem *vmr;
+	struct m00473_freewheel_regmap __iomem *fw;
+	struct m00479_clk_loss_detector_regmap __iomem *clkloss;
+	struct m00235_fdma_packer_regmap __iomem *packer;
 	int rx = s->video_channel;
 	struct cobalt *cobalt = s->cobalt;
+	u32 cvi_ctrl, cvi_stat;
+	u32 vmr_ctrl, vmr_stat;
 
 	cvi = COBALT_CVI(cobalt, rx);
 	vmr = COBALT_CVI_VMR(cobalt, rx);
 	fw = COBALT_CVI_FREEWHEEL(cobalt, rx);
 	clkloss = COBALT_CVI_CLK_LOSS(cobalt, rx);
 	packer = COBALT_CVI_PACKER(cobalt, rx);
+	cvi_ctrl = ioread32(&cvi->control);
+	cvi_stat = ioread32(&cvi->status);
+	vmr_ctrl = ioread32(&vmr->control);
+	vmr_stat = ioread32(&vmr->control);
 	cobalt_info("rx%d: cvi resolution: %dx%d\n", rx,
-			cvi->frame_width, cvi->frame_height);
+		    ioread32(&cvi->frame_width), ioread32(&cvi->frame_height));
 	cobalt_info("rx%d: cvi control: %s%s%s\n", rx,
-		(cvi->control & M00389_CONTROL_BITMAP_ENABLE_MSK) ?
+		(cvi_ctrl & M00389_CONTROL_BITMAP_ENABLE_MSK) ?
 			"enable " : "disable ",
-		(cvi->control & M00389_CONTROL_BITMAP_HSYNC_POLARITY_LOW_MSK) ?
+		(cvi_ctrl & M00389_CONTROL_BITMAP_HSYNC_POLARITY_LOW_MSK) ?
 			"HSync- " : "HSync+ ",
-		(cvi->control & M00389_CONTROL_BITMAP_VSYNC_POLARITY_LOW_MSK) ?
+		(cvi_ctrl & M00389_CONTROL_BITMAP_VSYNC_POLARITY_LOW_MSK) ?
 			"VSync- " : "VSync+ ");
 	cobalt_info("rx%d: cvi status: %s%s\n", rx,
-		(cvi->status & M00389_STATUS_BITMAP_LOCK_MSK) ?
+		(cvi_stat & M00389_STATUS_BITMAP_LOCK_MSK) ?
 			"lock " : "no-lock ",
-		(cvi->status & M00389_STATUS_BITMAP_ERROR_MSK) ?
+		(cvi_stat & M00389_STATUS_BITMAP_ERROR_MSK) ?
 			"error " : "no-error ");
 
 	cobalt_info("rx%d: Measurements: %s%s%s%s%s%s%s\n", rx,
-		(vmr->control & M00233_CONTROL_BITMAP_HSYNC_POLARITY_LOW_MSK) ?
+		(vmr_ctrl & M00233_CONTROL_BITMAP_HSYNC_POLARITY_LOW_MSK) ?
 			"HSync- " : "HSync+ ",
-		(vmr->control & M00233_CONTROL_BITMAP_VSYNC_POLARITY_LOW_MSK) ?
+		(vmr_ctrl & M00233_CONTROL_BITMAP_VSYNC_POLARITY_LOW_MSK) ?
 			"VSync- " : "VSync+ ",
-		(vmr->control & M00233_CONTROL_BITMAP_ENABLE_MEASURE_MSK) ?
+		(vmr_ctrl & M00233_CONTROL_BITMAP_ENABLE_MEASURE_MSK) ?
 			"enabled " : "disabled ",
-		(vmr->control & M00233_CONTROL_BITMAP_ENABLE_INTERRUPT_MSK) ?
+		(vmr_ctrl & M00233_CONTROL_BITMAP_ENABLE_INTERRUPT_MSK) ?
 			"irq-enabled " : "irq-disabled ",
-		(vmr->control & M00233_CONTROL_BITMAP_UPDATE_ON_HSYNC_MSK) ?
+		(vmr_ctrl & M00233_CONTROL_BITMAP_UPDATE_ON_HSYNC_MSK) ?
 			"update-on-hsync " : "",
-		(vmr->status & M00233_STATUS_BITMAP_HSYNC_TIMEOUT_MSK) ?
+		(vmr_stat & M00233_STATUS_BITMAP_HSYNC_TIMEOUT_MSK) ?
 			"hsync-timeout " : "",
-		(vmr->status & M00233_STATUS_BITMAP_INIT_DONE_MSK) ?
+		(vmr_stat & M00233_STATUS_BITMAP_INIT_DONE_MSK) ?
 			"init-done" : "");
 	cobalt_info("rx%d: irq_status: 0x%02x irq_triggers: 0x%02x\n", rx,
-			vmr->irq_status & 0xff, vmr->irq_triggers & 0xff);
-	cobalt_info("rx%d: vsync: %d\n", rx, vmr->vsync_time);
-	cobalt_info("rx%d: vbp: %d\n", rx, vmr->vback_porch);
-	cobalt_info("rx%d: vact: %d\n", rx, vmr->vactive_area);
-	cobalt_info("rx%d: vfb: %d\n", rx, vmr->vfront_porch);
-	cobalt_info("rx%d: hsync: %d\n", rx, vmr->hsync_time);
-	cobalt_info("rx%d: hbp: %d\n", rx, vmr->hback_porch);
-	cobalt_info("rx%d: hact: %d\n", rx, vmr->hactive_area);
-	cobalt_info("rx%d: hfb: %d\n", rx, vmr->hfront_porch);
+			ioread32(&vmr->irq_status) & 0xff,
+			ioread32(&vmr->irq_triggers) & 0xff);
+	cobalt_info("rx%d: vsync: %d\n", rx, ioread32(&vmr->vsync_time));
+	cobalt_info("rx%d: vbp: %d\n", rx, ioread32(&vmr->vback_porch));
+	cobalt_info("rx%d: vact: %d\n", rx, ioread32(&vmr->vactive_area));
+	cobalt_info("rx%d: vfb: %d\n", rx, ioread32(&vmr->vfront_porch));
+	cobalt_info("rx%d: hsync: %d\n", rx, ioread32(&vmr->hsync_time));
+	cobalt_info("rx%d: hbp: %d\n", rx, ioread32(&vmr->hback_porch));
+	cobalt_info("rx%d: hact: %d\n", rx, ioread32(&vmr->hactive_area));
+	cobalt_info("rx%d: hfb: %d\n", rx, ioread32(&vmr->hfront_porch));
 	cobalt_info("rx%d: Freewheeling: %s%s%s\n", rx,
-		(fw->ctrl & M00473_CTRL_BITMAP_ENABLE_MSK) ?
+		(ioread32(&fw->ctrl) & M00473_CTRL_BITMAP_ENABLE_MSK) ?
 			"enabled " : "disabled ",
-		(fw->ctrl & M00473_CTRL_BITMAP_FORCE_FREEWHEEL_MODE_MSK) ?
+		(ioread32(&fw->ctrl) & M00473_CTRL_BITMAP_FORCE_FREEWHEEL_MODE_MSK) ?
 			"forced " : "",
-		(fw->status & M00473_STATUS_BITMAP_FREEWHEEL_MODE_MSK) ?
+		(ioread32(&fw->status) & M00473_STATUS_BITMAP_FREEWHEEL_MODE_MSK) ?
 			"freewheeling " : "video-passthrough ");
-	vmr->irq_status = 0xff;
+	iowrite32(0xff, &vmr->irq_status);
 	cobalt_info("rx%d: Clock Loss Detection: %s%s\n", rx,
-		(clkloss->ctrl & M00479_CTRL_BITMAP_ENABLE_MSK) ?
+		(ioread32(&clkloss->ctrl) & M00479_CTRL_BITMAP_ENABLE_MSK) ?
 			"enabled " : "disabled ",
-		(clkloss->status & M00479_STATUS_BITMAP_CLOCK_MISSING_MSK) ?
+		(ioread32(&clkloss->status) & M00479_STATUS_BITMAP_CLOCK_MISSING_MSK) ?
 			"clock-missing " : "found-clock ");
-	cobalt_info("rx%d: Packer: %x\n", rx, packer->control);
+	cobalt_info("rx%d: Packer: %x\n", rx, ioread32(&packer->control));
 }
 
 static int cobalt_log_status(struct file *file, void *priv_fh)
 {
 	struct cobalt_stream *s = video_drvdata(file);
 	struct cobalt *cobalt = s->cobalt;
-	volatile struct m00514_syncgen_flow_evcnt_regmap __iomem *vo =
+	struct m00514_syncgen_flow_evcnt_regmap __iomem *vo =
 		COBALT_TX_BASE(cobalt);
 	u8 stat;
 
@@ -592,14 +606,14 @@ static int cobalt_log_status(struct file *file, void *priv_fh)
 		return 0;
 	}
 
-	stat = vo->rd_status;
+	stat = ioread32(&vo->rd_status);
 
 	cobalt_info("tx: status: %s%s\n",
 		(stat & M00514_RD_STATUS_BITMAP_FLOW_CTRL_NO_DATA_ERROR_MSK) ?
 			"no_data " : "",
 		(stat & M00514_RD_STATUS_BITMAP_READY_BUFFER_FULL_MSK) ?
 			"ready_buffer_full " : "");
-	cobalt_info("tx: evcnt: %d\n", vo->rd_evcnt_count);
+	cobalt_info("tx: evcnt: %d\n", ioread32(&vo->rd_evcnt_count));
 	return 0;
 }
 
-- 
2.1.4

