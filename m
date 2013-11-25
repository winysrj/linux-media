Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:58468 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab3KYJ6l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Nov 2013 04:58:41 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MWT00JZHD1SKU30@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 25 Nov 2013 18:58:40 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: sw0312.kim@samsung.com, andrzej.p@samsung.com,
	s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v2 02/16] s5p-jpeg: Fix output YUV 4:2:0 fourcc for decoder
Date: Mon, 25 Nov 2013 10:58:09 +0100
Message-id: <1385373503-1657-3-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1385373503-1657-1-git-send-email-j.anaszewski@samsung.com>
References: <1385373503-1657-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Output samples during decoding phase for the YUV 4:2:0 format
are arranged in the manner compatible with 2-planar NV12,
not 3-planar YUV420 fourcc.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 2234944..0f567c5 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -58,7 +58,7 @@ static struct s5p_jpeg_fmt formats_enc[] = {
 static struct s5p_jpeg_fmt formats_dec[] = {
 	{
 		.name		= "YUV 4:2:0 planar, YCbCr",
-		.fourcc		= V4L2_PIX_FMT_YUV420,
+		.fourcc		= V4L2_PIX_FMT_NV12,
 		.depth		= 12,
 		.colplanes	= 3,
 		.h_align	= 4,
-- 
1.7.9.5

