Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:50821 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752702Ab3CZB0E (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Mar 2013 21:26:04 -0400
Message-ID: <5150F926.8070505@web.de>
Date: Tue, 26 Mar 2013 02:25:58 +0100
From: Soeren Moch <smoch@web.de>
MIME-Version: 1.0
To: mchehab@redhat.com
CC: linux-media@vger.kernel.org
Subject: dmxdev: Unable to handle kernel paging request
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Every few days/weeks I see Oopses like the attached one. I tried to track down the problem, but with added debug printk's the error didn't occur. I'm using em28xx and dib0700 based dvb sticks at an armv5te system (Marvell Kirkwood), the user application is vdr.

Any ideas what is wrong or who can help here?

Thanks,
  Soeren


Mar 25 21:47:00 guruvdr kernel: Unable to handle kernel paging request at virtual address e2134000
Mar 25 21:47:00 guruvdr kernel: pgd = def2c000
Mar 25 21:47:00 guruvdr kernel: [e2134000] *pgd=1ef4b811, *pte=00000000, *ppte=00000000
Mar 25 21:47:00 guruvdr kernel: Internal error: Oops: 7 [#1] PREEMPT ARM
Mar 25 21:47:00 guruvdr kernel: Modules linked in: uap8xxx em28xx_dvb tda18271c2dd drxk tda18271 dvb_usb_dib0700 em28xx tveeprom videobuf_vmalloc videobuf_core
Mar 25 21:47:00 guruvdr kernel: CPU: 0    Not tainted  (3.8.0-guruvdr #42)
Mar 25 21:47:00 guruvdr kernel: PC is at memcpy+0x320/0x3a4
Mar 25 21:47:00 guruvdr kernel: LR is at 0x50100
Mar 25 21:47:00 guruvdr kernel: pc : [<c0172980>]    lr : [<00050100>]    psr: 20000013
Mar 25 21:47:00 guruvdr kernel: sp : dedabe50  ip : 616c4b05  fp : dedabe9c
Mar 25 21:47:00 guruvdr kernel: r10: 00000000  r9 : 2c6f6d69  r8 : 73736974
Mar 25 21:47:00 guruvdr kernel: r7 : 73657250  r6 : 206d4905  r5 : 0f756564  r4 : 404dd200
Mar 25 21:47:00 guruvdr kernel: r3 : 00000000  r2 : 00000020  r1 : e2133ff4  r0 : afffdf40
Mar 25 21:47:00 guruvdr kernel: Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Mar 25 21:47:00 guruvdr kernel: Control: 0005397f  Table: 1ef2c000  DAC: 00000015
Mar 25 21:47:00 guruvdr kernel: Process section handler (pid: 2110, stack limit = 0xdedaa1b8)
Mar 25 21:47:00 guruvdr kernel: Stack: (0xdedabe50 to 0xdedac000)
Mar 25 21:47:00 guruvdr kernel: be40:                                     0000049b afffde77 00000189 e2133f1a
Mar 25 21:47:00 guruvdr kernel: be60: 00000000 afffde77 dedaa000 c017bff4 ddbcc7f4 ded50338 e17b9054 afffde77
Mar 25 21:47:00 guruvdr kernel: be80: 0000049b 00000587 00000587 00000003 dedabeac dedabea0 c017c084 c017bf1c
Mar 25 21:47:00 guruvdr kernel: bea0: dedabecc dedabeb0 c029a8d8 c017c074 e17b9054 afffdd8b 00000587 dedaa000
Mar 25 21:47:00 guruvdr kernel: bec0: dedabf1c dedabed0 c0291dbc c029a820 00000800 dedabee8 c07624c8 00000000
Mar 25 21:47:00 guruvdr kernel: bee0: 00000000 c0745728 00000013 00000080 dedabf50 e17b9000 afffdd8b deed5180
Mar 25 21:47:00 guruvdr kernel: bf00: 00000ffd 00000003 e17b9070 00000003 dedabf4c dedabf20 c0291f90 c0291c8c
Mar 25 21:47:00 guruvdr kernel: bf20: dedabf80 00001000 deed5180 afffdd88 dedabf80 c000dce4 dedaa000 00000000
Mar 25 21:47:00 guruvdr kernel: bf40: dedabf7c dedabf50 c008eba8 c0291e70 dedabf7c dedabf60 c00a82a0 deed5180
Mar 25 21:47:00 guruvdr kernel: bf60: 00000001 afffdd88 00001000 c000dce4 dedabfa4 dedabf80 c008ec6c c008eb00
Mar 25 21:47:00 guruvdr kernel: bf80: 00000000 00000000 0000002d 00001000 afffdd88 00000003 00000000 dedabfa8
Mar 25 21:47:00 guruvdr kernel: bfa0: c000db80 c008ec34 0000002d 00001000 0000002d afffdd88 00001000 00001000
Mar 25 21:47:00 guruvdr kernel: bfc0: 0000002d 00001000 afffdd88 00000003 001270c8 00000006 00d40d98 afffedb4
Mar 25 21:47:00 guruvdr kernel: bfe0: 00000000 afffdcf8 b6f00f74 b6f00f84 80000010 0000002d 1fffe831 1fffec31
Mar 25 21:47:00 guruvdr kernel: Backtrace:
Mar 25 21:47:00 guruvdr kernel: [<c017bf0c>] (__copy_to_user_memcpy+0x0/0x158) from [<c017c084>] (__copy_to_user+0x20/0x24)
Mar 25 21:47:00 guruvdr kernel: [<c017c064>] (__copy_to_user+0x0/0x24) from [<c029a8d8>] (dvb_ringbuffer_read_user+0xc8/0xfc)
Mar 25 21:47:00 guruvdr kernel: [<c029a810>] (dvb_ringbuffer_read_user+0x0/0xfc) from [<c0291dbc>] (dvb_dmxdev_buffer_read.isra.8+0x140/0x19c)
Mar 25 21:47:00 guruvdr kernel: r7:dedaa000 r6:00000587 r5:afffdd8b r4:e17b9054
Mar 25 21:47:00 guruvdr kernel: [<c0291c7c>] (dvb_dmxdev_buffer_read.isra.8+0x0/0x19c) from [<c0291f90>] (dvb_demux_read+0x130/0x180)
Mar 25 21:47:00 guruvdr kernel: [<c0291e60>] (dvb_demux_read+0x0/0x180) from [<c008eba8>] (vfs_read+0xb8/0x134)
Mar 25 21:47:00 guruvdr kernel: [<c008eaf0>] (vfs_read+0x0/0x134) from [<c008ec6c>] (sys_read+0x48/0x70)
Mar 25 21:47:00 guruvdr kernel: r8:c000dce4 r7:00001000 r6:afffdd88 r5:00000001 r4:deed5180
Mar 25 21:47:00 guruvdr kernel: [<c008ec24>] (sys_read+0x0/0x70) from [<c000db80>] (ret_fast_syscall+0x0/0x2c)
Mar 25 21:47:00 guruvdr kernel: r7:00000003 r6:afffdd88 r5:00001000 r4:0000002d
Mar 25 21:47:00 guruvdr kernel: Code: f5d1f07c e8b100f0 e1a03c2e e2522020 (e8b15300)
Mar 25 21:47:00 guruvdr kernel: ---[ end trace ad119c47b9c422ea ]---
Mar 25 21:47:00 guruvdr kernel: note: section handler[2110] exited with preempt_count 1
