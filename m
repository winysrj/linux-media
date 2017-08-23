Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:60387 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751728AbdHWVUN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Aug 2017 17:20:13 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>, linux-media@vger.kernel.org,
        Max Kellermann <max.kellermann@gmail.com>
Subject: [RFC 2/3] dvb_frontend: Add dvb_frontend_init() function
Date: Thu, 24 Aug 2017 00:20:38 +0300
Message-Id: <20170823212039.27751-3-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20170823212039.27751-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20170823212039.27751-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The function is meant to initialize a newly allocated frontend before it
can be used. This ensures that fields needed to release the frontend
(such as the refcount) are initialized early enough before frontend
registration to be usable in error handling code paths.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 44 +++++++++++++++++++++--------------
 drivers/media/dvb-core/dvb_frontend.h | 11 +++++++++
 2 files changed, 38 insertions(+), 17 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index f8caedc83d70..f957511a4037 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -2679,7 +2679,7 @@ EXPORT_SYMBOL(dvb_frontend_resume);
 int dvb_register_frontend(struct dvb_adapter* dvb,
 			  struct dvb_frontend* fe)
 {
-	struct dvb_frontend_private *fepriv;
+	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	const struct dvb_device dvbdev_template = {
 		.users = ~0,
 		.writers = 1,
@@ -2696,28 +2696,15 @@ int dvb_register_frontend(struct dvb_adapter* dvb,
 	if (mutex_lock_interruptible(&frontend_mutex))
 		return -ERESTARTSYS;
 
-	fe->frontend_priv = kzalloc(sizeof(struct dvb_frontend_private), GFP_KERNEL);
-	if (fe->frontend_priv == NULL) {
-		mutex_unlock(&frontend_mutex);
-		return -ENOMEM;
-	}
-	fepriv = fe->frontend_priv;
-
-	kref_init(&fe->refcount);
+	printk(KERN_INFO "%s: frontend %p (id %d)\n", __func__, fe, fe->id);
 
 	/*
-	 * After initialization, there need to be two references: one
-	 * for dvb_unregister_frontend(), and another one for
-	 * dvb_frontend_detach().
+	 * Take a reference to the frontend that will be released at
+	 * unregistration time.
 	 */
 	dvb_frontend_get(fe);
 
-	sema_init(&fepriv->sem, 1);
-	init_waitqueue_head (&fepriv->wait_queue);
-	init_waitqueue_head (&fepriv->events.wait_queue);
-	mutex_init(&fepriv->events.mtx);
 	fe->dvb = dvb;
-	fepriv->inversion = INVERSION_OFF;
 
 	dev_info(fe->dvb->device,
 			"DVB: registering adapter %i frontend %i (%s)...\n",
@@ -2775,3 +2762,26 @@ void dvb_frontend_detach(struct dvb_frontend* fe)
 	dvb_frontend_put(fe);
 }
 EXPORT_SYMBOL(dvb_frontend_detach);
+
+int dvb_frontend_init(struct dvb_frontend *fe)
+{
+	struct dvb_frontend_private *fepriv;
+
+	fepriv = kzalloc(sizeof(*fepriv), GFP_KERNEL);
+	if (fepriv == NULL)
+		return -ENOMEM;
+
+	fe->frontend_priv = fepriv;
+
+	kref_init(&fe->refcount);
+
+	sema_init(&fepriv->sem, 1);
+	init_waitqueue_head(&fepriv->wait_queue);
+	init_waitqueue_head(&fepriv->events.wait_queue);
+	mutex_init(&fepriv->events.mtx);
+
+	fepriv->inversion = INVERSION_OFF;
+
+	return 0;
+}
+EXPORT_SYMBOL(dvb_frontend_init);
diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index 907a05bde162..02fa16ab8650 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -707,6 +707,17 @@ int dvb_register_frontend(struct dvb_adapter *dvb,
 int dvb_unregister_frontend(struct dvb_frontend *fe);
 
 /**
+ * dvb_frontend_init() - Initialize a frontend after allocation
+ * @fe: the frontend to be initialized
+ *
+ * This function must be called by frontend drivers in their attach handler to
+ * initialize the frontend structure they allocate.
+ *
+ * Return 0 on success and a negative error code on failure.
+ */
+int dvb_frontend_init(struct dvb_frontend *fe);
+
+/**
  * dvb_frontend_detach() - Detaches and frees frontend specific data
  *
  * @fe: pointer to the frontend struct
-- 
Regards,

Laurent Pinchart
