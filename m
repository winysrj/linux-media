Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3200 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754821Ab3DFGiw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Apr 2013 02:38:52 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Frank =?iso-8859-15?q?Sch=E4fer?= <fschaefer.oss@googlemail.com>
Subject: Re: em28xx: kernel oops in em28xx_tuner_callback() when watching digital TV
Date: Sat, 6 Apr 2013 08:38:41 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <515EF7CF.4060107@googlemail.com>
In-Reply-To: <515EF7CF.4060107@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <201304060838.42052.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri April 5 2013 18:11:59 Frank Schäfer wrote:
> Mauro, Hans,
> with the latest media-tree, I'm getting the following kernel oops when
> starting to watch digital TV with em28xx devices:
> 
> [  124.297707] BUG: unable to handle kernel paging request at 38326f3d
> [  124.297770] IP: [<f8bf1026>] em28xx_tuner_callback+0x6/0x40 [em28xx]
> [  124.297825] *pdpt = 0000000034dd5001 *pde = 0000000000000000
> [  124.297870] Oops: 0000 [#1] PREEMPT SMP
> [  124.297904] Modules linked in: em28xx_rc zl10353 em28xx_dvb dvb_core
> tuner_xc2028 tvp5150 em28xx [...]
> [  124.298010] Pid: 2165, comm: kdvb-ad-0-fe-0 Not tainted
> 3.9.0-rc5-0.1-desktop+ #11 System manufacturer System Product Name/M2N-VM DH
> [  124.298010] EIP: 0060:[<f8bf1026>] EFLAGS: 00010246 CPU: 0
> [  124.298010] EIP is at em28xx_tuner_callback+0x6/0x40 [em28xx]
> [  124.298010] EAX: ef33f000 EBX: 38326d65 ECX: 00000000 EDX: 00000000
> [  124.298010] ESI: ef2d2b50 EDI: ef2d2b00 EBP: ee90b998 ESP: ee90b994
> [  124.298010]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> [  124.298010] CR0: 8005003b CR2: 38326f3d CR3: 362a0000 CR4: 000007f0
> [  124.298010] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> [  124.298010] DR6: ffff0ff0 DR7: 00000400
> [  124.298010] Process kdvb-ad-0-fe-0 (pid: 2165, ti=ee90a000
> task=f1074f80 task.ti=ee90a000)
> [  124.298010] Stack:
> [  124.298010]  f8bf1020 ee90ba2c f8be1139 00000000 f71cb740 ee90b9b0
> ee90b9cb 00000004
> [  124.298010]  ef33f000 ee90b9d0 f8bf24e0 ee90b9cb 00000001 0033fa14
> ee90ba98 ee90baa4
> [  124.298010]  00000002 00000009 12980558 ee90ba96 00000216 00000000
> 00000000 f5c07804
> [  124.298010] Call Trace:
> [  124.298010]  [<f8bf1020>] ? em28xx_i2c_unregister+0x30/0x30 [em28xx]
> [  124.298010]  [<f8be1139>] check_firmware+0x159/0xcf0 [tuner_xc2028]
> [  124.298010]  [<f8bf24e0>] ? em28xx_read_reg_req+0x20/0x30 [em28xx]
> [  124.298010]  [<f8be1d2c>] generic_set_freq+0x5c/0x500 [tuner_xc2028]
> [  124.298010]  [<c060b79d>] ? __i2c_transfer+0x4d/0x60
> [  124.298010]  [<f8be2501>] xc2028_set_params+0x111/0xc10 [tuner_xc2028]
> [  124.298010]  [<f94e9d88>] zl10353_set_parameters+0x578/0x6c0 [zl10353]
> [  124.298010]  [<c026ee1d>] ? update_curr+0x12d/0x1f0
> [  124.298010]  [<c0324123>] ? dma_pool_alloc+0x193/0x1e0
> [  124.298010]  [<c026adcd>] ? cpuacct_charge+0x5d/0x70
> [  124.298010]  [<f94a6db4>] dvb_frontend_swzigzag_autotune+0x144/0x2f0
> [dvb_core]
> [  124.298010]  [<c05cc8d4>] ? usb_alloc_urb+0x14/0x40
> [  124.298010]  [<f94a79dd>] dvb_frontend_swzigzag+0x2ad/0x310 [dvb_core]
> [  124.298010]  [<c026f371>] ? dequeue_entity+0x151/0x670
> [  124.298010]  [<c026fd46>] ? dequeue_task_fair+0x366/0x6d0
> [  124.298010]  [<c0266063>] ? update_rq_clock+0x33/0x160
> [  124.298010]  [<c026c770>] ? __dequeue_entity+0x20/0x40
> [  124.298010]  [<c0201bb3>] ? __switch_to+0xc3/0x380
> [  124.298010]  [<c0263712>] ? finish_task_switch+0x42/0xa0
> [  124.298010]  [<c073ac3c>] ? __schedule+0x34c/0x780
> [  124.298010]  [<c027067c>] ? check_preempt_wakeup+0x13c/0x250
> [  124.298010]  [<c0247af4>] ? lock_timer_base.isra.37+0x24/0x50
> [  124.298010]  [<c02486bd>] ? try_to_del_timer_sync+0x3d/0x50
> [  124.298010]  [<c0248711>] ? del_timer_sync+0x41/0x50
> [  124.298010]  [<c0739299>] ? schedule_timeout+0x129/0x270
> [  124.298010]  [<c02473d0>] ? usleep_range+0x40/0x40
> [  124.298010]  [<c025debb>] ? down_interruptible+0x2b/0x50
> [  124.298010]  [<f94a98ef>] dvb_frontend_thread+0x35f/0x6b0 [dvb_core]
> [  124.298010]  [<c0268e2b>] ? default_wake_function+0xb/0x10
> [  124.298010]  [<c0259340>] ? finish_wait+0x60/0x60
> [  124.298010]  [<f94a9590>] ? dvb_register_frontend+0x180/0x180 [dvb_core]
> [  124.298010]  [<c0258cef>] kthread+0x8f/0xa0
> [  124.298010]  [<c0260000>] ? sys_setgroups+0x90/0x100
> [  124.298010]  [<c0742377>] ret_from_kernel_thread+0x1b/0x28
> [  124.298010]  [<c0258c60>] ? kthread_create_on_node+0xc0/0xc0
> [  124.298010] Code: 55 89 e5 8d 84 10 e4 01 00 00 e8 36 c0 a1 c7 31 c0
> 5d c3 66 90 b8 ed ff ff ff c3 90 90 90 90 90 90 90 90 90 90 55 89 e5 53
> 8b 18 <8b> 93 d8 01 00 00 83 fa 4c 75 1f 31 c0 85 c9 74 09 5b 5d c3 8d
> [  124.298010] EIP: [<f8bf1026>] em28xx_tuner_callback+0x6/0x40 [em28xx]
> SS:ESP 0068:ee90b994
> [  124.298010] CR2: 0000000038326f3d
> [  124.348464] ---[ end trace 2877a1eb744b8796 ]---
> 
> 
> I don't have time to debug this further this evening+weekend, but I
> assume the recent i2c bus changes from Mauro and/or commit bc3d2928
> (Hans fix for em28xx_tuner_callback() ) are involved.
> Could you please take a look at it this ?

Yes, that's a correct assumption. It turns out that for dvb the priv pointer
wasn't updated. The whole tuner core code is one big inpenetrable mess :-(

Can you try the patch below and let me know if that works?

Thanks,

	Hans


diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 42a6a26..aacab3b 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -268,7 +268,8 @@ static int em28xx_stop_feed(struct dvb_demux_feed *feed)
 /* ------------------------------------------------------------------ */
 static int em28xx_dvb_bus_ctrl(struct dvb_frontend *fe, int acquire)
 {
-	struct em28xx *dev = fe->dvb->priv;
+	struct em28xx_i2c_bus *i2c_bus = fe->dvb->priv;
+	struct em28xx *dev = i2c_bus->dev;
 
 	if (acquire)
 		return em28xx_set_mode(dev, EM28XX_DIGITAL_MODE);
@@ -670,7 +671,8 @@ static void pctv_520e_init(struct em28xx *dev)
 static int em28xx_pctv_290e_set_lna(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	struct em28xx *dev = fe->dvb->priv;
+	struct em28xx_i2c_bus *i2c_bus = fe->dvb->priv;
+	struct em28xx *dev = i2c_bus->dev;
 #ifdef CONFIG_GPIOLIB
 	struct em28xx_dvb *dvb = dev->dvb;
 	int ret;
@@ -839,7 +841,7 @@ static int em28xx_register_dvb(struct em28xx_dvb *dvb, struct module *module,
 	if (dvb->fe[1])
 		dvb->fe[1]->ops.ts_bus_ctrl = em28xx_dvb_bus_ctrl;
 
-	dvb->adapter.priv = dev;
+	dvb->adapter.priv = &dev->i2c_bus[def_i2c_bus];
 
 	/* register frontend */
 	result = dvb_register_frontend(&dvb->adapter, dvb->fe[0]);
