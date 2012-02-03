Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2891 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755406Ab2BCKGS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Feb 2012 05:06:18 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 2/6] v4l2 framework: add support for the new dv_timings ioctls.
Date: Fri,  3 Feb 2012 11:06:02 +0100
Message-Id: <5e30e250fb80a205f43d1a42b21a9adf50064e38.1328262332.git.hans.verkuil@cisco.com>
In-Reply-To: <1328263566-21620-1-git-send-email-hverkuil@xs4all.nl>
References: <1328263566-21620-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <f884dc30bd71901ea5dad39dc3310fa5a7d9e9c2.1328262332.git.hans.verkuil@cisco.com>
References: <f884dc30bd71901ea5dad39dc3310fa5a7d9e9c2.1328262332.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-compat-ioctl32.c |    3 +
 drivers/media/video/v4l2-ioctl.c          |  122 ++++++++++++++++++++---------
 include/media/v4l2-ioctl.h                |    6 ++
 include/media/v4l2-subdev.h               |    6 ++
 4 files changed, 101 insertions(+), 36 deletions(-)

diff --git a/drivers/media/video/v4l2-compat-ioctl32.c b/drivers/media/video/v4l2-compat-ioctl32.c
index af4419e..87ac6c8 100644
--- a/drivers/media/video/v4l2-compat-ioctl32.c
+++ b/drivers/media/video/v4l2-compat-ioctl32.c
@@ -1021,6 +1021,9 @@ long v4l2_compat_ioctl32(struct file *file, unsigned int cmd, unsigned long arg)
 	case VIDIOC_UNSUBSCRIBE_EVENT:
 	case VIDIOC_CREATE_BUFS32:
 	case VIDIOC_PREPARE_BUF32:
+	case VIDIOC_ENUM_DV_TIMINGS:
+	case VIDIOC_QUERY_DV_TIMINGS:
+	case VIDIOC_DV_TIMINGS_CAP:
 		ret = do_video_ioctl(file, cmd, arg);
 		break;
 
diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index d0d7281..c8d2452 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -277,6 +277,9 @@ static const char *v4l2_ioctls[] = {
 	[_IOC_NR(VIDIOC_UNSUBSCRIBE_EVENT)] = "VIDIOC_UNSUBSCRIBE_EVENT",
 	[_IOC_NR(VIDIOC_CREATE_BUFS)]      = "VIDIOC_CREATE_BUFS",
 	[_IOC_NR(VIDIOC_PREPARE_BUF)]      = "VIDIOC_PREPARE_BUF",
+	[_IOC_NR(VIDIOC_ENUM_DV_TIMINGS)]  = "VIDIOC_ENUM_DV_TIMINGS",
+	[_IOC_NR(VIDIOC_QUERY_DV_TIMINGS)] = "VIDIOC_QUERY_DV_TIMINGS",
+	[_IOC_NR(VIDIOC_DV_TIMINGS_CAP)]   = "VIDIOC_DV_TIMINGS_CAP",
 };
 #define V4L2_IOCTLS ARRAY_SIZE(v4l2_ioctls)
 
@@ -357,6 +360,34 @@ static inline void dbgrect(struct video_device *vfd, char *s,
 						r->width, r->height);
 };
 
+static void dbgtimings(struct video_device *vfd,
+			const struct v4l2_dv_timings *p)
+{
+	switch (p->type) {
+	case V4L2_DV_BT_656_1120:
+		dbgarg2("bt-656/1120:interlaced=%d,"
+				" pixelclock=%lld,"
+				" width=%d, height=%d, polarities=%x,"
+				" hfrontporch=%d, hsync=%d,"
+				" hbackporch=%d, vfrontporch=%d,"
+				" vsync=%d, vbackporch=%d,"
+				" il_vfrontporch=%d, il_vsync=%d,"
+				" il_vbackporch=%d, standards=%x, flags=%x\n",
+				p->bt.interlaced, p->bt.pixelclock,
+				p->bt.width, p->bt.height,
+				p->bt.polarities, p->bt.hfrontporch,
+				p->bt.hsync, p->bt.hbackporch,
+				p->bt.vfrontporch, p->bt.vsync,
+				p->bt.vbackporch, p->bt.il_vfrontporch,
+				p->bt.il_vsync, p->bt.il_vbackporch,
+				p->bt.standards, p->bt.flags);
+		break;
+	default:
+		dbgarg2("Unknown type %d!\n", p->type);
+		break;
+	}
+}
+
 static inline void v4l_print_pix_fmt(struct video_device *vfd,
 						struct v4l2_pix_format *fmt)
 {
@@ -2112,25 +2143,13 @@ static long __video_do_ioctl(struct file *file,
 			break;
 		}
 
+		dbgtimings(vfd, p);
 		switch (p->type) {
 		case V4L2_DV_BT_656_1120:
-			dbgarg2("bt-656/1120:interlaced=%d, pixelclock=%lld,"
-				" width=%d, height=%d, polarities=%x,"
-				" hfrontporch=%d, hsync=%d, hbackporch=%d,"
-				" vfrontporch=%d, vsync=%d, vbackporch=%d,"
-				" il_vfrontporch=%d, il_vsync=%d,"
-				" il_vbackporch=%d\n",
-				p->bt.interlaced, p->bt.pixelclock,
-				p->bt.width, p->bt.height, p->bt.polarities,
-				p->bt.hfrontporch, p->bt.hsync,
-				p->bt.hbackporch, p->bt.vfrontporch,
-				p->bt.vsync, p->bt.vbackporch,
-				p->bt.il_vfrontporch, p->bt.il_vsync,
-				p->bt.il_vbackporch);
 			ret = ops->vidioc_s_dv_timings(file, fh, p);
 			break;
 		default:
-			dbgarg2("Unknown type %d!\n", p->type);
+			ret = -EINVAL;
 			break;
 		}
 		break;
@@ -2143,29 +2162,60 @@ static long __video_do_ioctl(struct file *file,
 			break;
 
 		ret = ops->vidioc_g_dv_timings(file, fh, p);
+		if (!ret)
+			dbgtimings(vfd, p);
+		break;
+	}
+	case VIDIOC_ENUM_DV_TIMINGS:
+	{
+		struct v4l2_enum_dv_timings *p = arg;
+
+		if (!ops->vidioc_enum_dv_timings)
+			break;
+
+		ret = ops->vidioc_enum_dv_timings(file, fh, p);
 		if (!ret) {
-			switch (p->type) {
-			case V4L2_DV_BT_656_1120:
-				dbgarg2("bt-656/1120:interlaced=%d,"
-					" pixelclock=%lld,"
-					" width=%d, height=%d, polarities=%x,"
-					" hfrontporch=%d, hsync=%d,"
-					" hbackporch=%d, vfrontporch=%d,"
-					" vsync=%d, vbackporch=%d,"
-					" il_vfrontporch=%d, il_vsync=%d,"
-					" il_vbackporch=%d\n",
-					p->bt.interlaced, p->bt.pixelclock,
-					p->bt.width, p->bt.height,
-					p->bt.polarities, p->bt.hfrontporch,
-					p->bt.hsync, p->bt.hbackporch,
-					p->bt.vfrontporch, p->bt.vsync,
-					p->bt.vbackporch, p->bt.il_vfrontporch,
-					p->bt.il_vsync, p->bt.il_vbackporch);
-				break;
-			default:
-				dbgarg2("Unknown type %d!\n", p->type);
-				break;
-			}
+			dbgarg(cmd, "index=%d: ", p->index);
+			dbgtimings(vfd, &p->timings);
+		}
+		break;
+	}
+	case VIDIOC_QUERY_DV_TIMINGS:
+	{
+		struct v4l2_dv_timings *p = arg;
+
+		if (!ops->vidioc_query_dv_timings)
+			break;
+
+		ret = ops->vidioc_query_dv_timings(file, fh, p);
+		if (!ret)
+			dbgtimings(vfd, p);
+		break;
+	}
+	case VIDIOC_DV_TIMINGS_CAP:
+	{
+		struct v4l2_dv_timings_cap *p = arg;
+
+		if (!ops->vidioc_dv_timings_cap)
+			break;
+
+		ret = ops->vidioc_dv_timings_cap(file, fh, p);
+		if (ret)
+			break;
+		switch (p->type) {
+		case V4L2_DV_BT_656_1120:
+			dbgarg(cmd,
+			       "type=%d, width=%u-%u, height=%u-%u, "
+			       "pixelclock=%llu-%llu, standards=%x, capabilities=%x ",
+			       p->type,
+			       p->bt.min_width, p->bt.max_width,
+			       p->bt.min_height, p->bt.max_height,
+			       p->bt.min_pixelclock, p->bt.max_pixelclock,
+			       p->bt.standards, p->bt.capabilities);
+			break;
+		default:
+			dbgarg(cmd, "unknown type ");
+			break;
 		}
 		break;
 	}
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index 3f5d60f..e53b896 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -268,6 +268,12 @@ struct v4l2_ioctl_ops {
 				    struct v4l2_dv_timings *timings);
 	int (*vidioc_g_dv_timings) (struct file *file, void *fh,
 				    struct v4l2_dv_timings *timings);
+	int (*vidioc_query_dv_timings) (struct file *file, void *fh,
+				    struct v4l2_dv_timings *timings);
+	int (*vidioc_enum_dv_timings) (struct file *file, void *fh,
+				    struct v4l2_enum_dv_timings *timings);
+	int (*vidioc_dv_timings_cap) (struct file *file, void *fh,
+				    struct v4l2_dv_timings_cap *cap);
 
 	int (*vidioc_subscribe_event)  (struct v4l2_fh *fh,
 					struct v4l2_event_subscription *sub);
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index f0f3358..9f82c0b 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -307,6 +307,12 @@ struct v4l2_subdev_video_ops {
 			struct v4l2_dv_timings *timings);
 	int (*g_dv_timings)(struct v4l2_subdev *sd,
 			struct v4l2_dv_timings *timings);
+	int (*enum_dv_timings)(struct v4l2_subdev *sd,
+			struct v4l2_enum_dv_timings *timings);
+	int (*query_dv_timings)(struct v4l2_subdev *sd,
+			struct v4l2_dv_timings *timings);
+	int (*dv_timings_cap)(struct v4l2_subdev *sd,
+			struct v4l2_dv_timings_cap *cap);
 	int (*enum_mbus_fmt)(struct v4l2_subdev *sd, unsigned int index,
 			     enum v4l2_mbus_pixelcode *code);
 	int (*enum_mbus_fsizes)(struct v4l2_subdev *sd,
-- 
1.7.8.3

