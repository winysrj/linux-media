Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48553 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331AbbH3DHx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Aug 2015 23:07:53 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	devel@driverdev.osuosl.org
Subject: [PATCH v8 37/55] [media] omap4iss: stop MEDIA_ENT_T_V4L2_SUBDEV abuse
Date: Sun, 30 Aug 2015 00:06:48 -0300
Message-Id: <ac6f2a7a8afe83affe3b688e8b8f509987a13c96.1440902901.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440902901.git.mchehab@osg.samsung.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440902901.git.mchehab@osg.samsung.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver is abusing MEDIA_ENT_T_V4L2_SUBDEV, as it uses a
hack to check if the remote entity is a subdev. Get rid of it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/staging/media/omap4iss/iss_ipipe.c b/drivers/staging/media/omap4iss/iss_ipipe.c
index e1a7b7ba7362..eb91ec48a21e 100644
--- a/drivers/staging/media/omap4iss/iss_ipipe.c
+++ b/drivers/staging/media/omap4iss/iss_ipipe.c
@@ -447,8 +447,11 @@ static int ipipe_link_setup(struct media_entity *entity,
 	struct iss_ipipe_device *ipipe = v4l2_get_subdevdata(sd);
 	struct iss_device *iss = to_iss_device(ipipe);
 
-	switch (local->index | media_entity_type(remote->entity)) {
-	case IPIPE_PAD_SINK | MEDIA_ENT_T_V4L2_SUBDEV:
+	if (!is_media_entity_v4l2_subdev(remote->entity))
+		return -EINVAL;
+
+	switch (local->index) {
+	case IPIPE_PAD_SINK:
 		/* Read from IPIPEIF. */
 		if (!(flags & MEDIA_LNK_FL_ENABLED)) {
 			ipipe->input = IPIPE_INPUT_NONE;
@@ -463,7 +466,7 @@ static int ipipe_link_setup(struct media_entity *entity,
 
 		break;
 
-	case IPIPE_PAD_SOURCE_VP | MEDIA_ENT_T_V4L2_SUBDEV:
+	case IPIPE_PAD_SOURCE_VP:
 		/* Send to RESIZER */
 		if (flags & MEDIA_LNK_FL_ENABLED) {
 			if (ipipe->output & ~IPIPE_OUTPUT_VP)
-- 
2.4.3

