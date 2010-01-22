Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:36131 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398Ab0AVLqF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jan 2010 06:46:05 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Aguirre, Sergio" <saaguirre@ti.com>
Subject: Re: gitorious.org/omap3camera: Falied attempt to migrate sensor driver to Zoom2/3 platform
Date: Fri, 22 Jan 2010 12:46:24 +0100
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <A24693684029E5489D1D202277BE8944517F0987@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE8944517F0987@dlee02.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201001221246.24330.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergio,

On Friday 22 January 2010 10:49:17 Aguirre, Sergio wrote:
> Laurent, Sakari,
> 
> While I was trying to adapt my Zoom2/3 sensor drivers into latest 'devel'
>  branch with latest commit:
> 
> commit 2e7d09ec5e09ee80462a611c9958e99866ee337c
> Author: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Date:   Wed Jan 20 13:49:31 2010 +0100
> 
>     omap3isp: Work around sg_alloc_table BUG_ON
> 
>     Work in progress
> 
>     Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

That last patch shouldn't have been applied to the linux-omap tree. The patch 
itself is correct, but the commit message isn't. I'll check that with Sakari.

> And applying the attached patches. I see the following kernel panic on
>  bootup:
> 
> omap3isp omap3isp: Revision 2.0 found
> omap-iommu omap-iommu.0: isp: version 1.1
> Unable to handle kernel NULL pointer dereference at virtual address
>  00000048 pgd = c0004000
> [00000048] *pgd=00000000
> Internal error: Oops: 5 [#1]
> last sysfs file:
> Modules linked in:
> CPU: 0    Not tainted  (2.6.32-07583-gd4ae425-dirty #7)
> PC is at get_device_parent+0x68/0x114
> LR is at device_add+0x7c/0x474
> pc : [<c019345c>]    lr : [<c0194264>]    psr: 60000013
> sp : cf823dc8  ip : cf95f680  fp : cf91b178
> r10: c03f37e0  r9 : c0367b06  r8 : c03dc770
> r7 : ffffffea  r6 : cf91b170  r5 : c03b7748  r4 : 00000000
> r3 : c03dc770  r2 : 00000000  r1 : c03b7740  r0 : c03b7748
> Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
> Control: 10c5387d  Table: 80004019  DAC: 00000017
> Process swapper (pid: 1, stack limit = 0xcf8222e8)
> Stack: (0xcf823dc8 to 0xcf824000)
> 3dc0:                   00000000 cf91b170 cf91b170 c0194264 cf823e10
>  c03b7740 3de0: 00000000 cf91b178 00000000 c01670a4 cf91b178 00000000
>  cf91b168 cf91b170 3e00: c03f33dc c03dc770 c0367b06 c03f37e0 c03b787c
>  c0200744 c03b7740 cf91b160 3e20: c03b7740 cf91b000 c03d3cc0 00000000
>  00000000 c01fdcbc c03b8ae0 c03b8fc0 3e40: c03b7738 98f7cec1 cf820a30
>  c03b8f68 00000000 c0067f78 cf82c01c cf821a40 3e60: 00000017 cf820a00
>  cf821bdc 00000000 cf823eac 00000001 00000000 fffffffd 3e80: cf823ebc
>  cf803740 00000000 00000001 cf803744 00000000 00000000 c03ed394 3ea0:
>  cf823ef4 c016630c 00000000 cf80d7a8 00000000 c016630c cf82dfa4 cf80d7a8
>  3ec0: c00e5cdc cf80e608 00000000 c02a8c58 00000000 cf823f10 cf95e7b8
>  c00e6474 3ee0: cf95e7b8 c00e60ac cf95e818 cf95e7b8 cf823f10 c00e6184
>  00000000 cf823f10 3f00: cf95e7b8 cf80e608 00000001 c00e6eec cf80e608
>  00000000 00000000 c03b7740 3f20: c03b7740 c03dc440 cf95dbc0 c03d3cc0
>  00000000 00000000 00000000 c01971e4 3f40: c03b7740 c01963e0 c03b7740
>  c03b7774 c03dc440 cf95dbc0 c03d3cc0 c01964ec 3f60: 00000000 c019648c
>  c03dc440 c0195cb4 cf803af8 cf8459f0 c00222c8 c03dc440 3f80: c03dc440
>  c0195614 c03361b1 c03361b1 00000006 c00222c8 00000000 c03dc440 3fa0:
>  00000000 00000000 00000000 c01967bc c00222c8 00000000 c001c060 00000000
>  3fc0: 00000000 c0027334 00000031 00000000 00000000 00000192 00000000
>  c00222c8 3fe0: 00000000 00000000 00000000 c0008578 00000000 c0028dbc
>  00dbda20 24ffdc02 [<c019345c>] (get_device_parent+0x68/0x114) from
>  [<c0194264>] (device_add+0x7c/0x474) [<c0194264>] (device_add+0x7c/0x474)
>  from [<c0200744>] (media_devnode_register+0x1d0/0x29c) [<c0200744>]
>  (media_devnode_register+0x1d0/0x29c) from [<c01fdcbc>]
>  (omap34xxcam_probe+0x64/0x428) [<c01fdcbc>] (omap34xxcam_probe+0x64/0x428)
>  from [<c01971e4>] (platform_drv_probe+0x18/0x1c) [<c01971e4>]
>  (platform_drv_probe+0x18/0x1c) from [<c01963e0>]
>  (driver_probe_device+0xa0/0x14c) [<c01963e0>]
>  (driver_probe_device+0xa0/0x14c) from [<c01964ec>]
>  (__driver_attach+0x60/0x84) [<c01964ec>] (__driver_attach+0x60/0x84) from
>  [<c0195cb4>] (bus_for_each_dev+0x44/0x74) [<c0195cb4>]
>  (bus_for_each_dev+0x44/0x74) from [<c0195614>] (bus_add_driver+0x9c/0x220)
>  [<c0195614>] (bus_add_driver+0x9c/0x220) from [<c01967bc>]
>  (driver_register+0xa8/0x130) [<c01967bc>] (driver_register+0xa8/0x130)
>  from [<c0027334>] (do_one_initcall+0x5c/0x1b4) [<c0027334>]
>  (do_one_initcall+0x5c/0x1b4) from [<c0008578>] (kernel_init+0x90/0x10c)
>  [<c0008578>] (kernel_init+0x90/0x10c) from [<c0028dbc>]
>  (kernel_thread_exit+0x0/0x8) Code: 18bd8070 e1a05000 e596309c e5932030
>  (e5b23048)
> ---[ end trace 31cd15fa922e3123 ]---
> Kernel panic - not syncing: Attempted to kill init!
> 
> Do you have any idea what I could be missing?

Yes, I think you're missing the equivalent to commit 
38f5cbed7710ab373252b64e3fb0701ab5a7b828

    rx51: Add omap3isp_device pointer to platform data.
    
    Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>

-- 
Regards,

Laurent Pinchart
