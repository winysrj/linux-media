Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:39537 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751140AbbCTQXL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Mar 2015 12:23:11 -0400
Received: from [192.168.1.106] (marune.xs4all.nl [80.101.105.217])
	by tschai.lan (Postfix) with ESMTPSA id 7824B2A009F
	for <linux-media@vger.kernel.org>; Fri, 20 Mar 2015 17:22:59 +0100 (CET)
Message-ID: <550C496A.4030200@xs4all.nl>
Date: Fri, 20 Mar 2015 17:23:06 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [PATCH] vivid-tpg.c: fix wrong Bt.2020 coefficients
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mistyping 0.2627 as 0.2726 I can understand, but -0.4598 as -0.4629? No idea how
I managed that. Anyway, these coefficients are now correct again.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/platform/vivid/vivid-tpg.c b/drivers/media/platform/vivid/vivid-tpg.c
index 34493f4..1ab5ddb 100644
--- a/drivers/media/platform/vivid/vivid-tpg.c
+++ b/drivers/media/platform/vivid/vivid-tpg.c
@@ -347,9 +347,9 @@ static void color_to_ycbcr(struct tpg_data *tpg, int r, int g, int b,
 		{ COEFF(0.5, 224),    COEFF(-0.445, 224), COEFF(-0.055, 224) },
 	};
 	static const int bt2020[3][3] = {
-		{ COEFF(0.2726, 219),  COEFF(0.6780, 219),  COEFF(0.0593, 219)  },
+		{ COEFF(0.2627, 219),  COEFF(0.6780, 219),  COEFF(0.0593, 219)  },
 		{ COEFF(-0.1396, 224), COEFF(-0.3604, 224), COEFF(0.5, 224)     },
-		{ COEFF(0.5, 224),     COEFF(-0.4629, 224), COEFF(-0.0405, 224) },
+		{ COEFF(0.5, 224),     COEFF(-0.4598, 224), COEFF(-0.0402, 224) },
 	};
 	bool full = tpg->real_quantization == V4L2_QUANTIZATION_FULL_RANGE;
 	unsigned y_offset = full ? 0 : 16;
