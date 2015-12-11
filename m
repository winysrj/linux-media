Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56639 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbbLKO07 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2015 09:26:59 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>,
	Haneen Mohammed <hamohammed.sa@gmail.com>,
	Navya Sri Nizamkari <navyasri.tech@gmail.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Nicholas Mc Guire <der.herr@hofr.at>,
	devel@driverdev.osuosl.org
Subject: [PATCH] media: use unsigned for pad index
Date: Fri, 11 Dec 2015 12:26:45 -0200
Message-Id: <cc589da759a48477b8283eba3b61568f85ca14ef.1449843997.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The pad index is unsigned. Replace the occurences of it where
pertinent.

Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/platform/omap3isp/ispccdc.c          | 2 +-
 drivers/media/platform/omap3isp/ispccp2.c          | 2 +-
 drivers/media/platform/omap3isp/ispcsi2.c          | 2 +-
 drivers/media/platform/omap3isp/isppreview.c       | 2 +-
 drivers/media/platform/omap3isp/ispresizer.c       | 2 +-
 drivers/staging/media/davinci_vpfe/dm365_ipipeif.c | 2 +-
 drivers/staging/media/davinci_vpfe/dm365_isif.c    | 2 +-
 drivers/staging/media/davinci_vpfe/dm365_resizer.c | 2 +-
 drivers/staging/media/omap4iss/iss_csi2.c          | 2 +-
 drivers/staging/media/omap4iss/iss_ipipeif.c       | 2 +-
 drivers/staging/media/omap4iss/iss_resizer.c       | 2 +-
 11 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispccdc.c b/drivers/media/platform/omap3isp/ispccdc.c
index dae674cd3f74..749462c1af8e 100644
--- a/drivers/media/platform/omap3isp/ispccdc.c
+++ b/drivers/media/platform/omap3isp/ispccdc.c
@@ -2513,7 +2513,7 @@ static int ccdc_link_setup(struct media_entity *entity,
 	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
 	struct isp_ccdc_device *ccdc = v4l2_get_subdevdata(sd);
 	struct isp_device *isp = to_isp_device(ccdc);
-	int index = local->index;
+	unsigned int index = local->index;
 
 	/* FIXME: this is actually a hack! */
 	if (is_media_entity_v4l2_subdev(remote->entity))
diff --git a/drivers/media/platform/omap3isp/ispccp2.c b/drivers/media/platform/omap3isp/ispccp2.c
index 0c790b25f6f9..59686dd1bb0a 100644
--- a/drivers/media/platform/omap3isp/ispccp2.c
+++ b/drivers/media/platform/omap3isp/ispccp2.c
@@ -956,7 +956,7 @@ static int ccp2_link_setup(struct media_entity *entity,
 {
 	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
 	struct isp_ccp2_device *ccp2 = v4l2_get_subdevdata(sd);
-	int index = local->index;
+	unsigned int index = local->index;
 
 	/* FIXME: this is actually a hack! */
 	if (is_media_entity_v4l2_subdev(remote->entity))
diff --git a/drivers/media/platform/omap3isp/ispcsi2.c b/drivers/media/platform/omap3isp/ispcsi2.c
index f50f6b305204..886f148755b0 100644
--- a/drivers/media/platform/omap3isp/ispcsi2.c
+++ b/drivers/media/platform/omap3isp/ispcsi2.c
@@ -1144,7 +1144,7 @@ static int csi2_link_setup(struct media_entity *entity,
 	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
 	struct isp_csi2_device *csi2 = v4l2_get_subdevdata(sd);
 	struct isp_csi2_ctrl_cfg *ctrl = &csi2->ctrl;
-	int index = local->index;
+	unsigned int index = local->index;
 
 	/*
 	 * The ISP core doesn't support pipelines with multiple video outputs.
diff --git a/drivers/media/platform/omap3isp/isppreview.c b/drivers/media/platform/omap3isp/isppreview.c
index c300cb7219e9..e15ad4133632 100644
--- a/drivers/media/platform/omap3isp/isppreview.c
+++ b/drivers/media/platform/omap3isp/isppreview.c
@@ -2144,7 +2144,7 @@ static int preview_link_setup(struct media_entity *entity,
 {
 	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
 	struct isp_prev_device *prev = v4l2_get_subdevdata(sd);
-	int index = local->index;
+	unsigned int index = local->index;
 
 	/* FIXME: this is actually a hack! */
 	if (is_media_entity_v4l2_subdev(remote->entity))
diff --git a/drivers/media/platform/omap3isp/ispresizer.c b/drivers/media/platform/omap3isp/ispresizer.c
index cd0a9f6e1fed..20b98d876d7e 100644
--- a/drivers/media/platform/omap3isp/ispresizer.c
+++ b/drivers/media/platform/omap3isp/ispresizer.c
@@ -1623,7 +1623,7 @@ static int resizer_link_setup(struct media_entity *entity,
 {
 	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
 	struct isp_res_device *res = v4l2_get_subdevdata(sd);
-	int index = local->index;
+	unsigned int index = local->index;
 
 	/* FIXME: this is actually a hack! */
 	if (is_media_entity_v4l2_subdev(remote->entity))
diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c b/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
index a54c60fce3d5..633d6456fdce 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
@@ -885,7 +885,7 @@ ipipeif_link_setup(struct media_entity *entity, const struct media_pad *local,
 	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
 	struct vpfe_ipipeif_device *ipipeif = v4l2_get_subdevdata(sd);
 	struct vpfe_device *vpfe = to_vpfe_device(ipipeif);
-	int index = local->index;
+	unsigned int index = local->index;
 
 	/* FIXME: this is actually a hack! */
 	if (is_media_entity_v4l2_subdev(remote->entity))
diff --git a/drivers/staging/media/davinci_vpfe/dm365_isif.c b/drivers/staging/media/davinci_vpfe/dm365_isif.c
index b35667afb73f..99057892d88d 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_isif.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_isif.c
@@ -1707,7 +1707,7 @@ isif_link_setup(struct media_entity *entity, const struct media_pad *local,
 {
 	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
 	struct vpfe_isif_device *isif = v4l2_get_subdevdata(sd);
-	int index = local->index;
+	unsigned int index = local->index;
 
 	/* FIXME: this is actually a hack! */
 	if (is_media_entity_v4l2_subdev(remote->entity))
diff --git a/drivers/staging/media/davinci_vpfe/dm365_resizer.c b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
index 669ae3f9791f..a91395ce91e1 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_resizer.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
@@ -1648,7 +1648,7 @@ static int resizer_link_setup(struct media_entity *entity,
 	struct vpfe_device *vpfe_dev = to_vpfe_device(resizer);
 	u16 ipipeif_source = vpfe_dev->vpfe_ipipeif.output;
 	u16 ipipe_source = vpfe_dev->vpfe_ipipe.output;
-	int index = local->index;
+	unsigned int index = local->index;
 
 	/* FIXME: this is actually a hack! */
 	if (is_media_entity_v4l2_subdev(remote->entity))
diff --git a/drivers/staging/media/omap4iss/iss_csi2.c b/drivers/staging/media/omap4iss/iss_csi2.c
index 226366a03661..f0fa037ce173 100644
--- a/drivers/staging/media/omap4iss/iss_csi2.c
+++ b/drivers/staging/media/omap4iss/iss_csi2.c
@@ -1170,7 +1170,7 @@ static int csi2_link_setup(struct media_entity *entity,
 	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
 	struct iss_csi2_device *csi2 = v4l2_get_subdevdata(sd);
 	struct iss_csi2_ctrl_cfg *ctrl = &csi2->ctrl;
-	int index = local->index;
+	unsigned int index = local->index;
 
 	/* FIXME: this is actually a hack! */
 	if (is_media_entity_v4l2_subdev(remote->entity))
diff --git a/drivers/staging/media/omap4iss/iss_ipipeif.c b/drivers/staging/media/omap4iss/iss_ipipeif.c
index c2b5638a0898..88b22f7f8b13 100644
--- a/drivers/staging/media/omap4iss/iss_ipipeif.c
+++ b/drivers/staging/media/omap4iss/iss_ipipeif.c
@@ -662,7 +662,7 @@ static int ipipeif_link_setup(struct media_entity *entity,
 	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
 	struct iss_ipipeif_device *ipipeif = v4l2_get_subdevdata(sd);
 	struct iss_device *iss = to_iss_device(ipipeif);
-	int index = local->index;
+	unsigned int index = local->index;
 
 	/* FIXME: this is actually a hack! */
 	if (is_media_entity_v4l2_subdev(remote->entity))
diff --git a/drivers/staging/media/omap4iss/iss_resizer.c b/drivers/staging/media/omap4iss/iss_resizer.c
index fea13ab4041f..fe7b253bb0d3 100644
--- a/drivers/staging/media/omap4iss/iss_resizer.c
+++ b/drivers/staging/media/omap4iss/iss_resizer.c
@@ -716,7 +716,7 @@ static int resizer_link_setup(struct media_entity *entity,
 	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
 	struct iss_resizer_device *resizer = v4l2_get_subdevdata(sd);
 	struct iss_device *iss = to_iss_device(resizer);
-	int index = local->index;
+	unsigned int index = local->index;
 
 	/* FIXME: this is actually a hack! */
 	if (is_media_entity_v4l2_subdev(remote->entity))
-- 
2.5.0

