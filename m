Return-path: <linux-media-owner@vger.kernel.org>
Received: from swift.blarg.de ([78.47.110.205]:51163 "EHLO swift.blarg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932487AbcHIVlp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Aug 2016 17:41:45 -0400
Subject: [PATCH 10/12] [media] dvb_frontend: move kref to struct dvb_frontend
From: Max Kellermann <max.kellermann@gmail.com>
To: linux-media@vger.kernel.org, shuahkh@osg.samsung.com,
	mchehab@osg.samsung.com
Cc: linux-kernel@vger.kernel.org
Date: Tue, 09 Aug 2016 23:32:51 +0200
Message-ID: <147077837162.21835.13795783837449669535.stgit@woodpecker.blarg.de>
In-Reply-To: <147077832610.21835.743840405297289081.stgit@woodpecker.blarg.de>
References: <147077832610.21835.743840405297289081.stgit@woodpecker.blarg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This commit amends my old commit fe35637b0a9f ("[media] dvb_frontend:
eliminate blocking wait in dvb_unregister_frontend()"), which added
kref to struct dvb_frontend_private.  It turned out that there are
several use-after-free bugs left, which affect the struct
dvb_frontend.  Protecting it with kref also protects struct
dvb_frontend_private, so we can simply move it.

This is how the use-after-free looks like in KASAN:

    BUG: KASAN: use-after-free in string+0x60/0xb1 at addr ffff880033bd9fc0
    Read of size 1 by task kworker/0:2/617
    CPU: 0 PID: 617 Comm: kworker/0:2 Not tainted 4.8.0-rc1-hosting+ #60
    Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
    Workqueue: usb_hub_wq hub_event
     0000000000000000 ffff880033757218 ffffffff81394e50 ffff880033bd9fd0
     ffff880035c03b00 ffff880033757240 ffffffff811f271d ffff880033bd9fc0
     1ffff1000677b3f8 ffffed000677b3f8 ffff8800337572b8 ffffffff811f2afe
    Call Trace:
     [...]
     [<ffffffff813a2d2f>] vsnprintf+0x39d/0x7e9
     [<ffffffff813993f9>] add_uevent_var+0x10f/0x1dc
     [<ffffffff814fe5ca>] rc_dev_uevent+0x55/0x6f
     [<ffffffff814438f8>] dev_uevent+0x2e1/0x316
     [<ffffffff81399744>] kobject_uevent_env+0x27e/0x701
     [<ffffffff81399bd2>] kobject_uevent+0xb/0xd
     [<ffffffff81443445>] device_del+0x322/0x383
     [<ffffffff81500c0c>] rc_unregister_device+0x98/0xc3
     [<ffffffff81508fb4>] dvb_usb_remote_exit+0x7a/0x90
     [<ffffffff81506157>] dvb_usb_exit+0x1d/0xe5
     [<ffffffff81506e90>] dvb_usb_device_exit+0x69/0x7d
     [<ffffffff8150a181>] pctv452e_usb_disconnect+0x7b/0x80
     [...]
    Object at ffff880033bd9fc0, in cache kmalloc-16 size: 16
    Allocated:
     [...]
    Freed:
    PID = 617
     [...]
     [<ffffffff811f034c>] kfree+0xd9/0x166
     [<ffffffff814fe513>] ir_free_table+0x2f/0x51
     [<ffffffff81500bc1>] rc_unregister_device+0x4d/0xc3
     [<ffffffff81508fb4>] dvb_usb_remote_exit+0x7a/0x90
     [<ffffffff81506157>] dvb_usb_exit+0x1d/0xe5
     [<ffffffff81506e90>] dvb_usb_device_exit+0x69/0x7d
     [<ffffffff8150a181>] pctv452e_usb_disconnect+0x7b/0x80

Another one:

    BUG: KASAN: use-after-free in do_sys_poll+0x336/0x6b8 at addr ffff88003563fcc0
    Read of size 8 by task tuner on fronte/1042
    CPU: 1 PID: 1042 Comm: tuner on fronte Tainted: G    B           4.8.0-rc1-hosting+ #60
    Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
     0000000000000000 ffff88003353f910 ffffffff81394e50 ffff88003563fd80
     ffff880035c03200 ffff88003353f938 ffffffff811f271d ffff88003563fc80
     1ffff10006ac7f98 ffffed0006ac7f98 ffff88003353f9b0 ffffffff811f2afe
    Call Trace:
     [...]
     [<ffffffff812289b3>] do_sys_poll+0x336/0x6b8
     [...]
     [<ffffffff81228ed9>] SyS_poll+0xa9/0x194
     [...]
    Object at ffff88003563fc80, in cache kmalloc-256 size: 256
    Allocated:
     [...]
    Freed:
    PID = 617
     [...]
     [<ffffffff811f034c>] kfree+0xd9/0x166
     [<ffffffff814eb60d>] dvb_unregister_device+0xd6/0xe5
     [<ffffffff814fa4ed>] dvb_unregister_frontend+0x4b/0x66
     [<ffffffff8150810b>] dvb_usb_adapter_frontend_exit+0x69/0xac
     [<ffffffff8150617d>] dvb_usb_exit+0x43/0xe5
     [<ffffffff81506e90>] dvb_usb_device_exit+0x69/0x7d
     [<ffffffff8150a181>] pctv452e_usb_disconnect+0x7b/0x80

Signed-off-by: Max Kellermann <max.kellermann@gmail.com>
---
 drivers/media/dvb-core/dvb_frontend.c |   46 ++++++++++++++++++++++-----------
 drivers/media/dvb-core/dvb_frontend.h |    1 +
 2 files changed, 31 insertions(+), 16 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 5bbe389..c38143b4 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -99,8 +99,6 @@ MODULE_PARM_DESC(dvb_mfe_wait_time, "Wait up to <mfe_wait_time> seconds on open(
 static DEFINE_MUTEX(frontend_mutex);
 
 struct dvb_frontend_private {
-	struct kref refcount;
-
 	/* thread/frontend values */
 	struct dvb_device *dvbdev;
 	struct dvb_frontend_parameters parameters_out;
@@ -138,21 +136,30 @@ struct dvb_frontend_private {
 #endif
 };
 
-static void dvb_frontend_private_free(struct kref *ref)
+static void dvb_frontend_invoke_release(struct dvb_frontend *fe,
+					void (*release)(struct dvb_frontend *fe));
+
+static void dvb_frontend_free(struct kref *ref)
 {
-	struct dvb_frontend_private *fepriv =
-		container_of(ref, struct dvb_frontend_private, refcount);
+	struct dvb_frontend *fe =
+		container_of(ref, struct dvb_frontend, refcount);
+	struct dvb_frontend_private *fepriv = fe->frontend_priv;
+
+	dvb_free_device(fepriv->dvbdev);
+
+	dvb_frontend_invoke_release(fe, fe->ops.release);
+
 	kfree(fepriv);
 }
 
-static void dvb_frontend_private_put(struct dvb_frontend_private *fepriv)
+static void dvb_frontend_put(struct dvb_frontend *fe)
 {
-	kref_put(&fepriv->refcount, dvb_frontend_private_free);
+	kref_put(&fe->refcount, dvb_frontend_free);
 }
 
-static void dvb_frontend_private_get(struct dvb_frontend_private *fepriv)
+static void dvb_frontend_get(struct dvb_frontend *fe)
 {
-	kref_get(&fepriv->refcount);
+	kref_get(&fe->refcount);
 }
 
 static void dvb_frontend_wakeup(struct dvb_frontend *fe);
@@ -2569,7 +2576,7 @@ static int dvb_frontend_open(struct inode *inode, struct file *file)
 		fepriv->events.eventr = fepriv->events.eventw = 0;
 	}
 
-	dvb_frontend_private_get(fepriv);
+	dvb_frontend_get(fe);
 
 	if (adapter->mfe_shared)
 		mutex_unlock (&adapter->mfe_lock);
@@ -2619,7 +2626,7 @@ static int dvb_frontend_release(struct inode *inode, struct file *file)
 			fe->ops.ts_bus_ctrl(fe, 0);
 	}
 
-	dvb_frontend_private_put(fepriv);
+	dvb_frontend_put(fe);
 
 	return ret;
 }
@@ -2709,7 +2716,14 @@ int dvb_register_frontend(struct dvb_adapter* dvb,
 	}
 	fepriv = fe->frontend_priv;
 
-	kref_init(&fepriv->refcount);
+	kref_init(&fe->refcount);
+
+	/*
+	 * After initialization, there need to be two references: one
+	 * for dvb_unregister_frontend(), and another one for
+	 * dvb_frontend_detach().
+	 */
+	dvb_frontend_get(fe);
 
 	sema_init(&fepriv->sem, 1);
 	init_waitqueue_head (&fepriv->wait_queue);
@@ -2744,12 +2758,12 @@ int dvb_unregister_frontend(struct dvb_frontend* fe)
 	dev_dbg(fe->dvb->device, "%s:\n", __func__);
 
 	mutex_lock(&frontend_mutex);
-	dvb_frontend_stop (fe);
-	dvb_unregister_device (fepriv->dvbdev);
+	dvb_frontend_stop(fe);
+	dvb_remove_device(fepriv->dvbdev);
 
 	/* fe is invalid now */
 	mutex_unlock(&frontend_mutex);
-	dvb_frontend_private_put(fepriv);
+	dvb_frontend_put(fe);
 	return 0;
 }
 EXPORT_SYMBOL(dvb_unregister_frontend);
@@ -2771,6 +2785,6 @@ void dvb_frontend_detach(struct dvb_frontend* fe)
 	dvb_frontend_invoke_release(fe, fe->ops.tuner_ops.release);
 	dvb_frontend_invoke_release(fe, fe->ops.analog_ops.release);
 	dvb_frontend_invoke_release(fe, fe->ops.detach);
-	dvb_frontend_invoke_release(fe, fe->ops.release);
+	dvb_frontend_put(fe);
 }
 EXPORT_SYMBOL(dvb_frontend_detach);
diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index d535571..f21b255 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -667,6 +667,7 @@ struct dtv_frontend_properties {
  */
 
 struct dvb_frontend {
+	struct kref refcount;
 	struct dvb_frontend_ops ops;
 	struct dvb_adapter *dvb;
 	void *demodulator_priv;

