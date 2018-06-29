Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:37118 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936821AbeF2SxE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Jun 2018 14:53:04 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 11/17] media: staging/imx: Loop through all registered subdevs for media links
Date: Fri, 29 Jun 2018 11:49:55 -0700
Message-Id: <1530298220-5097-12-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1530298220-5097-1-git-send-email-steve_longerbeam@mentor.com>
References: <1530298220-5097-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The root imx-media notifier no longer sees all bound subdevices because
some of them will be bound to subdev notifiers. So imx_media_create_links()
now needs to loop through all subdevices registered with the v4l2-device,
not just the ones in the root notifier's done list. This should be safe
because imx_media_create_of_links() checks if a fwnode link already
exists before creating.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/media/imx/imx-media-dev.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
index b0be80f..ae87c81 100644
--- a/drivers/staging/media/imx/imx-media-dev.c
+++ b/drivers/staging/media/imx/imx-media-dev.c
@@ -175,7 +175,7 @@ static int imx_media_subdev_bound(struct v4l2_async_notifier *notifier,
 }
 
 /*
- * create the media links for all subdevs that registered async.
+ * Create the media links for all subdevs that registered.
  * Called after all async subdevs have bound.
  */
 static int imx_media_create_links(struct v4l2_async_notifier *notifier)
@@ -184,14 +184,7 @@ static int imx_media_create_links(struct v4l2_async_notifier *notifier)
 	struct v4l2_subdev *sd;
 	int ret;
 
-	/*
-	 * Only links are created between subdevices that are known
-	 * to the async notifier. If there are other non-async subdevices,
-	 * they were created internally by some subdevice (smiapp is one
-	 * example). In those cases it is expected the subdevice is
-	 * responsible for creating those internal links.
-	 */
-	list_for_each_entry(sd, &notifier->done, async_list) {
+	list_for_each_entry(sd, &imxmd->v4l2_dev.subdevs, list) {
 		switch (sd->grp_id) {
 		case IMX_MEDIA_GRP_ID_VDIC:
 		case IMX_MEDIA_GRP_ID_IC_PRP:
@@ -211,7 +204,10 @@ static int imx_media_create_links(struct v4l2_async_notifier *notifier)
 				imx_media_create_csi_of_links(imxmd, sd);
 			break;
 		default:
-			/* this is an external fwnode subdev */
+			/*
+			 * if this subdev has fwnode links, create media
+			 * links for them.
+			 */
 			imx_media_create_of_links(imxmd, sd);
 			break;
 		}
-- 
2.7.4
