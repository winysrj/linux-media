Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:22317 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756972Ab2CFQd3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Mar 2012 11:33:29 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, dacohen@gmail.com,
	snjw23@gmail.com, andriy.shevchenko@linux.intel.com,
	t.stanislaws@samsung.com, tuukkat76@gmail.com,
	k.debski@samsung.com, riverful@gmail.com, hverkuil@xs4all.nl,
	teturtia@gmail.com, pradeep.sawlani@gmail.com
Subject: [PATCH v5 29/35] omap3isp: Default link validation for ccp2, csi2, preview and resizer
Date: Tue,  6 Mar 2012 18:33:10 +0200
Message-Id: <1331051596-8261-29-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20120306163239.GN1075@valkosipuli.localdomain>
References: <20120306163239.GN1075@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use default link validation for ccp2, csi2, preview and resizer. On ccp2,
csi2 and ccdc we also collect information on external subdevs as one may be
connected to those entities.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/omap3isp/ispccp2.c    |    1 +
 drivers/media/video/omap3isp/ispcsi2.c    |    1 +
 drivers/media/video/omap3isp/isppreview.c |    1 +
 drivers/media/video/omap3isp/ispresizer.c |    1 +
 4 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispccp2.c b/drivers/media/video/omap3isp/ispccp2.c
index 70ddbf3..41e807f 100644
--- a/drivers/media/video/omap3isp/ispccp2.c
+++ b/drivers/media/video/omap3isp/ispccp2.c
@@ -1021,6 +1021,7 @@ static int ccp2_link_setup(struct media_entity *entity,
 /* media operations */
 static const struct media_entity_operations ccp2_media_ops = {
 	.link_setup = ccp2_link_setup,
+	.link_validate = v4l2_subdev_link_validate,
 };
 
 /*
diff --git a/drivers/media/video/omap3isp/ispcsi2.c b/drivers/media/video/omap3isp/ispcsi2.c
index fcb5168..d2e1c92 100644
--- a/drivers/media/video/omap3isp/ispcsi2.c
+++ b/drivers/media/video/omap3isp/ispcsi2.c
@@ -1181,6 +1181,7 @@ static int csi2_link_setup(struct media_entity *entity,
 /* media operations */
 static const struct media_entity_operations csi2_media_ops = {
 	.link_setup = csi2_link_setup,
+	.link_validate = v4l2_subdev_link_validate,
 };
 
 void omap3isp_csi2_unregister_entities(struct isp_csi2_device *csi2)
diff --git a/drivers/media/video/omap3isp/isppreview.c b/drivers/media/video/omap3isp/isppreview.c
index 6d0fb2c..8545f0b 100644
--- a/drivers/media/video/omap3isp/isppreview.c
+++ b/drivers/media/video/omap3isp/isppreview.c
@@ -2076,6 +2076,7 @@ static int preview_link_setup(struct media_entity *entity,
 /* media operations */
 static const struct media_entity_operations preview_media_ops = {
 	.link_setup = preview_link_setup,
+	.link_validate = v4l2_subdev_link_validate,
 };
 
 void omap3isp_preview_unregister_entities(struct isp_prev_device *prev)
diff --git a/drivers/media/video/omap3isp/ispresizer.c b/drivers/media/video/omap3isp/ispresizer.c
index 6958a9e..0fc6525 100644
--- a/drivers/media/video/omap3isp/ispresizer.c
+++ b/drivers/media/video/omap3isp/ispresizer.c
@@ -1603,6 +1603,7 @@ static int resizer_link_setup(struct media_entity *entity,
 /* media operations */
 static const struct media_entity_operations resizer_media_ops = {
 	.link_setup = resizer_link_setup,
+	.link_validate = v4l2_subdev_link_validate,
 };
 
 void omap3isp_resizer_unregister_entities(struct isp_res_device *res)
-- 
1.7.2.5

