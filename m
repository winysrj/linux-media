Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:39875 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754968Ab2DXNsM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Apr 2012 09:48:12 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [RFCv3 PATCH 2/6] v4l2 framework: add support for the new dv_timings ioctls.
Date: Tue, 24 Apr 2012 15:48:01 +0200
Message-Id: <1d342702b621dfab7e50846f6f2bb047751dbf42.1335274503.git.hans.verkuil@cisco.com>
In-Reply-To: <1335275285-13333-1-git-send-email-hans.verkuil@cisco.com>
References: <1335275285-13333-1-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <c5dd21524394247c53a2d58797c64f974f4bd6ca.1335274503.git.hans.verkuil@cisco.com>
References: <c5dd21524394247c53a2d58797c64f974f4bd6ca.1335274503.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/video/v4l2-compat-ioctl32.c |    3 +
 drivers/media/video/v4l2-ioctl.c          |  126 ++++++++++++++++++++---------
 include/media/v4l2-ioctl.h                |    6 ++
 include/media/v4l2-subdev.h               |    6 ++
 4 files changed, 104 insertions(+), 37 deletions(-)

diff --git a/drivers/media/video/v4l2-compat-ioctl32.c b/drivers/media/video/v4l2-compat-ioctl32.c
index 2829d25..aa43f76 100644
--- a/drivers/media/video/v4l2-compat-ioctl32.c
+++ b/drivers/media/video/v4l2-compat-ioctl32.c
@@ -1023,6 +1023,9 @@ long v4l2_compat_ioctl32(struct file *file, unsigned int cmd, unsigned long arg)
 	case VIDIOC_UNSUBSCRIBE_EVENT:
 	case VIDIOC_CREATE_BUFS32:
 	case VIDIOC_PREPARE_BUF32:
+	case VIDIOC_ENUM_DV_TIMINGS:
+	case VIDIOC_QUERY_DV_TIMINGS:
+	case VIDIOC_DV_TIMINGS_CAP:
 		ret = do_video_ioctl(file, cmd, arg);
 		break;
 
diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 5b2ec1f..594715a 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -279,6 +279,9 @@ static const char *v4l2_ioctls[] = {
 	[_IOC_NR(VIDIOC_UNSUBSCRIBE_EVENT)] = "VIDIOC_UNSUBSCRIBE_EVENT",
 	[_IOC_NR(VIDIOC_CREATE_BUFS)]      = "VIDIOC_CREATE_BUFS",
 	[_IOC_NR(VIDIOC_PREPARE_BUF)]      = "VIDIOC_PREPARE_BUF",
+	[_IOC_NR(VIDIOC_ENUM_DV_TIMINGS)]  = "VIDIOC_ENUM_DV_TIMINGS",
+	[_IOC_NR(VIDIOC_QUERY_DV_TIMINGS)] = "VIDIOC_QUERY_DV_TIMINGS",
+	[_IOC_NR(VIDIOC_DV_TIMINGS_CAP)]   = "VIDIOC_DV_TIMINGS_CAP",
 };
 #define V4L2_IOCTLS ARRAY_SIZE(v4l2_ioctls)
 
@@ -359,6 +362,34 @@ static inline void dbgrect(struct video_device *vfd, char *s,
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
@@ -2146,25 +2177,13 @@ static long __video_do_ioctl(struct file *file,
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
@@ -2177,29 +2196,60 @@ static long __video_do_ioctl(struct file *file,
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
@@ -2463,7 +2513,9 @@ video_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
 			err = -EFAULT;
 		goto out_array_args;
 	}
-	if (err < 0)
+	/* VIDIOC_QUERY_DV_TIMINGS can return an error, but still have valid
+	   results that must be returned. */
+	if (err < 0 && cmd != VIDIOC_QUERY_DV_TIMINGS)
 		goto out;
 
 out_array_args:
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index 3cb939c..d8b76f7 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -271,6 +271,12 @@ struct v4l2_ioctl_ops {
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
index 7e85035..0ddbe91 100644
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
1.7.9.5

