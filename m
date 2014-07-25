Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3662 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758404AbaGYJtx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jul 2014 05:49:53 -0400
Message-ID: <53D227FC.6070504@xs4all.nl>
Date: Fri, 25 Jul 2014 11:48:44 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH] libv4l-mplane: make it aware of the extended pix_format fields
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The v4l2_pix_format struct has been extended with new fields. Let libv4l-mplane
make use of that so that the v4l2_pix_format_mplane 'flags' field can be reported
in v4l2_pix_format as well.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/lib/libv4l-mplane/libv4l-mplane.c b/lib/libv4l-mplane/libv4l-mplane.c
index 5659dd5..a7b4f04 100644
--- a/lib/libv4l-mplane/libv4l-mplane.c
+++ b/lib/libv4l-mplane/libv4l-mplane.c
@@ -21,6 +21,7 @@
 #include <stdint.h>
 #include <stdio.h>
 #include <stdlib.h>
+#include <stddef.h>
 #include <string.h>
 #include <unistd.h>
 #include <sys/syscall.h>
@@ -142,6 +143,9 @@ static int querycap_ioctl(int fd, unsigned long int cmd,
 	if (cap->device_caps & V4L2_CAP_VIDEO_OUTPUT_MPLANE)
 		cap->device_caps |= V4L2_CAP_VIDEO_OUTPUT;
 
+	cap->capabilities |= V4L2_CAP_EXT_PIX_FORMAT;
+	cap->device_caps |= V4L2_CAP_EXT_PIX_FORMAT;
+
 	/*
 	 * Don't report mplane caps, as this will be handled via
 	 * this plugin
@@ -166,6 +170,32 @@ static int convert_type(int type)
 	}
 }
 
+static void sanitize_format(struct v4l2_format *fmt)
+{
+	unsigned int offset;
+
+	/*
+	 * The v4l2_pix_format structure has been extended with fields that were
+	 * not previously required to be set to zero by applications. The priv
+	 * field, when set to a magic value, indicates the the extended fields
+	 * are valid. We support these extended fields since struct
+	 * v4l2_pix_format_mplane supports those fields as well.
+	 *
+	 * So this function will sanitize v4l2_pix_format if priv != PRIV_MAGIC
+	 * by setting priv to that value and zeroing the remaining fields.
+	 */
+
+	if (fmt->fmt.pix.priv == V4L2_PIX_FMT_PRIV_MAGIC)
+		return;
+
+	fmt->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
+
+	offset = offsetof(struct v4l2_pix_format, priv)
+	       + sizeof(fmt->fmt.pix.priv);
+	memset(((char *)&fmt->fmt.pix) + offset, 0,
+	       sizeof(fmt->fmt.pix) - offset);
+}
+
 static int try_set_fmt_ioctl(int fd, unsigned long int cmd,
 			     struct v4l2_format *arg)
 {
@@ -188,12 +218,15 @@ static int try_set_fmt_ioctl(int fd, unsigned long int cmd,
 		return SYS_IOCTL(fd, cmd, arg);
 	}
 
+	sanitize_format(org);
+
 	fmt.fmt.pix_mp.width = org->fmt.pix.width;
 	fmt.fmt.pix_mp.height = org->fmt.pix.height;
 	fmt.fmt.pix_mp.pixelformat = org->fmt.pix.pixelformat;
 	fmt.fmt.pix_mp.field = org->fmt.pix.field;
 	fmt.fmt.pix_mp.colorspace = org->fmt.pix.colorspace;
 	fmt.fmt.pix_mp.num_planes = 1;
+	fmt.fmt.pix_mp.flags = org->fmt.pix.flags;
 	fmt.fmt.pix_mp.plane_fmt[0].bytesperline = org->fmt.pix.bytesperline;
 	fmt.fmt.pix_mp.plane_fmt[0].sizeimage = org->fmt.pix.sizeimage;
 
@@ -208,7 +241,7 @@ static int try_set_fmt_ioctl(int fd, unsigned long int cmd,
 	org->fmt.pix.colorspace = fmt.fmt.pix_mp.colorspace;
 	org->fmt.pix.bytesperline = fmt.fmt.pix_mp.plane_fmt[0].bytesperline;
 	org->fmt.pix.sizeimage = fmt.fmt.pix_mp.plane_fmt[0].sizeimage;
-	org->fmt.pix.priv = 0;
+	org->fmt.pix.flags = fmt.fmt.pix_mp.flags;
 
 	return 0;
 }
@@ -239,12 +272,14 @@ static int create_bufs_ioctl(int fd, unsigned long int cmd,
 	cbufs.index = arg->index;
 	cbufs.count = arg->count;
 	cbufs.memory = arg->memory;
+	sanitize_format(org);
 	fmt->fmt.pix_mp.width = org->fmt.pix.width;
 	fmt->fmt.pix_mp.height = org->fmt.pix.height;
 	fmt->fmt.pix_mp.pixelformat = org->fmt.pix.pixelformat;
 	fmt->fmt.pix_mp.field = org->fmt.pix.field;
 	fmt->fmt.pix_mp.colorspace = org->fmt.pix.colorspace;
 	fmt->fmt.pix_mp.num_planes = 1;
+	fmt->fmt.pix_mp.flags = org->fmt.pix.flags;
 	fmt->fmt.pix_mp.plane_fmt[0].bytesperline = org->fmt.pix.bytesperline;
 	fmt->fmt.pix_mp.plane_fmt[0].sizeimage = org->fmt.pix.sizeimage;
 
@@ -259,6 +294,7 @@ static int create_bufs_ioctl(int fd, unsigned long int cmd,
 	org->fmt.pix.colorspace = fmt->fmt.pix_mp.colorspace;
 	org->fmt.pix.bytesperline = fmt->fmt.pix_mp.plane_fmt[0].bytesperline;
 	org->fmt.pix.sizeimage = fmt->fmt.pix_mp.plane_fmt[0].sizeimage;
+	org->fmt.pix.flags = fmt->fmt.pix_mp.flags;
 
 	return ret;
 }
@@ -288,6 +324,7 @@ static int get_fmt_ioctl(int fd, unsigned long int cmd, struct v4l2_format *arg)
 	if (ret)
 		return ret;
 
+	memset(&org->fmt.pix, 0, sizeof(org->fmt.pix));
 	org->fmt.pix.width = fmt.fmt.pix_mp.width;
 	org->fmt.pix.height = fmt.fmt.pix_mp.height;
 	org->fmt.pix.pixelformat = fmt.fmt.pix_mp.pixelformat;
@@ -295,7 +332,8 @@ static int get_fmt_ioctl(int fd, unsigned long int cmd, struct v4l2_format *arg)
 	org->fmt.pix.colorspace = fmt.fmt.pix_mp.colorspace;
 	org->fmt.pix.bytesperline = fmt.fmt.pix_mp.plane_fmt[0].bytesperline;
 	org->fmt.pix.sizeimage = fmt.fmt.pix_mp.plane_fmt[0].sizeimage;
-	org->fmt.pix.priv = 0;
+	org->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
+	org->fmt.pix.flags = fmt.fmt.pix_mp.flags;
 
 	/*
 	 * If the device doesn't support just one plane, there's
