Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:64620 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754152AbaKOW1i (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Nov 2014 17:27:38 -0500
Received: from [192.168.178.20] ([79.215.128.214]) by mail.gmx.com (mrgmx001)
 with ESMTPSA (Nemesis) id 0MSdNs-1XOF3D2A5M-00RWTE for
 <linux-media@vger.kernel.org>; Sat, 15 Nov 2014 23:27:35 +0100
Message-ID: <5467D356.6080504@gmx.net>
Date: Sat, 15 Nov 2014 23:27:34 +0100
From: JPT <j-p-t@gmx.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: kernel panic in DVB code
Content-Type: multipart/mixed;
 boundary="------------000508040000030103030100"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000508040000030103030100
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hi,

I am using DVB on ARM and believe this is a little bit instable.
Is this trace of any use to you?

Please don't care about this only because of me. It is the first time
this occured in 6 weeks, so fixing it is not important to me.
I only wanted to report in case it was helpful to anyone for finding
bugs in the dvb code. (I know from java the value of real-live stack-traces)

It's a self built 3.17.2 kernel with a small patch in the DVB USB buffer
size. I can supply the .config or binary if needed.

I cannot find any suspect entry in the syslog just before the crash.
There are only a few cron entries issuing php scripts.

regards,

Jan




--------------000508040000030103030100
Content-Type: text/x-log;
 name="kernelpanic.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="kernelpanic.log"

Unhandled prefetch abort: unknown 25 (0x409) at 0xc02fc948
Internal error: : 409 [#1] ARM
Modules linked in: ir_lirc_codec ir_xmp_decoder lirc_dev ir_mce_kbd_decoder ir_sharp_decoder ir_sanyo_decoder ir_sony_decoder ir_jvc_decoder ir_rc6_decoder ir_rc5_decoder ir_nec_decoder rc_technisat_usb2 stv6110x usblp dvb_usb_technisat_usb2 dvb_usb dvb_core stv090x rc_core
CPU: 0 PID: 0 Comm: swapper Not tainted 3.17.2-rn104-jpt9 #6
task: c08459f0 ti: c0838000 task.ti: c0838000
PC is at crc32_be+0x40/0x168
LR is at 0xc083dff0
pc : [<c02fc948>]    lr : [<c083dff0>]    psr: 20000193
sp : c0839d74  ip : 65622065  fp : 00000067
r10: e0aef730  r9 : 00000049  r8 : e9bf7754
r7 : aa9e5f03  r6 : d98cdd52  r5 : 6965ba03  r4 : c083f9d4
r3 : 6964206e  r2 : 00000000  r1 : e0aef640  r0 : 9e5bff47
Flags: nzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: 10c5387d  Table: 1de78019  DAC: 00000015
Process swapper (pid: 0, stack limit = 0xc0838240)
Stack: (0xc0839d74 to 0xc083a000)
9d60:                                              e0aef62c e0adf30c 00000338
9d80: e0aef62c e0af062c 00000000 00000000 df64f000 bf01dbc8 00000397 bf01c7ec
9da0: 00000020 c084004c df64f000 00000397 00000001 e0aef62c e0af062c 00000012
9dc0: df414b78 e082a017 00000000 00000000 df64f000 bf01cef4 91dd391e 00001d7d
9de0: c08d2e40 e083aa58 00000000 00000000 00000003 c005541c c08d2f70 df414a78
9e00: 20000193 00000400 e082a000 000000d3 000003e9 c084004c df64f000 bf01d14c
9e20: dec2c200 00000001 00000000 df414ce0 dec2c200 e082a000 c084004c bf03bebc
9e40: dec2c200 00000000 60000193 dec2c200 df67f000 e09b35d0 c084004c c0401e44
9e60: e09b3640 00000000 00000001 c042a8d0 c0839ebc 00000000 c084a6e8 c003df38
9e80: ddeacb40 00000040 00000200 dee46580 0000000d 00000000 00000001 de56e7e0
9ea0: 1f4e00b0 df67f1d4 00000004 0000000d 0d000400 00001d81 7074aa2f 00000000
9ec0: c0839ec0 df610880 0000006b 00000000 00000000 0000006b df778300 c08813ff
9ee0: 00000000 c0048f40 c0838000 c004e918 df778300 0000006b 00000000 c0839f70
9f00: 00000000 dfffcc00 c082e350 c0049030 0000006b c004b1d8 c0838028 0000006b
9f20: 0000006b c004886c c085dfac c000f608 00000011 00020000 c08ddb40 c030bba0
9f40: c08ddb40 000003ff c0839f70 c08ddb40 c08813fd c00084f0 c0040a54 60000013
9f60: ffffffff c0839fa4 c08813fd c00126c0 00000000 c084a698 00000000 c001911c
9f80: c0838000 c08400dc c0838038 c08813fd c08813fd dfffcc00 c082e350 00000000
9fa0: 01000000 c0839fb8 c000f75c c0040a54 60000013 ffffffff c0840000 c0805c04
9fc0: ffffffff ffffffff c0805610 00000000 00000000 c082e350 c088ded4 c0840078
9fe0: c082e34c c0846a60 00004059 561f5811 00000000 00008070 00000000 00000000
[<c02fc948>] (crc32_be) from [<bf01dbc8>] (dvb_dmx_crc32+0x10/0x18 [dvb_core])
[<bf01dbc8>] (dvb_dmx_crc32 [dvb_core]) from [<bf01c7ec>] (dvb_dmx_swfilter_section_copy_dump+0x254/0x268 [dvb_core])
[<bf01c7ec>] (dvb_dmx_swfilter_section_copy_dump [dvb_core]) from [<bf01cef4>] (dvb_dmx_swfilter_packet+0x45c/0x564 [dvb_core])
[<bf01cef4>] (dvb_dmx_swfilter_packet [dvb_core]) from [<bf01d14c>] (dvb_dmx_swfilter+0xf4/0x164 [dvb_core])
[<bf01d14c>] (dvb_dmx_swfilter [dvb_core]) from [<bf03bebc>] (usb_urb_complete+0xbc/0xe4 [dvb_usb])
[<bf03bebc>] (usb_urb_complete [dvb_usb]) from [<c0401e44>] (__usb_hcd_giveback_urb+0x5c/0xe8)
[<c0401e44>] (__usb_hcd_giveback_urb) from [<c042a8d0>] (xhci_irq+0x8d8/0x1e08)
[<c042a8d0>] (xhci_irq) from [<c0048f40>] (handle_irq_event_percpu+0x78/0x140)
[<c0048f40>] (handle_irq_event_percpu) from [<c0049030>] (handle_irq_event+0x28/0x38)
[<c0049030>] (handle_irq_event) from [<c004b1d8>] (handle_simple_irq+0x64/0xa8)
[<c004b1d8>] (handle_simple_irq) from [<c004886c>] (generic_handle_irq+0x2c/0x3c)
[<c004886c>] (generic_handle_irq) from [<c000f608>] (handle_IRQ+0x38/0x84)
[<c000f608>] (handle_IRQ) from [<c030bba0>] (armada_370_xp_handle_msi_irq+0x9c/0xa0)
[<c030bba0>] (armada_370_xp_handle_msi_irq) from [<c00084f0>] (armada_370_xp_handle_irq+0x5c/0x60)
[<c00084f0>] (armada_370_xp_handle_irq) from [<c00126c0>] (__irq_svc+0x40/0x54)
Exception stack(0xc0839f70 to 0xc0839fb8)
9f60:                                     00000000 c084a698 00000000 c001911c
9f80: c0838000 c08400dc c0838038 c08813fd c08813fd dfffcc00 c082e350 00000000
9fa0: 01000000 c0839fb8 c000f75c c0040a54 60000013 ffffffff
[<c00126c0>] (__irq_svc) from [<c0040a54>] (cpu_startup_entry+0xa8/0xf4)
[<c0040a54>] (cpu_startup_entry) from [<c0805c04>] (start_kernel+0x3b0/0x3bc)
Code: e59a3004 e2599001 e5bac008 e0200003 (e7e7745c) 
---[ end trace 2c8c481652a246a4 ]---
Kernel panic - not syncing: Fatal exception in interrupt
---[ end Kernel panic - not syncing: Fatal exception in interrupt

--------------000508040000030103030100--
