Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway31.websitewelcome.com ([192.185.144.91]:11048 "EHLO
        gateway31.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751521AbdITDD3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 23:03:29 -0400
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway31.websitewelcome.com (Postfix) with ESMTP id 3DA576E8462
        for <linux-media@vger.kernel.org>; Tue, 19 Sep 2017 21:41:45 -0500 (CDT)
Date: Tue, 19 Sep 2017 21:41:37 -0500
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] ov9655: fix potential integer overflow
Message-ID: <20170920024043.GA372@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add suffix ULL to constant 10000 rather than casting the result of the
operation in order to avoid a potential integer overflow. This constant
is used in a context that expects an expression of type u64.

Addresses-Coverity-ID: 1324146
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/media/i2c/ov9650.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/ov9650.c b/drivers/media/i2c/ov9650.c
index 6ffb460..91a09ee 100644
--- a/drivers/media/i2c/ov9650.c
+++ b/drivers/media/i2c/ov9650.c
@@ -1129,8 +1129,8 @@ static int __ov965x_set_frame_interval(struct ov965x *ov965x,
 	if (fi->interval.denominator == 0)
 		return -EINVAL;
 
-	req_int = (u64)(fi->interval.numerator * 10000) /
-		fi->interval.denominator;
+	req_int = (fi->interval.numerator * 10000ULL) /
+		  fi->interval.denominator;
 
 	for (i = 0; i < ARRAY_SIZE(ov965x_intervals); i++) {
 		const struct ov965x_interval *iv = &ov965x_intervals[i];
-- 
2.7.4
