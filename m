Return-path: <mchehab@pedra>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37646 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987Ab1DZLSp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Apr 2011 07:18:45 -0400
Received: by iyb14 with SMTP id 14so406943iyb.19
        for <linux-media@vger.kernel.org>; Tue, 26 Apr 2011 04:18:45 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 26 Apr 2011 13:18:44 +0200
Message-ID: <BANLkTim9-Q2J18WMEzaMrTrXYDLqwkOgag@mail.gmail.com>
Subject: Problems with omap3isp + mt9p031 in Beagleboard xM.
From: javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,
I'm trying to port Guennadi's patches
(http://download.open-technology.de/BeagleBoard_xM-MT9P031/) to last
mainline kernel 2.6.39-rc.

I've managed to compile and configure the video interface using the
suggested commands:

root@beagleboard:~# ./media-ctl -r -l '"mt9p031 2-0048":0->"OMAP3 ISP
CCDC":0[1], "OMAP3 ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'
Resetting all links to inactive
Setting up link 16:0 -> 5:0 [1]
Setting up link 5:1 -> 6:0 [1]

root@beagleboard:~# ./media-ctl -f '"mt9p031 2-0048":0[SGRBG8
320x240], "OMAP3 ISP CCDC":1[SGRBG8 320x240]'
Setting up forma[   75.031677] mt9p031_set_format(320x240 : 1)
t SGRBG8 320x240 on pad mt9p031 2-0048/0
Format set: SGRBG8 320x240
Setting up format SGRBG8 320x240 on pad OMAP3 ISP CCDC/0
Format set: SGRBG8 320x240
Setting up format SGRBG8 320x240 on pad OMAP3 ISP CCDC/1
Format set: SGRBG8 320x240

However, when I try to capture some frames using yavta I get the following:

root@beagleboard:~# ./yavta -f SGRBG8 -s 320x240 -n 4 --capture=10
--skip 3 -F `./media-ctl -e "OMAP3 ISP CCDC output"`
Device /dev/video2 opened: OMAP3 ISP CCDC output (media).
Video[   81.140228] mt9p031_get_format()
 format set: width: 320 height: 240 buffer size: 76800
Video format: GRBG (47425247) 320x240
4 buffers requested.
length: 76800 offset: 0
Buffer 0 mapped at address 0x400c2000.
length: 76800 offset: 77824
Buffer 1 mapped at address 0x40213000.
length: 76800 offset: 155648
Buffer 2 mapped at address 0x40293000.
length: 76800 offset: 233472
Buffer 3 mapped at address 0x40344000.
[   81.268341] omap-iommu omap-iommu.0: isp: errs:0x00000000
da:0x00000000 pgd:0xdedb0000 *pgd:0x9e00fc01 pte:0xde00fc00
*pte:0x00000000
[   81.282775] omap-iommu omap-iommu.0: isp: errs:0x00000000
da:0x00000000 pgd:0xdedb0000 *pgd:0x9e00fc01 pte:0xde00fc00
*pte:0x00000000
[   81.498962] omap-iommu omap-iommu.0: isp: errs:0x00000000
da:0x00000000 pgd:0xdedb0000 *pgd:0x9e00fc01 pte:0xde00fc00
*pte:0x00000000
[   81.512634] omap-iommu omap-iommu.0: isp: errs:0x00000000
da:0x00000000 pgd:0xdedb0000 *pgd:0x9e00fc01 pte:0xde00fc00
*pte:0x00000000
[   81.604614] irq 10: nobody cared (try booting with the "irqpoll" option)
[   81.611663] [<c006c6e8>] (unwind_backtrace+0x0/0xec) from
[<c00d81cc>] (__report_bad_irq+0x30/0xa4)
[   81.621124] [<c00d81cc>] (__report_bad_irq+0x30/0xa4) from
[<c00d83d4>] (note_interrupt+0x194/0x230)
[   81.630645] [<c00d83d4>] (note_interrupt+0x194/0x230) from
[<c00d6964>] (handle_irq_event_percpu+0x1c0/0x1ec)
[   81.641021] [<c00d6964>] (handle_irq_event_percpu+0x1c0/0x1ec) from
[<c00d69d4>] (handle_irq_event+0x44/0x64)
[   81.651367] [<c00d69d4>] (handle_irq_event+0x44/0x64) from
[<c00d8f78>] (handle_level_irq+0xd4/0x118)
[   81.661010] [<c00d8f78>] (handle_level_irq+0xd4/0x118) from
[<c005b08c>] (asm_do_IRQ+0x8c/0xcc)
[   81.670104] [<c005b08c>] (asm_do_IRQ+0x8c/0xcc) from [<c04861d8>]
(__irq_svc+0x38/0x100)
[   81.678558] Exception stack(0xc061fef0 to 0xc061ff38)
[   81.683837] fee0:                                     c0620600
00000000 c06a6be0 00000000
[   81.692352] ff00: 0000000a c061e000 c0694b60 00000000 00000100
0000000a 00000000 00000000
[   81.700897] ff20: 0000000f c061ff38 c00a4ba8 c00a48ac 20000113 ffffffff
[   81.707824] [<c04861d8>] (__irq_svc+0x38/0x100) from [<c00a48ac>]
(__do_softirq+0x58/0x1b8)
[   81.716552] [<c00a48ac>] (__do_softirq+0x58/0x1b8) from
[<c00a4ba8>] (irq_exit+0x48/0x94)
[   81.725097] [<c00a4ba8>] (irq_exit+0x48/0x94) from [<c005b090>]
(asm_do_IRQ+0x90/0xcc)
[   81.733367] [<c005b090>] (asm_do_IRQ+0x90/0xcc) from [<c04861d8>]
(__irq_svc+0x38/0x100)
[   81.741790] Exception stack(0xc061ff88 to 0xc061ffd0)
[   81.747070] ff80:                   00000000 c062d238 00000000
c0695600 c061e000 c0694bdc
[   81.755615] ffa0: c0694b60 c06309ec 80000000 413fc082 00000000
00000000 c0af0db8 c061ffd0
[   81.764160] ffc0: c0079294 c0067280 60000013 ffffffff
[   81.769439] [<c04861d8>] (__irq_svc+0x38/0x100) from [<c0067280>]
(cpu_idle+0x94/0xec)
[   81.777709] [<c0067280>] (cpu_idle+0x94/0xec) from [<c0008944>]
(start_kernel+0x284/0x2d8)
[   81.786346] [<c0008944>] (start_kernel+0x284/0x2d8) from
[<8000803c>] (0x8000803c)
[   81.794219] handlers:
[   81.796600] [<c00808a8>] (omap3_l3_app_irq+0x0/0x2c0)
[   81.801910] Disabling IRQ #10
[   81.805023] omap-iommu omap-iommu.0: isp: errs:0x00000000
da:0x00000000 pgd:0xdedb0000 *pgd:0x9e00fc01 pte:0xde00fc00
*pte:0x00000000
0 (0) [-] 4294967295 76800 bytes 81.323760 1303817702.952038 0.001 fps
1 (1) [-] 4294967295 76800 bytes 81.553651 1303817702.952679 4.350 fps
2 (2) [-] 429496[   81.833038] omap-iommu omap-iommu.0: isp:
errs:0x00000000 da:0x00000000 pgd:0xdedb0000 *pgd:0x9e00fc01
pte:0xde00fc00 *pte:0x00000000
7295 76800 bytes[   81.846679] omap-iommu omap-iommu.0: isp:
errs:0x00000000 da:0x00000000 pgd:0xdedb0000 *pgd:0x9e00fc01
pte:0xde00fc00 *pte:0x00000000
 81.846081 1303817702.953075 3.420 fps
3 (3) [-] 4294967295 76800 bytes 81.888578 1303817702.993009 23.531 fps
[   81.944396] omap-iommu omap-iommu.0: isp: errs:0x00000000
da:0x00000000 pgd:0xdedb0000 *pgd:0x9e00fc01 pte:0xde00fc00
*pte:0x00000000
[   81.958038] omap-iommu omap-iommu.0: isp: errs:0x00000000
da:0x00000000 pgd:0xdedb0000 *pgd:0x9e00fc01 pte:0xde00fc00
*pte:0x00000000
4 (0) [-] 4294967295 76800 bytes 81.999073 1303817703.103504 9.050 fps
[   82.055755] omap-iommu omap-iommu.0: isp: errs:0x00000000
da:0x00000000 pgd:0xdedb0000 *pgd:0x9e00fc01 pte:0xde00fc00
*pte:0x00000000
[   82.069396] omap-iommu omap-iommu.0: isp: errs:0x00000000
da:0x00000000 pgd:0xdedb0000 *pgd:0x9e00fc01 pte:0xde00fc00
*pte:0x00000000
5 (1) [-] 4294967295 76800 bytes 82.110380 1303817703.215391 8.984 fps
[   82.167114] omap-iommu omap-iommu.0: isp: errs:0x00000000
da:0x00000000 pgd:0xdedb0000 *pgd:0x9e00fc01 pte:0xde00fc00
*pte:0x00000000
[   82.180755] omap-iommu omap-iommu.0: isp: errs:0x00000000
da:0x00000000 pgd:0xdedb0000 *pgd:0x9e00fc01 pte:0xde00fc00
*pte:0x00000000
6 (2) [-] 4294967295 76800 bytes 82.221743 1303817703.326723 8.980 fps
[   82.278442] omap-iommu omap-iommu.0: isp: errs:0x00000000
da:0x00000000 pgd:0xdedb0000 *pgd:0x9e00fc01 pte:0xde00fc00
*pte:0x00000000
[   82.292114] omap-iommu omap-iommu.0: isp: errs:0x00000000
da:0x00000000 pgd:0xdedb0000 *pgd:0x9e00fc01 pte:0xde00fc00
*pte:0x00000000
7 (3) [-] 4294967295 76800 bytes 82.333128 1303817703.437529 8.978 fps
[   82.389801] omap-iommu omap-iommu.0: isp: errs:0x00000000
da:0x00000000 pgd:0xdedb0000 *pgd:0x9e00fc01 pte:0xde00fc00
*pte:0x00000000
[   82.403442] omap-iommu omap-iommu.0: isp: errs:0x00000000
da:0x00000000 pgd:0xdedb0000 *pgd:0x9e00fc01 pte:0xde00fc00
*pte:0x00000000
8 (0) [-] 4294967295 76800 bytes 82.444457 1303817703.549407 8.982 fps
[   82.501159] omap-iommu omap-iommu.0: isp: errs:0x00000000
da:0x00000000 pgd:0xdedb0000 *pgd:0x9e00fc01 pte:0xde00fc00
*pte:0x00000000
[   82.514801] omap-iommu omap-iommu.0: isp: errs:0x00000000
da:0x00000000 pgd:0xdedb0000 *pgd:0x9e00fc01 pte:0xde00fc00
*pte:0x00000000
9 (1) [-] 4294967295 76800 bytes 82.555816 1303817703.660736 8.980 fps
[   82.612518] omap-iommu omap-iommu.0: isp: errs:0x00000000
da:0x00000000 pgd:0xdedb0000 *pgd:0x9e00fc01 pte:0xde00fc00
*pte:0x00000000
[   82.626159] omap-iommu omap-iommu.0: isp: errs:0x00000000
da:0x00000000 pgd:0xdedb0000 *pgd:0x9e00fc01 pte:0xde00fc00
*pte:0x00000000
Captured 10 frames in 1.377928 seconds (7.257273 fps, 557358.584774 B/s).
4 buffers released.


And the image files I get are filled with 5555 instead of useful data.

Does anybody know whether those iommu errors are harmless?
Do I need to enable CAM mux inside
arch/arm/mach-omap2/board-omap3beagle.c which are currently disabled
using an ifdef?

Thank you.
-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
