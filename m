Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:43598 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755129AbdCKJVs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 11 Mar 2017 04:21:48 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 1/3] libv4lconvert: expose bayer formats
Date: Sat, 11 Mar 2017 06:21:39 -0300
Message-Id: <db1d17c0eed07c89fae03275bda0fe4d3d5c1776.1489224099.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently, the bayer formats, if present, are not shown to the
applications, with prevents them to use more optimized code to
handle it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 lib/libv4lconvert/libv4lconvert.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/lib/libv4lconvert/libv4lconvert.c b/lib/libv4lconvert/libv4lconvert.c
index da718918b030..6cfaf6edbc40 100644
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
-- 
2.9.3
