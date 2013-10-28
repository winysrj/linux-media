Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.fpasia.hk ([202.130.89.98]:53591 "EHLO fpa01n0.fpasia.hk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756441Ab3J1MQ1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Oct 2013 08:16:27 -0400
Received: from localhost (localhost [127.0.0.1])
	by fpa01n0.fpasia.hk (Postfix) with ESMTP id 9D568CC9269
	for <linux-media@vger.kernel.org>; Mon, 28 Oct 2013 20:16:22 +0800 (HKT)
Received: from fpa01n0.fpasia.hk ([127.0.0.1])
	by localhost (fpa01n0.office.fpa.com.hk [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Vby6bErVaaMt for <linux-media@vger.kernel.org>;
	Mon, 28 Oct 2013 20:16:20 +0800 (HKT)
Received: from s01.gtsys.com.hk (gtsnode.office.fpasia.hk [10.10.37.40])
	by fpa01n0.fpasia.hk (Postfix) with ESMTP id 78E0CCC9268
	for <linux-media@vger.kernel.org>; Mon, 28 Oct 2013 20:16:20 +0800 (HKT)
Received: from [192.168.10.46] (unknown [118.140.73.106])
	by s01.gtsys.com.hk (Postfix) with ESMTPSA id 7B462C0274A
	for <linux-media@vger.kernel.org>; Mon, 28 Oct 2013 20:16:18 +0800 (HKT)
Message-ID: <526E55DA.3070007@gtsys.com.hk>
Date: Mon, 28 Oct 2013 20:17:30 +0800
From: Chris Ruehl <chris.ruehl@gtsys.com.hk>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: imx27.dtsi usbotg/usbh2 oops in fsl_usb2_mph_dr_of_probe
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

when tried to activate the USB-OTG or USBH2 with the FDT the system oops


[    1.034403] ehci-mxc: Freescale On-Chip EHCI Host driver
[    1.041158] Unable to handle kernel NULL pointer dereference at 
virtual address 00000000
[    1.049406] pgd = c0004000
[    1.052219] [00000000] *pgd=00000000
[    1.055868] Internal error: Oops: 5 [#1] ARM
[    1.060167] Modules linked in:
[    1.063287] CPU: 0 PID: 1 Comm: swapper Not tainted 3.12.0-rc7 #2
[    1.069429] task: c7836000 ti: c783c000 task.ti: c783c000
[    1.074888] PC is at fsl_usb2_mph_dr_of_probe+0x314/0x428
[    1.080342] LR is at platform_device_alloc+0x5c/0x6c
[    1.085362] pc : [<c028c3b4>]    lr : [<c021c5c4>] psr: a0000013
[    1.085362] sp : c783dd68  ip : 00000000  fp : c783ddf4
[    1.096888] r10: c7872500  r9 : c79ed600  r8 : 00000002
[    1.102154] r7 : c0564c40  r6 : 00000000  r5 : c7873110  r4 : c7873100
[    1.108722] r3 : 00000000  r2 : ffffffff  r1 : 00000000  r0 : c79ed600
[    1.115291] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM 
Segment kernel
[    1.122643] Control: 0005317f  Table: a0004000  DAC: 00000017
[    1.128427] Process swapper (pid: 1, stack limit = 0xc783c1c0)
[    1.134299] Stack: (0xc783dd68 to 0xc783e000)
[    1.138718] dd60:                   c783dd94 c0564c40 c00dac3c 
00000000 00000001 00000001
[    1.146962] dd80: 00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000010
[    1.155204] dda0: 00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000000
[    1.163452] ddc0: 00000000 00000000 c783dde4 c7873110 c7873144 
c0564c00 c058f0b0 00000000
[    1.171703] dde0: c783c020 00000000 c783de04 c783ddf8 c021bde0 
c028c0b0 c783de24 c783de08
[    1.179953] de00: c021ab48 c021bdd4 c7873110 c7873144 c0564c00 
00000000 c783de44 c783de28
[    1.188204] de20: c021ad40 c021aaac c021acd0 00000000 c0564c00 
c021acd0 c783de6c c783de48
[    1.196457] de40: c02191c4 c021ace0 c7823f4c c786a450 c79f77b4 
c0564c00 c055b2b0 c79f7780
[    1.204709] de60: c783de7c c783de70 c021a6ac c0219158 c783dea4 
c783de80 c021a23c c021a69c
[    1.212962] de80: c04d71b6 c783de90 c0564c00 c053ae0c c0530264 
c0572980 c783debc c783dea8
[    1.221213] dea0: c021b384 c021a168 00000006 c053ae0c c783decc 
c783dec0 c021c3a8 c021b2f0
[    1.229466] dec0: c783dedc c783ded0 c053027c c021c368 c783df54 
c783dee0 c000888c c0530274
[    1.237719] dee0: c00d2cb8 c00d29c8 c783df0c c783def8 c051b400 
c01c8b84 c069ca87 c069ca8c
[    1.245969] df00: c783df54 c783df10 c002c26c c051b4d8 00000000 
c05198fc 00000006 00000006
[    1.254219] df20: 00000086 c051909c c00313d0 00000006 00000006 
c053ae0c c053fb70 c0572980
[    1.262469] df40: c0572980 00000086 c783df94 c783df58 c051bb50 
c0008804 00000006 00000006
[    1.270717] df60: c051b4c8 c783df10 00000001 01234567 00000000 
c03f72fc 00000000 00000000
[    1.278964] df80: 00000000 00000000 c783dfac c783df98 c03f730c 
c051ba60 00000000 00000000
[    1.287212] dfa0: 00000000 c783dfb0 c0009450 c03f730c 00000000 
00000000 00000000 00000000
[    1.295453] dfc0: 00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000000
[    1.303696] dfe0: 00000000 00000000 00000000 00000000 00000013 
00000000 00000000 00000000
[    1.311897] Backtrace:
[    1.314448] [<c028c0a0>] (fsl_usb2_mph_dr_of_probe+0x0/0x428) from 
[<c021bde0>] (platform_drv_probe+0x1c/0x20)
[    1.324544] [<c021bdc4>] (platform_drv_probe+0x0/0x20) from 
[<c021ab48>] (driver_probe_device+0xac/0x1e8)
[    1.334204] [<c021aa9c>] (driver_probe_device+0x0/0x1e8) from 
[<c021ad40>] (__driver_attach+0x70/0x94)
[    1.343544]  r7:00000000 r6:c0564c00 r5:c7873144 r4:c7873110
[    1.349383] [<c021acd0>] (__driver_attach+0x0/0x94) from [<c02191c4>] 
(bus_for_each_dev+0x7c/0x90)
[    1.358375]  r6:c021acd0 r5:c0564c00 r4:00000000 r3:c021acd0
[    1.364210] [<c0219148>] (bus_for_each_dev+0x0/0x90) from 
[<c021a6ac>] (driver_attach+0x20/0x28)
[    1.373026]  r6:c79f7780 r5:c055b2b0 r4:c0564c00
[    1.377796] [<c021a68c>] (driver_attach+0x0/0x28) from [<c021a23c>] 
(bus_add_driver+0xe4/0x24c)
[    1.386573] [<c021a158>] (bus_add_driver+0x0/0x24c) from [<c021b384>] 
(driver_register+0xa4/0xe8)
[    1.395478]  r7:c0572980 r6:c0530264 r5:c053ae0c r4:c0564c00
[    1.401303] [<c021b2e0>] (driver_register+0x0/0xe8) from [<c021c3a8>] 
(__platform_driver_register+0x50/0x64)
[    1.411163]  r5:c053ae0c r4:00000006
[    1.414862] [<c021c358>] (__platform_driver_register+0x0/0x64) from 
[<c053027c>] (fsl_usb2_mph_dr_driver_init+0x18/0x20)
[    1.425812] [<c0530264>] (fsl_usb2_mph_dr_driver_init+0x0/0x20) from 
[<c000888c>] (do_one_initcall+0x98/0x140)
[    1.435889] [<c00087f4>] (do_one_initcall+0x0/0x140) from 
[<c051bb50>] (kernel_init_freeable+0x100/0x1c4)
[    1.445488]  r9:00000086 r8:c0572980 r7:c0572980 r6:c053fb70 r5:c053ae0c
r4:00000006
[    1.453532] [<c051ba50>] (kernel_init_freeable+0x0/0x1c4) from 
[<c03f730c>] (kernel_init+0x10/0xec)
[    1.462610]  r9:00000000 r8:00000000 r7:00000000 r6:00000000 r5:c03f72fc
r4:00000000
[    1.470645] [<c03f72fc>] (kernel_init+0x0/0xec) from [<c0009450>] 
(ret_from_fork+0x14/0x24)
[    1.479027]  r4:00000000 r3:00000000
[    1.482703] Code: e1c429d0 e1c929f0 e599c08c e594108c (e1c120d0)
[    1.489025] ---[ end trace 1b9409ded9abd572 ]---
[    1.493810] Kernel panic - not syncing: Attempted to kill init! 
exitcode=0x0000000b

config: (imx27.dtsi)

             usbotg: usb@10024000 {
                 compatible = "fsl-usb2-dr";
                 reg = <0x10024000 0x200>;
                 interrupts = <56>;
                 dr_mode = "host";
                 phy_type = "ulpi";
                 status = "disabled";
             };

some help welcome.
Chris

