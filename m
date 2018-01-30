Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway36.websitewelcome.com ([50.116.124.69]:14638 "EHLO
        gateway36.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751417AbeA3AxC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Jan 2018 19:53:02 -0500
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway36.websitewelcome.com (Postfix) with ESMTP id 2F06A401D7C67
        for <linux-media@vger.kernel.org>; Mon, 29 Jan 2018 18:31:50 -0600 (CST)
Date: Mon, 29 Jan 2018 18:31:47 -0600
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH 3/8] i2c: max2175: fix potential integer overflow in
 max2175_set_nco_freq
Message-ID: <4d475a610cb9c5c274ca4c9f4b1bc422c00776c0.1517268668.git.gustavo@embeddedor.com>
References: <cover.1517268667.git.gustavo@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1517268667.git.gustavo@embeddedor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cast expression (clock_rate - abs_nco_freq) to s64 in order to avoid
a potential integer overflow. This variable is being used in a
context that expects an expression of type s64.

Addresses-Coverity-ID: 1446589 ("Unintentional integer overflow")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/media/i2c/max2175.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/max2175.c b/drivers/media/i2c/max2175.c
index 2f1966b..3401ae6 100644
--- a/drivers/media/i2c/max2175.c
+++ b/drivers/media/i2c/max2175.c
@@ -643,7 +643,7 @@ static int max2175_set_nco_freq(struct max2175 *ctx, s32 nco_freq)
 	if (abs_nco_freq < clock_rate / 2) {
 		nco_val_desired = 2 * nco_freq;
 	} else {
-		nco_val_desired = 2 * (clock_rate - abs_nco_freq);
+		nco_val_desired = 2 * (s64)(clock_rate - abs_nco_freq);
 		if (nco_freq < 0)
 			nco_val_desired = -nco_val_desired;
 	}
-- 
2.7.4
