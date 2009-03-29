Return-path: <linux-media-owner@vger.kernel.org>
Received: from mk-outboundfilter-1.mail.uk.tiscali.com ([212.74.114.37]:3996
	"EHLO mk-outboundfilter-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752251AbZC2W3G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Mar 2009 18:29:06 -0400
From: Adam Baker <linux@baker-net.org.uk>
To: linux-media@vger.kernel.org, Hans de Goede <j.w.r.degoede@hhs.nl>
Subject: [PATCH v2 4/4] Add support to libv4l to use orientation from VIDIOC_ENUMINPUT
Date: Sun, 29 Mar 2009 23:28:09 +0100
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Jean-Francois Moine" <moinejf@free.fr>,
	kilgota@banach.math.auburn.edu, Hans Verkuil <hverkuil@xs4all.nl>
References: <200903292309.31267.linux@baker-net.org.uk> <200903292322.08660.linux@baker-net.org.uk> <200903292325.16499.linux@baker-net.org.uk>
In-Reply-To: <200903292325.16499.linux@baker-net.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903292328.09957.linux@baker-net.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add check to libv4l of the sensor orientation as reported by
VIDIOC_ENUMINPUT

Signed-off-by: Adam Baker <linux@baker-net.org.uk>

---
diff -r a647c2dfa989 v4l2-apps/lib/libv4l/libv4lconvert/libv4lconvert.c
--- a/v4l2-apps/lib/libv4l/libv4lconvert/libv4lconvert.c	Tue Jan 20 11:25:54 2009 +0100
+++ b/v4l2-apps/lib/libv4l/libv4lconvert/libv4lconvert.c	Sun Mar 29 22:59:56 2009 +0100
@@ -29,6 +29,11 @@
 #define MIN(a,b) (((a)<(b))?(a):(b))
 #define ARRAY_SIZE(x) ((int)sizeof(x)/(int)sizeof((x)[0]))
 
+/* Workaround this potentially being missing from videodev2.h */
+#ifndef V4L2_IN_ST_VFLIP
+#define V4L2_IN_ST_VFLIP       0x00000020 /* Output is flipped vertically */
+#endif
+
 /* Note for proper functioning of v4lconvert_enum_fmt the first entries in
   supported_src_pixfmts must match with the entries in supported_dst_pixfmts */
 #define SUPPORTED_DST_PIXFMTS \
@@ -134,6 +139,7 @@
   int i, j;
   struct v4lconvert_data *data = calloc(1, sizeof(struct v4lconvert_data));
   struct v4l2_capability cap;
+  struct v4l2_input input;
 
   if (!data)
     return NULL;
@@ -161,6 +167,13 @@
 
   /* Check if this cam has any special flags */
   data->flags = v4lconvert_get_flags(data->fd);
+  if ((syscall(SYS_ioctl, fd, VIDIOC_G_INPUT, &input.index) == 0) &&
+      (syscall(SYS_ioctl, fd, VIDIOC_ENUMINPUT, &input) == 0)) {
+    /* Don't yet support independent HFLIP and VFLIP so getting
+     * image the right way up is highest priority. */
+    if (input.status & V4L2_IN_ST_VFLIP)
+      data->flags |= V4LCONVERT_ROTATE_180;
+  }
   if (syscall(SYS_ioctl, fd, VIDIOC_QUERYCAP, &cap) == 0) {
     if (!strcmp((char *)cap.driver, "uvcvideo"))
       data->flags |= V4LCONVERT_IS_UVC;

