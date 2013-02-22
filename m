Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:49731 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755889Ab3BVPRs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Feb 2013 10:17:48 -0500
Message-ID: <1361546262.1968.11.camel@palomino.walls.org>
Subject: Re: 3.7/3.8 kernel won't boot with Hauppauge pvr-150
From: Andy Walls <awalls@md.metrocast.net>
To: Ron Andreasen <dlanor78@gmail.com>
Cc: linux-media@vger.kernel.org, ivtv-users@ivtvdriver.org
Date: Fri, 22 Feb 2013 10:17:42 -0500
In-Reply-To: <ab89dced-9718-4e81-a2c9-1581e0528eb9@email.android.com>
References: <CADUyVi=ztr2uF8jb6urSMtJ0yKRFrLWHrCHYmgKX+-9BTRsRFQ@mail.gmail.com>
	 <ab89dced-9718-4e81-a2c9-1581e0528eb9@email.android.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2013-02-21 at 22:32 -0500, Andy Walls wrote:
> Ron Andreasen <dlanor78@gmail.com> wrote:
> 
> >I've been having trouble getting distros that have any kernel above the
> >3.5
> >series to boot (only tried 64-bit). I get a black screen with a bunch
> >of
> >text and the boot process goes no further. I don't know if this is
> >usually
> >okay, but I'm posting a link to a picture I took of my monitor with my
> >cell
> >phone. It's a bit blurry but hopefully it's still okay:
> >
> >http://imgur.com/viP1kWk,3YJXKbG
> >
> >The distros I've had this problem in are Kubuntu (I've tried several of
> >the
> >daily builds) which uses the 3.8.? (can't boot far enough to see)
> >kernel,
> >Cinnarch which uses the 3.7.3 kernel, and openSUSE 12.3 and I don't
> >remember what version of the kernel that one used.
> >
> >

> It looks like the ivtv module is failing to initialize, starts to
> unload, and in the process of unloading, the cleanup path causes an
> Ooops.  
> 
> I should have time to look closer at it this weekend.

Test this patch (made against Kernel v3.8-rc5).

Hopefully, it will fix the oops and then let you see why the
ivtv_probe() function fails when initializing the PVR-150.

Regards,
Andy

diff --git a/drivers/media/pci/ivtv/ivtv-driver.c b/drivers/media/pci/ivtv/ivtv-driver.c
index df88dc4..de5db69 100644
--- a/drivers/media/pci/ivtv/ivtv-driver.c
+++ b/drivers/media/pci/ivtv/ivtv-driver.c
@@ -298,7 +298,6 @@ static void request_module_async(struct work_struct *work)
 
 static void request_modules(struct ivtv *dev)
 {
-	INIT_WORK(&dev->request_module_wk, request_module_async);
 	schedule_work(&dev->request_module_wk);
 }
 
@@ -307,6 +306,9 @@ static void flush_request_modules(struct ivtv *dev)
 	flush_work_sync(&dev->request_module_wk);
 }
 #else
+static void request_module_async(struct work_struct *work)
+{
+}
 #define request_modules(dev)
 #define flush_request_modules(dev)
 #endif /* CONFIG_MODULES */
@@ -751,6 +753,8 @@ static int ivtv_init_struct1(struct ivtv *itv)
 	spin_lock_init(&itv->lock);
 	spin_lock_init(&itv->dma_reg_lock);
 
+	INIT_WORK(&itv->request_module_wk, request_module_async);
+
 	init_kthread_worker(&itv->irq_worker);
 	itv->irq_worker_task = kthread_run(kthread_worker_fn, &itv->irq_worker,
 					   itv->v4l2_dev.name);



