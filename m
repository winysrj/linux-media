Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:39847 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349Ab0GZT7v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Jul 2010 15:59:51 -0400
From: "Sin, David" <davidsin@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
CC: "Molnar, Lajos" <molnar@ti.com>
Date: Mon, 26 Jul 2010 14:59:43 -0500
Subject: RE: [RFC 1/8] TILER-DMM: DMM-PAT driver for TI TILER
Message-ID: <513FF747EED39B4AADBB4D6C9D9F9F7903D63B9E3C@dlee02.ent.ti.com>
References: <1279927694-26138-1-git-send-email-davidsin@ti.com>
 <1279927694-26138-2-git-send-email-davidsin@ti.com>
 <201007261013.16666.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201007261013.16666.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent, 
Thanks for taking the time to review.  These are all very good comments and I will work on incorporating them into the next RFC version.
 
-David

-----Original Message-----
From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com] 
Sent: Monday, July 26, 2010 3:13 AM
To: linux-arm-kernel@lists.infradead.org
Cc: Sin, David; Molnar, Lajos
Subject: Re: [RFC 1/8] TILER-DMM: DMM-PAT driver for TI TILER

Hi David,

On Saturday 24 July 2010 01:28:07 David Sin wrote:
> This patch adds support for DMM-PAT initialization and programming.
> 
> Signed-off-by: David Sin <davidsin@ti.com>
> Signed-off-by: Lajos Molnar <molnar@ti.com>
> ---
>  arch/arm/mach-omap2/include/mach/dmm.h |  128 ++++++++++++++++++++
>  drivers/media/video/tiler/dmm.c        |  200
> ++++++++++++++++++++++++++++++++ 2 files changed, 328 insertions(+), 0
> deletions(-)
>  create mode 100644 arch/arm/mach-omap2/include/mach/dmm.h
>  create mode 100644 drivers/media/video/tiler/dmm.c
> 
> diff --git a/arch/arm/mach-omap2/include/mach/dmm.h
> b/arch/arm/mach-omap2/include/mach/dmm.h new file mode 100644
> index 0000000..68b798a
> --- /dev/null
> +++ b/arch/arm/mach-omap2/include/mach/dmm.h
> @@ -0,0 +1,128 @@
> +/*
> + * dmm.h
> + *
> + * DMM driver support functions for TI DMM-TILER hardware block.
> + *
> + * Author: David Sin <davidsin@ti.com>
> + *
> + * Copyright (C) 2009-2010 Texas Instruments, Inc.
> + *
> + * This package is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
> + * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
> + * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
> + */
> +
> +#ifndef DMM_H
> +#define DMM_H
> +
> +#define DMM_BASE 0x4E000000
> +#define DMM_SIZE 0x800
> +
> +#define DMM_REVISION          0x000
> +#define DMM_HWINFO            0x004
> +#define DMM_LISA_HWINFO       0x008
> +#define DMM_DMM_SYSCONFIG     0x010
> +#define DMM_LISA_LOCK         0x01C
> +#define DMM_LISA_MAP__0       0x040
> +#define DMM_LISA_MAP__1       0x044

Why the double _ ?

> +#define DMM_TILER_HWINFO      0x208
> +#define DMM_TILER_OR__0       0x220
> +#define DMM_TILER_OR__1       0x224
> +#define DMM_PAT_HWINFO        0x408
> +#define DMM_PAT_GEOMETRY      0x40C
> +#define DMM_PAT_CONFIG        0x410
> +#define DMM_PAT_VIEW__0       0x420
> +#define DMM_PAT_VIEW__1       0x424
> +#define DMM_PAT_VIEW_MAP__0   0x440
> +#define DMM_PAT_VIEW_MAP_BASE 0x460
> +#define DMM_PAT_IRQ_EOI       0x478
> +#define DMM_PAT_IRQSTATUS_RAW 0x480
> +#define DMM_PAT_IRQSTATUS     0x490
> +#define DMM_PAT_IRQENABLE_SET 0x4A0
> +#define DMM_PAT_IRQENABLE_CLR 0x4B0
> +#define DMM_PAT_STATUS__0     0x4C0
> +#define DMM_PAT_STATUS__1     0x4C4
> +#define DMM_PAT_STATUS__2     0x4C8
> +#define DMM_PAT_STATUS__3     0x4CC
> +#define DMM_PAT_DESCR__0      0x500
> +#define DMM_PAT_AREA__0       0x504
> +#define DMM_PAT_CTRL__0       0x508
> +#define DMM_PAT_DATA__0       0x50C
> +#define DMM_PEG_HWINFO        0x608
> +#define DMM_PEG_PRIO          0x620
> +#define DMM_PEG_PRIO_PAT      0x640
> +
> +/**
> + * PAT refill programming mode.
> + */
> +enum pat_mode {
> +	MANUAL,
> +	AUTO
> +};

MANUAL and AUTO are pretty generic names to have in the top-level scope. 
Please at least rename them to PAT_MANUAL and PAT_AUTO.

Even better, the pat_ prefix might be better called dmm_pat_, as PAT is 
already used for Physical Address Extension on x86 (granted, the DMM-PAT is 
not likely to be used on x86 platforms).

An explanation of the DMM and PAT acronyms would be nice as well.

> +
> +/**
> + * Area definition for DMM physical address translator.
> + */
> +struct pat_area {
> +	s32 x0:8;
> +	s32 y0:8;
> +	s32 x1:8;
> +	s32 y1:8;

What's wrong with four u8 fields ?

> +};
> +
> +/**
> + * DMM physical address translator control.
> + */
> +struct pat_ctrl {
> +	s32 start:4;
> +	s32 dir:4;
> +	s32 lut_id:8;
> +	s32 sync:12;
> +	s32 ini:4;
> +};
> +
> +/**
> + * PAT descriptor.
> + */
> +struct pat {
> +	struct pat *next;
> +	struct pat_area area;
> +	struct pat_ctrl ctrl;
> +	u32 data;
> +};
> +
> +/**
> + * DMM device data
> + */
> +struct dmm {
> +	void __iomem *base;
> +};
> +
> +/**
> + * Create and initialize the physical address translator.
> + * @param id    PAT id
> + * @return pointer to device data
> + */
> +struct dmm *dmm_pat_init(u32 id);
> +
> +/**
> + * Program the physical address translator.
> + * @param dmm   Device data
> + * @param desc  PAT descriptor
> + * @param mode  programming mode
> + * @return an error status.
> + */
> +s32 dmm_pat_refill(struct dmm *dmm, struct pat *desc, enum pat_mode mode);
> +
> +/**
> + * Clean up the physical address translator.
> + * @param dmm    Device data
> + * @return an error status.
> + */
> +void dmm_pat_release(struct dmm *dmm);
> +
> +#endif
> diff --git a/drivers/media/video/tiler/dmm.c
> b/drivers/media/video/tiler/dmm.c new file mode 100644
> index 0000000..e715936
> --- /dev/null
> +++ b/drivers/media/video/tiler/dmm.c
> @@ -0,0 +1,200 @@
> +/*
> + * dmm.c
> + *
> + * DMM driver support functions for TI OMAP processors.
> + *
> + * Authors: David Sin <davidsin@ti.com>
> + *          Lajos Molnar <molnar@ti.com>
> + *
> + * Copyright (C) 2009-2010 Texas Instruments, Inc.
> + *
> + * This package is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
> + * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
> + * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
> + */
> +
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h> /* platform_device() */
> +#include <linux/io.h>              /* ioremap() */
> +#include <linux/errno.h>
> +#include <linux/slab.h>
> +
> +#include <mach/dmm.h>
> +
> +#define MASK(msb, lsb) (((1 << ((msb) + 1 - (lsb))) - 1) << (lsb))
> +#define SET_FLD(reg, msb, lsb, val) \
> +(((reg) & ~MASK((msb), (lsb))) | (((val) << (lsb)) & MASK((msb), (lsb))))
> +
> +static struct platform_driver dmm_driver_ldm = {
> +	.driver = {
> +		.owner = THIS_MODULE,
> +		.name = "dmm",
> +	},
> +	.probe = NULL,
> +	.shutdown = NULL,
> +	.remove = NULL,
> +};

Why do you need a platform_driver if it's completely empty ? Instead of using 
the hardcoded DMM_BASE and DMM_SIZE constants in the driver, you should 
implement a probe function and retrieve them from the platform device 
resources.

> +s32 dmm_pat_refill(struct dmm *dmm, struct pat *pd, enum pat_mode mode)
> +{
> +	void __iomem *r;
> +	u32 v;
> +
> +	/* Only manual refill supported */
> +	if (mode != MANUAL)
> +		return -EFAULT;
> +
> +	/* Check that the DMM_PAT_STATUS register has not reported an error */
> +	r = dmm->base + DMM_PAT_STATUS__0;
> +	v = __raw_readl(r);

Adding dmm_read and dmm_write macros that compute the address using the base 
and offset would make the code simpler. You could also define dmm_clear_bits 
and dmm_set_bits macros.

> +	if (WARN(v & 0xFC00, KERN_ERR "dmm_pat_refill() error.\n"))

Can you define constants for the field's bits and use them instead of the 
hardcoded 0xfc00 ?

Same comment for the other values you use in the driver (both the register 
values, field numbers, shift constants, ...).

> +		return -EIO;
> +
> +	/* Set "next" register to NULL */
> +	r = dmm->base + DMM_PAT_DESCR__0;
> +	v = __raw_readl(r);
> +	v = SET_FLD(v, 31, 4, (u32) NULL);
> +	__raw_writel(v, r);
> +
> +	/* Set area to be refilled */
> +	r = dmm->base + DMM_PAT_AREA__0;
> +	v = __raw_readl(r);
> +	v = SET_FLD(v, 30, 24, pd->area.y1);
> +	v = SET_FLD(v, 23, 16, pd->area.x1);
> +	v = SET_FLD(v, 14, 8, pd->area.y0);
> +	v = SET_FLD(v, 7, 0, pd->area.x0);
> +	__raw_writel(v, r);
> +	wmb();
> +
> +	/* First, clear the DMM_PAT_IRQSTATUS register */
> +	r = dmm->base + DMM_PAT_IRQSTATUS;
> +	__raw_writel(0xFFFFFFFF, r);
> +	wmb();
> +
> +	r = dmm->base + DMM_PAT_IRQSTATUS_RAW;
> +	while (__raw_readl(r) != 0)
> +		;

How long is this expected to last ? Shouldn't you add a timeout ?

> +	/* Fill data register */
> +	r = dmm->base + DMM_PAT_DATA__0;
> +	v = __raw_readl(r);
> +
> +	v = SET_FLD(v, 31, 4, pd->data >> 4);
> +	__raw_writel(v, r);
> +	wmb();
> +
> +	/* Read back PAT_DATA__0 to see if write was successful */
> +	while (__raw_readl(r) != pd->data)
> +		;

Do you really need to read back every register after writing them ?

> +	r = dmm->base + DMM_PAT_CTRL__0;
> +	v = __raw_readl(r);
> +	v = SET_FLD(v, 31, 28, pd->ctrl.ini);
> +	v = SET_FLD(v, 16, 16, pd->ctrl.sync);
> +	v = SET_FLD(v, 9, 8, pd->ctrl.lut_id);
> +	v = SET_FLD(v, 6, 4, pd->ctrl.dir);
> +	v = SET_FLD(v, 0, 0, pd->ctrl.start);
> +	__raw_writel(v, r);
> +	wmb();
> +
> +	/* Check if PAT_IRQSTATUS_RAW is set after the PAT has been refilled */
> +	r = dmm->base + DMM_PAT_IRQSTATUS_RAW;
> +	while ((__raw_readl(r) & 0x3) != 0x3)
> +		;
> +
> +	/* Again, clear the DMM_PAT_IRQSTATUS register */
> +	r = dmm->base + DMM_PAT_IRQSTATUS;
> +	__raw_writel(0xFFFFFFFF, r);
> +	wmb();
> +
> +	r = dmm->base + DMM_PAT_IRQSTATUS_RAW;
> +	while (__raw_readl(r) != 0)
> +		;
> +
> +	/* Again, set "next" register to NULL to clear any PAT STATUS errors */
> +	r = dmm->base + DMM_PAT_DESCR__0;
> +	v = __raw_readl(r);
> +	v = SET_FLD(v, 31, 4, (u32) NULL);
> +	__raw_writel(v, r);
> +
> +	/*
> +	 * Now, check that the DMM_PAT_STATUS register
> +	 * has not reported an error before exiting.
> +	*/
> +	r = dmm->base + DMM_PAT_STATUS__0;
> +	v = __raw_readl(r);
> +	if (WARN(v & 0xFC00, KERN_ERR "dmm_pat_refill() error.\n"))
> +		return -EIO;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(dmm_pat_refill);
> +
> +struct dmm *dmm_pat_init(u32 id)
> +{
> +	u32 base;
> +	struct dmm *dmm;
> +	switch (id) {
> +	case 0:
> +		/* only support id 0 for now */
> +		base = DMM_BASE;
> +		break;
> +	default:
> +		return NULL;
> +	}

Shouldn't you protect against multiple driver trying to initialize the same 
DMM-PAT ?

> +	dmm = kzalloc(sizeof(*dmm), GFP_KERNEL);
> +	if (!dmm)
> +		return NULL;
> +
> +	dmm->base = ioremap(base, DMM_SIZE);
> +	if (!dmm->base) {
> +		kfree(dmm);
> +		return NULL;
> +	}
> +
> +	__raw_writel(0x88888888, dmm->base + DMM_PAT_VIEW__0);
> +	__raw_writel(0x88888888, dmm->base + DMM_PAT_VIEW__1);
> +	__raw_writel(0x80808080, dmm->base + DMM_PAT_VIEW_MAP__0);
> +	__raw_writel(0x80000000, dmm->base + DMM_PAT_VIEW_MAP_BASE);
> +	__raw_writel(0x88888888, dmm->base + DMM_TILER_OR__0);
> +	__raw_writel(0x88888888, dmm->base + DMM_TILER_OR__1);
> +
> +	return dmm;
> +}
> +EXPORT_SYMBOL(dmm_pat_init);
> +
> +/**
> + * Clean up the physical address translator.
> + * @param dmm    Device data
> + * @return an error status.
> + */
> +void dmm_pat_release(struct dmm *dmm)
> +{
> +	if (dmm) {
> +		iounmap(dmm->base);
> +		kfree(dmm);
> +	}
> +}
> +EXPORT_SYMBOL(dmm_pat_release);
> +
> +static s32 __init dmm_init(void)
> +{
> +	return platform_driver_register(&dmm_driver_ldm);
> +}
> +
> +static void __exit dmm_exit(void)
> +{
> +	platform_driver_unregister(&dmm_driver_ldm);
> +}
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_AUTHOR("davidsin@ti.com");
> +MODULE_AUTHOR("molnar@ti.com");
> +module_init(dmm_init);
> +module_exit(dmm_exit);

-- 
Regards,

Laurent Pinchart
