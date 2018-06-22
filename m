Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:56498 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933214AbeFVLUC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Jun 2018 07:20:02 -0400
Date: Fri, 22 Jun 2018 14:19:48 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] media: sr030pc30: inconsistent NULL checking in
 sr030pc30_base_config()
Message-ID: <20180622111947.tormf7s7an5vj4lg@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If info->pdata is NULL then we would oops on the next line.  And we can
flip the "ret" test around and give up if a failure has already occured.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/i2c/sr030pc30.c b/drivers/media/i2c/sr030pc30.c
index 2a4882cddc51..4ebd00198d34 100644
--- a/drivers/media/i2c/sr030pc30.c
+++ b/drivers/media/i2c/sr030pc30.c
@@ -569,8 +569,8 @@ static int sr030pc30_base_config(struct v4l2_subdev *sd)
 	if (!ret)
 		ret = sr030pc30_pwr_ctrl(sd, false, false);
 
-	if (!ret && !info->pdata)
-		return ret;
+	if (ret || !info->pdata)
+		return -EIO;
 
 	expmin = EXPOS_MIN_MS * info->pdata->clk_rate / (8 * 1000);
 	expmax = EXPOS_MAX_MS * info->pdata->clk_rate / (8 * 1000);
