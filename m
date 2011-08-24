Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.dream-property.net ([82.149.226.172]:35580 "EHLO
	mail.dream-property.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618Ab1HXReC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Aug 2011 13:34:02 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.dream-property.net (Postfix) with ESMTP id C90973153A63
	for <linux-media@vger.kernel.org>; Wed, 24 Aug 2011 19:33:59 +0200 (CEST)
Received: from mail.dream-property.net ([127.0.0.1])
	by localhost (mail.dream-property.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id Je6p7UsGTRmN for <linux-media@vger.kernel.org>;
	Wed, 24 Aug 2011 19:33:53 +0200 (CEST)
Received: from pepe.dream-property.nete (dreamboxupdate.com [82.149.226.174])
	by mail.dream-property.net (Postfix) with SMTP id 5F1AB3153A1D
	for <linux-media@vger.kernel.org>; Wed, 24 Aug 2011 19:33:52 +0200 (CEST)
From: Andreas Oberritter <obi@linuxtv.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/2] DVB: dvb_frontend: convert semaphore to mutex
Date: Wed, 24 Aug 2011 17:33:51 +0000
Message-Id: <1314207232-6031-1-git-send-email-obi@linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Andreas Oberritter <obi@linuxtv.org>
---
 drivers/media/dvb/dvb-core/dvb_frontend.c |   23 +++++++++++------------
 1 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index a716627..f433a88 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -31,7 +31,6 @@
 #include <linux/wait.h>
 #include <linux/slab.h>
 #include <linux/poll.h>
-#include <linux/semaphore.h>
 #include <linux/module.h>
 #include <linux/list.h>
 #include <linux/freezer.h>
@@ -108,7 +107,7 @@ struct dvb_frontend_private {
 	struct dvb_frontend_parameters parameters_in;
 	struct dvb_frontend_parameters parameters_out;
 	struct dvb_fe_events events;
-	struct semaphore sem;
+	struct mutex lock;
 	struct list_head list_head;
 	wait_queue_head_t wait_queue;
 	struct task_struct *thread;
@@ -190,12 +189,12 @@ static int dvb_frontend_get_event(struct dvb_frontend *fe,
 		if (flags & O_NONBLOCK)
 			return -EWOULDBLOCK;
 
-		up(&fepriv->sem);
+		mutex_unlock(&fepriv->lock);
 
 		ret = wait_event_interruptible (events->wait_queue,
 						events->eventw != events->eventr);
 
-		if (down_interruptible (&fepriv->sem))
+		if (mutex_lock_interruptible(&fepriv->lock))
 			return -ERESTARTSYS;
 
 		if (ret < 0)
@@ -556,7 +555,7 @@ static int dvb_frontend_thread(void *data)
 
 	set_freezable();
 	while (1) {
-		up(&fepriv->sem);	    /* is locked when we enter the thread... */
+		mutex_unlock(&fepriv->lock);	    /* is locked when we enter the thread... */
 restart:
 		timeout = wait_event_interruptible_timeout(fepriv->wait_queue,
 			dvb_frontend_should_wakeup(fe) || kthread_should_stop()
@@ -572,7 +571,7 @@ restart:
 		if (try_to_freeze())
 			goto restart;
 
-		if (down_interruptible(&fepriv->sem))
+		if (mutex_lock_interruptible(&fepriv->lock))
 			break;
 
 		if (fepriv->reinitialise) {
@@ -704,7 +703,7 @@ static void dvb_frontend_stop(struct dvb_frontend *fe)
 
 	kthread_stop(fepriv->thread);
 
-	sema_init(&fepriv->sem, 1);
+	mutex_init(&fepriv->lock);
 	fepriv->state = FESTATE_IDLE;
 
 	/* paranoia check in case a signal arrived */
@@ -773,7 +772,7 @@ static int dvb_frontend_start(struct dvb_frontend *fe)
 
 	if (signal_pending(current))
 		return -EINTR;
-	if (down_interruptible (&fepriv->sem))
+	if (mutex_lock_interruptible(&fepriv->lock))
 		return -EINTR;
 
 	fepriv->state = FESTATE_IDLE;
@@ -786,7 +785,7 @@ static int dvb_frontend_start(struct dvb_frontend *fe)
 	if (IS_ERR(fe_thread)) {
 		ret = PTR_ERR(fe_thread);
 		printk("dvb_frontend_start: failed to start kthread (%d)\n", ret);
-		up(&fepriv->sem);
+		mutex_unlock(&fepriv->lock);
 		return ret;
 	}
 	fepriv->thread = fe_thread;
@@ -1535,7 +1534,7 @@ static int dvb_frontend_ioctl(struct file *file,
 	     cmd == FE_DISEQC_RECV_SLAVE_REPLY))
 		return -EPERM;
 
-	if (down_interruptible (&fepriv->sem))
+	if (mutex_lock_interruptible(&fepriv->lock))
 		return -ERESTARTSYS;
 
 	if ((cmd == FE_SET_PROPERTY) || (cmd == FE_GET_PROPERTY))
@@ -1545,7 +1544,7 @@ static int dvb_frontend_ioctl(struct file *file,
 		err = dvb_frontend_ioctl_legacy(file, cmd, parg);
 	}
 
-	up(&fepriv->sem);
+	mutex_unlock(&fepriv->lock);
 	return err;
 }
 
@@ -2115,7 +2114,7 @@ int dvb_register_frontend(struct dvb_adapter* dvb,
 	}
 	fepriv = fe->frontend_priv;
 
-	sema_init(&fepriv->sem, 1);
+	mutex_init(&fepriv->lock);
 	init_waitqueue_head (&fepriv->wait_queue);
 	init_waitqueue_head (&fepriv->events.wait_queue);
 	mutex_init(&fepriv->events.mtx);
-- 
1.7.2.5

