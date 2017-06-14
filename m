Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:9954 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751869AbdFNNsD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Jun 2017 09:48:03 -0400
Date: Wed, 14 Jun 2017 21:47:15 +0800
From: kbuild test robot <lkp@intel.com>
To: chiranjeevi.rapolu@intel.com
Cc: kbuild-all@01.org, linux-media@vger.kernel.org,
        sakari.ailus@linux.intel.com, tfiga@chromium.org,
        jian.xu.zheng@intel.com, rajmohan.mani@intel.com,
        hyungwoo.yang@intel.com,
        Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
Subject: [PATCH] i2c: fix platform_no_drv_owner.cocci warnings
Message-ID: <20170614134715.GA23007@xian.lkp.intel.com>
References: <201706142129.jedNMTfn%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1497404348-16255-1-git-send-email-chiranjeevi.rapolu@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/i2c/ov5670.c:2577:3-8: No need to set .owner here. The core will do it.

 Remove .owner field if calls are used which set it automatically

Generated by: scripts/coccinelle/api/platform_no_drv_owner.cocci

CC: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---

 ov5670.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/media/i2c/ov5670.c
+++ b/drivers/media/i2c/ov5670.c
@@ -2574,7 +2574,6 @@ MODULE_DEVICE_TABLE(acpi, ov5670_acpi_id
 static struct i2c_driver ov5670_i2c_driver = {
 	.driver = {
 		.name = "ov5670",
-		.owner = THIS_MODULE,
 		.pm = &ov5670_pm_ops,
 		.acpi_match_table = ACPI_PTR(ov5670_acpi_ids),
 	},
