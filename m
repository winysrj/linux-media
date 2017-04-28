Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17858 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1164414AbdD1Nvg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Apr 2017 09:51:36 -0400
Date: Fri, 28 Apr 2017 16:51:14 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alan Cox <alan@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        =?iso-8859-1?B?Suly6W15?= Lefaure <jeremy.lefaure@lse.epita.fr>,
        kbuild test robot <fengguang.wu@intel.com>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] staging/atomisp: fix && vs || typos
Message-ID: <20170428135114.w33djgm6tt7rvioi@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These sanity checks don't work because they use && instead of ||.  It's
impossible to be both negative and greater than 5.

Fixes: a49d25364dfb ("staging/atomisp: Add support for the Intel IPU v2")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/staging/media/atomisp/platform/clock/vlv2_plat_clock.c b/drivers/staging/media/atomisp/platform/clock/vlv2_plat_clock.c
index a322539d2621..4b1fa9c7bb81 100644
--- a/drivers/staging/media/atomisp/platform/clock/vlv2_plat_clock.c
+++ b/drivers/staging/media/atomisp/platform/clock/vlv2_plat_clock.c
@@ -67,7 +67,7 @@ int vlv2_plat_set_clock_freq(int clk_num, int freq_type)
 {
 	void __iomem *addr;
 
-	if (clk_num < 0 && clk_num > MAX_CLK_COUNT) {
+	if (clk_num < 0 || clk_num > MAX_CLK_COUNT) {
 		pr_err("Clock number out of range (%d)\n", clk_num);
 		return -EINVAL;
 	}
@@ -103,7 +103,7 @@ int vlv2_plat_get_clock_freq(int clk_num)
 {
 	u32 ret;
 
-	if (clk_num < 0 && clk_num > MAX_CLK_COUNT) {
+	if (clk_num < 0 || clk_num > MAX_CLK_COUNT) {
 		pr_err("Clock number out of range (%d)\n", clk_num);
 		return -EINVAL;
 	}
@@ -133,7 +133,7 @@ int vlv2_plat_configure_clock(int clk_num, u32 conf)
 {
 	void __iomem *addr;
 
-	if (clk_num < 0 && clk_num > MAX_CLK_COUNT) {
+	if (clk_num < 0 || clk_num > MAX_CLK_COUNT) {
 		pr_err("Clock number out of range (%d)\n", clk_num);
 		return -EINVAL;
 	}
@@ -169,7 +169,7 @@ int vlv2_plat_get_clock_status(int clk_num)
 {
 	int ret;
 
-	if (clk_num < 0 && clk_num > MAX_CLK_COUNT) {
+	if (clk_num < 0 || clk_num > MAX_CLK_COUNT) {
 		pr_err("Clock number out of range (%d)\n", clk_num);
 		return -EINVAL;
 	}
