Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:34962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S975695AbdDXSOg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Apr 2017 14:14:36 -0400
From: Kieran Bingham <kbingham@kernel.org>
To: niklas.soderlund@ragnatech.se
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH 2/2] rcar-vin: group: use correct of_node
Date: Mon, 24 Apr 2017 19:14:26 +0100
Message-Id: <1493057666-27961-1-git-send-email-kbingham@kernel.org>
In-Reply-To: <20170314190308.25790-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170314190308.25790-1-niklas.soderlund+renesas@ragnatech.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

The unbind function dereferences the subdev->dev node to obtain the
of_node. In error paths, the subdev->dev can be set to NULL, whilst the
correct reference to the of_node is available as subdev->of_node.

Correct the dereferencing, and move the variable outside of the loop as
it is constant against the subdev, and not initialised per CSI, for both
the bind and unbind functions

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 48557628e76d..a530dc388b95 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -469,7 +469,7 @@ static int rvin_digital_notify_bound(struct v4l2_async_notifier *notifier,
 
 	v4l2_set_subdev_hostdata(subdev, vin);
 
-	if (vin->digital.asd.match.of.node == subdev->dev->of_node) {
+	if (vin->digital.asd.match.of.node == subdev->of_node) {
 		/* Find surce and sink pad of remote subdevice */
 
 		ret = rvin_find_pad(subdev, MEDIA_PAD_FL_SOURCE);
@@ -738,12 +738,11 @@ static void rvin_group_notify_unbind(struct v4l2_async_notifier *notifier,
 				     struct v4l2_async_subdev *asd)
 {
 	struct rvin_dev *vin = notifier_to_vin(notifier);
+	struct device_node *del = subdev->of_node;
 	unsigned int i;
 
 	mutex_lock(&vin->group->lock);
 	for (i = 0; i < RVIN_CSI_MAX; i++) {
-		struct device_node *del = subdev->dev->of_node;
-
 		if (vin->group->bridge[i].asd.match.of.node == del) {
 			vin_dbg(vin, "Unbind bridge %s\n", subdev->name);
 			vin->group->bridge[i].subdev = NULL;
@@ -768,13 +767,13 @@ static int rvin_group_notify_bound(struct v4l2_async_notifier *notifier,
 				   struct v4l2_async_subdev *asd)
 {
 	struct rvin_dev *vin = notifier_to_vin(notifier);
+	struct device_node *new = subdev->of_node;
 	unsigned int i;
 
 	v4l2_set_subdev_hostdata(subdev, vin);
 
 	mutex_lock(&vin->group->lock);
 	for (i = 0; i < RVIN_CSI_MAX; i++) {
-		struct device_node *new = subdev->dev->of_node;
 
 		if (vin->group->bridge[i].asd.match.of.node == new) {
 			vin_dbg(vin, "Bound bridge %s\n", subdev->name);
-- 
2.7.4
