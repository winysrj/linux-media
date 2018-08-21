Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:52239 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726785AbeHUKuZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Aug 2018 06:50:25 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 4/6] vicodec: simplify blocktype checking
Date: Tue, 21 Aug 2018 09:31:17 +0200
Message-Id: <20180821073119.3662-5-hverkuil@xs4all.nl>
In-Reply-To: <20180821073119.3662-1-hverkuil@xs4all.nl>
References: <20180821073119.3662-1-hverkuil@xs4all.nl>
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
