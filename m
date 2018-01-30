Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway22.websitewelcome.com ([192.185.46.233]:40107 "EHLO
        gateway22.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752113AbeA3Azm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Jan 2018 19:55:42 -0500
Received: from cm15.websitewelcome.com (cm15.websitewelcome.com [100.42.49.9])
        by gateway22.websitewelcome.com (Postfix) with ESMTP id 1093C5500
        for <linux-media@vger.kernel.org>; Mon, 29 Jan 2018 18:32:02 -0600 (CST)
Date: Mon, 29 Jan 2018 18:32:01 -0600
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH 4/8] i2c: ov9650: fix potential integer overflow in
 __ov965x_set_frame_interval
Message-ID: <8ccf6acf10745fd1b9f33a7cacd5365e125633bf.1517268668.git.gustavo@embeddedor.com>
References: <cover.1517268667.git.gustavo@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1517268667.git.gustavo@embeddedor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cast fi->interval.numerator to u64 in order to avoid a potential integer
overflow. This variable is being used in a context that expects an
expression of type u64.

Addresses-Coverity-ID: 1324146 ("Unintentional integer overflow")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/media/i2c/ov9650.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov9650.c b/drivers/media/i2c/ov9650.c
index e519f27..c674a49 100644
--- a/drivers/media/i2c/ov9650.c
+++ b/drivers/media/i2c/ov9650.c
@@ -1130,7 +1130,7 @@ static int __ov965x_set_frame_interval(struct ov965x *ov965x,
 	if (fi->interval.denominator == 0)
 		return -EINVAL;
 
-	req_int = (u64)(fi->interval.numerator * 10000) /
+	req_int = (u64)fi->interval.numerator * 10000 /
 		fi->interval.denominator;
 
 	for (i = 0; i < ARRAY_SIZE(ov965x_intervals); i++) {
-- 
2.7.4
