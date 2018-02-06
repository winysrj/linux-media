Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway24.websitewelcome.com ([192.185.50.66]:27593 "EHLO
        gateway24.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752286AbeBFRKK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Feb 2018 12:10:10 -0500
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway24.websitewelcome.com (Postfix) with ESMTP id 12F85E9AD5
        for <linux-media@vger.kernel.org>; Tue,  6 Feb 2018 10:47:39 -0600 (CST)
Date: Tue, 6 Feb 2018 10:47:37 -0600
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH v3 3/8] i2c: max2175: use 64-bit arithmetic instead of 32-bit
Message-ID: <fdeffeff7451f52fd903e4773c6b10fe21f707e4.1517929336.git.gustavo@embeddedor.com>
References: <cover.1517929336.git.gustavo@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1517929336.git.gustavo@embeddedor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add suffix LL to constant 2 in order to give the compiler complete
information about the proper arithmetic to use. Notice that this
constant is used in a context that expects an expression of type
s64 (64 bits, signed).

The expression 2 * (clock_rate - abs_nco_freq) is currently being
evaluated using 32-bit arithmetic.

Addresses-Coverity-ID: 1446589 ("Unintentional integer overflow")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
Changes in v2:
 - Update subject and changelog to better reflect the proposed code changes.
 - Add suffix LL to constant instead of casting a variable.

Changes in v3:
 - Mention the specific Coverity report in the commit message.

 drivers/media/i2c/max2175.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/max2175.c b/drivers/media/i2c/max2175.c
index 2f1966b..87cba15 100644
--- a/drivers/media/i2c/max2175.c
+++ b/drivers/media/i2c/max2175.c
@@ -643,7 +643,7 @@ static int max2175_set_nco_freq(struct max2175 *ctx, s32 nco_freq)
 	if (abs_nco_freq < clock_rate / 2) {
 		nco_val_desired = 2 * nco_freq;
 	} else {
-		nco_val_desired = 2 * (clock_rate - abs_nco_freq);
+		nco_val_desired = 2LL * (clock_rate - abs_nco_freq);
 		if (nco_freq < 0)
 			nco_val_desired = -nco_val_desired;
 	}
-- 
2.7.4
