Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:56937 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752997AbcCBK7b (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Mar 2016 05:59:31 -0500
Date: Wed, 2 Mar 2016 07:59:26 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Heiner Kallweit <hkallweit1@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Problem since commit c73bbaa4ec3e [rc-core: don't lock device
 at rc_register_device()]
Message-ID: <20160302075926.4d2d8d79@recife.lan>
In-Reply-To: <56D21840.6080000@gmail.com>
References: <56D19314.3050409@gmail.com>
	<56D1CA81.10802@gmail.com>
	<20160227150524.7d8d6fbb@recife.lan>
	<56D1ED54.9080503@gmail.com>
	<20160227165014.11b66f37@recife.lan>
	<56D21840.6080000@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 27 Feb 2016 22:42:24 +0100
Heiner Kallweit <hkallweit1@gmail.com> escreveu:

> Am 27.02.2016 um 20:50 schrieb Mauro Carvalho Chehab:
> > Em Sat, 27 Feb 2016 19:39:16 +0100
> > Heiner Kallweit <hkallweit1@gmail.com> escreveu:
> >   
> >> Am 27.02.2016 um 19:05 schrieb Mauro Carvalho Chehab:  
> >>> Em Sat, 27 Feb 2016 17:10:41 +0100
> >>> Heiner Kallweit <hkallweit1@gmail.com> escreveu:
> >>>     
> >>>> Am 27.02.2016 um 13:14 schrieb Heiner Kallweit:    
> >>>>> Since this commit I see the following error when the Nuvoton RC driver is loaded:
> >>>>>
> >>>>> input: failed to attach handler kbd to device input3, error: -22
> >>>>>
> >>>>> Error 22 (EINVAL) comes from the new check in rc_open().
> >>>>>       
> >>>>
> >>>> Complete call chain seems to be:
> >>>>   rc_register_device
> >>>>   input_register_device
> >>>>   input_attach_handler
> >>>>   kbd_connect
> >>>>   input_open_device
> >>>>   ir_open
> >>>>   rc_open
> >>>>
> >>>> rc_register_device calls input_register_device before dev->initialized = true,
> >>>> therefore the new check in rc_open fails. At a first glance I'd say that we have
> >>>> to remove this check from rc_open.    
> >>>
> >>> Hmm... maybe we could, instead, do:
> >>>
> >>> 	if (!rdev->initialized) {
> >>> 		rval = -ERESTARTSYS;
> >>> 		goto unlock;
> >>> 	}
> >>>     
> >> Looking at the source code of the functions in the call chain I see no special
> >> handling of ERESTARTSYS. It's treated like any other error, therefore I don't
> >> think this helps.  
> > 
> > The expected behavior is that the Kernel syscall code to handle ERESTARTSYS
> > internally, and either return EAGAIN to userspace, or try again until
> > it succeeds, depending on the open mode.
> >   
> I tested it and returning ERESTARTSYS instead of EINVAL doesn't help.
> The behavior is the same.
> As far as I can see no syscall code is involved in this call chain.
> 
> > So, it seems a worth trial.

Yeah, this didn't work. The problem is that rc_open can be called too
early, by the time the input device got registered.

I have a patch for it. Will send on a separate e-mail

Yet, there's something still not right: after removing nuvoton_cir, 
a new modprobe to the driver causes a dead lock:

[  242.151822] INFO: task modprobe:2599 blocked for more than 120 seconds.
[  242.151952]       Not tainted 4.5.0-rc3+ #49
[  242.151955] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  242.151958] modprobe        D ffff8803b1037610     0  2599   2598 0x00000000
[  242.151964]  ffff8803b1037610 ffffffff82aa27f8 ffff8803b10375c8 ffffffff812404fa
[  242.151970]  0000000000000282 ffff8803bf076340 ffff8803c689f258 ffffffff00000000
[  242.151975]  ffff8803c2198000 ffff8803bf076000 ffff8803b1030000 ffffed0076206001
[  242.151981] Call Trace:
[  242.151988]  [<ffffffff812404fa>] ? trace_hardirqs_on_caller+0x40a/0x590
[  242.151992]  [<ffffffff822dc6dc>] schedule+0x9c/0x1c0
[  242.151996]  [<ffffffff8115fd02>] __request_region+0x2c2/0x440
[  242.152002]  [<ffffffff8115fa40>] ? free_resource+0x180/0x180
[  242.152005]  [<ffffffff812f6eb5>] ? is_module_address+0x15/0x30
[  242.152009]  [<ffffffff812381d3>] ? static_obj+0x33/0x50
[  242.152012]  [<ffffffff81239680>] ? lockdep_init_map+0xf0/0x1470
[  242.152016]  [<ffffffff811d3980>] ? wake_up_q+0xe0/0xe0
[  242.152023]  [<ffffffffa125a4c8>] nvt_probe+0x518/0x26a0 [nuvoton_cir]
[  242.152031]  [<ffffffff81b913a0>] ? compare_pnp_id+0x90/0x210
[  242.152041]  [<ffffffffa1259fb0>] ? nvt_tx_ir+0x3f0/0x3f0 [nuvoton_cir]
[  242.152047]  [<ffffffff81b91735>] pnp_device_probe+0x125/0x1f0
[  242.152054]  [<ffffffff81ce7e7a>] driver_probe_device+0x21a/0xc30
[  242.152060]  [<ffffffff81ce8890>] ? driver_probe_device+0xc30/0xc30
[  242.152066]  [<ffffffff81ce89b1>] __driver_attach+0x121/0x160
[  242.152072]  [<ffffffff81ce21bf>] bus_for_each_dev+0x11f/0x1a0
[  242.152077]  [<ffffffff81ce20a0>] ? subsys_dev_iter_exit+0x10/0x10
[  242.152083]  [<ffffffff822e7be7>] ? _raw_spin_unlock+0x27/0x40
[  242.152089]  [<ffffffff81ce6cdd>] driver_attach+0x3d/0x50
[  242.152095]  [<ffffffff81ce5df9>] bus_add_driver+0x4c9/0x770
[  242.152101]  [<ffffffffa0cd0000>] ? 0xffffffffa0cd0000
[  242.152107]  [<ffffffffa0cd0000>] ? 0xffffffffa0cd0000
[  242.152112]  [<ffffffff81cea39c>] driver_register+0x18c/0x3b0
[  242.152119]  [<ffffffff81b912c5>] pnp_register_driver+0x75/0xa0
[  242.152126]  [<ffffffffa0cd0010>] nvt_driver_init+0x10/0x1000 [nuvoton_cir]
[  242.152132]  [<ffffffff810021b1>] do_one_initcall+0x141/0x300
[  242.152138]  [<ffffffff81002070>] ? try_to_run_init_process+0x40/0x40
[  242.152145]  [<ffffffff8155f696>] ? kasan_unpoison_shadow+0x36/0x50
[  242.152150]  [<ffffffff8155f696>] ? kasan_unpoison_shadow+0x36/0x50
[  242.152156]  [<ffffffff8155f7a7>] ? __asan_register_globals+0x87/0xa0
[  242.152164]  [<ffffffff8144d8eb>] do_init_module+0x1d0/0x5ad
[  242.152170]  [<ffffffff812f27b6>] load_module+0x6666/0x9ba0
[  242.152177]  [<ffffffff812e9e20>] ? symbol_put_addr+0x50/0x50
[  242.152191]  [<ffffffff812ec150>] ? module_frob_arch_sections+0x20/0x20
[  242.152197]  [<ffffffff815be010>] ? open_exec+0x50/0x50
[  242.152204]  [<ffffffff8116716b>] ? ns_capable+0x5b/0xd0
[  242.152210]  [<ffffffff812f5fe8>] SyS_finit_module+0x108/0x130
[  242.152215]  [<ffffffff812f5ee0>] ? SyS_init_module+0x1f0/0x1f0
[  242.152221]  [<ffffffff81004044>] ? lockdep_sys_exit_thunk+0x12/0x14
[  242.152228]  [<ffffffff822e8636>] entry_SYSCALL_64_fastpath+0x16/0x76
[  242.152233] 2 locks held by modprobe/2599:
[  242.152237]  #0:  (&dev->mutex){......}, at: [<ffffffff81ce8933>] __driver_attach+0xa3/0x160
[  242.152252]  #1:  (&dev->mutex){......}, at: [<ffffffff81ce8941>] __driver_attach+0xb1/0x160



