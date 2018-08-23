Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:53268 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726925AbeHWLB1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Aug 2018 07:01:27 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 4/7] vicodec: simplify blocktype checking
Date: Thu, 23 Aug 2018 09:33:02 +0200
Message-Id: <20180823073305.6518-5-hverkuil@xs4all.nl>
In-Reply-To: <20180823073305.6518-1-hverkuil@xs4all.nl>
References: <20180823073305.6518-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Simplify some blocktype/is_intra checks.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vicodec/vicodec-codec.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/platform/vicodec/vicodec-codec.c b/drivers/media/platform/vicodec/vicodec-codec.c
index 7bd11a974db0..e402d988f2ad 100644
--- a/drivers/media/platform/vicodec/vicodec-codec.c
+++ b/drivers/media/platform/vicodec/vicodec-codec.c
@@ -663,11 +663,10 @@ static u32 encode_plane(u8 *input, u8 *refp, __be16 **rlco, __be16 *rlco_max,
 			if (!is_intra)
 				blocktype = decide_blocktype(input, refp,
 					deltablock, width, input_step);
-			if (is_intra || blocktype == IBLOCK) {
+			if (blocktype == IBLOCK) {
 				fwht(input, cf->coeffs, width, input_step, 1);
 				quantize_intra(cf->coeffs, cf->de_coeffs,
 					       cf->i_frame_qp);
-				blocktype = IBLOCK;
 			} else {
 				/* inter code */
 				encoding |= FRAME_PCODED;
-- 
2.18.0
