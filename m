Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45510 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942Ab1FXRjk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2011 13:39:40 -0400
Received: by wwe5 with SMTP id 5so3093594wwe.1
        for <linux-media@vger.kernel.org>; Fri, 24 Jun 2011 10:39:39 -0700 (PDT)
Subject: cx18 init lockdep spew
Content-Transfer-Encoding: 8BIT
From: Jarod Wilson <jarod@wilsonet.com>
Content-Type: text/plain; charset=us-ascii
Message-Id: <ECEB9AD1-D1E4-4204-BE4C-30E3EFFA7722@wilsonet.com>
Date: Fri, 24 Jun 2011 13:39:29 -0400
Cc: Andy Walls <awalls@md.metrocast.net>
To: "linux-media@vger.kernel.org Mailing List"
	<linux-media@vger.kernel.org>
Mime-Version: 1.0 (Apple Message framework v1084)
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I only just recently acquired a Hauppauge HVR-1600 cards, and at least both
2.6.39 and 3.0-rc4 kernels with copious debug spew enabled spit out the
lockdep spew included below. Haven't looked into it at all yet, but I
thought I'd ask before I do if it is already a known issue.

[   11.856504] Linux video capture interface: v2.00
[   12.306435] cx18:  Start initialization, version 1.5.0
[   12.308789] cx18-0: Initializing card 0
[   12.310751] cx18-0: Autodetected Hauppauge card
[   12.313403] cx18 0000:02:04.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   12.346552] cx18-0: cx23418 revision 01010000 (B)
[   12.437931] 
[   12.437933] =============================================
[   12.438014] [ INFO: possible recursive locking detected ]
[   12.438014] 3.0.0-rc4+ #15
[   12.438014] ---------------------------------------------
[   12.438014] work_for_cpu/743 is trying to acquire lock:
[   12.438014]  (&hdl->lock){+.+.+.}, at: [<ffffffffa02403e2>] handler_new_ref+0xe9/0x183 [videodev]
[   12.438014] 
[   12.438014] but task is already holding lock:
[   12.438014]  (&hdl->lock){+.+.+.}, at: [<ffffffffa02404c5>] v4l2_ctrl_add_handler+0x49/0x8e [videodev]
[   12.438014] 
[   12.438014] other info that might help us debug this:
[   12.438014]  Possible unsafe locking scenario:
[   12.438014] 
[   12.438014]        CPU0
[   12.438014]        ----
[   12.438014]   lock(&hdl->lock);
[   12.438014]   lock(&hdl->lock);
[   12.438014] 
[   12.438014]  *** DEADLOCK ***
[   12.438014] 
[   12.438014]  May be due to missing lock nesting notation
[   12.438014] 
[   12.438014] 1 lock held by work_for_cpu/743:
[   12.438014]  #0:  (&hdl->lock){+.+.+.}, at: [<ffffffffa02404c5>] v4l2_ctrl_add_handler+0x49/0x8e [videodev]
[   12.438014] 
[   12.438014] stack backtrace:
[   12.438014] Pid: 743, comm: work_for_cpu Not tainted 3.0.0-rc4+ #15
[   12.438014] Call Trace:
[   12.438014]  [<ffffffff81087815>] __lock_acquire+0x917/0xcf7
[   12.438014]  [<ffffffff810849d6>] ? trace_hardirqs_off+0xd/0xf
[   12.438014]  [<ffffffff81084f1a>] ? lock_release_holdtime.part.8+0x6b/0x72
[   12.438014]  [<ffffffffa02403e2>] ? handler_new_ref+0xe9/0x183 [videodev]
[   12.438014]  [<ffffffff81088082>] lock_acquire+0xbf/0x103
[   12.438014]  [<ffffffffa02403e2>] ? handler_new_ref+0xe9/0x183 [videodev]
[   12.438014]  [<ffffffff81088358>] ? mark_held_locks+0x4b/0x6d
[   12.438014]  [<ffffffffa02403e2>] ? handler_new_ref+0xe9/0x183 [videodev]
[   12.438014]  [<ffffffff814c9ae2>] __mutex_lock_common+0x4c/0x361
[   12.438014]  [<ffffffffa02403e2>] ? handler_new_ref+0xe9/0x183 [videodev]
[   12.438014]  [<ffffffffa024026d>] ? kzalloc.constprop.15+0x13/0x15 [videodev]
[   12.438014]  [<ffffffff811241f1>] ? __kmalloc+0xfa/0x10c
[   12.438014]  [<ffffffff814c9f06>] mutex_lock_nested+0x40/0x45
[   12.438014]  [<ffffffffa02403e2>] handler_new_ref+0xe9/0x183 [videodev]
[   12.438014]  [<ffffffffa02404e0>] v4l2_ctrl_add_handler+0x64/0x8e [videodev]
[   12.438014]  [<ffffffffa023d6c5>] v4l2_device_register_subdev+0xcb/0x141 [videodev]
[   12.438014]  [<ffffffffa0291e64>] cx18_av_probe+0x291/0x2bd [cx18]
[   12.438014]  [<ffffffff814ca03b>] ? mutex_unlock+0xe/0x10
[   12.438014]  [<ffffffffa0295623>] cx18_probe+0xd43/0x1343 [cx18]
[   12.438014]  [<ffffffff814cb5f8>] ? _raw_spin_unlock_irqrestore+0x45/0x52
[   12.438014]  [<ffffffff814cb600>] ? _raw_spin_unlock_irqrestore+0x4d/0x52
[   12.438014]  [<ffffffff8106d0b8>] ? move_linked_works+0x6e/0x6e
[   12.438014]  [<ffffffff812720b2>] local_pci_probe+0x44/0x75
[   12.438014]  [<ffffffff8106d0ce>] do_work_for_cpu+0x16/0x28
[   12.438014]  [<ffffffff8107344d>] kthread+0xa8/0xb0
[   12.438014]  [<ffffffff814d3324>] kernel_thread_helper+0x4/0x10
[   12.438014]  [<ffffffff814cb9d4>] ? retint_restore_args+0x13/0x13
[   12.438014]  [<ffffffff810733a5>] ? __init_kthread_worker+0x5a/0x5a[   12.438014]  [<ffffffff814d3320>] ? gs_change+0x13/0x13
[   12.663073] tveeprom 6-0050: Hauppauge model 74021, rev C1B2, serial# 1561046[   12.664488] tveeprom 6-0050: MAC address is 00:0d:fe:17:d1:d6
[   12.665871] tveeprom 6-0050: tuner model is TCL M2523_5N_E (idx 112, type 50)
[   12.667299] tveeprom 6-0050: TV standards NTSC(M) (eeprom 0x08)
[   12.668749] tveeprom 6-0050: audio processor is CX23418 (idx 38)
[   12.670207] tveeprom 6-0050: decoder processor is CX23418 (idx 31)
[   12.671694] tveeprom 6-0050: has no radio, has IR receiver, has IR transmitter
[   12.673218] cx18-0: Autodetected Hauppauge HVR-1600
[   12.674752] cx18-0: Simultaneous Digital and Analog TV capture supported[   12.824476] i2c-core: driver [tuner] using legacy suspend method
[   12.826135] i2c-core: driver [tuner] using legacy resume method
[   12.843402] tuner 7-0061: Tuner -1 found with type(s) Radio TV.
[   12.878152] cs5345 6-004c: chip found @ 0x98 (cx18 i2c driver #0-0)
[   12.952064] tuner-simple 7-0061: creating new instance
[   12.953712] tuner-simple 7-0061: type set to 50 (TCL 2002N)
[   12.967854] cx18-0: Registered device video0 for encoder MPEG (64 x 32.00 kB)
[   12.969552] DVB: registering new adapter (cx18)
[   13.157923] MXL5005S: Attached at address 0x63
[   13.159569] DVB: registering adapter 0 frontend 0 (Samsung S5H1409 QAM/8VSB Frontend)...
[   13.161557] cx18-0: DVB Frontend registered
[   13.163239] cx18-0: Registered DVB adapter0 for TS (32 x 32.00 kB)
[   13.165079] cx18-0: Registered device video32 for encoder YUV (20 x 101.25 kB)
[   13.166889] cx18-0: Registered device vbi0 for encoder VBI (20 x 51984 bytes)
[   13.168708] cx18-0: Registered device video24 for encoder PCM audio (256 x 4.00 kB)
[   13.170407] cx18-0: Initialized card: Hauppauge HVR-1600
[   13.172251] cx18:  End initialization
[   13.387206] cx18-0: loaded v4l-cx23418-cpu.fw firmware (158332 bytes)
[   13.551919] cx18-0: loaded v4l-cx23418-apu.fw firmware V00120000 (141200 bytes)
[   13.560280] cx18-0: FW version: 0.0.74.0 (Release 2007/03/12)
[   13.571169] cx18-alsa: module loading...
[   14.477034] cx18-0 843: loaded v4l-cx23418-dig.fw firmware (16382 bytes)
[   14.503906] cx18-0 843: verified load of v4l-cx23418-dig.fw firmware (16382 bytes)

-- 
Jarod Wilson
jarod@wilsonet.com



