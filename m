Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:34061 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755332AbaDGNRF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Apr 2014 09:17:05 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N3N00CFKWWG5PD0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 07 Apr 2014 22:17:05 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 8/8] [media] s5p_jpeg: Fix NV12 format entry related to S5C2120
 SoC
Date: Mon, 07 Apr 2014 15:16:13 +0200
Message-id: <1396876573-15811-8-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1396876573-15811-1-git-send-email-j.anaszewski@samsung.com>
References: <1396876573-15811-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

S5PC210 SoC doesn't support encoding NV12 raw images. Remove
the relavant flag from the respective entry in the sjpeg_formats
array.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 9228bcb..a57a1e0 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -192,8 +192,7 @@ static struct s5p_jpeg_fmt sjpeg_formats[] = {
 		.colplanes	= 2,
 		.h_align	= 4,
 		.v_align	= 4,
-		.flags		= SJPEG_FMT_FLAG_ENC_OUTPUT |
-				  SJPEG_FMT_FLAG_DEC_CAPTURE |
+		.flags		= SJPEG_FMT_FLAG_DEC_CAPTURE |
 				  SJPEG_FMT_FLAG_S5P |
 				  SJPEG_FMT_NON_RGB,
 		.subsampling	= V4L2_JPEG_CHROMA_SUBSAMPLING_420,
-- 
1.7.9.5

