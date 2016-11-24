Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59544 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935768AbcKXLBc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Nov 2016 06:01:32 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Andy Walls <awalls@md.metrocast.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 2/3] [media] ivtv: use pr_foo() instead of calling printk() directly
Date: Thu, 24 Nov 2016 09:01:21 -0200
Message-Id: <fa28df93853373bf9cf0d33be8bb134950fabcda.1479985277.git.mchehab@s-opensource.com>
In-Reply-To: <8e39e8122c8a4d3b5fb0a71ec51e0896a6953b66.1479985277.git.mchehab@s-opensource.com>
References: <8e39e8122c8a4d3b5fb0a71ec51e0896a6953b66.1479985277.git.mchehab@s-opensource.com>
In-Reply-To: <8e39e8122c8a4d3b5fb0a71ec51e0896a6953b66.1479985277.git.mchehab@s-opensource.com>
References: <8e39e8122c8a4d3b5fb0a71ec51e0896a6953b66.1479985277.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

pr_foo() provides a convenient way for printk's, enforcing
that they'll all prepend the error message with the driver's
name.

Use it inside ivtv.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/pci/ivtv/ivtv-alsa-main.c | 11 +++++------
 drivers/media/pci/ivtv/ivtv-driver.c    | 12 ++++++------
 drivers/media/pci/ivtv/ivtvfb.c         |  6 +++---
 3 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/media/pci/ivtv/ivtv-alsa-main.c b/drivers/media/pci/ivtv/ivtv-alsa-main.c
index 67ab73ef2bca..c66a8e991eb2 100644
--- a/drivers/media/pci/ivtv/ivtv-alsa-main.c
+++ b/drivers/media/pci/ivtv/ivtv-alsa-main.c
@@ -34,10 +34,11 @@
 int ivtv_alsa_debug;
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;
 
-#define IVTV_DEBUG_ALSA_INFO(fmt, arg...) \
+#define IVTV_DEBUG_ALSA_INFO(__fmt, __arg...) \
 	do { \
 		if (ivtv_alsa_debug & 2) \
-			pr_info("%s: " fmt, "ivtv-alsa", ## arg); \
+			printk(KERN_DEBUG pr_fmt("%s: alsa:" __fmt),	\
+			       __func__, ##__arg);			\
 	} while (0)
 
 module_param_named(debug, ivtv_alsa_debug, int, 0644);
@@ -226,8 +227,7 @@ static int ivtv_alsa_load(struct ivtv *itv)
 
 	s = &itv->streams[IVTV_ENC_STREAM_TYPE_PCM];
 	if (s->vdev.v4l2_dev == NULL) {
-		IVTV_DEBUG_ALSA_INFO("%s: PCM stream for card is disabled - skipping\n",
-				     __func__);
+		IVTV_DEBUG_ALSA_INFO("PCM stream for card is disabled - skipping\n");
 		return 0;
 	}
 
@@ -241,8 +241,7 @@ static int ivtv_alsa_load(struct ivtv *itv)
 		IVTV_ALSA_ERR("%s: failed to create struct snd_ivtv_card\n",
 			      __func__);
 	} else {
-		IVTV_DEBUG_ALSA_INFO("%s: created ivtv ALSA interface instance \n",
-				     __func__);
+		IVTV_DEBUG_ALSA_INFO("created ivtv ALSA interface instance\n");
 	}
 	return 0;
 }
diff --git a/drivers/media/pci/ivtv/ivtv-driver.c b/drivers/media/pci/ivtv/ivtv-driver.c
index 0a3b80a4bd69..ab2ae53618e8 100644
--- a/drivers/media/pci/ivtv/ivtv-driver.c
+++ b/drivers/media/pci/ivtv/ivtv-driver.c
@@ -1452,7 +1452,7 @@ static void ivtv_remove(struct pci_dev *pdev)
 	for (i = 0; i < IVTV_VBI_FRAMES; i++)
 		kfree(itv->vbi.sliced_mpeg_data[i]);
 
-	printk(KERN_INFO "ivtv: Removed %s\n", itv->card_name);
+	pr_info("Removed %s\n", itv->card_name);
 
 	v4l2_device_unregister(&itv->v4l2_dev);
 	kfree(itv);
@@ -1468,25 +1468,25 @@ static struct pci_driver ivtv_pci_driver = {
 
 static int __init module_start(void)
 {
-	printk(KERN_INFO "ivtv: Start initialization, version %s\n", IVTV_VERSION);
+	pr_info("Start initialization, version %s\n", IVTV_VERSION);
 
 	/* Validate parameters */
 	if (ivtv_first_minor < 0 || ivtv_first_minor >= IVTV_MAX_CARDS) {
-		printk(KERN_ERR "ivtv: Exiting, ivtv_first_minor must be between 0 and %d\n",
+		pr_err("Exiting, ivtv_first_minor must be between 0 and %d\n",
 		     IVTV_MAX_CARDS - 1);
 		return -1;
 	}
 
 	if (ivtv_debug < 0 || ivtv_debug > 2047) {
 		ivtv_debug = 0;
-		printk(KERN_INFO "ivtv: Debug value must be >= 0 and <= 2047\n");
+		pr_info("Debug value must be >= 0 and <= 2047\n");
 	}
 
 	if (pci_register_driver(&ivtv_pci_driver)) {
-		printk(KERN_ERR "ivtv: Error detecting PCI card\n");
+		pr_err("Error detecting PCI card\n");
 		return -ENODEV;
 	}
-	printk(KERN_INFO "ivtv: End initialization\n");
+	pr_info("End initialization\n");
 	return 0;
 }
 
diff --git a/drivers/media/pci/ivtv/ivtvfb.c b/drivers/media/pci/ivtv/ivtvfb.c
index b59b60d605eb..d8a152e45ce2 100644
--- a/drivers/media/pci/ivtv/ivtvfb.c
+++ b/drivers/media/pci/ivtv/ivtvfb.c
@@ -1270,7 +1270,7 @@ static int __init ivtvfb_init(void)
 
 
 	if (ivtvfb_card_id < -1 || ivtvfb_card_id >= IVTV_MAX_CARDS) {
-		printk(KERN_ERR "ivtvfb:  ivtvfb_card_id parameter is out of range (valid range: -1 - %d)\n",
+		pr_err(" ivtvfb_card_id parameter is out of range (valid range: -1 - %d)\n",
 		     IVTV_MAX_CARDS - 1);
 		return -EINVAL;
 	}
@@ -1279,7 +1279,7 @@ static int __init ivtvfb_init(void)
 	err = driver_for_each_device(drv, NULL, &registered, ivtvfb_callback_init);
 	(void)err;	/* suppress compiler warning */
 	if (!registered) {
-		printk(KERN_ERR "ivtvfb:  no cards found\n");
+		pr_err(" no cards found\n");
 		return -ENODEV;
 	}
 	return 0;
@@ -1290,7 +1290,7 @@ static void ivtvfb_cleanup(void)
 	struct device_driver *drv;
 	int err;
 
-	printk(KERN_INFO "ivtvfb:  Unloading framebuffer module\n");
+	pr_info(" Unloading framebuffer module\n");
 
 	drv = driver_find("ivtv", &pci_bus_type);
 	err = driver_for_each_device(drv, NULL, NULL, ivtvfb_callback_cleanup);
-- 
2.9.3

