Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f173.google.com ([209.85.215.173]:32983 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934382Ab3DGWBL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Apr 2013 18:01:11 -0400
Received: by mail-ea0-f173.google.com with SMTP id k11so2067433eaj.32
        for <linux-media@vger.kernel.org>; Sun, 07 Apr 2013 15:01:10 -0700 (PDT)
Message-ID: <5161ECE7.1060808@googlemail.com>
Date: Mon, 08 Apr 2013 00:02:15 +0200
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: em28xx: kernel oops in em28xx_tuner_callback() when watching
 digital TV
References: <515EF7CF.4060107@googlemail.com> <201304060838.42052.hverkuil@xs4all.nl>
In-Reply-To: <201304060838.42052.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 06.04.2013 08:38, schrieb Hans Verkuil:
> On Fri April 5 2013 18:11:59 Frank Schäfer wrote:
>> Mauro, Hans,
>> with the latest media-tree, I'm getting the following kernel oops when
>> starting to watch digital TV with em28xx devices:
>>
>> [  124.297707] BUG: unable to handle kernel paging request at 38326f3d
>> [  124.297770] IP: [<f8bf1026>] em28xx_tuner_callback+0x6/0x40 [em28xx]
>> [  124.297825] *pdpt = 0000000034dd5001 *pde = 0000000000000000
>> [  124.297870] Oops: 0000 [#1] PREEMPT SMP
>> [  124.297904] Modules linked in: em28xx_rc zl10353 em28xx_dvb dvb_core
>> tuner_xc2028 tvp5150 em28xx [...]
>> [  124.298010] Pid: 2165, comm: kdvb-ad-0-fe-0 Not tainted
>> 3.9.0-rc5-0.1-desktop+ #11 System manufacturer System Product Name/M2N-VM DH
>> [  124.298010] EIP: 0060:[<f8bf1026>] EFLAGS: 00010246 CPU: 0
>> [  124.298010] EIP is at em28xx_tuner_callback+0x6/0x40 [em28xx]
>> [  124.298010] EAX: ef33f000 EBX: 38326d65 ECX: 00000000 EDX: 00000000
>> [  124.298010] ESI: ef2d2b50 EDI: ef2d2b00 EBP: ee90b998 ESP: ee90b994
>> [  124.298010]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
>> [  124.298010] CR0: 8005003b CR2: 38326f3d CR3: 362a0000 CR4: 000007f0
>> [  124.298010] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
>> [  124.298010] DR6: ffff0ff0 DR7: 00000400
>> [  124.298010] Process kdvb-ad-0-fe-0 (pid: 2165, ti=ee90a000
>> task=f1074f80 task.ti=ee90a000)
>> [  124.298010] Stack:
>> [  124.298010]  f8bf1020 ee90ba2c f8be1139 00000000 f71cb740 ee90b9b0
>> ee90b9cb 00000004
>> [  124.298010]  ef33f000 ee90b9d0 f8bf24e0 ee90b9cb 00000001 0033fa14
>> ee90ba98 ee90baa4
>> [  124.298010]  00000002 00000009 12980558 ee90ba96 00000216 00000000
>> 00000000 f5c07804
>> [  124.298010] Call Trace:
>> [  124.298010]  [<f8bf1020>] ? em28xx_i2c_unregister+0x30/0x30 [em28xx]
>> [  124.298010]  [<f8be1139>] check_firmware+0x159/0xcf0 [tuner_xc2028]
>> [  124.298010]  [<f8bf24e0>] ? em28xx_read_reg_req+0x20/0x30 [em28xx]
>> [  124.298010]  [<f8be1d2c>] generic_set_freq+0x5c/0x500 [tuner_xc2028]
>> [  124.298010]  [<c060b79d>] ? __i2c_transfer+0x4d/0x60
>> [  124.298010]  [<f8be2501>] xc2028_set_params+0x111/0xc10 [tuner_xc2028]
>> [  124.298010]  [<f94e9d88>] zl10353_set_parameters+0x578/0x6c0 [zl10353]
>> [  124.298010]  [<c026ee1d>] ? update_curr+0x12d/0x1f0
>> [  124.298010]  [<c0324123>] ? dma_pool_alloc+0x193/0x1e0
>> [  124.298010]  [<c026adcd>] ? cpuacct_charge+0x5d/0x70
>> [  124.298010]  [<f94a6db4>] dvb_frontend_swzigzag_autotune+0x144/0x2f0
>> [dvb_core]
>> [  124.298010]  [<c05cc8d4>] ? usb_alloc_urb+0x14/0x40
>> [  124.298010]  [<f94a79dd>] dvb_frontend_swzigzag+0x2ad/0x310 [dvb_core]
>> [  124.298010]  [<c026f371>] ? dequeue_entity+0x151/0x670
>> [  124.298010]  [<c026fd46>] ? dequeue_task_fair+0x366/0x6d0
>> [  124.298010]  [<c0266063>] ? update_rq_clock+0x33/0x160
>> [  124.298010]  [<c026c770>] ? __dequeue_entity+0x20/0x40
>> [  124.298010]  [<c0201bb3>] ? __switch_to+0xc3/0x380
>> [  124.298010]  [<c0263712>] ? finish_task_switch+0x42/0xa0
>> [  124.298010]  [<c073ac3c>] ? __schedule+0x34c/0x780
>> [  124.298010]  [<c027067c>] ? check_preempt_wakeup+0x13c/0x250
>> [  124.298010]  [<c0247af4>] ? lock_timer_base.isra.37+0x24/0x50
>> [  124.298010]  [<c02486bd>] ? try_to_del_timer_sync+0x3d/0x50
>> [  124.298010]  [<c0248711>] ? del_timer_sync+0x41/0x50
>> [  124.298010]  [<c0739299>] ? schedule_timeout+0x129/0x270
>> [  124.298010]  [<c02473d0>] ? usleep_range+0x40/0x40
>> [  124.298010]  [<c025debb>] ? down_interruptible+0x2b/0x50
>> [  124.298010]  [<f94a98ef>] dvb_frontend_thread+0x35f/0x6b0 [dvb_core]
>> [  124.298010]  [<c0268e2b>] ? default_wake_function+0xb/0x10
>> [  124.298010]  [<c0259340>] ? finish_wait+0x60/0x60
>> [  124.298010]  [<f94a9590>] ? dvb_register_frontend+0x180/0x180 [dvb_core]
>> [  124.298010]  [<c0258cef>] kthread+0x8f/0xa0
>> [  124.298010]  [<c0260000>] ? sys_setgroups+0x90/0x100
>> [  124.298010]  [<c0742377>] ret_from_kernel_thread+0x1b/0x28
>> [  124.298010]  [<c0258c60>] ? kthread_create_on_node+0xc0/0xc0
>> [  124.298010] Code: 55 89 e5 8d 84 10 e4 01 00 00 e8 36 c0 a1 c7 31 c0
>> 5d c3 66 90 b8 ed ff ff ff c3 90 90 90 90 90 90 90 90 90 90 55 89 e5 53
>> 8b 18 <8b> 93 d8 01 00 00 83 fa 4c 75 1f 31 c0 85 c9 74 09 5b 5d c3 8d
>> [  124.298010] EIP: [<f8bf1026>] em28xx_tuner_callback+0x6/0x40 [em28xx]
>> SS:ESP 0068:ee90b994
>> [  124.298010] CR2: 0000000038326f3d
>> [  124.348464] ---[ end trace 2877a1eb744b8796 ]---
>>
>>
>> I don't have time to debug this further this evening+weekend, but I
>> assume the recent i2c bus changes from Mauro and/or commit bc3d2928
>> (Hans fix for em28xx_tuner_callback() ) are involved.
>> Could you please take a look at it this ?
> Yes, that's a correct assumption. It turns out that for dvb the priv pointer
> wasn't updated. The whole tuner core code is one big inpenetrable mess :-(
>
> Can you try the patch below and let me know if that works?
>
> Thanks,
>
> 	Hans
>
>
> diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
> index 42a6a26..aacab3b 100644
> --- a/drivers/media/usb/em28xx/em28xx-dvb.c
> +++ b/drivers/media/usb/em28xx/em28xx-dvb.c
> @@ -268,7 +268,8 @@ static int em28xx_stop_feed(struct dvb_demux_feed *feed)
>  /* ------------------------------------------------------------------ */
>  static int em28xx_dvb_bus_ctrl(struct dvb_frontend *fe, int acquire)
>  {
> -	struct em28xx *dev = fe->dvb->priv;
> +	struct em28xx_i2c_bus *i2c_bus = fe->dvb->priv;
> +	struct em28xx *dev = i2c_bus->dev;
>  
>  	if (acquire)
>  		return em28xx_set_mode(dev, EM28XX_DIGITAL_MODE);
> @@ -670,7 +671,8 @@ static void pctv_520e_init(struct em28xx *dev)
>  static int em28xx_pctv_290e_set_lna(struct dvb_frontend *fe)
>  {
>  	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
> -	struct em28xx *dev = fe->dvb->priv;
> +	struct em28xx_i2c_bus *i2c_bus = fe->dvb->priv;
> +	struct em28xx *dev = i2c_bus->dev;
>  #ifdef CONFIG_GPIOLIB
>  	struct em28xx_dvb *dvb = dev->dvb;
>  	int ret;
> @@ -839,7 +841,7 @@ static int em28xx_register_dvb(struct em28xx_dvb *dvb, struct module *module,
>  	if (dvb->fe[1])
>  		dvb->fe[1]->ops.ts_bus_ctrl = em28xx_dvb_bus_ctrl;
>  
> -	dvb->adapter.priv = dev;
> +	dvb->adapter.priv = &dev->i2c_bus[def_i2c_bus];
>  
>  	/* register frontend */
>  	result = dvb_register_frontend(&dvb->adapter, dvb->fe[0]);

Hi Hans,
thank you for looking at this issue and sorry for the delayed reply.
I've tested the patch with my HVR-900 and VLC:
The oops in em28xx_tuner_callback() is gone, but now I'm getting the
following one:

[  149.976305] BUG: unable to handle kernel paging request at 20200a72
[  149.976366] IP: [<c05cf4de>] usb_set_interface+0xe/0x360
[  149.976412] *pdpt = 000000001e50f001 *pde = 0000000000000000
[  149.976458] Oops: 0000 [#1] PREEMPT SMP
[  149.976491] Modules linked in: em28xx_rc zl10353 em28xx_dvb dvb_core
tuner_xc2028 tvp5150 em28xx videobuf2_core [...]
[  149.977015] Pid: 2209, comm: vlc Not tainted 3.9.0-rc5-0.1-desktop+
#12 System manufacturer System Product Name/M2N-VM DH
[  149.977015] EIP: 0060:[<c05cf4de>] EFLAGS: 00210286 CPU: 1
[  149.977015] EIP is at usb_set_interface+0xe/0x360
[  149.977015] EAX: 20200a3e EBX: 00000001 ECX: 73696e69 EDX: 00000000
[  149.977015] ESI: ef362008 EDI: 20200a3e EBP: dea97d84 ESP: dea97d50
[  149.977015]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[  149.977015] CR0: 8005003b CR2: 20200a72 CR3: 1e510000 CR4: 000007f0
[  149.977015] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  149.977015] DR6: ffff0ff0 DR7: 00000400
[  149.977015] Process vlc (pid: 2209, ti=dea96000 task=ef98a430
task.ti=dea96000)
[  149.977015] Stack:
[  149.977015]  80000000 f8ac7000 00000163 dea97dac f8ac7000 ef269e40
dea97d88 c031d775
[  149.977015]  00000163 80000000 00000001 ef362008 ef1bc8ec dea97db4
f8ba7e52 f8c3412b
[  149.977015]  dea97dac ff1fe000 ffffffff 000000d2 00000040 22646568
f9532000 ef362068
[  149.977015] Call Trace:
[  149.977015]  [<c031d775>] ? map_vm_area+0x35/0x50
[  149.977015]  [<f8ba7e52>] em28xx_start_feed+0x92/0x170 [em28xx_dvb]
[  149.977015]  [<f8c3412b>] ? dvb_demux_feed_add+0xbb/0xd0 [dvb_core]
[  149.977015]  [<f8c33c7e>] dmx_ts_feed_start_filtering+0x4e/0xe0
[dvb_core]
[  149.977015]  [<f8c31ea0>] dvb_dmxdev_start_feed.isra.0+0xa0/0xf0
[dvb_core]
[  149.977015]  [<f8c32b4a>] dvb_dmxdev_filter_start+0x8a/0x380 [dvb_core]
[  149.977015]  [<f8c33294>] dvb_demux_do_ioctl+0x344/0x550 [dvb_core]
[  149.977015]  [<c034716a>] ? do_last+0x22a/0xc00
[  149.977015]  [<c03446b1>] ? inode_permission+0x11/0x50
[  149.977015]  [<f8c31830>] dvb_usercopy+0x50/0x130 [dvb_core]
[  149.977015]  [<c0347bff>] ? path_openat+0xbf/0x3b0
[  149.977015]  [<c0311a8a>] ? handle_pte_fault+0x8a/0x5b0
[  149.977015]  [<c03480dc>] ? do_filp_open+0x2c/0x80
[  149.977015]  [<f8c31c70>] ? dvb_dvr_ioctl+0x20/0x20 [dvb_core]
[  149.977015]  [<f8c31c82>] dvb_demux_ioctl+0x12/0x20 [dvb_core]
[  149.977015]  [<f8c32f50>] ? dvb_demux_open+0x110/0x110 [dvb_core]
[  149.977015]  [<c0349ff2>] do_vfs_ioctl+0x72/0x570
[  149.977015]  [<c0344438>] ? final_putname+0x18/0x40
[  149.977015]  [<c03534a1>] ? set_close_on_exec+0x41/0x60
[  149.977015]  [<c03490d3>] ? do_fcntl+0x263/0x3e0
[  149.977015]  [<c03526ff>] ? fget_light+0x3f/0xe0
[  149.977015]  [<c034a553>] sys_ioctl+0x63/0x70
[  149.977015]  [<c07431c6>] sysenter_do_call+0x12/0x28
[  149.977015] Code: 00 c7 45 f0 f4 ff ff ff eb c3 c7 45 f0 8f ff ff ff
eb ba 8d 76 00 8d bc 27 00 00 00 00 55 89 e5 57 89 c7 56 53 83 e4 f8 83
ec 28 <8b> 40 34 83 7f 18 08 89 54 24 1c 89 4c 24 18 89 44 24 24 0f 84
[  149.977015] EIP: [<c05cf4de>] usb_set_interface+0xe/0x360 SS:ESP
0068:dea97d50
[  149.977015] CR2: 0000000020200a72
[  150.011424] ---[ end trace 4b92ff17d399e815 ]---


In em28xx_start_streaming() and also em28xx_stop_streaming() we do

     struct em28xx *dev = dvb->adapter.priv;

which I would say should be the culprit.
Are you sure that dvb->adapter.priv needs to be assigned to i2c_bus
instead of dev ?
Anyway, I modified both functions to obtain the right pointer to dev,
but this caused another oops.
I also tested without changing dvb->adapter.priv: oops :-/

Regards,
Frank



