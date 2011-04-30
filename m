Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59810 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756881Ab1D3Ndo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Apr 2011 09:33:44 -0400
Received: from localhost.localdomain (unknown [91.178.80.7])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 0072735B55
	for <linux-media@vger.kernel.org>; Sat, 30 Apr 2011 13:33:41 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 4/4] v4l: Release module if subdev registration fails
Date: Sat, 30 Apr 2011 15:34:05 +0200
Message-Id: <1304170445-11978-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1304170445-11978-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1304170445-11978-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

If v4l2_device_register_subdev() fails, the reference to the subdev
module taken by the function isn't released. Fix this.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: stable@kernel.org
Acked-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/v4l2-device.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/v4l2-device.c b/drivers/media/video/v4l2-device.c
index 5aeaf87..4aae501 100644
--- a/drivers/media/video/v4l2-device.c
+++ b/drivers/media/video/v4l2-device.c
@@ -155,8 +155,10 @@ int v4l2_device_register_subdev(struct v4l2_device *v4l2_dev,
 	sd->v4l2_dev = v4l2_dev;
 	if (sd->internal_ops && sd->internal_ops->registered) {
 		err = sd->internal_ops->registered(sd);
-		if (err)
+		if (err) {
+			module_put(sd->owner);
 			return err;
+		}
 	}
 
 	/* This just returns 0 if either of the two args is NULL */
@@ -164,6 +166,7 @@ int v4l2_device_register_subdev(struct v4l2_device *v4l2_dev,
 	if (err) {
 		if (sd->internal_ops && sd->internal_ops->unregistered)
 			sd->internal_ops->unregistered(sd);
+		module_put(sd->owner);
 		return err;
 	}
 
-- 
1.7.3.4

