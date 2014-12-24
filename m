Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:41856 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352AbaLXTPr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Dec 2014 14:15:47 -0500
Message-ID: <549B10DA.8050408@osg.samsung.com>
Date: Wed, 24 Dec 2014 12:15:38 -0700
From: Shuah Khan <shuahkh@osg.samsung.com>
MIME-Version: 1.0
To: "Mauro Carvalho Chehab (m.chehab@samsung.com)" <m.chehab@samsung.com>,
	ttmesterr@gmail.com,
	"dheitmueller@kernellabs.com >> Devin Heitmueller"
	<dheitmueller@kernellabs.com>, Shuah Khan <shuahkh@osg.samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: au0828 - possible circular locking dependency detected
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All,

I am seeing the following warning when driver is initializing. Full
trace as follows: au0828_rc_register() calls input_register_device().
In that path input_mutex is held, after that kbd_connect() initiates
input_open_device() which results attempt to hold inout_mutex. Is this
a known issue and any pointers on solving this. I haven't started any
attempts to solve it yet. This is a nested locking issue coming from
input core and I am not sure yet on how to solve it.

-- Shuah


Dec 17 12:50:16 anduin kernel: [  112.044576] [ INFO: possible circular
locking dependency detected ]
Dec 17 12:50:16 anduin kernel: [  112.044580] 3.18.0-rc7+ #13 Not tainted
Dec 17 12:50:16 anduin kernel: [  112.044583]
-------------------------------------------------------
Dec 17 12:50:16 anduin kernel: [  112.044586] systemd-udevd/3367 is
trying to acquire lock:
Dec 17 12:50:16 anduin kernel: [  112.044589]  (input_mutex){+.+.+.},
at: [<ffffffff815e0a31>] input_register_device+0x431/0x540
Dec 17 12:50:16 anduin kernel: [  112.044603]
Dec 17 12:50:16 anduin kernel: [  112.044603] but task is already
holding lock:
Dec 17 12:50:16 anduin kernel: [  112.044607]
(ir_raw_handler_lock){+.+.+.}, at: [<ffffffff8163e106>]
ir_raw_event_register+0x106/0x1b0
Dec 17 12:50:16 anduin kernel: [  112.044617]
Dec 17 12:50:16 anduin kernel: [  112.044617] which lock already depends
on the new lock.
Dec 17 12:50:16 anduin kernel: [  112.044617]
Dec 17 12:50:16 anduin kernel: [  112.044622]
Dec 17 12:50:16 anduin kernel: [  112.044622] the existing dependency
chain (in reverse order) is:
Dec 17 12:50:16 anduin kernel: [  112.044625]
Dec 17 12:50:16 anduin kernel: [  112.044625] -> #3
(ir_raw_handler_lock){+.+.+.}:
Dec 17 12:50:16 anduin kernel: [  112.044631]
[<ffffffff810adaa1>] lock_acquire+0xb1/0x140
Dec 17 12:50:16 anduin kernel: [  112.044639]
[<ffffffff818510b9>] mutex_lock_nested+0x49/0x3b0
Dec 17 12:50:16 anduin kernel: [  112.044645]
[<ffffffff8163e106>] ir_raw_event_register+0x106/0x1b0
Dec 17 12:50:16 anduin kernel: [  112.044650]
[<ffffffff8163d8d3>] rc_register_device+0x5a3/0x600
Dec 17 12:50:16 anduin kernel: [  112.044654]
[<ffffffffa05e40e4>] au0828_rc_register+0x234/0x2b0 [au0828]
Dec 17 12:50:16 anduin kernel: [  112.044665]
[<ffffffffa05dd518>] au0828_usb_probe+0x188/0x2d0 [au0828]
Dec 17 12:50:16 anduin kernel: [  112.044673]
[<ffffffff8159421e>] usb_probe_interface+0x1de/0x350
Dec 17 12:50:16 anduin kernel: [  112.044679]
[<ffffffff814d17e0>] driver_probe_device+0x90/0x3f0
Dec 17 12:50:16 anduin kernel: [  112.044685]
[<ffffffff814d1c23>] __driver_attach+0xa3/0xb0
Dec 17 12:50:16 anduin kernel: [  112.044689]
[<ffffffff814cf4d3>] bus_for_each_dev+0x73/0xb0
Dec 17 12:50:16 anduin kernel: [  112.044694]
[<ffffffff814d123e>] driver_attach+0x1e/0x20
Dec 17 12:50:16 anduin kernel: [  112.044698]
[<ffffffff814d0e18>] bus_add_driver+0x188/0x260
Dec 17 12:50:16 anduin kernel: [  112.044703]
[<ffffffff814d2444>] driver_register+0x64/0xf0
Dec 17 12:50:16 anduin kernel: [  112.044707]
[<ffffffff81592887>] usb_register_driver+0xa7/0x190
Dec 17 12:50:16 anduin kernel: [  112.044713]
[<ffffffffa05ff0c4>] au0828_init+0xc4/0x1000 [au0828]
Dec 17 12:50:16 anduin kernel: [  112.044720]
[<ffffffff81000300>] do_one_initcall+0xc0/0x1f0

Dec 17 12:50:16 anduin kernel: [  112.044726]
[<ffffffff810eddbd>] load_module+0x204d/0x2790
Dec 17 12:50:16 anduin kernel: [  112.044732]
[<ffffffff810ee6a6>] SyS_finit_module+0x86/0xb0
Dec 17 12:50:16 anduin kernel: [  112.044737]
[<ffffffff81855852>] system_call_fastpath+0x12/0x17
Dec 17 12:50:16 anduin kernel: [  112.044742]
Dec 17 12:50:16 anduin kernel: [  112.044742] -> #2 (&dev->lock#3){+.+.+.}:
Dec 17 12:50:16 anduin kernel: [  112.044750]
[<ffffffff810adaa1>] lock_acquire+0xb1/0x140
Dec 17 12:50:16 anduin kernel: [  112.044755]
[<ffffffff818510b9>] mutex_lock_nested+0x49/0x3b0
Dec 17 12:50:16 anduin kernel: [  112.044760]
[<ffffffff8163be7e>] rc_open+0x2e/0x90
Dec 17 12:50:16 anduin kernel: [  112.044764]
[<ffffffff8163bef5>] ir_open+0x15/0x20
Dec 17 12:50:16 anduin kernel: [  112.044768]
[<ffffffff815de9b1>] input_open_device+0x81/0xb0
Dec 17 12:50:16 anduin kernel: [  112.044772]
[<ffffffff8149cf68>] kbd_connect+0x78/0xa0
Dec 17 12:50:16 anduin kernel: [  112.044778]
[<ffffffff815e059d>] input_attach_handler+0x1bd/0x220
Dec 17 12:50:16 anduin kernel: [  112.044783]
[<ffffffff815e0a87>] input_register_device+0x487/0x540
Dec 17 12:50:16 anduin kernel: [  112.044787]
[<ffffffff8163d6bf>] rc_register_device+0x38f/0x600
Dec 17 12:50:16 anduin kernel: [  112.044791]
[<ffffffffa05e40e4>] au0828_rc_register+0x234/0x2b0 [au0828]
Dec 17 12:50:16 anduin kernel: [  112.044800]
[<ffffffffa05dd518>] au0828_usb_probe+0x188/0x2d0 [au0828]
Dec 17 12:50:16 anduin kernel: [  112.044807]
[<ffffffff8159421e>] usb_probe_interface+0x1de/0x350
Dec 17 12:50:16 anduin kernel: [  112.044812]
[<ffffffff814d17e0>] driver_probe_device+0x90/0x3f0
Dec 17 12:50:16 anduin kernel: [  112.044816]
[<ffffffff814d1c23>] __driver_attach+0xa3/0xb0
Dec 17 12:50:16 anduin kernel: [  112.044821]
[<ffffffff814cf4d3>] bus_for_each_dev+0x73/0xb0
Dec 17 12:50:16 anduin kernel: [  112.044825]
[<ffffffff814d123e>] driver_attach+0x1e/0x20
Dec 17 12:50:16 anduin kernel: [  112.044830]
[<ffffffff814d0e18>] bus_add_driver+0x188/0x260
Dec 17 12:50:16 anduin kernel: [  112.044834]
[<ffffffff814d2444>] driver_register+0x64/0xf0
Dec 17 12:50:16 anduin kernel: [  112.044838]
[<ffffffff81592887>] usb_register_driver+0xa7/0x190
Dec 17 12:50:16 anduin kernel: [  112.044843]
[<ffffffffa05ff0c4>] au0828_init+0xc4/0x1000 [au0828]
Dec 17 12:50:16 anduin kernel: [  112.044850]
[<ffffffff81000300>] do_one_initcall+0xc0/0x1f0
Dec 17 12:50:16 anduin kernel: [  112.044855]
[<ffffffff810eddbd>] load_module+0x204d/0x2790
Dec 17 12:50:16 anduin kernel: [  112.044860]
[<ffffffff810ee6a6>] SyS_finit_module+0x86/0xb0
Dec 17 12:50:16 anduin kernel: [  112.044864]
[<ffffffff81855852>] system_call_fastpath+0x12/0x17
Dec 17 12:50:16 anduin kernel: [  112.044870]
Dec 17 12:50:16 anduin kernel: [  112.044870] -> #1 (&dev->mutex#2){+.+.+.}:
Dec 17 12:50:16 anduin kernel: [  112.044876]
[<ffffffff810adaa1>] lock_acquire+0xb1/0x140
Dec 17 12:50:16 anduin kernel: [  112.044881]
[<ffffffff81850c94>] mutex_lock_interruptible_nested+0x54/0x430
Dec 17 12:50:16 anduin kernel: [  112.044886]
[<ffffffff815de772>] input_register_handle+0x32/0xe0
Dec 17 12:50:16 anduin kernel: [  112.044891]
[<ffffffff8149cf3e>] kbd_connect+0x4e/0xa0
Dec 17 12:50:16 anduin kernel: [  112.044895]
[<ffffffff815e059d>] input_attach_handler+0x1bd/0x220
Dec 17 12:50:16 anduin kernel: [  112.044900]
[<ffffffff815e0a87>] input_register_device+0x487/0x540
Dec 17 12:50:16 anduin kernel: [  112.044904]
[<ffffffff8146a312>] acpi_button_add+0x289/0x388
Dec 17 12:50:16 anduin kernel: [  112.044910]
[<ffffffff81443094>] acpi_device_probe+0x50/0xf7
Dec 17 12:50:16 anduin kernel: [  112.044916]
[<ffffffff814d17e0>] driver_probe_device+0x90/0x3f0
Dec 17 12:50:16 anduin kernel: [  112.044920]
[<ffffffff814d1c23>] __driver_attach+0xa3/0xb0
Dec 17 12:50:16 anduin kernel: [  112.044925]
[<ffffffff814cf4d3>] bus_for_each_dev+0x73/0xb0
Dec 17 12:50:16 anduin kernel: [  112.044929]
[<ffffffff814d123e>] driver_attach+0x1e/0x20
Dec 17 12:50:16 anduin kernel: [  112.044933]
[<ffffffff814d0e18>] bus_add_driver+0x188/0x260
Dec 17 12:50:16 anduin kernel: [  112.044937]
[<ffffffff814d2444>] driver_register+0x64/0xf0
Dec 17 12:50:16 anduin kernel: [  112.044942]
[<ffffffff8144394e>] acpi_bus_register_driver+0x40/0x42
Dec 17 12:50:16 anduin kernel: [  112.044946]
[<ffffffff81fc1466>] acpi_button_driver_init+0x10/0x12
Dec 17 12:50:16 anduin kernel: [  112.044952]
[<ffffffff81000300>] do_one_initcall+0xc0/0x1f0
Dec 17 12:50:16 anduin kernel: [  112.044957]
[<ffffffff81f7f0bc>] kernel_init_freeable+0x1da/0x262
Dec 17 12:50:16 anduin kernel: [  112.044962]
[<ffffffff8184211e>] kernel_init+0xe/0xf0
Dec 17 12:50:16 anduin kernel: [  112.044967]
[<ffffffff818557ac>] ret_from_fork+0x7c/0xb0
Dec 17 12:50:16 anduin kernel: [  112.044972]
Dec 17 12:50:16 anduin kernel: [  112.044972] -> #0 (input_mutex){+.+.+.}:
Dec 17 12:50:16 anduin kernel: [  112.044978]
[<ffffffff810ac936>] __lock_acquire+0x1db6/0x1ff0
Dec 17 12:50:16 anduin kernel: [  112.044983]
[<ffffffff810adaa1>] lock_acquire+0xb1/0x140
Dec 17 12:50:16 anduin kernel: [  112.044988]
[<ffffffff81850c94>] mutex_lock_interruptible_nested+0x54/0x430
Dec 17 12:50:16 anduin kernel: [  112.044993]
[<ffffffff815e0a31>] input_register_device+0x431/0x540
Dec 17 12:50:16 anduin kernel: [  112.044997]
[<ffffffff81640495>] ir_mce_kbd_register+0x125/0x160
Dec 17 12:50:16 anduin kernel: [  112.045002]
[<ffffffff8163e14e>] ir_raw_event_register+0x14e/0x1b0
Dec 17 12:50:16 anduin kernel: [  112.045006]
[<ffffffff8163d8d3>] rc_register_device+0x5a3/0x600
Dec 17 12:50:16 anduin kernel: [  112.045010]
[<ffffffffa05e40e4>] au0828_rc_register+0x234/0x2b0 [au0828]
Dec 17 12:50:16 anduin kernel: [  112.045018]
[<ffffffffa05dd518>] au0828_usb_probe+0x188/0x2d0 [au0828]
Dec 17 12:50:16 anduin kernel: [  112.045026]
[<ffffffff8159421e>] usb_probe_interface+0x1de/0x350
Dec 17 12:50:16 anduin kernel: [  112.045030]
[<ffffffff814d17e0>] driver_probe_device+0x90/0x3f0
Dec 17 12:50:16 anduin kernel: [  112.045035]
[<ffffffff814d1c23>] __driver_attach+0xa3/0xb0
Dec 17 12:50:16 anduin kernel: [  112.045039]
[<ffffffff814cf4d3>] bus_for_each_dev+0x73/0xb0
Dec 17 12:50:16 anduin kernel: [  112.045043]
[<ffffffff814d123e>] driver_attach+0x1e/0x20
Dec 17 12:50:16 anduin kernel: [  112.045047]
[<ffffffff814d0e18>] bus_add_driver+0x188/0x260
Dec 17 12:50:16 anduin kernel: [  112.045052]
[<ffffffff814d2444>] driver_register+0x64/0xf0
Dec 17 12:50:16 anduin kernel: [  112.045056]
[<ffffffff81592887>] usb_register_driver+0xa7/0x190
Dec 17 12:50:16 anduin kernel: [  112.045061]
[<ffffffffa05ff0c4>] au0828_init+0xc4/0x1000 [au0828]
Dec 17 12:50:16 anduin kernel: [  112.045068]
[<ffffffff81000300>] do_one_initcall+0xc0/0x1f0
Dec 17 12:50:16 anduin kernel: [  112.045073]
[<ffffffff810eddbd>] load_module+0x204d/0x2790
Dec 17 12:50:16 anduin kernel: [  112.045078]
[<ffffffff810ee6a6>] SyS_finit_module+0x86/0xb0
Dec 17 12:50:16 anduin kernel: [  112.045083]
[<ffffffff81855852>] system_call_fastpath+0x12/0x17
Dec 17 12:50:16 anduin kernel: [  112.045088]
Dec 17 12:50:16 anduin kernel: [  112.045088] other info that might help
us debug this:
Dec 17 12:50:16 anduin kernel: [  112.045088]
Dec 17 12:50:16 anduin kernel: [  112.045092] Chain exists of:
Dec 17 12:50:16 anduin kernel: [  112.045092]   input_mutex -->
&dev->lock#3 --> ir_raw_handler_lock
Dec 17 12:50:16 anduin kernel: [  112.045092]
Dec 17 12:50:16 anduin kernel: [  112.045101]  Possible unsafe locking
scenario:
Dec 17 12:50:16 anduin kernel: [  112.045101]
Dec 17 12:50:16 anduin kernel: [  112.045104]        CPU0
     CPU1
Dec 17 12:50:16 anduin kernel: [  112.045106]        ----
     ----
Dec 17 12:50:16 anduin kernel: [  112.045108]   lock(ir_raw_handler_lock);
Dec 17 12:50:16 anduin kernel: [  112.045112]
     lock(&dev->lock#3);
Dec 17 12:50:16 anduin kernel: [  112.045117]
     lock(ir_raw_handler_lock);
Dec 17 12:50:16 anduin kernel: [  112.045120]   lock(input_mutex);
Dec 17 12:50:16 anduin kernel: [  112.045124]
Dec 17 12:50:16 anduin kernel: [  112.045124]  *** DEADLOCK ***
Dec 17 12:50:16 anduin kernel: [  112.045124]
Dec 17 12:50:16 anduin kernel: [  112.045128] 5 locks held by
systemd-udevd/3367:
Dec 17 12:50:16 anduin kernel: [  112.045130]  #0:
(&dev->mutex){......}, at: [<ffffffff814d1bd3>] __driver_attach+0x53/0xb0
Dec 17 12:50:16 anduin kernel: [  112.045139]  #1:
(&dev->mutex){......}, at: [<ffffffff814d1be1>] __driver_attach+0x61/0xb0
Dec 17 12:50:16 anduin kernel: [  112.045148]  #2:
(&dev->lock#2){+.+.+.}, at: [<ffffffffa05dd42d>]
au0828_usb_probe+0x9d/0x2d0 [au0828]
Dec 17 12:50:16 anduin kernel: [  112.045160]  #3:
(&dev->lock#3){+.+.+.}, at: [<ffffffff8163d6cc>]
rc_register_device+0x39c/0x600
Dec 17 12:50:16 anduin kernel: [  112.045170]  #4:
(ir_raw_handler_lock){+.+.+.}, at: [<ffffffff8163e106>]
ir_raw_event_register+0x106/0x1b0
Dec 17 12:50:16 anduin kernel: [  112.045179]
Dec 17 12:50:16 anduin kernel: [  112.045179] stack backtrace:

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
