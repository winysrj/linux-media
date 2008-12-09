Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB9HZBw0002466
	for <video4linux-list@redhat.com>; Tue, 9 Dec 2008 12:35:11 -0500
Received: from mail-ew0-f21.google.com (mail-ew0-f21.google.com
	[209.85.219.21])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB9HYvwq027609
	for <video4linux-list@redhat.com>; Tue, 9 Dec 2008 12:34:57 -0500
Received: by ewy14 with SMTP id 14so68311ewy.3
	for <video4linux-list@redhat.com>; Tue, 09 Dec 2008 09:34:57 -0800 (PST)
Date: Tue, 9 Dec 2008 17:34:58 +0000
From: Jaime Velasco Juan <jsagarribay@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, mchehab@infradead.org
Message-ID: <20081209173458.GA4208@singular.sob>
References: <1228759826-11929-1-git-send-email-jsagarribay@gmail.com>
	<200812081933.55462.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812081933.55462.hverkuil@xs4all.nl>
Cc: video4linux-list@redhat.com
Subject: [PATCH v2] stkwebcam: Implement VIDIOC_ENUM_FRAMESIZES ioctl
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
 drivers/media/video/stk-webcam.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

Here is a new version of the patch using the vidioc_enum_framesizes callback.
Thanks for your comments, Hans.

Regards

diff --git a/drivers/media/video/stk-webcam.c b/drivers/media/video/stk-webcam.c
index e9eb6d7..5566c23 100644
--- a/drivers/media/video/stk-webcam.c
+++ b/drivers/media/video/stk-webcam.c
@@ -1262,6 +1262,25 @@ static int stk_vidioc_g_parm(struct file *filp,
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
 static struct file_operations v4l_stk_fops = {
 	.owner = THIS_MODULE,
 	.open = v4l_stk_open,
@@ -1296,6 +1315,7 @@ static const struct v4l2_ioctl_ops v4l_stk_ioctl_ops = {
 	.vidioc_g_ctrl = stk_vidioc_g_ctrl,
 	.vidioc_s_ctrl = stk_vidioc_s_ctrl,
 	.vidioc_g_parm = stk_vidioc_g_parm,
+	.vidioc_enum_framesizes = stk_vidioc_enum_framesizes,
 };
 
 static void stk_v4l_dev_release(struct video_device *vd)
-- 
1.5.6.5


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
