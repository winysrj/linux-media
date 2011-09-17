Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:51709 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753334Ab1IQTI7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Sep 2011 15:08:59 -0400
Subject: Re: Lockdep warning in ivtv driver in 3.1
From: Andy Walls <awalls@md.metrocast.net>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org
Date: Sat, 17 Sep 2011 15:09:33 -0400
In-Reply-To: <20110822182410.GH2270@zod.bos.redhat.com>
References: <20110822182410.GH2270@zod.bos.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1316286574.2253.23.camel@palomino.walls.org>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2011-08-22 at 14:24 -0400, Josh Boyer wrote:
> Hi All,
> 
> We've gotten a report[1] that the ivtv driver is throwing a lockdep
> warning when calling ivtv_gpio_init.  From what I can tell, it seems
> like the lock being held twice is the one allocated for ivtv->cxhdl, but
> I can't immediately see where it's locked and not unlocked in the
> callstack path.
>
> Does anyone have an idea where this could be happening?

Yes, I do.  Right here:

http://git.linuxtv.org/media_tree.git/blob/refs/heads/staging/for_v3.2:/drivers/media/video/v4l2-ctrls.c#l1120

But it is almost certainly a false positive because of the way the mutex
is initialized in the body of a helper function used by many drivers:

http://git.linuxtv.org/media_tree.git/blob/refs/heads/staging/for_v3.2:/drivers/media/video/v4l2-ctrls.c#l1099

So there is no way for lockdep to distinguish between a control handler
lock in the bridge driver vs. one of the subdevices under the bridge
driver's control.

The mutex should really be initialized in a macro or inline function.
Say like in this patch:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg26097.html
http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/27027

See if it still applies and solves your problem.

Further reading:
Comments 11-13 of this ivtv bugzilla report:
https://bugzilla.redhat.com/show_bug.cgi?id=662384

This post by me:
http://www.mail-archive.com/linux-media@vger.kernel.org/msg33565.html


Honestly I wish all mutexes and spinlocks were initalized with such
descriptive names as my patch sets up for the control handler mutex.  It
would make the output of lockdep a lot easier to follow.

Regards,
Andy W.

> [   28.556610] =============================================
> [   28.557007] [ INFO: possible recursive locking detected ]
> [   28.557007] 3.1.0-0.rc0.git19.1.fc17.x86_64 #1
> [   28.557007] ---------------------------------------------
> [   28.557007] modprobe/684 is trying to acquire lock:
> [   28.557007]  (&hdl->lock){+.+...}, at: [<ffffffffa02919ba>]
> find_ref_lock+0x24/0x46 [videodev]
> [   28.557007] 
> [   28.557007] but task is already holding lock:
> [   28.557007]  (&hdl->lock){+.+...}, at: [<ffffffffa029380f>]
> v4l2_ctrl_add_handler+0x49/0x97 [videodev]
> [   28.557007] 
> [   28.557007] other info that might help us debug this:
> [   28.557007]  Possible unsafe locking scenario:
> [   28.557007] 
> [   28.557007]        CPU0
> [   28.557007]        ----
> [   28.557007]   lock(&hdl->lock);
> [   28.557007]   lock(&hdl->lock);
> [   28.557007] 
> [   28.557007]  *** DEADLOCK ***
> [   28.557007] 
> [   28.557007]  May be due to missing lock nesting notation
> [   28.557007] 
> [   28.557007] 3 locks held by modprobe/684:
> [   28.557007]  #0:  (&__lockdep_no_validate__){......}, at:
> [<ffffffff81314d0c>] __driver_attach+0x3b/0x82
> [   28.557007]  #1:  (&__lockdep_no_validate__){......}, at:
> [<ffffffff81314d1a>] __driver_attach+0x49/0x82
> [   28.557007]  #2:  (&hdl->lock){+.+...}, at: [<ffffffffa029380f>]
> v4l2_ctrl_add_handler+0x49/0x97 [videodev]
> [   28.557007] 
> [   28.557007] stack backtrace:
> [   28.557007] Pid: 684, comm: modprobe Not tainted
> 3.1.0-0.rc0.git19.1.fc17.x86_64 #1
> [   28.557007] Call Trace:
> [   28.557007]  [<ffffffff8108eb06>] __lock_acquire+0x917/0xcf7
> [   28.557007]  [<ffffffff81014fbe>] ? sched_clock+0x9/0xd
> [   28.557007]  [<ffffffff8108dffc>] ? mark_lock+0x2d/0x220
> [   28.557007]  [<ffffffffa02919ba>] ? find_ref_lock+0x24/0x46 [videodev]
> [   28.557007]  [<ffffffff8108f3dc>] lock_acquire+0xf3/0x13e
> [   28.584886]  [<ffffffffa02919ba>] ? find_ref_lock+0x24/0x46 [videodev]
> [   28.585146]  [<ffffffffa02919ba>] ? find_ref_lock+0x24/0x46 [videodev]
> [   28.585146]  [<ffffffff814f2523>] __mutex_lock_common+0x5d/0x39a
> [   28.585146]  [<ffffffffa02919ba>] ? find_ref_lock+0x24/0x46 [videodev]
> [   28.585146]  [<ffffffff8108f6db>] ? mark_held_locks+0x6d/0x95
> [   28.585146]  [<ffffffff814f282f>] ? __mutex_lock_common+0x369/0x39a
> [   28.585146]  [<ffffffff8108f830>] ? trace_hardirqs_on_caller+0x12d/0x164
> [   28.585146]  [<ffffffff814f296f>] mutex_lock_nested+0x40/0x45
> [   28.585146]  [<ffffffffa02919ba>] find_ref_lock+0x24/0x46 [videodev]
> [   28.585146]  [<ffffffffa029367e>] handler_new_ref+0x42/0x18a [videodev]
> [   28.585146]  [<ffffffffa0293833>] v4l2_ctrl_add_handler+0x6d/0x97 [videodev]
> [   28.585146]  [<ffffffffa028f71b>] v4l2_device_register_subdev+0x16c/0x257
> [videodev]
> [   28.585146]  [<ffffffffa02ddfe9>] ivtv_gpio_init+0x14e/0x159 [ivtv]
> [   28.585146]  [<ffffffffa02ebd57>] ivtv_probe+0xdc4/0x1662 [ivtv]
> [   28.585146]  [<ffffffff8108f6c3>] ? mark_held_locks+0x55/0x95
> [   28.585146]  [<ffffffff814f41df>] ? _raw_spin_unlock_irqrestore+0x4d/0x61
> [   28.585146]  [<ffffffff8126a12b>] local_pci_probe+0x44/0x75
> [   28.585146]  [<ffffffff8126acb1>] pci_device_probe+0xd0/0xff
> [   28.585146]  [<ffffffff81314bef>] driver_probe_device+0x131/0x213
> [   28.585146]  [<ffffffff81314d2f>] __driver_attach+0x5e/0x82
> [   28.585146]  [<ffffffff81314cd1>] ? driver_probe_device+0x213/0x213
> [   28.585146]  [<ffffffff81313c30>] bus_for_each_dev+0x59/0x8f
> [   28.585146]  [<ffffffff813147c3>] driver_attach+0x1e/0x20
> [   28.585146]  [<ffffffff813143db>] bus_add_driver+0xd4/0x22a
> [   28.585146]  [<ffffffffa02ff000>] ? 0xffffffffa02fefff
> [   28.585146]  [<ffffffff813151f2>] driver_register+0x98/0x105
> [   28.618302]  [<ffffffffa02ff000>] ? 0xffffffffa02fefff
> [   28.618302]  [<ffffffff8126b584>] __pci_register_driver+0x66/0xd2
> [   28.618302]  [<ffffffffa02ff000>] ? 0xffffffffa02fefff
> [   28.618302]  [<ffffffffa02ff078>] module_start+0x78/0x1000 [ivtv]
> [   28.618302]  [<ffffffff81002099>] do_one_initcall+0x7f/0x13a
> [   28.618302]  [<ffffffffa02ff000>] ? 0xffffffffa02fefff
> [   28.618302]  [<ffffffff8109a864>] sys_init_module+0x114/0x267
> [   28.618302]  [<ffffffff814fafc2>] system_call_fastpath+0x16/0x1b
> 
> josh
> 
> [1] https://bugzilla.redhat.com/show_bug.cgi?id=728316


