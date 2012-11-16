Return-path: <linux-media-owner@vger.kernel.org>
Received: from moh3-ve3.go2.pl ([193.17.41.87]:51293 "EHLO moh3-ve3.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752264Ab2KPT1x (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Nov 2012 14:27:53 -0500
Received: from moh3-ve3.go2.pl (unknown [10.0.0.158])
	by moh3-ve3.go2.pl (Postfix) with ESMTP id A6C12B5A71C
	for <linux-media@vger.kernel.org>; Fri, 16 Nov 2012 20:27:45 +0100 (CET)
Received: from unknown (unknown [10.0.0.108])
	by moh3-ve3.go2.pl (Postfix) with SMTP
	for <linux-media@vger.kernel.org>; Fri, 16 Nov 2012 20:27:45 +0100 (CET)
Message-ID: <50A693AF.4080707@tlen.pl>
Date: Fri, 16 Nov 2012 20:27:43 +0100
From: Wojciech Myrda <vojcek@tlen.pl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Mariusz Bialonczyk <manio@skyboo.net>, liplianin@me.by
Subject: Re: Bugs in DVB-S Prof-Tuner 8000 driver (idle & suspend)
References: <5072E5BA.2020205@tlen.pl>
In-Reply-To: <5072E5BA.2020205@tlen.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

W dniu 08.10.2012 16:39, Wojciech Myrda pisze:
> Hi,
>
> I am using these new driver http://patchwork.linuxtv.org/patch/14300/
> for my card. It generally works great allowing me to send DiseqC
> commands, tune to LNBs etc but only as long as I do not use idle or
> suspend with it which in first circumstance leads to kernel panics for
> which I acquired number of pictures http://bigvo.dyndns.org/dvb/cx23885/
> and in second requires reloading the driver to work properly
>
>
> CARD INFO
> [    4.600476] cx23885 driver version 0.0.3 loaded
> [    4.600828] CORE cx23885[0]: subsystem: 8000:3034, board: Prof
> Revolution DVB-S2 8000 [card=37,autodetected]
> [    5.334312] cx23885_dvb_register() allocating 1 frontend(s)
> [    5.334342] cx23885[0]: cx23885 based dvb card
> [    5.423938] DVB: registering new adapter (cx23885[0])
> [    5.424427] cx23885_dev_checkrevision() Hardware revision = 0xb0
> [    5.424437] cx23885[0]/0: found at 0000:02:00.0, rev: 2, irq: 16,
> latency: 0, mmio: 0xfe600000
>
> More info here: http://bigvo.dyndns.org/dvb/
>
> If anyone is willing to take time and effort to improve the code for the
> driver I would greatly appreciate it and I am willing to test it
>
> Regards,
> _WM

hi guys,

I tried to use my Prof card once again now that 3.7 kernel reached rc-5
to find my system crash after something about 2 hours of testing the
card. This time for a change I did notice that first after I made number
of tunnings to different channels few minutes before the crash I was not
able to tune to in to any frequency.

My system without the card did work for a month with no problem
therefore the problem is definetly with the card or the way the in
kernel driver for it works. Please take a look at the error and let me
know if there is any thing I can do to get rid of this problem :(



BUG: unable to handle kernel NULL pointer deference at 00000000000000a8
IP: [<ffffffffa01d38a0>] cx23885_video_wakeup+0x20/0x160 [ cx23885]
PGD 127716067 PUD 12b2f1067 PMD 0
Oops: 0000 [#1] SMP
Modules linked in: des_generic ecb md4 sha256_generic md5 hmac
nls_cp1250 cifs ipv6 dvb_ttpci saa7146_vv ttpci_eeprom saa7146
ir_rc6_decoder ir_lirc_codec lirc_dev w83627ehf hwmon_vid phx_k8(O)
mperf(O) thermal fan rc_imon_pad imon usbhid stb6100 stv090x cx23885
btcx_risc psmouse snd_hda_codec_realtek altera_ci videobuf_dvb tda18271
pcspkr altera_stapi tveeprom cx2341x videobuf_dma_sg k10temp dvb_core
rc_core v4l2_common xhci_hcd r8169 videodev mii media snd_hda_codec_hdmi
videobuf_core ohci_hcd sr_mod cdrom snd_hda_intel ehci_hcd snd_hda_codec
snd_hwdep snd_pcm usbcore snd_page_alloc usb_common snd_timer snd
parport_pc parport processor thermal_sys
CPU 1
Pid: 0, comm: swapper/1 Tained: G 0 3.7.0-rc5 #1 System manufacuter
System Product Name/E35M1-M PRO
RIP: 0010:[<ffffffffa01d38a0>] [<ffffffffa01d38a0>]
cx23885_video_wakeup+0x20/0x160 [ cx23885]
RSP: 0018:ffff88013ed03de8 EFLAGS: 00010082
RAX: ffffc90011400000 RBX: 0000000000000000 RCX: 0000000000000060
RDX: 00000000ffffffff RSI: ffff880137586070 RDI: ffff880137584000
RBP: ffff880137586070 R08: 000000000000000a R09: 0000000000000000
R10: 00000000000003cb R11: 00000000000003ca R12: 0000000000000000
R13: 00000000ffffffff R14: 00000000ffffffff R15: 00000000ffffffff
FS: 00007f1b27b73700(0000) GS:ffff88013ed00000(0000) knlGS:00000000f1bfab40
CS: 0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000000000a8 CR3: 000000012743b000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper/1 (pid: 0, threadinfo ffff88013a8a6000, task
ffff88013a87c080
Stack:
ffff88013ed03e38 ffff88013ed03df8 00000000ffffffff 00000000ffffffff
ffff880137584000 0000000000000000 00000000ffffffff 00000000ffffffff
00000000ffffffff ffffffffa01d4360 ffff880137584000 00000000ffffffff
Call Trace:
<IRQ>
[<ffffffffa01d4360>] ? cx23885_video_irq+0x100/0x1c0 [ cx23885]
[<ffffffffa01d7ea4>] ? cx23885_irq+0x434/0x920 [ cx23885]
[<ffffffff8109cab9>] ? rcu_process_callbacks+0x459/0x540
[<ffffffffa00067a5>] ? azx_interrupt+0x105/0x1b0 [snd_hda_intel]
[<ffffffff81096624>] ? handle_irq_event_percpu+0x54/0x1f0
[<ffffffff810967f6>] ? handle_irq_event+0x36/0x60
[<ffffffff8109967c>] ? handle_fasteoi_irq+0x4c/0xe0
[<ffffffff81003df5>] ? handle_irq+0x15/0x20
[<ffffffff81003ac3>] ? do_IRQ+0x53/0xd0
[<ffffffff814ab9ea>] ? common_interrupt+0x6a/0x6a
<EOI>
[<ffffffffa0012005>] ? acpi_idle_enter_simple+0xb5/0xe6 [processor]
[<ffffffffa0012000>] ? acpi_idle_enter_simple+0xb0/0xe6 [processor]
[<ffffffff813e6b12>] ? cpuidle_idle_call+0xa2/0x270
[<ffffffff8100b24a>] ? cpu_idle+0x7a/0xd0
Code: 12 2d e1 e9 52 ff ff ff 0f 1f 00 41 57 41 56 41 89 d6 41 55 41 54
55 48 89 f5 53 48 83 ec 18 48 8b 1e 48 39 de 0f 84 e1 00 00 00 <66> 3b
93 a8 00 00 00 41 89 d4 0f 88 b4 00 00 00 48 8d 43 c8 45
RIP [<ffffffffa01d38a0>] cx23885_video_wakeup+0x20/0x160 [ cx23885]
RSP <ffff88013ed03de8>
CR2: 00000000000000a8
Kernel panic – not syncing: Fatal exception in interrupt
panic occured, switching back to text console

Regards,
_WM



