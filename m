Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:55571 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932372AbdCJUxi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Mar 2017 15:53:38 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH] libv4lconvert: by default, offer the original format to the client
Date: Fri, 10 Mar 2017 17:53:26 -0300
Message-Id: <bfae3cb4407b1de1a29ca450e20bbc16d8262884.1489179204.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The libv4lconvert part of libv4l was meant to provide a common
place to handle weird proprietary formats. With time, we also
added support to other standard formats, in order to help
V4L2 applications that are not performance sensitive to support
all V4L2 formats.

Yet, the hole idea is to let userspace to decide to implement
their own format conversion code when it needs either more
performance or more quality than what libv4lconvert provides.

In other words, applications should have the right to decide
between using a libv4lconvert emulated format or to implement
the decoding themselves for non-proprietary formats,
as this may have significative performance impact.

At the application side, deciding between them is just a matter
of looking at the V4L2_FMT_FLAG_EMULATED flag.

Yet, we don't want to have a miriad of format converters
everywhere for the proprietary formats, like V4L2_PIX_FMT_KONICA420,
V4L2_PIX_FMT_SPCA501, etc. So, let's offer only the emulated
variant for those weird stuff.

So, this patch changes the libv4lconvert behavior, for
all non-proprietary formats, including Bayer, to offer both
the original format and the emulated ones.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 lib/libv4lconvert/libv4lconvert.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/lib/libv4lconvert/libv4lconvert.c b/lib/libv4lconvert/libv4lconvert.c
index da718918b030..d87d6b91a838 100644
--- a/lib/libv4lconvert/libv4lconvert.c
+++ b/lib/libv4lconvert/libv4lconvert.c
@@ -118,10 +118,10 @@ static const struct v4lconvert_pixfmt supported_src_pixfmts[] = {
 	{ V4L2_PIX_FMT_OV511,		 0,	 7,	 7,	1 },
 	{ V4L2_PIX_FMT_OV518,		 0,	 7,	 7,	1 },
 	/* uncompressed bayer */
-	{ V4L2_PIX_FMT_SBGGR8,		 8,	 8,	 8,	1 },
-	{ V4L2_PIX_FMT_SGBRG8,		 8,	 8,	 8,	1 },
-	{ V4L2_PIX_FMT_SGRBG8,		 8,	 8,	 8,	1 },
-	{ V4L2_PIX_FMT_SRGGB8,		 8,	 8,	 8,	1 },
+	{ V4L2_PIX_FMT_SBGGR8,		 8,	 8,	 8,	0 },
+	{ V4L2_PIX_FMT_SGBRG8,		 8,	 8,	 8,	0 },
+	{ V4L2_PIX_FMT_SGRBG8,		 8,	 8,	 8,	0 },
+	{ V4L2_PIX_FMT_SRGGB8,		 8,	 8,	 8,	0 },
 	{ V4L2_PIX_FMT_STV0680,		 8,	 8,	 8,	1 },
 	/* compressed bayer */
 	{ V4L2_PIX_FMT_SPCA561,		 0,	 9,	 9,	1 },
@@ -178,7 +178,7 @@ struct v4lconvert_data *v4lconvert_create_with_dev_ops(int fd, void *dev_ops_pri
 	/* This keeps tracks of devices which have only formats for which apps
 	   most likely will need conversion and we can thus safely add software
 	   processing controls without a performance impact. */
-	int always_needs_conversion = 1;
+	int always_needs_conversion = 0;
 
 	if (!data) {
 		fprintf(stderr, "libv4lconvert: error: out of memory!\n");
@@ -208,10 +208,9 @@ struct v4lconvert_data *v4lconvert_create_with_dev_ops(int fd, void *dev_ops_pri
 		if (j < ARRAY_SIZE(supported_src_pixfmts)) {
 			data->supported_src_formats |= 1ULL << j;
 			v4lconvert_get_framesizes(data, fmt.pixelformat, j);
-			if (!supported_src_pixfmts[j].needs_conversion)
-				always_needs_conversion = 0;
-		} else
-			always_needs_conversion = 0;
+			if (supported_src_pixfmts[j].needs_conversion)
+				always_needs_conversion = 1;
+		}
 	}
 
 	data->no_formats = i;
-- 
2.9.3
