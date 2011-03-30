Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51350 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789Ab1C3HsD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Mar 2011 03:48:03 -0400
Received: from localhost.localdomain (77.162-65-87.adsl-dyn.isp.belgacom.be [87.65.162.77])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id C375B35B86
	for <linux-media@vger.kernel.org>; Wed, 30 Mar 2011 07:48:01 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] v4l: Release module if subdev registration fails
Date: Wed, 30 Mar 2011 09:48:21 +0200
Message-Id: <1301471301-8946-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

If v4l2_device_register_subdev() fails, the reference to the subdev
module taken by the function isn't released. Fix this.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
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

