Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:34914 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750776AbdCJFNY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Mar 2017 00:13:24 -0500
Received: by mail-pg0-f67.google.com with SMTP id g2so4557912pge.2
        for <linux-media@vger.kernel.org>; Thu, 09 Mar 2017 21:13:23 -0800 (PST)
From: simran singhal <singhalsimran0@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, jarod@wilsonet.com, mchehab@kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH 2/3] staging: vpfe_mc_capture: Clean up tests if NULL returned on failure
Date: Fri, 10 Mar 2017 10:43:11 +0530
Message-Id: <1489122792-8081-3-git-send-email-singhalsimran0@gmail.com>
In-Reply-To: <1489122792-8081-1-git-send-email-singhalsimran0@gmail.com>
References: <1489122792-8081-1-git-send-email-singhalsimran0@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some functions like kmalloc/kzalloc return NULL on failure.
When NULL represents failure, !x is commonly used.

This was done using Coccinelle:
@@
expression *e;
identifier l1;
@@

e = \(kmalloc\|kzalloc\|kcalloc\|devm_kzalloc\)(...);
...
- e == NULL
+ !e

Signed-off-by: simran singhal <singhalsimran0@gmail.com>
---
 drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c b/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
index 32109cd..bffe215 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
@@ -228,7 +228,7 @@ static int vpfe_enable_clock(struct vpfe_device *vpfe_dev)
 
 	vpfe_dev->clks = kcalloc(vpfe_cfg->num_clocks,
 				 sizeof(*vpfe_dev->clks), GFP_KERNEL);
-	if (vpfe_dev->clks == NULL)
+	if (!vpfe_dev->clks)
 		return -ENOMEM;
 
 	for (i = 0; i < vpfe_cfg->num_clocks; i++) {
@@ -348,7 +348,7 @@ static int register_i2c_devices(struct vpfe_device *vpfe_dev)
 	vpfe_dev->sd =
 		  kcalloc(num_subdevs, sizeof(struct v4l2_subdev *),
 			  GFP_KERNEL);
-	if (vpfe_dev->sd == NULL)
+	if (!vpfe_dev->sd)
 		return -ENOMEM;
 
 	for (i = 0, k = 0; i < num_subdevs; i++) {
-- 
2.7.4
