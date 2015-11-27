Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:37101 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755271AbbK0WDG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Nov 2015 17:03:06 -0500
Received: by wmww144 with SMTP id w144so71907287wmw.0
        for <linux-media@vger.kernel.org>; Fri, 27 Nov 2015 14:03:05 -0800 (PST)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH] media: rc: raw: improve FIFO handling
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org,
	=?UTF-8?Q?David_H=c3=a4rdeman?= <david@hardeman.nu>
Message-ID: <5658D2FE.2000603@gmail.com>
Date: Fri, 27 Nov 2015 23:02:38 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The FIFO is used for ir_raw_event records, however for some historic
reason the FIFO is used on a per byte basis. IMHO this adds unneeded
complexity. Therefore set up the FIFO for ir_raw_event records.

This also allows to define the FIFO statically as part of
ir_raw_event_ctrl instead of having to allocate the FIFO dynamically.
In addition:

- When writing into the FIFO and it's full return ENOSPC instead of
  ENOMEM thus making it easier to tell between "FIFO full" and
  "Dynamic memory allocation failed" when the error is propagated to
  a higher level.
  Also add an error message.

- When reading from the FIFO check whether it's empty.
  This is not strictly needed here but kfifo_out is annotated
  "must check" anyway.

Successfully tested it with the nuvoton-cir driver.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/rc-core-priv.h |  6 +++++-
 drivers/media/rc/rc-ir-raw.c    | 23 ++++++++---------------
 2 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index 7359f3d..585d5e5 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -16,6 +16,9 @@
 #ifndef _RC_CORE_PRIV
 #define _RC_CORE_PRIV
 
+/* Define the max number of pulse/space transitions to buffer */
+#define	MAX_IR_EVENT_SIZE	512
+
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <media/rc-core.h>
@@ -35,7 +38,8 @@ struct ir_raw_event_ctrl {
 	struct list_head		list;		/* to keep track of raw clients */
 	struct task_struct		*thread;
 	spinlock_t			lock;
-	struct kfifo_rec_ptr_1		kfifo;		/* fifo for the pulse/space durations */
+	/* fifo for the pulse/space durations */
+	DECLARE_KFIFO(kfifo, struct ir_raw_event, MAX_IR_EVENT_SIZE);
 	ktime_t				last_event;	/* when last event occurred */
 	enum raw_event_type		last_type;	/* last event type */
 	struct rc_dev			*dev;		/* pointer to the parent rc_dev */
diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index c69807f..144304c 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -20,9 +20,6 @@
 #include <linux/freezer.h>
 #include "rc-core-priv.h"
 
-/* Define the max number of pulse/space transitions to buffer */
-#define MAX_IR_EVENT_SIZE      512
-
 /* Used to keep track of IR raw clients, protected by ir_raw_handler_lock */
 static LIST_HEAD(ir_raw_client_list);
 
@@ -36,14 +33,12 @@ static int ir_raw_event_thread(void *data)
 	struct ir_raw_event ev;
 	struct ir_raw_handler *handler;
 	struct ir_raw_event_ctrl *raw = (struct ir_raw_event_ctrl *)data;
-	int retval;
 
 	while (!kthread_should_stop()) {
 
 		spin_lock_irq(&raw->lock);
-		retval = kfifo_len(&raw->kfifo);
 
-		if (retval < sizeof(ev)) {
+		if (!kfifo_len(&raw->kfifo)) {
 			set_current_state(TASK_INTERRUPTIBLE);
 
 			if (kthread_should_stop())
@@ -54,7 +49,8 @@ static int ir_raw_event_thread(void *data)
 			continue;
 		}
 
-		retval = kfifo_out(&raw->kfifo, &ev, sizeof(ev));
+		if(!kfifo_out(&raw->kfifo, &ev, 1))
+			dev_err(&raw->dev->dev, "IR event FIFO is empty!\n");
 		spin_unlock_irq(&raw->lock);
 
 		mutex_lock(&ir_raw_handler_lock);
@@ -87,8 +83,10 @@ int ir_raw_event_store(struct rc_dev *dev, struct ir_raw_event *ev)
 	IR_dprintk(2, "sample: (%05dus %s)\n",
 		   TO_US(ev->duration), TO_STR(ev->pulse));
 
-	if (kfifo_in(&dev->raw->kfifo, ev, sizeof(*ev)) != sizeof(*ev))
-		return -ENOMEM;
+	if (!kfifo_put(&dev->raw->kfifo, *ev)) {
+		dev_err(&dev->dev, "IR event FIFO is full!\n");
+		return -ENOSPC;
+	}
 
 	return 0;
 }
@@ -273,11 +271,7 @@ int ir_raw_event_register(struct rc_dev *dev)
 
 	dev->raw->dev = dev;
 	dev->change_protocol = change_protocol;
-	rc = kfifo_alloc(&dev->raw->kfifo,
-			 sizeof(struct ir_raw_event) * MAX_IR_EVENT_SIZE,
-			 GFP_KERNEL);
-	if (rc < 0)
-		goto out;
+	INIT_KFIFO(dev->raw->kfifo);
 
 	spin_lock_init(&dev->raw->lock);
 	dev->raw->thread = kthread_run(ir_raw_event_thread, dev->raw,
@@ -319,7 +313,6 @@ void ir_raw_event_unregister(struct rc_dev *dev)
 			handler->raw_unregister(dev);
 	mutex_unlock(&ir_raw_handler_lock);
 
-	kfifo_free(&dev->raw->kfifo);
 	kfree(dev->raw);
 	dev->raw = NULL;
 }
-- 
2.6.2

