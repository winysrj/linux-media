Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01a.mail.t-online.hu ([84.2.40.6]:50694 "EHLO
	mail01a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444AbZH3I4R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Aug 2009 04:56:17 -0400
Message-ID: <4A9A3EB0.8060304@freemail.hu>
Date: Sun, 30 Aug 2009 10:56:16 +0200
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
MIME-Version: 1.0
To: V4L Mailing List <linux-media@vger.kernel.org>
CC: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Subject: [PATCH] libv4l: add NULL pointer check
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

Add NULL pointer check before the pointers are dereferenced.

The patch was tested with v4l-test 0.19 [1] together with
"Trust 610 LCD Powerc@m Zoom" in webcam mode.

Reference:
[1] v4l-test: Test environment for Video For Linux Two API
    http://v4l-test.sourceforge.net/

Priority: normal

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -upr libv4l-0.6.1-test.orig/libv4l2/libv4l2.c libv4l-0.6.1-test/libv4l2/libv4l2.c
--- libv4l-0.6.1-test.orig/libv4l2/libv4l2.c	2009-08-20 11:41:15.000000000 +0200
+++ libv4l-0.6.1-test/libv4l2/libv4l2.c	2009-08-30 10:40:12.000000000 +0200
@@ -772,7 +772,8 @@ int v4l2_ioctl (int fd, unsigned long in
       is_capture_request = 1;
       break;
     case VIDIOC_ENUM_FMT:
-      if (((struct v4l2_fmtdesc *)arg)->type == V4L2_BUF_TYPE_VIDEO_CAPTURE &&
+      if (arg &&
+	  ((struct v4l2_fmtdesc *)arg)->type == V4L2_BUF_TYPE_VIDEO_CAPTURE &&
 	  !(devices[index].flags & V4L2_DISABLE_CONVERSION))
 	is_capture_request = 1;
       break;
@@ -782,19 +783,22 @@ int v4l2_ioctl (int fd, unsigned long in
 	is_capture_request = 1;
       break;
     case VIDIOC_TRY_FMT:
-      if (((struct v4l2_format *)arg)->type == V4L2_BUF_TYPE_VIDEO_CAPTURE &&
+      if (arg &&
+	  ((struct v4l2_format *)arg)->type == V4L2_BUF_TYPE_VIDEO_CAPTURE &&
 	  !(devices[index].flags & V4L2_DISABLE_CONVERSION))
 	is_capture_request = 1;
       break;
     case VIDIOC_S_FMT:
     case VIDIOC_G_FMT:
-      if (((struct v4l2_format *)arg)->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+      if (arg &&
+	  ((struct v4l2_format *)arg)->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
 	is_capture_request = 1;
 	stream_needs_locking = 1;
       }
       break;
     case VIDIOC_REQBUFS:
-      if (((struct v4l2_requestbuffers *)arg)->type ==
+      if (arg &&
+	  ((struct v4l2_requestbuffers *)arg)->type ==
 	  V4L2_BUF_TYPE_VIDEO_CAPTURE) {
 	is_capture_request = 1;
 	stream_needs_locking = 1;
@@ -803,14 +807,16 @@ int v4l2_ioctl (int fd, unsigned long in
     case VIDIOC_QUERYBUF:
     case VIDIOC_QBUF:
     case VIDIOC_DQBUF:
-      if (((struct v4l2_buffer *)arg)->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+      if (arg &&
+	  ((struct v4l2_buffer *)arg)->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
 	is_capture_request = 1;
 	stream_needs_locking = 1;
       }
       break;
     case VIDIOC_STREAMON:
     case VIDIOC_STREAMOFF:
-      if (*((enum v4l2_buf_type *)arg) == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+      if (arg &&
+	  *((enum v4l2_buf_type *)arg) == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
 	is_capture_request = 1;
 	stream_needs_locking = 1;
       }
diff -upr libv4l-0.6.1-test.orig/libv4lconvert/control/libv4lcontrol.c libv4l-0.6.1-test/libv4lconvert/control/libv4lcontrol.c
--- libv4l-0.6.1-test.orig/libv4lconvert/control/libv4lcontrol.c	2009-08-20 11:29:51.000000000 +0200
+++ libv4l-0.6.1-test/libv4lconvert/control/libv4lcontrol.c	2009-08-30 10:37:53.000000000 +0200
@@ -543,7 +543,7 @@ int v4lcontrol_vidioc_queryctrl(struct v
   int i;
   struct v4l2_queryctrl *ctrl = arg;
   int retval;
-  __u32 orig_id=ctrl->id;
+  __u32 orig_id;

   /* if we have an exact match return it */
   for (i = 0; i < V4LCONTROL_COUNT; i++)
@@ -556,24 +556,27 @@ int v4lcontrol_vidioc_queryctrl(struct v
   /* find out what the kernel driver would respond. */
   retval = SYS_IOCTL(data->fd, VIDIOC_QUERYCTRL, arg);

-  if ((data->priv_flags & V4LCONTROL_SUPPORTS_NEXT_CTRL) &&
-      (orig_id & V4L2_CTRL_FLAG_NEXT_CTRL)) {
-    /* If the hardware has no more controls check if we still have any
-       fake controls with a higher id then the hardware's highest */
-    if (retval)
-      ctrl->id = V4L2_CTRL_FLAG_NEXT_CTRL;
-
-    /* If any of our controls have an id > orig_id but less than
-       ctrl->id then return that control instead. Note we do not
-       break when we have a match, but keep iterating, so that
-       we end up with the fake ctrl with the lowest CID > orig_id. */
-    for (i = 0; i < V4LCONTROL_COUNT; i++)
-      if ((data->controls & (1 << i)) &&
-	  (fake_controls[i].id > (orig_id & ~V4L2_CTRL_FLAG_NEXT_CTRL)) &&
-	  (fake_controls[i].id <= ctrl->id)) {
-	v4lcontrol_copy_queryctrl(data, ctrl, i);
-	retval = 0;
-      }
+  if (ctrl) {
+    orig_id = ctrl->id;
+    if ((data->priv_flags & V4LCONTROL_SUPPORTS_NEXT_CTRL) &&
+        (orig_id & V4L2_CTRL_FLAG_NEXT_CTRL)) {
+      /* If the hardware has no more controls check if we still have any
+         fake controls with a higher id then the hardware's highest */
+      if (retval)
+        ctrl->id = V4L2_CTRL_FLAG_NEXT_CTRL;
+
+      /* If any of our controls have an id > orig_id but less than
+         ctrl->id then return that control instead. Note we do not
+         break when we have a match, but keep iterating, so that
+         we end up with the fake ctrl with the lowest CID > orig_id. */
+      for (i = 0; i < V4LCONTROL_COUNT; i++)
+        if ((data->controls & (1 << i)) &&
+	    (fake_controls[i].id > (orig_id & ~V4L2_CTRL_FLAG_NEXT_CTRL)) &&
+	    (fake_controls[i].id <= ctrl->id)) {
+	  v4lcontrol_copy_queryctrl(data, ctrl, i);
+	  retval = 0;
+        }
+    }
   }

   return retval;
diff -upr libv4l-0.6.1-test.orig/libv4lconvert/libv4lconvert.c libv4l-0.6.1-test/libv4lconvert/libv4lconvert.c
--- libv4l-0.6.1-test.orig/libv4lconvert/libv4lconvert.c	2009-08-19 15:56:14.000000000 +0200
+++ libv4l-0.6.1-test/libv4lconvert/libv4lconvert.c	2009-08-30 10:45:16.000000000 +0200
@@ -1170,6 +1170,10 @@ static void v4lconvert_get_framesizes(st
 int v4lconvert_enum_framesizes(struct v4lconvert_data *data,
   struct v4l2_frmsizeenum *frmsize)
 {
+  if (!frmsize) {
+      errno = EACCES;
+      return -1;
+  }
   if (!v4lconvert_supported_dst_format(frmsize->pixel_format)) {
     if (v4lconvert_supported_dst_fmt_only(data)) {
       errno = EINVAL;
