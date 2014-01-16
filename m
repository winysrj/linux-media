Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:11354 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbaAPL0q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jan 2014 06:26:46 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MZH00L7ERSL7LC0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Jan 2014 20:26:45 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 2/2] s5p-jpeg: Fix wrong NV12 format parameters
Date: Thu, 16 Jan 2014 12:26:33 +0100
Message-id: <1389871593-10973-2-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1389871593-10973-1-git-send-email-j.anaszewski@samsung.com>
References: <1389871593-10973-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

NV12 format entries in the sjpeg_formats array had wrong
colplanes, depth and v_align values.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index a009bd9..6db4d5e 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -175,7 +175,7 @@ static struct s5p_jpeg_fmt sjpeg_formats[] = {
 	{
 		.name		= "YUV 4:2:0 planar, Y/CbCr",
 		.fourcc		= V4L2_PIX_FMT_NV12,
-		.depth		= 16,
+		.depth		= 12,
 		.colplanes	= 2,
 		.h_align	= 1,
 		.v_align	= 1,
@@ -188,10 +188,10 @@ static struct s5p_jpeg_fmt sjpeg_formats[] = {
 	{
 		.name		= "YUV 4:2:0 planar, Y/CbCr",
 		.fourcc		= V4L2_PIX_FMT_NV12,
-		.depth		= 16,
-		.colplanes	= 4,
+		.depth		= 12,
+		.colplanes	= 2,
 		.h_align	= 4,
-		.v_align	= 1,
+		.v_align	= 4,
 		.flags		= SJPEG_FMT_FLAG_ENC_OUTPUT |
 				  SJPEG_FMT_FLAG_DEC_CAPTURE |
 				  SJPEG_FMT_FLAG_S5P |
-- 
1.7.9.5

