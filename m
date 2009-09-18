Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway16.websitewelcome.com ([69.56.239.11]:51479 "HELO
	gateway16.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758462AbZIRS35 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Sep 2009 14:29:57 -0400
Received: from [66.15.212.169] (port=30667 helo=[10.140.5.16])
	by gator886.hostgator.com with esmtpsa (SSLv3:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <pete@sensoray.com>)
	id 1Moi71-0002e1-Hk
	for linux-media@vger.kernel.org; Fri, 18 Sep 2009 13:23:15 -0500
Subject: [PATCH 3/9] go7007: Fix mpeg controls
From: Pete <pete@sensoray.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 18 Sep 2009 11:23:19 -0700
Message-Id: <1253298199.4314.567.camel@pete-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

MPEG controls were disabled by Mauro's ioctl conversion patch.  They are now
re-enabled and cleaned up.

Priority: normal

Signed-off-by: Pete Eberlein <pete@sensoray.com>

diff -r 19c623143852 -r e9801d1d9c6c linux/drivers/staging/go7007/go7007-v4l2.c
--- a/linux/drivers/staging/go7007/go7007-v4l2.c	Fri Sep 18 10:22:27 2009 -0700
+++ b/linux/drivers/staging/go7007/go7007-v4l2.c	Fri Sep 18 10:26:12 2009 -0700
@@ -383,13 +383,10 @@
 	}
 	return 0;
 }
+#endif
 
-static int mpeg_queryctrl(u32 id, struct v4l2_queryctrl *ctrl)
+static int mpeg_queryctrl(struct v4l2_queryctrl *ctrl)
 {
-	static const u32 user_ctrls[] = {
-		V4L2_CID_USER_CLASS,
-		0
-	};
 	static const u32 mpeg_ctrls[] = {
 		V4L2_CID_MPEG_CLASS,
 		V4L2_CID_MPEG_STREAM_TYPE,
@@ -401,26 +398,15 @@
 		0
 	};
 	static const u32 *ctrl_classes[] = {
-		user_ctrls,
 		mpeg_ctrls,
 		NULL
 	};
 
-	/* The ctrl may already contain the queried i2c controls,
-	 * query the mpeg controls if the existing ctrl id is
-	 * greater than the next mpeg ctrl id.
-	 */
-	id = v4l2_ctrl_next(ctrl_classes, id);
-	if (id >= ctrl->id && ctrl->name[0])
-		return 0;
-
-	memset(ctrl, 0, sizeof(*ctrl));
-	ctrl->id = id;
+	ctrl->id = v4l2_ctrl_next(ctrl_classes, ctrl->id);
 
 	switch (ctrl->id) {
-	case V4L2_CID_USER_CLASS:
 	case V4L2_CID_MPEG_CLASS:
-		return v4l2_ctrl_query_fill_std(ctrl);
+		return v4l2_ctrl_query_fill(ctrl, 0, 0, 0, 0);
 	case V4L2_CID_MPEG_STREAM_TYPE:
 		return v4l2_ctrl_query_fill(ctrl,
 				V4L2_MPEG_STREAM_TYPE_MPEG2_DVD,
@@ -437,20 +423,21 @@
 				V4L2_MPEG_VIDEO_ASPECT_16x9, 1,
 				V4L2_MPEG_VIDEO_ASPECT_1x1);
 	case V4L2_CID_MPEG_VIDEO_GOP_SIZE:
+		return v4l2_ctrl_query_fill(ctrl, 0, 34, 1, 15);
 	case V4L2_CID_MPEG_VIDEO_GOP_CLOSURE:
-		return v4l2_ctrl_query_fill_std(ctrl);
+		return v4l2_ctrl_query_fill(ctrl, 0, 1, 1, 0);
 	case V4L2_CID_MPEG_VIDEO_BITRATE:
 		return v4l2_ctrl_query_fill(ctrl,
 				64000,
 				10000000, 1,
-				9800000);
+				1500000);
 	default:
-		break;
+		return -EINVAL;
 	}
-	return -EINVAL;
+	return 0;
 }
 
-static int mpeg_s_control(struct v4l2_control *ctrl, struct go7007 *go)
+static int mpeg_s_ctrl(struct v4l2_control *ctrl, struct go7007 *go)
 {
 	/* pretty sure we can't change any of these while streaming */
 	if (go->streaming)
@@ -528,6 +515,8 @@
 		}
 		break;
 	case V4L2_CID_MPEG_VIDEO_GOP_SIZE:
+		if (ctrl->value < 0 || ctrl->value > 34)
+			return -EINVAL;
 		go->gop_size = ctrl->value;
 		break;
 	case V4L2_CID_MPEG_VIDEO_GOP_CLOSURE:
@@ -547,7 +536,7 @@
 	return 0;
 }
 
-static int mpeg_g_control(struct v4l2_control *ctrl, struct go7007 *go)
+static int mpeg_g_ctrl(struct v4l2_control *ctrl, struct go7007 *go)
 {
 	switch (ctrl->id) {
 	case V4L2_CID_MPEG_STREAM_TYPE:
@@ -600,7 +589,6 @@
 	}
 	return 0;
 }
-#endif
 
 static int vidioc_querycap(struct file *file, void  *priv,
 					struct v4l2_capability *cap)
@@ -996,7 +984,7 @@
 
 	i2c_clients_command(&go->i2c_adapter, VIDIOC_QUERYCTRL, query);
 
-	return (!query->name[0]) ? -EINVAL : 0;
+	return (!query->name[0]) ? mpeg_queryctrl(query) : 0;
 }
 
 static int vidioc_g_ctrl(struct file *file, void *priv,
@@ -1013,7 +1001,7 @@
 	query.id = ctrl->id;
 	i2c_clients_command(&go->i2c_adapter, VIDIOC_QUERYCTRL, &query);
 	if (query.name[0] == 0)
-		return -EINVAL;
+		return mpeg_g_ctrl(ctrl, go);
 	i2c_clients_command(&go->i2c_adapter, VIDIOC_G_CTRL, ctrl);
 
 	return 0;
@@ -1033,7 +1021,7 @@
 	query.id = ctrl->id;
 	i2c_clients_command(&go->i2c_adapter, VIDIOC_QUERYCTRL, &query);
 	if (query.name[0] == 0)
-		return -EINVAL;
+		return mpeg_s_ctrl(ctrl, go);
 	i2c_clients_command(&go->i2c_adapter, VIDIOC_S_CTRL, ctrl);
 
 	return 0;


