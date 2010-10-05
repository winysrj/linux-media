Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:60207 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717Ab0JENSo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Oct 2010 09:18:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [RFC/PATCH v2 3/6] V4L/DVB: v4l: Add a v4l2_subdev host private data field
Date: Tue,  5 Oct 2010 15:18:52 +0200
Message-Id: <1286284734-12292-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1286284734-12292-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1286284734-12292-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The existing priv field stores subdev private data owned by the subdev
driver. Host (bridge) drivers might need to store per-subdev
host-specific data, such as a pointer to platform data.

Add a v4l2_subdev host_priv field to store host-specific data, and
rename the existing priv field to dev_priv.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 Documentation/video4linux/v4l2-framework.txt |    5 +++++
 drivers/media/video/v4l2-subdev.c            |    3 ++-
 include/media/v4l2-subdev.h                  |   17 ++++++++++++++---
 3 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/Documentation/video4linux/v4l2-framework.txt b/Documentation/video4linux/v4l2-framework.txt
index 21bb837..9127a28 100644
--- a/Documentation/video4linux/v4l2-framework.txt
+++ b/Documentation/video4linux/v4l2-framework.txt
@@ -206,6 +206,11 @@ You also need a way to go from the low-level struct to v4l2_subdev. For the
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
diff --git a/drivers/media/video/v4l2-subdev.c b/drivers/media/video/v4l2-subdev.c
index 096644d..8e2e04f 100644
--- a/drivers/media/video/v4l2-subdev.c
+++ b/drivers/media/video/v4l2-subdev.c
@@ -304,7 +304,8 @@ void v4l2_subdev_init(struct v4l2_subdev *sd, const struct v4l2_subdev_ops *ops)
 	sd->flags = 0;
 	sd->name[0] = '\0';
 	sd->grp_id = 0;
-	sd->priv = NULL;
+	sd->dev_priv = NULL;
+	sd->host_priv = NULL;
 	sd->initialized = 1;
 	sd->entity.name = sd->name;
 	sd->entity.type = MEDIA_ENTITY_TYPE_SUBDEV;
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index c1f792e..4ea3cbb 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -483,7 +483,8 @@ struct v4l2_subdev {
 	/* can be used to group similar subdevs, value is driver-specific */
 	u32 grp_id;
 	/* pointer to private data */
-	void *priv;
+	void *dev_priv;
+	void *host_priv;
 	/* subdev device node */
 	struct video_device devnode;
 	unsigned int initialized;
@@ -524,12 +525,22 @@ extern const struct v4l2_file_operations v4l2_subdev_fops;
 
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
 
 void v4l2_subdev_init(struct v4l2_subdev *sd,
-- 
1.7.2.2

