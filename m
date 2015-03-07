Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:44673 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbbCGPaz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Mar 2015 10:30:55 -0500
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 1/2] media: am437x-vpfe: match the OF node/i2c addr instead of name
Date: Sat,  7 Mar 2015 15:30:49 +0000
Message-Id: <1425742250-24404-2-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1425742250-24404-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1425742250-24404-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

Instead of matching the subdevs with their name, match
it with OF node/ i2c address and adapter number.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/am437x/am437x-vpfe.c | 27 +++++++++++----------------
 drivers/media/platform/am437x/am437x-vpfe.h |  1 -
 2 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
index 8166b38..3d59ae0 100644
--- a/drivers/media/platform/am437x/am437x-vpfe.c
+++ b/drivers/media/platform/am437x/am437x-vpfe.c
@@ -1701,11 +1701,16 @@ static int vpfe_get_app_input_index(struct vpfe_device *vpfe,
 {
 	struct vpfe_config *cfg = vpfe->cfg;
 	struct vpfe_subdev_info *sdinfo;
+	struct i2c_client *client;
+	struct i2c_client *curr_client;
 	int i, j = 0;
 
+	curr_client = v4l2_get_subdevdata(vpfe->current_subdev->sd);
 	for (i = 0; i < ARRAY_SIZE(vpfe->cfg->asd); i++) {
 		sdinfo = &cfg->sub_devs[i];
-		if (!strcmp(sdinfo->name, vpfe->current_subdev->name)) {
+		client = v4l2_get_subdevdata(sdinfo->sd);
+		if (client->addr == curr_client->addr &&
+		    client->adapter->nr == client->adapter->nr) {
 			if (vpfe->current_input >= 1)
 				return -1;
 			*app_input_index = j + vpfe->current_input;
@@ -2297,20 +2302,10 @@ vpfe_async_bound(struct v4l2_async_notifier *notifier,
 	vpfe_dbg(1, vpfe, "vpfe_async_bound\n");
 
 	for (i = 0; i < ARRAY_SIZE(vpfe->cfg->asd); i++) {
-		sdinfo = &vpfe->cfg->sub_devs[i];
-
-		if (!strcmp(sdinfo->name, subdev->name)) {
+		if (vpfe->cfg->asd[i]->match.of.node == asd[i].match.of.node) {
+			sdinfo = &vpfe->cfg->sub_devs[i];
 			vpfe->sd[i] = subdev;
-			vpfe_info(vpfe,
-				 "v4l2 sub device %s registered\n",
-				 subdev->name);
-			vpfe->sd[i]->grp_id =
-					sdinfo->grp_id;
-			/* update tvnorms from the sub devices */
-			for (j = 0; j < 1; j++)
-				vpfe->video_dev->tvnorms |=
-					sdinfo->inputs[j].std;
-
+			vpfe->sd[i]->grp_id = sdinfo->grp_id;
 			found = true;
 			break;
 		}
@@ -2321,6 +2316,8 @@ vpfe_async_bound(struct v4l2_async_notifier *notifier,
 		return -EINVAL;
 	}
 
+	vpfe->video_dev->tvnorms |= sdinfo->inputs[0].std;
+
 	/* setup the supported formats & indexes */
 	for (j = 0, i = 0; ; ++j) {
 		struct vpfe_fmt *fmt;
@@ -2501,8 +2498,6 @@ vpfe_get_pdata(struct platform_device *pdev)
 			goto done;
 		}
 
-		strncpy(sdinfo->name, rem->name, sizeof(sdinfo->name));
-
 		pdata->asd[i] = devm_kzalloc(&pdev->dev,
 					     sizeof(struct v4l2_async_subdev),
 					     GFP_KERNEL);
diff --git a/drivers/media/platform/am437x/am437x-vpfe.h b/drivers/media/platform/am437x/am437x-vpfe.h
index 0f55735..956fb9e 100644
--- a/drivers/media/platform/am437x/am437x-vpfe.h
+++ b/drivers/media/platform/am437x/am437x-vpfe.h
@@ -83,7 +83,6 @@ struct vpfe_route {
 };
 
 struct vpfe_subdev_info {
-	 char name[32];
 	/* Sub device group id */
 	int grp_id;
 	/* inputs available at the sub device */
-- 
2.1.0

