Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:39581 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754617AbdLOBFp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Dec 2017 20:05:45 -0500
From: Steve Longerbeam <slongerbeam@gmail.com>
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v2 8/9] media: staging/imx: reorder function prototypes
Date: Thu, 14 Dec 2017 17:04:46 -0800
Message-Id: <1513299887-16804-9-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1513299887-16804-1-git-send-email-steve_longerbeam@mentor.com>
References: <1513299887-16804-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Re-order some of the function prototypes in imx-media.h to
group them correctly by source file. No functional changes.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/media/imx/imx-media.h | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media.h b/drivers/staging/media/imx/imx-media.h
index ebb24b1..2fd6dfd 100644
--- a/drivers/staging/media/imx/imx-media.h
+++ b/drivers/staging/media/imx/imx-media.h
@@ -157,6 +157,7 @@ enum codespace_sel {
 	CS_SEL_ANY,
 };
 
+/* imx-media-utils.c */
 const struct imx_media_pixfmt *
 imx_media_find_format(u32 fourcc, enum codespace_sel cs_sel, bool allow_bayer);
 int imx_media_enum_format(u32 *fourcc, u32 index, enum codespace_sel cs_sel);
@@ -181,17 +182,8 @@ int imx_media_mbus_fmt_to_ipu_image(struct ipu_image *image,
 				    struct v4l2_mbus_framefmt *mbus);
 int imx_media_ipu_image_to_mbus_fmt(struct v4l2_mbus_framefmt *mbus,
 				    struct ipu_image *image);
-int imx_media_add_async_subdev(struct imx_media_dev *imxmd,
-			       struct fwnode_handle *fwnode,
-			       struct platform_device *pdev);
 void imx_media_grp_id_to_sd_name(char *sd_name, int sz,
 				 u32 grp_id, int ipu_id);
-
-int imx_media_add_internal_subdevs(struct imx_media_dev *imxmd);
-int imx_media_create_internal_links(struct imx_media_dev *imxmd,
-				    struct v4l2_subdev *sd);
-void imx_media_remove_internal_subdevs(struct imx_media_dev *imxmd);
-
 struct v4l2_subdev *
 imx_media_find_subdev_by_fwnode(struct imx_media_dev *imxmd,
 				struct fwnode_handle *fwnode);
@@ -227,6 +219,11 @@ int imx_media_pipeline_set_stream(struct imx_media_dev *imxmd,
 				  struct media_entity *entity,
 				  bool on);
 
+/* imx-media-dev.c */
+int imx_media_add_async_subdev(struct imx_media_dev *imxmd,
+			       struct fwnode_handle *fwnode,
+			       struct platform_device *pdev);
+
 /* imx-media-fim.c */
 struct imx_media_fim;
 void imx_media_fim_eof_monitor(struct imx_media_fim *fim, ktime_t timestamp);
@@ -237,6 +234,12 @@ int imx_media_fim_add_controls(struct imx_media_fim *fim);
 struct imx_media_fim *imx_media_fim_init(struct v4l2_subdev *sd);
 void imx_media_fim_free(struct imx_media_fim *fim);
 
+/* imx-media-internal-sd.c */
+int imx_media_add_internal_subdevs(struct imx_media_dev *imxmd);
+int imx_media_create_internal_links(struct imx_media_dev *imxmd,
+				    struct v4l2_subdev *sd);
+void imx_media_remove_internal_subdevs(struct imx_media_dev *imxmd);
+
 /* imx-media-of.c */
 int imx_media_add_of_subdevs(struct imx_media_dev *dev,
 			     struct device_node *np);
-- 
2.7.4
