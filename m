Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36541 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbbEHBMt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 May 2015 21:12:49 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	devel@driverdev.osuosl.org
Subject: [PATCH 15/18] omap4iss: stop MEDIA_ENT_T_V4L2_SUBDEV abuse
Date: Thu,  7 May 2015 22:12:37 -0300
Message-Id: <6bedd5838eea6a475cff45b62682d0bfe6c35383.1431046915.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1431046915.git.mchehab@osg.samsung.com>
References: <cover.1431046915.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1431046915.git.mchehab@osg.samsung.com>
References: <cover.1431046915.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver is abusing MEDIA_ENT_T_V4L2_SUBDEV, as it uses a
hack to check if the remote entity is a subdev. Get rid of it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/staging/media/omap4iss/iss_ipipe.c b/drivers/staging/media/omap4iss/iss_ipipe.c
index eaa82da30f50..2c809e7a8da6 100644
--- a/drivers/staging/media/omap4iss/iss_ipipe.c
+++ b/drivers/staging/media/omap4iss/iss_ipipe.c
@@ -439,8 +439,11 @@ static int ipipe_link_setup(struct media_entity *entity,
 	struct iss_ipipe_device *ipipe = v4l2_get_subdevdata(sd);
 	struct iss_device *iss = to_iss_device(ipipe);
 
+	if (!is_media_entity_v4l2_subdev(remote->entity))
+		return -EINVAL;
+
 	switch (local->index | media_entity_type(remote->entity)) {
-	case IPIPE_PAD_SINK | MEDIA_ENT_T_V4L2_SUBDEV:
+	case IPIPE_PAD_SINK:
 		/* Read from IPIPEIF. */
 		if (!(flags & MEDIA_LNK_FL_ENABLED)) {
 			ipipe->input = IPIPE_INPUT_NONE;
@@ -455,7 +458,7 @@ static int ipipe_link_setup(struct media_entity *entity,
 
 		break;
 
-	case IPIPE_PAD_SOURCE_VP | MEDIA_ENT_T_V4L2_SUBDEV:
+	case IPIPE_PAD_SOURCE_VP:
 		/* Send to RESIZER */
 		if (flags & MEDIA_LNK_FL_ENABLED) {
 			if (ipipe->output & ~IPIPE_OUTPUT_VP)
-- 
2.1.0

