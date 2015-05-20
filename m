Return-path: <linux-media-owner@vger.kernel.org>
Received: from 82-70-136-246.dsl.in-addr.zen.co.uk ([82.70.136.246]:56223 "EHLO
	xk120.dyn.ducie.codethink.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751569AbbEUJCl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2015 05:02:41 -0400
From: William Towle <william.towle@codethink.co.uk>
To: linux-kernel@lists.codethink.co.uk, linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, sergei.shtylyov@cogentembedded.com,
	hverkuil@xs4all.nl, rob.taylor@codethink.co.uk
Subject: [PATCH 02/20] media: adv7180: add of match table
Date: Wed, 20 May 2015 17:39:22 +0100
Message-Id: <1432139980-12619-3-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1432139980-12619-1-git-send-email-william.towle@codethink.co.uk>
References: <1432139980-12619-1-git-send-email-william.towle@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Ben Dooks <ben.dooks@codethink.co.uk>

Add a proper of match id for use when the device is being bound via
device tree, to avoid having to use the i2c old-style binding of the
device.

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
Signed-off-by: William.Towle <william.towle@codethink.co.uk>
Reviewed-by: Rob Taylor <rob.taylor@codethink.co.uk>
---
 drivers/media/i2c/adv7180.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index a493c0b..09a96df 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -25,6 +25,7 @@
 #include <linux/interrupt.h>
 #include <linux/i2c.h>
 #include <linux/slab.h>
+#include <linux/of.h>
 #include <media/v4l2-ioctl.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
@@ -1324,11 +1325,21 @@ static SIMPLE_DEV_PM_OPS(adv7180_pm_ops, adv7180_suspend, adv7180_resume);
 #define ADV7180_PM_OPS NULL
 #endif
 
+#ifdef CONFIG_OF
+static const struct of_device_id adv7180_of_id[] = {
+	{ .compatible = "adi,adv7180", },
+	{ },
+};
+
+MODULE_DEVICE_TABLE(of, adv7180_of_id);
+#endif
+
 static struct i2c_driver adv7180_driver = {
 	.driver = {
 		   .owner = THIS_MODULE,
 		   .name = KBUILD_MODNAME,
 		   .pm = ADV7180_PM_OPS,
+		   .of_match_table = of_match_ptr(adv7180_of_id),
 		   },
 	.probe = adv7180_probe,
 	.remove = adv7180_remove,
-- 
1.7.10.4

