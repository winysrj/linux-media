Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:56616 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755126AbeDFOXj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Apr 2018 10:23:39 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hansverk@cisco.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Bhumika Goyal <bhumirks@gmail.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Geliang Tang <geliangtang@gmail.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 20/21] media: fsl-viu: fix __iomem annotations
Date: Fri,  6 Apr 2018 10:23:21 -0400
Message-Id: <457312e30430e83f9dc4bf1804acb15b91e5dfc1.1523024380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523024380.git.mchehab@s-opensource.com>
References: <cover.1523024380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523024380.git.mchehab@s-opensource.com>
References: <cover.1523024380.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those annotations are wrong, causing this warning:

    drivers/media/platform/fsl-viu.c:1440:21: warning: incorrect type in assignment (different address spaces)
    drivers/media/platform/fsl-viu.c:1440:21:    expected struct viu_reg *vr
    drivers/media/platform/fsl-viu.c:1440:21:    got struct viu_reg [noderef] <asn:2>*[assigned] viu_regs

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/fsl-viu.c | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/media/platform/fsl-viu.c b/drivers/media/platform/fsl-viu.c
index 4ca060ee8c08..5b6bfcafc2a4 100644
--- a/drivers/media/platform/fsl-viu.c
+++ b/drivers/media/platform/fsl-viu.c
@@ -134,7 +134,7 @@ struct viu_dev {
 	int			dma_done;
 
 	/* Hardware register area */
-	struct viu_reg		*vr;
+	struct viu_reg __iomem	*vr;
 
 	/* Interrupt vector */
 	int			irq;
@@ -250,7 +250,7 @@ static struct viu_fmt *format_by_fourcc(int fourcc)
 
 static void viu_start_dma(struct viu_dev *dev)
 {
-	struct viu_reg *vr = dev->vr;
+	struct viu_reg __iomem *vr = dev->vr;
 
 	dev->field = 0;
 
@@ -261,7 +261,7 @@ static void viu_start_dma(struct viu_dev *dev)
 
 static void viu_stop_dma(struct viu_dev *dev)
 {
-	struct viu_reg *vr = dev->vr;
+	struct viu_reg __iomem *vr = dev->vr;
 	int cnt = 100;
 	u32 status_cfg;
 
@@ -401,7 +401,7 @@ static void free_buffer(struct videobuf_queue *vq, struct viu_buf *buf)
 
 inline int buffer_activate(struct viu_dev *dev, struct viu_buf *buf)
 {
-	struct viu_reg *vr = dev->vr;
+	struct viu_reg __iomem *vr = dev->vr;
 	int bpp;
 
 	/* setup the DMA base address */
@@ -706,10 +706,8 @@ static int verify_preview(struct viu_dev *dev, struct v4l2_window *win)
 	return 0;
 }
 
-inline void viu_activate_overlay(struct viu_reg *viu_reg)
+inline void viu_activate_overlay(struct viu_reg __iomem *vr)
 {
-	struct viu_reg *vr = viu_reg;
-
 	out_be32(&vr->field_base_addr, reg_val.field_base_addr);
 	out_be32(&vr->dma_inc, reg_val.dma_inc);
 	out_be32(&vr->picture_count, reg_val.picture_count);
@@ -988,10 +986,8 @@ inline void viu_activate_next_buf(struct viu_dev *dev,
 	}
 }
 
-inline void viu_default_settings(struct viu_reg *viu_reg)
+inline void viu_default_settings(struct viu_reg __iomem *vr)
 {
-	struct viu_reg *vr = viu_reg;
-
 	out_be32(&vr->luminance, 0x9512A254);
 	out_be32(&vr->chroma_r, 0x03310000);
 	out_be32(&vr->chroma_g, 0x06600F38);
@@ -1004,7 +1000,7 @@ inline void viu_default_settings(struct viu_reg *viu_reg)
 
 static void viu_overlay_intr(struct viu_dev *dev, u32 status)
 {
-	struct viu_reg *vr = dev->vr;
+	struct viu_reg __iomem *vr = dev->vr;
 
 	if (status & INT_DMA_END_STATUS)
 		dev->dma_done = 1;
@@ -1035,7 +1031,7 @@ static void viu_overlay_intr(struct viu_dev *dev, u32 status)
 static void viu_capture_intr(struct viu_dev *dev, u32 status)
 {
 	struct viu_dmaqueue *vidq = &dev->vidq;
-	struct viu_reg *vr = dev->vr;
+	struct viu_reg __iomem *vr = dev->vr;
 	struct viu_buf *buf;
 	int field_num;
 	int need_two;
@@ -1107,7 +1103,7 @@ static void viu_capture_intr(struct viu_dev *dev, u32 status)
 static irqreturn_t viu_intr(int irq, void *dev_id)
 {
 	struct viu_dev *dev  = (struct viu_dev *)dev_id;
-	struct viu_reg *vr = dev->vr;
+	struct viu_reg __iomem *vr = dev->vr;
 	u32 status;
 	u32 error;
 
@@ -1172,7 +1168,7 @@ static int viu_open(struct file *file)
 	struct video_device *vdev = video_devdata(file);
 	struct viu_dev *dev = video_get_drvdata(vdev);
 	struct viu_fh *fh;
-	struct viu_reg *vr;
+	struct viu_reg __iomem *vr;
 	int minor = vdev->minor;
 	u32 status_cfg;
 
@@ -1306,7 +1302,7 @@ static int viu_release(struct file *file)
 	return 0;
 }
 
-static void viu_reset(struct viu_reg *reg)
+static void viu_reset(struct viu_reg __iomem *reg)
 {
 	out_be32(&reg->status_cfg, 0);
 	out_be32(&reg->luminance, 0x9512a254);
-- 
2.14.3
