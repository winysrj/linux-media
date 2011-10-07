Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37285 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882Ab1JGH5k (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Oct 2011 03:57:40 -0400
Message-ID: <4E8EB0F6.3060002@redhat.com>
Date: Fri, 07 Oct 2011 09:57:42 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: libv4l2 misbehavior after calling S_STD or S_DV_PRESET
References: <201110061313.56974.hverkuil@xs4all.nl>
In-Reply-To: <201110061313.56974.hverkuil@xs4all.nl>
Content-Type: multipart/mixed;
 boundary="------------090901040207060703020900"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090901040207060703020900
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

Hmm, nasty...

On 10/06/2011 01:13 PM, Hans Verkuil wrote:
> Hi Hans!
>
> I've been looking into a problem with libv4l2 that occurs when you change TV
> standard or video preset using VIDIOC_S_STD or VIDIOC_S_DV_PRESET. These calls
> will change the format implicitly (e.g. if the current format is set for PAL
> at 720x576 and you select NTSC, then the format will be reset to 720x480).
>
> However, libv4l2 isn't taking this into account and will keep using the cached
> dest_fmt value. It is easy to reproduce this using qv4l2.
>
> The same problem is likely to occur with S_CROP (haven't tested that yet,
> though): calling S_CROP can also change the format.
>
> To be precise: S_STD and S_DV_PRESET can change both the crop rectangle and
> the format, and S_CROP can change the format.

First of all it would be good to actually document this behavior of
VIDIOC_S_STD or VIDIOC_S_DV_PRESET, the current docs don't mention this at all:
http://linuxtv.org/downloads/v4l-dvb-apis/standard.html

I've attached 2 patches which should make libv4l2 deal with this correctly.
I assume you've a reproducer for this and I would appreciate it if you could test
if these patches actually fix the issue you are seeing.

Regards,

Hans

--------------090901040207060703020900
Content-Type: text/plain;
 name="0001-libv4l2-Move-s_fmt-handling-code-into-a-helper-funct.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-libv4l2-Move-s_fmt-handling-code-into-a-helper-funct.pa";
 filename*1="tch"

>From a5abaaa08602b540c88ae4776f557a3b0c34b24d Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Fri, 7 Oct 2011 09:18:39 +0200
Subject: [PATCH 1/2] libv4l2: Move s_fmt handling code into a helper function

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 lib/libv4l2/libv4l2.c |  195 +++++++++++++++++++++++++------------------------
 1 files changed, 98 insertions(+), 97 deletions(-)

diff --git a/lib/libv4l2/libv4l2.c b/lib/libv4l2/libv4l2.c
index 977179a..f7ec85d 100644
--- a/lib/libv4l2/libv4l2.c
+++ b/lib/libv4l2/libv4l2.c
@@ -881,6 +881,101 @@ static void v4l2_set_src_and_dest_format(int index,
 	devices[index].dest_fmt = *dest_fmt;
 }
 
+static int v4l2_s_fmt(int index, struct v4l2_format *dest_fmt)
+{
+	struct v4l2_format src_fmt;
+	struct v4l2_pix_format req_pix_fmt;
+	int result;
+
+	/* Don't be lazy on uvc cams, as this triggers a bug in the uvcvideo
+	   driver in kernel <= 2.6.28 (with certain cams) */
+	if (!(devices[index].flags & V4L2_IS_UVC) &&
+	    v4l2_pix_fmt_compat(&devices[index].dest_fmt, dest_fmt)) {
+		*dest_fmt = devices[index].dest_fmt;
+		return 0;
+	}
+
+	if (v4l2_log_file) {
+		int pixfmt = dest_fmt->fmt.pix.pixelformat;
+
+		fprintf(v4l2_log_file, "VIDIOC_S_FMT app requesting: %c%c%c%c\n",
+				pixfmt & 0xff,
+				(pixfmt >> 8) & 0xff,
+				(pixfmt >> 16) & 0xff,
+				pixfmt >> 24);
+	}
+
+	result = v4lconvert_try_format(devices[index].convert,
+				       dest_fmt, &src_fmt);
+	if (result) {
+		int saved_err = errno;
+		V4L2_LOG("S_FMT error trying format: %s\n", strerror(errno));
+		errno = saved_err;
+		return result;
+	}
+
+	if (src_fmt.fmt.pix.pixelformat != dest_fmt->fmt.pix.pixelformat &&
+			v4l2_log_file) {
+		int pixfmt = src_fmt.fmt.pix.pixelformat;
+
+		fprintf(v4l2_log_file,
+			"VIDIOC_S_FMT converting from: %c%c%c%c\n",
+			pixfmt & 0xff, (pixfmt >> 8) & 0xff,
+			(pixfmt >> 16) & 0xff, pixfmt >> 24);
+	}
+
+	/* Maybe after try format has adjusted width/height etc, to whats
+	   available nothing has changed (on the cam side) ? */
+	if (!(devices[index].flags & V4L2_IS_UVC) &&
+	    v4l2_pix_fmt_compat(&devices[index].src_fmt, &src_fmt)) {
+		v4l2_set_src_and_dest_format(index, &devices[index].src_fmt,
+				dest_fmt);
+		return 0;
+	}
+
+	result = v4l2_check_buffer_change_ok(index);
+	if (result)
+		return result;
+
+	req_pix_fmt = src_fmt.fmt.pix;
+	result = devices[index].dev_ops->ioctl(devices[index].dev_ops_priv,
+					       devices[index].fd,
+					       VIDIOC_S_FMT, &src_fmt);
+	if (result) {
+		int saved_err = errno;
+		V4L2_LOG_ERR("setting pixformat: %s\n", strerror(errno));
+		/* Report to the app dest_fmt has not changed */
+		*dest_fmt = devices[index].dest_fmt;
+		errno = saved_err;
+		return result;
+	}
+
+	/* See if we've gotten what try_fmt promised us
+	   (this check should never fail) */
+	if (src_fmt.fmt.pix.width != req_pix_fmt.width ||
+	    src_fmt.fmt.pix.height != req_pix_fmt.height ||
+	    src_fmt.fmt.pix.pixelformat != req_pix_fmt.pixelformat) {
+		V4L2_LOG_ERR("set_fmt gave us a different result then try_fmt!\n");
+		/* Not what we expected / wanted, disable conversion */
+		*dest_fmt = src_fmt;
+	}
+
+	v4l2_set_src_and_dest_format(index, &src_fmt, dest_fmt);
+
+	if (devices[index].flags & V4L2_SUPPORTS_TIMEPERFRAME) {
+		struct v4l2_streamparm parm = {
+			.type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
+		};
+		if (devices[index].dev_ops->ioctl(devices[index].dev_ops_priv,
+						  devices[index].fd,
+						  VIDIOC_G_PARM, &parm))
+			return 0;
+		v4l2_update_fps(index, &parm);
+	}
+
+	return 0;
+}
+
 int v4l2_ioctl(int fd, unsigned long int request, ...)
 {
 	void *arg;
@@ -991,11 +1086,8 @@ no_capture_request:
 			struct v4l2_format fmt = devices[index].dest_fmt;
 
 			V4L2_LOG("Setting pixelformat to RGB24 (supported_dst_fmt_only)");
-			devices[index].flags |= V4L2_STREAM_TOUCHED;
 			fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_RGB24;
-			pthread_mutex_unlock(&devices[index].stream_lock);
-			v4l2_ioctl(fd, VIDIOC_S_FMT, &fmt);
-			pthread_mutex_lock(&devices[index].stream_lock);
+			v4l2_s_fmt(index, &fmt);
 			V4L2_LOG("Done setting pixelformat (supported_dst_fmt_only)");
 		}
 		devices[index].flags |= V4L2_STREAM_TOUCHED;
@@ -1046,100 +1138,9 @@ no_capture_request:
 					       arg, NULL);
 		break;
 
-	case VIDIOC_S_FMT: {
-		struct v4l2_format src_fmt, *dest_fmt = arg;
-		struct v4l2_pix_format req_pix_fmt;
-
-		/* Don't be lazy on uvc cams, as this triggers a bug in the uvcvideo
-		   driver in kernel <= 2.6.28 (with certain cams) */
-		if (!(devices[index].flags & V4L2_IS_UVC) &&
-		    v4l2_pix_fmt_compat(&devices[index].dest_fmt, dest_fmt)) {
-			*dest_fmt = devices[index].dest_fmt;
-			result = 0;
-			break;
-		}
-
-		if (v4l2_log_file) {
-			int pixfmt = dest_fmt->fmt.pix.pixelformat;
-
-			fprintf(v4l2_log_file, "VIDIOC_S_FMT app requesting: %c%c%c%c\n",
-					pixfmt & 0xff,
-					(pixfmt >> 8) & 0xff,
-					(pixfmt >> 16) & 0xff,
-					pixfmt >> 24);
-		}
-
-		result = v4lconvert_try_format(devices[index].convert,
-					       dest_fmt, &src_fmt);
-		if (result) {
-			saved_err = errno;
-			V4L2_LOG("S_FMT error trying format: %s\n", strerror(errno));
-			errno = saved_err;
-			break;
-		}
-
-		if (src_fmt.fmt.pix.pixelformat != dest_fmt->fmt.pix.pixelformat &&
-				v4l2_log_file) {
-			int pixfmt = src_fmt.fmt.pix.pixelformat;
-
-			fprintf(v4l2_log_file, "VIDIOC_S_FMT converting from: %c%c%c%c\n",
-					pixfmt & 0xff,
-					(pixfmt >> 8) & 0xff,
-					(pixfmt >> 16) & 0xff,
-					pixfmt >> 24);
-		}
-
-		/* Maybe after try format has adjusted width/height etc, to whats
-		   available nothing has changed (on the cam side) ? */
-		if (!(devices[index].flags & V4L2_IS_UVC) &&
-				v4l2_pix_fmt_compat(&devices[index].src_fmt, &src_fmt)) {
-			v4l2_set_src_and_dest_format(index, &devices[index].src_fmt,
-					dest_fmt);
-			result = 0;
-			break;
-		}
-
-		result = v4l2_check_buffer_change_ok(index);
-		if (result)
-			break;
-
-		req_pix_fmt = src_fmt.fmt.pix;
-		result = devices[index].dev_ops->ioctl(
-				devices[index].dev_ops_priv,
-				fd, VIDIOC_S_FMT, &src_fmt);
-		if (result) {
-			saved_err = errno;
-			V4L2_LOG_ERR("setting pixformat: %s\n", strerror(errno));
-			/* Report to the app dest_fmt has not changed */
-			*dest_fmt = devices[index].dest_fmt;
-			errno = saved_err;
-			break;
-		}
-		/* See if we've gotten what try_fmt promised us
-		   (this check should never fail) */
-		if (src_fmt.fmt.pix.width != req_pix_fmt.width ||
-				src_fmt.fmt.pix.height != req_pix_fmt.height ||
-				src_fmt.fmt.pix.pixelformat != req_pix_fmt.pixelformat) {
-			V4L2_LOG_ERR("set_fmt gave us a different result then try_fmt!\n");
-			/* Not what we expected / wanted, disable conversion */
-			*dest_fmt = src_fmt;
-		}
-
-		v4l2_set_src_and_dest_format(index, &src_fmt, dest_fmt);
-
-		if (devices[index].flags & V4L2_SUPPORTS_TIMEPERFRAME) {
-			struct v4l2_streamparm parm = {
-				.type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
-			};
-			if (devices[index].dev_ops->ioctl(
-					devices[index].dev_ops_priv,
-					fd, VIDIOC_G_PARM, &parm))
-				break;
-			v4l2_update_fps(index, &parm);
-		}
-
+	case VIDIOC_S_FMT:
+		result = v4l2_s_fmt(index, arg);
 		break;
-	}
 
 	case VIDIOC_G_FMT: {
 		struct v4l2_format *fmt = arg;
-- 
1.7.6.4


--------------090901040207060703020900
Content-Type: text/plain;
 name="0002-libv4l-handle-VIDIOC_S_STD-or-VIDIOC_S_DV_PRESET-cha.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0002-libv4l-handle-VIDIOC_S_STD-or-VIDIOC_S_DV_PRESET-cha.pa";
 filename*1="tch"

>From ce898a8e33b361424b554879faff4bd619aaf979 Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Fri, 7 Oct 2011 09:54:24 +0200
Subject: [PATCH 2/2] libv4l: handle VIDIOC_S_STD or VIDIOC_S_DV_PRESET
 changing the format

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 lib/libv4l2/libv4l2-priv.h |    1 +
 lib/libv4l2/libv4l2.c      |   50 ++++++++++++++++++++++++++++++++++++++++++++
 lib/libv4l2/log.c          |    2 +-
 3 files changed, 52 insertions(+), 1 deletions(-)

diff --git a/lib/libv4l2/libv4l2-priv.h b/lib/libv4l2/libv4l2-priv.h
index 2e99200..730f193 100644
--- a/lib/libv4l2/libv4l2-priv.h
+++ b/lib/libv4l2/libv4l2-priv.h
@@ -100,6 +100,7 @@ void v4l2_plugin_cleanup(void *plugin_lib, void *plugin_priv,
 			 const struct libv4l2_dev_ops *dev_ops);
 
 /* From log.c */
+extern const char *v4l2_ioctls[];
 void v4l2_log_ioctl(unsigned long int request, void *arg, int result);
 
 #endif
diff --git a/lib/libv4l2/libv4l2.c b/lib/libv4l2/libv4l2.c
index f7ec85d..d205674 100644
--- a/lib/libv4l2/libv4l2.c
+++ b/lib/libv4l2/libv4l2.c
@@ -1059,6 +1059,11 @@ int v4l2_ioctl(int fd, unsigned long int request, ...)
 				stream_needs_locking = 1;
 		}
 		break;
+	case VIDIOC_S_STD:
+	case VIDIOC_S_DV_PRESET:
+		is_capture_request = 1;
+		stream_needs_locking = 1;
+		break;		
 	}
 
 	if (!is_capture_request) {
@@ -1150,6 +1155,51 @@ no_capture_request:
 		break;
 	}
 
+	case VIDIOC_S_STD:
+	case VIDIOC_S_DV_PRESET: {
+		struct v4l2_format src_fmt, try_fmt;
+
+		result = devices[index].dev_ops->ioctl(
+				devices[index].dev_ops_priv,
+				fd, request, arg);
+		if (result)
+			break;
+
+		/* These ioctls may have changed the device's fmt */
+		result = devices[index].dev_ops->ioctl(
+				devices[index].dev_ops_priv,
+				fd, VIDIOC_G_FMT, &src_fmt);
+		if (result) {
+			V4L2_LOG_ERR("getting pixformat after %s: %s\n",
+				     v4l2_ioctls[_IOC_NR(request)],
+				     strerror(errno));
+			result = 0; /* The original command did succeed */
+			break;
+		}
+
+		if (v4l2_pix_fmt_compat(&devices[index].src_fmt, &src_fmt)) {
+			v4l2_set_src_and_dest_format(index, &src_fmt,
+						     &devices[index].dest_fmt);
+			break;
+		}
+
+		/* The fmt has been changed, try to restore the last set
+		   destination pixelformat, using the new dimenstions */
+		try_fmt = src_fmt;
+		try_fmt.fmt.pix.pixelformat =
+			devices[index].dest_fmt.fmt.pix.pixelformat;
+		result = v4l2_s_fmt(index, &try_fmt);
+		if (result) {
+			V4L2_LOG_WARN("Restoring destination pixelformat after %s failed\n",
+				      v4l2_ioctls[_IOC_NR(request)]);
+			devices[index].src_fmt = src_fmt;
+			devices[index].dest_fmt = src_fmt;
+			result = 0; /* The original command did succeed */
+		}
+
+		break;
+	}
+
 	case VIDIOC_REQBUFS: {
 		struct v4l2_requestbuffers *req = arg;
 
diff --git a/lib/libv4l2/log.c b/lib/libv4l2/log.c
index 37d2e1f..f7ce06f 100644
--- a/lib/libv4l2/log.c
+++ b/lib/libv4l2/log.c
@@ -31,7 +31,7 @@
 
 FILE *v4l2_log_file = NULL;
 
-static const char *v4l2_ioctls[] = {
+const char *v4l2_ioctls[] = {
 	/* start v4l2 ioctls */
 	[_IOC_NR(VIDIOC_QUERYCAP)]         = "VIDIOC_QUERYCAP",
 	[_IOC_NR(VIDIOC_RESERVED)]         = "VIDIOC_RESERVED",
-- 
1.7.6.4


--------------090901040207060703020900--
