Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:57349 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751179AbbCHHbK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Mar 2015 03:31:10 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id D130F2A0090
	for <linux-media@vger.kernel.org>; Sun,  8 Mar 2015 08:30:47 +0100 (CET)
Message-ID: <54FBFAA7.6010102@xs4all.nl>
Date: Sun, 08 Mar 2015 08:30:47 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] v4l2-ioctl: tidy up debug messages
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make sure the format fields are reported consistently.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index b084072..84fb034 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -257,7 +257,7 @@ static void v4l_print_format(const void *arg, bool write_only)
 		pr_cont(", width=%u, height=%u, "
 			"pixelformat=%c%c%c%c, field=%s, "
 			"bytesperline=%u, sizeimage=%u, colorspace=%d, "
-			"flags %x, ycbcr_enc=%u, quantization=%u\n",
+			"flags=0x%x, ycbcr_enc=%u, quantization=%u\n",
 			pix->width, pix->height,
 			(pix->pixelformat & 0xff),
 			(pix->pixelformat >>  8) & 0xff,
@@ -273,7 +273,7 @@ static void v4l_print_format(const void *arg, bool write_only)
 		mp = &p->fmt.pix_mp;
 		pr_cont(", width=%u, height=%u, "
 			"format=%c%c%c%c, field=%s, "
-			"colorspace=%d, num_planes=%u, flags=%x, "
+			"colorspace=%d, num_planes=%u, flags=0x%x, "
 			"ycbcr_enc=%u, quantization=%u\n",
 			mp->width, mp->height,
 			(mp->pixelformat & 0xff),
-- 
2.1.4

