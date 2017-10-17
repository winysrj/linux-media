Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:52353 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761614AbdJQM1k (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Oct 2017 08:27:40 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, prabhakar.csengg@gmail.com,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH 1/2] [media] davinci: make function arguments const
Date: Tue, 17 Oct 2017 14:27:24 +0200
Message-Id: <1508243245-30849-2-git-send-email-bhumirks@gmail.com>
In-Reply-To: <1508243245-30849-1-git-send-email-bhumirks@gmail.com>
References: <1508243245-30849-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make the function arguments of functions vpfe_{register/unregister}_ccdc_device
const as the pointer dev does not modify the fields of the structure 
it points to. Also, declare the variable ccdc_dev const as it points to the 
same structure as dev but it does not modify the fields as well.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/media/platform/davinci/ccdc_hw_device.h | 4 ++--
 drivers/media/platform/davinci/vpfe_capture.c   | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/davinci/ccdc_hw_device.h b/drivers/media/platform/davinci/ccdc_hw_device.h
index f1b5210..3482178 100644
--- a/drivers/media/platform/davinci/ccdc_hw_device.h
+++ b/drivers/media/platform/davinci/ccdc_hw_device.h
@@ -82,8 +82,8 @@ struct ccdc_hw_device {
 };
 
 /* Used by CCDC module to register & unregister with vpfe capture driver */
-int vpfe_register_ccdc_device(struct ccdc_hw_device *dev);
-void vpfe_unregister_ccdc_device(struct ccdc_hw_device *dev);
+int vpfe_register_ccdc_device(const struct ccdc_hw_device *dev);
+void vpfe_unregister_ccdc_device(const struct ccdc_hw_device *dev);
 
 #endif
 #endif
diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
index 6792da1..7b3f6f8 100644
--- a/drivers/media/platform/davinci/vpfe_capture.c
+++ b/drivers/media/platform/davinci/vpfe_capture.c
@@ -115,7 +115,7 @@ struct ccdc_config {
 };
 
 /* ccdc device registered */
-static struct ccdc_hw_device *ccdc_dev;
+static const struct ccdc_hw_device *ccdc_dev;
 /* lock for accessing ccdc information */
 static DEFINE_MUTEX(ccdc_lock);
 /* ccdc configuration */
@@ -203,7 +203,7 @@ static const struct vpfe_pixel_format *vpfe_lookup_pix_format(u32 pix_format)
  * vpfe_register_ccdc_device. CCDC module calls this to
  * register with vpfe capture
  */
-int vpfe_register_ccdc_device(struct ccdc_hw_device *dev)
+int vpfe_register_ccdc_device(const struct ccdc_hw_device *dev)
 {
 	int ret = 0;
 	printk(KERN_NOTICE "vpfe_register_ccdc_device: %s\n", dev->name);
@@ -259,7 +259,7 @@ int vpfe_register_ccdc_device(struct ccdc_hw_device *dev)
  * vpfe_unregister_ccdc_device. CCDC module calls this to
  * unregister with vpfe capture
  */
-void vpfe_unregister_ccdc_device(struct ccdc_hw_device *dev)
+void vpfe_unregister_ccdc_device(const struct ccdc_hw_device *dev)
 {
 	if (!dev) {
 		printk(KERN_ERR "invalid ccdc device ptr\n");
-- 
1.9.1
