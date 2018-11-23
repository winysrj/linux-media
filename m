Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:55752 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390102AbeKWU5I (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Nov 2018 15:57:08 -0500
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Yong Deng <yong.deng@magewell.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/2] media: sum6i-csi: Fix a few coding style issues
Date: Fri, 23 Nov 2018 05:13:22 -0500
Message-Id: <ad8d7a438746a7f6dd3300ff9f07bd5506de100c.1542967999.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make checkpatch.pl happier by running it on strict mode and
using the --fix-inline to solve some issues.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c     |  9 ++++-----
 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.h     |  2 +-
 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi_reg.h |  2 +-
 drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c   | 10 +++++-----
 4 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
index 7af55ad142dc..89fe2c1e21a8 100644
--- a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
+++ b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
@@ -279,7 +279,6 @@ static enum csi_output_fmt get_csi_output_format(struct sun6i_csi_dev *sdev,
 static enum csi_input_seq get_csi_input_seq(struct sun6i_csi_dev *sdev,
 					    u32 mbus_code, u32 pixformat)
 {
-
 	switch (pixformat) {
 	case V4L2_PIX_FMT_HM12:
 	case V4L2_PIX_FMT_NV12:
@@ -543,7 +542,7 @@ int sun6i_csi_update_config(struct sun6i_csi *csi,
 {
 	struct sun6i_csi_dev *sdev = sun6i_csi_to_dev(csi);
 
-	if (config == NULL)
+	if (!config)
 		return -EINVAL;
 
 	memcpy(&csi->config, config, sizeof(csi->config));
@@ -644,7 +643,7 @@ static int sun6i_subdev_notify_complete(struct v4l2_async_notifier *notifier)
 	dev_dbg(csi->dev, "notify complete, all subdevs registered\n");
 
 	sd = list_first_entry(&v4l2_dev->subdevs, struct v4l2_subdev, list);
-	if (sd == NULL)
+	if (!sd)
 		return -EINVAL;
 
 	ret = sun6i_csi_link_entity(csi, &sd->entity, sd->fwnode);
@@ -810,7 +809,7 @@ static int sun6i_csi_resource_request(struct sun6i_csi_dev *sdev,
 		return PTR_ERR(io_base);
 
 	sdev->regmap = devm_regmap_init_mmio_clk(&pdev->dev, "bus", io_base,
-					    &sun6i_csi_regmap_config);
+						 &sun6i_csi_regmap_config);
 	if (IS_ERR(sdev->regmap)) {
 		dev_err(&pdev->dev, "Failed to init register map\n");
 		return PTR_ERR(sdev->regmap);
@@ -853,7 +852,7 @@ static int sun6i_csi_resource_request(struct sun6i_csi_dev *sdev,
 
 /*
  * PHYS_OFFSET isn't available on all architectures. In order to
- * accomodate for COMPILE_TEST, let's define it to something dumb.
+ * accommodate for COMPILE_TEST, let's define it to something dumb.
  */
 #if defined(CONFIG_COMPILE_TEST) && !defined(PHYS_OFFSET)
 #define PHYS_OFFSET 0
diff --git a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.h b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.h
index bd9be36aabfe..0bb000712c33 100644
--- a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.h
+++ b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.h
@@ -55,7 +55,7 @@ struct sun6i_csi {
  * @mbus_code:	media bus format code (MEDIA_BUS_FMT_*)
  */
 bool sun6i_csi_is_format_supported(struct sun6i_csi *csi, u32 pixformat,
-				 u32 mbus_code);
+				   u32 mbus_code);
 
 /**
  * sun6i_csi_set_power() - power on/off the csi
diff --git a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi_reg.h b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi_reg.h
index 3a55836a5a4d..d9b6d89f1927 100644
--- a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi_reg.h
+++ b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi_reg.h
@@ -37,7 +37,7 @@
 #define CSI_IF_CFG_IF_DATA_WIDTH_12BIT		((2 << 8) & CSI_IF_CFG_IF_DATA_WIDTH_MASK)
 #define CSI_IF_CFG_MIPI_IF_MASK			BIT(7)
 #define CSI_IF_CFG_MIPI_IF_CSI			(0 << 7)
-#define CSI_IF_CFG_MIPI_IF_MIPI			(1 << 7)
+#define CSI_IF_CFG_MIPI_IF_MIPI			BIT(7)
 #define CSI_IF_CFG_CSI_IF_MASK			GENMASK(4, 0)
 #define CSI_IF_CFG_CSI_IF_YUV422_INTLV		((0 << 0) & CSI_IF_CFG_CSI_IF_MASK)
 #define CSI_IF_CFG_CSI_IF_YUV422_16BIT		((1 << 0) & CSI_IF_CFG_CSI_IF_MASK)
diff --git a/drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c b/drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c
index e1901a38726f..306b9d2aeafb 100644
--- a/drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c
+++ b/drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c
@@ -86,9 +86,9 @@ sun6i_video_remote_subdev(struct sun6i_video *video, u32 *pad)
 }
 
 static int sun6i_video_queue_setup(struct vb2_queue *vq,
-				 unsigned int *nbuffers, unsigned int *nplanes,
-				 unsigned int sizes[],
-				 struct device *alloc_devs[])
+				   unsigned int *nbuffers, unsigned int *nplanes,
+				   unsigned int sizes[],
+				   struct device *alloc_devs[])
 {
 	struct sun6i_video *video = vb2_get_drv_priv(vq);
 	unsigned int size = video->fmt.fmt.pix.sizeimage;
@@ -308,7 +308,7 @@ static const struct vb2_ops sun6i_csi_vb2_ops = {
 };
 
 static int vidioc_querycap(struct file *file, void *priv,
-				struct v4l2_capability *cap)
+			   struct v4l2_capability *cap)
 {
 	struct sun6i_video *video = video_drvdata(file);
 
@@ -403,7 +403,7 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 }
 
 static int vidioc_enum_input(struct file *file, void *fh,
-			 struct v4l2_input *inp)
+			     struct v4l2_input *inp)
 {
 	if (inp->index != 0)
 		return -EINVAL;
-- 
2.19.1
