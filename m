Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:46720 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755129AbdCKTcL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 11 Mar 2017 14:32:11 -0500
From: Colin King <colin.king@canonical.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: atomisp: clean up return logic, remove redunant code
Date: Sat, 11 Mar 2017 19:32:05 +0000
Message-Id: <20170311193205.6410-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

There is no need to check if ret is non-zero, remove this
redundant check and just return the error status from the call
to mt9m114_write_reg_array.

Detected by CoverityScan, CID#1416577 ("Identical code for
different branches")

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/staging/media/atomisp/i2c/mt9m114.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/mt9m114.c b/drivers/staging/media/atomisp/i2c/mt9m114.c
index 8762124..a555aec 100644
--- a/drivers/staging/media/atomisp/i2c/mt9m114.c
+++ b/drivers/staging/media/atomisp/i2c/mt9m114.c
@@ -444,12 +444,8 @@ static int mt9m114_set_suspend(struct v4l2_subdev *sd)
 static int mt9m114_init_common(struct v4l2_subdev *sd)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	int ret;
 
-	ret = mt9m114_write_reg_array(client, mt9m114_common, PRE_POLLING);
-	if (ret)
-		return ret;
-	return ret;
+	return mt9m114_write_reg_array(client, mt9m114_common, PRE_POLLING);
 }
 
 static int power_ctrl(struct v4l2_subdev *sd, bool flag)
-- 
2.10.2
