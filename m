Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:43320 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726935AbeHWLB1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Aug 2018 07:01:27 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 5/7] vicodec: improve handling of uncompressable planes
Date: Thu, 23 Aug 2018 09:33:03 +0200
Message-Id: <20180823073305.6518-6-hverkuil@xs4all.nl>
In-Reply-To: <20180823073305.6518-1-hverkuil@xs4all.nl>
References: <20180823073305.6518-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Exit the loop immediately once it is clear that the plane
cannot be compressed. Also clear the PCODED bit and fix the
PCODED check (it should check for the bit) in the caller code.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vicodec/vicodec-codec.c | 10 ++++++----
 drivers/media/platform/vicodec/vicodec-core.c  |  2 +-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/vicodec/vicodec-codec.c b/drivers/media/platform/vicodec/vicodec-codec.c
index e402d988f2ad..3547129c1163 100644
--- a/drivers/media/platform/vicodec/vicodec-codec.c
+++ b/drivers/media/platform/vicodec/vicodec-codec.c
@@ -685,9 +685,6 @@ static u32 encode_plane(u8 *input, u8 *refp, __be16 **rlco, __be16 *rlco_max,
 			input += 8 * input_step;
 			refp += 8 * 8;
 
-			if (encoding & FRAME_UNENCODED)
-				continue;
-
 			size = rlc(cf->coeffs, *rlco, blocktype);
 			if (last_size == size &&
 			    !memcmp(*rlco + 1, *rlco - size + 1, 2 * size - 2)) {
@@ -702,12 +699,16 @@ static u32 encode_plane(u8 *input, u8 *refp, __be16 **rlco, __be16 *rlco_max,
 			} else {
 				*rlco += size;
 			}
-			if (*rlco >= rlco_max)
+			if (*rlco >= rlco_max) {
 				encoding |= FRAME_UNENCODED;
+				goto exit_loop;
+			}
 			last_size = size;
 		}
 		input += width * 7 * input_step;
 	}
+
+exit_loop:
 	if (encoding & FRAME_UNENCODED) {
 		u8 *out = (u8 *)rlco_start;
 
@@ -721,6 +722,7 @@ static u32 encode_plane(u8 *input, u8 *refp, __be16 **rlco, __be16 *rlco_max,
 		for (i = 0; i < height * width; i++, input += input_step)
 			*out++ = (*input == 0xff) ? 0xfe : *input;
 		*rlco = (__be16 *)out;
+		encoding &= ~FRAME_PCODED;
 	}
 	return encoding;
 }
diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index 4680b3c9b9b2..caff521d94c6 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -281,7 +281,7 @@ static void encode(struct vicodec_ctx *ctx,
 
 	encoding = encode_frame(&rf, &ctx->ref_frame, &cf, !ctx->gop_cnt,
 				ctx->gop_cnt == ctx->gop_size - 1);
-	if (encoding != FRAME_PCODED)
+	if (!(encoding & FRAME_PCODED))
 		ctx->gop_cnt = 0;
 	if (++ctx->gop_cnt >= ctx->gop_size)
 		ctx->gop_cnt = 0;
-- 
2.18.0
