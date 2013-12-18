Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:45784 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021Ab3LROt7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Dec 2013 09:49:59 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MY0001RZBVANY70@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Wed, 18 Dec 2013 23:49:58 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH v3 3/8] s5p-jpeg: Retrieve "YCbCr subsampling" field from the
 jpeg header
Date: Wed, 18 Dec 2013 15:49:30 +0100
Message-id: <1387378175-23399-4-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1387378175-23399-1-git-send-email-j.anaszewski@samsung.com>
References: <1387378175-23399-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make s5p_jpeg_parse_hdr function capable of parsing
"YCbCr subsampling" field of a jpeg file header.
Store the parsed value in the context. The information
about source JPEG subsampling is required to make validation
of destination format possible, which must be conducted
for exynos4x12 device as the decoding process will not succeed
if the destination format is set to YUV with subsampling lower
than the one of the source JPEG image. With this knowledge
the driver can adjust the destination format appropriately.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c |   35 ++++++++++++++++++++++++---
 1 file changed, 31 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 242e8b8..ffae566 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -624,10 +624,11 @@ static void skip(struct s5p_jpeg_buffer *buf, long len)
 }
 
 static bool s5p_jpeg_parse_hdr(struct s5p_jpeg_q_data *result,
-			       unsigned long buffer, unsigned long size)
+			       unsigned long buffer, unsigned long size,
+			       struct s5p_jpeg_ctx *ctx)
 {
 	int c, components, notfound;
-	unsigned int height, width, word;
+	unsigned int height, width, word, subsampling = 0;
 	long length;
 	struct s5p_jpeg_buffer jpeg_buffer;
 
@@ -666,7 +667,15 @@ static bool s5p_jpeg_parse_hdr(struct s5p_jpeg_q_data *result,
 				break;
 			notfound = 0;
 
-			skip(&jpeg_buffer, components * 3);
+			if (components == 1) {
+				subsampling = 0x33;
+			} else {
+				skip(&jpeg_buffer, 1);
+				subsampling = get_byte(&jpeg_buffer);
+				skip(&jpeg_buffer, 1);
+			}
+
+			skip(&jpeg_buffer, components * 2);
 			break;
 
 		/* skip payload-less markers */
@@ -688,6 +697,24 @@ static bool s5p_jpeg_parse_hdr(struct s5p_jpeg_q_data *result,
 	result->w = width;
 	result->h = height;
 	result->size = components;
+
+	switch (subsampling) {
+	case 0x11:
+		ctx->subsampling = V4L2_JPEG_CHROMA_SUBSAMPLING_444;
+		break;
+	case 0x21:
+		ctx->subsampling = V4L2_JPEG_CHROMA_SUBSAMPLING_422;
+		break;
+	case 0x22:
+		ctx->subsampling = V4L2_JPEG_CHROMA_SUBSAMPLING_420;
+		break;
+	case 0x33:
+		ctx->subsampling = V4L2_JPEG_CHROMA_SUBSAMPLING_GRAY;
+		break;
+	default:
+		return false;
+	}
+
 	return !notfound;
 }
 
@@ -1438,7 +1465,7 @@ static void s5p_jpeg_buf_queue(struct vb2_buffer *vb)
 		ctx->hdr_parsed = s5p_jpeg_parse_hdr(&tmp,
 		     (unsigned long)vb2_plane_vaddr(vb, 0),
 		     min((unsigned long)ctx->out_q.size,
-			 vb2_get_plane_payload(vb, 0)));
+			 vb2_get_plane_payload(vb, 0)), ctx);
 		if (!ctx->hdr_parsed) {
 			vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
 			return;
-- 
1.7.9.5

