Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48520 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbbH3DHw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Aug 2015 23:07:52 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH v8 17/55] [media] omap3isp: separate links creation from entities init
Date: Sun, 30 Aug 2015 00:06:28 -0300
Message-Id: <c81b0942c0405f447e4736fcda37f63509dc0526.1440902901.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440902901.git.mchehab@osg.samsung.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440902901.git.mchehab@osg.samsung.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Javier Martinez Canillas <javier@osg.samsung.com>

The omap3isp driver initializes the entities and creates the pads links
before the entities are registered with the media device. This does not
work now that object IDs are used to create links so the media_device
has to be set.

Split out the pads links creation from the entity initialization so are
made after the entities registration.

Suggested-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

Series-to: linux-kernel@vger.kernel.org
Series-cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Series-cc: linux-media@vger.kernel.org
Series-cc: Shuah Khan <shuahkh@osg.samsung.com>
Series-cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Cover-letter:
Patches to test MC next gen patches in OMAP3 ISP
Hello,

This series contains two patches that are needed to test the
"[PATCH v7 00/44] MC next generation patches" [0] in a OMAP3
board by using the omap3isp driver.

I found two issues during testing, the first one is that the
media_entity_cleanup() function tries to empty the pad links
list but the list is initialized when a entity is registered
causing a NULL pointer deference error.

The second issue is that the omap3isp driver creates links
when the entities are initialized but before the media device
is registered causing a NULL pointer deference as well.

Patch 1/1 fixes the first issue by removing the links list
empty logic from media_entity_cleanup() since that is made
in media_device_unregister_entity() and 2/2 fixes the second
issue by separating the entities initialization from the pads
links creation after the entities have been registered.

Patch 1/1 was posted before [1] but forgot to add the [media]
prefix in the subject line so I'm including in this set again.
Sorry about that.

The testing was made on an OMAP3 DM3735 IGEPv2 board and test
that the media-ctl -p prints out the topology. More extensive
testing will be made but I wanted to share these patches in
order to make easier for other people that were looking at it.

[0]: https://www.mail-archive.com/linux-media@vger.kernel.org/msg91528.html
[1]: https://lkml.org/lkml/2015/8/24/649

Best regards,
Javier
END

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index aa13b17d19a0..b8f6f81d2db2 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -1933,6 +1933,100 @@ done:
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
@@ -2003,62 +2097,8 @@ static int isp_initialize_modules(struct isp_device *isp)
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
@@ -2468,6 +2508,10 @@ static int isp_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto error_modules;
 
+	ret = isp_create_pads_links(isp);
+	if (ret < 0)
+		goto error_register_entities;
+
 	isp->notifier.bound = isp_subdev_notifier_bound;
 	isp->notifier.complete = isp_subdev_notifier_complete;
 
diff --git a/drivers/media/platform/omap3isp/ispccdc.c b/drivers/media/platform/omap3isp/ispccdc.c
index 27555e4f4aa8..9a811f5741fa 100644
--- a/drivers/media/platform/omap3isp/ispccdc.c
+++ b/drivers/media/platform/omap3isp/ispccdc.c
@@ -2666,16 +2666,8 @@ static int ccdc_init_entities(struct isp_ccdc_device *ccdc)
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
@@ -2721,6 +2713,20 @@ int omap3isp_ccdc_init(struct isp_device *isp)
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
index b215eb5049d6..6ec7d104ab75 100644
--- a/drivers/media/platform/omap3isp/ispccp2.c
+++ b/drivers/media/platform/omap3isp/ispccp2.c
@@ -1099,16 +1099,8 @@ static int ccp2_init_entities(struct isp_ccp2_device *ccp2)
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
@@ -1157,6 +1149,20 @@ int omap3isp_ccp2_init(struct isp_device *isp)
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
index fcefc1e74881..0fb057a74f69 100644
--- a/drivers/media/platform/omap3isp/ispcsi2.c
+++ b/drivers/media/platform/omap3isp/ispcsi2.c
@@ -1264,16 +1264,8 @@ static int csi2_init_entities(struct isp_csi2_device *csi2)
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
@@ -1314,6 +1306,20 @@ int omap3isp_csi2_init(struct isp_device *isp)
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
index ad38d20c7770..6986d2f65c19 100644
--- a/drivers/media/platform/omap3isp/isppreview.c
+++ b/drivers/media/platform/omap3isp/isppreview.c
@@ -2311,21 +2311,8 @@ static int preview_init_entities(struct isp_prev_device *prev)
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
@@ -2349,6 +2336,26 @@ int omap3isp_preview_init(struct isp_device *isp)
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
index b48ad4d4b834..249af7f524f9 100644
--- a/drivers/media/platform/omap3isp/ispresizer.c
+++ b/drivers/media/platform/omap3isp/ispresizer.c
@@ -1755,21 +1755,8 @@ static int resizer_init_entities(struct isp_res_device *res)
 
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
@@ -1793,6 +1780,26 @@ int omap3isp_resizer_init(struct isp_device *isp)
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

