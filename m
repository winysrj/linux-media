Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:62208 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755051Ab3LUQug (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Dec 2013 11:50:36 -0500
Received: by mail-ee0-f41.google.com with SMTP id t10so1623587eei.28
        for <linux-media@vger.kernel.org>; Sat, 21 Dec 2013 08:50:34 -0800 (PST)
Message-ID: <52B5C718.7030605@googlemail.com>
Date: Sat, 21 Dec 2013 17:51:36 +0100
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: em28xx DEADLOCK reported by lock debug
References: <52B1C79C.1070408@iki.fi>
In-Reply-To: <52B1C79C.1070408@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antti,

thank you for reporting this issue.

Am 18.12.2013 17:04, schrieb Antti Palosaari:
> That same lock debug deadlock is still there (maybe ~4 times I report
> it during 2 years). Is that possible to fix easily at all?

Patches are always welcome. ;)

>
>
> Antti
>
>
>
> joulu 18 17:56:37 localhost.localdomain kernel: usb 2-2: USB
> disconnect, device number 2
> joulu 18 17:56:37 localhost.localdomain kernel: em28174 #0:
> disconnecting em28174 #0 video
> joulu 18 17:56:37 localhost.localdomain kernel: joulu 18 17:56:37
> localhost.localdomain kernel:
> ======================================================
> joulu 18 17:56:37 localhost.localdomain kernel: [ INFO: possible
> circular locking dependency detected ]
> joulu 18 17:56:37 localhost.localdomain kernel: 3.13.0-rc1+ #77
> Tainted: G         C O
> joulu 18 17:56:37 localhost.localdomain kernel:
> -------------------------------------------------------
> joulu 18 17:56:37 localhost.localdomain kernel: khubd/34 is trying to
> acquire lock:
> joulu 18 17:56:37 localhost.localdomain kernel:
> (em28xx_devlist_mutex){+.+.+.}, at: [<ffffffffa06edd0d>]
> em28xx_close_extension+0x1d/0x70 [em28xx]
> joulu 18 17:56:37 localhost.localdomain kernel:
>                                                 but task is already
> holding lock:
> joulu 18 17:56:37 localhost.localdomain kernel:  (&dev->lock){+.+.+.},
> at: [<ffffffffa06eb689>] em28xx_usb_disconnect+0x99/0x140 [em28xx]
> joulu 18 17:56:37 localhost.localdomain kernel:
>                                                 which lock already
> depends on the new lock.
> joulu 18 17:56:37 localhost.localdomain kernel:
>                                                 the existing
> dependency chain (in reverse order) is:
> joulu 18 17:56:37 localhost.localdomain kernel:
>                                                 -> #1
> (&dev->lock){+.+.+.}:
> joulu 18 17:56:37 localhost.localdomain kernel: [<ffffffff810bb386>]
> __lock_acquire+0x3d6/0xc40
> joulu 18 17:56:37 localhost.localdomain kernel: [<ffffffff810bbca0>]
> lock_acquire+0xb0/0x150
> joulu 18 17:56:37 localhost.localdomain kernel: [<ffffffff816be5b7>]
> mutex_lock_nested+0x77/0x3d0
> joulu 18 17:56:37 localhost.localdomain kernel: [<ffffffffa077b6d5>]
> em28xx_dvb_init+0x85/0x1b44 [em28xx_dvb]
> joulu 18 17:56:37 localhost.localdomain kernel: [<ffffffffa06eb908>]
> em28xx_register_extension+0x58/0xa0 [em28xx]
> joulu 18 17:56:37 localhost.localdomain kernel: [<ffffffffa0783010>]
> 0xffffffffa0783010
> joulu 18 17:56:37 localhost.localdomain kernel: [<ffffffff8100214a>]
> do_one_initcall+0xfa/0x1b0
> joulu 18 17:56:37 localhost.localdomain kernel: [<ffffffff810eec72>]
> load_module+0x13c2/0x1a80
> joulu 18 17:56:37 localhost.localdomain kernel: [<ffffffff810ef4c6>]
> SyS_finit_module+0x86/0xb0
> joulu 18 17:56:37 localhost.localdomain kernel: [<ffffffff816ca729>]
> system_call_fastpath+0x16/0x1b
> joulu 18 17:56:37 localhost.localdomain kernel:
>                                                 -> #0
> (em28xx_devlist_mutex){+.+.+.}:
> joulu 18 17:56:37 localhost.localdomain kernel: [<ffffffff810b96b7>]
> validate_chain.isra.36+0x10d7/0x1130
> joulu 18 17:56:37 localhost.localdomain kernel: [<ffffffff810bb386>]
> __lock_acquire+0x3d6/0xc40
> joulu 18 17:56:37 localhost.localdomain kernel: [<ffffffff810bbca0>]
> lock_acquire+0xb0/0x150
> joulu 18 17:56:37 localhost.localdomain kernel: [<ffffffff816be5b7>]
> mutex_lock_nested+0x77/0x3d0
> joulu 18 17:56:37 localhost.localdomain kernel: [<ffffffffa06edd0d>]
> em28xx_close_extension+0x1d/0x70 [em28xx]
> joulu 18 17:56:37 localhost.localdomain kernel: [<ffffffffa06eb6a3>]
> em28xx_usb_disconnect+0xb3/0x140 [em28xx]
> joulu 18 17:56:37 localhost.localdomain kernel: [<ffffffff814b7c87>]
> usb_unbind_interface+0x67/0x1d0
> joulu 18 17:56:37 localhost.localdomain kernel: [<ffffffff814378ff>]
> __device_release_driver+0x7f/0xf0
> joulu 18 17:56:37 localhost.localdomain kernel: [<ffffffff81437995>]
> device_release_driver+0x25/0x40
> joulu 18 17:56:37 localhost.localdomain kernel: [<ffffffff814371fc>]
> bus_remove_device+0x11c/0x1a0
> joulu 18 17:56:37 localhost.localdomain kernel: [<ffffffff81433c26>]
> device_del+0x136/0x1d0
> joulu 18 17:56:37 localhost.localdomain kernel: [<ffffffff814b5660>]
> usb_disable_device+0xb0/0x290
> joulu 18 17:56:37 localhost.localdomain kernel: [<ffffffff814aa5f5>]
> usb_disconnect+0xb5/0x1d0
> joulu 18 17:56:37 localhost.localdomain kernel: [<ffffffff814acfe6>]
> hub_port_connect_change+0xd6/0xad0
> joulu 18 17:56:37 localhost.localdomain kernel: [<ffffffff814adcf3>]
> hub_events+0x313/0x9b0
> joulu 18 17:56:37 localhost.localdomain kernel: [<ffffffff814ae3c5>]
> hub_thread+0x35/0x190
> joulu 18 17:56:37 localhost.localdomain kernel: [<ffffffff8109044f>]
> kthread+0xff/0x120
> joulu 18 17:56:37 localhost.localdomain kernel: [<ffffffff816ca67c>]
> ret_from_fork+0x7c/0xb0
> joulu 18 17:56:37 localhost.localdomain kernel:
>                                                 other info that might
> help us debug this:
> joulu 18 17:56:37 localhost.localdomain kernel:  Possible unsafe
> locking scenario:
> joulu 18 17:56:37 localhost.localdomain kernel:        CPU0        CPU1
> joulu 18 17:56:37 localhost.localdomain kernel:        ----        ----
> joulu 18 17:56:37 localhost.localdomain kernel:   lock(&dev->lock);
> joulu 18 17:56:37 localhost.localdomain kernel:       
> lock(em28xx_devlist_mutex);
> joulu 18 17:56:37 localhost.localdomain kernel:        lock(&dev->lock);
> joulu 18 17:56:37 localhost.localdomain kernel:
> lock(em28xx_devlist_mutex);
> joulu 18 17:56:37 localhost.localdomain kernel:
>                                                  *** DEADLOCK ***

AFAICS, this deadlock can not occur.
em28xx_usb_disconnect() calls flush_request_modules() before acquiring
dev->lock which calls flush_work() to cancel module initialization.
And flush_work() is actually flush_work_sync() these days, so module
initialization should always be finished before dev->lock is acquired.

However, it would of course be nice to get this false warning fixed.
Any suggestions ? :)

Regards,
Frank

> joulu 18 17:56:37 localhost.localdomain kernel: 4 locks held by khubd/34:
> joulu 18 17:56:37 localhost.localdomain kernel:  #0:
> (&__lockdep_no_validate__){......}, at: [<ffffffff814ada94>]
> hub_events+0xb4/0x9b0
> joulu 18 17:56:37 localhost.localdomain kernel:  #1:
> (&__lockdep_no_validate__){......}, at: [<ffffffff814aa5a6>]
> usb_disconnect+0x66/0x1d0
> joulu 18 17:56:37 localhost.localdomain kernel:  #2:
> (&__lockdep_no_validate__){......}, at: [<ffffffff8143798d>]
> device_release_driver+0x1d/0x40
> joulu 18 17:56:37 localhost.localdomain kernel:  #3:
> (&dev->lock){+.+.+.}, at: [<ffffffffa06eb689>]
> em28xx_usb_disconnect+0x99/0x140 [em28xx]
> joulu 18 17:56:37 localhost.localdomain kernel:
>                                                 stack backtrace:
> joulu 18 17:56:37 localhost.localdomain kernel: CPU: 3 PID: 34 Comm:
> khubd Tainted: G         C O 3.13.0-rc1+ #77
> joulu 18 17:56:37 localhost.localdomain kernel: Hardware name: System
> manufacturer System Product Name/M5A78L-M/USB3, BIOS 1503    11/14/2012
> joulu 18 17:56:37 localhost.localdomain kernel:  ffffffff824f59f0
> ffff88030dbb98e8 ffffffff816b8da9 ffffffff824f59f0
> joulu 18 17:56:37 localhost.localdomain kernel:  ffff88030dbb9928
> ffffffff816b2c9b ffff88030dbb9960 0000000000000003
> joulu 18 17:56:37 localhost.localdomain kernel:  ffff88030da1afd0
> 0000000000000004 ffff88030da1a8a0 ffff88030da1afd0
> joulu 18 17:56:37 localhost.localdomain kernel: Call Trace:
> joulu 18 17:56:37 localhost.localdomain kernel:  [<ffffffff816b8da9>]
> dump_stack+0x4d/0x66
> joulu 18 17:56:37 localhost.localdomain kernel:  [<ffffffff816b2c9b>]
> print_circular_bug+0x200/0x20e
> joulu 18 17:56:37 localhost.localdomain kernel:  [<ffffffff810b96b7>]
> validate_chain.isra.36+0x10d7/0x1130
> joulu 18 17:56:37 localhost.localdomain kernel:  [<ffffffff8101c413>]
> ? native_sched_clock+0x13/0x80
> joulu 18 17:56:37 localhost.localdomain kernel:  [<ffffffff810bb386>]
> __lock_acquire+0x3d6/0xc40
> joulu 18 17:56:37 localhost.localdomain kernel:  [<ffffffff810bb3a7>]
> ? __lock_acquire+0x3f7/0xc40
> joulu 18 17:56:37 localhost.localdomain kernel:  [<ffffffff810bbca0>]
> lock_acquire+0xb0/0x150
> joulu 18 17:56:37 localhost.localdomain kernel:  [<ffffffffa06edd0d>]
> ? em28xx_close_extension+0x1d/0x70 [em28xx]
> joulu 18 17:56:37 localhost.localdomain kernel:  [<ffffffff816be5b7>]
> mutex_lock_nested+0x77/0x3d0
> joulu 18 17:56:37 localhost.localdomain kernel:  [<ffffffffa06edd0d>]
> ? em28xx_close_extension+0x1d/0x70 [em28xx]
> joulu 18 17:56:37 localhost.localdomain kernel:  [<ffffffff810b9e6d>]
> ? trace_hardirqs_on+0xd/0x10
> joulu 18 17:56:37 localhost.localdomain kernel:  [<ffffffffa06edd0d>]
> ? em28xx_close_extension+0x1d/0x70 [em28xx]
> joulu 18 17:56:37 localhost.localdomain kernel:  [<ffffffffa06eb689>]
> ? em28xx_usb_disconnect+0x99/0x140 [em28xx]
> joulu 18 17:56:37 localhost.localdomain kernel:  [<ffffffffa06eb689>]
> ? em28xx_usb_disconnect+0x99/0x140 [em28xx]
> joulu 18 17:56:37 localhost.localdomain kernel:  [<ffffffffa06edd0d>]
> em28xx_close_extension+0x1d/0x70 [em28xx]
> joulu 18 17:56:37 localhost.localdomain kernel:  [<ffffffffa06eb6a3>]
> em28xx_usb_disconnect+0xb3/0x140 [em28xx]
> joulu 18 17:56:37 localhost.localdomain kernel:  [<ffffffff814b7c87>]
> usb_unbind_interface+0x67/0x1d0
> joulu 18 17:56:37 localhost.localdomain kernel:  [<ffffffff814378ff>]
> __device_release_driver+0x7f/0xf0
> joulu 18 17:56:37 localhost.localdomain kernel:  [<ffffffff81437995>]
> device_release_driver+0x25/0x40
> joulu 18 17:56:37 localhost.localdomain kernel:  [<ffffffff814371fc>]
> bus_remove_device+0x11c/0x1a0
> joulu 18 17:56:37 localhost.localdomain kernel:  [<ffffffff81433c26>]
> device_del+0x136/0x1d0
> joulu 18 17:56:37 localhost.localdomain kernel:  [<ffffffff814b5660>]
> usb_disable_device+0xb0/0x290
> joulu 18 17:56:37 localhost.localdomain kernel:  [<ffffffff814aa5f5>]
> usb_disconnect+0xb5/0x1d0
> joulu 18 17:56:37 localhost.localdomain kernel:  [<ffffffff814acfe6>]
> hub_port_connect_change+0xd6/0xad0
> joulu 18 17:56:37 localhost.localdomain kernel:  [<ffffffff814b40a4>]
> ? usb_control_msg+0xd4/0x110
> joulu 18 17:56:37 localhost.localdomain kernel:  [<ffffffff814adcf3>]
> hub_events+0x313/0x9b0
> joulu 18 17:56:37 localhost.localdomain kernel:  [<ffffffff814ae3c5>]
> hub_thread+0x35/0x190
> joulu 18 17:56:37 localhost.localdomain kernel:  [<ffffffff810b12d0>]
> ? abort_exclusive_wait+0xb0/0xb0
> joulu 18 17:56:37 localhost.localdomain kernel:  [<ffffffff814ae390>]
> ? hub_events+0x9b0/0x9b0
> joulu 18 17:56:37 localhost.localdomain kernel:  [<ffffffff8109044f>]
> kthread+0xff/0x120
> joulu 18 17:56:37 localhost.localdomain kernel:  [<ffffffff81090350>]
> ? kthread_create_on_node+0x250/0x250
> joulu 18 17:56:37 localhost.localdomain kernel:  [<ffffffff816ca67c>]
> ret_from_fork+0x7c/0xb0
> joulu 18 17:56:37 localhost.localdomain kernel:  [<ffffffff81090350>]
> ? kthread_create_on_node+0x250/0x250
> joulu 18 17:56:37 localhost.localdomain kernel: tda18271 6-0060:
> destroying instance
> joulu 18 17:56:37 localhost.localdomain kernel: rc_unregister_device:
> Freed keycode table
> joulu 18 17:56:37 localhost.localdomain kernel: em28174 #0: V4L2
> device video0 deregistered
> joulu 18 17:56:37 localhost.localdomain kernel: i2c i2c-6: adapter
> [em28174 #0] unregistered
> joulu 18 17:56:37 localhost.localdomain kernel: i2c i2c-5: adapter
> [em28174 #0] unregistered
> joulu 18 17:56:37 localhost.localdomain colord[603]: device removed:
> sysfs-PCTV_Systems-PCTV_290e
>

