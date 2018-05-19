Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:30671 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752523AbeESQxz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 19 May 2018 12:53:55 -0400
Date: Sun, 20 May 2018 00:53:39 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: bingbu.cao@intel.com
Cc: kbuild-all@01.org, linux-media@vger.kernel.org,
        sakari.ailus@linux.intel.com, bingbu.cao@linux.intel.com,
        tian.shu.qiu@linux.intel.com, rajmohan.mani@intel.com,
        mchehab@kernel.org
Subject: [RFC PATCH] media: imx319: imx319_global_setting can be static
Message-ID: <20180519165338.GA40297@cairo>
References: <1526529744-25446-1-git-send-email-bingbu.cao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1526529744-25446-1-git-send-email-bingbu.cao@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Fixes: aa51064f24f3 ("media: imx319: Add imx319 camera sensor driver")
Signed-off-by: kbuild test robot <fengguang.wu@intel.com>
---
 imx319.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/imx319.c b/drivers/media/i2c/imx319.c
index e6a918e..44a9bda 100644
--- a/drivers/media/i2c/imx319.c
+++ b/drivers/media/i2c/imx319.c
@@ -216,7 +216,7 @@ static const struct imx319_reg imx319_global_regs[] = {
 	{ 0xf2d9, 0x02 },
 };
 
-struct imx319_reg_list imx319_global_setting = {
+static struct imx319_reg_list imx319_global_setting = {
 	.num_of_regs = ARRAY_SIZE(imx319_global_regs),
 	.regs = imx319_global_regs,
 };
