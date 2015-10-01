Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49338 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbbJAWRm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Oct 2015 18:17:42 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
Subject: [PATCH 7/7] [media] rcar_jpu: Fix namespace for two __be16 vars
Date: Thu,  1 Oct 2015 19:17:29 -0300
Message-Id: <996347612dc58b534e397a742b3bfd3023850bb1.1443737683.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1443737682.git.mchehab@osg.samsung.com>
References: <cover.1443737682.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1443737682.git.mchehab@osg.samsung.com>
References: <cover.1443737682.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes those sparse warnings:
	drivers/media/platform/rcar_jpu.c:1150:51: warning: incorrect type in assignment (different base types)
	drivers/media/platform/rcar_jpu.c:1150:51:    expected unsigned short [unsigned] [short] [usertype] <noident>
	drivers/media/platform/rcar_jpu.c:1150:51:    got restricted __be16 [usertype] <noident>
	drivers/media/platform/rcar_jpu.c:1152:50: warning: incorrect type in assignment (different base types)
	drivers/media/platform/rcar_jpu.c:1152:50:    expected unsigned short [unsigned] [short] [usertype] <noident>
	drivers/media/platform/rcar_jpu.c:1152:50:    got restricted __be16 [usertype] <noident>

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/platform/rcar_jpu.c b/drivers/media/platform/rcar_jpu.c
index 7533b9e16649..c80395df67bc 100644
--- a/drivers/media/platform/rcar_jpu.c
+++ b/drivers/media/platform/rcar_jpu.c
@@ -1147,9 +1147,9 @@ static void jpu_buf_finish(struct vb2_buffer *vb)
 	buffer = vb2_plane_vaddr(vb, 0);
 
 	memcpy(buffer, jpeg_hdrs[jpu_buf->compr_quality], JPU_JPEG_HDR_SIZE);
-	*(u16 *)(buffer + JPU_JPEG_HEIGHT_OFFSET) =
+	*(__be16 *)(buffer + JPU_JPEG_HEIGHT_OFFSET) =
 					cpu_to_be16(q_data->format.height);
-	*(u16 *)(buffer + JPU_JPEG_WIDTH_OFFSET) =
+	*(__be16 *)(buffer + JPU_JPEG_WIDTH_OFFSET) =
 					cpu_to_be16(q_data->format.width);
 	*(buffer + JPU_JPEG_SUBS_OFFSET) = q_data->fmtinfo->subsampling;
 }
-- 
2.4.3


