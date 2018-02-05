Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway30.websitewelcome.com ([192.185.149.4]:36502 "EHLO
        gateway30.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750949AbeBEUIG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Feb 2018 15:08:06 -0500
Received: from cm15.websitewelcome.com (cm15.websitewelcome.com [100.42.49.9])
        by gateway30.websitewelcome.com (Postfix) with ESMTP id 10208D305
        for <linux-media@vger.kernel.org>; Mon,  5 Feb 2018 14:08:06 -0600 (CST)
Date: Mon, 5 Feb 2018 14:08:04 -0600
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH v2 3/8] i2c: max2175: use 64-bit arithmetic instead of 32-bit
Message-ID: <fdeffeff7451f52fd903e4773c6b10fe21f707e4.1517856716.git.gustavo@embeddedor.com>
References: <cover.1517856716.git.gustavo@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1517856716.git.gustavo@embeddedor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add suffix LL to constant 2 in order to give the compiler complete
information about the proper arithmetic to use. Notice that this
constant is used in a context that expects an expression of type
s64 (64 bits, signed).

The expression 2 * (clock_rate - abs_nco_freq) is currently being
evaluated using 32-bit arithmetic.

Addresses-Coverity-ID: 1446589
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
Changes in v2:
 - Update subject and changelog to better reflect the proposed code changes.
 - Add suffix LL to constant instead of casting a variable.

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
