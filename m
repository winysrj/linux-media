Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway32.websitewelcome.com ([192.185.145.115]:48986 "EHLO
        gateway32.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751547AbeAWSOY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 Jan 2018 13:14:24 -0500
Received: from cm15.websitewelcome.com (cm15.websitewelcome.com [100.42.49.9])
        by gateway32.websitewelcome.com (Postfix) with ESMTP id 0A15230A89
        for <linux-media@vger.kernel.org>; Tue, 23 Jan 2018 11:49:34 -0600 (CST)
Date: Tue, 23 Jan 2018 11:49:29 -0600
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] ov13858: Use false for boolean value
Message-ID: <20180123174928.GA8529@embeddedgus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Assign true or false to boolean variables instead of an integer value.

This issue was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/media/i2c/ov13858.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov13858.c b/drivers/media/i2c/ov13858.c
index bf7d06f..e547133 100644
--- a/drivers/media/i2c/ov13858.c
+++ b/drivers/media/i2c/ov13858.c
@@ -1565,7 +1565,7 @@ static int __maybe_unused ov13858_resume(struct device *dev)
 
 error:
 	ov13858_stop_streaming(ov13858);
-	ov13858->streaming = 0;
+	ov13858->streaming = false;
 	return ret;
 }
 
-- 
2.7.4
