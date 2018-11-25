Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:36265 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726562AbeKZEv0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Nov 2018 23:51:26 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH] media: saa7134: rc-core maintains users count, no need to duplicate
Date: Sun, 25 Nov 2018 17:59:48 +0000
Message-Id: <20181125175948.19176-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This simplifies the code a little. Tested with suspend and resume.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/pci/saa7134/saa7134-core.c  |  8 +--
 drivers/media/pci/saa7134/saa7134-input.c | 68 ++++-------------------
 drivers/media/pci/saa7134/saa7134.h       |  9 ++-
 3 files changed, 18 insertions(+), 67 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-core.c b/drivers/media/pci/saa7134/saa7134-core.c
index 8984b1bf57a5..aa98ea49558c 100644
--- a/drivers/media/pci/saa7134/saa7134-core.c
+++ b/drivers/media/pci/saa7134/saa7134-core.c
@@ -1419,8 +1419,8 @@ static int saa7134_suspend(struct pci_dev *pci_dev , pm_message_t state)
 	del_timer(&dev->vbi_q.timeout);
 	del_timer(&dev->ts_q.timeout);
 
-	if (dev->remote)
-		saa7134_ir_stop(dev);
+	if (dev->remote && dev->remote->dev->users)
+		saa7134_ir_close(dev->remote->dev);
 
 	pci_save_state(pci_dev);
 	pci_set_power_state(pci_dev, pci_choose_state(pci_dev, state));
@@ -1447,8 +1447,8 @@ static int saa7134_resume(struct pci_dev *pci_dev)
 		saa7134_videoport_init(dev);
 	if (card_has_mpeg(dev))
 		saa7134_ts_init_hw(dev);
-	if (dev->remote)
-		saa7134_ir_start(dev);
+	if (dev->remote && dev->remote->dev->users)
+		saa7134_ir_open(dev->remote->dev);
 	saa7134_hw_enable1(dev);
 
 	msleep(100);
diff --git a/drivers/media/pci/saa7134/saa7134-input.c b/drivers/media/pci/saa7134/saa7134-input.c
index bc1ed7798d21..35884d5b8337 100644
--- a/drivers/media/pci/saa7134/saa7134-input.c
+++ b/drivers/media/pci/saa7134/saa7134-input.c
@@ -448,17 +448,10 @@ static void saa7134_input_timer(struct timer_list *t)
 	mod_timer(&ir->timer, jiffies + msecs_to_jiffies(ir->polling));
 }
 
-static int __saa7134_ir_start(void *priv)
+int saa7134_ir_open(struct rc_dev *rc)
 {
-	struct saa7134_dev *dev = priv;
-	struct saa7134_card_ir *ir;
-
-	if (!dev || !dev->remote)
-		return -EINVAL;
-
-	ir  = dev->remote;
-	if (ir->running)
-		return 0;
+	struct saa7134_dev *dev = rc->priv;
+	struct saa7134_card_ir *ir = dev->remote;
 
 	/* Moved here from saa7134_input_init1() because the latter
 	 * is not called on device resume */
@@ -507,55 +500,15 @@ static int __saa7134_ir_start(void *priv)
 	return 0;
 }
 
-static void __saa7134_ir_stop(void *priv)
+void saa7134_ir_close(struct rc_dev *rc)
 {
-	struct saa7134_dev *dev = priv;
-	struct saa7134_card_ir *ir;
-
-	if (!dev || !dev->remote)
-		return;
-
-	ir  = dev->remote;
-	if (!ir->running)
-		return;
+	struct saa7134_dev *dev = rc->priv;
+	struct saa7134_card_ir *ir = dev->remote;
 
 	if (ir->polling)
 		del_timer_sync(&ir->timer);
 
 	ir->running = false;
-
-	return;
-}
-
-int saa7134_ir_start(struct saa7134_dev *dev)
-{
-	if (dev->remote->users)
-		return __saa7134_ir_start(dev);
-
-	return 0;
-}
-
-void saa7134_ir_stop(struct saa7134_dev *dev)
-{
-	if (dev->remote->users)
-		__saa7134_ir_stop(dev);
-}
-
-static int saa7134_ir_open(struct rc_dev *rc)
-{
-	struct saa7134_dev *dev = rc->priv;
-
-	dev->remote->users++;
-	return __saa7134_ir_start(dev);
-}
-
-static void saa7134_ir_close(struct rc_dev *rc)
-{
-	struct saa7134_dev *dev = rc->priv;
-
-	dev->remote->users--;
-	if (!dev->remote->users)
-		__saa7134_ir_stop(dev);
 }
 
 int saa7134_input_init1(struct saa7134_dev *dev)
@@ -624,7 +577,7 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 		mask_keycode = 0x0007C8;
 		mask_keydown = 0x000010;
 		polling      = 50; // ms
-		/* GPIO stuff moved to __saa7134_ir_start() */
+		/* GPIO stuff moved to saa7134_ir_open() */
 		break;
 	case SAA7134_BOARD_AVERMEDIA_M135A:
 		ir_codes     = RC_MAP_AVERMEDIA_M135A;
@@ -646,14 +599,14 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 		mask_keycode = 0x02F200;
 		mask_keydown = 0x000400;
 		polling      = 50; // ms
-		/* GPIO stuff moved to __saa7134_ir_start() */
+		/* GPIO stuff moved to saa7134_ir_open() */
 		break;
 	case SAA7134_BOARD_AVERMEDIA_A16D:
 		ir_codes     = RC_MAP_AVERMEDIA_A16D;
 		mask_keycode = 0x02F200;
 		mask_keydown = 0x000400;
 		polling      = 50; /* ms */
-		/* GPIO stuff moved to __saa7134_ir_start() */
+		/* GPIO stuff moved to saa7134_ir_open() */
 		break;
 	case SAA7134_BOARD_KWORLD_TERMINATOR:
 		ir_codes     = RC_MAP_PIXELVIEW;
@@ -705,7 +658,7 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 		mask_keycode = 0x0003CC;
 		mask_keydown = 0x000010;
 		polling	     = 5; /* ms */
-		/* GPIO stuff moved to __saa7134_ir_start() */
+		/* GPIO stuff moved to saa7134_ir_open() */
 		break;
 	case SAA7134_BOARD_VIDEOMATE_TV_PVR:
 	case SAA7134_BOARD_VIDEOMATE_GOLD_PLUS:
@@ -890,7 +843,6 @@ void saa7134_input_fini(struct saa7134_dev *dev)
 	if (NULL == dev->remote)
 		return;
 
-	saa7134_ir_stop(dev);
 	rc_unregister_device(dev->remote->dev);
 	kfree(dev->remote);
 	dev->remote = NULL;
diff --git a/drivers/media/pci/saa7134/saa7134.h b/drivers/media/pci/saa7134/saa7134.h
index 1c3f273f7dd2..50b1d07d2ac1 100644
--- a/drivers/media/pci/saa7134/saa7134.h
+++ b/drivers/media/pci/saa7134/saa7134.h
@@ -124,7 +124,6 @@ struct saa7134_card_ir {
 	struct rc_dev		*dev;
 
 	char                    phys[32];
-	unsigned                users;
 
 	u32			polling;
 	u32			last_gpio;
@@ -922,13 +921,13 @@ int  saa7134_input_init1(struct saa7134_dev *dev);
 void saa7134_input_fini(struct saa7134_dev *dev);
 void saa7134_input_irq(struct saa7134_dev *dev);
 void saa7134_probe_i2c_ir(struct saa7134_dev *dev);
-int saa7134_ir_start(struct saa7134_dev *dev);
-void saa7134_ir_stop(struct saa7134_dev *dev);
+int saa7134_ir_open(struct rc_dev *dev);
+void saa7134_ir_close(struct rc_dev *dev);
 #else
 #define saa7134_input_init1(dev)	((void)0)
 #define saa7134_input_fini(dev)		((void)0)
 #define saa7134_input_irq(dev)		((void)0)
 #define saa7134_probe_i2c_ir(dev)	((void)0)
-#define saa7134_ir_start(dev)		((void)0)
-#define saa7134_ir_stop(dev)		((void)0)
+#define saa7134_ir_open(dev)		((void)0)
+#define saa7134_ir_close(dev)		((void)0)
 #endif
-- 
2.19.1
