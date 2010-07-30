Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:60505 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633Ab0G3UZC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Jul 2010 16:25:02 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl
Subject: [PATCH 2/2] v4l: Add a v4l2_subdev host private data field
Date: Fri, 30 Jul 2010 22:24:55 +0200
Message-Id: <1280521495-19922-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1280521495-19922-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1280521495-19922-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The existing priv field stores subdev private data owned by the subdev
driver. Host (bridge) drivers might need to store per-subdev
host-specific data, such as a pointer to platform data.

Add a v4l2_subdev host_priv field to store host-specific data, and
rename the existing priv field to dev_priv.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 Documentation/video4linux/v4l2-framework.txt |    5 +++++
 include/media/v4l2-subdev.h                  |   20 ++++++++++++++++----
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/Documentation/video4linux/v4l2-framework.txt b/Documentation/video4linux/v4l2-framework.txt
index e831aac..f5fdb39 100644
--- a/Documentation/video4linux/v4l2-framework.txt
+++ b/Documentation/video4linux/v4l2-framework.txt
@@ -192,6 +192,11 @@ You also need a way to go from the low-level struct to v4l2_subdev. For the
 common i2c_client struct the i2c_set_clientdata() call is used to store a
 v4l2_subdev pointer, for other busses you may have to use other methods.
 
+Bridges might also need to store per-subdev private data, such as a pointer to
+bridge-specific per-subdev private data. The v4l2_subdev structure provides
+host private data for that purpose that can be accessed with
+v4l2_get_subdev_hostdata() and v4l2_set_subdev_hostdata().
+
 From the bridge driver perspective you load the sub-device module and somehow
 obtain the v4l2_subdev pointer. For i2c devices this is easy: you call
 i2c_get_clientdata(). For other busses something similar needs to be done.
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 02c6f4d..fcdd247 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -420,17 +420,28 @@ struct v4l2_subdev {
 	/* can be used to group similar subdevs, value is driver-specific */
 	u32 grp_id;
 	/* pointer to private data */
-	void *priv;
+	void *dev_priv;
+	void *host_priv;
 };
 
 static inline void v4l2_set_subdevdata(struct v4l2_subdev *sd, void *p)
 {
-	sd->priv = p;
+	sd->dev_priv = p;
 }
 
 static inline void *v4l2_get_subdevdata(const struct v4l2_subdev *sd)
 {
-	return sd->priv;
+	return sd->dev_priv;
+}
+
+static inline void v4l2_set_subdev_hostdata(struct v4l2_subdev *sd, void *p)
+{
+	sd->host_priv = p;
+}
+
+static inline void *v4l2_get_subdev_hostdata(const struct v4l2_subdev *sd)
+{
+	return sd->host_priv;
 }
 
 static inline void v4l2_subdev_init(struct v4l2_subdev *sd,
@@ -444,7 +455,8 @@ static inline void v4l2_subdev_init(struct v4l2_subdev *sd,
 	sd->flags = 0;
 	sd->name[0] = '\0';
 	sd->grp_id = 0;
-	sd->priv = NULL;
+	sd->dev_priv = NULL;
+	sd->host_priv = NULL;
 }
 
 /* Call an ops of a v4l2_subdev, doing the right checks against
-- 
1.7.1

