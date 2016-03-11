Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:36248 "EHLO
	smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbcCKUlS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2016 15:41:18 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
To: hverkuil@xs4all.nl, linux-media@vger.kernel.org
Cc: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
Subject: [v4l-utils PATCH] libv4lconvert: Add support for V4L2_PIX_FMT_NV16
Date: Fri, 11 Mar 2016 21:40:11 +0100
Message-Id: <1457728811-3337-1-git-send-email-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

NV16 are two-plane versions of the YUV 4:2:2 format (V4L2_PIX_FMT_YUVU).
Support it by merging the two planes into a one YUVU plane and falling
through to the V4L2_PIX_FMT_YUVU code path.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---

I'm sorry this is a bit of a hack. The support for NV16 are scarce and
this allowed me use it in qv4l2 so I thought it might help someone else.
I'm not to sure about the entry in supported_src_pixfmts[] is it correct
to set 'needs conversion' for my use case?

 lib/libv4lconvert/libv4lconvert-priv.h |  3 +++
 lib/libv4lconvert/libv4lconvert.c      | 15 +++++++++++++++
 lib/libv4lconvert/rgbyuv.c             | 17 +++++++++++++++++
 3 files changed, 35 insertions(+)

diff --git a/lib/libv4lconvert/libv4lconvert-priv.h b/lib/libv4lconvert/libv4lconvert-priv.h
index b77e3d3..1740efc 100644
--- a/lib/libv4lconvert/libv4lconvert-priv.h
+++ b/lib/libv4lconvert/libv4lconvert-priv.h
@@ -129,6 +129,9 @@ void v4lconvert_yuyv_to_bgr24(const unsigned char *src, unsigned char *dst,
 void v4lconvert_yuyv_to_yuv420(const unsigned char *src, unsigned char *dst,
 		int width, int height, int stride, int yvu);

+void v4lconvert_nv16_to_yuyv(const unsigned char *src, unsigned char *dest,
+		int width, int height);
+
 void v4lconvert_yvyu_to_rgb24(const unsigned char *src, unsigned char *dst,
 		int width, int height, int stride);

diff --git a/lib/libv4lconvert/libv4lconvert.c b/lib/libv4lconvert/libv4lconvert.c
index f62aea1..5426cb2 100644
--- a/lib/libv4lconvert/libv4lconvert.c
+++ b/lib/libv4lconvert/libv4lconvert.c
@@ -98,6 +98,7 @@ static const struct v4lconvert_pixfmt supported_src_pixfmts[] = {
 	{ V4L2_PIX_FMT_YUYV,		16,	 5,	 4,	0 },
 	{ V4L2_PIX_FMT_YVYU,		16,	 5,	 4,	0 },
 	{ V4L2_PIX_FMT_UYVY,		16,	 5,	 4,	0 },
+	{ V4L2_PIX_FMT_NV16,		16,	 5,	 4,	1 },
 	/* yuv 4:2:0 formats */
 	{ V4L2_PIX_FMT_SPCA501,		12,      6,	 3,	1 },
 	{ V4L2_PIX_FMT_SPCA505,		12,	 6,	 3,	1 },
@@ -1229,6 +1230,20 @@ static int v4lconvert_convert_pixfmt(struct v4lconvert_data *data,
 		}
 		break;

+	case V4L2_PIX_FMT_NV16: {
+		unsigned char *tmpbuf;
+
+		tmpbuf = v4lconvert_alloc_buffer(width * height * 2,
+				&data->convert_pixfmt_buf, &data->convert_pixfmt_buf_size);
+		if (!tmpbuf)
+			return v4lconvert_oom_error(data);
+
+		v4lconvert_nv16_to_yuyv(src, tmpbuf, width, height);
+		src_pix_fmt = V4L2_PIX_FMT_YUYV;
+		src = tmpbuf;
+		bytesperline = bytesperline * 2;
+		/* fall through */
+	}
 	case V4L2_PIX_FMT_YUYV:
 		if (src_size < (width * height * 2)) {
 			V4LCONVERT_ERR("short yuyv data frame\n");
diff --git a/lib/libv4lconvert/rgbyuv.c b/lib/libv4lconvert/rgbyuv.c
index 695255a..a9d6f5b 100644
--- a/lib/libv4lconvert/rgbyuv.c
+++ b/lib/libv4lconvert/rgbyuv.c
@@ -295,6 +295,23 @@ void v4lconvert_yuyv_to_yuv420(const unsigned char *src, unsigned char *dest,
 	}
 }

+void v4lconvert_nv16_to_yuyv(const unsigned char *src, unsigned char *dest,
+		int width, int height)
+{
+	const unsigned char *y, *cbcr;
+	int count;
+
+	y = src;
+	cbcr = src + width*height;
+	count = 0;
+
+	while (count++ < width*height) {
+		*dest++ = *y++;
+		*dest++ = *cbcr++;
+	}
+
+}
+
 void v4lconvert_yvyu_to_bgr24(const unsigned char *src, unsigned char *dest,
 		int width, int height, int stride)
 {
--
2.7.2

