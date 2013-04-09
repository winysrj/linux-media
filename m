Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37473 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935572Ab3DIVZX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Apr 2013 17:25:23 -0400
Received: from [82.128.187.254] (helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1UPg2b-0003hU-70
	for linux-media@vger.kernel.org; Wed, 10 Apr 2013 00:25:21 +0300
Message-ID: <5164871A.4030603@iki.fi>
Date: Wed, 10 Apr 2013 00:24:42 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: em28xx bug#1
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Any idea what are there bugs?


Apr 10 00:21:41 localhost kernel: [  355.292348] usb 2-2: USB 
disconnect, device number 2
Apr 10 00:21:41 localhost kernel: [  355.294357] em2874 #0: 
disconnecting em2874 #0 video
Apr 10 00:21:41 localhost kernel: [  355.294517]
Apr 10 00:21:41 localhost kernel: [  355.294523] 
======================================================
Apr 10 00:21:41 localhost kernel: [  355.294528] [ INFO: possible 
circular locking dependency detected ]
Apr 10 00:21:41 localhost kernel: [  355.294535] 3.9.0-rc5+ #39 Tainted: 
G           O
Apr 10 00:21:41 localhost kernel: [  355.294539] 
-------------------------------------------------------
Apr 10 00:21:41 localhost kernel: [  355.294544] khubd/34 is trying to 
acquire lock:
Apr 10 00:21:41 localhost kernel: [  355.294549] 
(em28xx_devlist_mutex){+.+.+.}, at: [<ffffffffa0471b7d>] 
em28xx_close_extension+0x1d/0x70 [em28xx]
Apr 10 00:21:41 localhost kernel: [  355.294576]
Apr 10 00:21:41 localhost kernel: [  355.294576] but task is already 
holding lock:
Apr 10 00:21:41 localhost kernel: [  355.294582]  (&dev->lock){+.+.+.}, 
at: [<ffffffffa046f719>] em28xx_usb_disconnect+0x99/0x140 [em28xx]
Apr 10 00:21:41 localhost kernel: [  355.294602]
Apr 10 00:21:41 localhost kernel: [  355.294602] which lock already 
depends on the new lock.
Apr 10 00:21:41 localhost kernel: [  355.294602]
Apr 10 00:21:41 localhost kernel: [  355.294609]
Apr 10 00:21:41 localhost kernel: [  355.294609] the existing dependency 
chain (in reverse order) is:
Apr 10 00:21:41 localhost kernel: [  355.294614]
Apr 10 00:21:41 localhost kernel: [  355.294614] -> #1 (&dev->lock){+.+.+.}:
Apr 10 00:21:41 localhost kernel: [  355.294624] 
[<ffffffff810c8821>] lock_acquire+0xa1/0x140
Apr 10 00:21:41 localhost kernel: [  355.294635] 
[<ffffffff8169f636>] mutex_lock_nested+0x76/0x390
Apr 10 00:21:41 localhost kernel: [  355.294645] 
[<ffffffffa048763c>] em28xx_dvb_init+0x7c/0x1a14 [em28xx_dvb]
Apr 10 00:21:41 localhost kernel: [  355.294655] 
[<ffffffffa046f9d8>] em28xx_register_extension+0x58/0xa0 [em28xx]
Apr 10 00:21:41 localhost kernel: [  355.294668] 
[<ffffffffa04b6010>] 0xffffffffa04b6010
Apr 10 00:21:41 localhost kernel: [  355.294684] 
[<ffffffff8100215a>] do_one_initcall+0x12a/0x180
Apr 10 00:21:41 localhost kernel: [  355.294692] 
[<ffffffff810d72e6>] load_module+0x1c36/0x27f0
Apr 10 00:21:41 localhost kernel: [  355.294700] 
[<ffffffff810d7f77>] sys_init_module+0xd7/0x120
Apr 10 00:21:41 localhost kernel: [  355.294707] 
[<ffffffff816acc99>] system_call_fastpath+0x16/0x1b
Apr 10 00:21:41 localhost kernel: [  355.294717]
Apr 10 00:21:41 localhost kernel: [  355.294717] -> #0 
(em28xx_devlist_mutex){+.+.+.}:
Apr 10 00:21:41 localhost kernel: [  355.294727] 
[<ffffffff810c80f8>] __lock_acquire+0x1c88/0x1d50
Apr 10 00:21:41 localhost kernel: [  355.294734] 
[<ffffffff810c8821>] lock_acquire+0xa1/0x140
Apr 10 00:21:41 localhost kernel: [  355.294741] 
[<ffffffff8169f636>] mutex_lock_nested+0x76/0x390
Apr 10 00:21:41 localhost kernel: [  355.294749] 
[<ffffffffa0471b7d>] em28xx_close_extension+0x1d/0x70 [em28xx]
Apr 10 00:21:41 localhost kernel: [  355.294762] 
[<ffffffffa046f733>] em28xx_usb_disconnect+0xb3/0x140 [em28xx]
Apr 10 00:21:41 localhost kernel: [  355.294775] 
[<ffffffff8149cbf3>] usb_unbind_interface+0x63/0x1b0
Apr 10 00:21:41 localhost kernel: [  355.294784] 
[<ffffffff814187ac>] __device_release_driver+0x7c/0xf0
Apr 10 00:21:41 localhost kernel: [  355.294791] 
[<ffffffff81418afe>] device_release_driver+0x2e/0x40
Apr 10 00:21:41 localhost kernel: [  355.294799] 
[<ffffffff81418222>] bus_remove_device+0x102/0x180
Apr 10 00:21:41 localhost kernel: [  355.294806] 
[<ffffffff8141557f>] device_del+0x12f/0x1c0
Apr 10 00:21:41 localhost kernel: [  355.294814] 
[<ffffffff8149a4f0>] usb_disable_device+0xb0/0x270
Apr 10 00:21:41 localhost kernel: [  355.294822] 
[<ffffffff814907e5>] usb_disconnect+0xb5/0x1d0
Apr 10 00:21:41 localhost kernel: [  355.294831] 
[<ffffffff81491fbd>] hub_port_connect_change+0xcd/0xab0
Apr 10 00:21:41 localhost kernel: [  355.294840] 
[<ffffffff81492ca0>] hub_events+0x300/0x920
Apr 10 00:21:41 localhost kernel: [  355.294848] 
[<ffffffff814932f5>] hub_thread+0x35/0x1f0
Apr 10 00:21:41 localhost kernel: [  355.294857] 
[<ffffffff81087d8d>] kthread+0xed/0x100
Apr 10 00:21:41 localhost kernel: [  355.294866] 
[<ffffffff816acbec>] ret_from_fork+0x7c/0xb0
Apr 10 00:21:41 localhost kernel: [  355.294874]
Apr 10 00:21:41 localhost kernel: [  355.294874] other info that might 
help us debug this:
Apr 10 00:21:41 localhost kernel: [  355.294874]
Apr 10 00:21:41 localhost kernel: [  355.294882]  Possible unsafe 
locking scenario:
Apr 10 00:21:41 localhost kernel: [  355.294882]
Apr 10 00:21:41 localhost kernel: [  355.294887]        CPU0 
         CPU1
Apr 10 00:21:41 localhost kernel: [  355.294890]        ---- 
         ----
Apr 10 00:21:41 localhost kernel: [  355.294894]   lock(&dev->lock);
Apr 10 00:21:41 localhost kernel: [  355.294900] 
         lock(em28xx_devlist_mutex);
Apr 10 00:21:41 localhost kernel: [  355.294907] 
         lock(&dev->lock);
Apr 10 00:21:41 localhost kernel: [  355.294912] 
lock(em28xx_devlist_mutex);
Apr 10 00:21:41 localhost kernel: [  355.294919]
Apr 10 00:21:41 localhost kernel: [  355.294919]  *** DEADLOCK ***
Apr 10 00:21:41 localhost kernel: [  355.294919]
Apr 10 00:21:41 localhost kernel: [  355.294926] 4 locks held by khubd/34:
Apr 10 00:21:41 localhost kernel: [  355.294930]  #0: 
(&__lockdep_no_validate__){......}, at: [<ffffffff81492a51>] 
hub_events+0xb1/0x920
Apr 10 00:21:41 localhost kernel: [  355.294945]  #1: 
(&__lockdep_no_validate__){......}, at: [<ffffffff81490796>] 
usb_disconnect+0x66/0x1d0
Apr 10 00:21:41 localhost kernel: [  355.294960]  #2: 
(&__lockdep_no_validate__){......}, at: [<ffffffff81418af6>] 
device_release_driver+0x26/0x40
Apr 10 00:21:41 localhost kernel: [  355.294974]  #3: 
(&dev->lock){+.+.+.}, at: [<ffffffffa046f719>] 
em28xx_usb_disconnect+0x99/0x140 [em28xx]
Apr 10 00:21:41 localhost kernel: [  355.294993]
Apr 10 00:21:41 localhost kernel: [  355.294993] stack backtrace:
Apr 10 00:21:41 localhost kernel: [  355.295000] Pid: 34, comm: khubd 
Tainted: G           O 3.9.0-rc5+ #39
Apr 10 00:21:41 localhost kernel: [  355.295005] Call Trace:
Apr 10 00:21:41 localhost kernel: [  355.295017]  [<ffffffff81695cb6>] 
print_circular_bug+0x1fb/0x20c
Apr 10 00:21:41 localhost kernel: [  355.295026]  [<ffffffff810c80f8>] 
__lock_acquire+0x1c88/0x1d50
Apr 10 00:21:41 localhost kernel: [  355.295035]  [<ffffffff810c688e>] ? 
__lock_acquire+0x41e/0x1d50
Apr 10 00:21:41 localhost kernel: [  355.295045]  [<ffffffff8101cc43>] ? 
native_sched_clock+0x13/0x80
Apr 10 00:21:41 localhost kernel: [  355.295055]  [<ffffffff816a3d30>] ? 
_raw_spin_unlock_irq+0x30/0x50
Apr 10 00:21:41 localhost kernel: [  355.295064]  [<ffffffff810c8821>] 
lock_acquire+0xa1/0x140
Apr 10 00:21:41 localhost kernel: [  355.295078]  [<ffffffffa0471b7d>] ? 
em28xx_close_extension+0x1d/0x70 [em28xx]
Apr 10 00:21:41 localhost kernel: [  355.295086]  [<ffffffff810c4ae2>] ? 
mark_held_locks+0xb2/0x130
Apr 10 00:21:41 localhost kernel: [  355.295095]  [<ffffffff8169f8a6>] ? 
mutex_lock_nested+0x2e6/0x390
Apr 10 00:21:41 localhost kernel: [  355.295105]  [<ffffffff8169f636>] 
mutex_lock_nested+0x76/0x390
Apr 10 00:21:41 localhost kernel: [  355.295118]  [<ffffffffa0471b7d>] ? 
em28xx_close_extension+0x1d/0x70 [em28xx]
Apr 10 00:21:41 localhost kernel: [  355.295127]  [<ffffffff8169f882>] ? 
mutex_lock_nested+0x2c2/0x390
Apr 10 00:21:41 localhost kernel: [  355.295140]  [<ffffffffa046f719>] ? 
em28xx_usb_disconnect+0x99/0x140 [em28xx]
Apr 10 00:21:41 localhost kernel: [  355.295153]  [<ffffffffa0471b7d>] ? 
em28xx_close_extension+0x1d/0x70 [em28xx]
Apr 10 00:21:41 localhost kernel: [  355.295167]  [<ffffffffa046f719>] ? 
em28xx_usb_disconnect+0x99/0x140 [em28xx]
Apr 10 00:21:41 localhost kernel: [  355.295175]  [<ffffffff81694cfe>] ? 
printk+0x61/0x63
Apr 10 00:21:41 localhost kernel: [  355.295188]  [<ffffffffa0471b7d>] 
em28xx_close_extension+0x1d/0x70 [em28xx]
Apr 10 00:21:41 localhost kernel: [  355.295202]  [<ffffffffa046f733>] 
em28xx_usb_disconnect+0xb3/0x140 [em28xx]
Apr 10 00:21:41 localhost kernel: [  355.295211]  [<ffffffff8149cbf3>] 
usb_unbind_interface+0x63/0x1b0
Apr 10 00:21:41 localhost kernel: [  355.295220]  [<ffffffff814187ac>] 
__device_release_driver+0x7c/0xf0
Apr 10 00:21:41 localhost kernel: [  355.295228]  [<ffffffff81418afe>] 
device_release_driver+0x2e/0x40
Apr 10 00:21:41 localhost kernel: [  355.295236]  [<ffffffff81418222>] 
bus_remove_device+0x102/0x180
Apr 10 00:21:41 localhost kernel: [  355.295245]  [<ffffffff8141557f>] 
device_del+0x12f/0x1c0
Apr 10 00:21:41 localhost kernel: [  355.295253]  [<ffffffff8149a4f0>] 
usb_disable_device+0xb0/0x270
Apr 10 00:21:41 localhost kernel: [  355.295264]  [<ffffffff8119d1f2>] ? 
kfree+0xb2/0x1d0
Apr 10 00:21:41 localhost kernel: [  355.295273]  [<ffffffff814907e5>] 
usb_disconnect+0xb5/0x1d0
Apr 10 00:21:41 localhost kernel: [  355.295284]  [<ffffffff81491fbd>] 
hub_port_connect_change+0xcd/0xab0
Apr 10 00:21:41 localhost kernel: [  355.295292]  [<ffffffff81499a80>] ? 
usb_control_msg+0xf0/0x140
Apr 10 00:21:41 localhost kernel: [  355.295301]  [<ffffffff8148ca23>] ? 
hub_port_status+0x83/0x120
Apr 10 00:21:41 localhost kernel: [  355.295311]  [<ffffffff81492ca0>] 
hub_events+0x300/0x920
Apr 10 00:21:41 localhost kernel: [  355.295322]  [<ffffffff814932f5>] 
hub_thread+0x35/0x1f0
Apr 10 00:21:41 localhost kernel: [  355.295331]  [<ffffffff81088440>] ? 
wake_up_bit+0x40/0x40
Apr 10 00:21:41 localhost kernel: [  355.295341]  [<ffffffff814932c0>] ? 
hub_events+0x920/0x920
Apr 10 00:21:41 localhost kernel: [  355.295350]  [<ffffffff81087d8d>] 
kthread+0xed/0x100
Apr 10 00:21:41 localhost kernel: [  355.295361]  [<ffffffff81087ca0>] ? 
kthread_create_on_node+0x160/0x160
Apr 10 00:21:41 localhost kernel: [  355.295370]  [<ffffffff816acbec>] 
ret_from_fork+0x7c/0xb0
Apr 10 00:21:41 localhost kernel: [  355.295379]  [<ffffffff81087ca0>] ? 
kthread_create_on_node+0x160/0x160
Apr 10 00:21:41 localhost kernel: [  355.299531] em2874 #0: V4L2 device 
video0 deregistered
Apr 10 00:22:02 localhost kernel: [  375.763842] TCP: lp registered


-- 
http://palosaari.fi/
