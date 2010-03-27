Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:53796 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754083Ab0C0WEt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Mar 2010 18:04:49 -0400
Received: from smtp2-g21.free.fr (localhost [127.0.0.1])
	by smtp2-g21.free.fr (Postfix) with ESMTP id 1EA114B0045
	for <linux-media@vger.kernel.org>; Sat, 27 Mar 2010 23:04:43 +0100 (CET)
Received: from [192.168.1.234] (cac94-1-81-57-151-96.fbx.proxad.net [81.57.151.96])
	by smtp2-g21.free.fr (Postfix) with ESMTP id 209844B00D9
	for <linux-media@vger.kernel.org>; Sat, 27 Mar 2010 23:04:41 +0100 (CET)
Message-ID: <4BAE810A.6030405@free.fr>
Date: Sat, 27 Mar 2010 23:04:58 +0100
From: matthieu castet <castet.matthieu@free.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] fix dvb frontend lockup
References: <4BA603AB.6070809@free.fr>
In-Reply-To: <4BA603AB.6070809@free.fr>
Content-Type: multipart/mixed;
 boundary="------------060505080405020005080704"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060505080405020005080704
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

matthieu castet a écrit :
> Hi,
> 
> With my current kernel (2.6.32), if my dvb device is removed while in 
> use, I got [1].
> 
> After checking the source code, the problem seems to happen also in 
> master :
> 
> If there are users (for example users == -2) :
> - dvb_unregister_frontend :
> - stop kernel thread with dvb_frontend_stop :
>  - fepriv->exit = 1;
>  - thread loop catch stop event and break while loop
>  - fepriv->thread = NULL; and fepriv->exit = 0;
> - dvb_unregister_frontend wait on "fepriv->dvbdev->wait_queue" that 
> fepriv->dvbdev->users==-1.
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
> [ 4920.484056]  f64c8000 00000046 00000000 c2008000 00000004 c13fa000 
> c13fa000 f
> 64c8000
> [ 4920.484066]  f64c81bc c2008000 00000000 d9d9dce6 00000452 00000001 
> f64c8000 c
> 102daad
> [ 4920.484075]  00100100 f64c81bc 00000286 f0a7ccc0 f0913404 f0cba404 
> f644de58 f
> 092b0a8
> [ 4920.484084] Call Trace:
> [ 4920.484102]  [<c102daad>] ? default_wake_function+0x0/0x8
> [ 4920.484147]  [<f8cb09e1>] ? dvb_unregister_frontend+0x95/0xcc [dvb_core]
> [ 4920.484157]  [<c1044412>] ? autoremove_wake_function+0x0/0x2d
> [ 4920.484168]  [<f8dd1af2>] ? dvb_usb_adapter_frontend_exit+0x12/0x21 
> [dvb_usb]
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

--------------060505080405020005080704
Content-Type: text/x-diff;
 name="frontend_release.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="frontend_release.diff"

--- 1/linux/drivers/media/dvb/dvb-core/dvb_frontend.c	2010-03-27 22:59:50.000000000 +0100
+++ 2/linux/drivers/media/dvb/dvb-core/dvb_frontend.c	2010-03-27 23:01:34.000000000 +0100
@@ -686,7 +686,10 @@
 	}
 
 	fepriv->thread = NULL;
-	fepriv->exit = 0;
+	if (kthread_should_stop())
+		fepriv->exit = 2;
+	else
+		fepriv->exit = 0;
 	mb();
 
 	dvb_frontend_wakeup(fe);
@@ -1929,6 +1932,8 @@
 	int ret;
 
 	dprintk ("%s\n", __func__);
+	if (fepriv->exit == 2)
+		return -ENODEV;
 
 	if (adapter->mfe_shared) {
 		mutex_lock (&adapter->mfe_lock);
@@ -2021,7 +2026,7 @@
 	ret = dvb_generic_release (inode, file);
 
 	if (dvbdev->users == -1) {
-		if (fepriv->exit == 1) {
+		if (fepriv->exit) {
 			fops_put(file->f_op);
 			file->f_op = NULL;
 			wake_up(&dvbdev->wait_queue);

--------------060505080405020005080704--
