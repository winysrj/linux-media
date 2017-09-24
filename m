Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:58657 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752624AbdIXSGS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Sep 2017 14:06:18 -0400
Subject: [PATCH 2/4] [media] omap3isp: Adjust 53 checks for null pointers
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <692bab24-7990-c971-b577-b2dea4176e64@users.sourceforge.net>
Message-ID: <9f9c3c08-ab8a-5a9e-4402-6b7dd9ddb30a@users.sourceforge.net>
Date: Sun, 24 Sep 2017 20:06:11 +0200
MIME-Version: 1.0
In-Reply-To: <692bab24-7990-c971-b577-b2dea4176e64@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 24 Sep 2017 18:56:33 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The script “checkpatch.pl” pointed information out like the following.

Comparison to NULL could be written …

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/platform/omap3isp/isp.c        | 16 ++++++++--------
 drivers/media/platform/omap3isp/ispccdc.c    | 28 ++++++++++++++--------------
 drivers/media/platform/omap3isp/ispccp2.c    |  6 +++---
 drivers/media/platform/omap3isp/ispcsi2.c    |  6 +++---
 drivers/media/platform/omap3isp/ispcsiphy.c  |  2 +-
 drivers/media/platform/omap3isp/isph3a_af.c  |  2 +-
 drivers/media/platform/omap3isp/isphist.c    |  4 ++--
 drivers/media/platform/omap3isp/isppreview.c |  8 ++++----
 drivers/media/platform/omap3isp/ispresizer.c |  8 ++++----
 drivers/media/platform/omap3isp/ispstat.c    |  4 ++--
 drivers/media/platform/omap3isp/ispvideo.c   | 22 +++++++++++-----------
 11 files changed, 53 insertions(+), 53 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 874b883ac83a..2ebff06bb523 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -552,25 +552,25 @@ static void isp_isr_sbl(struct isp_device *isp)
 
 	if (sbl_pcr & ISPSBL_PCR_CSIB_WBL_OVF) {
 		pipe = to_isp_pipeline(&isp->isp_ccp2.subdev.entity);
-		if (pipe != NULL)
+		if (pipe)
 			pipe->error = true;
 	}
 
 	if (sbl_pcr & ISPSBL_PCR_CSIA_WBL_OVF) {
 		pipe = to_isp_pipeline(&isp->isp_csi2a.subdev.entity);
-		if (pipe != NULL)
+		if (pipe)
 			pipe->error = true;
 	}
 
 	if (sbl_pcr & ISPSBL_PCR_CCDC_WBL_OVF) {
 		pipe = to_isp_pipeline(&isp->isp_ccdc.subdev.entity);
-		if (pipe != NULL)
+		if (pipe)
 			pipe->error = true;
 	}
 
 	if (sbl_pcr & ISPSBL_PCR_PRV_WBL_OVF) {
 		pipe = to_isp_pipeline(&isp->isp_prev.subdev.entity);
-		if (pipe != NULL)
+		if (pipe)
 			pipe->error = true;
 	}
 
@@ -579,7 +579,7 @@ static void isp_isr_sbl(struct isp_device *isp)
 		       | ISPSBL_PCR_RSZ3_WBL_OVF
 		       | ISPSBL_PCR_RSZ4_WBL_OVF)) {
 		pipe = to_isp_pipeline(&isp->isp_res.subdev.entity);
-		if (pipe != NULL)
+		if (pipe)
 			pipe->error = true;
 	}
 
@@ -1401,7 +1401,7 @@ static struct isp_device *__omap3isp_get(struct isp_device *isp, bool irq)
 {
 	struct isp_device *__isp = isp;
 
-	if (isp == NULL)
+	if (!isp)
 		return NULL;
 
 	mutex_lock(&isp->isp_mutex);
@@ -1421,7 +1421,7 @@ static struct isp_device *__omap3isp_get(struct isp_device *isp, bool irq)
 		isp_enable_interrupts(isp);
 
 out:
-	if (__isp != NULL)
+	if (__isp)
 		isp->ref_count++;
 	mutex_unlock(&isp->isp_mutex);
 
@@ -1441,7 +1441,7 @@ struct isp_device *omap3isp_get(struct isp_device *isp)
  */
 static void __omap3isp_put(struct isp_device *isp, bool save_ctx)
 {
-	if (isp == NULL)
+	if (!isp)
 		return;
 
 	mutex_lock(&isp->isp_mutex);
diff --git a/drivers/media/platform/omap3isp/ispccdc.c b/drivers/media/platform/omap3isp/ispccdc.c
index b66276ab5765..579d3b406344 100644
--- a/drivers/media/platform/omap3isp/ispccdc.c
+++ b/drivers/media/platform/omap3isp/ispccdc.c
@@ -355,7 +355,7 @@ static void ccdc_lsc_free_request(struct isp_ccdc_device *ccdc,
 {
 	struct isp_device *isp = to_isp_device(ccdc);
 
-	if (req == NULL)
+	if (!req)
 		return;
 
 	if (req->table.addr) {
@@ -423,7 +423,7 @@ static int ccdc_lsc_config(struct isp_ccdc_device *ccdc,
 	}
 
 	req = kzalloc(sizeof(*req), GFP_KERNEL);
-	if (req == NULL)
+	if (!req)
 		return -ENOMEM;
 
 	if (config->flag & OMAP3ISP_CCDC_CONFIG_LSC) {
@@ -438,7 +438,7 @@ static int ccdc_lsc_config(struct isp_ccdc_device *ccdc,
 		req->table.addr = dma_alloc_coherent(isp->dev, req->config.size,
 						     &req->table.dma,
 						     GFP_KERNEL);
-		if (req->table.addr == NULL) {
+		if (!req->table.addr) {
 			ret = -ENOMEM;
 			goto done;
 		}
@@ -731,7 +731,7 @@ static int ccdc_config(struct isp_ccdc_device *ccdc,
 			fpc_new.addr = dma_alloc_coherent(isp->dev, size,
 							  &fpc_new.dma,
 							  GFP_KERNEL);
-			if (fpc_new.addr == NULL)
+			if (!fpc_new.addr)
 				return -ENOMEM;
 
 			if (copy_from_user(fpc_new.addr,
@@ -748,7 +748,7 @@ static int ccdc_config(struct isp_ccdc_device *ccdc,
 
 		ccdc_configure_fpc(ccdc);
 
-		if (fpc_old.addr != NULL)
+		if (fpc_old.addr)
 			dma_free_coherent(isp->dev, fpc_old.fpnum * 4,
 					  fpc_old.addr, fpc_old.dma);
 	}
@@ -941,7 +941,7 @@ void omap3isp_ccdc_max_rate(struct isp_ccdc_device *ccdc,
 	struct isp_pipeline *pipe = to_isp_pipeline(&ccdc->subdev.entity);
 	unsigned int rate;
 
-	if (pipe == NULL)
+	if (!pipe)
 		return;
 
 	/*
@@ -1287,7 +1287,7 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 
 	/* Lens shading correction. */
 	spin_lock_irqsave(&ccdc->lsc.req_lock, flags);
-	if (ccdc->lsc.request == NULL)
+	if (!ccdc->lsc.request)
 		goto unlock;
 
 	WARN_ON(ccdc->lsc.active);
@@ -1295,7 +1295,7 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 	/* Get last good LSC configuration. If it is not supported for
 	 * the current active resolution discard it.
 	 */
-	if (ccdc->lsc.active == NULL &&
+	if (!ccdc->lsc.active &&
 	    __ccdc_lsc_configure(ccdc, ccdc->lsc.request) == 0) {
 		ccdc->lsc.active = ccdc->lsc.request;
 	} else {
@@ -1521,7 +1521,7 @@ static void ccdc_lsc_isr(struct isp_ccdc_device *ccdc, u32 events)
 	/* The LSC engine is stopped at this point. Enable it if there's a
 	 * pending request.
 	 */
-	if (ccdc->lsc.request == NULL)
+	if (!ccdc->lsc.request)
 		goto done;
 
 	ccdc_lsc_enable(ccdc);
@@ -1614,7 +1614,7 @@ static int ccdc_isr_buffer(struct isp_ccdc_device *ccdc)
 		return 1;
 
 	buffer = omap3isp_video_buffer_next(&ccdc->video_out);
-	if (buffer != NULL)
+	if (buffer)
 		ccdc_set_outaddr(ccdc, buffer->dma);
 
 	pipe->state |= ISP_PIPELINE_IDLE_OUTPUT;
@@ -1734,7 +1734,7 @@ static void ccdc_vd1_isr(struct isp_ccdc_device *ccdc)
 	if (ccdc_handle_stopping(ccdc, CCDC_EVENT_VD1))
 		goto done;
 
-	if (ccdc->lsc.request == NULL)
+	if (!ccdc->lsc.request)
 		goto done;
 
 	/*
@@ -2312,7 +2312,7 @@ static int ccdc_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config
 	struct v4l2_mbus_framefmt *format;
 
 	format = __ccdc_get_format(ccdc, cfg, fmt->pad, fmt->which);
-	if (format == NULL)
+	if (!format)
 		return -EINVAL;
 
 	fmt->format = *format;
@@ -2336,7 +2336,7 @@ static int ccdc_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config
 	struct v4l2_rect *crop;
 
 	format = __ccdc_get_format(ccdc, cfg, fmt->pad, fmt->which);
-	if (format == NULL)
+	if (!format)
 		return -EINVAL;
 
 	ccdc_try_format(ccdc, cfg, fmt->pad, &fmt->format, fmt->which);
@@ -2732,7 +2732,7 @@ void omap3isp_ccdc_cleanup(struct isp_device *isp)
 	cancel_work_sync(&ccdc->lsc.table_work);
 	ccdc_lsc_free_queue(ccdc, &ccdc->lsc.free_queue);
 
-	if (ccdc->fpc.addr != NULL)
+	if (ccdc->fpc.addr)
 		dma_free_coherent(isp->dev, ccdc->fpc.fpnum * 4, ccdc->fpc.addr,
 				  ccdc->fpc.dma);
 
diff --git a/drivers/media/platform/omap3isp/ispccp2.c b/drivers/media/platform/omap3isp/ispccp2.c
index e062939d0d05..981ef33739d3 100644
--- a/drivers/media/platform/omap3isp/ispccp2.c
+++ b/drivers/media/platform/omap3isp/ispccp2.c
@@ -542,7 +542,7 @@ static void ccp2_isr_buffer(struct isp_ccp2_device *ccp2)
 	struct isp_buffer *buffer;
 
 	buffer = omap3isp_video_buffer_next(&ccp2->video_in);
-	if (buffer != NULL)
+	if (buffer)
 		ccp2_set_inaddr(ccp2, buffer->dma);
 
 	pipe->state |= ISP_PIPELINE_IDLE_INPUT;
@@ -758,7 +758,7 @@ static int ccp2_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config
 	struct v4l2_mbus_framefmt *format;
 
 	format = __ccp2_get_format(ccp2, cfg, fmt->pad, fmt->which);
-	if (format == NULL)
+	if (!format)
 		return -EINVAL;
 
 	fmt->format = *format;
@@ -779,7 +779,7 @@ static int ccp2_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config
 	struct v4l2_mbus_framefmt *format;
 
 	format = __ccp2_get_format(ccp2, cfg, fmt->pad, fmt->which);
-	if (format == NULL)
+	if (!format)
 		return -EINVAL;
 
 	ccp2_try_format(ccp2, cfg, fmt->pad, &fmt->format, fmt->which);
diff --git a/drivers/media/platform/omap3isp/ispcsi2.c b/drivers/media/platform/omap3isp/ispcsi2.c
index a4d3d030e81e..0285b100024d 100644
--- a/drivers/media/platform/omap3isp/ispcsi2.c
+++ b/drivers/media/platform/omap3isp/ispcsi2.c
@@ -688,7 +688,7 @@ static void csi2_isr_buffer(struct isp_csi2_device *csi2)
 	 * Let video queue operation restart engine if there is an underrun
 	 * condition.
 	 */
-	if (buffer == NULL)
+	if (!buffer)
 		return;
 
 	csi2_set_outaddr(csi2, buffer->dma);
@@ -976,7 +976,7 @@ static int csi2_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config
 	struct v4l2_mbus_framefmt *format;
 
 	format = __csi2_get_format(csi2, cfg, fmt->pad, fmt->which);
-	if (format == NULL)
+	if (!format)
 		return -EINVAL;
 
 	fmt->format = *format;
@@ -997,7 +997,7 @@ static int csi2_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config
 	struct v4l2_mbus_framefmt *format;
 
 	format = __csi2_get_format(csi2, cfg, fmt->pad, fmt->which);
-	if (format == NULL)
+	if (!format)
 		return -EINVAL;
 
 	csi2_try_format(csi2, cfg, fmt->pad, &fmt->format, fmt->which);
diff --git a/drivers/media/platform/omap3isp/ispcsiphy.c b/drivers/media/platform/omap3isp/ispcsiphy.c
index a28fb79abaac..846a8e1e3cc2 100644
--- a/drivers/media/platform/omap3isp/ispcsiphy.c
+++ b/drivers/media/platform/omap3isp/ispcsiphy.c
@@ -264,7 +264,7 @@ int omap3isp_csiphy_acquire(struct isp_csiphy *phy, struct media_entity *entity)
 {
 	int rval;
 
-	if (phy->vdd == NULL) {
+	if (!phy->vdd) {
 		dev_err(phy->isp->dev,
 			"Power regulator for CSI PHY not available\n");
 		return -ENODEV;
diff --git a/drivers/media/platform/omap3isp/isph3a_af.c b/drivers/media/platform/omap3isp/isph3a_af.c
index b81e869ade8c..e37cad7db835 100644
--- a/drivers/media/platform/omap3isp/isph3a_af.c
+++ b/drivers/media/platform/omap3isp/isph3a_af.c
@@ -355,7 +355,7 @@ int omap3isp_h3a_af_init(struct isp_device *isp)
 	struct omap3isp_h3a_af_config *af_recover_cfg;
 
 	af_cfg = devm_kzalloc(isp->dev, sizeof(*af_cfg), GFP_KERNEL);
-	if (af_cfg == NULL)
+	if (!af_cfg)
 		return -ENOMEM;
 
 	af->ops = &h3a_af_ops;
diff --git a/drivers/media/platform/omap3isp/isphist.c b/drivers/media/platform/omap3isp/isphist.c
index a4ed5d140d48..6bf5e10f825f 100644
--- a/drivers/media/platform/omap3isp/isphist.c
+++ b/drivers/media/platform/omap3isp/isphist.c
@@ -206,7 +206,7 @@ static int hist_buf_dma(struct ispstat *hist)
 	tx = dmaengine_prep_slave_single(hist->dma_ch, dma_addr,
 					 hist->buf_size, DMA_DEV_TO_MEM,
 					 DMA_CTRL_ACK);
-	if (tx == NULL) {
+	if (!tx) {
 		dev_dbg(hist->isp->dev,
 			"hist: DMA slave preparation failed\n");
 		goto error;
@@ -479,7 +479,7 @@ int omap3isp_hist_init(struct isp_device *isp)
 	int ret = -1;
 
 	hist_cfg = devm_kzalloc(isp->dev, sizeof(*hist_cfg), GFP_KERNEL);
-	if (hist_cfg == NULL)
+	if (!hist_cfg)
 		return -ENOMEM;
 
 	hist->isp = isp;
diff --git a/drivers/media/platform/omap3isp/isppreview.c b/drivers/media/platform/omap3isp/isppreview.c
index ac30a0f83780..f20d55f99e9f 100644
--- a/drivers/media/platform/omap3isp/isppreview.c
+++ b/drivers/media/platform/omap3isp/isppreview.c
@@ -1482,7 +1482,7 @@ static void preview_isr_buffer(struct isp_prev_device *prev)
 
 	if (prev->output & PREVIEW_OUTPUT_MEMORY) {
 		buffer = omap3isp_video_buffer_next(&prev->video_out);
-		if (buffer != NULL) {
+		if (buffer) {
 			preview_set_outaddr(prev, buffer->dma);
 			restart = 1;
 		}
@@ -1491,7 +1491,7 @@ static void preview_isr_buffer(struct isp_prev_device *prev)
 
 	if (prev->input == PREVIEW_INPUT_MEMORY) {
 		buffer = omap3isp_video_buffer_next(&prev->video_in);
-		if (buffer != NULL)
+		if (buffer)
 			preview_set_inaddr(prev, buffer->dma);
 		pipe->state |= ISP_PIPELINE_IDLE_INPUT;
 	}
@@ -2020,7 +2020,7 @@ static int preview_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_pad_con
 	struct v4l2_mbus_framefmt *format;
 
 	format = __preview_get_format(prev, cfg, fmt->pad, fmt->which);
-	if (format == NULL)
+	if (!format)
 		return -EINVAL;
 
 	fmt->format = *format;
@@ -2042,7 +2042,7 @@ static int preview_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_pad_con
 	struct v4l2_rect *crop;
 
 	format = __preview_get_format(prev, cfg, fmt->pad, fmt->which);
-	if (format == NULL)
+	if (!format)
 		return -EINVAL;
 
 	preview_try_format(prev, cfg, fmt->pad, &fmt->format, fmt->which);
diff --git a/drivers/media/platform/omap3isp/ispresizer.c b/drivers/media/platform/omap3isp/ispresizer.c
index 0b6a87508584..b3fbbef1213b 100644
--- a/drivers/media/platform/omap3isp/ispresizer.c
+++ b/drivers/media/platform/omap3isp/ispresizer.c
@@ -1025,7 +1025,7 @@ static void resizer_isr_buffer(struct isp_res_device *res)
 	 * buffer.
 	 */
 	buffer = omap3isp_video_buffer_next(&res->video_out);
-	if (buffer != NULL) {
+	if (buffer) {
 		resizer_set_outaddr(res, buffer->dma);
 		restart = 1;
 	}
@@ -1034,7 +1034,7 @@ static void resizer_isr_buffer(struct isp_res_device *res)
 
 	if (res->input == RESIZER_INPUT_MEMORY) {
 		buffer = omap3isp_video_buffer_next(&res->video_in);
-		if (buffer != NULL)
+		if (buffer)
 			resizer_set_inaddr(res, buffer->dma);
 		pipe->state |= ISP_PIPELINE_IDLE_INPUT;
 	}
@@ -1482,7 +1482,7 @@ static int resizer_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_pad_con
 	struct v4l2_mbus_framefmt *format;
 
 	format = __resizer_get_format(res, cfg, fmt->pad, fmt->which);
-	if (format == NULL)
+	if (!format)
 		return -EINVAL;
 
 	fmt->format = *format;
@@ -1504,7 +1504,7 @@ static int resizer_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_pad_con
 	struct v4l2_rect *crop;
 
 	format = __resizer_get_format(res, cfg, fmt->pad, fmt->which);
-	if (format == NULL)
+	if (!format)
 		return -EINVAL;
 
 	resizer_try_format(res, cfg, fmt->pad, &fmt->format, fmt->which);
diff --git a/drivers/media/platform/omap3isp/ispstat.c b/drivers/media/platform/omap3isp/ispstat.c
index 47cbc7e3d825..f27e3d28e76f 100644
--- a/drivers/media/platform/omap3isp/ispstat.c
+++ b/drivers/media/platform/omap3isp/ispstat.c
@@ -411,7 +411,7 @@ static int isp_stat_bufs_alloc(struct ispstat *stat, u32 size)
 
 	spin_lock_irqsave(&stat->isp->stat_lock, flags);
 
-	BUG_ON(stat->locked_buf != NULL);
+	BUG_ON(stat->locked_buf);
 
 	/* Are the old buffers big enough? */
 	if (stat->buf_alloc_size >= size) {
@@ -686,7 +686,7 @@ static void isp_stat_try_enable(struct ispstat *stat)
 {
 	unsigned long irqflags;
 
-	if (stat->priv == NULL)
+	if (!stat->priv)
 		/* driver wasn't initialised */
 		return;
 
diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index 218e6d7ae93a..7b9bd684337a 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -245,7 +245,7 @@ static int isp_video_get_graph_data(struct isp_video *video,
 
 		media_entity_enum_set(&pipe->ent_enum, entity);
 
-		if (far_end != NULL)
+		if (far_end)
 			continue;
 
 		if (entity == &video->video.entity)
@@ -267,7 +267,7 @@ static int isp_video_get_graph_data(struct isp_video *video,
 		pipe->input = far_end;
 		pipe->output = video;
 	} else {
-		if (far_end == NULL)
+		if (!far_end)
 			return -EPIPE;
 
 		pipe->input = video;
@@ -286,7 +286,7 @@ __isp_video_get_format(struct isp_video *video, struct v4l2_format *format)
 	int ret;
 
 	subdev = isp_video_remote_subdev(video, &pad);
-	if (subdev == NULL)
+	if (!subdev)
 		return -EINVAL;
 
 	fmt.pad = pad;
@@ -583,7 +583,7 @@ struct isp_buffer *omap3isp_video_buffer_next(struct isp_video *video)
 		return NULL;
 	}
 
-	if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE && pipe->input != NULL) {
+	if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE && pipe->input) {
 		spin_lock(&pipe->lock);
 		pipe->state &= ~ISP_PIPELINE_STREAM;
 		spin_unlock(&pipe->lock);
@@ -756,7 +756,7 @@ isp_video_try_format(struct file *file, void *fh, struct v4l2_format *format)
 		return -EINVAL;
 
 	subdev = isp_video_remote_subdev(video, &pad);
-	if (subdev == NULL)
+	if (!subdev)
 		return -EINVAL;
 
 	isp_video_pix_to_mbus(&format->fmt.pix, &fmt.format);
@@ -801,7 +801,7 @@ isp_video_get_selection(struct file *file, void *fh, struct v4l2_selection *sel)
 		return -EINVAL;
 	}
 	subdev = isp_video_remote_subdev(video, &pad);
-	if (subdev == NULL)
+	if (!subdev)
 		return -EINVAL;
 
 	/* Try the get selection operation first and fallback to get format if not
@@ -855,7 +855,7 @@ isp_video_set_selection(struct file *file, void *fh, struct v4l2_selection *sel)
 		return -EINVAL;
 	}
 	subdev = isp_video_remote_subdev(video, &pad);
-	if (subdev == NULL)
+	if (!subdev)
 		return -EINVAL;
 
 	sdsel.pad = pad;
@@ -980,7 +980,7 @@ static int isp_video_check_external_subdevs(struct isp_video *video,
 	int ret;
 
 	/* Memory-to-memory pipelines have no external subdev. */
-	if (pipe->input != NULL)
+	if (pipe->input)
 		return 0;
 
 	for (i = 0; i < ARRAY_SIZE(ents); i++) {
@@ -990,7 +990,7 @@ static int isp_video_check_external_subdevs(struct isp_video *video,
 
 		/* ISP entities have always sink pad == 0. Find source. */
 		source_pad = media_entity_remote_pad(&ents[i]->pads[0]);
-		if (source_pad == NULL)
+		if (!source_pad)
 			continue;
 
 		source = source_pad->entity;
@@ -1306,7 +1306,7 @@ static int isp_video_open(struct file *file)
 	int ret = 0;
 
 	handle = kzalloc(sizeof(*handle), GFP_KERNEL);
-	if (handle == NULL)
+	if (!handle)
 		return -ENOMEM;
 
 	v4l2_fh_init(&handle->vfh, &video->video);
@@ -1454,7 +1454,7 @@ int omap3isp_video_init(struct isp_video *video, const char *name)
 	spin_lock_init(&video->irqlock);
 
 	/* Initialize the video device. */
-	if (video->ops == NULL)
+	if (!video->ops)
 		video->ops = &isp_video_dummy_ops;
 
 	video->video.fops = &isp_video_fops;
-- 
2.14.1
