Return-path: <mchehab@pedra>
Received: from smtp209.alice.it ([82.57.200.105]:40868 "EHLO smtp209.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754731Ab1DGQQi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Apr 2011 12:16:38 -0400
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>,
	Steven Toth <stoth@kernellabs.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [RFC, PATCH] libv4lconvert: Add support for Y10B grey format (V4L2_PIX_FMT_Y10BPACK)
Date: Thu,  7 Apr 2011 18:16:29 +0200
Message-Id: <1302192989-7747-1-git-send-email-ospite@studenti.unina.it>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Y10B is a 10 bits per pixel greyscale format in a bit-packed array
representation. Such pixel format is supplied for instance by the Kinect
sensor device.

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---

Hi,

this is a very first attempt about supporting Y10B in libv4lconvert, the
doubts I have are about the conversion routines which need to unpack a frame
before doing the actual pixelformat conversion, and maybe this can be handled
in some conversion layer in libv4l.

I don't know libv4l yet, so I am asking for advice providing some code to
discuss on; looking at the last hunk of the patch: can I allocate a temporary
buffer only once per device (and not per frame as I am horribly doing now) and
reuse it in the conversion routines? Or is the unpacking better be done even
before conversion, feeding the conversion routines with already unpacked
buffers?

Thanks,
   Antonio Ospite
   http://ao2.it

 include/linux/videodev2.h              |    3 +
 lib/libv4lconvert/libv4lconvert-priv.h |    6 +++
 lib/libv4lconvert/libv4lconvert.c      |   20 ++++++++
 lib/libv4lconvert/rgbyuv.c             |   76 ++++++++++++++++++++++++++++++++
 4 files changed, 105 insertions(+), 0 deletions(-)

diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 51788a6..559d5f3 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -289,6 +289,9 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_Y10     v4l2_fourcc('Y', '1', '0', ' ') /* 10  Greyscale     */
 #define V4L2_PIX_FMT_Y16     v4l2_fourcc('Y', '1', '6', ' ') /* 16  Greyscale     */
 
+/* Grey bit-packed formats */
+#define V4L2_PIX_FMT_Y10BPACK    v4l2_fourcc('Y', '1', '0', 'B') /* 10  Greyscale bit-packed */
+
 /* Palette formats */
 #define V4L2_PIX_FMT_PAL8    v4l2_fourcc('P', 'A', 'L', '8') /*  8  8-bit palette */
 
diff --git a/lib/libv4lconvert/libv4lconvert-priv.h b/lib/libv4lconvert/libv4lconvert-priv.h
index 84c706e..470a869 100644
--- a/lib/libv4lconvert/libv4lconvert-priv.h
+++ b/lib/libv4lconvert/libv4lconvert-priv.h
@@ -133,6 +133,12 @@ void v4lconvert_grey_to_rgb24(const unsigned char *src, unsigned char *dest,
 void v4lconvert_grey_to_yuv420(const unsigned char *src, unsigned char *dest,
 		const struct v4l2_format *src_fmt);
 
+void v4lconvert_y10b_to_rgb24(const unsigned char *src, unsigned char *dest,
+		int width, int height);
+
+void v4lconvert_y10b_to_yuv420(const unsigned char *src, unsigned char *dest,
+		const struct v4l2_format *src_fmt);
+
 void v4lconvert_rgb565_to_rgb24(const unsigned char *src, unsigned char *dest,
 		int width, int height);
 
diff --git a/lib/libv4lconvert/libv4lconvert.c b/lib/libv4lconvert/libv4lconvert.c
index e4863fd..631d912 100644
--- a/lib/libv4lconvert/libv4lconvert.c
+++ b/lib/libv4lconvert/libv4lconvert.c
@@ -48,6 +48,7 @@ static const struct v4lconvert_pixfmt supported_src_pixfmts[] = {
 	{ V4L2_PIX_FMT_YVYU,         0 },
 	{ V4L2_PIX_FMT_UYVY,         0 },
 	{ V4L2_PIX_FMT_RGB565,       0 },
+	{ V4L2_PIX_FMT_Y10BPACK,     0 },
 	{ V4L2_PIX_FMT_SN9C20X_I420, V4LCONVERT_NEEDS_CONVERSION },
 	{ V4L2_PIX_FMT_SBGGR8,       V4LCONVERT_NEEDS_CONVERSION },
 	{ V4L2_PIX_FMT_SGBRG8,       V4LCONVERT_NEEDS_CONVERSION },
@@ -862,6 +863,25 @@ static int v4lconvert_convert_pixfmt(struct v4lconvert_data *data,
 			result = -1;
 		}
 		break;
+
+	case V4L2_PIX_FMT_Y10BPACK:
+		switch (dest_pix_fmt) {
+		case V4L2_PIX_FMT_RGB24:
+	        case V4L2_PIX_FMT_BGR24:
+			v4lconvert_y10b_to_rgb24(src, dest, width, height);
+			break;
+		case V4L2_PIX_FMT_YUV420:
+		case V4L2_PIX_FMT_YVU420:
+			v4lconvert_y10b_to_yuv420(src, dest, fmt);
+			break;
+		}
+		if (src_size < (width * height * 10 / 8)) {
+			V4LCONVERT_ERR("short y10b data frame\n");
+			errno = EPIPE;
+			result = -1;
+		}
+		break;
+
 	case V4L2_PIX_FMT_RGB565:
 		switch (dest_pix_fmt) {
 		case V4L2_PIX_FMT_RGB24:
diff --git a/lib/libv4lconvert/rgbyuv.c b/lib/libv4lconvert/rgbyuv.c
index 2ee7e58..23fe8f3 100644
--- a/lib/libv4lconvert/rgbyuv.c
+++ b/lib/libv4lconvert/rgbyuv.c
@@ -603,3 +603,79 @@ void v4lconvert_grey_to_yuv420(const unsigned char *src, unsigned char *dest,
 	/* Clear U/V */
 	memset(dest, 0x80, src_fmt->fmt.pix.width * src_fmt->fmt.pix.height / 2);
 }
+
+#include <stdint.h>
+#include <stdlib.h>
+/* Unpack buffer of (vw bit) data into padded 16bit buffer. */
+static inline void convert_packed_to_16bit(uint8_t *raw, uint16_t *unpacked, int vw, int unpacked_len)
+{
+	int mask = (1 << vw) - 1;
+	uint32_t buffer = 0;
+	int bitsIn = 0;
+	while (unpacked_len--) {
+		while (bitsIn < vw) {
+			buffer = (buffer << 8) | *(raw++);
+			bitsIn += 8;
+		}
+		bitsIn -= vw;
+		*(unpacked++) = (buffer >> bitsIn) & mask;
+	}
+}
+
+void v4lconvert_y10b_to_rgb24(const unsigned char *src, unsigned char *dest,
+		int width, int height)
+{
+	unsigned short *unpacked_buffer = NULL;
+
+	/* TODO: check return value or move the allocation out of here */
+	unpacked_buffer = malloc(width * height * sizeof(unsigned short));
+	convert_packed_to_16bit((uint8_t *)src, unpacked_buffer, 10, width * height);
+
+	int j;
+	unsigned short *tmp = unpacked_buffer;
+	while (--height >= 0) {
+		for (j = 0; j < width; j++) {
+
+			/* Only 10 useful bits, so we discard the LSBs */
+			*dest++ = (*tmp & 0x3ff) >> 2;
+			*dest++ = (*tmp & 0x3ff) >> 2;
+			*dest++ = (*tmp & 0x3ff) >> 2;
+
+			/* +1 means two bytes as we are dealing with (unsigned short) */
+			tmp += 1;
+		}
+	}
+
+	free(unpacked_buffer);
+}
+
+void v4lconvert_y10b_to_yuv420(const unsigned char *src, unsigned char *dest,
+		const struct v4l2_format *src_fmt)
+{
+	unsigned short *unpacked_buffer = NULL;
+	int width = src_fmt->fmt.pix.width;
+	int height = src_fmt->fmt.pix.height;
+
+	/* TODO: check return value or move the allocation out of here */
+	unpacked_buffer = malloc(width * height * sizeof(unsigned short));
+	convert_packed_to_16bit((uint8_t *)src, unpacked_buffer, 10, width * height);
+
+	int x, y;
+	unsigned short *tmp = unpacked_buffer;
+
+	/* Y */
+	for (y = 0; y < src_fmt->fmt.pix.height; y++)
+		for (x = 0; x < src_fmt->fmt.pix.width; x++) {
+
+			/* Only 10 useful bits, so we discard the LSBs */
+			*dest++ = (*tmp & 0x3ff) >> 2;
+
+			/* +1 means two bytes as we are dealing with (unsigned short) */
+			tmp += 1;
+		}
+
+	/* Clear U/V */
+	memset(dest, 0x80, src_fmt->fmt.pix.width * src_fmt->fmt.pix.height / 2);
+
+	free(unpacked_buffer);
+}
-- 
1.7.4.1

