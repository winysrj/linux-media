Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp6-g21.free.fr ([212.27.42.6]:60050 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143Ab0EES71 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 5 May 2010 14:59:27 -0400
Message-ID: <4BE1C008.7020206@free.fr>
Date: Wed, 05 May 2010 20:59:20 +0200
From: matthieu castet <castet.matthieu@free.fr>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] fix dvb frontend lockup
References: <4BA603AB.6070809@free.fr>	<4BAE810A.6030405@free.fr> <20100503210726.66a41c01@pedra>
In-Reply-To: <20100503210726.66a41c01@pedra>
Content-Type: multipart/mixed;
 boundary="------------080104000308000107090504"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080104000308000107090504
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

matthieu castet a écrit :
> Hi,
>
> With my current kernel (2.6.32), if my dvb device is removed while in use, I got [1].
>
> After checking the source code, the problem seems to happen also in master :
>
> If there are users (for example users == -2) :
> - dvb_unregister_frontend :
> - stop kernel thread with dvb_frontend_stop :
>  - fepriv->exit = 1;
>  - thread loop catch stop event and break while loop
>  - fepriv->thread = NULL; and fepriv->exit = 0;
> - dvb_unregister_frontend wait on "fepriv->dvbdev->wait_queue" that fepriv->dvbdev->users==-1.
> The user finish :
> - dvb_frontend_release - set users to -1
> - don't wait wait_queue because fepriv->exit != 1
>
> => dvb_unregister_frontend never exit the wait queue.
>
>
> Matthieu
>
>
> [ 4920.484047] khubd         D c2008000     0   198      2 0x00000000
> [ 4920.484056]  f64c8000 00000046 00000000 c2008000 00000004 c13fa000 c13fa000 f
> 64c8000
> [ 4920.484066]  f64c81bc c2008000 00000000 d9d9dce6 00000452 00000001 f64c8000 c
> 102daad
> [ 4920.484075]  00100100 f64c81bc 00000286 f0a7ccc0 f0913404 f0cba404 f644de58 f
> 092b0a8
> [ 4920.484084] Call Trace:
> [ 4920.484102]  [<c102daad>] ? default_wake_function+0x0/0x8
> [ 4920.484147]  [<f8cb09e1>] ? dvb_unregister_frontend+0x95/0xcc [dvb_core]
> [ 4920.484157]  [<c1044412>] ? autoremove_wake_function+0x0/0x2d
> [ 4920.484168]  [<f8dd1af2>] ? dvb_usb_adapter_frontend_exit+0x12/0x21 [dvb_usb]
> [ 4920.484176]  [<f8dd12f1>] ? dvb_usb_exit+0x26/0x88 [dvb_usb]
> [ 4920.484184]  [<f8dd138d>] ? dvb_usb_device_exit+0x3a/0x4a [dvb_usb]
> [ 4920.484217]  [<f7fe1b08>] ? usb_unbind_interface+0x3f/0xb4 [usbcore]
> [ 4920.484227]  [<c11a4178>] ? __device_release_driver+0x74/0xb7
> [ 4920.484233]  [<c11a4247>] ? device_release_driver+0x15/0x1e
> [ 4920.484243]  [<c11a3a33>] ? bus_remove_device+0x6e/0x87
> [ 4920.484249]  [<c11a26d6>] ? device_del+0xfa/0x152
> [ 4920.484264]  [<f7fdf609>] ? usb_disable_device+0x59/0xb9 [usbcore]
> [ 4920.484279]  [<f7fdb9ee>] ? usb_disconnect+0x70/0xdc [usbcore]
> [ 4920.484294]  [<f7fdc728>] ? hub_thread+0x521/0xe1d [usbcore]
> [ 4920.484301]  [<c1044412>] ? autoremove_wake_function+0x0/0x2d
> [ 4920.484316]  [<f7fdc207>] ? hub_thread+0x0/0xe1d [usbcore]
> [ 4920.484321]  [<c10441e0>] ? kthread+0x61/0x66
> [ 4920.484327]  [<c104417f>] ? kthread+0x0/0x66
> [ 4920.484336]  [<c1003d47>] ? kernel_thread_helper+0x7/0x10
>
Here a patch that fix the issue


Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>



--------------080104000308000107090504
Content-Type: text/x-diff;
 name="frontend_release2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="frontend_release2.diff"

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 55ea260..6932def 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -95,6 +95,10 @@ MODULE_PARM_DESC(dvb_mfe_wait_time, "Wait up to <mfe_wait_time> seconds on open(
  * FESTATE_LOSTLOCK. When the lock has been lost, and we're searching it again.
  */
 
+#define DVB_FE_NO_EXIT	0
+#define DVB_FE_NORMAL_EXIT	1
+#define DVB_FE_DEVICE_REMOVED	2
+
 static DEFINE_MUTEX(frontend_mutex);
 
 struct dvb_frontend_private {
@@ -497,7 +501,7 @@ static int dvb_frontend_is_exiting(struct dvb_frontend *fe)
 {
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 
-	if (fepriv->exit)
+	if (fepriv->exit != DVB_FE_NO_EXIT)
 		return 1;
 
 	if (fepriv->dvbdev->writers == 1)
@@ -559,7 +563,7 @@ restart:
 
 		if (kthread_should_stop() || dvb_frontend_is_exiting(fe)) {
 			/* got signal or quitting */
-			fepriv->exit = 1;
+			fepriv->exit = DVB_FE_NORMAL_EXIT;
 			break;
 		}
 
@@ -673,7 +677,10 @@ restart:
 	}
 
 	fepriv->thread = NULL;
-	fepriv->exit = 0;
+	if (kthread_should_stop())
+		fepriv->exit = DVB_FE_DEVICE_REMOVED;
+	else
+		fepriv->exit = DVB_FE_NO_EXIT;
 	mb();
 
 	dvb_frontend_wakeup(fe);
@@ -686,7 +693,7 @@ static void dvb_frontend_stop(struct dvb_frontend *fe)
 
 	dprintk ("%s\n", __func__);
 
-	fepriv->exit = 1;
+	fepriv->exit = DVB_FE_NORMAL_EXIT;
 	mb();
 
 	if (!fepriv->thread)
@@ -755,7 +762,7 @@ static int dvb_frontend_start(struct dvb_frontend *fe)
 	dprintk ("%s\n", __func__);
 
 	if (fepriv->thread) {
-		if (!fepriv->exit)
+		if (fepriv->exit == DVB_FE_NO_EXIT)
 			return 0;
 		else
 			dvb_frontend_stop (fe);
@@ -767,7 +774,7 @@ static int dvb_frontend_start(struct dvb_frontend *fe)
 		return -EINTR;
 
 	fepriv->state = FESTATE_IDLE;
-	fepriv->exit = 0;
+	fepriv->exit = DVB_FE_NO_EXIT;
 	fepriv->thread = NULL;
 	mb();
 
@@ -1490,7 +1497,7 @@ static int dvb_frontend_ioctl(struct inode *inode, struct file *file,
 
 	dprintk("%s (%d)\n", __func__, _IOC_NR(cmd));
 
-	if (fepriv->exit)
+	if (fepriv->exit != DVB_FE_NO_EXIT)
 		return -ENODEV;
 
 	if ((file->f_flags & O_ACCMODE) == O_RDONLY &&
@@ -1916,6 +1923,8 @@ static int dvb_frontend_open(struct inode *inode, struct file *file)
 	int ret;
 
 	dprintk ("%s\n", __func__);
+	if (fepriv->exit == DVB_FE_DEVICE_REMOVED)
+		return -ENODEV;
 
 	if (adapter->mfe_shared) {
 		mutex_lock (&adapter->mfe_lock);
@@ -2008,7 +2017,7 @@ static int dvb_frontend_release(struct inode *inode, struct file *file)
 	ret = dvb_generic_release (inode, file);
 
 	if (dvbdev->users == -1) {
-		if (fepriv->exit == 1) {
+		if (fepriv->exit != DVB_FE_NO_EXIT) {
 			fops_put(file->f_op);
 			file->f_op = NULL;
 			wake_up(&dvbdev->wait_queue);

--------------080104000308000107090504--
