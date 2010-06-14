Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:38791 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752002Ab0FNMjd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jun 2010 08:39:33 -0400
Subject: Re: Kernel oops with new IR modules
From: Andy Walls <awalls@md.metrocast.net>
To: "Timothy D. Lenz" <tlenz@vorgon.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <4C159A0F.20006@vorgon.com>
References: <4C159A0F.20006@vorgon.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Jun 2010 08:39:54 -0400
Message-ID: <1276519194.4376.25.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2010-06-13 at 19:55 -0700, Timothy D. Lenz wrote: 
> I tried to build new drivers from v4l hg for 06/08/10 and when I tried 
> to load drivers I got a kernel oops. Kernel is 2.6.34 64bit for amd cpu
> 
> http://pastebin.com/7KwJtFJg


See:
http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/20198
http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/19904

The Oops appears to be in the same place as the Oops I analyzed in the
second link.  However, your compiler, like mine, decides to code the
comparison against RC_DRIVER_SCANCODE (which is 0) first:

	4f: 83 3a 00   cmpl   $0x0,(%rdx)    <---------- Oopsing insn

Right about here:

http://linuxtv.org/hg/v4l-dvb/file/23492745405c/linux/drivers/media/IR/ir-sysfs.c#l226


As mentioned in the first link, please try the patch found here:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=84b14f181a36eea6591779156ef356f8d198bbfd

Regards,
Andy

> Jun 13 14:35:40 x64VDR kernel: IR JVC protocol handler initialized
> Jun 13 14:35:40 x64VDR kernel: IR Sony protocol handler initialized
> Jun 13 14:35:40 x64VDR kernel: cx23885_dev_checkrevision() Hardware 
> revision = 0xb0
> Jun 13 14:35:40 x64VDR kernel: cx23885[0]/0: found at 0000:02:00.0, rev: 
> 2, irq: 16, latency: 0, mmio: 0xfdc00000
> Jun 13 14:35:40 x64VDR kernel: cx23885 0000:02:00.0: setting latency 
> timer to 64
> Jun 13 14:35:40 x64VDR kernel: IRQ 16/cx23885[0]: IRQF_DISABLED is not 
> guaranteed on shared IRQs
> Jun 13 14:35:40 x64VDR kernel: Registered IR keymap rc-fusionhdtv-mce
> Jun 13 14:35:40 x64VDR kernel: BUG: unable to handle kernel NULL pointer 
> dereference at (null)
> Jun 13 14:35:40 x64VDR kernel: IP: [<ffffffffa0229e30>] 
> ir_register_class+0x4f/0x15f [ir_core]
> Jun 13 14:35:40 x64VDR kernel: PGD 7ebdb067 PUD 7ebd3067 PMD 0
> Jun 13 14:35:40 x64VDR kernel: Oops: 0000 [#1] PREEMPT SMP
> Jun 13 14:35:40 x64VDR kernel: last sysfs file: 
> /sys/module/ir_core/initstate
> Jun 13 14:35:40 x64VDR kernel: CPU 1
> Jun 13 14:35:40 x64VDR kernel: Modules linked in: rc_fusionhdtv_mce 
> ir_kbd_i2c(+) ir_sony_decoder ir_jvc_decoder ir_rc6_decoder cx23885 
> ir_rc5_decoder cx2341x v4l2_common videobuf_dvb ir_common ir_nec_decoder 
> ir_core btcx_risc tveeprom lnbp21 stv0299 dvb_ttpci dvb_core saa7146_vv 
> videodev v4l1_compat v4l2_compat_ioctl32 saa7146 videobuf_dma_sg 
> videobuf_core ttpci_eeprom powernow_k8 hwmon_vid max6650 snd_intel8x0 
> snd_ac97_codec ac97_bus smbfs af_packet snd_hda_codec_analog 
> snd_hda_intel snd_hda_codec snd_pcm snd_seq snd_timer snd_seq_device snd 
> sg psmouse amd64_edac_mod k8temp fan soundcore snd_page_alloc 
> asus_atk0110 i2c_nforce2 thermal processor button
> Jun 13 14:35:40 x64VDR kernel:
> Jun 13 14:35:40 x64VDR kernel: Pid: 1933, comm: modprobe Not tainted 
> 2.6.34.20100610.1 #1 M2N-E/System Product Name
> Jun 13 14:35:40 x64VDR kernel: RIP: 0010:[<ffffffffa0229e30>] 
> [<ffffffffa0229e30>] ir_register_class+0x4f/0x15f [ir_core]
> Jun 13 14:35:40 x64VDR kernel: RSP: 0018:ffff88007e0abd18  EFLAGS: 00010246
> Jun 13 14:35:40 x64VDR kernel: RAX: 0000000000000000 RBX: 
> ffff88007ee5ec00 RCX: ffffffffa022ae00
> Jun 13 14:35:40 x64VDR kernel: RDX: 0000000000000000 RSI: 
> ffffffffa022a9d4 RDI: ffff88007ee5ec00
> Jun 13 14:35:40 x64VDR kernel: RBP: 0000000000000000 R08: 
> 000000000000004f R09: 00000000ffffffff
> Jun 13 14:35:40 x64VDR kernel: R10: 00000000ffffffff R11: 
> ffff88007ee28808 R12: ffffffffa029d060
> Jun 13 14:35:40 x64VDR kernel: R13: ffff88007ee28000 R14: 
> 0000000000000282 R15: ffffffffa0296aec
> Jun 13 14:35:40 x64VDR kernel: FS:  00007fdc8355d6f0(0000) 
> GS:ffff880001700000(0000) knlGS:0000000000000000
> Jun 13 14:35:40 x64VDR kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
> 000000008005003b
> Jun 13 14:35:40 x64VDR kernel: CR2: 0000000000000000 CR3: 
> 000000007ebd1000 CR4: 00000000000006e0
> Jun 13 14:35:40 x64VDR kernel: DR0: 0000000000000000 DR1: 
> 0000000000000000 DR2: 0000000000000000
> Jun 13 14:35:40 x64VDR kernel: DR3: 0000000000000000 DR6: 
> 00000000ffff0ff0 DR7: 0000000000000400
> Jun 13 14:35:40 x64VDR kernel: Process modprobe (pid: 1933, threadinfo 
> ffff88007e0aa000, task ffff88007e22a280)
> Jun 13 14:35:40 x64VDR kernel: Stack:
> Jun 13 14:35:40 x64VDR kernel:  ffff88007ee28000 ffff88007ee5ec00 
> ffff88007ee28000 ffffffffa029d060
> Jun 13 14:35:40 x64VDR kernel: <0> 000000000000002d ffffffffa022960a 
> 0000000000000001 ffffffff00000000
> Jun 13 14:35:40 x64VDR kernel: <0> ffff88007ee5ee20 ffff88007ee5edf8 
> ffff88007e0aa000 ffff88007d815600
> Jun 13 14:35:40 x64VDR kernel: Call Trace:
> Jun 13 14:35:40 x64VDR kernel:  [<ffffffffa022960a>] ? 
> __ir_input_register+0x243/0x2e7 [ir_core]
> Jun 13 14:35:40 x64VDR kernel:  [<ffffffffa02963aa>] ? 
> ir_probe+0x37f/0x448 [ir_kbd_i2c]
> Jun 13 14:35:40 x64VDR kernel:  [<ffffffffa029602b>] ? 
> ir_probe+0x0/0x448 [ir_kbd_i2c]
> Jun 13 14:35:40 x64VDR kernel:  [<ffffffff81222ce2>] ? 
> i2c_device_probe+0xb0/0xe6
> Jun 13 14:35:40 x64VDR kernel:  [<ffffffff811be322>] ? 
> driver_sysfs_add+0x42/0x69
> Jun 13 14:35:40 x64VDR kernel:  [<ffffffff811be452>] ? 
> driver_probe_device+0x9c/0x123
> Jun 13 14:35:40 x64VDR kernel:  [<ffffffff811be528>] ? 
> __driver_attach+0x4f/0x6f
> Jun 13 14:35:40 x64VDR kernel:  [<ffffffff811be4d9>] ? 
> __driver_attach+0x0/0x6f
> Jun 13 14:35:40 x64VDR kernel:  [<ffffffff811bdd13>] ? 
> bus_for_each_dev+0x44/0x78
> Jun 13 14:35:40 x64VDR kernel:  [<ffffffff811bd6f8>] ? 
> bus_add_driver+0xaf/0x1f7
> Jun 13 14:35:40 x64VDR kernel:  [<ffffffff811be7cd>] ? 
> driver_register+0x90/0xf8
> Jun 13 14:35:40 x64VDR kernel:  [<ffffffffa029a000>] ? ir_init+0x0/0x19 
> [ir_kbd_i2c]
> Jun 13 14:35:40 x64VDR kernel:  [<ffffffff812238f9>] ? 
> i2c_register_driver+0x40/0x91
> Jun 13 14:35:40 x64VDR kernel:  [<ffffffffa029a000>] ? ir_init+0x0/0x19 
> [ir_kbd_i2c]
> Jun 13 14:35:40 x64VDR kernel:  [<ffffffff810001e0>] ? 
> do_one_initcall+0x4f/0x13e
> Jun 13 14:35:40 x64VDR kernel:  [<ffffffff81052330>] ? 
> sys_init_module+0xc6/0x222
> Jun 13 14:35:40 x64VDR kernel:  [<ffffffff81001eab>] ? 
> system_call_fastpath+0x16/0x1b
> Jun 13 14:35:40 x64VDR kernel: Code: a0 48 89 c3 e8 b9 23 f2 e0 85 c0 89 
> c5 0f 88 1b 01 00 00 48 8b 93 30 02 00 00 48 c7 c1 00 ae 22 a0 48 c7 c6 
> d4 a9 22 a0 48 89 df <83> 3a 00 48 c7 c2 30 ae 22 a0 48 c7 83 d8 01 00 
> 00 90 ad 22 a0
> Jun 13 14:35:40 x64VDR kernel: RIP  [<ffffffffa0229e30>] 
> ir_register_class+0x4f/0x15f [ir_core]
> Jun 13 14:35:40 x64VDR kernel:  RSP <ffff88007e0abd18>
> Jun 13 14:35:40 x64VDR kernel: CR2: 0000000000000000
> Jun 13 14:35:40 x64VDR kernel: ---[ end trace 3443a52638911d4d ]---
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



