Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:55754 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390258AbeKWU5I (ORCPT
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
Subject: [PATCH 2/2] media: sun6i-csi: manually fix other coding style issues
Date: Fri, 23 Nov 2018 05:13:23 -0500
Message-Id: <5470d46e7afc781f858eda7d7013934e46764f14.1542967999.git.mchehab+samsung@kernel.org>
In-Reply-To: <ad8d7a438746a7f6dd3300ff9f07bd5506de100c.1542967999.git.mchehab+samsung@kernel.org>
References: <ad8d7a438746a7f6dd3300ff9f07bd5506de100c.1542967999.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are a few other coding style issues reported by checkpatch
while in --strict mode. Fix the ones that make sense.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 .../platform/sunxi/sun6i-csi/sun6i_csi.c      |  9 +++----
 .../platform/sunxi/sun6i-csi/sun6i_csi_reg.h  | 24 +++++++++----------
 .../platform/sunxi/sun6i-csi/sun6i_video.c    |  3 ++-
 3 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
index 89fe2c1e21a8..9c8a98d78c97 100644
--- a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
+++ b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
@@ -57,7 +57,7 @@ bool sun6i_csi_is_format_supported(struct sun6i_csi *csi,
 	 * Identify the media bus format from device tree.
 	 */
 	if ((sdev->csi.v4l2_ep.bus_type == V4L2_MBUS_PARALLEL
-	      || sdev->csi.v4l2_ep.bus_type == V4L2_MBUS_BT656)
+	     || sdev->csi.v4l2_ep.bus_type == V4L2_MBUS_BT656)
 	     && sdev->csi.v4l2_ep.bus.parallel.bus_width == 16) {
 		switch (pixformat) {
 		case V4L2_PIX_FMT_HM12:
@@ -726,9 +726,10 @@ static int sun6i_csi_v4l2_init(struct sun6i_csi *csi)
 	if (ret)
 		goto unreg_v4l2;
 
-	ret = v4l2_async_notifier_parse_fwnode_endpoints(
-		csi->dev, &csi->notifier, sizeof(struct v4l2_async_subdev),
-		sun6i_csi_fwnode_parse);
+	ret = v4l2_async_notifier_parse_fwnode_endpoints(csi->dev,
+							 &csi->notifier,
+							 sizeof(struct v4l2_async_subdev),
+							 sun6i_csi_fwnode_parse);
 	if (ret)
 		goto clean_video;
 
diff --git a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi_reg.h b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi_reg.h
index d9b6d89f1927..703fa14bb313 100644
--- a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi_reg.h
+++ b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi_reg.h
@@ -46,7 +46,7 @@
 
 #define CSI_CAP_REG			0x8
 #define CSI_CAP_CH0_CAP_MASK_MASK		GENMASK(5, 2)
-#define CSI_CAP_CH0_CAP_MASK(count)		((count << 2) & CSI_CAP_CH0_CAP_MASK_MASK)
+#define CSI_CAP_CH0_CAP_MASK(count)		(((count) << 2) & CSI_CAP_CH0_CAP_MASK_MASK)
 #define CSI_CAP_CH0_VCAP_ON			BIT(1)
 #define CSI_CAP_CH0_SCAP_ON			BIT(0)
 
@@ -59,9 +59,9 @@
 
 #define CSI_CH_CFG_REG			0x44
 #define CSI_CH_CFG_INPUT_FMT_MASK		GENMASK(23, 20)
-#define CSI_CH_CFG_INPUT_FMT(fmt)		((fmt << 20) & CSI_CH_CFG_INPUT_FMT_MASK)
+#define CSI_CH_CFG_INPUT_FMT(fmt)		(((fmt) << 20) & CSI_CH_CFG_INPUT_FMT_MASK)
 #define CSI_CH_CFG_OUTPUT_FMT_MASK		GENMASK(19, 16)
-#define CSI_CH_CFG_OUTPUT_FMT(fmt)		((fmt << 16) & CSI_CH_CFG_OUTPUT_FMT_MASK)
+#define CSI_CH_CFG_OUTPUT_FMT(fmt)		(((fmt) << 16) & CSI_CH_CFG_OUTPUT_FMT_MASK)
 #define CSI_CH_CFG_VFLIP_EN			BIT(13)
 #define CSI_CH_CFG_HFLIP_EN			BIT(12)
 #define CSI_CH_CFG_FIELD_SEL_MASK		GENMASK(11, 10)
@@ -69,7 +69,7 @@
 #define CSI_CH_CFG_FIELD_SEL_FIELD1		((1 << 10) & CSI_CH_CFG_FIELD_SEL_MASK)
 #define CSI_CH_CFG_FIELD_SEL_BOTH		((2 << 10) & CSI_CH_CFG_FIELD_SEL_MASK)
 #define CSI_CH_CFG_INPUT_SEQ_MASK		GENMASK(9, 8)
-#define CSI_CH_CFG_INPUT_SEQ(seq)		((seq << 8) & CSI_CH_CFG_INPUT_SEQ_MASK)
+#define CSI_CH_CFG_INPUT_SEQ(seq)		(((seq) << 8) & CSI_CH_CFG_INPUT_SEQ_MASK)
 
 #define CSI_CH_SCALE_REG		0x4c
 #define CSI_CH_SCALE_QUART_EN			BIT(0)
@@ -111,27 +111,27 @@
 
 #define CSI_CH_HSIZE_REG		0x80
 #define CSI_CH_HSIZE_HOR_LEN_MASK		GENMASK(28, 16)
-#define CSI_CH_HSIZE_HOR_LEN(len)		((len << 16) & CSI_CH_HSIZE_HOR_LEN_MASK)
+#define CSI_CH_HSIZE_HOR_LEN(len)		(((len) << 16) & CSI_CH_HSIZE_HOR_LEN_MASK)
 #define CSI_CH_HSIZE_HOR_START_MASK		GENMASK(12, 0)
-#define CSI_CH_HSIZE_HOR_START(start)		((start << 0) & CSI_CH_HSIZE_HOR_START_MASK)
+#define CSI_CH_HSIZE_HOR_START(start)		(((start) << 0) & CSI_CH_HSIZE_HOR_START_MASK)
 
 #define CSI_CH_VSIZE_REG		0x84
 #define CSI_CH_VSIZE_VER_LEN_MASK		GENMASK(28, 16)
-#define CSI_CH_VSIZE_VER_LEN(len)		((len << 16) & CSI_CH_VSIZE_VER_LEN_MASK)
+#define CSI_CH_VSIZE_VER_LEN(len)		(((len) << 16) & CSI_CH_VSIZE_VER_LEN_MASK)
 #define CSI_CH_VSIZE_VER_START_MASK		GENMASK(12, 0)
-#define CSI_CH_VSIZE_VER_START(start)		((start << 0) & CSI_CH_VSIZE_VER_START_MASK)
+#define CSI_CH_VSIZE_VER_START(start)		(((start) << 0) & CSI_CH_VSIZE_VER_START_MASK)
 
 #define CSI_CH_BUF_LEN_REG		0x88
 #define CSI_CH_BUF_LEN_BUF_LEN_C_MASK		GENMASK(29, 16)
-#define CSI_CH_BUF_LEN_BUF_LEN_C(len)		((len << 16) & CSI_CH_BUF_LEN_BUF_LEN_C_MASK)
+#define CSI_CH_BUF_LEN_BUF_LEN_C(len)		(((len) << 16) & CSI_CH_BUF_LEN_BUF_LEN_C_MASK)
 #define CSI_CH_BUF_LEN_BUF_LEN_Y_MASK		GENMASK(13, 0)
-#define CSI_CH_BUF_LEN_BUF_LEN_Y(len)		((len << 0) & CSI_CH_BUF_LEN_BUF_LEN_Y_MASK)
+#define CSI_CH_BUF_LEN_BUF_LEN_Y(len)		(((len) << 0) & CSI_CH_BUF_LEN_BUF_LEN_Y_MASK)
 
 #define CSI_CH_FLIP_SIZE_REG		0x8c
 #define CSI_CH_FLIP_SIZE_VER_LEN_MASK		GENMASK(28, 16)
-#define CSI_CH_FLIP_SIZE_VER_LEN(len)		((len << 16) & CSI_CH_FLIP_SIZE_VER_LEN_MASK)
+#define CSI_CH_FLIP_SIZE_VER_LEN(len)		(((len) << 16) & CSI_CH_FLIP_SIZE_VER_LEN_MASK)
 #define CSI_CH_FLIP_SIZE_VALID_LEN_MASK		GENMASK(12, 0)
-#define CSI_CH_FLIP_SIZE_VALID_LEN(len)		((len << 0) & CSI_CH_FLIP_SIZE_VALID_LEN_MASK)
+#define CSI_CH_FLIP_SIZE_VALID_LEN(len)		(((len) << 0) & CSI_CH_FLIP_SIZE_VALID_LEN_MASK)
 
 #define CSI_CH_FRM_CLK_CNT_REG		0x90
 #define CSI_CH_ACC_ITNL_CLK_CNT_REG	0x94
diff --git a/drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c b/drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c
index 306b9d2aeafb..37c85b8f37a9 100644
--- a/drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c
+++ b/drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c
@@ -86,7 +86,8 @@ sun6i_video_remote_subdev(struct sun6i_video *video, u32 *pad)
 }
 
 static int sun6i_video_queue_setup(struct vb2_queue *vq,
-				   unsigned int *nbuffers, unsigned int *nplanes,
+				   unsigned int *nbuffers,
+				   unsigned int *nplanes,
 				   unsigned int sizes[],
 				   struct device *alloc_devs[])
 {
-- 
2.19.1
