Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37524 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755490AbbLKRQ4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2015 12:16:56 -0500
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH 01/10] [media] omap3isp: remove per ISP module link creation functions
Date: Fri, 11 Dec 2015 14:16:27 -0300
Message-Id: <1449854196-13296-2-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1449854196-13296-1-git-send-email-javier@osg.samsung.com>
References: <1449854196-13296-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The entities to video nodes links were created on separate functions for
each ISP module but since the only thing that these functions do is to
call media_create_pad_link(), there's no need for that indirection level
and all link creation logic can be just inlined in the caller function.

Also, since the only possible failure for the link creation is a memory
allocation, there is no need for error messages since the core already
reports a very verbose message in that case.

Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---

This patch addresses 3 of the issues Laurent pointed in patch [0]:

1- Inline entity to video node links creation in the caller.
2- Remove error messages if links creation failed.
3- Replace comment for links between entities.

[0]: https://patchwork.linuxtv.org/patch/31147/

 drivers/media/platform/omap3isp/isp.c        | 56 +++++++++++++++++-----------
 drivers/media/platform/omap3isp/ispccdc.c    | 14 -------
 drivers/media/platform/omap3isp/ispccdc.h    |  1 -
 drivers/media/platform/omap3isp/ispccp2.c    | 14 -------
 drivers/media/platform/omap3isp/ispccp2.h    |  1 -
 drivers/media/platform/omap3isp/ispcsi2.c    | 14 -------
 drivers/media/platform/omap3isp/ispcsi2.h    |  1 -
 drivers/media/platform/omap3isp/isppreview.c | 20 ----------
 drivers/media/platform/omap3isp/isppreview.h |  1 -
 drivers/media/platform/omap3isp/ispresizer.c | 20 ----------
 drivers/media/platform/omap3isp/ispresizer.h |  1 -
 11 files changed, 35 insertions(+), 108 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index cb8ac90086c1..40aee11805c7 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -1940,37 +1940,51 @@ static int isp_create_pads_links(struct isp_device *isp)
 {
 	int ret;
 
-	ret = omap3isp_csi2_create_pads_links(isp);
-	if (ret < 0) {
-		dev_err(isp->dev, "CSI2 pads links creation failed\n");
+	/* Create links between entities and video nodes. */
+	ret = media_create_pad_link(
+			&isp->isp_csi2a.subdev.entity, CSI2_PAD_SOURCE,
+			&isp->isp_csi2a.video_out.video.entity, 0, 0);
+	if (ret < 0)
 		return ret;
-	}
 
-	ret = omap3isp_ccp2_create_pads_links(isp);
-	if (ret < 0) {
-		dev_err(isp->dev, "CCP2 pads links creation failed\n");
+	ret = media_create_pad_link(
+			&isp->isp_ccp2.video_in.video.entity, 0,
+			&isp->isp_ccp2.subdev.entity, CCP2_PAD_SINK, 0);
+	if (ret < 0)
 		return ret;
-	}
 
-	ret = omap3isp_ccdc_create_pads_links(isp);
-	if (ret < 0) {
-		dev_err(isp->dev, "CCDC pads links creation failed\n");
+	ret = media_create_pad_link(
+			&isp->isp_ccdc.subdev.entity, CCDC_PAD_SOURCE_OF,
+			&isp->isp_ccdc.video_out.video.entity, 0, 0);
+	if (ret < 0)
 		return ret;
-	}
 
-	ret = omap3isp_preview_create_pads_links(isp);
-	if (ret < 0) {
-		dev_err(isp->dev, "Preview pads links creation failed\n");
+	ret = media_create_pad_link(
+			&isp->isp_prev.video_in.video.entity, 0,
+			&isp->isp_prev.subdev.entity, PREV_PAD_SINK, 0);
+	if (ret < 0)
 		return ret;
-	}
 
-	ret = omap3isp_resizer_create_pads_links(isp);
-	if (ret < 0) {
-		dev_err(isp->dev, "Resizer pads links creation failed\n");
+	ret = media_create_pad_link(
+			&isp->isp_prev.subdev.entity, PREV_PAD_SOURCE,
+			&isp->isp_prev.video_out.video.entity, 0, 0);
+	if (ret < 0)
+		return ret;
+
+	ret = media_create_pad_link(
+			&isp->isp_res.video_in.video.entity, 0,
+			&isp->isp_res.subdev.entity, RESZ_PAD_SINK, 0);
+	if (ret < 0)
+		return ret;
+
+	ret = media_create_pad_link(
+			&isp->isp_res.subdev.entity, RESZ_PAD_SOURCE,
+			&isp->isp_res.video_out.video.entity, 0, 0);
+
+	if (ret < 0)
 		return ret;
-	}
 
-	/* Connect the submodules. */
+	/* Create links between entities. */
 	ret = media_create_pad_link(
 			&isp->isp_csi2a.subdev.entity, CSI2_PAD_SOURCE,
 			&isp->isp_ccdc.subdev.entity, CCDC_PAD_SINK, 0);
diff --git a/drivers/media/platform/omap3isp/ispccdc.c b/drivers/media/platform/omap3isp/ispccdc.c
index 749462c1af8e..5e16b5f594b7 100644
--- a/drivers/media/platform/omap3isp/ispccdc.c
+++ b/drivers/media/platform/omap3isp/ispccdc.c
@@ -2718,20 +2718,6 @@ int omap3isp_ccdc_init(struct isp_device *isp)
 }
 
 /*
- * omap3isp_ccdc_create_pads_links - CCDC pads links creation
- * @isp : Pointer to ISP device
- * return negative error code or zero on success
- */
-int omap3isp_ccdc_create_pads_links(struct isp_device *isp)
-{
-	struct isp_ccdc_device *ccdc = &isp->isp_ccdc;
-
-	/* Connect the CCDC subdev to the video node. */
-	return media_create_pad_link(&ccdc->subdev.entity, CCDC_PAD_SOURCE_OF,
-				     &ccdc->video_out.video.entity, 0, 0);
-}
-
-/*
  * omap3isp_ccdc_cleanup - CCDC module cleanup.
  * @isp: Device pointer specific to the OMAP3 ISP.
  */
diff --git a/drivers/media/platform/omap3isp/ispccdc.h b/drivers/media/platform/omap3isp/ispccdc.h
index 2128203ef6fb..3440a7097940 100644
--- a/drivers/media/platform/omap3isp/ispccdc.h
+++ b/drivers/media/platform/omap3isp/ispccdc.h
@@ -163,7 +163,6 @@ struct isp_ccdc_device {
 struct isp_device;
 
 int omap3isp_ccdc_init(struct isp_device *isp);
-int omap3isp_ccdc_create_pads_links(struct isp_device *isp);
 void omap3isp_ccdc_cleanup(struct isp_device *isp);
 int omap3isp_ccdc_register_entities(struct isp_ccdc_device *ccdc,
 	struct v4l2_device *vdev);
diff --git a/drivers/media/platform/omap3isp/ispccp2.c b/drivers/media/platform/omap3isp/ispccp2.c
index 59686dd1bb0a..27f5fe4edefc 100644
--- a/drivers/media/platform/omap3isp/ispccp2.c
+++ b/drivers/media/platform/omap3isp/ispccp2.c
@@ -1154,20 +1154,6 @@ int omap3isp_ccp2_init(struct isp_device *isp)
 }
 
 /*
- * omap3isp_ccp2_create_pads_links - CCP2 pads links creation
- * @isp : Pointer to ISP device
- * return negative error code or zero on success
- */
-int omap3isp_ccp2_create_pads_links(struct isp_device *isp)
-{
-	struct isp_ccp2_device *ccp2 = &isp->isp_ccp2;
-
-	/* Connect the video node to the ccp2 subdev. */
-	return media_create_pad_link(&ccp2->video_in.video.entity, 0,
-				     &ccp2->subdev.entity, CCP2_PAD_SINK, 0);
-}
-
-/*
  * omap3isp_ccp2_cleanup - CCP2 un-initialization
  * @isp : Pointer to ISP device
  */
diff --git a/drivers/media/platform/omap3isp/ispccp2.h b/drivers/media/platform/omap3isp/ispccp2.h
index fb74bc67878b..4662bffa79e3 100644
--- a/drivers/media/platform/omap3isp/ispccp2.h
+++ b/drivers/media/platform/omap3isp/ispccp2.h
@@ -79,7 +79,6 @@ struct isp_ccp2_device {
 
 /* Function declarations */
 int omap3isp_ccp2_init(struct isp_device *isp);
-int omap3isp_ccp2_create_pads_links(struct isp_device *isp);
 void omap3isp_ccp2_cleanup(struct isp_device *isp);
 int omap3isp_ccp2_register_entities(struct isp_ccp2_device *ccp2,
 			struct v4l2_device *vdev);
diff --git a/drivers/media/platform/omap3isp/ispcsi2.c b/drivers/media/platform/omap3isp/ispcsi2.c
index 886f148755b0..f75a1be29d84 100644
--- a/drivers/media/platform/omap3isp/ispcsi2.c
+++ b/drivers/media/platform/omap3isp/ispcsi2.c
@@ -1311,20 +1311,6 @@ int omap3isp_csi2_init(struct isp_device *isp)
 }
 
 /*
- * omap3isp_csi2_create_pads_links - CSI2 pads links creation
- * @isp : Pointer to ISP device
- * return negative error code or zero on success
- */
-int omap3isp_csi2_create_pads_links(struct isp_device *isp)
-{
-	struct isp_csi2_device *csi2a = &isp->isp_csi2a;
-
-	/* Connect the CSI2 subdev to the video node. */
-	return media_create_pad_link(&csi2a->subdev.entity, CSI2_PAD_SOURCE,
-				     &csi2a->video_out.video.entity, 0, 0);
-}
-
-/*
  * omap3isp_csi2_cleanup - Routine for module driver cleanup
  */
 void omap3isp_csi2_cleanup(struct isp_device *isp)
diff --git a/drivers/media/platform/omap3isp/ispcsi2.h b/drivers/media/platform/omap3isp/ispcsi2.h
index 452ee239c7d7..453ed62fe394 100644
--- a/drivers/media/platform/omap3isp/ispcsi2.h
+++ b/drivers/media/platform/omap3isp/ispcsi2.h
@@ -148,7 +148,6 @@ struct isp_csi2_device {
 void omap3isp_csi2_isr(struct isp_csi2_device *csi2);
 int omap3isp_csi2_reset(struct isp_csi2_device *csi2);
 int omap3isp_csi2_init(struct isp_device *isp);
-int omap3isp_csi2_create_pads_links(struct isp_device *isp);
 void omap3isp_csi2_cleanup(struct isp_device *isp);
 void omap3isp_csi2_unregister_entities(struct isp_csi2_device *csi2);
 int omap3isp_csi2_register_entities(struct isp_csi2_device *csi2,
diff --git a/drivers/media/platform/omap3isp/isppreview.c b/drivers/media/platform/omap3isp/isppreview.c
index e15ad4133632..84a96670e2e7 100644
--- a/drivers/media/platform/omap3isp/isppreview.c
+++ b/drivers/media/platform/omap3isp/isppreview.c
@@ -2341,26 +2341,6 @@ int omap3isp_preview_init(struct isp_device *isp)
 	return preview_init_entities(prev);
 }
 
-/*
- * omap3isp_preview_create_pads_links - Previewer pads links creation
- * @isp : Pointer to ISP device
- * return negative error code or zero on success
- */
-int omap3isp_preview_create_pads_links(struct isp_device *isp)
-{
-	struct isp_prev_device *prev = &isp->isp_prev;
-	int ret;
-
-	/* Connect the video nodes to the previewer subdev. */
-	ret = media_create_pad_link(&prev->video_in.video.entity, 0,
-			&prev->subdev.entity, PREV_PAD_SINK, 0);
-	if (ret < 0)
-		return ret;
-
-	return media_create_pad_link(&prev->subdev.entity, PREV_PAD_SOURCE,
-				     &prev->video_out.video.entity, 0, 0);
-}
-
 void omap3isp_preview_cleanup(struct isp_device *isp)
 {
 	struct isp_prev_device *prev = &isp->isp_prev;
diff --git a/drivers/media/platform/omap3isp/isppreview.h b/drivers/media/platform/omap3isp/isppreview.h
index f3593b7cecc7..16fdc03a3d43 100644
--- a/drivers/media/platform/omap3isp/isppreview.h
+++ b/drivers/media/platform/omap3isp/isppreview.h
@@ -148,7 +148,6 @@ struct isp_prev_device {
 struct isp_device;
 
 int omap3isp_preview_init(struct isp_device *isp);
-int omap3isp_preview_create_pads_links(struct isp_device *isp);
 void omap3isp_preview_cleanup(struct isp_device *isp);
 
 int omap3isp_preview_register_entities(struct isp_prev_device *prv,
diff --git a/drivers/media/platform/omap3isp/ispresizer.c b/drivers/media/platform/omap3isp/ispresizer.c
index 20b98d876d7e..0b6a87508584 100644
--- a/drivers/media/platform/omap3isp/ispresizer.c
+++ b/drivers/media/platform/omap3isp/ispresizer.c
@@ -1785,26 +1785,6 @@ int omap3isp_resizer_init(struct isp_device *isp)
 	return resizer_init_entities(res);
 }
 
-/*
- * omap3isp_resizer_create_pads_links - Resizer pads links creation
- * @isp : Pointer to ISP device
- * return negative error code or zero on success
- */
-int omap3isp_resizer_create_pads_links(struct isp_device *isp)
-{
-	struct isp_res_device *res = &isp->isp_res;
-	int ret;
-
-	/* Connect the video nodes to the resizer subdev. */
-	ret = media_create_pad_link(&res->video_in.video.entity, 0,
-				    &res->subdev.entity, RESZ_PAD_SINK, 0);
-	if (ret < 0)
-		return ret;
-
-	return media_create_pad_link(&res->subdev.entity, RESZ_PAD_SOURCE,
-				     &res->video_out.video.entity, 0, 0);
-}
-
 void omap3isp_resizer_cleanup(struct isp_device *isp)
 {
 	struct isp_res_device *res = &isp->isp_res;
diff --git a/drivers/media/platform/omap3isp/ispresizer.h b/drivers/media/platform/omap3isp/ispresizer.h
index 8b9fdcdab73d..5414542912e2 100644
--- a/drivers/media/platform/omap3isp/ispresizer.h
+++ b/drivers/media/platform/omap3isp/ispresizer.h
@@ -119,7 +119,6 @@ struct isp_res_device {
 struct isp_device;
 
 int omap3isp_resizer_init(struct isp_device *isp);
-int omap3isp_resizer_create_pads_links(struct isp_device *isp);
 void omap3isp_resizer_cleanup(struct isp_device *isp);
 
 int omap3isp_resizer_register_entities(struct isp_res_device *res,
-- 
2.4.3

