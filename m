Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36608 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbbEHBMy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 May 2015 21:12:54 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	"Prabhakar Lad" <prabhakar.csengg@gmail.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>,
	Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>,
	devel@driverdev.osuosl.org
Subject: [PATCH 14/18] davinci_vbpe: stop MEDIA_ENT_T_V4L2_SUBDEV abuse
Date: Thu,  7 May 2015 22:12:36 -0300
Message-Id: <b619844482d48808d9e532cc18cec961799b9b16.1431046915.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1431046915.git.mchehab@osg.samsung.com>
References: <cover.1431046915.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1431046915.git.mchehab@osg.samsung.com>
References: <cover.1431046915.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver is abusing MEDIA_ENT_T_V4L2_SUBDEV:

- it uses a hack to check if the remote entity is a subdev;
- it still uses the legacy entity subtype check macro, that
  will be removed soon.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
index 1bbb90ce0086..220aa30d5e5d 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
@@ -1711,8 +1711,11 @@ ipipe_link_setup(struct media_entity *entity, const struct media_pad *local,
 	struct vpfe_device *vpfe_dev = to_vpfe_device(ipipe);
 	u16 ipipeif_sink = vpfe_dev->vpfe_ipipeif.input;
 
-	switch (local->index | media_entity_type(remote->entity)) {
-	case IPIPE_PAD_SINK | MEDIA_ENT_T_V4L2_SUBDEV:
+	if (!is_media_entity_v4l2_subdev(remote->entity))
+		return -EINVAL;
+
+	switch (local->index) {
+	case IPIPE_PAD_SINK:
 		if (!(flags & MEDIA_LNK_FL_ENABLED)) {
 			ipipe->input = IPIPE_INPUT_NONE;
 			break;
@@ -1725,7 +1728,7 @@ ipipe_link_setup(struct media_entity *entity, const struct media_pad *local,
 			ipipe->input = IPIPE_INPUT_CCDC;
 		break;
 
-	case IPIPE_PAD_SOURCE | MEDIA_ENT_T_V4L2_SUBDEV:
+	case IPIPE_PAD_SOURCE:
 		/* out to RESIZER */
 		if (flags & MEDIA_LNK_FL_ENABLED)
 			ipipe->output = IPIPE_OUTPUT_RESIZER;
diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
index 429bec44d1a3..ed9338fa9eb1 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
@@ -91,7 +91,7 @@ vpfe_video_remote_subdev(struct vpfe_video_device *video, u32 *pad)
 {
 	struct media_pad *remote = media_entity_remote_pad(&video->pad);
 
-	if (remote == NULL || remote->entity->type != MEDIA_ENT_T_V4L2_SUBDEV)
+	if (!is_media_entity_v4l2_subdev(remote->entity))
 		return NULL;
 	if (pad)
 		*pad = remote->index;
@@ -246,8 +246,7 @@ static int vpfe_video_validate_pipeline(struct vpfe_pipeline *pipe)
 
 		/* Retrieve the source format */
 		pad = media_entity_remote_pad(pad);
-		if (pad == NULL ||
-			pad->entity->type != MEDIA_ENT_T_V4L2_SUBDEV)
+		if (!is_media_entity_v4l2_subdev(pad->entity))
 			break;
 
 		subdev = media_entity_to_v4l2_subdev(pad->entity);
-- 
2.1.0

