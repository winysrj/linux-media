Return-path: <linux-media-owner@vger.kernel.org>
Received: from swift.blarg.de ([78.47.110.205]:59762 "EHLO swift.blarg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753555AbcGDMIy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jul 2016 08:08:54 -0400
Subject: [PATCH 2/2] dvb_frontend: eliminate blocking wait in
 dvb_unregister_frontend()
From: Max Kellermann <max@duempel.org>
To: linux-media@vger.kernel.org, shuahkh@osg.samsung.com,
	mchehab@osg.samsung.com
Cc: linux-kernel@vger.kernel.org
Date: Mon, 04 Jul 2016 14:08:51 +0200
Message-ID: <146763413097.10008.12031335874667069131.stgit@woodpecker.blarg.de>
In-Reply-To: <146763412568.10008.7316707423893692579.stgit@woodpecker.blarg.de>
References: <146763412568.10008.7316707423893692579.stgit@woodpecker.blarg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The wait_event() call in dvb_unregister_frontend() waits synchronously
for other tasks to free a file descriptor, but it does that while
holding several mutexes.  That alone is a bad idea, but if one user
process happens to keep a (defunct) file descriptor open indefinitely,
the kernel will correctly detect a hung task:

    INFO: task kworker/0:1:314 blocked for more than 30 seconds.
          Not tainted 4.7.0-rc1-hosting+ #50
    "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
    kworker/0:1     D ffff88003daf7a50     0   314      2 0x00000000
    Workqueue: usb_hub_wq hub_event
     ffff88003daf7a50 0000000000000296 ffff88003daf7a30 ffff88003fc13f98
     ffff88003dadce00 ffff88003daf8000 ffff88003e3fc010 ffff88003d48d4f8
     ffff88003e3b5030 ffff88003e3f8898 ffff88003daf7a68 ffffffff810cf860
    Call Trace:
     [<ffffffff810cf860>] schedule+0x30/0x80
     [<ffffffff812f88d3>] dvb_unregister_frontend+0x93/0xc0
     [<ffffffff8107a000>] ? __wake_up_common+0x80/0x80
     [<ffffffff813019c7>] dvb_usb_adapter_frontend_exit+0x37/0x70
     [<ffffffff81300614>] dvb_usb_exit+0x34/0xb0
     [<ffffffff81300d4a>] dvb_usb_device_exit+0x3a/0x50
     [<ffffffff81302dc2>] pctv452e_usb_disconnect+0x52/0x60
     [<ffffffff81295a07>] usb_unbind_interface+0x67/0x1e0
     [<ffffffff810609f3>] ? __blocking_notifier_call_chain+0x53/0x70
     [<ffffffff8127ba67>] __device_release_driver+0x77/0x110
     [<ffffffff8127c2d3>] device_release_driver+0x23/0x30
     [<ffffffff8127ab5d>] bus_remove_device+0x10d/0x150
     [<ffffffff8127879b>] device_del+0x13b/0x260
     [<ffffffff81299dea>] ? usb_remove_ep_devs+0x1a/0x30
     [<ffffffff8129468e>] usb_disable_device+0x9e/0x1e0
     [<ffffffff8128bb09>] usb_disconnect+0x89/0x260
     [<ffffffff8128db8d>] hub_event+0x30d/0xfc0
     [<ffffffff81059475>] process_one_work+0x1c5/0x4a0
     [<ffffffff8105940c>] ? process_one_work+0x15c/0x4a0
     [<ffffffff81059799>] worker_thread+0x49/0x480
     [<ffffffff81059750>] ? process_one_work+0x4a0/0x4a0
     [<ffffffff81059750>] ? process_one_work+0x4a0/0x4a0
     [<ffffffff8105f65e>] kthread+0xee/0x110
     [<ffffffff810400bf>] ret_from_fork+0x1f/0x40
     [<ffffffff8105f570>] ? __kthread_unpark+0x70/0x70
    5 locks held by kworker/0:1/314:
     #0:  ("usb_hub_wq"){......}, at: [<ffffffff8105940c>] process_one_work+0x15c/0x4a0
     #1:  ((&hub->events)){......}, at: [<ffffffff8105940c>] process_one_work+0x15c/0x4a0
     #2:  (&dev->mutex){......}, at: [<ffffffff8128d8cb>] hub_event+0x4b/0xfc0
     #3:  (&dev->mutex){......}, at: [<ffffffff8128bad2>] usb_disconnect+0x52/0x260
     #4:  (&dev->mutex){......}, at: [<ffffffff8127c2cb>] device_release_driver+0x1b/0x30

This patch removes the blocking wait, and postpones the kfree() call
until all file handles have been closed by using struct kref.

Signed-off-by: Max Kellermann <max@duempel.org>
---
 drivers/media/dvb-core/dvb_frontend.c |   33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index c014261..be99c8d 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -99,6 +99,7 @@ MODULE_PARM_DESC(dvb_mfe_wait_time, "Wait up to <mfe_wait_time> seconds on open(
 static DEFINE_MUTEX(frontend_mutex);
 
 struct dvb_frontend_private {
+	struct kref refcount;
 
 	/* thread/frontend values */
 	struct dvb_device *dvbdev;
@@ -137,6 +138,23 @@ struct dvb_frontend_private {
 #endif
 };
 
+static void dvb_frontend_private_free(struct kref *ref)
+{
+	struct dvb_frontend_private *fepriv =
+		container_of(ref, struct dvb_frontend_private, refcount);
+	kfree(fepriv);
+}
+
+static void dvb_frontend_private_put(struct dvb_frontend_private *fepriv)
+{
+	kref_put(&fepriv->refcount, dvb_frontend_private_free);
+}
+
+static void dvb_frontend_private_get(struct dvb_frontend_private *fepriv)
+{
+	kref_get(&fepriv->refcount);
+}
+
 static void dvb_frontend_wakeup(struct dvb_frontend *fe);
 static int dtv_get_frontend(struct dvb_frontend *fe,
 			    struct dtv_frontend_properties *c,
@@ -2543,6 +2561,8 @@ static int dvb_frontend_open(struct inode *inode, struct file *file)
 		fepriv->events.eventr = fepriv->events.eventw = 0;
 	}
 
+	dvb_frontend_private_get(fepriv);
+
 	if (adapter->mfe_shared)
 		mutex_unlock (&adapter->mfe_lock);
 	return ret;
@@ -2591,6 +2611,8 @@ static int dvb_frontend_release(struct inode *inode, struct file *file)
 			fe->ops.ts_bus_ctrl(fe, 0);
 	}
 
+	dvb_frontend_private_put(fepriv);
+
 	return ret;
 }
 
@@ -2679,6 +2701,8 @@ int dvb_register_frontend(struct dvb_adapter* dvb,
 	}
 	fepriv = fe->frontend_priv;
 
+	kref_init(&fepriv->refcount);
+
 	sema_init(&fepriv->sem, 1);
 	init_waitqueue_head (&fepriv->wait_queue);
 	init_waitqueue_head (&fepriv->events.wait_queue);
@@ -2713,18 +2737,11 @@ int dvb_unregister_frontend(struct dvb_frontend* fe)
 
 	mutex_lock(&frontend_mutex);
 	dvb_frontend_stop (fe);
-	mutex_unlock(&frontend_mutex);
-
-	if (fepriv->dvbdev->users < -1)
-		wait_event(fepriv->dvbdev->wait_queue,
-				fepriv->dvbdev->users==-1);
-
-	mutex_lock(&frontend_mutex);
 	dvb_unregister_device (fepriv->dvbdev);
 
 	/* fe is invalid now */
-	kfree(fepriv);
 	mutex_unlock(&frontend_mutex);
+	dvb_frontend_private_put(fepriv);
 	return 0;
 }
 EXPORT_SYMBOL(dvb_unregister_frontend);

