Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1594 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106AbaGQW1x (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 18:27:53 -0400
Message-ID: <53C84DDE.4000701@xs4all.nl>
Date: Fri, 18 Jul 2014 00:27:42 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH] libv4lconvert: add support for new pixelformats
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Support for alpha-channel aware pixelformats was added. Recognize those formats
in libv4lconvert.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/lib/libv4lconvert/libv4lconvert.c b/lib/libv4lconvert/libv4lconvert.c
index 7ee7c19..cea65aa 100644
--- a/lib/libv4lconvert/libv4lconvert.c
+++ b/lib/libv4lconvert/libv4lconvert.c
@@ -86,6 +86,10 @@ static const struct v4lconvert_pixfmt supported_src_pixfmts[] = {
 	{ V4L2_PIX_FMT_RGB565,		16,	 4,	 6,	0 },
 	{ V4L2_PIX_FMT_BGR32,		32,	 4,	 6,	0 },
 	{ V4L2_PIX_FMT_RGB32,		32,	 4,	 6,	0 },
+	{ V4L2_PIX_FMT_XBGR32,		32,	 4,	 6,	0 },
+	{ V4L2_PIX_FMT_XRGB32,		32,	 4,	 6,	0 },
+	{ V4L2_PIX_FMT_ABGR32,		32,	 4,	 6,	0 },
+	{ V4L2_PIX_FMT_ARGB32,		32,	 4,	 6,	0 },
 	/* yuv 4:2:2 formats */
 	{ V4L2_PIX_FMT_YUYV,		16,	 5,	 4,	0 },
 	{ V4L2_PIX_FMT_YVYU,		16,	 5,	 4,	0 },
@@ -1121,6 +1125,8 @@ static int v4lconvert_convert_pixfmt(struct v4lconvert_data *data,
 		break;
 
 	case V4L2_PIX_FMT_RGB32:
+	case V4L2_PIX_FMT_XRGB32:
+	case V4L2_PIX_FMT_ARGB32:
 		if (src_size < (width * height * 4)) {
 			V4LCONVERT_ERR("short rgb32 data frame\n");
 			errno = EPIPE;
@@ -1143,6 +1149,8 @@ static int v4lconvert_convert_pixfmt(struct v4lconvert_data *data,
 		break;
 
 	case V4L2_PIX_FMT_BGR32:
+	case V4L2_PIX_FMT_XBGR32:
+	case V4L2_PIX_FMT_ABGR32:
 		if (src_size < (width * height * 4)) {
 			V4LCONVERT_ERR("short bgr32 data frame\n");
 			errno = EPIPE;
