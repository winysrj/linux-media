Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:25715 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137AbaIBTV0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Sep 2014 15:21:26 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NBA00C55GFO11B0@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 02 Sep 2014 15:21:24 -0400 (EDT)
Date: Tue, 02 Sep 2014 16:21:19 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv3 1/2] tw68: add support for Techwell tw68xx PCI grabber
 boards
Message-id: <20140902162119.0eb5b931.m.chehab@samsung.com>
In-reply-to: <1409034793-9465-2-git-send-email-hverkuil@xs4all.nl>
References: <1409034793-9465-1-git-send-email-hverkuil@xs4all.nl>
 <1409034793-9465-2-git-send-email-hverkuil@xs4all.nl>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 26 Aug 2014 08:33:12 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Add support for the tw68 driver. The driver has been out-of-tree for many
> years on gitorious: https://gitorious.org/tw68/tw68-v2
> 
> I have refactored and ported that driver to the latest V4L2 core frameworks.
> 
> Tested with my Techwell tw6805a and tw6816 grabber boards.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

I would be expecting here the  William M. Brack's SOB too.

Also, the best is to add his original work on one patch (without Kbuild
stuff) and your changes on a separate patch. That helps us to identify
what are your contributions to his code, and what was his original
copyright wording.

> ---
>  drivers/media/pci/Kconfig           |    1 +
>  drivers/media/pci/Makefile          |    1 +
>  drivers/media/pci/tw68/Kconfig      |   10 +
>  drivers/media/pci/tw68/Makefile     |    3 +
>  drivers/media/pci/tw68/tw68-core.c  |  434 ++++++++++++++
>  drivers/media/pci/tw68/tw68-reg.h   |  195 +++++++
>  drivers/media/pci/tw68/tw68-risc.c  |  230 ++++++++
>  drivers/media/pci/tw68/tw68-video.c | 1060 +++++++++++++++++++++++++++++++++++
>  drivers/media/pci/tw68/tw68.h       |  231 ++++++++
>  9 files changed, 2165 insertions(+)
>  create mode 100644 drivers/media/pci/tw68/Kconfig
>  create mode 100644 drivers/media/pci/tw68/Makefile
>  create mode 100644 drivers/media/pci/tw68/tw68-core.c
>  create mode 100644 drivers/media/pci/tw68/tw68-reg.h
>  create mode 100644 drivers/media/pci/tw68/tw68-risc.c
>  create mode 100644 drivers/media/pci/tw68/tw68-video.c
>  create mode 100644 drivers/media/pci/tw68/tw68.h
> 
> diff --git a/drivers/media/pci/Kconfig b/drivers/media/pci/Kconfig
> index 5c16c9c..9332807 100644
> --- a/drivers/media/pci/Kconfig
> +++ b/drivers/media/pci/Kconfig
> @@ -20,6 +20,7 @@ source "drivers/media/pci/ivtv/Kconfig"
>  source "drivers/media/pci/zoran/Kconfig"
>  source "drivers/media/pci/saa7146/Kconfig"
>  source "drivers/media/pci/solo6x10/Kconfig"
> +source "drivers/media/pci/tw68/Kconfig"
>  endif
>  
>  if MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT
> diff --git a/drivers/media/pci/Makefile b/drivers/media/pci/Makefile
> index dc2ebbe..73d9c0f 100644
> --- a/drivers/media/pci/Makefile
> +++ b/drivers/media/pci/Makefile
> @@ -21,6 +21,7 @@ obj-$(CONFIG_VIDEO_CX88) += cx88/
>  obj-$(CONFIG_VIDEO_BT848) += bt8xx/
>  obj-$(CONFIG_VIDEO_SAA7134) += saa7134/
>  obj-$(CONFIG_VIDEO_SAA7164) += saa7164/
> +obj-$(CONFIG_VIDEO_TW68) += tw68/
>  obj-$(CONFIG_VIDEO_MEYE) += meye/
>  obj-$(CONFIG_STA2X11_VIP) += sta2x11/
>  obj-$(CONFIG_VIDEO_SOLO6X10) += solo6x10/
> diff --git a/drivers/media/pci/tw68/Kconfig b/drivers/media/pci/tw68/Kconfig
> new file mode 100644
> index 0000000..5425ba1
> --- /dev/null
> +++ b/drivers/media/pci/tw68/Kconfig
> @@ -0,0 +1,10 @@
> +config VIDEO_TW68
> +	tristate "Techwell tw68x Video For Linux"
> +	depends on VIDEO_DEV && PCI && VIDEO_V4L2
> +	select I2C_ALGOBIT
> +	select VIDEOBUF2_DMA_SG
> +	---help---
> +	  Support for Techwell tw68xx based frame grabber boards.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called tw68.
> diff --git a/drivers/media/pci/tw68/Makefile b/drivers/media/pci/tw68/Makefile
> new file mode 100644
> index 0000000..3d02f28
> --- /dev/null
> +++ b/drivers/media/pci/tw68/Makefile
> @@ -0,0 +1,3 @@
> +tw68-objs := tw68-core.o tw68-video.o tw68-risc.o
> +
> +obj-$(CONFIG_VIDEO_TW68) += tw68.o
> diff --git a/drivers/media/pci/tw68/tw68-core.c b/drivers/media/pci/tw68/tw68-core.c
> new file mode 100644
> index 0000000..baf93af
> --- /dev/null
> +++ b/drivers/media/pci/tw68/tw68-core.c
> @@ -0,0 +1,434 @@
> +/*
> + *  tw68-core.c
> + *  Core functions for the Techwell 68xx driver
> + *
> + *  Much of this code is derived from the cx88 and sa7134 drivers, which
> + *  were in turn derived from the bt87x driver.  The original work was by
> + *  Gerd Knorr; more recently the code was enhanced by Mauro Carvalho Chehab,
> + *  Hans Verkuil, Andy Walls and many others.  Their work is gratefully
> + *  acknowledged.  Full credit goes to them - any problems within this code
> + *  are mine.
> + *
> + *  Copyright (C) 2009  William M. Brack
> + *
> + *  Refactored and updated to the latest v4l core frameworks:
> + *
> + *  Copyright (C) 2014 Hans Verkuil <hverkuil@xs4all.nl>
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + */
> +
> +#include <linux/init.h>
> +#include <linux/list.h>
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/slab.h>
> +#include <linux/kmod.h>
> +#include <linux/sound.h>
> +#include <linux/interrupt.h>
> +#include <linux/delay.h>
> +#include <linux/mutex.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/pm.h>
> +
> +#include <media/v4l2-dev.h>
> +#include "tw68.h"
> +#include "tw68-reg.h"
> +
> +MODULE_DESCRIPTION("v4l2 driver module for tw6800 based video capture cards");
> +MODULE_AUTHOR("William M. Brack");
> +MODULE_AUTHOR("Hans Verkuil <hverkuil@xs4all.nl>");
> +MODULE_LICENSE("GPL");
> +
> +static unsigned int latency = UNSET;
> +module_param(latency, int, 0444);
> +MODULE_PARM_DESC(latency, "pci latency timer");
> +
> +static unsigned int video_nr[] = {[0 ... (TW68_MAXBOARDS - 1)] = UNSET };
> +module_param_array(video_nr, int, NULL, 0444);
> +MODULE_PARM_DESC(video_nr, "video device number");
> +
> +static unsigned int card[] = {[0 ... (TW68_MAXBOARDS - 1)] = UNSET };
> +module_param_array(card, int, NULL, 0444);
> +MODULE_PARM_DESC(card, "card type");
> +
> +static atomic_t tw68_instance = ATOMIC_INIT(0);
> +
> +/* ------------------------------------------------------------------ */
> +
> +/*
> + * Please add any new PCI IDs to: http://pci-ids.ucw.cz.  This keeps
> + * the PCI ID database up to date.  Note that the entries must be
> + * added under vendor 0x1797 (Techwell Inc.) as subsystem IDs.
> + */
> +struct pci_device_id tw68_pci_tbl[] = {
> +	{PCI_DEVICE(PCI_VENDOR_ID_TECHWELL, PCI_DEVICE_ID_6800)},
> +	{PCI_DEVICE(PCI_VENDOR_ID_TECHWELL, PCI_DEVICE_ID_6801)},
> +	{PCI_DEVICE(PCI_VENDOR_ID_TECHWELL, PCI_DEVICE_ID_6804)},
> +	{PCI_DEVICE(PCI_VENDOR_ID_TECHWELL, PCI_DEVICE_ID_6816_1)},
> +	{PCI_DEVICE(PCI_VENDOR_ID_TECHWELL, PCI_DEVICE_ID_6816_2)},
> +	{PCI_DEVICE(PCI_VENDOR_ID_TECHWELL, PCI_DEVICE_ID_6816_3)},
> +	{PCI_DEVICE(PCI_VENDOR_ID_TECHWELL, PCI_DEVICE_ID_6816_4)},
> +	{0,}
> +};
> +
> +/* ------------------------------------------------------------------ */
> +
> +
> +/*
> + * The device is given a "soft reset". According to the specifications,
> + * after this "all register content remain unchanged", so we also write
> + * to all specified registers manually as well (mostly to manufacturer's
> + * specified reset values)
> + */
> +static int tw68_hw_init1(struct tw68_dev *dev)
> +{
> +	/* Assure all interrupts are disabled */
> +	tw_writel(TW68_INTMASK, 0);		/* 020 */
> +	/* Clear any pending interrupts */
> +	tw_writel(TW68_INTSTAT, 0xffffffff);	/* 01C */
> +	/* Stop risc processor, set default buffer level */
> +	tw_writel(TW68_DMAC, 0x1600);
> +
> +	tw_writeb(TW68_ACNTL, 0x80);	/* 218	soft reset */
> +	msleep(100);
> +
> +	tw_writeb(TW68_INFORM, 0x40);	/* 208	mux0, 27mhz xtal */
> +	tw_writeb(TW68_OPFORM, 0x04);	/* 20C	analog line-lock */
> +	tw_writeb(TW68_HSYNC, 0);	/* 210	color-killer high sens */
> +	tw_writeb(TW68_ACNTL, 0x42);	/* 218	int vref #2, chroma adc off */
> +
> +	tw_writeb(TW68_CROP_HI, 0x02);	/* 21C	Hactive m.s. bits */
> +	tw_writeb(TW68_VDELAY_LO, 0x12);/* 220	Mfg specified reset value */
> +	tw_writeb(TW68_VACTIVE_LO, 0xf0);
> +	tw_writeb(TW68_HDELAY_LO, 0x0f);
> +	tw_writeb(TW68_HACTIVE_LO, 0xd0);
> +
> +	tw_writeb(TW68_CNTRL1, 0xcd);	/* 230	Wide Chroma BPF B/W
> +					 *	Secam reduction, Adap comb for
> +					 *	NTSC, Op Mode 1 */
> +
> +	tw_writeb(TW68_VSCALE_LO, 0);	/* 234 */
> +	tw_writeb(TW68_SCALE_HI, 0x11);	/* 238 */
> +	tw_writeb(TW68_HSCALE_LO, 0);	/* 23c */
> +	tw_writeb(TW68_BRIGHT, 0);	/* 240 */
> +	tw_writeb(TW68_CONTRAST, 0x5c);	/* 244 */
> +	tw_writeb(TW68_SHARPNESS, 0x51);/* 248 */
> +	tw_writeb(TW68_SAT_U, 0x80);	/* 24C */
> +	tw_writeb(TW68_SAT_V, 0x80);	/* 250 */
> +	tw_writeb(TW68_HUE, 0x00);	/* 254 */
> +
> +	/* TODO - Check that none of these are set by control defaults */
> +	tw_writeb(TW68_SHARP2, 0x53);	/* 258	Mfg specified reset val */
> +	tw_writeb(TW68_VSHARP, 0x80);	/* 25C	Sharpness Coring val 8 */
> +	tw_writeb(TW68_CORING, 0x44);	/* 260	CTI and Vert Peak coring */
> +	tw_writeb(TW68_CNTRL2, 0x00);	/* 268	No power saving enabled */
> +	tw_writeb(TW68_SDT, 0x07);	/* 270	Enable shadow reg, auto-det */
> +	tw_writeb(TW68_SDTR, 0x7f);	/* 274	All stds recog, don't start */
> +	tw_writeb(TW68_CLMPG, 0x50);	/* 280	Clamp end at 40 sys clocks */
> +	tw_writeb(TW68_IAGC, 0x22);	/* 284	Mfg specified reset val */
> +	tw_writeb(TW68_AGCGAIN, 0xf0);	/* 288	AGC gain when loop disabled */
> +	tw_writeb(TW68_PEAKWT, 0xd8);	/* 28C	White peak threshold */
> +	tw_writeb(TW68_CLMPL, 0x3c);	/* 290	Y channel clamp level */
> +/*	tw_writeb(TW68_SYNCT, 0x38);*/	/* 294	Sync amplitude */
> +	tw_writeb(TW68_SYNCT, 0x30);	/* 294	Sync amplitude */
> +	tw_writeb(TW68_MISSCNT, 0x44);	/* 298	Horiz sync, VCR detect sens */
> +	tw_writeb(TW68_PCLAMP, 0x28);	/* 29C	Clamp pos from PLL sync */
> +	/* Bit DETV of VCNTL1 helps sync multi cams/chip board */
> +	tw_writeb(TW68_VCNTL1, 0x04);	/* 2A0 */
> +	tw_writeb(TW68_VCNTL2, 0);	/* 2A4 */
> +	tw_writeb(TW68_CKILL, 0x68);	/* 2A8	Mfg specified reset val */
> +	tw_writeb(TW68_COMB, 0x44);	/* 2AC	Mfg specified reset val */
> +	tw_writeb(TW68_LDLY, 0x30);	/* 2B0	Max positive luma delay */
> +	tw_writeb(TW68_MISC1, 0x14);	/* 2B4	Mfg specified reset val */
> +	tw_writeb(TW68_LOOP, 0xa5);	/* 2B8	Mfg specified reset val */
> +	tw_writeb(TW68_MISC2, 0xe0);	/* 2BC	Enable colour killer */
> +	tw_writeb(TW68_MVSN, 0);	/* 2C0 */
> +	tw_writeb(TW68_CLMD, 0x05);	/* 2CC	slice level auto, clamp med. */
> +	tw_writeb(TW68_IDCNTL, 0);	/* 2D0	Writing zero to this register
> +					 *	selects NTSC ID detection,
> +					 *	but doesn't change the
> +					 *	sensitivity (which has a reset
> +					 *	value of 1E).  Since we are
> +					 *	not doing auto-detection, it
> +					 *	has no real effect */
> +	tw_writeb(TW68_CLCNTL1, 0);	/* 2D4 */
> +	tw_writel(TW68_VBIC, 0x03);	/* 010 */
> +	tw_writel(TW68_CAP_CTL, 0x03);	/* 040	Enable both even & odd flds */
> +	tw_writel(TW68_DMAC, 0x2000);	/* patch set had 0x2080 */
> +	tw_writel(TW68_TESTREG, 0);	/* 02C */
> +
> +	/*
> +	 * Some common boards, especially inexpensive single-chip models,
> +	 * use the GPIO bits 0-3 to control an on-board video-output mux.
> +	 * For these boards, we need to set up the GPIO register into
> +	 * "normal" mode, set bits 0-3 as output, and then set those bits
> +	 * zero.
> +	 *
> +	 * Eventually, it would be nice if we could identify these boards
> +	 * uniquely, and only do this initialisation if the board has been
> +	 * identify.  For the moment, however, it shouldn't hurt anything
> +	 * to do these steps.
> +	 */
> +	tw_writel(TW68_GPIOC, 0);	/* Set the GPIO to "normal", no ints */
> +	tw_writel(TW68_GPOE, 0x0f);	/* Set bits 0-3 to "output" */
> +	tw_writel(TW68_GPDATA, 0);	/* Set all bits to low state */
> +
> +	/* Initialize the device control structures */
> +	mutex_init(&dev->lock);
> +	spin_lock_init(&dev->slock);
> +
> +	/* Initialize any subsystems */
> +	tw68_video_init1(dev);
> +	return 0;
> +}
> +
> +static irqreturn_t tw68_irq(int irq, void *dev_id)
> +{
> +	struct tw68_dev *dev = dev_id;
> +	u32 status, orig;
> +	int loop;
> +
> +	status = orig = tw_readl(TW68_INTSTAT) & dev->pci_irqmask;
> +	/* Check if anything to do */
> +	if (0 == status)
> +		return IRQ_NONE;	/* Nope - return */
> +	for (loop = 0; loop < 10; loop++) {
> +		if (status & dev->board_virqmask)	/* video interrupt */
> +			tw68_irq_video_done(dev, status);
> +		status = tw_readl(TW68_INTSTAT) & dev->pci_irqmask;
> +		if (0 == status)
> +			return IRQ_HANDLED;
> +	}
> +	dev_dbg(&dev->pci->dev, "%s: **** INTERRUPT NOT HANDLED - clearing mask (orig 0x%08x, cur 0x%08x)",
> +			dev->name, orig, tw_readl(TW68_INTSTAT));
> +	dev_dbg(&dev->pci->dev, "%s: pci_irqmask 0x%08x; board_virqmask 0x%08x ****\n",
> +			dev->name, dev->pci_irqmask, dev->board_virqmask);
> +	tw_clearl(TW68_INTMASK, dev->pci_irqmask);
> +	return IRQ_HANDLED;
> +}
> +
> +static int tw68_initdev(struct pci_dev *pci_dev,
> +				     const struct pci_device_id *pci_id)
> +{
> +	struct tw68_dev *dev;
> +	int vidnr = -1;
> +	int err;
> +
> +	dev = devm_kzalloc(&pci_dev->dev, sizeof(*dev), GFP_KERNEL);
> +	if (NULL == dev)
> +		return -ENOMEM;
> +
> +	dev->instance = v4l2_device_set_name(&dev->v4l2_dev, "tw68",
> +						&tw68_instance);
> +
> +	err = v4l2_device_register(&pci_dev->dev, &dev->v4l2_dev);
> +	if (err)
> +		return err;
> +
> +	/* pci init */
> +	dev->pci = pci_dev;
> +	if (pci_enable_device(pci_dev)) {
> +		err = -EIO;
> +		goto fail1;
> +	}
> +
> +	dev->name = dev->v4l2_dev.name;
> +
> +	if (UNSET != latency) {
> +		pr_info("%s: setting pci latency timer to %d\n",
> +		       dev->name, latency);
> +		pci_write_config_byte(pci_dev, PCI_LATENCY_TIMER, latency);
> +	}
> +
> +	/* print pci info */
> +	pci_read_config_byte(pci_dev, PCI_CLASS_REVISION, &dev->pci_rev);
> +	pci_read_config_byte(pci_dev, PCI_LATENCY_TIMER,  &dev->pci_lat);
> +	pr_info("%s: found at %s, rev: %d, irq: %d, latency: %d, mmio: 0x%llx\n",
> +		dev->name, pci_name(pci_dev), dev->pci_rev, pci_dev->irq,
> +		dev->pci_lat, (u64)pci_resource_start(pci_dev, 0));
> +	pci_set_master(pci_dev);
> +	if (!pci_dma_supported(pci_dev, DMA_BIT_MASK(32))) {
> +		pr_info("%s: Oops: no 32bit PCI DMA ???\n", dev->name);
> +		err = -EIO;
> +		goto fail1;
> +	}
> +
> +	switch (pci_id->device) {
> +	case PCI_DEVICE_ID_6800:	/* TW6800 */
> +		dev->vdecoder = TW6800;
> +		dev->board_virqmask = TW68_VID_INTS;
> +		break;
> +	case PCI_DEVICE_ID_6801:	/* Video decoder for TW6802 */
> +		dev->vdecoder = TW6801;
> +		dev->board_virqmask = TW68_VID_INTS | TW68_VID_INTSX;
> +		break;
> +	case PCI_DEVICE_ID_6804:	/* Video decoder for TW6804 */
> +		dev->vdecoder = TW6804;
> +		dev->board_virqmask = TW68_VID_INTS | TW68_VID_INTSX;
> +		break;
> +	default:
> +		dev->vdecoder = TWXXXX;	/* To be announced */
> +		dev->board_virqmask = TW68_VID_INTS | TW68_VID_INTSX;
> +		break;
> +	}
> +
> +	/* get mmio */
> +	if (!request_mem_region(pci_resource_start(pci_dev, 0),
> +				pci_resource_len(pci_dev, 0),
> +				dev->name)) {
> +		err = -EBUSY;
> +		pr_err("%s: can't get MMIO memory @ 0x%llx\n",
> +			dev->name,
> +			(unsigned long long)pci_resource_start(pci_dev, 0));
> +		goto fail1;
> +	}
> +	dev->lmmio = ioremap(pci_resource_start(pci_dev, 0),
> +			     pci_resource_len(pci_dev, 0));
> +	dev->bmmio = (__u8 __iomem *)dev->lmmio;
> +	if (NULL == dev->lmmio) {
> +		err = -EIO;
> +		pr_err("%s: can't ioremap() MMIO memory\n",
> +		       dev->name);
> +		goto fail2;
> +	}
> +	/* initialize hardware #1 */
> +	/* Then do any initialisation wanted before interrupts are on */
> +	tw68_hw_init1(dev);
> +
> +	/* get irq */
> +	err = devm_request_irq(&pci_dev->dev, pci_dev->irq, tw68_irq,
> +			  IRQF_SHARED | IRQF_DISABLED, dev->name, dev);
> +	if (err < 0) {
> +		pr_err("%s: can't get IRQ %d\n",
> +		       dev->name, pci_dev->irq);
> +		goto fail3;
> +	}
> +
> +	/*
> +	 *  Now do remainder of initialisation, first for
> +	 *  things unique for this card, then for general board
> +	 */
> +	if (dev->instance < TW68_MAXBOARDS)
> +		vidnr = video_nr[dev->instance];
> +	/* initialise video function first */
> +	err = tw68_video_init2(dev, vidnr);
> +	if (err < 0) {
> +		pr_err("%s: can't register video device\n",
> +		       dev->name);
> +		goto fail4;
> +	}
> +	tw_setl(TW68_INTMASK, dev->pci_irqmask);
> +
> +	pr_info("%s: registered device %s\n",
> +	       dev->name, video_device_node_name(&dev->vdev));
> +
> +	return 0;
> +
> +fail4:
> +	video_unregister_device(&dev->vdev);
> +fail3:
> +	iounmap(dev->lmmio);
> +fail2:
> +	release_mem_region(pci_resource_start(pci_dev, 0),
> +			   pci_resource_len(pci_dev, 0));
> +fail1:
> +	v4l2_device_unregister(&dev->v4l2_dev);
> +	return err;
> +}
> +
> +static void tw68_finidev(struct pci_dev *pci_dev)
> +{
> +	struct v4l2_device *v4l2_dev = pci_get_drvdata(pci_dev);
> +	struct tw68_dev *dev =
> +		container_of(v4l2_dev, struct tw68_dev, v4l2_dev);
> +
> +	/* shutdown subsystems */
> +	tw_clearl(TW68_DMAC, TW68_DMAP_EN | TW68_FIFO_EN);
> +	tw_writel(TW68_INTMASK, 0);
> +
> +	/* unregister */
> +	video_unregister_device(&dev->vdev);
> +	v4l2_ctrl_handler_free(&dev->hdl);
> +
> +	/* release resources */
> +	iounmap(dev->lmmio);
> +	release_mem_region(pci_resource_start(pci_dev, 0),
> +			   pci_resource_len(pci_dev, 0));
> +
> +	v4l2_device_unregister(&dev->v4l2_dev);
> +}
> +
> +#ifdef CONFIG_PM
> +
> +static int tw68_suspend(struct pci_dev *pci_dev , pm_message_t state)
> +{
> +	struct v4l2_device *v4l2_dev = pci_get_drvdata(pci_dev);
> +	struct tw68_dev *dev = container_of(v4l2_dev,
> +				struct tw68_dev, v4l2_dev);
> +
> +	tw_clearl(TW68_DMAC, TW68_DMAP_EN | TW68_FIFO_EN);
> +	dev->pci_irqmask &= ~TW68_VID_INTS;
> +	tw_writel(TW68_INTMASK, 0);
> +
> +	synchronize_irq(pci_dev->irq);
> +
> +	pci_save_state(pci_dev);
> +	pci_set_power_state(pci_dev, pci_choose_state(pci_dev, state));
> +	vb2_discard_done(&dev->vidq);
> +
> +	return 0;
> +}
> +
> +static int tw68_resume(struct pci_dev *pci_dev)
> +{
> +	struct v4l2_device *v4l2_dev = pci_get_drvdata(pci_dev);
> +	struct tw68_dev *dev = container_of(v4l2_dev,
> +					    struct tw68_dev, v4l2_dev);
> +	struct tw68_buf *buf;
> +	unsigned long flags;
> +
> +	pci_set_power_state(pci_dev, PCI_D0);
> +	pci_restore_state(pci_dev);
> +
> +	/* Do things that are done in tw68_initdev ,
> +		except of initializing memory structures.*/
> +
> +	msleep(100);
> +
> +	tw68_set_tvnorm_hw(dev);
> +
> +	/*resume unfinished buffer(s)*/
> +	spin_lock_irqsave(&dev->slock, flags);
> +	buf = container_of(dev->active.next, struct tw68_buf, list);
> +
> +	tw68_video_start_dma(dev, buf);
> +
> +	spin_unlock_irqrestore(&dev->slock, flags);
> +
> +	return 0;
> +}
> +#endif
> +
> +/* ----------------------------------------------------------- */
> +
> +static struct pci_driver tw68_pci_driver = {
> +	.name	  = "tw68",
> +	.id_table = tw68_pci_tbl,
> +	.probe	  = tw68_initdev,
> +	.remove	  = tw68_finidev,
> +#ifdef CONFIG_PM
> +	.suspend  = tw68_suspend,
> +	.resume   = tw68_resume
> +#endif
> +};
> +
> +module_pci_driver(tw68_pci_driver);
> diff --git a/drivers/media/pci/tw68/tw68-reg.h b/drivers/media/pci/tw68/tw68-reg.h
> new file mode 100644
> index 0000000..f60b3a8
> --- /dev/null
> +++ b/drivers/media/pci/tw68/tw68-reg.h
> @@ -0,0 +1,195 @@
> +/*
> + *  tw68-reg.h - TW68xx register offsets
> + *
> + *  Much of this code is derived from the cx88 and sa7134 drivers, which
> + *  were in turn derived from the bt87x driver.  The original work was by
> + *  Gerd Knorr; more recently the code was enhanced by Mauro Carvalho Chehab,
> + *  Hans Verkuil, Andy Walls and many others.  Their work is gratefully
> + *  acknowledged.  Full credit goes to them - any problems within this code
> + *  are mine.
> + *
> + *  Copyright (C) William M. Brack
> + *
> + *  Refactored and updated to the latest v4l core frameworks:
> + *
> + *  Copyright (C) 2014 Hans Verkuil <hverkuil@xs4all.nl>
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> +*/
> +
> +#ifndef _TW68_REG_H_
> +#define _TW68_REG_H_
> +
> +/* ---------------------------------------------------------------------- */
> +#define	TW68_DMAC		0x000
> +#define	TW68_DMAP_SA		0x004
> +#define	TW68_DMAP_EXE		0x008
> +#define	TW68_DMAP_PP		0x00c
> +#define	TW68_VBIC		0x010
> +#define	TW68_SBUSC		0x014
> +#define	TW68_SBUSSD		0x018
> +#define	TW68_INTSTAT		0x01C
> +#define	TW68_INTMASK		0x020
> +#define	TW68_GPIOC		0x024
> +#define	TW68_GPOE		0x028
> +#define	TW68_TESTREG		0x02C
> +#define	TW68_SBUSRD		0x030
> +#define	TW68_SBUS_TRIG		0x034
> +#define	TW68_CAP_CTL		0x040
> +#define	TW68_SUBSYS		0x054
> +#define	TW68_I2C_RST		0x064
> +#define	TW68_VBIINST		0x06C
> +/* define bits in FIFO and DMAP Control reg */
> +#define	TW68_DMAP_EN		(1 << 0)
> +#define	TW68_FIFO_EN		(1 << 1)
> +/* define the Interrupt Status Register bits */
> +#define	TW68_SBDONE		(1 << 0)
> +#define	TW68_DMAPI		(1 << 1)
> +#define	TW68_GPINT		(1 << 2)
> +#define	TW68_FFOF		(1 << 3)
> +#define	TW68_FDMIS		(1 << 4)
> +#define	TW68_DMAPERR		(1 << 5)
> +#define	TW68_PABORT		(1 << 6)
> +#define	TW68_SBDONE2		(1 << 12)
> +#define	TW68_SBERR2		(1 << 13)
> +#define	TW68_PPERR		(1 << 14)
> +#define	TW68_FFERR		(1 << 15)
> +#define	TW68_DET50		(1 << 16)
> +#define	TW68_FLOCK		(1 << 17)
> +#define	TW68_CCVALID		(1 << 18)
> +#define	TW68_VLOCK		(1 << 19)
> +#define	TW68_FIELD		(1 << 20)
> +#define	TW68_SLOCK		(1 << 21)
> +#define	TW68_HLOCK		(1 << 22)
> +#define	TW68_VDLOSS		(1 << 23)
> +#define	TW68_SBERR		(1 << 24)
> +/* define the i2c control register bits */
> +#define	TW68_SBMODE		(0)
> +#define	TW68_WREN		(1)
> +#define	TW68_SSCLK		(6)
> +#define	TW68_SSDAT		(7)
> +#define	TW68_SBCLK		(8)
> +#define	TW68_WDLEN		(16)
> +#define	TW68_RDLEN		(20)
> +#define	TW68_SBRW		(24)
> +#define	TW68_SBDEV		(25)
> +
> +#define	TW68_SBMODE_B		(1 << TW68_SBMODE)
> +#define	TW68_WREN_B		(1 << TW68_WREN)
> +#define	TW68_SSCLK_B		(1 << TW68_SSCLK)
> +#define	TW68_SSDAT_B		(1 << TW68_SSDAT)
> +#define	TW68_SBRW_B		(1 << TW68_SBRW)
> +
> +#define	TW68_GPDATA		0x100
> +#define	TW68_STATUS1		0x204
> +#define	TW68_INFORM		0x208
> +#define	TW68_OPFORM		0x20C
> +#define	TW68_HSYNC		0x210
> +#define	TW68_ACNTL		0x218
> +#define	TW68_CROP_HI		0x21C
> +#define	TW68_VDELAY_LO		0x220
> +#define	TW68_VACTIVE_LO		0x224
> +#define	TW68_HDELAY_LO		0x228
> +#define	TW68_HACTIVE_LO		0x22C
> +#define	TW68_CNTRL1		0x230
> +#define	TW68_VSCALE_LO		0x234
> +#define	TW68_SCALE_HI		0x238
> +#define	TW68_HSCALE_LO		0x23C
> +#define	TW68_BRIGHT		0x240
> +#define	TW68_CONTRAST		0x244
> +#define	TW68_SHARPNESS		0x248
> +#define	TW68_SAT_U		0x24C
> +#define	TW68_SAT_V		0x250
> +#define	TW68_HUE		0x254
> +#define	TW68_SHARP2		0x258
> +#define	TW68_VSHARP		0x25C
> +#define	TW68_CORING		0x260
> +#define	TW68_VBICNTL		0x264
> +#define	TW68_CNTRL2		0x268
> +#define	TW68_CC_DATA		0x26C
> +#define	TW68_SDT		0x270
> +#define	TW68_SDTR		0x274
> +#define	TW68_RESERV2		0x278
> +#define	TW68_RESERV3		0x27C
> +#define	TW68_CLMPG		0x280
> +#define	TW68_IAGC		0x284
> +#define	TW68_AGCGAIN		0x288
> +#define	TW68_PEAKWT		0x28C
> +#define	TW68_CLMPL		0x290
> +#define	TW68_SYNCT		0x294
> +#define	TW68_MISSCNT		0x298
> +#define	TW68_PCLAMP		0x29C
> +#define	TW68_VCNTL1		0x2A0
> +#define	TW68_VCNTL2		0x2A4
> +#define	TW68_CKILL		0x2A8
> +#define	TW68_COMB		0x2AC
> +#define	TW68_LDLY		0x2B0
> +#define	TW68_MISC1		0x2B4
> +#define	TW68_LOOP		0x2B8
> +#define	TW68_MISC2		0x2BC
> +#define	TW68_MVSN		0x2C0
> +#define	TW68_STATUS2		0x2C4
> +#define	TW68_HFREF		0x2C8
> +#define	TW68_CLMD		0x2CC
> +#define	TW68_IDCNTL		0x2D0
> +#define	TW68_CLCNTL1		0x2D4
> +
> +/* Audio */
> +#define	TW68_ACKI1		0x300
> +#define	TW68_ACKI2		0x304
> +#define	TW68_ACKI3		0x308
> +#define	TW68_ACKN1		0x30C
> +#define	TW68_ACKN2		0x310
> +#define	TW68_ACKN3		0x314
> +#define	TW68_SDIV		0x318
> +#define	TW68_LRDIV		0x31C
> +#define	TW68_ACCNTL		0x320
> +
> +#define	TW68_VSCTL		0x3B8
> +#define	TW68_CHROMAGVAL		0x3BC
> +
> +#define	TW68_F2CROP_HI		0x3DC
> +#define	TW68_F2VDELAY_LO	0x3E0
> +#define	TW68_F2VACTIVE_LO	0x3E4
> +#define	TW68_F2HDELAY_LO	0x3E8
> +#define	TW68_F2HACTIVE_LO	0x3EC
> +#define	TW68_F2CNT		0x3F0
> +#define	TW68_F2VSCALE_LO	0x3F4
> +#define	TW68_F2SCALE_HI		0x3F8
> +#define	TW68_F2HSCALE_LO	0x3FC
> +
> +#define	RISC_INT_BIT		0x08000000
> +#define	RISC_SYNCO		0xC0000000
> +#define	RISC_SYNCE		0xD0000000
> +#define	RISC_JUMP		0xB0000000
> +#define	RISC_LINESTART		0x90000000
> +#define	RISC_INLINE		0xA0000000
> +
> +#define VideoFormatNTSC		 0
> +#define VideoFormatNTSCJapan	 0
> +#define VideoFormatPALBDGHI	 1
> +#define VideoFormatSECAM	 2
> +#define VideoFormatNTSC443	 3
> +#define VideoFormatPALM		 4
> +#define VideoFormatPALN		 5
> +#define VideoFormatPALNC	 5
> +#define VideoFormatPAL60	 6
> +#define VideoFormatAuto		 7
> +
> +#define ColorFormatRGB32	 0x00
> +#define ColorFormatRGB24	 0x10
> +#define ColorFormatRGB16	 0x20
> +#define ColorFormatRGB15	 0x30
> +#define ColorFormatYUY2		 0x40
> +#define ColorFormatBSWAP         0x04
> +#define ColorFormatWSWAP         0x08
> +#define ColorFormatGamma         0x80
> +#endif
> diff --git a/drivers/media/pci/tw68/tw68-risc.c b/drivers/media/pci/tw68/tw68-risc.c
> new file mode 100644
> index 0000000..7439db2
> --- /dev/null
> +++ b/drivers/media/pci/tw68/tw68-risc.c
> @@ -0,0 +1,230 @@
> +/*
> + *  tw68_risc.c
> + *  Part of the device driver for Techwell 68xx based cards
> + *
> + *  Much of this code is derived from the cx88 and sa7134 drivers, which
> + *  were in turn derived from the bt87x driver.  The original work was by
> + *  Gerd Knorr; more recently the code was enhanced by Mauro Carvalho Chehab,
> + *  Hans Verkuil, Andy Walls and many others.  Their work is gratefully
> + *  acknowledged.  Full credit goes to them - any problems within this code
> + *  are mine.
> + *
> + *  Copyright (C) 2009  William M. Brack
> + *
> + *  Refactored and updated to the latest v4l core frameworks:
> + *
> + *  Copyright (C) 2014 Hans Verkuil <hverkuil@xs4all.nl>
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + */
> +
> +#include "tw68.h"
> +
> +/**
> + *  @rp		pointer to current risc program position
> + *  @sglist	pointer to "scatter-gather list" of buffer pointers
> + *  @offset	offset to target memory buffer
> + *  @sync_line	0 -> no sync, 1 -> odd sync, 2 -> even sync
> + *  @bpl	number of bytes per scan line
> + *  @padding	number of bytes of padding to add
> + *  @lines	number of lines in field
> + *  @jump	insert a jump at the start
> + */
> +static __le32 *tw68_risc_field(__le32 *rp, struct scatterlist *sglist,
> +			    unsigned int offset, u32 sync_line,
> +			    unsigned int bpl, unsigned int padding,
> +			    unsigned int lines, bool jump)
> +{
> +	struct scatterlist *sg;
> +	unsigned int line, todo, done;
> +
> +	if (jump) {
> +		*(rp++) = cpu_to_le32(RISC_JUMP);
> +		*(rp++) = 0;
> +	}
> +
> +	/* sync instruction */
> +	if (sync_line == 1)
> +		*(rp++) = cpu_to_le32(RISC_SYNCO);
> +	else
> +		*(rp++) = cpu_to_le32(RISC_SYNCE);
> +	*(rp++) = 0;
> +
> +	/* scan lines */
> +	sg = sglist;
> +	for (line = 0; line < lines; line++) {
> +		/* calculate next starting position */
> +		while (offset && offset >= sg_dma_len(sg)) {
> +			offset -= sg_dma_len(sg);
> +			sg = sg_next(sg);
> +		}
> +		if (bpl <= sg_dma_len(sg) - offset) {
> +			/* fits into current chunk */
> +			*(rp++) = cpu_to_le32(RISC_LINESTART |
> +					      /* (offset<<12) |*/  bpl);
> +			*(rp++) = cpu_to_le32(sg_dma_address(sg) + offset);
> +			offset += bpl;
> +		} else {
> +			/*
> +			 * scanline needs to be split.  Put the start in
> +			 * whatever memory remains using RISC_LINESTART,
> +			 * then the remainder into following addresses
> +			 * given by the scatter-gather list.
> +			 */
> +			todo = bpl;	/* one full line to be done */
> +			/* first fragment */
> +			done = (sg_dma_len(sg) - offset);
> +			*(rp++) = cpu_to_le32(RISC_LINESTART |
> +						(7 << 24) |
> +						done);
> +			*(rp++) = cpu_to_le32(sg_dma_address(sg) + offset);
> +			todo -= done;
> +			sg = sg_next(sg);
> +			/* succeeding fragments have no offset */
> +			while (todo > sg_dma_len(sg)) {
> +				*(rp++) = cpu_to_le32(RISC_INLINE |
> +						(done << 12) |
> +						sg_dma_len(sg));
> +				*(rp++) = cpu_to_le32(sg_dma_address(sg));
> +				todo -= sg_dma_len(sg);
> +				sg = sg_next(sg);
> +				done += sg_dma_len(sg);
> +			}
> +			if (todo) {
> +				/* final chunk - offset 0, count 'todo' */
> +				*(rp++) = cpu_to_le32(RISC_INLINE |
> +							(done << 12) |
> +							todo);
> +				*(rp++) = cpu_to_le32(sg_dma_address(sg));
> +			}
> +			offset = todo;
> +		}
> +		offset += padding;
> +	}
> +
> +	return rp;
> +}
> +
> +/**
> + * tw68_risc_buffer
> + *
> + *	This routine is called by tw68-video.  It allocates
> + *	memory for the dma controller "program" and then fills in that
> + *	memory with the appropriate "instructions".
> + *
> + *	@pci_dev	structure with info about the pci
> + *			slot which our device is in.
> + *	@risc		structure with info about the memory
> + *			used for our controller program.
> + *	@sglist		scatter-gather list entry
> + *	@top_offset	offset within the risc program area for the
> + *			first odd frame line
> + *	@bottom_offset	offset within the risc program area for the
> + *			first even frame line
> + *	@bpl		number of data bytes per scan line
> + *	@padding	number of extra bytes to add at end of line
> + *	@lines		number of scan lines
> + */
> +int tw68_risc_buffer(struct pci_dev *pci,
> +			struct tw68_buf *buf,
> +			struct scatterlist *sglist,
> +			unsigned int top_offset,
> +			unsigned int bottom_offset,
> +			unsigned int bpl,
> +			unsigned int padding,
> +			unsigned int lines)
> +{
> +	u32 instructions, fields;
> +	__le32 *rp;
> +
> +	fields = 0;
> +	if (UNSET != top_offset)
> +		fields++;
> +	if (UNSET != bottom_offset)
> +		fields++;
> +	/*
> +	 * estimate risc mem: worst case is one write per page border +
> +	 * one write per scan line + syncs + 2 jumps (all 2 dwords).
> +	 * Padding can cause next bpl to start close to a page border.
> +	 * First DMA region may be smaller than PAGE_SIZE
> +	 */
> +	instructions  = fields * (1 + (((bpl + padding) * lines) /
> +			 PAGE_SIZE) + lines) + 4;
> +	buf->size = instructions * 8;
> +	buf->cpu = pci_alloc_consistent(pci, buf->size, &buf->dma);
> +	if (buf->cpu == NULL)
> +		return -ENOMEM;
> +
> +	/* write risc instructions */
> +	rp = buf->cpu;
> +	if (UNSET != top_offset)	/* generates SYNCO */
> +		rp = tw68_risc_field(rp, sglist, top_offset, 1,
> +				     bpl, padding, lines, true);
> +	if (UNSET != bottom_offset)	/* generates SYNCE */
> +		rp = tw68_risc_field(rp, sglist, bottom_offset, 2,
> +				     bpl, padding, lines, top_offset == UNSET);
> +
> +	/* save pointer to jmp instruction address */
> +	buf->jmp = rp;
> +	buf->cpu[1] = cpu_to_le32(buf->dma + 8);
> +	/* assure risc buffer hasn't overflowed */
> +	BUG_ON((buf->jmp - buf->cpu + 2) * sizeof(buf->cpu[0]) > buf->size);
> +	return 0;
> +}
> +
> +#if 0
> +/* ------------------------------------------------------------------ */
> +/* debug helper code                                                  */
> +
> +static void tw68_risc_decode(u32 risc, u32 addr)
> +{
> +#define	RISC_OP(reg)	(((reg) >> 28) & 7)
> +	static struct instr_details {
> +		char *name;
> +		u8 has_data_type;
> +		u8 has_byte_info;
> +		u8 has_addr;
> +	} instr[8] = {
> +		[RISC_OP(RISC_SYNCO)]	  = {"syncOdd", 0, 0, 0},
> +		[RISC_OP(RISC_SYNCE)]	  = {"syncEven", 0, 0, 0},
> +		[RISC_OP(RISC_JUMP)]	  = {"jump", 0, 0, 1},
> +		[RISC_OP(RISC_LINESTART)] = {"lineStart", 1, 1, 1},
> +		[RISC_OP(RISC_INLINE)]	  = {"inline", 1, 1, 1},
> +	};
> +	u32 p;
> +
> +	p = RISC_OP(risc);
> +	if (!(risc & 0x80000000) || !instr[p].name) {
> +		pr_debug("0x%08x [ INVALID ]\n", risc);
> +		return;
> +	}
> +	pr_debug("0x%08x %-9s IRQ=%d",
> +		risc, instr[p].name, (risc >> 27) & 1);
> +	if (instr[p].has_data_type)
> +		pr_debug(" Type=%d", (risc >> 24) & 7);
> +	if (instr[p].has_byte_info)
> +		pr_debug(" Start=0x%03x Count=%03u",
> +			(risc >> 12) & 0xfff, risc & 0xfff);
> +	if (instr[p].has_addr)
> +		pr_debug(" StartAddr=0x%08x", addr);
> +	pr_debug("\n");
> +}
> +
> +void tw68_risc_program_dump(struct tw68_core *core, struct tw68_buf *buf)
> +{
> +	const __le32 *addr;
> +
> +	pr_debug("%s: risc_program_dump: risc=%p, buf->cpu=0x%p, buf->jmp=0x%p\n",
> +		  core->name, buf, buf->cpu, buf->jmp);
> +	for (addr = buf->cpu; addr <= buf->jmp; addr += 2)
> +		tw68_risc_decode(*addr, *(addr+1));
> +}
> +#endif
> diff --git a/drivers/media/pci/tw68/tw68-video.c b/drivers/media/pci/tw68/tw68-video.c
> new file mode 100644
> index 0000000..66fae23
> --- /dev/null
> +++ b/drivers/media/pci/tw68/tw68-video.c
> @@ -0,0 +1,1060 @@
> +/*
> + *  tw68 functions to handle video data
> + *
> + *  Much of this code is derived from the cx88 and sa7134 drivers, which
> + *  were in turn derived from the bt87x driver.  The original work was by
> + *  Gerd Knorr; more recently the code was enhanced by Mauro Carvalho Chehab,
> + *  Hans Verkuil, Andy Walls and many others.  Their work is gratefully
> + *  acknowledged.  Full credit goes to them - any problems within this code
> + *  are mine.
> + *
> + *  Copyright (C) 2009  William M. Brack
> + *
> + *  Refactored and updated to the latest v4l core frameworks:
> + *
> + *  Copyright (C) 2014 Hans Verkuil <hverkuil@xs4all.nl>
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + */
> +
> +#include <linux/module.h>
> +#include <media/v4l2-common.h>
> +#include <media/v4l2-event.h>
> +#include <media/videobuf2-dma-sg.h>
> +
> +#include "tw68.h"
> +#include "tw68-reg.h"
> +
> +/* ------------------------------------------------------------------ */
> +/* data structs for video                                             */
> +/*
> + * FIXME -
> + * Note that the saa7134 has formats, e.g. YUV420, which are classified
> + * as "planar".  These affect overlay mode, and are flagged with a field
> + * ".planar" in the format.  Do we need to implement this in this driver?
> + */
> +static const struct tw68_format formats[] = {
> +	{
> +		.name		= "15 bpp RGB, le",
> +		.fourcc		= V4L2_PIX_FMT_RGB555,
> +		.depth		= 16,
> +		.twformat	= ColorFormatRGB15,
> +	}, {
> +		.name		= "15 bpp RGB, be",
> +		.fourcc		= V4L2_PIX_FMT_RGB555X,
> +		.depth		= 16,
> +		.twformat	= ColorFormatRGB15 | ColorFormatBSWAP,
> +	}, {
> +		.name		= "16 bpp RGB, le",
> +		.fourcc		= V4L2_PIX_FMT_RGB565,
> +		.depth		= 16,
> +		.twformat	= ColorFormatRGB16,
> +	}, {
> +		.name		= "16 bpp RGB, be",
> +		.fourcc		= V4L2_PIX_FMT_RGB565X,
> +		.depth		= 16,
> +		.twformat	= ColorFormatRGB16 | ColorFormatBSWAP,
> +	}, {
> +		.name		= "24 bpp RGB, le",
> +		.fourcc		= V4L2_PIX_FMT_BGR24,
> +		.depth		= 24,
> +		.twformat	= ColorFormatRGB24,
> +	}, {
> +		.name		= "24 bpp RGB, be",
> +		.fourcc		= V4L2_PIX_FMT_RGB24,
> +		.depth		= 24,
> +		.twformat	= ColorFormatRGB24 | ColorFormatBSWAP,
> +	}, {
> +		.name		= "32 bpp RGB, le",
> +		.fourcc		= V4L2_PIX_FMT_BGR32,
> +		.depth		= 32,
> +		.twformat	= ColorFormatRGB32,
> +	}, {
> +		.name		= "32 bpp RGB, be",
> +		.fourcc		= V4L2_PIX_FMT_RGB32,
> +		.depth		= 32,
> +		.twformat	= ColorFormatRGB32 | ColorFormatBSWAP |
> +				  ColorFormatWSWAP,
> +	}, {
> +		.name		= "4:2:2 packed, YUYV",
> +		.fourcc		= V4L2_PIX_FMT_YUYV,
> +		.depth		= 16,
> +		.twformat	= ColorFormatYUY2,
> +	}, {
> +		.name		= "4:2:2 packed, UYVY",
> +		.fourcc		= V4L2_PIX_FMT_UYVY,
> +		.depth		= 16,
> +		.twformat	= ColorFormatYUY2 | ColorFormatBSWAP,
> +	}
> +};
> +#define FORMATS ARRAY_SIZE(formats)
> +
> +#define NORM_625_50			\
> +		.h_delay	= 3,	\
> +		.h_delay0	= 133,	\
> +		.h_start	= 0,	\
> +		.h_stop		= 719,	\
> +		.v_delay	= 24,	\
> +		.vbi_v_start_0	= 7,	\
> +		.vbi_v_stop_0	= 22,	\
> +		.video_v_start	= 24,	\
> +		.video_v_stop	= 311,	\
> +		.vbi_v_start_1	= 319
> +
> +#define NORM_525_60			\
> +		.h_delay	= 8,	\
> +		.h_delay0	= 138,	\
> +		.h_start	= 0,	\
> +		.h_stop		= 719,	\
> +		.v_delay	= 22,	\
> +		.vbi_v_start_0	= 10,	\
> +		.vbi_v_stop_0	= 21,	\
> +		.video_v_start	= 22,	\
> +		.video_v_stop	= 262,	\
> +		.vbi_v_start_1	= 273
> +
> +/*
> + * The following table is searched by tw68_s_std, first for a specific
> + * match, then for an entry which contains the desired id.  The table
> + * entries should therefore be ordered in ascending order of specificity.
> + */
> +static const struct tw68_tvnorm tvnorms[] = {
> +	{
> +		.name		= "PAL", /* autodetect */
> +		.id		= V4L2_STD_PAL,
> +		NORM_625_50,
> +
> +		.sync_control	= 0x18,
> +		.luma_control	= 0x40,
> +		.chroma_ctrl1	= 0x81,
> +		.chroma_gain	= 0x2a,
> +		.chroma_ctrl2	= 0x06,
> +		.vgate_misc	= 0x1c,
> +		.format		= VideoFormatPALBDGHI,
> +	}, {
> +		.name		= "NTSC",
> +		.id		= V4L2_STD_NTSC,
> +		NORM_525_60,
> +
> +		.sync_control	= 0x59,
> +		.luma_control	= 0x40,
> +		.chroma_ctrl1	= 0x89,
> +		.chroma_gain	= 0x2a,
> +		.chroma_ctrl2	= 0x0e,
> +		.vgate_misc	= 0x18,
> +		.format		= VideoFormatNTSC,
> +	}, {
> +		.name		= "SECAM",
> +		.id		= V4L2_STD_SECAM,
> +		NORM_625_50,
> +
> +		.sync_control	= 0x18,
> +		.luma_control	= 0x1b,
> +		.chroma_ctrl1	= 0xd1,
> +		.chroma_gain	= 0x80,
> +		.chroma_ctrl2	= 0x00,
> +		.vgate_misc	= 0x1c,
> +		.format		= VideoFormatSECAM,
> +	}, {
> +		.name		= "PAL-M",
> +		.id		= V4L2_STD_PAL_M,
> +		NORM_525_60,
> +
> +		.sync_control	= 0x59,
> +		.luma_control	= 0x40,
> +		.chroma_ctrl1	= 0xb9,
> +		.chroma_gain	= 0x2a,
> +		.chroma_ctrl2	= 0x0e,
> +		.vgate_misc	= 0x18,
> +		.format		= VideoFormatPALM,
> +	}, {
> +		.name		= "PAL-Nc",
> +		.id		= V4L2_STD_PAL_Nc,
> +		NORM_625_50,
> +
> +		.sync_control	= 0x18,
> +		.luma_control	= 0x40,
> +		.chroma_ctrl1	= 0xa1,
> +		.chroma_gain	= 0x2a,
> +		.chroma_ctrl2	= 0x06,
> +		.vgate_misc	= 0x1c,
> +		.format		= VideoFormatPALNC,
> +	}, {
> +		.name		= "PAL-60",
> +		.id		= V4L2_STD_PAL_60,
> +		.h_delay	= 186,
> +		.h_start	= 0,
> +		.h_stop		= 719,
> +		.v_delay	= 26,
> +		.video_v_start	= 23,
> +		.video_v_stop	= 262,
> +		.vbi_v_start_0	= 10,
> +		.vbi_v_stop_0	= 21,
> +		.vbi_v_start_1	= 273,
> +
> +		.sync_control	= 0x18,
> +		.luma_control	= 0x40,
> +		.chroma_ctrl1	= 0x81,
> +		.chroma_gain	= 0x2a,
> +		.chroma_ctrl2	= 0x06,
> +		.vgate_misc	= 0x1c,
> +		.format		= VideoFormatPAL60,
> +	}
> +};
> +#define TVNORMS ARRAY_SIZE(tvnorms)
> +
> +static const struct tw68_format *format_by_fourcc(unsigned int fourcc)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < FORMATS; i++)
> +		if (formats[i].fourcc == fourcc)
> +			return formats+i;
> +	return NULL;
> +}
> +
> +
> +/* ------------------------------------------------------------------ */
> +/*
> + * Note that the cropping rectangles are described in terms of a single
> + * frame, i.e. line positions are only 1/2 the interlaced equivalent
> + */
> +static void set_tvnorm(struct tw68_dev *dev, const struct tw68_tvnorm *norm)
> +{
> +	if (norm != dev->tvnorm) {
> +		dev->width = 720;
> +		dev->height = (norm->id & V4L2_STD_525_60) ? 480 : 576;
> +		dev->tvnorm = norm;
> +		tw68_set_tvnorm_hw(dev);
> +	}
> +}
> +
> +/*
> + * tw68_set_scale
> + *
> + * Scaling and Cropping for video decoding
> + *
> + * We are working with 3 values for horizontal and vertical - scale,
> + * delay and active.
> + *
> + * HACTIVE represent the actual number of pixels in the "usable" image,
> + * before scaling.  HDELAY represents the number of pixels skipped
> + * between the start of the horizontal sync and the start of the image.
> + * HSCALE is calculated using the formula
> + *	HSCALE = (HACTIVE / (#pixels desired)) * 256
> + *
> + * The vertical registers are similar, except based upon the total number
> + * of lines in the image, and the first line of the image (i.e. ignoring
> + * vertical sync and VBI).
> + *
> + * Note that the number of bytes reaching the FIFO (and hence needing
> + * to be processed by the DMAP program) is completely dependent upon
> + * these values, especially HSCALE.
> + *
> + * Parameters:
> + *	@dev		pointer to the device structure, needed for
> + *			getting current norm (as well as debug print)
> + *	@width		actual image width (from user buffer)
> + *	@height		actual image height
> + *	@field		indicates Top, Bottom or Interlaced
> + */
> +static int tw68_set_scale(struct tw68_dev *dev, unsigned int width,
> +			  unsigned int height, enum v4l2_field field)
> +{
> +	const struct tw68_tvnorm *norm = dev->tvnorm;
> +	/* set individually for debugging clarity */
> +	int hactive, hdelay, hscale;
> +	int vactive, vdelay, vscale;
> +	int comb;
> +
> +	if (V4L2_FIELD_HAS_BOTH(field))	/* if field is interlaced */
> +		height /= 2;		/* we must set for 1-frame */
> +
> +	pr_debug("%s: width=%d, height=%d, both=%d\n"
> +		 "  tvnorm h_delay=%d, h_start=%d, h_stop=%d, "
> +		 "v_delay=%d, v_start=%d, v_stop=%d\n" , __func__,
> +		width, height, V4L2_FIELD_HAS_BOTH(field),
> +		norm->h_delay, norm->h_start, norm->h_stop,
> +		norm->v_delay, norm->video_v_start,
> +		norm->video_v_stop);
> +
> +	switch (dev->vdecoder) {
> +	case TW6800:
> +		hdelay = norm->h_delay0;
> +		break;
> +	default:
> +		hdelay = norm->h_delay;
> +		break;
> +	}
> +
> +	hdelay += norm->h_start;
> +	hactive = norm->h_stop - norm->h_start + 1;
> +
> +	hscale = (hactive * 256) / (width);
> +
> +	vdelay = norm->v_delay;
> +	vactive = ((norm->id & V4L2_STD_525_60) ? 524 : 624) / 2 - norm->video_v_start;
> +	vscale = (vactive * 256) / height;
> +
> +	pr_debug("%s: %dx%d [%s%s,%s]\n", __func__,
> +		width, height,
> +		V4L2_FIELD_HAS_TOP(field)    ? "T" : "",
> +		V4L2_FIELD_HAS_BOTTOM(field) ? "B" : "",
> +		v4l2_norm_to_name(dev->tvnorm->id));
> +	pr_debug("%s: hactive=%d, hdelay=%d, hscale=%d; "
> +		"vactive=%d, vdelay=%d, vscale=%d\n", __func__,
> +		hactive, hdelay, hscale, vactive, vdelay, vscale);
> +
> +	comb =	((vdelay & 0x300)  >> 2) |
> +		((vactive & 0x300) >> 4) |
> +		((hdelay & 0x300)  >> 6) |
> +		((hactive & 0x300) >> 8);
> +	pr_debug("%s: setting CROP_HI=%02x, VDELAY_LO=%02x, "
> +		"VACTIVE_LO=%02x, HDELAY_LO=%02x, HACTIVE_LO=%02x\n",
> +		__func__, comb, vdelay, vactive, hdelay, hactive);
> +	tw_writeb(TW68_CROP_HI, comb);
> +	tw_writeb(TW68_VDELAY_LO, vdelay & 0xff);
> +	tw_writeb(TW68_VACTIVE_LO, vactive & 0xff);
> +	tw_writeb(TW68_HDELAY_LO, hdelay & 0xff);
> +	tw_writeb(TW68_HACTIVE_LO, hactive & 0xff);
> +
> +	comb = ((vscale & 0xf00) >> 4) | ((hscale & 0xf00) >> 8);
> +	pr_debug("%s: setting SCALE_HI=%02x, VSCALE_LO=%02x, "
> +		"HSCALE_LO=%02x\n", __func__, comb, vscale, hscale);
> +	tw_writeb(TW68_SCALE_HI, comb);
> +	tw_writeb(TW68_VSCALE_LO, vscale);
> +	tw_writeb(TW68_HSCALE_LO, hscale);
> +
> +	return 0;
> +}
> +
> +/* ------------------------------------------------------------------ */
> +
> +int tw68_video_start_dma(struct tw68_dev *dev, struct tw68_buf *buf)
> +{
> +	/* Set cropping and scaling */
> +	tw68_set_scale(dev, dev->width, dev->height, dev->field);
> +	/*
> +	 *  Set start address for RISC program.  Note that if the DMAP
> +	 *  processor is currently running, it must be stopped before
> +	 *  a new address can be set.
> +	 */
> +	tw_clearl(TW68_DMAC, TW68_DMAP_EN);
> +	tw_writel(TW68_DMAP_SA, cpu_to_le32(buf->dma));
> +	/* Clear any pending interrupts */
> +	tw_writel(TW68_INTSTAT, dev->board_virqmask);
> +	/* Enable the risc engine and the fifo */
> +	tw_andorl(TW68_DMAC, 0xff, dev->fmt->twformat |
> +		ColorFormatGamma | TW68_DMAP_EN | TW68_FIFO_EN);
> +	dev->pci_irqmask |= dev->board_virqmask;
> +	tw_setl(TW68_INTMASK, dev->pci_irqmask);
> +	return 0;
> +}
> +
> +/* ------------------------------------------------------------------ */
> +
> +/* nr of (tw68-)pages for the given buffer size */
> +static int tw68_buffer_pages(int size)
> +{
> +	size  = PAGE_ALIGN(size);
> +	size += PAGE_SIZE; /* for non-page-aligned buffers */
> +	size /= 4096;

The above seems to be wrong, as PAGE_SIZE is not always 4096.

IMHO, the correct would be to do size /= PAGE_SIZE, if the intent is
to return the number of pages.

> +	return size;
> +}
> +
> +/* calc max # of buffers from size (must not exceed the 4MB virtual
> + * address space per DMA channel) */
> +static int tw68_buffer_count(unsigned int size, unsigned int count)
> +{
> +	unsigned int maxcount;
> +
> +	maxcount = 1024 / tw68_buffer_pages(size);

Again, the 1024 here looks weird, as it seems to also be assuming a
4096 page size.

> +	if (count > maxcount)
> +		count = maxcount;
> +	return count;
> +}
> +
> +/* ------------------------------------------------------------- */
> +/* vb2 queue operations                                          */
> +
> +static int tw68_queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
> +			   unsigned int *num_buffers, unsigned int *num_planes,
> +			   unsigned int sizes[], void *alloc_ctxs[])
> +{
> +	struct tw68_dev *dev = vb2_get_drv_priv(q);
> +	unsigned tot_bufs = q->num_buffers + *num_buffers;
> +
> +	sizes[0] = (dev->fmt->depth * dev->width * dev->height) >> 3;
> +	/*
> +	 * We allow create_bufs, but only if the sizeimage is the same as the
> +	 * current sizeimage. The tw68_buffer_count calculation becomes quite
> +	 * difficult otherwise.
> +	 */
> +	if (fmt && fmt->fmt.pix.sizeimage < sizes[0])
> +		return -EINVAL;
> +	*num_planes = 1;
> +	if (tot_bufs < 2)
> +		tot_bufs = 2;
> +	tot_bufs = tw68_buffer_count(sizes[0], tot_bufs);
> +	*num_buffers = tot_bufs - q->num_buffers;
> +
> +	return 0;
> +}
> +
> +/*
> + * The risc program for each buffers works as follows: it starts with a simple
> + * 'JUMP to addr + 8', which is effectively a NOP. Then the program to DMA the
> + * buffer follows and at the end we have a JUMP back to the start + 8 (skipping
> + * the initial JUMP).
> + *
> + * This is the program of the first buffer to be queued if the active list is
> + * empty and it just keeps DMAing this buffer without generating any interrupts.
> + *
> + * If a new buffer is added then the initial JUMP in the program generates an
> + * interrupt as well which signals that the previous buffer has been DMAed
> + * successfully and that it can be returned to userspace.
> + *
> + * It also sets the final jump of the previous buffer to the start of the new
> + * buffer, thus chaining the new buffer into the DMA chain. This is a single
> + * atomic u32 write, so there is no race condition.
> + *
> + * The end-result of all this that you only get an interrupt when a buffer
> + * is ready, so the control flow is very easy.
> + */
> +static void tw68_buf_queue(struct vb2_buffer *vb)
> +{
> +	struct vb2_queue *vq = vb->vb2_queue;
> +	struct tw68_dev *dev = vb2_get_drv_priv(vq);
> +	struct tw68_buf *buf = container_of(vb, struct tw68_buf, vb);
> +	struct tw68_buf *prev;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&dev->slock, flags);
> +
> +	/* append a 'JUMP to start of buffer' to the buffer risc program */
> +	buf->jmp[0] = cpu_to_le32(RISC_JUMP);
> +	buf->jmp[1] = cpu_to_le32(buf->dma + 8);
> +
> +	if (!list_empty(&dev->active)) {
> +		prev = list_entry(dev->active.prev, struct tw68_buf, list);
> +		buf->cpu[0] |= cpu_to_le32(RISC_INT_BIT);
> +		prev->jmp[1] = cpu_to_le32(buf->dma);
> +	}
> +	list_add_tail(&buf->list, &dev->active);
> +	spin_unlock_irqrestore(&dev->slock, flags);
> +}
> +
> +/*
> + * buffer_prepare
> + *
> + * Set the ancilliary information into the buffer structure.  This
> + * includes generating the necessary risc program if it hasn't already
> + * been done for the current buffer format.
> + * The structure fh contains the details of the format requested by the
> + * user - type, width, height and #fields.  This is compared with the
> + * last format set for the current buffer.  If they differ, the risc
> + * code (which controls the filling of the buffer) is (re-)generated.
> + */
> +static int tw68_buf_prepare(struct vb2_buffer *vb)
> +{
> +	struct vb2_queue *vq = vb->vb2_queue;
> +	struct tw68_dev *dev = vb2_get_drv_priv(vq);
> +	struct tw68_buf *buf = container_of(vb, struct tw68_buf, vb);
> +	struct sg_table *dma = vb2_dma_sg_plane_desc(vb, 0);
> +	unsigned size, bpl;
> +	int rc;
> +
> +	size = (dev->width * dev->height * dev->fmt->depth) >> 3;
> +	if (vb2_plane_size(vb, 0) < size)
> +		return -EINVAL;
> +	vb2_set_plane_payload(vb, 0, size);
> +
> +	rc = dma_map_sg(&dev->pci->dev, dma->sgl, dma->nents, DMA_FROM_DEVICE);
> +	if (!rc)
> +		return -EIO;
> +
> +	bpl = (dev->width * dev->fmt->depth) >> 3;
> +	switch (dev->field) {
> +	case V4L2_FIELD_TOP:
> +		tw68_risc_buffer(dev->pci, buf, dma->sgl,
> +				 0, UNSET, bpl, 0, dev->height);
> +		break;
> +	case V4L2_FIELD_BOTTOM:
> +		tw68_risc_buffer(dev->pci, buf, dma->sgl,
> +				 UNSET, 0, bpl, 0, dev->height);
> +		break;
> +	case V4L2_FIELD_SEQ_TB:
> +		tw68_risc_buffer(dev->pci, buf, dma->sgl,
> +				 0, bpl * (dev->height >> 1),
> +				 bpl, 0, dev->height >> 1);
> +		break;
> +	case V4L2_FIELD_SEQ_BT:
> +		tw68_risc_buffer(dev->pci, buf, dma->sgl,
> +				 bpl * (dev->height >> 1), 0,
> +				 bpl, 0, dev->height >> 1);
> +		break;
> +	case V4L2_FIELD_INTERLACED:
> +	default:
> +		tw68_risc_buffer(dev->pci, buf, dma->sgl,
> +				 0, bpl, bpl, bpl, dev->height >> 1);
> +		break;
> +	}
> +	return 0;
> +}
> +
> +static void tw68_buf_finish(struct vb2_buffer *vb)
> +{
> +	struct vb2_queue *vq = vb->vb2_queue;
> +	struct tw68_dev *dev = vb2_get_drv_priv(vq);
> +	struct sg_table *dma = vb2_dma_sg_plane_desc(vb, 0);
> +	struct tw68_buf *buf = container_of(vb, struct tw68_buf, vb);
> +
> +	dma_unmap_sg(&dev->pci->dev, dma->sgl, dma->nents, DMA_FROM_DEVICE);
> +
> +	pci_free_consistent(dev->pci, buf->size, buf->cpu, buf->dma);
> +}
> +
> +static int tw68_start_streaming(struct vb2_queue *q, unsigned int count)
> +{
> +	struct tw68_dev *dev = vb2_get_drv_priv(q);

> +	struct tw68_buf *buf =
> +		container_of(dev->active.next, struct tw68_buf, list);

Please put the above statement into a single line.

> +
> +	dev->seqnr = 0;
> +	tw68_video_start_dma(dev, buf);
> +	return 0;
> +}
> +
> +static void tw68_stop_streaming(struct vb2_queue *q)
> +{
> +	struct tw68_dev *dev = vb2_get_drv_priv(q);
> +
> +	/* Stop risc & fifo */
> +	tw_clearl(TW68_DMAC, TW68_DMAP_EN | TW68_FIFO_EN);
> +	while (!list_empty(&dev->active)) {
> +		struct tw68_buf *buf =
> +			container_of(dev->active.next, struct tw68_buf, list);

Same here. Or if you want to use multiple lines, do it like:

		struct tw68_buf *buf;

		buf = container_of(dev->active.next, struct tw68_buf, list);

(personally, I prefer this way)

Same on other similar places.

> +
> +		list_del(&buf->list);
> +		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
> +	}
> +}
> +
> +static struct vb2_ops tw68_video_qops = {
> +	.queue_setup	= tw68_queue_setup,
> +	.buf_queue	= tw68_buf_queue,
> +	.buf_prepare	= tw68_buf_prepare,
> +	.buf_finish	= tw68_buf_finish,
> +	.start_streaming = tw68_start_streaming,
> +	.stop_streaming = tw68_stop_streaming,
> +	.wait_prepare	= vb2_ops_wait_prepare,
> +	.wait_finish	= vb2_ops_wait_finish,
> +};
> +
> +/* ------------------------------------------------------------------ */
> +
> +static int tw68_s_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct tw68_dev *dev =
> +		container_of(ctrl->handler, struct tw68_dev, hdl);
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_BRIGHTNESS:
> +		tw_writeb(TW68_BRIGHT, ctrl->val);
> +		break;
> +	case V4L2_CID_HUE:
> +		tw_writeb(TW68_HUE, ctrl->val);
> +		break;
> +	case V4L2_CID_CONTRAST:
> +		tw_writeb(TW68_CONTRAST, ctrl->val);
> +		break;
> +	case V4L2_CID_SATURATION:
> +		tw_writeb(TW68_SAT_U, ctrl->val);
> +		tw_writeb(TW68_SAT_V, ctrl->val);
> +		break;
> +	case V4L2_CID_COLOR_KILLER:
> +		if (ctrl->val)
> +			tw_andorb(TW68_MISC2, 0xe0, 0xe0);
> +		else
> +			tw_andorb(TW68_MISC2, 0xe0, 0x00);
> +		break;
> +	case V4L2_CID_CHROMA_AGC:
> +		if (ctrl->val)
> +			tw_andorb(TW68_LOOP, 0x30, 0x20);
> +		else
> +			tw_andorb(TW68_LOOP, 0x30, 0x00);
> +		break;
> +	}
> +	return 0;
> +}
> +
> +/* ------------------------------------------------------------------ */
> +
> +/*
> + * Note that this routine returns what is stored in the fh structure, and
> + * does not interrogate any of the device registers.
> + */
> +static int tw68_g_fmt_vid_cap(struct file *file, void *priv,
> +				struct v4l2_format *f)
> +{
> +	struct tw68_dev *dev = video_drvdata(file);
> +
> +	f->fmt.pix.width        = dev->width;
> +	f->fmt.pix.height       = dev->height;
> +	f->fmt.pix.field        = dev->field;
> +	f->fmt.pix.pixelformat  = dev->fmt->fourcc;
> +	f->fmt.pix.bytesperline =
> +		(f->fmt.pix.width * (dev->fmt->depth)) >> 3;
> +	f->fmt.pix.sizeimage =
> +		f->fmt.pix.height * f->fmt.pix.bytesperline;
> +	f->fmt.pix.colorspace	= V4L2_COLORSPACE_SMPTE170M;
> +	f->fmt.pix.priv = 0;
> +	return 0;
> +}
> +
> +static int tw68_try_fmt_vid_cap(struct file *file, void *priv,
> +						struct v4l2_format *f)
> +{
> +	struct tw68_dev *dev = video_drvdata(file);
> +	const struct tw68_format *fmt;
> +	enum v4l2_field field;
> +	unsigned int maxh;
> +
> +	fmt = format_by_fourcc(f->fmt.pix.pixelformat);
> +	if (NULL == fmt)
> +		return -EINVAL;
> +
> +	field = f->fmt.pix.field;
> +	maxh  = (dev->tvnorm->id & V4L2_STD_525_60) ? 480 : 576;
> +
> +	switch (field) {
> +	case V4L2_FIELD_TOP:
> +	case V4L2_FIELD_BOTTOM:
> +		break;
> +	case V4L2_FIELD_INTERLACED:
> +	case V4L2_FIELD_SEQ_BT:
> +	case V4L2_FIELD_SEQ_TB:
> +		maxh = maxh * 2;
> +		break;
> +	default:
> +		field = (f->fmt.pix.height > maxh / 2)
> +			? V4L2_FIELD_INTERLACED
> +			: V4L2_FIELD_BOTTOM;
> +		break;
> +	}
> +
> +	f->fmt.pix.field = field;
> +	if (f->fmt.pix.width  < 48)
> +		f->fmt.pix.width  = 48;
> +	if (f->fmt.pix.height < 32)
> +		f->fmt.pix.height = 32;
> +	if (f->fmt.pix.width > 720)
> +		f->fmt.pix.width = 720;
> +	if (f->fmt.pix.height > maxh)
> +		f->fmt.pix.height = maxh;
> +	f->fmt.pix.width &= ~0x03;
> +	f->fmt.pix.bytesperline =
> +		(f->fmt.pix.width * (fmt->depth)) >> 3;
> +	f->fmt.pix.sizeimage =
> +		f->fmt.pix.height * f->fmt.pix.bytesperline;
> +	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
> +	return 0;
> +}
> +
> +/*
> + * Note that tw68_s_fmt_vid_cap sets the information into the fh structure,
> + * and it will be used for all future new buffers.  However, there could be
> + * some number of buffers on the "active" chain which will be filled before
> + * the change takes place.
> + */
> +static int tw68_s_fmt_vid_cap(struct file *file, void *priv,
> +					struct v4l2_format *f)
> +{
> +	struct tw68_dev *dev = video_drvdata(file);
> +	int err;
> +
> +	err = tw68_try_fmt_vid_cap(file, priv, f);
> +	if (0 != err)
> +		return err;
> +
> +	dev->fmt = format_by_fourcc(f->fmt.pix.pixelformat);
> +	dev->width = f->fmt.pix.width;
> +	dev->height = f->fmt.pix.height;
> +	dev->field = f->fmt.pix.field;
> +	return 0;
> +}
> +
> +static int tw68_enum_input(struct file *file, void *priv,
> +					struct v4l2_input *i)
> +{
> +	struct tw68_dev *dev = video_drvdata(file);
> +	unsigned int n;
> +
> +	n = i->index;
> +	if (n >= TW68_INPUT_MAX)
> +		return -EINVAL;
> +	i->index = n;
> +	i->type = V4L2_INPUT_TYPE_CAMERA;
> +	snprintf(i->name, sizeof(i->name), "Composite %d", n);
> +
> +	/* If the query is for the current input, get live data */
> +	if (n == dev->input) {
> +		int v1 = tw_readb(TW68_STATUS1);
> +		int v2 = tw_readb(TW68_MVSN);
> +
> +		if (0 != (v1 & (1 << 7)))
> +			i->status |= V4L2_IN_ST_NO_SYNC;
> +		if (0 != (v1 & (1 << 6)))
> +			i->status |= V4L2_IN_ST_NO_H_LOCK;
> +		if (0 != (v1 & (1 << 2)))
> +			i->status |= V4L2_IN_ST_NO_SIGNAL;
> +		if (0 != (v1 & 1 << 1))
> +			i->status |= V4L2_IN_ST_NO_COLOR;
> +		if (0 != (v2 & (1 << 2)))
> +			i->status |= V4L2_IN_ST_MACROVISION;
> +	}
> +	i->std = video_devdata(file)->tvnorms;
> +	return 0;
> +}
> +
> +static int tw68_g_input(struct file *file, void *priv, unsigned int *i)
> +{
> +	struct tw68_dev *dev = video_drvdata(file);
> +
> +	*i = dev->input;
> +	return 0;
> +}
> +
> +static int tw68_s_input(struct file *file, void *priv, unsigned int i)
> +{
> +	struct tw68_dev *dev = video_drvdata(file);
> +
> +	if (i >= TW68_INPUT_MAX)
> +		return -EINVAL;
> +	dev->input = i;
> +	tw_andorb(TW68_INFORM, 0x03 << 2, dev->input << 2);
> +	return 0;
> +}
> +
> +static int tw68_querycap(struct file *file, void  *priv,
> +					struct v4l2_capability *cap)
> +{
> +	struct tw68_dev *dev = video_drvdata(file);
> +
> +	strcpy(cap->driver, "tw68");
> +	strlcpy(cap->card, "Techwell Capture Card",
> +		sizeof(cap->card));
> +	sprintf(cap->bus_info, "PCI:%s", pci_name(dev->pci));
> +	cap->device_caps =
> +		V4L2_CAP_VIDEO_CAPTURE |
> +		V4L2_CAP_READWRITE |
> +		V4L2_CAP_STREAMING;
> +
> +	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
> +	return 0;
> +}
> +
> +static int tw68_s_std(struct file *file, void *priv, v4l2_std_id id)
> +{
> +	struct tw68_dev *dev = video_drvdata(file);
> +	unsigned int i;
> +
> +	if (vb2_is_busy(&dev->vidq))
> +		return -EBUSY;
> +
> +	/* Look for match on complete norm id (may have mult bits) */
> +	for (i = 0; i < TVNORMS; i++) {
> +		if (id == tvnorms[i].id)
> +			break;
> +	}
> +
> +	/* If no exact match, look for norm which contains this one */
> +	if (i == TVNORMS) {
> +		for (i = 0; i < TVNORMS; i++)
> +			if (id & tvnorms[i].id)
> +				break;
> +	}
> +	/* If still not matched, give up */
> +	if (i == TVNORMS)
> +		return -EINVAL;
> +
> +	set_tvnorm(dev, &tvnorms[i]);	/* do the actual setting */
> +	return 0;
> +}
> +
> +static int tw68_g_std(struct file *file, void *priv, v4l2_std_id *id)
> +{
> +	struct tw68_dev *dev = video_drvdata(file);
> +
> +	*id = dev->tvnorm->id;
> +	return 0;
> +}
> +
> +static int tw68_enum_fmt_vid_cap(struct file *file, void  *priv,
> +					struct v4l2_fmtdesc *f)
> +{
> +	if (f->index >= FORMATS)
> +		return -EINVAL;
> +
> +	strlcpy(f->description, formats[f->index].name,
> +		sizeof(f->description));
> +
> +	f->pixelformat = formats[f->index].fourcc;
> +
> +	return 0;
> +}
> +
> +/*
> + * Used strictly for internal development and debugging, this routine
> + * prints out the current register contents for the tw68xx device.
> + */
> +static void tw68_dump_regs(struct tw68_dev *dev)
> +{
> +	unsigned char line[80];
> +	int i, j, k;
> +	unsigned char *cptr;
> +
> +	pr_info("Full dump of TW68 registers:\n");
> +	/* First we do the PCI regs, 8 4-byte regs per line */
> +	for (i = 0; i < 0x100; i += 32) {
> +		cptr = line;
> +		cptr += sprintf(cptr, "%03x  ", i);
> +		/* j steps through the next 4 words */
> +		for (j = i; j < i + 16; j += 4)
> +			cptr += sprintf(cptr, "%08x ", tw_readl(j));
> +		*cptr++ = ' ';
> +		for (; j < i + 32; j += 4)
> +			cptr += sprintf(cptr, "%08x ", tw_readl(j));
> +		*cptr++ = '\n';
> +		*cptr = 0;
> +		pr_info("%s", line);
> +	}
> +	/* Next the control regs, which are single-byte, address mod 4 */
> +	while (i < 0x400) {
> +		cptr = line;
> +		cptr += sprintf(cptr, "%03x ", i);
> +		/* Print out 4 groups of 4 bytes */
> +		for (j = 0; j < 4; j++) {
> +			for (k = 0; k < 4; k++) {
> +				cptr += sprintf(cptr, "%02x ",
> +					tw_readb(i));
> +				i += 4;
> +			}
> +			*cptr++ = ' ';
> +		}
> +		*cptr++ = '\n';
> +		*cptr = 0;
> +		pr_info("%s", line);
> +	}
> +}
> +
> +static int vidioc_log_status(struct file *file, void *priv)
> +{
> +	struct tw68_dev *dev = video_drvdata(file);
> +
> +	tw68_dump_regs(dev);
> +	return v4l2_ctrl_log_status(file, priv);
> +}
> +
> +#ifdef CONFIG_VIDEO_ADV_DEBUG
> +static int vidioc_g_register(struct file *file, void *priv,
> +			      struct v4l2_dbg_register *reg)
> +{
> +	struct tw68_dev *dev = video_drvdata(file);
> +
> +	if (reg->size == 1)
> +		reg->val = tw_readb(reg->reg);
> +	else
> +		reg->val = tw_readl(reg->reg);
> +	return 0;
> +}
> +
> +static int vidioc_s_register(struct file *file, void *priv,
> +				const struct v4l2_dbg_register *reg)
> +{
> +	struct tw68_dev *dev = video_drvdata(file);
> +
> +	if (reg->size == 1)
> +		tw_writeb(reg->reg, reg->val);
> +	else
> +		tw_writel(reg->reg & 0xffff, reg->val);
> +	return 0;
> +}
> +#endif
> +
> +static const struct v4l2_ctrl_ops tw68_ctrl_ops = {
> +	.s_ctrl = tw68_s_ctrl,
> +};
> +
> +static const struct v4l2_file_operations video_fops = {
> +	.owner			= THIS_MODULE,
> +	.open			= v4l2_fh_open,
> +	.release		= vb2_fop_release,
> +	.read			= vb2_fop_read,
> +	.poll			= vb2_fop_poll,
> +	.mmap			= vb2_fop_mmap,
> +	.unlocked_ioctl		= video_ioctl2,
> +};
> +
> +static const struct v4l2_ioctl_ops video_ioctl_ops = {
> +	.vidioc_querycap		= tw68_querycap,
> +	.vidioc_enum_fmt_vid_cap	= tw68_enum_fmt_vid_cap,
> +	.vidioc_reqbufs			= vb2_ioctl_reqbufs,
> +	.vidioc_create_bufs		= vb2_ioctl_create_bufs,
> +	.vidioc_querybuf		= vb2_ioctl_querybuf,
> +	.vidioc_qbuf			= vb2_ioctl_qbuf,
> +	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
> +	.vidioc_s_std			= tw68_s_std,
> +	.vidioc_g_std			= tw68_g_std,
> +	.vidioc_enum_input		= tw68_enum_input,
> +	.vidioc_g_input			= tw68_g_input,
> +	.vidioc_s_input			= tw68_s_input,
> +	.vidioc_streamon		= vb2_ioctl_streamon,
> +	.vidioc_streamoff		= vb2_ioctl_streamoff,
> +	.vidioc_g_fmt_vid_cap		= tw68_g_fmt_vid_cap,
> +	.vidioc_try_fmt_vid_cap		= tw68_try_fmt_vid_cap,
> +	.vidioc_s_fmt_vid_cap		= tw68_s_fmt_vid_cap,
> +	.vidioc_log_status		= vidioc_log_status,
> +	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
> +	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
> +#ifdef CONFIG_VIDEO_ADV_DEBUG
> +	.vidioc_g_register              = vidioc_g_register,
> +	.vidioc_s_register              = vidioc_s_register,
> +#endif
> +};
> +
> +static struct video_device tw68_video_template = {
> +	.name			= "tw68_video",
> +	.fops			= &video_fops,
> +	.ioctl_ops		= &video_ioctl_ops,
> +	.release		= video_device_release_empty,
> +	.tvnorms		= TW68_NORMS,
> +};
> +
> +/* ------------------------------------------------------------------ */
> +/* exported stuff                                                     */
> +void tw68_set_tvnorm_hw(struct tw68_dev *dev)
> +{
> +	tw_andorb(TW68_SDT, 0x07, dev->tvnorm->format);
> +}
> +
> +int tw68_video_init1(struct tw68_dev *dev)
> +{
> +	struct v4l2_ctrl_handler *hdl = &dev->hdl;
> +
> +	v4l2_ctrl_handler_init(hdl, 6);
> +	v4l2_ctrl_new_std(hdl, &tw68_ctrl_ops,
> +			V4L2_CID_BRIGHTNESS, -128, 127, 1, 20);
> +	v4l2_ctrl_new_std(hdl, &tw68_ctrl_ops,
> +			V4L2_CID_CONTRAST, 0, 255, 1, 100);
> +	v4l2_ctrl_new_std(hdl, &tw68_ctrl_ops,
> +			V4L2_CID_SATURATION, 0, 255, 1, 128);
> +	/* NTSC only */
> +	v4l2_ctrl_new_std(hdl, &tw68_ctrl_ops,
> +			V4L2_CID_HUE, -128, 127, 1, 0);
> +	v4l2_ctrl_new_std(hdl, &tw68_ctrl_ops,
> +			V4L2_CID_COLOR_KILLER, 0, 1, 1, 0);
> +	v4l2_ctrl_new_std(hdl, &tw68_ctrl_ops,
> +			V4L2_CID_CHROMA_AGC, 0, 1, 1, 1);
> +	if (hdl->error) {
> +		v4l2_ctrl_handler_free(hdl);
> +		return hdl->error;
> +	}
> +	dev->v4l2_dev.ctrl_handler = hdl;
> +	v4l2_ctrl_handler_setup(hdl);
> +	return 0;
> +}
> +
> +int tw68_video_init2(struct tw68_dev *dev, int video_nr)
> +{
> +	int ret;
> +
> +	set_tvnorm(dev, &tvnorms[0]);
> +
> +	dev->fmt      = format_by_fourcc(V4L2_PIX_FMT_BGR24);
> +	dev->width    = 720;
> +	dev->height   = 576;
> +	dev->field    = V4L2_FIELD_INTERLACED;
> +
> +	INIT_LIST_HEAD(&dev->active);
> +	dev->vidq.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	dev->vidq.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	dev->vidq.io_modes = VB2_MMAP | VB2_USERPTR | VB2_READ | VB2_DMABUF;
> +	dev->vidq.ops = &tw68_video_qops;
> +	dev->vidq.mem_ops = &vb2_dma_sg_memops;
> +	dev->vidq.drv_priv = dev;
> +	dev->vidq.gfp_flags = __GFP_DMA32;
> +	dev->vidq.buf_struct_size = sizeof(struct tw68_buf);
> +	dev->vidq.lock = &dev->lock;
> +	dev->vidq.min_buffers_needed = 2;
> +	ret = vb2_queue_init(&dev->vidq);
> +	if (ret)
> +		return ret;
> +	dev->vdev = tw68_video_template;
> +	dev->vdev.v4l2_dev = &dev->v4l2_dev;
> +	dev->vdev.lock = &dev->lock;
> +	dev->vdev.queue = &dev->vidq;
> +	video_set_drvdata(&dev->vdev, dev);
> +	return video_register_device(&dev->vdev, VFL_TYPE_GRABBER, video_nr);
> +}
> +
> +/*
> + * tw68_irq_video_done
> + */
> +void tw68_irq_video_done(struct tw68_dev *dev, unsigned long status)
> +{
> +	__u32 reg;
> +
> +	/* reset interrupts handled by this routine */
> +	tw_writel(TW68_INTSTAT, status);
> +	/*
> +	 * Check most likely first
> +	 *
> +	 * DMAPI shows we have reached the end of the risc code
> +	 * for the current buffer.
> +	 */
> +	if (status & TW68_DMAPI) {
> +		struct tw68_buf *buf;
> +
> +		spin_lock(&dev->slock);
> +		buf = list_entry(dev->active.next, struct tw68_buf, list);
> +		list_del(&buf->list);
> +		spin_unlock(&dev->slock);
> +		v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
> +		buf->vb.v4l2_buf.field = dev->field;
> +		buf->vb.v4l2_buf.sequence = dev->seqnr++;
> +		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
> +		status &= ~(TW68_DMAPI);
> +		if (0 == status)
> +			return;
> +	}
> +	if (status & (TW68_VLOCK | TW68_HLOCK))
> +		dev_dbg(&dev->pci->dev, "Lost sync\n");
> +	if (status & TW68_PABORT)
> +		dev_err(&dev->pci->dev, "PABORT interrupt\n");
> +	if (status & TW68_DMAPERR)
> +		dev_err(&dev->pci->dev, "DMAPERR interrupt\n");
> +	/*
> +	 * On TW6800, FDMIS is apparently generated if video input is switched
> +	 * during operation.  Therefore, it is not enabled for that chip.
> +	 */
> +	if (status & TW68_FDMIS)
> +		dev_dbg(&dev->pci->dev, "FDMIS interrupt\n");
> +	if (status & TW68_FFOF) {
> +		/* probably a logic error */
> +		reg = tw_readl(TW68_DMAC) & TW68_FIFO_EN;
> +		tw_clearl(TW68_DMAC, TW68_FIFO_EN);
> +		dev_dbg(&dev->pci->dev, "FFOF interrupt\n");
> +		tw_setl(TW68_DMAC, reg);
> +	}
> +	if (status & TW68_FFERR)
> +		dev_dbg(&dev->pci->dev, "FFERR interrupt\n");
> +}
> diff --git a/drivers/media/pci/tw68/tw68.h b/drivers/media/pci/tw68/tw68.h
> new file mode 100644
> index 0000000..2c8abe2
> --- /dev/null
> +++ b/drivers/media/pci/tw68/tw68.h
> @@ -0,0 +1,231 @@
> +/*
> + *  tw68 driver common header file
> + *
> + *  Much of this code is derived from the cx88 and sa7134 drivers, which
> + *  were in turn derived from the bt87x driver.  The original work was by
> + *  Gerd Knorr; more recently the code was enhanced by Mauro Carvalho Chehab,
> + *  Hans Verkuil, Andy Walls and many others.  Their work is gratefully
> + *  acknowledged.  Full credit goes to them - any problems within this code
> + *  are mine.
> + *
> + *  Copyright (C) 2009  William M. Brack
> + *
> + *  Refactored and updated to the latest v4l core frameworks:
> + *
> + *  Copyright (C) 2014 Hans Verkuil <hverkuil@xs4all.nl>
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + */
> +
> +#include <linux/version.h>
> +#include <linux/pci.h>
> +#include <linux/videodev2.h>
> +#include <linux/notifier.h>
> +#include <linux/delay.h>
> +#include <linux/mutex.h>
> +#include <linux/io.h>
> +
> +#include <media/v4l2-common.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +#include <media/videobuf2-dma-sg.h>
> +
> +#include "tw68-reg.h"
> +
> +#define	UNSET	(-1U)
> +
> +/* system vendor and device ID's */
> +#define	PCI_VENDOR_ID_TECHWELL	0x1797
> +#define	PCI_DEVICE_ID_6800	0x6800
> +#define	PCI_DEVICE_ID_6801	0x6801
> +#define	PCI_DEVICE_ID_AUDIO2	0x6802
> +#define	PCI_DEVICE_ID_TS3	0x6803
> +#define	PCI_DEVICE_ID_6804	0x6804
> +#define	PCI_DEVICE_ID_AUDIO5	0x6805
> +#define	PCI_DEVICE_ID_TS6	0x6806
> +
> +/* tw6816 based cards */
> +#define	PCI_DEVICE_ID_6816_1   0x6810
> +#define	PCI_DEVICE_ID_6816_2   0x6811
> +#define	PCI_DEVICE_ID_6816_3   0x6812
> +#define	PCI_DEVICE_ID_6816_4   0x6813
> +
> +#define TW68_NORMS ( \
> +	V4L2_STD_NTSC    | V4L2_STD_PAL       | V4L2_STD_SECAM    | \
> +	V4L2_STD_PAL_M   | V4L2_STD_PAL_Nc    | V4L2_STD_PAL_60)
> +
> +#define	TW68_VID_INTS	(TW68_FFERR | TW68_PABORT | TW68_DMAPERR | \
> +			 TW68_FFOF   | TW68_DMAPI)
> +/* TW6800 chips have trouble with these, so we don't set them for that chip */
> +#define	TW68_VID_INTSX	(TW68_FDMIS | TW68_HLOCK | TW68_VLOCK)
> +
> +#define	TW68_I2C_INTS	(TW68_SBERR | TW68_SBDONE | TW68_SBERR2  | \
> +			 TW68_SBDONE2)
> +
> +enum tw68_decoder_type {
> +	TW6800,
> +	TW6801,
> +	TW6804,
> +	TWXXXX,
> +};
> +
> +/* ----------------------------------------------------------- */
> +/* static data                                                 */
> +
> +struct tw68_tvnorm {
> +	char		*name;
> +	v4l2_std_id	id;
> +
> +	/* video decoder */
> +	u32	sync_control;
> +	u32	luma_control;
> +	u32	chroma_ctrl1;
> +	u32	chroma_gain;
> +	u32	chroma_ctrl2;
> +	u32	vgate_misc;
> +
> +	/* video scaler */
> +	u32	h_delay;
> +	u32	h_delay0;	/* for TW6800 */
> +	u32	h_start;
> +	u32	h_stop;
> +	u32	v_delay;
> +	u32	video_v_start;
> +	u32	video_v_stop;
> +	u32	vbi_v_start_0;
> +	u32	vbi_v_stop_0;
> +	u32	vbi_v_start_1;
> +
> +	/* Techwell specific */
> +	u32	format;
> +};
> +
> +struct tw68_format {
> +	char	*name;
> +	u32	fourcc;
> +	u32	depth;
> +	u32	twformat;
> +};
> +
> +/* ----------------------------------------------------------- */
> +/* card configuration					  */
> +
> +#define TW68_BOARD_NOAUTO		UNSET
> +#define TW68_BOARD_UNKNOWN		0
> +#define	TW68_BOARD_GENERIC_6802		1
> +
> +#define	TW68_MAXBOARDS			16
> +#define	TW68_INPUT_MAX			4
> +
> +/* ----------------------------------------------------------- */
> +/* device / file handle status                                 */
> +
> +#define	BUFFER_TIMEOUT	msecs_to_jiffies(500)	/* 0.5 seconds */
> +
> +struct tw68_dev;	/* forward delclaration */
> +
> +/* buffer for one video/vbi/ts frame */
> +struct tw68_buf {
> +	struct vb2_buffer vb;
> +	struct list_head list;
> +
> +	unsigned int   size;
> +	__le32         *cpu;
> +	__le32         *jmp;
> +	dma_addr_t     dma;
> +};
> +
> +struct tw68_fmt {
> +	char			*name;
> +	u32			fourcc;	/* v4l2 format id */
> +	int			depth;
> +	int			flags;
> +	u32			twformat;
> +};
> +
> +/* global device status */
> +struct tw68_dev {
> +	struct mutex		lock;
> +	spinlock_t		slock;
> +	u16			instance;
> +	struct v4l2_device	v4l2_dev;
> +
> +	/* various device info */
> +	enum tw68_decoder_type	vdecoder;
> +	struct video_device	vdev;
> +	struct v4l2_ctrl_handler hdl;
> +
> +	/* pci i/o */
> +	char			*name;
> +	struct pci_dev		*pci;
> +	unsigned char		pci_rev, pci_lat;
> +	u32			__iomem *lmmio;
> +	u8			__iomem *bmmio;
> +	u32			pci_irqmask;
> +	/* The irq mask to be used will depend upon the chip type */
> +	u32			board_virqmask;
> +
> +	/* video capture */
> +	const struct tw68_format *fmt;
> +	unsigned		width, height;
> +	unsigned		seqnr;
> +	unsigned		field;
> +	struct vb2_queue	vidq;
> +	struct list_head	active;
> +
> +	/* various v4l controls */
> +	const struct tw68_tvnorm *tvnorm;	/* video */
> +
> +	int			input;
> +};
> +
> +/* ----------------------------------------------------------- */
> +
> +#define tw_readl(reg)		readl(dev->lmmio + ((reg) >> 2))
> +#define	tw_readb(reg)		readb(dev->bmmio + (reg))
> +#define tw_writel(reg, value)	writel((value), dev->lmmio + ((reg) >> 2))
> +#define	tw_writeb(reg, value)	writeb((value), dev->bmmio + (reg))
> +
> +#define tw_andorl(reg, mask, value) \
> +		writel((readl(dev->lmmio+((reg)>>2)) & ~(mask)) |\
> +		((value) & (mask)), dev->lmmio+((reg)>>2))
> +#define	tw_andorb(reg, mask, value) \
> +		writeb((readb(dev->bmmio + (reg)) & ~(mask)) |\
> +		((value) & (mask)), dev->bmmio+(reg))
> +#define tw_setl(reg, bit)	tw_andorl((reg), (bit), (bit))
> +#define	tw_setb(reg, bit)	tw_andorb((reg), (bit), (bit))
> +#define	tw_clearl(reg, bit)	\
> +		writel((readl(dev->lmmio + ((reg) >> 2)) & ~(bit)), \
> +		dev->lmmio + ((reg) >> 2))
> +#define	tw_clearb(reg, bit)	\
> +		writeb((readb(dev->bmmio+(reg)) & ~(bit)), \
> +		dev->bmmio + (reg))
> +
> +#define tw_wait(us) { udelay(us); }
> +
> +/* ----------------------------------------------------------- */
> +/* tw68-video.c                                                */
> +
> +void tw68_set_tvnorm_hw(struct tw68_dev *dev);
> +
> +int tw68_video_init1(struct tw68_dev *dev);
> +int tw68_video_init2(struct tw68_dev *dev, int video_nr);
> +void tw68_irq_video_done(struct tw68_dev *dev, unsigned long status);
> +int tw68_video_start_dma(struct tw68_dev *dev, struct tw68_buf *buf);
> +
> +/* ----------------------------------------------------------- */
> +/* tw68-risc.c                                                 */
> +
> +int tw68_risc_buffer(struct pci_dev *pci, struct tw68_buf *buf,
> +	struct scatterlist *sglist, unsigned int top_offset,
> +	unsigned int bottom_offset, unsigned int bpl,
> +	unsigned int padding, unsigned int lines);
