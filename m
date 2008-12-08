Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB8IAhEr007123
	for <video4linux-list@redhat.com>; Mon, 8 Dec 2008 13:10:44 -0500
Received: from ey-out-2122.google.com (ey-out-2122.google.com [74.125.78.26])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB8IATUb023698
	for <video4linux-list@redhat.com>; Mon, 8 Dec 2008 13:10:29 -0500
Received: by ey-out-2122.google.com with SMTP id 4so464892eyf.39
	for <video4linux-list@redhat.com>; Mon, 08 Dec 2008 10:10:29 -0800 (PST)
From: Jaime Velasco Juan <jsagarribay@gmail.com>
To: mchehab@infradead.org
Date: Mon,  8 Dec 2008 18:10:26 +0000
Message-Id: <1228759826-11929-1-git-send-email-jsagarribay@gmail.com>
Cc: video4linux-list@redhat.com
Subject: [PATCH] stkwebcam: Implement VIDIOC_ENUM_FRAMESIZES ioctl
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

It is used at least by gstreamer.

Signed-off-by: Jaime Velasco Juan <jsagarribay@gmail.com>
---
 drivers/media/video/stk-webcam.c |   29 +++++++++++++++++++++++++++++
 1 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/stk-webcam.c b/drivers/media/video/stk-webcam.c
index e9eb6d7..4afa82f 100644
--- a/drivers/media/video/stk-webcam.c
+++ b/drivers/media/video/stk-webcam.c
@@ -1262,6 +1262,34 @@ static int stk_vidioc_g_parm(struct file *filp,
 	return 0;
 }
 
+static int stk_vidioc_enum_framesizes(struct file *filp,
+		void *priv, struct v4l2_frmsizeenum *frms)
+{
+	if (frms->index >= ARRAY_SIZE(stk_sizes))
+		return -EINVAL;
+	switch (frms->pixel_format) {
+	case V4L2_PIX_FMT_RGB565:
+	case V4L2_PIX_FMT_RGB565X:
+	case V4L2_PIX_FMT_UYVY:
+	case V4L2_PIX_FMT_YUYV:
+	case V4L2_PIX_FMT_SBGGR8:
+		frms->type = V4L2_FRMSIZE_TYPE_DISCRETE;
+		frms->discrete.width = stk_sizes[frms->index].w;
+		frms->discrete.height = stk_sizes[frms->index].h;
+		return 0;
+	default: return -EINVAL;
+	}
+}
+
+static int stk_vidioc_default(struct file *filp,
+		void *priv, int cmd, void *arg)
+{
+	if (cmd == (int)VIDIOC_ENUM_FRAMESIZES)
+		return stk_vidioc_enum_framesizes(filp, priv,
+				(struct v4l2_frmsizeenum *) arg);
+	return -EINVAL;
+}
+
 static struct file_operations v4l_stk_fops = {
 	.owner = THIS_MODULE,
 	.open = v4l_stk_open,
@@ -1296,6 +1324,7 @@ static const struct v4l2_ioctl_ops v4l_stk_ioctl_ops = {
 	.vidioc_g_ctrl = stk_vidioc_g_ctrl,
 	.vidioc_s_ctrl = stk_vidioc_s_ctrl,
 	.vidioc_g_parm = stk_vidioc_g_parm,
+	.vidioc_default = stk_vidioc_default,
 };
 
 static void stk_v4l_dev_release(struct video_device *vd)
-- 
1.5.6.5

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
