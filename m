Return-path: <linux-media-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:56189 "EHLO
	pophost.sonytel.be" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751323AbZDGHcz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Apr 2009 03:32:55 -0400
Date: Tue, 7 Apr 2009 09:32:52 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-media@vger.kernel.org, linux-dvb@linuxtv.org,
	Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: USB DVB unplug: kernel BUG at kernel/module.c:912!
In-Reply-To: <20090406235739.d9302e33.akpm@linux-foundation.org>
Message-ID: <alpine.LRH.2.00.0904070928590.17130@vixen.sonytel.be>
References: <alpine.LRH.2.00.0903311424360.12318@vixen.sonytel.be> <20090406235739.d9302e33.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 6 Apr 2009, Andrew Morton wrote:
> On Tue, 31 Mar 2009 14:28:45 +0200 (CEST) Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:
> 
> > When unplugging a Sony PlayTV USB DVB adaptor from a PS3, I get
> > 
> > | kernel BUG at kernel/module.c:912!
> > 
> > on 2.6.29-06608-g15f7176.

> > Unplug Sony PlayTV USB:
> > 
> > Mar 31 14:01:28 ps3 kernel: [ 1437.101593] usb 1-2.1: USB disconnect, address 6
> > Mar 31 14:01:28 ps3 kernel: [ 1437.133461] ------------[ cut here ]------------
> > Mar 31 14:01:28 ps3 kernel: [ 1437.137955] kernel BUG at kernel/module.c:912!
> > Mar 31 14:01:28 ps3 kernel: [ 1437.142408] Oops: Exception in kernel mode, sig: 5 [#1]
> > Mar 31 14:01:28 ps3 kernel: [ 1437.146533] SMP NR_CPUS=2 PS3
> > Mar 31 14:01:28 ps3 kernel: [ 1437.150560] Modules linked in: dvb_usb_dib0700 dib7000p dib3000mc dvb_usb dvb_core dib7000m dibx000_common dib0070 i2c_core nfsd exportfs dm_crypt dm_mod sg ps3disk ps3rom ps3flash ps3stor_lib ps3vram joydev evdev
> > Mar 31 14:01:28 ps3 kernel: [ 1437.155317] NIP: c00000000008ae54 LR: c00000000008ae4c CTR: c00000000008ae20
> > Mar 31 14:01:28 ps3 kernel: [ 1437.159706] REGS: c000000006987410 TRAP: 0700   Tainted: G        W   (2.6.29-06608-g15f7176)
> > Mar 31 14:01:28 ps3 kernel: [ 1437.164144] MSR: 8000000000028032 <EE,CE,IR,DR>  CR: 44004042  XER: 20000000
> > Mar 31 14:01:28 ps3 kernel: [ 1437.168636] TASK = c0000000069811c0[111] 'khubd' THREAD: c000000006984000 CPU: 0
> > Mar 31 14:01:28 ps3 kernel: [ 1437.168853] GPR00: c0000000005777f8 c000000006987690 c000000000639b20 0000000000000000 
> > Mar 31 14:01:28 ps3 kernel: [ 1437.173362] GPR04: c0000000000d1504 d0000000029ced10 0000000000000000 c00000000065dc68 
> > Mar 31 14:01:28 ps3 kernel: [ 1437.177894] GPR08: 0000000000000000 c0000000005777f8 d0000000028092f8 c0000000005777f8 
> > Mar 31 14:01:28 ps3 kernel: [ 1437.182439] GPR12: d0000000029d53f0 c000000000664200 00000000000000e9 c000000006d71830 
> > Mar 31 14:01:28 ps3 kernel: [ 1437.186985] GPR16: 00000000000003e8 0000000000000000 c000000006de9400 c000000006d71830 
> > Mar 31 14:01:28 ps3 kernel: [ 1437.191559] GPR20: 0000000000000000 0000000000000000 c000000006cc6000 c000000006cc6000 
> > Mar 31 14:01:28 ps3 kernel: [ 1437.196120] GPR24: 0000000000000001 c000000006cc63a0 c000000006bf90e8 c00000000122c800 
> > Mar 31 14:01:28 ps3 kernel: [ 1437.200676] GPR28: 0000000000000001 c00000000312a000 d000000002b5c080 d0000000028092f8 
> > Mar 31 14:01:28 ps3 kernel: [ 1437.209542] NIP [c00000000008ae54] .symbol_put_addr+0x34/0x64
> > Mar 31 14:01:28 ps3 kernel: [ 1437.214040] LR [c00000000008ae4c] .symbol_put_addr+0x2c/0x64
> > Mar 31 14:01:28 ps3 kernel: [ 1437.218494] Call Trace:
> > Mar 31 14:01:28 ps3 kernel: [ 1437.222885] [c000000006987690] [0000000000000001] 0x1 (unreliable)
> > Mar 31 14:01:28 ps3 kernel: [ 1437.227447] [c000000006987710] [d0000000029ce2e0] .dvb_frontend_detach+0x80/0x10c [dvb_core]
> > Mar 31 14:01:28 ps3 kernel: [ 1437.232018] [c0000000069877a0] [d000000002b4f088] .dvb_usb_adapter_frontend_exit+0x30/0x4c [dvb_usb]
> > Mar 31 14:01:28 ps3 kernel: [ 1437.236598] [c000000006987820] [d000000002b4e4ec] .dvb_usb_exit+0x3c/0xf0 [dvb_usb]
> > Mar 31 14:01:28 ps3 kernel: [ 1437.241189] [c0000000069878c0] [d000000002b4e5ec] .dvb_usb_device_exit+0x4c/0x74 [dvb_usb]
> > Mar 31 14:01:28 ps3 kernel: [ 1437.245784] [c000000006987940] [c000000000279ca0] .usb_unbind_interface+0x7c/0x138
> > Mar 31 14:01:28 ps3 kernel: [ 1437.250348] [c0000000069879e0] [c0000000002430e8] .__device_release_driver+0xb8/0x100
> > Mar 31 14:01:28 ps3 kernel: [ 1437.254936] [c000000006987a70] [c00000000024325c] .device_release_driver+0x30/0x54
> > Mar 31 14:01:28 ps3 kernel: [ 1437.259518] [c000000006987b00] [c0000000002423a4] .bus_remove_device+0xe4/0x124
> > Mar 31 14:01:28 ps3 kernel: [ 1437.264104] [c000000006987b90] [c00000000023ff98] .device_del+0x178/0x1f8
> > Mar 31 14:01:28 ps3 kernel: [ 1437.268631] [c000000006987c20] [c000000000276eb4] .usb_disable_device+0xb0/0x168
> > Mar 31 14:01:28 ps3 kernel: [ 1437.273175] [c000000006987cc0] [c000000000271630] .usb_disconnect+0xc0/0x158
> > Mar 31 14:01:28 ps3 kernel: [ 1437.277606] [c000000006987d70] [c00000000027260c] .hub_thread+0x538/0xf14
> > Mar 31 14:01:28 ps3 kernel: [ 1437.281894] [c000000006987f00] [c00000000006c298] .kthread+0x78/0xc4
> > Mar 31 14:01:28 ps3 kernel: [ 1437.286192] [c000000006987f90] [c0000000000209e8] .kernel_thread+0x54/0x70
> > Mar 31 14:01:28 ps3 kernel: [ 1437.290510] Instruction dump:
> > Mar 31 14:01:28 ps3 kernel: [ 1437.294762] 7c0802a6 f8010010 7c7f1b78 f821ff81 4bfde4fd 60000000 2fa30000 409e0030 
> > Mar 31 14:01:28 ps3 kernel: [ 1437.299233] 7fe3fb78 4bffc3b9 2fa30000 409e000c <0fe00000> 48000000 38210080 e8010010 
> > Mar 31 14:01:28 ps3 kernel: [ 1437.304457] ---[ end trace d1da44b3213415b8 ]---
> 
> Is it a post-2.6.29 regression?

The support for Sony PlayTV was added to the dib0700 driver after 2.6.29.
But it also happened with another DVB-T USB stick that uses the same driver.

I'll see if I can get ahold of the other one again and try on 2.6.29...

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
