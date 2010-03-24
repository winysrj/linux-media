Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10159 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932504Ab0CXTlZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Mar 2010 15:41:25 -0400
Message-ID: <4BAA6ADF.9050102@redhat.com>
Date: Wed, 24 Mar 2010 16:41:19 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>
Subject: [PATCH 1/2] V4L/DVB: cx25821-video.c: fix table indent
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Table indent were likely damaged by Lindent. Fix it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>

diff --git a/drivers/staging/cx25821/cx25821-video.c b/drivers/staging/cx25821/cx25821-video.c
index c7c14c7..7235386 100644
--- a/drivers/staging/cx25821/cx25821-video.c
+++ b/drivers/staging/cx25821/cx25821-video.c
@@ -54,31 +54,31 @@ static void init_controls(struct cx25821_dev *dev, int chan_num);
 
 struct cx25821_fmt formats[] = {
 	{
-	 .name = "8 bpp, gray",
-	 .fourcc = V4L2_PIX_FMT_GREY,
-	 .depth = 8,
-	 .flags = FORMAT_FLAGS_PACKED,
+		.name = "8 bpp, gray",
+		.fourcc = V4L2_PIX_FMT_GREY,
+		.depth = 8,
+		.flags = FORMAT_FLAGS_PACKED,
 	 }, {
-	     .name = "4:1:1, packed, Y41P",
-	     .fourcc = V4L2_PIX_FMT_Y41P,
-	     .depth = 12,
-	     .flags = FORMAT_FLAGS_PACKED,
-	     }, {
-		 .name = "4:2:2, packed, YUYV",
-		 .fourcc = V4L2_PIX_FMT_YUYV,
-		 .depth = 16,
-		 .flags = FORMAT_FLAGS_PACKED,
-		 }, {
-		     .name = "4:2:2, packed, UYVY",
-		     .fourcc = V4L2_PIX_FMT_UYVY,
-		     .depth = 16,
-		     .flags = FORMAT_FLAGS_PACKED,
-		     }, {
-			 .name = "4:2:0, YUV",
-			 .fourcc = V4L2_PIX_FMT_YUV420,
-			 .depth = 12,
-			 .flags = FORMAT_FLAGS_PACKED,
-			 },
+		.name = "4:1:1, packed, Y41P",
+		.fourcc = V4L2_PIX_FMT_Y41P,
+		.depth = 12,
+		.flags = FORMAT_FLAGS_PACKED,
+	}, {
+		.name = "4:2:2, packed, YUYV",
+		.fourcc = V4L2_PIX_FMT_YUYV,
+		.depth = 16,
+		.flags = FORMAT_FLAGS_PACKED,
+	}, {
+		.name = "4:2:2, packed, UYVY",
+		.fourcc = V4L2_PIX_FMT_UYVY,
+		.depth = 16,
+		.flags = FORMAT_FLAGS_PACKED,
+	}, {
+		.name = "4:2:0, YUV",
+		.fourcc = V4L2_PIX_FMT_YUV420,
+		.depth = 12,
+		.flags = FORMAT_FLAGS_PACKED,
+	},
 };
 
 int get_format_size(void)
-- 
1.6.6.1


