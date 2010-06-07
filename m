Return-path: <linux-media-owner@vger.kernel.org>
Received: from dd16922.kasserver.com ([85.13.137.202]:42766 "EHLO
	dd16922.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab0FGQdH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jun 2010 12:33:07 -0400
Received: from [127.0.0.1] (p50814FB5.dip.t-dialin.net [80.129.79.181])
	by dd16922.kasserver.com (Postfix) with ESMTPA id 97151742002
	for <linux-media@vger.kernel.org>; Mon,  7 Jun 2010 18:33:05 +0200 (CEST)
Message-ID: <4C0D1F49.4040501@helmutauer.de>
Date: Mon, 07 Jun 2010 18:33:13 +0200
From: Helmut Auer <vdr@helmutauer.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Kernel oops with current hg (ir-sysfs.c ?)
References: <201005241726.52932.martin.dauskardt@gmx.de>
In-Reply-To: <201005241726.52932.martin.dauskardt@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 24.05.2010 17:26, schrieb Martin Dauskardt:
> I guess it is a similar problem like the one that was solved a few months ago with this patch:
> http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/14232
> 
> I compiled the current v4l-dvb hg against the 2.6.32 Ubuntu 10.04 kernel
> 
> 
> May 24 13:30:22 ubuntuvdr1 kernel: [    5.629408] DVB: registering new adapter (TT-Budget C-1501 PCI)
> May 24 13:30:22 ubuntuvdr1 kernel: [    5.646949] tda9887 3-0043: i2c i/o error: rc == -5 (should be 4)
> May 24 13:30:22 ubuntuvdr1 kernel: [    5.649823] tda9887 3-0043: i2c i/o error: rc == -5 (should be 4)
> May 24 13:30:22 ubuntuvdr1 kernel: [    5.666028] adapter has MAC addr = 00:d0:5c:c6:5a:11
> May 24 13:30:22 ubuntuvdr1 kernel: [    5.692518] Registered IR keymap rc-tt-1500
> May 24 13:30:22 ubuntuvdr1 kernel: [    5.692545] BUG: unable to handle kernel NULL pointer dereference at (null)
> May 24 13:30:22 ubuntuvdr1 kernel: [    5.692554] IP: [<f825bd7e>] ir_register_class+0x3e/0x190 [ir_core]
> May 24 13:30:22 ubuntuvdr1 kernel: [    5.692566] *pde = 00000000
> May 24 13:30:22 ubuntuvdr1 kernel: [    5.692571] Oops: 0000 [#1] SMP
> May 24 13:30:22 ubuntuvdr1 kernel: [    5.692575] last sysfs file: /sys/module/ir_core/initstate
> May 24 13:30:22 ubuntuvdr1 kernel: [    5.692580] Modules linked in: rc_tt_1500 tda10021 snd_hda_codec_realtek tuner_simple tuner_types tda9887 tda8290 tuner msp3400 snd_hda_intel$
> May 24 13:30:22 ubuntuvdr1 kernel: [    5.692659]
> May 24 13:30:22 ubuntuvdr1 kernel: [    5.692663] Pid: 375, comm: modprobe Not tainted (2.6.32-22-generic #33-Ubuntu) M56S-S3
> May 24 13:30:22 ubuntuvdr1 kernel: [    5.692669] EIP: 0060:[<f825bd7e>] EFLAGS: 00010246 CPU: 0
> May 24 13:30:22 ubuntuvdr1 kernel: [    5.692677] EIP is at ir_register_class+0x3e/0x190 [ir_core]
> May 24 13:30:22 ubuntuvdr1 kernel: [    5.692681] EAX: 00000000 EBX: f6375000 ECX: 00000000 EDX: 00000100
> May 24 13:30:22 ubuntuvdr1 kernel: [    5.692686] ESI: f4fa6000 EDI: 00000000 EBP: f61d5d78 ESP: f61d5d4c
> May 24 13:30:22 ubuntuvdr1 kernel: [    5.692691]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> May 24 13:30:22 ubuntuvdr1 kernel: [    5.692697] Process modprobe (pid: 375, ti=f61d4000 task=f61b6680 task.ti=f61d4000)
> May 24 13:30:22 ubuntuvdr1 kernel: [    5.692704] Stack:
> May 24 13:30:22 ubuntuvdr1 kernel: [    5.692707]  00000246 f825ba47 c24054e0 f825ba47 001d5d64 00000128 f4fa6000 0000003f
> May 24 13:30:22 ubuntuvdr1 kernel: [    5.692717] <0> faee9068 00000027 f4fa6000 f61d5db0 f825bb7c 0000009f 00000000 f8ce32ef
> May 24 13:30:22 ubuntuvdr1 kernel: [    5.692728] <0> c0588f82 f825cc11 00000296 f637513c f6375120 f6375000 f6827000 f4fa6000
> May 24 13:30:22 ubuntuvdr1 kernel: [    5.692741] Call Trace:
> May 24 13:30:22 ubuntuvdr1 kernel: [    5.692750]  [<f825ba47>] ? __ir_input_register+0x167/0x350 [ir_core]
> May 24 13:30:22 ubuntuvdr1 kernel: [    5.692759]  [<f825ba47>] ? __ir_input_register+0x167/0x350 [ir_core]
> May 24 13:30:22 ubuntuvdr1 kernel: [    5.692769]  [<f825bb7c>] ? __ir_input_register+0x29c/0x350 [ir_core]
> May 24 13:30:22 ubuntuvdr1 kernel: [    5.692779]  [<c0588f82>] ? printk+0x1d/0x23
> May 24 13:30:22 ubuntuvdr1 kernel: [    5.692789]  [<f8ce1153>] ? budget_ci_attach+0x193/0xd80 [budget_ci]
> May 24 13:30:22 ubuntuvdr1 kernel: [    5.692800]  [<f81ffeac>] ? saa7146_init_one+0x7dc/0x860 [saa7146]
> May 24 13:30:22 ubuntuvdr1 kernel: [    5.692811]  [<c01078d0>] ? dma_generic_alloc_coherent+0x0/0xc0
> May 24 13:30:22 ubuntuvdr1 kernel: [    5.692821]  [<c0363883>] ? local_pci_probe+0x13/0x20
> May 24 13:30:22 ubuntuvdr1 kernel: [    5.692827]  [<c0364688>] ? pci_device_probe+0x68/0x90
> May 24 13:30:22 ubuntuvdr1 kernel: [    5.692835]  [<c03e688d>] ? really_probe+0x4d/0x140
> May 24 13:30:22 ubuntuvdr1 kernel: [    5.692843]  [<c03ed19e>] ? pm_runtime_barrier+0x4e/0xc0
> May 24 13:30:22 ubuntuvdr1 kernel: [    5.692850]  [<c03e69bc>] ? driver_probe_device+0x3c/0x60
> May 24 13:30:22 ubuntuvdr1 kernel: [    5.692857]  [<c03e6a61>] ? __driver_attach+0x81/0x90
> May 24 13:30:22 ubuntuvdr1 kernel: [    5.692864]  [<c03e5ea3>] ? bus_for_each_dev+0x53/0x80
> May 24 13:30:22 ubuntuvdr1 kernel: [    5.692871]  [<c03e675e>] ? driver_attach+0x1e/0x20
> May 24 13:30:22 ubuntuvdr1 kernel: [    5.692877]  [<c03e69e0>] ? __driver_attach+0x0/0x90
> May 24 13:30:22 ubuntuvdr1 kernel: [    5.692884]  [<c03e6125>] ? bus_add_driver+0xd5/0x280
> May 24 13:30:22 ubuntuvdr1 kernel: [    5.692890]  [<c03645c0>] ? pci_device_remove+0x0/0x40
> May 24 13:30:22 ubuntuvdr1 kernel: [    5.692897]  [<c03e6d5a>] ? driver_register+0x6a/0x130
> May 24 13:30:22 ubuntuvdr1 kernel: [    5.692903]  [<c03648c5>] ? __pci_register_driver+0x45/0xb0
> May 24 13:30:22 ubuntuvdr1 kernel: [    5.692913]  [<f81fed63>] ? saa7146_register_extension+0x53/0x90 [saa7146]
> May 24 13:30:22 ubuntuvdr1 kernel: [    5.692923]  [<f8ce700d>] ? budget_ci_init+0xd/0xf [budget_ci]
> May 24 13:30:22 ubuntuvdr1 kernel: [    5.692929]  [<c0101131>] ? do_one_initcall+0x31/0x190
> May 24 13:30:22 ubuntuvdr1 kernel: [    5.692937]  [<f8ce7000>] ? budget_ci_init+0x0/0xf [budget_ci]
> May 24 13:30:22 ubuntuvdr1 kernel: [    5.692945]  [<c0182340>] ? sys_init_module+0xb0/0x210
> May 24 13:30:22 ubuntuvdr1 kernel: [    5.692951]  [<c01033ec>] ? syscall_call+0x7/0xb
> May 24 13:30:22 ubuntuvdr1 kernel: [    5.692956] Code: 00 89 c6 8d 80 a0 07 00 00 e8 bf a7 18 c8 ba 00 01 00 00 89 c3 b8 0c d4 25 f8 e8 6e ec 0e c8 89 c7 85 ff 78 6f 8b 83 44 01 $
> May 24 13:30:22 ubuntuvdr1 kernel: [    5.693003] EIP: [<f825bd7e>] ir_register_class+0x3e/0x190 [ir_core] SS:ESP 0068:f61d5d4c
> May 24 13:30:22 ubuntuvdr1 kernel: [    5.693015] CR2: 0000000000000000
> May 24 13:30:22 ubuntuvdr1 kernel: [    5.693020] ---[ end trace 2c915ef882a2f862 ]---
> --I can confirm this. Loading budget_ci from current v4l-dvb hg with kernel 2.6.34 causes kernel oops:

Jun 07 12:49:05 [kernel] budget_ci dvb 0000:01:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
Jun 07 12:49:05 [kernel] IRQ 19/: IRQF_DISABLED is not guaranteed on shared IRQs
Jun 07 12:49:05 [kernel] saa7146: found saa7146 @ mem f949ac00 (revision 1, irq 19) (0x13c2,0x1010).
Jun 07 12:49:05 [kernel] saa7146 (0): dma buffer size 192512
Jun 07 12:49:05 [kernel] DVB: registering new adapter (TT-Budget-C-CI PCI)
Jun 07 12:49:05 [kernel] IR NEC protocol handler initialized
Jun 07 12:49:05 [kernel] IR RC5(x) protocol handler initialized
Jun 07 12:49:05 [kernel] IR RC6 protocol handler initialized
Jun 07 12:49:05 [kernel] IR JVC protocol handler initialized
Jun 07 12:49:05 [kernel] IR Sony protocol handler initialized
Jun 07 12:49:05 [kernel] Registered IR keymap rc-tt-1500
Jun 07 12:49:05 [kernel] BUG: unable to handle kernel NULL pointer dereference at (null)
Jun 07 12:49:05 [kernel] IP: [<f9435cc0>] ir_register_class+0x3f/0x123 [ir_core]
Jun 07 12:49:05 [kernel] *pdpt = 0000000036cb9001 *pde = 0000000000000000
Jun 07 12:49:05 [kernel] Modules linked in: rc_tt_1500 ir_sony_decoder ir_jvc_decoder
ir_rc6_decoder ir_rc5_decoder ir_nec_decoder budget_ci(+) budget_core dvb_core saa7146
ttpci_eeprom ir_core i2c_core snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm
snd_timer snd_page_alloc
Jun 07 12:49:05 [kernel] Pid: 1877, comm: modprobe Not tainted 2.6.34-gentoo #1 IPM31/To Be
Filled By O.E.M.
Jun 07 12:49:05 [kernel] EIP: 0060:[<f9435cc0>] EFLAGS: 00010246 CPU: 0
Jun 07 12:49:05 [kernel] EIP is at ir_register_class+0x3f/0x123 [ir_core]
Jun 07 12:49:05 [kernel] EAX: f9436a44 EBX: fffffff4 ECX: 00000000 EDX: 00000000
Jun 07 12:49:05 [kernel] ESI: f6da6200 EDI: f6fd1000 EBP: f6bf5dbc ESP: f6bf5dac
Jun 07 12:49:05 [kernel]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Jun 07 12:49:05 [kernel]  00000000 fffffff4 f6da6200 00000000 f6bf5de8 f9435572 f9636048 f6fd1000
Jun 07 12:49:05 [kernel] <0> f6da62c4 f6fd1784 f6da62e0 00000282 f651f5d0 f6fd1000 f651f588 f6bf5e24
Jun 07 12:49:05 [kernel] <0> f9491e04 f9492ee7 f6bf5e04 f6bf5e98 f651f000 f9449110 00000000 f9636048
Jun 07 12:49:05 [kernel]  [<f9435572>] ? __ir_input_register+0x220/0x3aa [ir_core]
Jun 07 12:49:05 [kernel]  [<f9491e04>] ? 0xf9491e04
Jun 07 12:49:05 [kernel]  [<f9448312>] ? saa7146_pgtable_free+0x57f/0x795 [saa7146]
Jun 07 12:49:05 [kernel]  [<c10c110a>] ? sysfs_addrm_finish+0x15/0xa3
Jun 07 12:49:05 [kernel]  [<c10c0b33>] ? sysfs_add_one+0x12/0x7a
Jun 07 12:49:05 [kernel]  [<c12b232b>] ? pci_match_device+0xa4/0xac
Jun 07 12:49:05 [kernel]  [<c12b21f4>] ? local_pci_probe+0xe/0x10
Jun 07 12:49:05 [kernel]  [<c12b2bf5>] ? pci_device_probe+0x43/0x66
Jun 07 12:49:05 [kernel]  [<c132471e>] ? driver_probe_device+0x79/0x105
Jun 07 12:49:05 [kernel]  [<c13247ed>] ? __driver_attach+0x43/0x5f
Jun 07 12:49:05 [kernel]  [<c132413d>] ? bus_for_each_dev+0x3d/0x67
Jun 07 12:49:05 [kernel]  [<c13245f7>] ? driver_attach+0x14/0x16
Jun 07 12:49:05 [kernel]  [<c13247aa>] ? __driver_attach+0x0/0x5f
Jun 07 12:49:05 [kernel]  [<c1323bb7>] ? bus_add_driver+0xa2/0x1d4
Jun 07 12:49:05 [kernel]  [<c1324a33>] ? driver_register+0x8b/0xeb
Jun 07 12:49:05 [kernel]  [<c12b2dc8>] ? __pci_register_driver+0x38/0x91
Jun 07 12:49:05 [kernel]  [<f9497000>] ? init_module+0x0/0xf [budget_ci]
Jun 07 12:49:05 [kernel]  [<f9447bb9>] ? saa7146_register_extension+0x68/0x242 [saa7146]
Jun 07 12:49:05 [kernel]  [<f949700d>] ? init_module+0xd/0xf [budget_ci]
Jun 07 12:49:05 [kernel]  [<c1001139>] ? do_one_initcall+0x4c/0x131
Jun 07 12:49:05 [kernel]  [<c104b5ae>] ? sys_init_module+0xa7/0x1db
Jun 07 12:49:05 [kernel]  [<c1002810>] ? sysenter_do_call+0x12/0x26
Jun 07 12:49:05 [kernel] ---[ end trace 100a66f59725996d ]---


It looks to me that v4l-dvb is not really maintained anymore :(


Helmut Auer, helmut@helmutauer.de
