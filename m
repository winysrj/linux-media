Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway33.websitewelcome.com ([192.185.145.9]:40884 "EHLO
        gateway33.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751578AbdFOQtT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Jun 2017 12:49:19 -0400
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway33.websitewelcome.com (Postfix) with ESMTP id 267BB6973A
        for <linux-media@vger.kernel.org>; Thu, 15 Jun 2017 11:49:16 -0500 (CDT)
Date: Thu, 15 Jun 2017 11:49:14 -0500
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Mats Randgaard <matrandg@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] i2c: tc358743: remove useless variable assignment in
 tc358743_isr
Message-ID: <20170615164914.GA23292@embeddedgus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove useless variable assignment in function tc358743_isr().

The value stored in variable _intstatus_ at line 1299 is
overwritten at line 1302, just before it can be used.

Addresses-Coverity-ID: 1397678
Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/media/i2c/tc358743.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index 3251cba..e8b23f3 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -1296,7 +1296,6 @@ static int tc358743_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 			tc358743_csi_err_int_handler(sd, handled);
 
 		i2c_wr16(sd, INTSTATUS, MASK_CSI_INT);
-		intstatus &= ~MASK_CSI_INT;
 	}
 
 	intstatus = i2c_rd16(sd, INTSTATUS);
-- 
2.5.0
