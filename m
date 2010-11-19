Return-path: <mchehab@gaivota>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:33751 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757201Ab0KSXon (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Nov 2010 18:44:43 -0500
Subject: [PATCH 05/10] saa7134: protect the ir user count
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: jarod@wilsonet.com, mchehab@infradead.org
Date: Sat, 20 Nov 2010 00:43:02 +0100
Message-ID: <20101119234302.3511.97440.stgit@localhost.localdomain>
In-Reply-To: <20101119233959.3511.91287.stgit@localhost.localdomain>
References: <20101119233959.3511.91287.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

The use of the saa7134_card_ir->users seems racy, so protect the count with
a spinlock. Also use proper data types as arguments to __saa7134_ir_start()
and __saa7134_ir_stop() to remove some unnecessary casts.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/video/saa7134/saa7134-input.c |   54 ++++++++++++++++-----------
 drivers/media/video/saa7134/saa7134.h       |    1 +
 2 files changed, 33 insertions(+), 22 deletions(-)

diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index 98678d9..8b80efb 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -402,17 +402,12 @@ static void ir_raw_decode_timer_end(unsigned long data)
 	ir->active = false;
 }
 
-static int __saa7134_ir_start(void *priv)
+static void __saa7134_ir_start(struct saa7134_dev *dev)
 {
-	struct saa7134_dev *dev = priv;
-	struct saa7134_card_ir *ir;
-
-	if (!dev || !dev->remote)
-		return -EINVAL;
+	struct saa7134_card_ir *ir = dev->remote;
 
-	ir  = dev->remote;
 	if (ir->running)
-		return 0;
+		return;
 
 	ir->running = true;
 	ir->active = false;
@@ -427,19 +422,12 @@ static int __saa7134_ir_start(void *priv)
 		setup_timer(&ir->timer, ir_raw_decode_timer_end,
 			    (unsigned long)dev);
 	}
-
-	return 0;
 }
 
-static void __saa7134_ir_stop(void *priv)
+static void __saa7134_ir_stop(struct saa7134_dev *dev)
 {
-	struct saa7134_dev *dev = priv;
-	struct saa7134_card_ir *ir;
-
-	if (!dev || !dev->remote)
-		return;
+	struct saa7134_card_ir *ir = dev->remote;
 
-	ir  = dev->remote;
 	if (!ir->running)
 		return;
 
@@ -448,39 +436,60 @@ static void __saa7134_ir_stop(void *priv)
 
 	ir->active = false;
 	ir->running = false;
-
-	return;
 }
 
 int saa7134_ir_start(struct saa7134_dev *dev)
 {
+	if (!dev || !dev->remote)
+		return -EINVAL;
+
+	spin_lock(&dev->remote->lock);
 	if (dev->remote->users)
-		return __saa7134_ir_start(dev);
+		__saa7134_ir_start(dev);
+	spin_unlock(&dev->remote->lock);
 
 	return 0;
 }
 
 void saa7134_ir_stop(struct saa7134_dev *dev)
 {
+	if (!dev || !dev->remote)
+		return;
+
+	spin_lock(&dev->remote->lock);
 	if (dev->remote->users)
 		__saa7134_ir_stop(dev);
+	spin_unlock(&dev->remote->lock);
 }
 
 static int saa7134_ir_open(struct rc_dev *rc)
 {
 	struct saa7134_dev *dev = rc->priv;
 
+	if (!dev || !dev->remote)
+		return -EINVAL;
+
+	spin_lock(&dev->remote->lock);
+	if (dev->remote->users == 0)
+		__saa7134_ir_start(dev);
 	dev->remote->users++;
-	return __saa7134_ir_start(dev);
+	spin_unlock(&dev->remote->lock);
+
+	return 0;
 }
 
 static void saa7134_ir_close(struct rc_dev *rc)
 {
 	struct saa7134_dev *dev = rc->priv;
 
+	if (!dev || !dev->remote)
+		return;
+
+	spin_lock(&dev->remote->lock);
 	dev->remote->users--;
-	if (!dev->remote->users)
+	if (dev->remote->users == 0)
 		__saa7134_ir_stop(dev);
+	spin_unlock(&dev->remote->lock);
 }
 
 int saa7134_input_init1(struct saa7134_dev *dev)
@@ -744,6 +753,7 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 	ir->mask_keyup   = mask_keyup;
 	ir->polling      = polling;
 	ir->raw_decode	 = raw_decode;
+	spin_lock_init(&ir->lock);
 
 	/* init input device */
 	snprintf(ir->name, sizeof(ir->name), "saa7134 IR (%s)",
diff --git a/drivers/media/video/saa7134/saa7134.h b/drivers/media/video/saa7134/saa7134.h
index babfbe7..7c836c3 100644
--- a/drivers/media/video/saa7134/saa7134.h
+++ b/drivers/media/video/saa7134/saa7134.h
@@ -125,6 +125,7 @@ struct saa7134_card_ir {
 	char                    name[32];
 	char                    phys[32];
 	unsigned                users;
+	spinlock_t              lock;
 
 	u32			polling;
         u32			last_gpio;

