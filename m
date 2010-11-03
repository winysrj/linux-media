Return-path: <mchehab@gaivota>
Received: from fmmailgate05.web.de ([217.72.192.243]:41322 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab0KCPys convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Nov 2010 11:54:48 -0400
Received: from mwmweb019  ( [172.20.18.28])
	by fmmailgate05.web.de (Postfix) with ESMTP id 2F38C63693BD
	for <linux-media@vger.kernel.org>; Wed,  3 Nov 2010 16:54:47 +0100 (CET)
Date: Wed, 3 Nov 2010 16:54:47 +0100 (CET)
From: "Herbert Lueger" <kloana@web.de>
Message-ID: <838109956.2368762.1288799687187.JavaMail.fmail@mwmweb019>
Subject: FW: Re: 2.6.32 with ngene --> traceback under Debian DomU
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
To: linux-media@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi,

i'm not sure if i'm right in this mailinglist. Maybe you can find out a problem.

Thanks in advance,
regards
Herbert



---------------------
Von: "Herbert Lueger" <kloana@web.de>
Gesendet: 03.11.2010 09:13:10
An: debian-kernel@lists.debian.org, "Herbert Lueger" <kloana@web.de>
Betreff: Re: 2.6.32 with ngene --> traceback


Hi,

do you need any further informations?

Thanks in advance,
regards
herbert



---------------------
Von: "Herbert Lueger" <kloana@web.de>
Gesendet: 27.10.2010 18:29:45
An: debian-kernel@lists.debian.org, "Herbert Lueger" <kloana@web.de>
Betreff: 2.6.32 with ngene --> traceback




Hi,

i'm trying to find a solution for a cineS2 dvb-card under a xen DomU. 
I testet to build the latest v4l-driver modules from mercurial. Building under linux-image-2.6.32-5-xen-amd64 is working without any problems. The CineS2 TV-card is hidden via piback.hide and imported to the domU via the pci command in the domU config file. 
When i boot the domU i always get a traceback.

When i use the same driver under non-xen kernel everything is working. Only under XEN the problem occours.

Attached you can find the output of dmesg.

IRQ 18 is shared with two usb-controllers.

Sorry i'm not sure if i'm right in this mailinglist, or if i should open a troubleticket at debian kernel side. 

Thanks in advance,
regards
Herbert

[    1.987639] input: PC Speaker as /devices/platform/pcspkr/input/input1
[    2.308933] nGene PCIE bridge driver, Copyright (C) 2005-2007 Micronas
[    2.309153] ngene 0000:00:00.0: enabling device (0000 -> 0002)
[    2.309269] ngene 0000:00:00.0: Xen PCI enabling IRQ: 18
[    2.309280]   alloc irq_desc for 18 on node 0
[    2.309283]   alloc kstat_irqs on node 0
[    2.309303] ngene: Found Linux4Media cineS2 DVB-S2 Twin Tuner (v5)
[    2.310004] ngene 0000:00:00.0: setting latency timer to 64
[    2.310293] ngene: Device version 1
[    2.310339] ngene 0000:00:00.0: firmware: requesting ngene_15.fw
[    2.347956] Error: Driver 'pcspkr' is already registered, aborting...
[    2.373354] ngene: Loading firmware file ngene_15.fw.
[    4.384106] ngene: Command timeout cmd=11 prev=02
[    4.384124] host_to_ngene (c000): 00 00 00 00 00 00 00 00
[    4.384135] ngene_to_host (c100): 00 01 00 00 00 00 00 00
[    4.384145] dev->hosttongene (ffff88000724a000): 11 01 00 d0 00 04 00 00
[    4.384154] dev->ngenetohost (ffff88000724a100): 00 00 00 00 00 00 00 00
[    4.384450] ngene: probe of 0000:00:00.0 failed with error -5
[    4.385161] BUG: unable to handle kernel paging request at ffffc90000097770
[    4.385174] IP: [<ffffffff8113f18a>] sysfs_open_file+0x77/0x2aa
[    4.385186] PGD 7c42067 PUD 7c43067 PMD 7c44067 PTE 0
[    4.385198] Oops: 0000 [#1] SMP 
[    4.385206] last sysfs file: /sys/devices/pci-0/pci0000:00/0000:00:00.0/i2c-0/uevent
[    4.385214] CPU 0 
[    4.385219] Modules linked in: ngene snd_pcm snd_timer snd dvb_core soundcore snd_page_alloc i2c_core evdev pcspkr ext3 jbd mbcache xen_netfront xen_blkfront
[    4.385254] Pid: 156, comm: udevd Not tainted 2.6.32-5-xen-amd64 #1 
[    4.385261] RIP: e030:[<ffffffff8113f18a>]  [<ffffffff8113f18a>] sysfs_open_file+0x77/0x2aa
[    4.385271] RSP: e02b:ffff880006c77d78  EFLAGS: 00010286
[    4.385277] RAX: ffff8800070160a0 RBX: 00000000ffffffed RCX: 0000000000000000
[    4.385285] RDX: 0000000000000001 RSI: ffff8800078df9c8 RDI: ffff8800070160a0
[    4.385291] RBP: ffff880007748b40 R08: ffff880007016054 R09: ffffffff81676150
[    4.385298] R10: ffff880006c77e48 R11: ffffffff811533e5 R12: ffffc90000097748
[    4.385305] R13: ffff8800070160a0 R14: ffff8800078df9c8 R15: ffff880007748b40
[    4.385316] FS:  00007f7663b907a0(0000) GS:ffff880003023000(0000) knlGS:0000000000000000
[    4.385324] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
[    4.385330] CR2: ffffc90000097770 CR3: 0000000007112000 CR4: 0000000000002620
[    4.385338] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    4.385345] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    4.385352] Process udevd (pid: 156, threadinfo ffff880006c76000, task ffff880007d34710)
[    4.385360] Stack:
[    4.385364]  0000000000000024 0000000000000000 ffff880007748b40 0000000000000000
[    4.385375] <0> ffff8800078df9c8 0000000000000024 ffffffff8113f113 ffffffff810ed986
[    4.385388] <0> ffff880007486000 ffff8800062feb00 ffff8800078d7840 0000000000000000
[    4.385404] Call Trace:
[    4.385410]  [<ffffffff8113f113>] ? sysfs_open_file+0x0/0x2aa
[    4.385419]  [<ffffffff810ed986>] ? __dentry_open+0x19d/0x2bf
[    4.385427]  [<ffffffff810f90d7>] ? do_filp_open+0x4e4/0x94b
[    4.385437]  [<ffffffff81250b7e>] ? sys_recvfrom+0xb2/0x11a
[    4.385446]  [<ffffffff8100ec5f>] ? xen_restore_fl_direct_end+0x0/0x1
[    4.385454]  [<ffffffff81102109>] ? alloc_fd+0x67/0x10c
[    4.385461]  [<ffffffff810ed717>] ? do_sys_open+0x55/0xfc
[    4.385469]  [<ffffffff81011b42>] ? system_call_fastpath+0x16/0x1b
[    4.385475] Code: ff f2 ae 48 c7 c7 50 61 67 81 48 f7 d1 48 89 ca e8 40 6c 05 00 4c 89 ef bb ed ff ff ff e8 f3 15 00 00 48 85 c0 0f 84 25 02 00 00 <49> 8b 44 24 28 48 85 c0 74 13 48 8b 68 08 48 85 ed 74 0a 41 8b 
[    4.385576] RIP  [<ffffffff8113f18a>] sysfs_open_file+0x77/0x2aa
[    4.385584]  RSP <ffff880006c77d78>
[    4.385590] CR2: ffffc90000097770
[    4.385596] ---[ end trace e428cb227937b038 ]---

Maybe someone has a solution to fix this problem.

Thanks in advance,
regards
Herbert
___________________________________________________________
GRATIS! Movie-FLAT mit über 300 Videos. 
Jetzt freischalten unter http://movieflat.web.de
