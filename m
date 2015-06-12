Return-Path: <ricardo.ribalda@gmail.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
 Sakari Ailus <sakari.ailus@linux.intel.com>,
 Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
 Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
 Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linux-media@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [RFC v3 08/19] v4l2-subdev: Add g_def_ext_ctrls to core_ops
Date: Fri, 12 Jun 2015 18:46:27 +0200
Message-id: <1434127598-11719-9-git-send-email-ricardo.ribalda@gmail.com>
In-reply-to: <1434127598-11719-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1434127598-11719-1-git-send-email-ricardo.ribalda@gmail.com>
MIME-version: 1.0
Content-type: text/plain
List-ID: <linux-media.vger.kernel.org>

This function returns the default value of an extended control. Provides
sub-devices with the same functionality as ioctl VIDIOC_G_DEF_EXT_CTRLS.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 7 +++++++
 include/media/v4l2-ctrls.h           | 2 ++
 include/media/v4l2-subdev.h          | 2 ++
 3 files changed, 11 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 02ff6f573fd2..2a42b826f857 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -2888,6 +2888,13 @@ int v4l2_subdev_g_ext_ctrls(struct v4l2_subdev *sd, struct v4l2_ext_controls *cs
 }
 EXPORT_SYMBOL(v4l2_subdev_g_ext_ctrls);
 
+int v4l2_subdev_g_def_ext_ctrls(struct v4l2_subdev *sd,
+				struct v4l2_ext_controls *cs)
+{
+	return v4l2_g_ext_ctrls(sd->ctrl_handler, cs, true);
+}
+EXPORT_SYMBOL(v4l2_subdev_g_def_ext_ctrls);
+
 /* Helper function to get a single control */
 static int get_ctrl(struct v4l2_ctrl *ctrl, struct v4l2_ext_control *c)
 {
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 16f16b67181b..61e6cd67fc10 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -823,6 +823,8 @@ int v4l2_s_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
 int v4l2_subdev_queryctrl(struct v4l2_subdev *sd, struct v4l2_queryctrl *qc);
 int v4l2_subdev_querymenu(struct v4l2_subdev *sd, struct v4l2_querymenu *qm);
 int v4l2_subdev_g_ext_ctrls(struct v4l2_subdev *sd, struct v4l2_ext_controls *cs);
+int v4l2_subdev_g_def_ext_ctrls(struct v4l2_subdev *sd,
+				struct v4l2_ext_controls *cs);
 int v4l2_subdev_try_ext_ctrls(struct v4l2_subdev *sd, struct v4l2_ext_controls *cs);
 int v4l2_subdev_s_ext_ctrls(struct v4l2_subdev *sd, struct v4l2_ext_controls *cs);
 int v4l2_subdev_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl);
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index dc20102ff600..01b3354942cf 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -158,6 +158,8 @@ struct v4l2_subdev_core_ops {
 	int (*g_ctrl)(struct v4l2_subdev *sd, struct v4l2_control *ctrl);
 	int (*s_ctrl)(struct v4l2_subdev *sd, struct v4l2_control *ctrl);
 	int (*g_ext_ctrls)(struct v4l2_subdev *sd, struct v4l2_ext_controls *ctrls);
+	int (*g_def_ext_ctrls)(struct v4l2_subdev *sd,
+			       struct v4l2_ext_controls *ctrls);
 	int (*s_ext_ctrls)(struct v4l2_subdev *sd, struct v4l2_ext_controls *ctrls);
 	int (*try_ext_ctrls)(struct v4l2_subdev *sd, struct v4l2_ext_controls *ctrls);
 	int (*querymenu)(struct v4l2_subdev *sd, struct v4l2_querymenu *qm);
-- 
2.1.4
