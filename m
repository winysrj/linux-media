Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:40451 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161223AbcFBRZy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Jun 2016 13:25:54 -0400
Subject: Re: [PATCH v4 5/7] ARM: Exynos: remove code for MFC custom reserved
 memory handling
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
References: <1464096690-23605-1-git-send-email-m.szyprowski@samsung.com>
 <1464096690-23605-6-git-send-email-m.szyprowski@samsung.com>
 <574BEBB8.8040606@samsung.com>
 <5a12a8be-0402-dc0c-d242-5d9f3145e001@osg.samsung.com>
 <57505F5B.90101@samsung.com>
Cc: devicetree@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Uli Middelberg <uli@middelberg.de>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <e715a7d0-eb25-9d68-27ad-25cf03c499ca@osg.samsung.com>
Date: Thu, 2 Jun 2016 13:25:43 -0400
MIME-Version: 1.0
In-Reply-To: <57505F5B.90101@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Krzysztof,

On 06/02/2016 12:31 PM, Krzysztof Kozlowski wrote:
> On 06/02/2016 05:20 PM, Javier Martinez Canillas wrote:
>> Hello Krzysztof,
>>
>> On 05/30/2016 03:28 AM, Krzysztof Kozlowski wrote:
>>> On 05/24/2016 03:31 PM, Marek Szyprowski wrote:
>>>> Once MFC driver has been converted to generic reserved memory bindings,
>>>> there is no need for custom memory reservation code.
>>>>
>>>> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
>>>> ---
>>>>  arch/arm/mach-exynos/Makefile      |  2 -
>>>>  arch/arm/mach-exynos/exynos.c      | 19 --------
>>>>  arch/arm/mach-exynos/mfc.h         | 16 -------
>>>>  arch/arm/mach-exynos/s5p-dev-mfc.c | 93 --------------------------------------
>>>>  4 files changed, 130 deletions(-)
>>>>  delete mode 100644 arch/arm/mach-exynos/mfc.h
>>>>  delete mode 100644 arch/arm/mach-exynos/s5p-dev-mfc.c
>>>
>>> Thanks, applied.
>>>
>>
>> This patch can't be applied before patches 2/5 and 3/5, or the custom
>> memory regions reservation will break with the current s5p-mfc driver.
> 
> Yes, I know. As I understood from talk with Marek, the driver is broken
> now so continuous work was not chosen. If it is not correct and full

It's true that the driven is currently broken in mainline and is not really
stable, I posted fixes for all the issues I found (mostly in module removal
and insert paths).

But with just the following patch from Ayaka on top of mainline, I'm able to
have video decoding working: https://lkml.org/lkml/2016/5/6/577

Marek mentioned that bisectability is only partially broken because the old
binding will still work after this series if IOMMU is enabled (because the
properties are ignored in this case). But will break if IOMMU isn't enabled
which will be the case for some boards that fails to boot with IOMMU due the
bootloader leaving the FIMD enabled doing DMA operations automatically AFAIU. 

Now, I'm OK with not keeping backwards compatibility for the MFC dt bindings
since arguably the driver has been broken for a long time and nobody cared
and also I don't think anyone in practice boots a new kernel with an old DTB
for Exynos.

But I don't think is correct to introduce a new issue as is the case if this
patch is applied before the previous patches in the series since this causes
the driver to probe to fail and the following warn on boot (while it used to
at least probe correctly in mainline):

[   17.190165] WARNING: CPU: 0 PID: 224 at kernel/memremap.c:111 memremap+0x1a8/0x1b0
[   17.193127] memremap attempted on ram 0x51000000 size: 0x800000
[   17.196247] Modules linked in: s5p_mfc(+) uvcvideo s5p_jpeg videobuf2_vmalloc v4l2_mem2mem
[   17.199569] CPU: 0 PID: 224 Comm: systemd-udevd Not tainted 4.7.0-rc1-next-20160531-00006-g569df5b983f3 #68
[   17.202556] Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
[   17.205534] [<c010e1ac>] (unwind_backtrace) from [<c010af38>] (show_stack+0x10/0x14)
[   17.208535] [<c010af38>] (show_stack) from [<c0323b9c>] (dump_stack+0x88/0x9c)
[   17.211530] [<c0323b9c>] (dump_stack) from [<c011a828>] (__warn+0xe8/0x100)
[   17.214492] [<c011a828>] (__warn) from [<c011a878>] (warn_slowpath_fmt+0x38/0x48)
[   17.217479] [<c011a878>] (warn_slowpath_fmt) from [<c0194ee0>] (memremap+0x1a8/0x1b0)
[   17.220476] [<c0194ee0>] (memremap) from [<c040d92c>] (dma_init_coherent_memory+0xf8/0x130)
[   17.223489] [<c040d92c>] (dma_init_coherent_memory) from [<c040d990>] (dma_declare_coherent_memory+0x2c/0x6c)
[   17.226570] [<c040d990>] (dma_declare_coherent_memory) from [<bf1768c4>] (s5p_mfc_probe+0x170/0x650 [s5p_mfc])
[   17.229648] [<bf1768c4>] (s5p_mfc_probe [s5p_mfc]) from [<c03fb704>] (platform_drv_probe+0x4c/0xb0)
[   17.232718] [<c03fb704>] (platform_drv_probe) from [<c03f9e58>] (driver_probe_device+0x214/0x2c0)
[   17.235800] [<c03f9e58>] (driver_probe_device) from [<c03f9fb0>] (__driver_attach+0xac/0xb0)
[   17.238906] [<c03f9fb0>] (__driver_attach) from [<c03f81d0>] (bus_for_each_dev+0x68/0x9c)
[   17.242031] [<c03f81d0>] (bus_for_each_dev) from [<c03f944c>] (bus_add_driver+0x1a0/0x218)
[   17.245160] [<c03f944c>] (bus_add_driver) from [<c03fa7c8>] (driver_register+0x78/0xf8)
[   17.248300] [<c03fa7c8>] (driver_register) from [<c01017c0>] (do_one_initcall+0x40/0x170)
[   17.251475] [<c01017c0>] (do_one_initcall) from [<c01956e4>] (do_init_module+0x60/0x1b0)
[   17.254656] [<c01956e4>] (do_init_module) from [<c0188dc0>] (load_module+0x17ec/0x1dd0)
[   17.257844] [<c0188dc0>] (load_module) from [<c0189570>] (SyS_finit_module+0x8c/0x9c)
[   17.261037] [<c0189570>] (SyS_finit_module) from [<c01078c0>] (ret_fast_syscall+0x0/0x3c)
[   17.265210] ---[ end trace 33de2b5daf697e0f ]---
[   17.269300] s5p_mfc_alloc_memdevs:1072: Failed to declare coherent memory for
               MFC device
[   17.277593] ------------[ cut here ]------------

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
