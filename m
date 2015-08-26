Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:60104 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932680AbbHZPZs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Aug 2015 11:25:48 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH 2/2] [media] omap3isp: separate links creation from entities init
Date: Wed, 26 Aug 2015 17:25:19 +0200
Message-Id: <1440602719-12500-3-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1440602719-12500-1-git-send-email-javier@osg.samsung.com>
References: <1440602719-12500-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The omap3isp driver initializes the entities and creates the pads links
before the entities are registered with the media device. This does not
work now that object IDs are used to create links so the media_device
has to be set.

Split out the pads links creation from the entity initialization so are
made after the entities registration.

Suggested-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---

 drivers/media/platform/omap3isp/isp.c        | 152 +++++++++++++++++----------
 drivers/media/platform/omap3isp/ispccdc.c    |  22 ++--
 drivers/media/platform/omap3isp/ispccdc.h    |   1 +
 drivers/media/platform/omap3isp/ispccp2.c    |  22 ++--
 drivers/media/platform/omap3isp/ispccp2.h    |   1 +
 drivers/media/platform/omap3isp/ispcsi2.c    |  22 ++--
 drivers/media/platform/omap3isp/ispcsi2.h    |   1 +
 drivers/media/platform/omap3isp/isppreview.c |  33 +++---
 drivers/media/platform/omap3isp/isppreview.h |   1 +
 drivers/media/platform/omap3isp/ispresizer.c |  33 +++---
 drivers/media/platform/omap3isp/ispresizer.h |   1 +
 11 files changed, 185 insertions(+), 104 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index f3248b90f44d..0577d9254bed 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -1931,6 +1931,100 @@ done:
 	return ret;
 }
 
+/*
+ * isp_create_pads_links - Pads links creation for the subdevices
+ * @isp : Pointer to ISP device
+ * return negative error code or zero on success
+ */
+static int isp_create_pads_links(struct isp_device *isp)
+{
+	int ret;
+
+	ret = omap3isp_csi2_create_pads_links(isp);
+	if (ret < 0) {
+		dev_err(isp->dev, "CSI2 pads links creation failed\n");
+		return ret;
+	}
+
+	ret = omap3isp_ccp2_create_pads_links(isp);
+	if (ret < 0) {
+		dev_err(isp->dev, "CCP2 pads links creation failed\n");
+		return ret;
+	}
+
+	ret = omap3isp_ccdc_create_pads_links(isp);
+	if (ret < 0) {
+		dev_err(isp->dev, "CCDC pads links creation failed\n");
+		return ret;
+	}
+
+	ret = omap3isp_preview_create_pads_links(isp);
+	if (ret < 0) {
+		dev_err(isp->dev, "Preview pads links creation failed\n");
+		return ret;
+	}
+
+	ret = omap3isp_resizer_create_pads_links(isp);
+	if (ret < 0) {
+		dev_err(isp->dev, "Resizer pads links creation failed\n");
+		return ret;
+	}
+
+	/* Connect the submodules. */
+	ret = media_create_pad_link(
+			&isp->isp_csi2a.subdev.entity, CSI2_PAD_SOURCE,
+			&isp->isp_ccdc.subdev.entity, CCDC_PAD_SINK, 0);
+	if (ret < 0)
+		return ret;
+
+	ret = media_create_pad_link(
+			&isp->isp_ccp2.subdev.entity, CCP2_PAD_SOURCE,
+			&isp->isp_ccdc.subdev.entity, CCDC_PAD_SINK, 0);
+	if (ret < 0)
+		return ret;
+
+	ret = media_create_pad_link(
+			&isp->isp_ccdc.subdev.entity, CCDC_PAD_SOURCE_VP,
+			&isp->isp_prev.subdev.entity, PREV_PAD_SINK, 0);
+	if (ret < 0)
+		return ret;
+
+	ret = media_create_pad_link(
+			&isp->isp_ccdc.subdev.entity, CCDC_PAD_SOURCE_OF,
+			&isp->isp_res.subdev.entity, RESZ_PAD_SINK, 0);
+	if (ret < 0)
+		return ret;
+
+	ret = media_create_pad_link(
+			&isp->isp_prev.subdev.entity, PREV_PAD_SOURCE,
+			&isp->isp_res.subdev.entity, RESZ_PAD_SINK, 0);
+	if (ret < 0)
+		return ret;
+
+	ret = media_create_pad_link(
+			&isp->isp_ccdc.subdev.entity, CCDC_PAD_SOURCE_VP,
+			&isp->isp_aewb.subdev.entity, 0,
+			MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE);
+	if (ret < 0)
+		return ret;
+
+	ret = media_create_pad_link(
+			&isp->isp_ccdc.subdev.entity, CCDC_PAD_SOURCE_VP,
+			&isp->isp_af.subdev.entity, 0,
+			MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE);
+	if (ret < 0)
+		return ret;
+
+	ret = media_create_pad_link(
+			&isp->isp_ccdc.subdev.entity, CCDC_PAD_SOURCE_VP,
+			&isp->isp_hist.subdev.entity, 0,
+			MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
 static void isp_cleanup_modules(struct isp_device *isp)
 {
 	omap3isp_h3a_aewb_cleanup(isp);
@@ -2001,62 +2095,8 @@ static int isp_initialize_modules(struct isp_device *isp)
 		goto error_h3a_af;
 	}
 
-	/* Connect the submodules. */
-	ret = media_create_pad_link(
-			&isp->isp_csi2a.subdev.entity, CSI2_PAD_SOURCE,
-			&isp->isp_ccdc.subdev.entity, CCDC_PAD_SINK, 0);
-	if (ret < 0)
-		goto error_link;
-
-	ret = media_create_pad_link(
-			&isp->isp_ccp2.subdev.entity, CCP2_PAD_SOURCE,
-			&isp->isp_ccdc.subdev.entity, CCDC_PAD_SINK, 0);
-	if (ret < 0)
-		goto error_link;
-
-	ret = media_create_pad_link(
-			&isp->isp_ccdc.subdev.entity, CCDC_PAD_SOURCE_VP,
-			&isp->isp_prev.subdev.entity, PREV_PAD_SINK, 0);
-	if (ret < 0)
-		goto error_link;
-
-	ret = media_create_pad_link(
-			&isp->isp_ccdc.subdev.entity, CCDC_PAD_SOURCE_OF,
-			&isp->isp_res.subdev.entity, RESZ_PAD_SINK, 0);
-	if (ret < 0)
-		goto error_link;
-
-	ret = media_create_pad_link(
-			&isp->isp_prev.subdev.entity, PREV_PAD_SOURCE,
-			&isp->isp_res.subdev.entity, RESZ_PAD_SINK, 0);
-	if (ret < 0)
-		goto error_link;
-
-	ret = media_create_pad_link(
-			&isp->isp_ccdc.subdev.entity, CCDC_PAD_SOURCE_VP,
-			&isp->isp_aewb.subdev.entity, 0,
-			MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE);
-	if (ret < 0)
-		goto error_link;
-
-	ret = media_create_pad_link(
-			&isp->isp_ccdc.subdev.entity, CCDC_PAD_SOURCE_VP,
-			&isp->isp_af.subdev.entity, 0,
-			MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE);
-	if (ret < 0)
-		goto error_link;
-
-	ret = media_create_pad_link(
-			&isp->isp_ccdc.subdev.entity, CCDC_PAD_SOURCE_VP,
-			&isp->isp_hist.subdev.entity, 0,
-			MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE);
-	if (ret < 0)
-		goto error_link;
-
 	return 0;
 
-error_link:
-	omap3isp_h3a_af_cleanup(isp);
 error_h3a_af:
 	omap3isp_h3a_aewb_cleanup(isp);
 error_h3a_aewb:
@@ -2466,6 +2506,10 @@ static int isp_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto error_modules;
 
+	ret = isp_create_pads_links(isp);
+	if (ret < 0)
+		goto error_register_entities;
+
 	isp->notifier.bound = isp_subdev_notifier_bound;
 	isp->notifier.complete = isp_subdev_notifier_complete;
 
diff --git a/drivers/media/platform/omap3isp/ispccdc.c b/drivers/media/platform/omap3isp/ispccdc.c
index 6b5c52b7f755..f0e530c98188 100644
--- a/drivers/media/platform/omap3isp/ispccdc.c
+++ b/drivers/media/platform/omap3isp/ispccdc.c
@@ -2671,16 +2671,8 @@ static int ccdc_init_entities(struct isp_ccdc_device *ccdc)
 	if (ret < 0)
 		goto error_video;
 
-	/* Connect the CCDC subdev to the video node. */
-	ret = media_create_pad_link(&ccdc->subdev.entity, CCDC_PAD_SOURCE_OF,
-			&ccdc->video_out.video.entity, 0, 0);
-	if (ret < 0)
-		goto error_link;
-
 	return 0;
 
-error_link:
-	omap3isp_video_cleanup(&ccdc->video_out);
 error_video:
 	media_entity_cleanup(me);
 	return ret;
@@ -2726,6 +2718,20 @@ int omap3isp_ccdc_init(struct isp_device *isp)
 }
 
 /*
+ * omap3isp_ccdc_create_pads_links - CCDC pads links creation
+ * @isp : Pointer to ISP device
+ * return negative error code or zero on success
+ */
+int omap3isp_ccdc_create_pads_links(struct isp_device *isp)
+{
+	struct isp_ccdc_device *ccdc = &isp->isp_ccdc;
+
+	/* Connect the CCDC subdev to the video node. */
+	return media_create_pad_link(&ccdc->subdev.entity, CCDC_PAD_SOURCE_OF,
+				     &ccdc->video_out.video.entity, 0, 0);
+}
+
+/*
  * omap3isp_ccdc_cleanup - CCDC module cleanup.
  * @isp: Device pointer specific to the OMAP3 ISP.
  */
diff --git a/drivers/media/platform/omap3isp/ispccdc.h b/drivers/media/platform/omap3isp/ispccdc.h
index 3440a7097940..2128203ef6fb 100644
--- a/drivers/media/platform/omap3isp/ispccdc.h
+++ b/drivers/media/platform/omap3isp/ispccdc.h
@@ -163,6 +163,7 @@ struct isp_ccdc_device {
 struct isp_device;
 
 int omap3isp_ccdc_init(struct isp_device *isp);
+int omap3isp_ccdc_create_pads_links(struct isp_device *isp);
 void omap3isp_ccdc_cleanup(struct isp_device *isp);
 int omap3isp_ccdc_register_entities(struct isp_ccdc_device *ccdc,
 	struct v4l2_device *vdev);
diff --git a/drivers/media/platform/omap3isp/ispccp2.c b/drivers/media/platform/omap3isp/ispccp2.c
index 4ec96bd51094..ae3038e643cc 100644
--- a/drivers/media/platform/omap3isp/ispccp2.c
+++ b/drivers/media/platform/omap3isp/ispccp2.c
@@ -1104,16 +1104,8 @@ static int ccp2_init_entities(struct isp_ccp2_device *ccp2)
 	if (ret < 0)
 		goto error_video;
 
-	/* Connect the video node to the ccp2 subdev. */
-	ret = media_create_pad_link(&ccp2->video_in.video.entity, 0,
-				       &ccp2->subdev.entity, CCP2_PAD_SINK, 0);
-	if (ret < 0)
-		goto error_link;
-
 	return 0;
 
-error_link:
-	omap3isp_video_cleanup(&ccp2->video_in);
 error_video:
 	media_entity_cleanup(&ccp2->subdev.entity);
 	return ret;
@@ -1162,6 +1154,20 @@ int omap3isp_ccp2_init(struct isp_device *isp)
 }
 
 /*
+ * omap3isp_ccp2_create_pads_links - CCP2 pads links creation
+ * @isp : Pointer to ISP device
+ * return negative error code or zero on success
+ */
+int omap3isp_ccp2_create_pads_links(struct isp_device *isp)
+{
+	struct isp_ccp2_device *ccp2 = &isp->isp_ccp2;
+
+	/* Connect the video node to the ccp2 subdev. */
+	return media_create_pad_link(&ccp2->video_in.video.entity, 0,
+				     &ccp2->subdev.entity, CCP2_PAD_SINK, 0);
+}
+
+/*
  * omap3isp_ccp2_cleanup - CCP2 un-initialization
  * @isp : Pointer to ISP device
  */
diff --git a/drivers/media/platform/omap3isp/ispccp2.h b/drivers/media/platform/omap3isp/ispccp2.h
index 4662bffa79e3..fb74bc67878b 100644
--- a/drivers/media/platform/omap3isp/ispccp2.h
+++ b/drivers/media/platform/omap3isp/ispccp2.h
@@ -79,6 +79,7 @@ struct isp_ccp2_device {
 
 /* Function declarations */
 int omap3isp_ccp2_init(struct isp_device *isp);
+int omap3isp_ccp2_create_pads_links(struct isp_device *isp);
 void omap3isp_ccp2_cleanup(struct isp_device *isp);
 int omap3isp_ccp2_register_entities(struct isp_ccp2_device *ccp2,
 			struct v4l2_device *vdev);
diff --git a/drivers/media/platform/omap3isp/ispcsi2.c b/drivers/media/platform/omap3isp/ispcsi2.c
index 054e25e1f2ec..b1617f7efdee 100644
--- a/drivers/media/platform/omap3isp/ispcsi2.c
+++ b/drivers/media/platform/omap3isp/ispcsi2.c
@@ -1269,16 +1269,8 @@ static int csi2_init_entities(struct isp_csi2_device *csi2)
 	if (ret < 0)
 		goto error_video;
 
-	/* Connect the CSI2 subdev to the video node. */
-	ret = media_create_pad_link(&csi2->subdev.entity, CSI2_PAD_SOURCE,
-				       &csi2->video_out.video.entity, 0, 0);
-	if (ret < 0)
-		goto error_link;
-
 	return 0;
 
-error_link:
-	omap3isp_video_cleanup(&csi2->video_out);
 error_video:
 	media_entity_cleanup(&csi2->subdev.entity);
 	return ret;
@@ -1319,6 +1311,20 @@ int omap3isp_csi2_init(struct isp_device *isp)
 }
 
 /*
+ * omap3isp_csi2_create_pads_links - CSI2 pads links creation
+ * @isp : Pointer to ISP device
+ * return negative error code or zero on success
+ */
+int omap3isp_csi2_create_pads_links(struct isp_device *isp)
+{
+	struct isp_csi2_device *csi2a = &isp->isp_csi2a;
+
+	/* Connect the CSI2 subdev to the video node. */
+	return media_create_pad_link(&csi2a->subdev.entity, CSI2_PAD_SOURCE,
+				     &csi2a->video_out.video.entity, 0, 0);
+}
+
+/*
  * omap3isp_csi2_cleanup - Routine for module driver cleanup
  */
 void omap3isp_csi2_cleanup(struct isp_device *isp)
diff --git a/drivers/media/platform/omap3isp/ispcsi2.h b/drivers/media/platform/omap3isp/ispcsi2.h
index 453ed62fe394..452ee239c7d7 100644
--- a/drivers/media/platform/omap3isp/ispcsi2.h
+++ b/drivers/media/platform/omap3isp/ispcsi2.h
@@ -148,6 +148,7 @@ struct isp_csi2_device {
 void omap3isp_csi2_isr(struct isp_csi2_device *csi2);
 int omap3isp_csi2_reset(struct isp_csi2_device *csi2);
 int omap3isp_csi2_init(struct isp_device *isp);
+int omap3isp_csi2_create_pads_links(struct isp_device *isp);
 void omap3isp_csi2_cleanup(struct isp_device *isp);
 void omap3isp_csi2_unregister_entities(struct isp_csi2_device *csi2);
 int omap3isp_csi2_register_entities(struct isp_csi2_device *csi2,
diff --git a/drivers/media/platform/omap3isp/isppreview.c b/drivers/media/platform/omap3isp/isppreview.c
index 4e16feb0e929..cfb2debb02bf 100644
--- a/drivers/media/platform/omap3isp/isppreview.c
+++ b/drivers/media/platform/omap3isp/isppreview.c
@@ -2316,21 +2316,8 @@ static int preview_init_entities(struct isp_prev_device *prev)
 	if (ret < 0)
 		goto error_video_out;
 
-	/* Connect the video nodes to the previewer subdev. */
-	ret = media_create_pad_link(&prev->video_in.video.entity, 0,
-			&prev->subdev.entity, PREV_PAD_SINK, 0);
-	if (ret < 0)
-		goto error_link;
-
-	ret = media_create_pad_link(&prev->subdev.entity, PREV_PAD_SOURCE,
-			&prev->video_out.video.entity, 0, 0);
-	if (ret < 0)
-		goto error_link;
-
 	return 0;
 
-error_link:
-	omap3isp_video_cleanup(&prev->video_out);
 error_video_out:
 	omap3isp_video_cleanup(&prev->video_in);
 error_video_in:
@@ -2354,6 +2341,26 @@ int omap3isp_preview_init(struct isp_device *isp)
 	return preview_init_entities(prev);
 }
 
+/*
+ * omap3isp_preview_create_pads_links - Previewer pads links creation
+ * @isp : Pointer to ISP device
+ * return negative error code or zero on success
+ */
+int omap3isp_preview_create_pads_links(struct isp_device *isp)
+{
+	struct isp_prev_device *prev = &isp->isp_prev;
+	int ret;
+
+	/* Connect the video nodes to the previewer subdev. */
+	ret = media_create_pad_link(&prev->video_in.video.entity, 0,
+			&prev->subdev.entity, PREV_PAD_SINK, 0);
+	if (ret < 0)
+		return ret;
+
+	return media_create_pad_link(&prev->subdev.entity, PREV_PAD_SOURCE,
+				     &prev->video_out.video.entity, 0, 0);
+}
+
 void omap3isp_preview_cleanup(struct isp_device *isp)
 {
 	struct isp_prev_device *prev = &isp->isp_prev;
diff --git a/drivers/media/platform/omap3isp/isppreview.h b/drivers/media/platform/omap3isp/isppreview.h
index 16fdc03a3d43..f3593b7cecc7 100644
--- a/drivers/media/platform/omap3isp/isppreview.h
+++ b/drivers/media/platform/omap3isp/isppreview.h
@@ -148,6 +148,7 @@ struct isp_prev_device {
 struct isp_device;
 
 int omap3isp_preview_init(struct isp_device *isp);
+int omap3isp_preview_create_pads_links(struct isp_device *isp);
 void omap3isp_preview_cleanup(struct isp_device *isp);
 
 int omap3isp_preview_register_entities(struct isp_prev_device *prv,
diff --git a/drivers/media/platform/omap3isp/ispresizer.c b/drivers/media/platform/omap3isp/ispresizer.c
index a05975d90153..e3ecf1787fc4 100644
--- a/drivers/media/platform/omap3isp/ispresizer.c
+++ b/drivers/media/platform/omap3isp/ispresizer.c
@@ -1760,21 +1760,8 @@ static int resizer_init_entities(struct isp_res_device *res)
 
 	res->video_out.video.entity.flags |= MEDIA_ENT_FL_DEFAULT;
 
-	/* Connect the video nodes to the resizer subdev. */
-	ret = media_create_pad_link(&res->video_in.video.entity, 0,
-			&res->subdev.entity, RESZ_PAD_SINK, 0);
-	if (ret < 0)
-		goto error_link;
-
-	ret = media_create_pad_link(&res->subdev.entity, RESZ_PAD_SOURCE,
-			&res->video_out.video.entity, 0, 0);
-	if (ret < 0)
-		goto error_link;
-
 	return 0;
 
-error_link:
-	omap3isp_video_cleanup(&res->video_out);
 error_video_out:
 	omap3isp_video_cleanup(&res->video_in);
 error_video_in:
@@ -1798,6 +1785,26 @@ int omap3isp_resizer_init(struct isp_device *isp)
 	return resizer_init_entities(res);
 }
 
+/*
+ * omap3isp_resizer_create_pads_links - Resizer pads links creation
+ * @isp : Pointer to ISP device
+ * return negative error code or zero on success
+ */
+int omap3isp_resizer_create_pads_links(struct isp_device *isp)
+{
+	struct isp_res_device *res = &isp->isp_res;
+	int ret;
+
+	/* Connect the video nodes to the resizer subdev. */
+	ret = media_create_pad_link(&res->video_in.video.entity, 0,
+				    &res->subdev.entity, RESZ_PAD_SINK, 0);
+	if (ret < 0)
+		return ret;
+
+	return media_create_pad_link(&res->subdev.entity, RESZ_PAD_SOURCE,
+				     &res->video_out.video.entity, 0, 0);
+}
+
 void omap3isp_resizer_cleanup(struct isp_device *isp)
 {
 	struct isp_res_device *res = &isp->isp_res;
diff --git a/drivers/media/platform/omap3isp/ispresizer.h b/drivers/media/platform/omap3isp/ispresizer.h
index 5414542912e2..8b9fdcdab73d 100644
--- a/drivers/media/platform/omap3isp/ispresizer.h
+++ b/drivers/media/platform/omap3isp/ispresizer.h
@@ -119,6 +119,7 @@ struct isp_res_device {
 struct isp_device;
 
 int omap3isp_resizer_init(struct isp_device *isp);
+int omap3isp_resizer_create_pads_links(struct isp_device *isp);
 void omap3isp_resizer_cleanup(struct isp_device *isp);
 
 int omap3isp_resizer_register_entities(struct isp_res_device *res,
-- 
2.4.3

