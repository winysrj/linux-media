Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:38308 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757932Ab3DXHmZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Apr 2013 03:42:25 -0400
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org
Cc: s.nawrocki@samsung.com, shaik.samsung@gmail.com,
	arunkk.samsung@gmail.com
Subject: [RFC v2 3/6] media: fimc-lite: Adding support for Exynos5
Date: Wed, 24 Apr 2013 13:11:10 +0530
Message-Id: <1366789273-30184-4-git-send-email-shaik.ameer@samsung.com>
In-Reply-To: <1366789273-30184-1-git-send-email-shaik.ameer@samsung.com>
References: <1366789273-30184-1-git-send-email-shaik.ameer@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

FIMC-LITE supports multiple DMA shadow registers from Exynos5 onwards.
This patch adds the functionality of using shadow registers by
checking the driver data.

Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-lite-reg.c |   13 +++++++
 drivers/media/platform/exynos4-is/fimc-lite-reg.h |   41 ++++++++++++++++++++-
 drivers/media/platform/exynos4-is/fimc-lite.c     |   12 ++++--
 3 files changed, 60 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-lite-reg.c b/drivers/media/platform/exynos4-is/fimc-lite-reg.c
index 8cc0d39..a1d566a 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite-reg.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite-reg.c
@@ -215,6 +215,18 @@ void flite_hw_set_camera_bus(struct fimc_lite *dev,
 	flite_hw_set_camera_port(dev, si->mux_id);
 }
 
+static void flite_hw_set_pack12(struct fimc_lite *dev, int on)
+{
+	u32 cfg = readl(dev->regs + FLITE_REG_CIODMAFMT);
+
+	cfg &= ~FLITE_REG_CIODMAFMT_PACK12;
+
+	if (on)
+		cfg |= FLITE_REG_CIODMAFMT_PACK12;
+
+	writel(cfg, dev->regs + FLITE_REG_CIODMAFMT);
+}
+
 static void flite_hw_set_out_order(struct fimc_lite *dev, struct flite_frame *f)
 {
 	static const u32 pixcode[4][2] = {
@@ -267,6 +279,7 @@ void flite_hw_set_output_dma(struct fimc_lite *dev, struct flite_frame *f,
 
 	flite_hw_set_out_order(dev, f);
 	flite_hw_set_dma_window(dev, f);
+	flite_hw_set_pack12(dev, 0);
 }
 
 void flite_hw_dump_regs(struct fimc_lite *dev, const char *label)
diff --git a/drivers/media/platform/exynos4-is/fimc-lite-reg.h b/drivers/media/platform/exynos4-is/fimc-lite-reg.h
index 3903839..8e57e7a 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite-reg.h
+++ b/drivers/media/platform/exynos4-is/fimc-lite-reg.h
@@ -120,6 +120,10 @@
 /* b0: 1 - camera B, 0 - camera A */
 #define FLITE_REG_CIGENERAL_CAM_B		(1 << 0)
 
+
+#define FLITE_REG_CIFCNTSEQ			0x100
+#define FLITE_REG_CIOSAN(x)			(0x200 + (4 * (x)))
+
 /* ----------------------------------------------------------------------------
  * Function declarations
  */
@@ -143,8 +147,41 @@ void flite_hw_set_dma_window(struct fimc_lite *dev, struct flite_frame *f);
 void flite_hw_set_test_pattern(struct fimc_lite *dev, bool on);
 void flite_hw_dump_regs(struct fimc_lite *dev, const char *label);
 
-static inline void flite_hw_set_output_addr(struct fimc_lite *dev, u32 paddr)
+static inline void flite_hw_set_output_addr(struct fimc_lite *dev,
+	u32 paddr, u32 index)
+{
+	u32 config;
+
+	/* FLITE in EXYNOS4 has only one DMA register */
+	if (!dev->dd->support_multi_dma_buf)
+		index = 0;
+
+	config = readl(dev->regs + FLITE_REG_CIFCNTSEQ);
+	config |= 1 << index;
+	writel(config, dev->regs + FLITE_REG_CIFCNTSEQ);
+
+	if (index == 0)
+		writel(paddr, dev->regs + FLITE_REG_CIOSA);
+	else
+		writel(paddr, dev->regs + FLITE_REG_CIOSAN(index-1));
+}
+
+static inline void flite_hw_clear_output_addr(struct fimc_lite *dev, u32 index)
 {
-	writel(paddr, dev->regs + FLITE_REG_CIOSA);
+	u32 config;
+
+	/* FLITE in EXYNOS4 has only one DMA register */
+	if (!dev->dd->support_multi_dma_buf)
+		index = 0;
+
+	config = readl(dev->regs + FLITE_REG_CIFCNTSEQ);
+	config &= ~(1 << index);
+	writel(config, dev->regs + FLITE_REG_CIFCNTSEQ);
 }
+
+static inline void flite_hw_clear_output_index(struct fimc_lite *dev)
+{
+	writel(0, dev->regs + FLITE_REG_CIFCNTSEQ);
+}
+
 #endif /* FIMC_LITE_REG_H */
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index cb173ec..1b12ea8 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -166,6 +166,8 @@ static int fimc_lite_hw_init(struct fimc_lite *fimc, bool isp_output)
 	if (fimc->inp_frame.fmt == NULL || fimc->out_frame.fmt == NULL)
 		return -EINVAL;
 
+	flite_hw_clear_output_index(fimc);
+
 	/* Get sensor configuration data from the sensor subdev */
 	si = v4l2_get_subdev_hostdata(fimc->sensor);
 	if (!si)
@@ -307,11 +309,12 @@ static irqreturn_t flite_irq_handler(int irq, void *priv)
 		tv->tv_sec = ts.tv_sec;
 		tv->tv_usec = ts.tv_nsec / NSEC_PER_USEC;
 		vbuf->vb.v4l2_buf.sequence = fimc->frame_count++;
+		flite_hw_clear_output_addr(fimc, vbuf->vb.v4l2_buf.index);
 		vb2_buffer_done(&vbuf->vb, VB2_BUF_STATE_DONE);
 
 		vbuf = fimc_lite_pending_queue_pop(fimc);
-		flite_hw_set_output_addr(fimc, vbuf->paddr);
-		fimc_lite_active_queue_add(fimc, vbuf);
+		flite_hw_set_output_addr(fimc, vbuf->paddr,
+					vbuf->vb.v4l2_buf.index);
 	}
 
 	if (test_bit(ST_FLITE_CONFIG, &fimc->state))
@@ -439,7 +442,8 @@ static void buffer_queue(struct vb2_buffer *vb)
 	if (!test_bit(ST_FLITE_SUSPENDED, &fimc->state) &&
 	    !test_bit(ST_FLITE_STREAM, &fimc->state) &&
 	    list_empty(&fimc->active_buf_q)) {
-		flite_hw_set_output_addr(fimc, buf->paddr);
+		flite_hw_set_output_addr(fimc, buf->paddr,
+					buf->vb.v4l2_buf.index);
 		fimc_lite_active_queue_add(fimc, buf);
 	} else {
 		fimc_lite_pending_queue_add(fimc, buf);
@@ -643,7 +647,7 @@ static int fimc_vidioc_querycap_capture(struct file *file, void *priv,
 	strlcpy(cap->driver, FIMC_LITE_DRV_NAME, sizeof(cap->driver));
 	cap->bus_info[0] = 0;
 	cap->card[0] = 0;
-	cap->capabilities = V4L2_CAP_STREAMING;
+	cap->capabilities = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_CAPTURE_MPLANE;
 	return 0;
 }
 
-- 
1.7.9.5

