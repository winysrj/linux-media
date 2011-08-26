Return-path: <linux-media-owner@vger.kernel.org>
Received: from hermes.mlbassoc.com ([64.234.241.98]:43164 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213Ab1HZKwW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Aug 2011 06:52:22 -0400
Message-ID: <4E577AE3.5020304@mlbassoc.com>
Date: Fri, 26 Aug 2011 04:52:19 -0600
From: Gary Thomas <gary@mlbassoc.com>
MIME-Version: 1.0
To: Enrico <ebutera@users.berlios.de>
CC: linux-media@vger.kernel.org
Subject: Re: omap3isp and tvp5150 hangs
References: <CA+2YH7tJjssZs6-tQibHGYZw_t0xdu9d0PJBKkMaXn79=VFJ8g@mail.gmail.com>
In-Reply-To: <CA+2YH7tJjssZs6-tQibHGYZw_t0xdu9d0PJBKkMaXn79=VFJ8g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2011-08-26 04:42, Enrico wrote:
> Hi,
>
> i need some help to debug a kernel hang on an igep board (+ expansion)
>   when using omap3-isp and tvp5150 video capture. Kernel version is
> mainline 3.0.1
>
> When i modprobe omap3-isp (after iommu2) the device is correctly recognized:
>
> root@igep0020:~# modprobe omap3-isp
> [  122.162200] Linux video capture interface: v2.00
> [  122.183319] _regulator_get: omap3isp supply VDD_CSIPHY1 not found,
> using dummy regulator
> [  122.192413] _regulator_get: omap3isp supply VDD_CSIPHY2 not found,
> using dummy regulator
> [  122.201416] omap3isp omap3isp: Revision 2.0 found
> [  122.206390] omap-iommu omap-iommu.0: isp: version 1.1
> [  122.262359] tvp5150 2-005c: chip found @ 0xb8 (OMAP I2C adapter)
> [  122.363830] tvp5150 2-005c: *** unknown tvp5151 chip detected.
> [  122.369964] tvp5150 2-005c: *** Rom ver is 1.0
>
> but then it immediatly hangs. Sysrq show regs:

I found that this driver is not compatible with the [new] v4l2_subdev setup.
In particular, it does not define any "pads" and the call to media_entity_create_link()
in omap3isp/isp.c:1803 fires a BUG_ON() for this condition.

>
> [  125.420349] Pid: 310, comm:             modprobe
> [  125.425170] CPU: 0    Not tainted  (3.0.1+ #22)
> [  125.429931] PC is at media_entity_create_link+0x3c/0xe8
> [  125.435485] LR is at isp_probe+0x770/0x97c [omap3_isp]
> [  125.440887] pc : [<c03420b8>]    lr : [<bf0ddd80>]    psr: 60000013
> [  125.440887] sp : de405de8  ip : 00000000  fp : c0615998
> [  125.452911] r10: de468800  r9 : 00000000  r8 : c062f088
> [  125.458374] r7 : deefdc78  r6 : 00000000  r5 : 00000000  r4 :
> 00000000
> [  125.465240] r3 : 00000000  r2 : deefdc78  r1 : 00000000  r0 :
> de468800
> [  125.472076] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
> [  125.479553] Control: 10c5387d  Table: 9e418019  DAC: 00000015
>
>
> Since i had to manually edit default u-boot mux data for some pins,
> can you confirm this is the right setup? Don't look at the comments
> because for now i didn't update them to match mux config.
>
> CAM_WEN and CAM_STROBE are used for reset/power down and are
> configured as gpios.
>
> MUX_VAL(CP(CAM_HS),            (IEN | PTU | EN | M0)) /* GPIO_94 - PDN
> (Rev. B) */\
> MUX_VAL(CP(CAM_VS),            (IEN | PTU | EN | M0)) /* GPIO_95 -
> RESET_N_W (Rev. B) */\
>
> MUX_VAL(CP(CAM_XCLKA),       (IDIS | PTD | DIS | M0)) /* CAM_XCLKA */\
> MUX_VAL(CP(CAM_PCLK),         (IEN  | PTU | EN  | M0)) /* CAM_PCLK  */\
> MUX_VAL(CP(CAM_FLD),            (IEN  | PTD | DIS | M0)) /* GPIO_98   */\
> MUX_VAL(CP(CAM_XCLKB),       (IDIS | PTD | DIS | M0)) /* CAM_XCLKB */\
>
> MUX_VAL(CP(CAM_D0),            (IEN | PTD | DIS | M0)) /* GPIO_99   */\
> MUX_VAL(CP(CAM_D1),            (IEN | PTD | DIS | M0)) /* GPIO_100  */\
> MUX_VAL(CP(CAM_D2),            (IEN  | PTD | DIS | M0)) /* CAM_D2    */\
> MUX_VAL(CP(CAM_D3),            (IEN  | PTD | DIS | M0)) /* CAM_D3    */\
> MUX_VAL(CP(CAM_D4),            (IEN  | PTD | DIS | M0)) /* CAM_D4    */\
> MUX_VAL(CP(CAM_D5),            (IEN  | PTD | DIS | M0)) /* CAM_D5    */\
> MUX_VAL(CP(CAM_D6),            (IEN | PTD | DIS | M0)) /* GPIO_105 -
> RF_CTRL     */\
> MUX_VAL(CP(CAM_D7),            (IEN | PTD | DIS | M0)) /* GPIO_106 -
> RF_STANDBY  */\
> MUX_VAL(CP(CAM_D8),            (IEN | PTD | DIS | M0)) /* GPIO_107 -
> RF_INT      */\
> MUX_VAL(CP(CAM_D9),            (IEN | PTD | DIS | M0)) /* GPIO_108 -
> RF_SYNCB    */\
> MUX_VAL(CP(CAM_D10),           (IEN  | PTD | DIS | M0)) /* CAM_D10   */\
> MUX_VAL(CP(CAM_D11),           (IEN  | PTD | DIS | M0)) /* CAM_D11   */\
>
>
> I just tried it also with kernel 3.1.0-rc3+ from tmlind repository, it
> doesn't hang but it segfaults with:
>
> [   70.227844] kernel BUG at drivers/media/media-entity.c:346!
> [   70.239471] Unable to handle kernel NULL pointer dereference at
> virtual address 00000000
> [   70.248046] pgd = dfbec000
> [   70.250885] [00000000] *pgd=9eeb4831, *pte=00000000, *ppte=00000000
> [   70.257476] Internal error: Oops: 817 [#1]
> [   70.261779] Modules linked in: tvp5150 omap3_isp(+) v4l2_common
> videodev iovmm iommu2 iommu libertas_sdio libertas cfg80211 rfkill
> twl4030_wdt twl4030_pwrbutton omap_wdt [last unloaded: iommu]
> [   70.279785] CPU: 0    Not tainted  (3.1.0-rc3+ #2)
> [   70.284820] PC is at __bug+0x1c/0x28
> [   70.288574] LR is at __bug+0x18/0x28
> [   70.292327] pc : [<c0010430>]    lr : [<c001042c>]    psr: 20000013
> [   70.292327] sp : dec75de0  ip : 00000000  fp : c04b8a48
> [   70.304351] r10: dec1bc00  r9 : 00000000  r8 : c04c5124
> [   70.309814] r7 : dec7da68  r6 : 00000000  r5 : 00000000  r4 : 00000000
> [   70.316680] r3 : 00000000  r2 : dec75dd4  r1 : c040182a  r0 : 00000045
> [   70.323516] Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
> [   70.330993] Control: 10c5387d  Table: 9fbec019  DAC: 00000015
> [   70.337005] Process modprobe (pid: 320, stack limit = 0xdec742f0)
> [   70.343383] Stack: (0xdec75de0 to 0xdec76000)
> [   70.347961] 5de0: 00000000 c027d390 00000008 c04c51b8 dec1bc00
> c04c51b8 c04c5124 dec7da68
> [   70.356536] 5e00: dec78000 bf0e2d04 00000000 dec78000 df806f18
> dec7e0b8 dec7edd8 00000000
> [   70.365112] 5e20: c04b8a7c c04b8a48 c04b8a7c bf0f59ac bf0f59ac
> 00000000 00000023 0000001c
> [   70.373687] 5e40: 00000000 c0212c7c c0212c68 c0211c00 00000000
> c04b8a48 c04b8a7c bf0f59ac
> [   70.382263] 5e60: 00000000 c0211d1c bf0f59ac dec75e78 c0211cbc
> c0210eb0 df806ef8 df867df0
> [   70.390838] 5e80: bf0f59ac bf0f59ac ded60a40 c04df5e0 00000000
> c0211520 bf0f32c5 bf0f32ca
> [   70.399414] 5ea0: 00000033 bf0f59ac bf0f5c38 00000001 bf0fb000
> 00000000 0000001c c0212230
> [   70.408020] 5ec0: 00000000 bf0f5bf0 bf0f5c38 00000001 bf0fb000
> 00000000 0000001c c0008574
> [   70.416595] 5ee0: bf0fb000 00000000 00000001 bf0f5bf0 bf0f5bf0
> bf0f5c38 00000001 ded6cb40
> [   70.425170] 5f00: 00000001 c0058728 bf0f5bfc c00082dc c0056534
> c0354308 bf0f5d14 00de2320
> [   70.433746] 5f20: ded5d66c e0952000 00021a7a e09695d0 e0969471
> e0970fd0 dedc6000 00014d2c
> [   70.442321] 5f40: 00016fcc 00000000 00000000 00000021 00000022
> 00000016 0000001a 0000000f
> [   70.450897] 5f60: 00000000 00000000 00000000 00000000 00000000
> 00000000 00000000 c044ad1c
> [   70.459472] 5f80: 00000000 00de2070 00000000 00000000 00000080
> c000d6c4 dec74000 00000000
> [   70.468048] 5fa0: 00de2168 c000d540 00de2070 00000000 400c3000
> 00021a7a 00de2320 00000000
> [   70.476623] 5fc0: 00de2070 00000000 00000000 00000080 00000000
> 00de2070 00de2020 00de2168
> [   70.485198] 5fe0: 00de2320 beb5498c 0000b620 4024d674 60000010
> 400c3000 00000000 00000000
> [   70.493804] [<c0010430>] (__bug+0x1c/0x28) from [<c027d390>]
> (media_entity_create_link+0x4c/0xfc)
> [   70.503173] [<c027d390>] (media_entity_create_link+0x4c/0xfc) from
> [<bf0e2d04>] (isp_probe+0x748/0x954 [omap3_isp])
> [   70.514190] [<bf0e2d04>] (isp_probe+0x748/0x954 [omap3_isp]) from
> [<c0212c7c>] (platform_drv_probe+0x14/0x18)
> [   70.524597] [<c0212c7c>] (platform_drv_probe+0x14/0x18) from
> [<c0211c00>] (driver_probe_device+0xc8/0x184)
> [   70.534698] [<c0211c00>] (driver_probe_device+0xc8/0x184) from
> [<c0211d1c>] (__driver_attach+0x60/0x84)
> [   70.544555] [<c0211d1c>] (__driver_attach+0x60/0x84) from
> [<c0210eb0>] (bus_for_each_dev+0x4c/0x78)
> [   70.554046] [<c0210eb0>] (bus_for_each_dev+0x4c/0x78) from
> [<c0211520>] (bus_add_driver+0x98/0x210)
> [   70.563537] [<c0211520>] (bus_add_driver+0x98/0x210) from
> [<c0212230>] (driver_register+0xa8/0x12c)
> [   70.573028] [<c0212230>] (driver_register+0xa8/0x12c) from
> [<c0008574>] (do_one_initcall+0x90/0x160)
> [   70.582641] [<c0008574>] (do_one_initcall+0x90/0x160) from
> [<c0058728>] (sys_init_module+0x15fc/0x17c4)
> [   70.592498] [<c0058728>] (sys_init_module+0x15fc/0x17c4) from
> [<c000d540>] (ret_fast_syscall+0x0/0x30)
> [   70.602264] Code: e59f0010 e1a01003 eb0cf943 e3a03000 (e5833000)
> [   70.608764] ---[ end trace c33463a29bf37706 ]---
>
>
> If it could be useful i can send the board file where the v4l subdev
> is registered, but basically i copied it from a working version from
> the manufacturer repository (kernel 2.6.35). It's not a hardware
> problem because it works with manufacturer kernel.
>
> Thanks,
>
> Enrico
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------
