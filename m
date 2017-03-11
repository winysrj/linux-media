Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:40805 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751788AbdCKJb5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 11 Mar 2017 04:31:57 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH v2 2/2] libv4lconvert: expose bayer formats
Date: Sat, 11 Mar 2017 06:31:48 -0300
Message-Id: <1c6979a9eb98d52c47ebe4989480f67b467a0720.1489224702.git.mchehab@s-opensource.com>
In-Reply-To: <f389eeb8826caf429b0948469bb7ce48f5276851.1489224702.git.mchehab@s-opensource.com>
References: <f389eeb8826caf429b0948469bb7ce48f5276851.1489224702.git.mchehab@s-opensource.com>
In-Reply-To: <f389eeb8826caf429b0948469bb7ce48f5276851.1489224702.git.mchehab@s-opensource.com>
References: <f389eeb8826caf429b0948469bb7ce48f5276851.1489224702.git.mchehab@s-opensource.com>
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

Currently, the bayer formats, if present, are not shown to the
applications, with prevents them to use more optimized code to
handle it. Change them to be shown to userspace.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 lib/libv4lconvert/libv4lconvert.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/lib/libv4lconvert/libv4lconvert.c b/lib/libv4lconvert/libv4lconvert.c
index 2718446ff239..4965e38754e2 100644
--- a/lib/libv4lconvert/libv4lconvert.c
+++ b/lib/libv4lconvert/libv4lconvert.c
@@ -125,10 +125,10 @@ static const struct v4lconvert_pixfmt supported_src_pixfmts[] = {
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
-- 
2.9.3
