Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:38786 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752099AbdCAKb7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 1 Mar 2017 05:31:59 -0500
Date: Wed, 1 Mar 2017 18:30:19 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Alan Cox <alan@linux.intel.com>
Cc: kbuild-all@01.org, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging/atomisp: fix platform_no_drv_owner.cocci warnings
Message-ID: <20170301103018.GA31172@lkp-wsm-ep1>
References: <201703011837.1R4zsbQi%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201703011837.1R4zsbQi%fengguang.wu@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/staging/media/atomisp/i2c/imx/../ov8858.c:2199:3-8: No need to set .owner here. The core will do it.

 Remove .owner field if calls are used which set it automatically

Generated by: scripts/coccinelle/api/platform_no_drv_owner.cocci

CC: Alan Cox <alan@linux.intel.com>
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---

 ov8858.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/staging/media/atomisp/i2c/imx/../ov8858.c
+++ b/drivers/staging/media/atomisp/i2c/imx/../ov8858.c
@@ -2196,7 +2196,6 @@ static struct acpi_device_id ov8858_acpi
 
 static struct i2c_driver ov8858_driver = {
 	.driver = {
-		.owner = THIS_MODULE,
 		.name = OV8858_NAME,
 		.acpi_match_table = ACPI_PTR(ov8858_acpi_match),
 	},
