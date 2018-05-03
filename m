Return-path: <linux-media-owner@vger.kernel.org>
Received: from swift.blarg.de ([78.47.110.205]:39099 "EHLO swift.blarg.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751075AbeECSVR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 3 May 2018 14:21:17 -0400
From: Max Kellermann <max.kellermann@gmail.com>
To: mchehab@osg.samsung.com, shuahkh@osg.samsung.com,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Max Kellermann <max.kellermann@gmail.com>
Subject: [PATCH] [media] dvbdev: add a mutex protecting the "mdev" pointer
Date: Thu,  3 May 2018 20:12:59 +0200
Message-Id: <20180503181259.22341-1-max.kellermann@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

During destruction, a race condition in
dvb_media_controller_disable_source() can cause a kernel crash,
because the "mdev" pointer has been read successfully while another
task executes dvb_usb_media_device_unregister(), which destroys the
object.  Example for such a crash:

    general protection fault: 0000 [#1] SMP
    CPU: 1 PID: 301 Comm: vdr Not tainted 4.8.1-nuc+ #102
    [142B blob data]
    task: ffff8802301f2040 task.stack: ffff880233728000
    RIP: 0010:[<ffffffff816c296b>]  [<ffffffff816c296b>] dvb_frontend_release+0xcb/0x120
    RSP: 0018:ffff88023372bdd8  EFLAGS: 00010202
    RAX: 001fd55c000000da RBX: ffff880236bad810 RCX: 0000000000000000
    RDX: ffff880235bd81f0 RSI: 0000000000000246 RDI: ffff880235bd81e8
    RBP: ffff88023372be00 R08: 0000000000000000 R09: 0000000000000000
    R10: 0000000000000000 R11: ffff88022f009910 R12: 0000000000000000
    R13: ffff880235a21a80 R14: ffff880235bd8000 R15: ffff880235bb8a78
    FS:  0000000000000000(0000) GS:ffff88023fd00000(0000) knlGS:0000000000000000
    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    CR2: 00007f96edd69818 CR3: 0000000002406000 CR4: 00000000001006e0
    Stack:
     ffff88022f009900 0000000000000008 ffff880235bb8a78 ffff8802344fbb20
     ffff880236437b40 ffff88023372be48 ffffffff8117a81e ffff880235bb8a78
     ffff88022f009910 ffff8802335a7400 ffff8802301f2040 ffff88022f009900
    Call Trace:
     [<ffffffff8117a81e>] __fput+0xde/0x1d0
     [<ffffffff8117a949>] ____fput+0x9/0x10
     [<ffffffff810a9fce>] task_work_run+0x7e/0xa0
     [<ffffffff81094bab>] do_exit+0x27b/0xa50
     [<ffffffff810407e3>] ? __do_page_fault+0x1c3/0x430
     [<ffffffff81095402>] do_group_exit+0x42/0xb0
     [<ffffffff8109547f>] SyS_exit_group+0xf/0x10
     [<ffffffff8108bedb>] entry_SYSCALL_64_fastpath+0x13/0x8f
    Code: 31 c9 49 8d be e8 01 00 00 ba 01 00 00 00 be 03 00 00 00 e8 68 2d a0 ff 48 8b 83 10 03 00 00 48 8b 80 88 00 00 00 48 85 c0 74 12 <48> 8b 80 88 02 00 00 48 85 c0 74 06 49 8b 7d
    RIP  [<ffffffff816c296b>] dvb_frontend_release+0xcb/0x120

Signed-off-by: Max Kellermann <max.kellermann@gmail.com>
---
 drivers/media/dvb-core/dvb_frontend.c   | 7 +++++++
 drivers/media/dvb-core/dvbdev.c         | 4 ++++
 drivers/media/usb/dvb-usb/dvb-usb-dvb.c | 4 ++++
 include/media/dvbdev.h                  | 2 ++
 4 files changed, 17 insertions(+)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index a4ada1ccf0df..bba3dbb9154e 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -2732,6 +2732,7 @@ static int dvb_frontend_open(struct inode *inode, struct file *file)
 		fepriv->voltage = -1;
 
 #ifdef CONFIG_MEDIA_CONTROLLER_DVB
+		mutex_lock(&fe->dvb->mdev_lock);
 		if (fe->dvb->mdev) {
 			mutex_lock(&fe->dvb->mdev->graph_mutex);
 			if (fe->dvb->mdev->enable_source)
@@ -2740,11 +2741,13 @@ static int dvb_frontend_open(struct inode *inode, struct file *file)
 							   &fepriv->pipe);
 			mutex_unlock(&fe->dvb->mdev->graph_mutex);
 			if (ret) {
+				mutex_unlock(&fe->dvb->mdev_lock);
 				dev_err(fe->dvb->device,
 					"Tuner is busy. Error %d\n", ret);
 				goto err2;
 			}
 		}
+		mutex_unlock(&fe->dvb->mdev_lock);
 #endif
 		ret = dvb_frontend_start (fe);
 		if (ret)
@@ -2762,12 +2765,14 @@ static int dvb_frontend_open(struct inode *inode, struct file *file)
 
 err3:
 #ifdef CONFIG_MEDIA_CONTROLLER_DVB
+	mutex_lock(&fe->dvb->mdev_lock);
 	if (fe->dvb->mdev) {
 		mutex_lock(&fe->dvb->mdev->graph_mutex);
 		if (fe->dvb->mdev->disable_source)
 			fe->dvb->mdev->disable_source(dvbdev->entity);
 		mutex_unlock(&fe->dvb->mdev->graph_mutex);
 	}
+	mutex_unlock(&fe->dvb->mdev_lock);
 err2:
 #endif
 	dvb_generic_release(inode, file);
@@ -2799,12 +2804,14 @@ static int dvb_frontend_release(struct inode *inode, struct file *file)
 	if (dvbdev->users == -1) {
 		wake_up(&fepriv->wait_queue);
 #ifdef CONFIG_MEDIA_CONTROLLER_DVB
+		mutex_lock(&fe->dvb->mdev_lock);
 		if (fe->dvb->mdev) {
 			mutex_lock(&fe->dvb->mdev->graph_mutex);
 			if (fe->dvb->mdev->disable_source)
 				fe->dvb->mdev->disable_source(dvbdev->entity);
 			mutex_unlock(&fe->dvb->mdev->graph_mutex);
 		}
+		mutex_unlock(&fe->dvb->mdev_lock);
 #endif
 		if (fe->exit != DVB_FE_NO_EXIT)
 			wake_up(&dvbdev->wait_queue);
diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index 787fe06df217..b44232f03c42 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -859,6 +859,10 @@ int dvb_register_adapter(struct dvb_adapter *adap, const char *name,
 	adap->mfe_dvbdev = NULL;
 	mutex_init (&adap->mfe_lock);
 
+#ifdef CONFIG_MEDIA_CONTROLLER_DVB
+	mutex_init (&adap->mdev_lock);
+#endif
+
 	list_add_tail (&adap->list_head, &dvb_adapter_list);
 
 	mutex_unlock(&dvbdev_register_lock);
diff --git a/drivers/media/usb/dvb-usb/dvb-usb-dvb.c b/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
index 3a66e732e0d8..8056053c9ab0 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
+++ b/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
@@ -132,10 +132,14 @@ static void dvb_usb_media_device_unregister(struct dvb_usb_adapter *adap)
 	if (!adap->dvb_adap.mdev)
 		return;
 
+	mutex_lock(&adap->dvb_adap.mdev_lock);
+
 	media_device_unregister(adap->dvb_adap.mdev);
 	media_device_cleanup(adap->dvb_adap.mdev);
 	kfree(adap->dvb_adap.mdev);
 	adap->dvb_adap.mdev = NULL;
+
+	mutex_unlock(&adap->dvb_adap.mdev_lock);
 #endif
 }
 
diff --git a/include/media/dvbdev.h b/include/media/dvbdev.h
index ee91516ad074..881ca461b7bb 100644
--- a/include/media/dvbdev.h
+++ b/include/media/dvbdev.h
@@ -91,6 +91,7 @@ struct dvb_frontend;
  * @mfe_dvbdev:		Frontend device in use, in the case of MFE
  * @mfe_lock:		Lock to prevent using the other frontends when MFE is
  *			used.
+ * @mdev_lock:          Protect access to the mdev pointer.
  * @mdev:		pointer to struct media_device, used when the media
  *			controller is used.
  * @conn:		RF connector. Used only if the device has no separate
@@ -114,6 +115,7 @@ struct dvb_adapter {
 	struct mutex mfe_lock;		/* access lock for thread creation */
 
 #if defined(CONFIG_MEDIA_CONTROLLER_DVB)
+	struct mutex mdev_lock;
 	struct media_device *mdev;
 	struct media_entity *conn;
 	struct media_pad *conn_pads;
-- 
2.17.0
