Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:33610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1948377AbdDYOzF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Apr 2017 10:55:05 -0400
From: Kieran Bingham <kbingham@kernel.org>
To: niklas.soderlund@ragnatech.se
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH] rcar-vin: Use of_nodes as specified by the subdev
Date: Tue, 25 Apr 2017 15:55:00 +0100
Message-Id: <1493132100-31901-1-git-send-email-kbingham@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

The rvin_digital_notify_bound() call dereferences the subdev->dev
pointer to obtain the of_node. On some error paths, this dev node can be
set as NULL. The of_node is mapped into the subdevice structure on
initialisation, so this is a safer source to compare the nodes.

Dereference the of_node from the subdev structure instead of the dev
structure.

Fixes: 83fba2c06f19 ("rcar-vin: rework how subdevice is found and
	bound")
Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 5861ab281150..a530dc388b95 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -469,7 +469,7 @@ static int rvin_digital_notify_bound(struct v4l2_async_notifier *notifier,
 
 	v4l2_set_subdev_hostdata(subdev, vin);
 
-	if (vin->digital.asd.match.of.node == subdev->dev->of_node) {
+	if (vin->digital.asd.match.of.node == subdev->of_node) {
 		/* Find surce and sink pad of remote subdevice */
 
 		ret = rvin_find_pad(subdev, MEDIA_PAD_FL_SOURCE);
-- 
2.7.4
