Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:50115 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753219AbbCIVXT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 17:23:19 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: corbet@lwn.net, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 06/18] marvell-ccic: control handler fixes
Date: Mon,  9 Mar 2015 22:22:11 +0100
Message-Id: <1425936143-5658-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425936143-5658-1-git-send-email-hverkuil@xs4all.nl>
References: <1425936143-5658-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

No controls were reported, even though the ov7670 does have controls.

Two reasons for this: the v4l2_ctrl_handler_init() call must come
before the ov7670 is loaded (otherwise the ov7670 won't know that
its controls should be added to the bridge driver), and the
v4l2_ctrl_handler_free() call at the end should only be called if
the ret value is non-zero (otherwise you would just free all the
controls that were just added).

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/marvell-ccic/mcam-core.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 7e54cef..51c9c8c 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -1919,6 +1919,14 @@ int mccic_register(struct mcam_camera *cam)
 	mcam_ctlr_init(cam);
 
 	/*
+	 * Get the v4l2 setup done.
+	 */
+	ret = v4l2_ctrl_handler_init(&cam->ctrl_handler, 10);
+	if (ret)
+		goto out_unregister;
+	cam->v4l2_dev.ctrl_handler = &cam->ctrl_handler;
+
+	/*
 	 * Try to find the sensor.
 	 */
 	sensor_cfg.clock_speed = cam->clock_speed;
@@ -1934,13 +1942,6 @@ int mccic_register(struct mcam_camera *cam)
 	ret = mcam_cam_init(cam);
 	if (ret)
 		goto out_unregister;
-	/*
-	 * Get the v4l2 setup done.
-	 */
-	ret = v4l2_ctrl_handler_init(&cam->ctrl_handler, 10);
-	if (ret)
-		goto out_unregister;
-	cam->v4l2_dev.ctrl_handler = &cam->ctrl_handler;
 
 	mutex_lock(&cam->s_mutex);
 	cam->vdev = mcam_v4l_template;
@@ -1960,10 +1961,12 @@ int mccic_register(struct mcam_camera *cam)
 	}
 
 out:
-	v4l2_ctrl_handler_free(&cam->ctrl_handler);
+	if (ret)
+		v4l2_ctrl_handler_free(&cam->ctrl_handler);
 	mutex_unlock(&cam->s_mutex);
 	return ret;
 out_unregister:
+	v4l2_ctrl_handler_free(&cam->ctrl_handler);
 	v4l2_device_unregister(&cam->v4l2_dev);
 	return ret;
 }
-- 
2.1.4

