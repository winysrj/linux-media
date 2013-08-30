Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:41647 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753655Ab3H3T2A (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Aug 2013 15:28:00 -0400
Message-ID: <5220F212.9030108@iki.fi>
Date: Fri, 30 Aug 2013 22:27:14 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	LMML <linux-media@vger.kernel.org>
CC: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
Subject: em28xx lock debug *** DEADLOCK ***
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,
I was thinking you already fixed that one, but I just meet it with 
latest media tree 3.11.0-rc2+ when I unplugged device ?

regards
Antti

[ 1464.238906] usb 2-2: USB disconnect, device number 2
[ 1464.242123] em28178 #0: disconnecting em28178 #0 video
[ 1464.242254]
[ 1464.242261] ======================================================
[ 1464.242265] [ INFO: possible circular locking dependency detected ]
[ 1464.242272] 3.11.0-rc2+ #61 Tainted: G         C O
[ 1464.242277] -------------------------------------------------------
[ 1464.242283] khubd/46 is trying to acquire lock:
[ 1464.242288]  (em28xx_devlist_mutex){+.+.+.}, at: [<ffffffffa04b1c8d>] 
em28xx_close_extension+0x1d/0x70 [em28xx]
[ 1464.242316]
[ 1464.242316] but task is already holding lock:
[ 1464.242322]  (&dev->lock){+.+.+.}, at: [<ffffffffa04af7a9>] 
em28xx_usb_disconnect+0x99/0x140 [em28xx]
[ 1464.242342]
[ 1464.242342] which lock already depends on the new lock.
[ 1464.242342]
[ 1464.242349]
[ 1464.242349] the existing dependency chain (in reverse order) is:
[ 1464.242354]
[ 1464.242354] -> #1 (&dev->lock){+.+.+.}:
[ 1464.242365]        [<ffffffff810c27be>] lock_acquire+0x8e/0x130
[ 1464.242376]        [<ffffffff8168dc25>] mutex_lock_nested+0x85/0x390
[ 1464.242386]        [<ffffffffa050c659>] em28xx_dvb_init+0x79/0x1c60 
[em28xx_dvb]
[ 1464.242396]        [<ffffffffa04afa68>] 
em28xx_register_extension+0x58/0xa0 [em28xx]
[ 1464.242410]        [<ffffffffa0514010>] 0xffffffffa0514010
[ 1464.242429]        [<ffffffff810002fa>] do_one_initcall+0xfa/0x1b0
[ 1464.242439]        [<ffffffff810d1166>] load_module+0x1de6/0x2760
[ 1464.242447]        [<ffffffff810d1bb7>] SyS_init_module+0xd7/0x120
[ 1464.242455]        [<ffffffff8169c5d4>] tracesys+0xdd/0xe2
[ 1464.242465]
[ 1464.242465] -> #0 (em28xx_devlist_mutex){+.+.+.}:
[ 1464.242475]        [<ffffffff810c2060>] __lock_acquire+0x1db0/0x1ea0
[ 1464.242483]        [<ffffffff810c27be>] lock_acquire+0x8e/0x130
[ 1464.242490]        [<ffffffff8168dc25>] mutex_lock_nested+0x85/0x390
[ 1464.242498]        [<ffffffffa04b1c8d>] 
em28xx_close_extension+0x1d/0x70 [em28xx]
[ 1464.242513]        [<ffffffffa04af7c3>] 
em28xx_usb_disconnect+0xb3/0x140 [em28xx]
[ 1464.242525]        [<ffffffff814939e3>] usb_unbind_interface+0x63/0x1b0
[ 1464.242536]        [<ffffffff814035af>] __device_release_driver+0x7f/0xf0
[ 1464.242545]        [<ffffffff8140390e>] device_release_driver+0x2e/0x40
[ 1464.242554]        [<ffffffff81403040>] bus_remove_device+0x110/0x190
[ 1464.242563]        [<ffffffff813ffefd>] device_del+0x13d/0x1d0
[ 1464.242570]        [<ffffffff814912e0>] usb_disable_device+0xb0/0x270
[ 1464.242579]        [<ffffffff81487655>] usb_disconnect+0xb5/0x1d0
[ 1464.242589]        [<ffffffff81488e69>] 
hub_port_connect_change+0xc9/0xad0
[ 1464.242598]        [<ffffffff81489b68>] hub_events+0x2f8/0x940
[ 1464.242607]        [<ffffffff8148a1e5>] hub_thread+0x35/0x190
[ 1464.242616]        [<ffffffff8107f99d>] kthread+0xed/0x100
[ 1464.242625]        [<ffffffff8169c31c>] ret_from_fork+0x7c/0xb0
[ 1464.242635]
[ 1464.242635] other info that might help us debug this:
[ 1464.242635]
[ 1464.242642]  Possible unsafe locking scenario:
[ 1464.242642]
[ 1464.242647]        CPU0                    CPU1
[ 1464.242651]        ----                    ----
[ 1464.242655]   lock(&dev->lock);
[ 1464.242663]                                lock(em28xx_devlist_mutex);
[ 1464.242669]                                lock(&dev->lock);
[ 1464.242676]   lock(em28xx_devlist_mutex);
[ 1464.242683]
[ 1464.242683]  *** DEADLOCK ***
[ 1464.242683]
[ 1464.242691] 4 locks held by khubd/46:
[ 1464.242695]  #0:  (&__lockdep_no_validate__){......}, at: 
[<ffffffff81489924>] hub_events+0xb4/0x940
[ 1464.242713]  #1:  (&__lockdep_no_validate__){......}, at: 
[<ffffffff81487606>] usb_disconnect+0x66/0x1d0
[ 1464.242730]  #2:  (&__lockdep_no_validate__){......}, at: 
[<ffffffff81403906>] device_release_driver+0x26/0x40
[ 1464.242746]  #3:  (&dev->lock){+.+.+.}, at: [<ffffffffa04af7a9>] 
em28xx_usb_disconnect+0x99/0x140 [em28xx]
[ 1464.242767]
[ 1464.242767] stack backtrace:
[ 1464.242777] CPU: 3 PID: 46 Comm: khubd Tainted: G         C O 
3.11.0-rc2+ #61
[ 1464.242783] Hardware name: System manufacturer System Product 
Name/M5A78L-M/USB3, BIOS 1503    11/14/2012
[ 1464.242788]  ffffffff8227a650 ffff88030dbf7858 ffffffff8168a207 
0000000000000007
[ 1464.242800]  ffffffff8227a650 ffff88030dbf78a8 ffffffff81684141 
ffff88030dbd2bc8
[ 1464.242811]  ffff88030dbf7938 ffff88030dbf78a8 ffff88030dbd2b90 
0af05782bc9fa503
[ 1464.242823] Call Trace:
[ 1464.242836]  [<ffffffff8168a207>] dump_stack+0x55/0x76
[ 1464.242846]  [<ffffffff81684141>] print_circular_bug+0x1fb/0x20c
[ 1464.242857]  [<ffffffff810c2060>] __lock_acquire+0x1db0/0x1ea0
[ 1464.242866]  [<ffffffff810c06e0>] ? __lock_acquire+0x430/0x1ea0
[ 1464.242878]  [<ffffffff81693500>] ? _raw_spin_unlock_irq+0x30/0x50
[ 1464.242887]  [<ffffffff810c27be>] lock_acquire+0x8e/0x130
[ 1464.242902]  [<ffffffffa04b1c8d>] ? em28xx_close_extension+0x1d/0x70 
[em28xx]
[ 1464.242911]  [<ffffffff810be94b>] ? mark_held_locks+0xbb/0x140
[ 1464.242920]  [<ffffffff8168de5b>] ? mutex_lock_nested+0x2bb/0x390
[ 1464.242928]  [<ffffffff8168dc25>] mutex_lock_nested+0x85/0x390
[ 1464.242943]  [<ffffffffa04b1c8d>] ? em28xx_close_extension+0x1d/0x70 
[em28xx]
[ 1464.242957]  [<ffffffffa04b1c8d>] ? em28xx_close_extension+0x1d/0x70 
[em28xx]
[ 1464.242971]  [<ffffffffa04af7a9>] ? em28xx_usb_disconnect+0x99/0x140 
[em28xx]
[ 1464.242985]  [<ffffffffa04b1c8d>] em28xx_close_extension+0x1d/0x70 
[em28xx]
[ 1464.242999]  [<ffffffffa04af7c3>] em28xx_usb_disconnect+0xb3/0x140 
[em28xx]
[ 1464.243009]  [<ffffffff814939e3>] usb_unbind_interface+0x63/0x1b0
[ 1464.243018]  [<ffffffff814035af>] __device_release_driver+0x7f/0xf0
[ 1464.243027]  [<ffffffff8140390e>] device_release_driver+0x2e/0x40
[ 1464.243036]  [<ffffffff81403040>] bus_remove_device+0x110/0x190
[ 1464.243044]  [<ffffffff813ffefd>] device_del+0x13d/0x1d0
[ 1464.243052]  [<ffffffff814912e0>] usb_disable_device+0xb0/0x270
[ 1464.243062]  [<ffffffff8119abd5>] ? kfree+0xa5/0x1d0
[ 1464.243072]  [<ffffffff81487655>] usb_disconnect+0xb5/0x1d0
[ 1464.243082]  [<ffffffff81488e69>] hub_port_connect_change+0xc9/0xad0
[ 1464.243090]  [<ffffffff81490906>] ? usb_control_msg+0xe6/0x120
[ 1464.243100]  [<ffffffff81489b68>] hub_events+0x2f8/0x940
[ 1464.243110]  [<ffffffff8148a1e5>] hub_thread+0x35/0x190
[ 1464.243118]  [<ffffffff8107fed0>] ? wake_up_bit+0x40/0x40
[ 1464.243128]  [<ffffffff8148a1b0>] ? hub_events+0x940/0x940
[ 1464.243136]  [<ffffffff8107f99d>] kthread+0xed/0x100
[ 1464.243147]  [<ffffffff8107f8b0>] ? kthread_create_on_node+0x160/0x160
[ 1464.243156]  [<ffffffff8169c31c>] ret_from_fork+0x7c/0xb0
[ 1464.243165]  [<ffffffff8107f8b0>] ? kthread_create_on_node+0x160/0x160
[ 1464.243214] em28178 #0: V4L2 device video0 deregistered
[ 1466.303859] Em28xx: Removed (Em28xx dvb Extension) extension


-- 
http://palosaari.fi/
