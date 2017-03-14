Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27378 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750891AbdCNHwT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Mar 2017 03:52:19 -0400
Date: Tue, 14 Mar 2017 10:51:50 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alan Cox <alan@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] staging/atomisp: silence uninitialized variable warnings
Message-ID: <20170314075150.GA6111@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These print an uninitialized value for "opt".  Let's just remove the
printk.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_drvfs.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_drvfs.c
index 327a5c535fab..7f7c6d5133d2 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_drvfs.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_drvfs.c
@@ -128,11 +128,9 @@ static ssize_t iunit_dbgfun_store(struct device_driver *drv, const char *buf,
 	unsigned int opt;
 	int ret;
 
-	if (kstrtouint(buf, 10, &opt)) {
-		dev_err(atomisp_dev, "%s setting %d value invalid\n",
-			__func__, opt);
-		return -EINVAL;
-	}
+	ret = kstrtouint(buf, 10, &opt);
+	if (ret)
+		return ret;
 
 	ret = atomisp_set_css_dbgfunc(iunit_debug.isp, opt);
 	if (ret)
@@ -154,11 +152,9 @@ static ssize_t iunit_dbgopt_store(struct device_driver *drv, const char *buf,
 	unsigned int opt;
 	int ret;
 
-	if (kstrtouint(buf, 10, &opt)) {
-		dev_err(atomisp_dev, "%s setting %d value invalid\n",
-			__func__, opt);
-		return -EINVAL;
-	}
+	ret = kstrtouint(buf, 10, &opt);
+	if (ret)
+		return ret;
 
 	iunit_debug.dbgopt = opt;
 	ret = iunit_dump_dbgopt(iunit_debug.isp, iunit_debug.dbgopt);
