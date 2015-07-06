Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:33792 "EHLO
	mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbbGFOfY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jul 2015 10:35:24 -0400
Received: by qkeo142 with SMTP id o142so118320969qke.1
        for <linux-media@vger.kernel.org>; Mon, 06 Jul 2015 07:35:23 -0700 (PDT)
Subject: Re: [PATCH] [MEDIA] Add support for TW686[4589]-based frame grabbers.
To: =?UTF-8?Q?Krzysztof_Ha=c5=82asa?= <khalasa@piap.pl>,
	linux-media <linux-media@vger.kernel.org>
References: <m3bnftphea.fsf@t19.piap.pl> <m37fqhpe35.fsf@t19.piap.pl>
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Message-ID: <559A915B.20305@vanguardiasur.com.ar>
Date: Mon, 6 Jul 2015 11:31:55 -0300
MIME-Version: 1.0
In-Reply-To: <m37fqhpe35.fsf@t19.piap.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Krzysztof,

First of all: thanks a lot for the good work!
The driver looks very clean and promising.

I've been playing with it a lot and have quite a bit
of feedback.

First of all, I've noticed you only supported TOP, BOTTOM
and SEQUENTIAL fields. Is there no way to get an interlaced
frame out of the driver?

Is there any way to get alternate top,bottom frames from
the device?

(The DMA modes aren't too documented in the
specs.)

Does this means applications are required to interlace
the frame theirselves?

With some modifications (see below for the detailed
feedback), I've been able to test a tw6869 with
latest media_tree git.

Also, the latest v4l2-compliance from v4l-utils
git passes to:

# v4l2-compliance -s  -f
Total: 148, Succeeded: 148, Failed: 0, Warnings: 0

On 07/03/2015 10:26 AM, Krzysztof Hałasa wrote:
> Audio will be supported with a further patch.
>
> Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>
>

There's something wrong with the patch format. See how
patchwork took it (with no commit log or SOB):

https://patchwork.linuxtv.org/patch/30448/

> diff --git a/drivers/media/pci/Kconfig b/drivers/media/pci/Kconfig
> index 218144a..32902f2 100644
> --- a/drivers/media/pci/Kconfig
> +++ b/drivers/media/pci/Kconfig
> @@ -21,6 +21,7 @@ source "drivers/media/pci/zoran/Kconfig"
>   source "drivers/media/pci/saa7146/Kconfig"
>   source "drivers/media/pci/solo6x10/Kconfig"
>   source "drivers/media/pci/tw68/Kconfig"
> +source "drivers/media/pci/tw686x/Kconfig"
>   endif
>
>   if MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT
> diff --git a/drivers/media/pci/Makefile b/drivers/media/pci/Makefile
> index 0baf0d2..5b15aa6 100644
> --- a/drivers/media/pci/Makefile
> +++ b/drivers/media/pci/Makefile
> @@ -24,6 +24,7 @@ obj-$(CONFIG_VIDEO_BT848) += bt8xx/
>   obj-$(CONFIG_VIDEO_SAA7134) += saa7134/
>   obj-$(CONFIG_VIDEO_SAA7164) += saa7164/
>   obj-$(CONFIG_VIDEO_TW68) += tw68/
> +obj-$(CONFIG_VIDEO_TW686X) += tw686x/
>   obj-$(CONFIG_VIDEO_MEYE) += meye/
>   obj-$(CONFIG_STA2X11_VIP) += sta2x11/
>   obj-$(CONFIG_VIDEO_SOLO6X10) += solo6x10/
> diff --git a/drivers/media/pci/tw686x/Kconfig b/drivers/media/pci/tw686x/Kconfig
> new file mode 100644
> index 0000000..8792a68
> --- /dev/null
> +++ b/drivers/media/pci/tw686x/Kconfig
> @@ -0,0 +1,16 @@
> +config VIDEO_TW686X
> +	tristate "Intersil/Techwell TW686x Video For Linux"
> +	depends on VIDEO_DEV && PCI && VIDEO_V4L2
> +	select VIDEOBUF2_DMA_SG
> +	help
> +	  Support for Intersil/Techwell TW686x-based frame grabber cards.
> +
> +	  Currently supported chips:
> +	  - TW6864 (4 video channels),
> +	  - TW6865 (4 video channels, not tested, second generation chip),
> +	  - TW6868 (8 video channels but only 4 first channels using
> +	    built-in video decoder are supported, not tested),
> +	  - TW6869 (8 video channels, second generation chip).
> +
> +	  To compile this driver as a module, choose M here: the module
> +	  will be named tw686x.
> diff --git a/drivers/media/pci/tw686x/Makefile b/drivers/media/pci/tw686x/Makefile
> new file mode 100644
> index 0000000..083b806
> --- /dev/null
> +++ b/drivers/media/pci/tw686x/Makefile
> @@ -0,0 +1,3 @@
> +tw686x-objs := tw686x-core.o tw686x-video.o
> +
> +obj-$(CONFIG_VIDEO_TW686X) += tw686x.o
> diff --git a/drivers/media/pci/tw686x/tw686x-core.c b/drivers/media/pci/tw686x/tw686x-core.c
> new file mode 100644
> index 0000000..aa873c5
> --- /dev/null
> +++ b/drivers/media/pci/tw686x/tw686x-core.c
> @@ -0,0 +1,176 @@
> +/*
> +  Copyright (C) 2015 Industrial Research Institute for Automation
> +  and Measurements PIAP
> +
> +  Written by Krzysztof Hałasa.
> +
> +  This program is free software; you can redistribute it and/or modify it
> +  under the terms of version 2 of the GNU General Public License
> +  as published by the Free Software Foundation.
> +*/
> +

As per the coding style, multiline comments should be:

/*
  * A long
  * text.
  */

> +#include <linux/init.h>
> +#include <linux/interrupt.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include "tw686x.h"
> +#include "tw686x-regs.h"
> +
> +static irqreturn_t tw686x_irq(int irq, void *dev_id)
> +{
> +	struct tw686x_dev *dev = (struct tw686x_dev *)dev_id;
> +	u32 int_status = reg_read(dev, INT_STATUS); /* cleared on read */
> +	unsigned long flags;
> +	unsigned handled = 0;
> +
> +	if (int_status) {
> +		spin_lock_irqsave(&dev->irq_lock, flags);
> +		dev->dma_requests |= int_status;
> +		spin_unlock_irqrestore(&dev->irq_lock, flags);
> +
> +		if (int_status & 0xFF0000FF)
> +			handled = tw686x_video_irq(dev);
> +	}
> +
> +	return IRQ_RETVAL(handled);
> +}
> +
> +static int tw686x_probe(struct pci_dev *pci_dev,
> +			const struct pci_device_id *pci_id)
> +{
> +	struct tw686x_dev *dev;
> +	int err;
> +
> +	dev = kzalloc(sizeof(*dev) + (pci_id->driver_data & TYPE_MAX_CHANNELS) *
> +		      sizeof(dev->video_channels[0]), GFP_KERNEL);

Using devm_kzalloc will simplify the driver a bit.

> +	if (!dev)
> +		return -ENOMEM;
> +
> +	sprintf(dev->name, "TW%04X", pci_dev->device);
> +	dev->type = pci_id->driver_data;
> +
> +	pr_info("%s: PCI %s, IRQ %d, MMIO 0x%lx\n", dev->name,
> +		pci_name(pci_dev), pci_dev->irq,
> +		(unsigned long)pci_resource_start(pci_dev, 0));
> +
> +	dev->pci_dev = pci_dev;
> +	if (pci_enable_device(pci_dev)) {
> +		err = -EIO;
> +		goto free_dev;
> +	}
> +
> +	pci_set_master(pci_dev);
> +
> +	if (!pci_dma_supported(pci_dev, DMA_BIT_MASK(32))) {
> +		pr_err("%s: 32-bit PCI DMA not supported\n", dev->name);
> +		err = -EIO;
> +		goto disable;
> +	}
> +
> +	if (!request_mem_region(pci_resource_start(pci_dev, 0),
> +				pci_resource_len(pci_dev, 0), dev->name)) {
> +		pr_err("%s: Unable to get MMIO region\n", dev->name);
> +		err = -EBUSY;
> +		goto disable;
> +	}
> +

Use pci_request_region?

> +	dev->mmio = ioremap_nocache(pci_resource_start(pci_dev, 0),
> +				    pci_resource_len(pci_dev, 0));

Use pci_ioremap_bar?

> +	if (!dev->mmio) {
> +		pr_err("%s: Unable to remap MMIO region\n", dev->name);
> +		err = -EIO;
> +		goto free_region;
> +	}
> +
> +	reg_write(dev, SYS_SOFT_RST, 0x0F); /* Reset all subsystems */
> +	mdelay(1);
> +
> +	reg_write(dev, SRST[0], 0x3F);
> +	if (max_channels(dev) > 4)
> +		reg_write(dev, SRST[1], 0x3F);
> +	reg_write(dev, DMA_CMD, 0);
> +	reg_write(dev, DMA_CHANNEL_ENABLE, 0);
> +	reg_write(dev, DMA_CHANNEL_TIMEOUT, 0x3EFF0FF0);
> +	reg_write(dev, DMA_TIMER_INTERVAL, 0x38000);
> +	reg_write(dev, DMA_CONFIG, 0xFFFFFF04);
> +
> +	spin_lock_init(&dev->irq_lock);
> +
> +	err = request_irq(pci_dev->irq, tw686x_irq, IRQF_SHARED, dev->name,
> +			  dev);

Use devm_request_irq?

> +	if (err < 0) {
> +		pr_err("%s: Unable to get IRQ\n", dev->name);
> +		goto iounmap;
> +	}
> +
> +	err = tw686x_video_init(dev);
> +	if (err)
> +		goto free_irq;
> +
> +	pci_set_drvdata(pci_dev, dev);

This is not needed, the v4l2_device_register takes care of it,
by calling dev_set_drvdata.

> +	return 0;
> +
> +free_irq:
> +	free_irq(pci_dev->irq, dev);
> +iounmap:
> +	iounmap(dev->mmio);
> +free_region:
> +	release_mem_region(pci_resource_start(pci_dev, 0),
> +			   pci_resource_len(pci_dev, 0));
> +disable:
> +	pci_disable_device(pci_dev);
> +free_dev:
> +	kfree(dev);
> +	return err;
> +}
> +
> +static void tw686x_remove(struct pci_dev *pci_dev)
> +{
> +	struct tw686x_dev *dev = pci_get_drvdata(pci_dev);
> +
> +	tw686x_video_free(dev);
> +
> +	free_irq(pci_dev->irq, dev);
> +	iounmap(dev->mmio);
> +	release_mem_region(pci_resource_start(pci_dev, 0),
> +			   pci_resource_len(pci_dev, 0));
> +	pci_disable_device(pci_dev);
> +	kfree(dev);
> +}
> +
> +/* driver_data is number of A/V channels */
> +static const struct pci_device_id tw686x_pci_tbl[] = {

I believe this table should be moved to include/linux/pci_ids.h
so the IDs can be shared with the TW68 driver.

(Of course, we would have to submit a patch first moving
the current TECHWELL IDs and fixing the TW68 driver.)

> +	{PCI_DEVICE(0x1797, 0x6864), .driver_data = 4},
> +	/* not tested */
> +	{PCI_DEVICE(0x1797, 0x6865), .driver_data = 4 | TYPE_SECOND_GEN},
> +	/* TW6868 supports 8 A/V channels with an external TW2865 chip -
> +	   not supported by the driver */
> +	{PCI_DEVICE(0x1797, 0x6868), .driver_data = 4}, /* not tested */
> +	{PCI_DEVICE(0x1797, 0x6869), .driver_data = 8 | TYPE_SECOND_GEN},
> +	{}
> +};
> +
> +static struct pci_driver tw686x_pci_driver = {
> +	.name = "TW686x",
> +	.id_table = tw686x_pci_tbl,
> +	.probe = tw686x_probe,
> +	.remove = tw686x_remove,
> +};
> +
> +static int tw686x_init(void)
> +{
> +	return pci_register_driver(&tw686x_pci_driver);
> +}
> +
> +static void tw686x_exit(void)
> +{
> +	pci_unregister_driver(&tw686x_pci_driver);
> +}
> +
> +MODULE_DESCRIPTION("Driver for video frame grabber cards based on Intersil/Techwell TW686[4589]");
> +MODULE_AUTHOR("Krzysztof Halasa");
> +MODULE_LICENSE("GPL v2");
> +MODULE_DEVICE_TABLE(pci, tw686x_pci_tbl);
> +module_init(tw686x_init);
> +module_exit(tw686x_exit);

Use module_pci_driver?

> diff --git a/drivers/media/pci/tw686x/tw686x-regs.h b/drivers/media/pci/tw686x/tw686x-regs.h
> new file mode 100644
> index 0000000..f9ac413
> --- /dev/null
> +++ b/drivers/media/pci/tw686x/tw686x-regs.h
> @@ -0,0 +1,103 @@
> +/* DMA controller registers */
> +#define REG8_1(a0) ((const u16[8]){a0, a0 + 1, a0 + 2, a0 + 3,		\
> +				   a0 + 4, a0 + 5, a0 + 6, a0 + 7})
> +#define REG8_2(a0) ((const u16[8]){a0, a0 + 2, a0 + 4, a0 + 6,		\
> +				   a0 + 8, a0 + 0xA, a0 + 0xC, a0 + 0xE})
> +#define REG8_8(a0) ((const u16[8]){a0, a0 + 8, a0 + 0x10, a0 + 0x18,	\
> +				   a0 + 0x20, a0 + 0x28, a0 + 0x30, a0 + 0x38})
> +#define INT_STATUS		0x00
> +#define PB_STATUS		0x01
> +#define DMA_CMD			0x02
> +#define VIDEO_FIFO_STATUS	0x03
> +#define VIDEO_CHANNEL_ID	0x04
> +#define VIDEO_PARSER_STATUS	0x05
> +#define SYS_SOFT_RST		0x06
> +#define DMA_PAGE_TABLE0_ADDR	((const u16[8]){0x08, 0xD0, 0xD2, 0xD4,	\
> +						0xD6, 0xD8, 0xDA, 0xDC})
> +#define DMA_PAGE_TABLE1_ADDR	((const u16[8]){0x09, 0xD1, 0xD3, 0xD5,	\
> +						0xD7, 0xD9, 0xDB, 0xDD})

Nitpick: don't mix uppercase and lowercase hex values.

> +#define DMA_CHANNEL_ENABLE	0x0a
> +#define DMA_CONFIG		0x0b
> +#define DMA_TIMER_INTERVAL	0x0c
> +#define DMA_CHANNEL_TIMEOUT	0x0d
> +#define VDMA_CHANNEL_CONFIG	REG8_1(0x10)
> +#define ADMA_P_ADDR		REG8_2(0x18)
> +#define ADMA_B_ADDR		REG8_2(0x19)
> +#define DMA10_P_ADDR		0x28 /* ??? */
> +#define DMA10_B_ADDR		0x29
> +#define VIDEO_CONTROL1		0x2A
> +#define VIDEO_CONTROL2		0x2B
> +#define AUDIO_CONTROL1		0x2C
> +#define AUDIO_CONTROL2		0x2D
> +#define PHASE_REF		0x2E
> +#define GPIO_REG		0x2F
> +#define INTL_HBAR_CTRL		REG8_1(0x30)
> +#define AUDIO_CONTROL3		0x38
> +#define VIDEO_FIELD_CTRL	REG8_1(0x39)
> +#define HSCALER_CTRL		REG8_1(0x42)
> +#define VIDEO_SIZE		REG8_1(0x4A)
> +#define VIDEO_SIZE_F2		REG8_1(0x52)
> +#define MD_CONF			REG8_1(0x60)
> +#define MD_INIT			REG8_1(0x68)
> +#define MD_MAP0			REG8_1(0x70)
> +#define VDMA_P_ADDR		REG8_8(0x80) /* not used in DMA SG mode */
> +#define VDMA_WHP		REG8_8(0x81)
> +#define VDMA_B_ADDR		REG8_8(0x82)
> +#define VDMA_F2_P_ADDR		REG8_8(0x84)
> +#define VDMA_F2_WHP		REG8_8(0x85)
> +#define VDMA_F2_B_ADDR		REG8_8(0x86)
> +#define EP_REG_ADDR		0xFE
> +#define EP_REG_DATA		0xFF
> +
> +/* Video decoder registers */
> +#define VDREG8(a0) ((const u16[8]){			\
> +	a0 + 0x000, a0 + 0x010, a0 + 0x020, a0 + 0x030,	\
> +	a0 + 0x100, a0 + 0x110, a0 + 0x120, a0 + 0x130})
> +#define VIDSTAT			VDREG8(0x100)
> +#define BRIGHT			VDREG8(0x101)
> +#define CONTRAST		VDREG8(0x102)
> +#define SHARPNESS		VDREG8(0x103)
> +#define SAT_U			VDREG8(0x104)
> +#define SAT_V			VDREG8(0x105)
> +#define HUE			VDREG8(0x106)
> +#define CROP_HI			VDREG8(0x107)
> +#define VDELAY_LO		VDREG8(0x108)
> +#define VACTIVE_LO		VDREG8(0x109)
> +#define HDELAY_LO		VDREG8(0x10A)
> +#define HACTIVE_LO		VDREG8(0x10B)
> +#define MVSN			VDREG8(0x10C)
> +#define STATUS2			VDREG8(0x10C)
> +#define SDT			VDREG8(0x10E)
> +#define SDT_EN			VDREG8(0x10F)
> +
> +#define VSCALE_LO		VDREG8(0x144)
> +#define SCALE_HI		VDREG8(0x145)
> +#define HSCALE_LO		VDREG8(0x146)
> +#define F2CROP_HI		VDREG8(0x147)
> +#define F2VDELAY_LO		VDREG8(0x148)
> +#define F2VACTIVE_LO		VDREG8(0x149)
> +#define F2HDELAY_LO		VDREG8(0x14A)
> +#define F2HACTIVE_LO		VDREG8(0x14B)
> +#define F2VSCALE_LO		VDREG8(0x14C)
> +#define F2SCALE_HI		VDREG8(0x14D)
> +#define F2HSCALE_LO		VDREG8(0x14E)
> +#define F2CNT			VDREG8(0x14F)
> +
> +#define VDREG2(a0) ((const u16[2]){a0, a0 + 0x100})
> +#define SRST			VDREG2(0x180)
> +#define ACNTL			VDREG2(0x181)
> +#define ACNTL2			VDREG2(0x182)
> +#define CNTRL1			VDREG2(0x183)
> +#define CKHY			VDREG2(0x184)
> +#define SHCOR			VDREG2(0x185)
> +#define CORING			VDREG2(0x186)
> +#define CLMPG			VDREG2(0x187)
> +#define IAGC			VDREG2(0x188)
> +#define VCTRL1			VDREG2(0x18F)
> +#define MISC1			VDREG2(0x194)
> +#define LOOP			VDREG2(0x195)
> +#define MISC2			VDREG2(0x196)
> +
> +#define CLMD			VDREG2(0x197)
> +#define AIGAIN			((const u16[8]){0x1D0, 0x1D1, 0x1D2, 0x1D3, \
> +						0x2D0, 0x2D1, 0x2D2, 0x2D3})
> diff --git a/drivers/media/pci/tw686x/tw686x-video.c b/drivers/media/pci/tw686x/tw686x-video.c
> new file mode 100644
> index 0000000..bf4f12e
> --- /dev/null
> +++ b/drivers/media/pci/tw686x/tw686x-video.c
> @@ -0,0 +1,776 @@
> +/*
> +  Copyright (C) 2015 Industrial Research Institute for Automation
> +  and Measurements PIAP
> +
> +  Written by Krzysztof Hałasa.
> +
> +  This program is free software; you can redistribute it and/or modify it
> +  under the terms of version 2 of the GNU General Public License
> +  as published by the Free Software Foundation.
> +*/
> +
> +#include <linux/init.h>
> +#include <linux/list.h>
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/slab.h>
> +#include <media/v4l2-common.h>
> +#include <media/v4l2-event.h>
> +#include "tw686x.h"
> +#include "tw686x-regs.h"
> +
> +#define MAX_SG_ENTRY_SIZE (/* 8192 - 128 */ 4096)
> +#define MAX_SG_DESC_COUNT 256 /* PAL 704x576 needs up to 198 4-KB pages */
> +

Why 704 and not 720?

> +static const struct tw686x_format formats[] = {
> +	{
> +		.name = "4:2:2 packed, UYVY", /* aka Y422 */
> +		.fourcc = V4L2_PIX_FMT_UYVY,
> +		.mode = 0,
> +		.depth = 16,
> +	}, {
> +#if 0
> +		.name = "4:2:0 packed, YUV",
> +		.mode = 1,	/* non-standard */
> +		.depth = 12,
> +	}, {
> +		.name = "4:1:1 packed, YUV",
> +		.mode = 2,	/* non-standard */
> +		.depth = 12,
> +	}, {
> +#endif
> +		.name = "4:1:1 packed, YUV",
> +		.fourcc = V4L2_PIX_FMT_Y41P,
> +		.mode = 3,
> +		.depth = 12,
> +	}, {
> +		.name = "15 bpp RGB",
> +		.fourcc = V4L2_PIX_FMT_RGB555,
> +		.mode = 4,
> +		.depth = 16,
> +	}, {
> +		.name = "16 bpp RGB",
> +		.fourcc = V4L2_PIX_FMT_RGB565,
> +		.mode = 5,
> +		.depth = 16,
> +	}, {
> +		.name = "4:2:2 packed, YUYV",
> +		.fourcc = V4L2_PIX_FMT_YUYV,
> +		.mode = 6,
> +		.depth = 16,
> +	}
> +	/* mode 7 is "reserved" */
> +};
> +
> +static const v4l2_std_id video_standards[7] = {
> +	V4L2_STD_NTSC,
> +	V4L2_STD_PAL,
> +	V4L2_STD_SECAM,
> +	V4L2_STD_NTSC_443,
> +	V4L2_STD_PAL_M,
> +	V4L2_STD_PAL_N,
> +	V4L2_STD_PAL_60,
> +};
> +
> +static const struct tw686x_format *format_by_fourcc(unsigned fourcc)
> +{
> +	unsigned cnt;
> +
> +	for (cnt = 0; cnt < ARRAY_SIZE(formats); cnt++)
> +		if (formats[cnt].fourcc == fourcc)
> +			return &formats[cnt];
> +	return NULL;
> +}
> +
> +/* video queue operations */
> +
> +static int tw686x_queue_setup(struct vb2_queue *vq,
> +			      const struct v4l2_format *v4l_fmt,
> +			      unsigned int *nbuffers, unsigned int *nplanes,
> +			      unsigned int sizes[], void *alloc_ctxs[])
> +{
> +	struct tw686x_video_channel *vc = vb2_get_drv_priv(vq);
> +
> +	sizes[0] = vc->width * vc->height * vc->format->depth / 8;
> +	alloc_ctxs[0] = vc->alloc_ctx;
> +	*nplanes = 1;		/* packed formats only */
> +	if (*nbuffers < 2)
> +		*nbuffers = 2;
> +

queue_setup is not properly implemented and will make v4l2-compliance
test to fail. See: Documentation/video4linux/v4l2-pci-skeleton.c.

Basically, you are missing a check for v4l_fmt, which can be non-NULL
is queue_setup is called on create_bufs.

> +	return 0;
> +}
> +
> +static void tw686x_buf_queue(struct vb2_buffer *vb)
> +{
> +	struct tw686x_video_channel *vc = vb2_get_drv_priv(vb->vb2_queue);
> +	struct tw686x_vb2_buf *buf;
> +
> +	buf = container_of(vb, struct tw686x_vb2_buf, vb);
> +
> +	spin_lock(&vc->qlock);
> +	list_add_tail(&buf->list, &vc->vidq_queued);
> +	spin_unlock(&vc->qlock);
> +}
> +
> +static void setup_descs(struct tw686x_video_channel *vc, unsigned n)
> +{
> +loop:
> +	while (!list_empty(&vc->vidq_queued)) {
> +		struct vdma_desc *descs = vc->sg_descs[n];
> +		struct tw686x_vb2_buf *buf;
> +		struct sg_table *vbuf;
> +		struct scatterlist *sg;
> +		unsigned buf_len, count = 0;
> +		int i;
> +
> +		buf = list_first_entry(&vc->vidq_queued, struct tw686x_vb2_buf,
> +				       list);
> +		list_del(&buf->list);
> +
> +		buf_len = vc->width * vc->height * vc->format->depth / 8;
> +		if (vb2_plane_size(&buf->vb, 0) < buf_len) {
> +			pr_err("Video buffer size too small\n");
> +			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
> +			goto loop; /* try another */
> +		}
> +
> +		vbuf = vb2_dma_sg_plane_desc(&buf->vb, 0);
> +		for_each_sg(vbuf->sgl, sg, vbuf->nents, i) {
> +			dma_addr_t phys = sg_dma_address(sg);
> +			unsigned len = sg_dma_len(sg);
> +
> +			while (len && buf_len) {
> +				unsigned entry_len = min_t(unsigned, len,
> +							   MAX_SG_ENTRY_SIZE);
> +				entry_len = min(entry_len, buf_len);
> +				if (count == MAX_SG_DESC_COUNT) {
> +					pr_err("Video buffer size too fragmented\n");
> +					vb2_buffer_done(&buf->vb,
> +							VB2_BUF_STATE_ERROR);
> +					goto loop;
> +				}
> +				descs[count].phys = cpu_to_le32(phys);
> +				descs[count++].flags_length =
> +					cpu_to_le32(0x40000000 /* available */ |
> +						    entry_len);
> +				phys += entry_len;
> +				len -= entry_len;
> +				buf_len -= entry_len;
> +			}
> +			if (!buf_len)
> +				break;
> +		}
> +
> +		/* clear the remaining entries */
> +		while (count < MAX_SG_DESC_COUNT) {
> +			descs[count].phys = 0;
> +			descs[count++].flags_length = 0; /* unavailable */
> +		}
> +
> +		buf->vb.state = VB2_BUF_STATE_ACTIVE;
> +		vc->curr_bufs[n] = buf;
> +		return;
> +	}
> +	vc->curr_bufs[n] = NULL;
> +}
> +
> +/* On TW6864 and TW6868, all channels share the pair of video DMA SG tables,
> +   with 10-bit start_idx and end_idx determining start and end of frame buffer
> +   for particular channel.
> +   TW6868 with all its 8 channels would be problematic (only 127 SG entries per
> +   channel) but we support only 4 channels on this chip anyway (the first
> +   4 channels are driven with internal video decoder, the other 4 would require
> +   an external TW286x part).
> +
> +   On TW6865 and TW6869, each channel has its own DMA SG table, with indexes
> +   starting with 0. Both chips have complete sets of internal video decoders
> +   (respectively 4 or 8-channel).
> +
> +   All chips have separate SG tables for two video frames. */
> +

Ditto about multiline comments.

> +static void setup_dma_cfg(struct tw686x_video_channel *vc)
> +{
> +	unsigned field_width = 704;
> +	unsigned field_height = (vc->video_standard & V4L2_STD_625_50) ?
> +		288 : 240;
> +	unsigned start_idx = is_second_gen(vc->dev) ? 0 :
> +		vc->ch * MAX_SG_DESC_COUNT;
> +	unsigned end_idx = start_idx + MAX_SG_DESC_COUNT - 1;
> +	u32 dma_cfg = (0 << 30) /* input selection */ |
> +		(1 << 29) /* field2 dropped (if any) */ |
> +		((vc->height < 300) << 28) /* field dropping */ |
> +		(1 << 27) /* master */ |
> +		(0 << 25) /* master channel (for slave only) */ |
> +		(0 << 24) /* (no) vertical (line) decimation */ |
> +		((vc->width < 400) << 23) /* horizontal decimation */ |
> +		(vc->format->mode << 20) /* output video format */ |
> +		(end_idx << 10) /* DMA end index */ |
> +		start_idx /* DMA start index */;
> +	u32 reg;
> +
> +	reg_write(vc->dev, VDMA_CHANNEL_CONFIG[vc->ch], dma_cfg);
> +	reg_write(vc->dev, VIDEO_SIZE[vc->ch], (1 << 31) | (field_height << 16)
> +		  | field_width);
> +	reg = reg_read(vc->dev, VIDEO_CONTROL1);
> +	reg_write(vc->dev, VIDEO_CONTROL1, reg);
> +}
> +
> +static int tw686x_start_streaming(struct vb2_queue *vq, unsigned int count)
> +{
> +	struct tw686x_video_channel *vc = vb2_get_drv_priv(vq);
> +	struct tw686x_dev *dev = vc->dev;
> +	u32 dma_ch_mask;
> +	unsigned n;
> +
> +	setup_dma_cfg(vc);
> +
> +	/* queue video buffers if available */
> +	spin_lock(&vc->qlock);
> +	for (n = 0; n < 2; n++)
> +		setup_descs(vc, n);
> +	spin_unlock(&vc->qlock);
> +
> +	dev->video_active |= 1 << vc->ch;
> +	dma_ch_mask = reg_read(dev, DMA_CHANNEL_ENABLE) | (1 << vc->ch);
> +	reg_write(dev, DMA_CHANNEL_ENABLE, dma_ch_mask);
> +	reg_write(dev, DMA_CMD, (1 << 31) | dma_ch_mask);
> +	return 0;
> +}
> +
> +static void tw686x_stop_streaming(struct vb2_queue *vq)
> +{
> +	struct tw686x_video_channel *vc = vb2_get_drv_priv(vq);
> +	struct tw686x_dev *dev = vc->dev;
> +	u32 dma_ch_mask = reg_read(dev, DMA_CHANNEL_ENABLE);
> +	u32 dma_cmd = reg_read(dev, DMA_CMD);
> +	unsigned n;
> +
> +	dma_ch_mask &= ~(1 << vc->ch);
> +	reg_write(dev, DMA_CHANNEL_ENABLE, dma_ch_mask);
> +
> +	dev->video_active &= ~(1 << vc->ch);
> +
> +	dma_cmd &= ~(1 << vc->ch);
> +	reg_write(dev, DMA_CMD, dma_cmd);
> +
> +	if (!dev->video_active) {
> +		reg_write(dev, DMA_CMD, 0);
> +		reg_write(dev, DMA_CHANNEL_ENABLE, 0);
> +	}
> +
> +	spin_lock(&vc->qlock);
> +	while (!list_empty(&vc->vidq_queued)) {
> +		struct tw686x_vb2_buf *buf;
> +
> +		buf = list_entry(vc->vidq_queued.next, struct tw686x_vb2_buf,
> +				 list);
> +		list_del(&buf->list);
> +		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
> +	}
> +
> +	for (n = 0; n < 2; n++)
> +		if (vc->curr_bufs[n])
> +			vb2_buffer_done(&vc->curr_bufs[n]->vb,
> +					VB2_BUF_STATE_ERROR);
> +
> +	spin_unlock(&vc->qlock);
> +}
> +
> +static struct vb2_ops tw686x_video_qops = {
> +	.queue_setup		= tw686x_queue_setup,
> +	.buf_queue		= tw686x_buf_queue,
> +	.start_streaming	= tw686x_start_streaming,
> +	.stop_streaming		= tw686x_stop_streaming,
> +	.wait_prepare		= vb2_ops_wait_prepare,
> +	.wait_finish		= vb2_ops_wait_finish,
> +};
> +
> +static int tw686x_s_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct tw686x_video_channel *vc;
> +	struct tw686x_dev *dev;
> +	unsigned ch;
> +
> +	vc = container_of(ctrl->handler, struct tw686x_video_channel,
> +			  ctrl_handler);
> +	dev = vc->dev;
> +	ch = vc->ch;
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_BRIGHTNESS:
> +		reg_write(dev, BRIGHT[ch], ctrl->val & 0xFF);
> +		return 0;
> +
> +	case V4L2_CID_CONTRAST:
> +		reg_write(dev, CONTRAST[ch], ctrl->val);
> +		return 0;
> +
> +	case V4L2_CID_SATURATION:
> +		reg_write(dev, SAT_U[ch], ctrl->val);
> +		reg_write(dev, SAT_V[ch], ctrl->val);
> +		return 0;
> +
> +	case V4L2_CID_HUE:
> +		reg_write(dev, HUE[ch], ctrl->val & 0xFF);
> +		return 0;
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +static const struct v4l2_ctrl_ops ctrl_ops = {
> +	.s_ctrl = tw686x_s_ctrl,
> +};
> +
> +static int tw686x_g_fmt_vid_cap(struct file *file, void *priv,
> +				struct v4l2_format *f)
> +{
> +	struct tw686x_video_channel *vc = video_drvdata(file);
> +
> +	f->fmt.pix.width = vc->width;
> +	f->fmt.pix.height = vc->height;
> +	f->fmt.pix.field = vc->field;
> +	f->fmt.pix.pixelformat = vc->format->fourcc;
> +	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
> +	f->fmt.pix.bytesperline = f->fmt.pix.width * vc->format->depth / 8;

Maybe add some parenthesis here to make it more readable?

> +	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
> +	return 0;
> +}
> +
> +static int tw686x_try_fmt_vid_cap(struct file *file, void *priv,
> +				  struct v4l2_format *f)
> +{
> +	struct tw686x_video_channel *vc = video_drvdata(file);
> +	const struct tw686x_format *format;
> +	unsigned width, height, height_div = 1;
> +
> +	format = format_by_fourcc(f->fmt.pix.pixelformat);
> +	if (!format) {
> +		format = &formats[0];
> +		f->fmt.pix.pixelformat = format->fourcc;
> +	}
> +
> +	width = 704;
> +	if (f->fmt.pix.width < width * 3 / 4 /* halfway */)
> +		width /= 2;
> +
> +	height = (vc->video_standard & V4L2_STD_625_50) ? 576 : 480;
> +	if (f->fmt.pix.height < height * 3 / 4 /* halfway */)
> +		height_div = 2;
> +
> +	switch (f->fmt.pix.field) {
> +	case V4L2_FIELD_TOP:
> +	case V4L2_FIELD_BOTTOM:
> +		height_div = 2;
> +		break;
> +	case V4L2_FIELD_SEQ_BT:
> +		if (height_div > 1)
> +			f->fmt.pix.field = V4L2_FIELD_BOTTOM;
> +		break;
> +	default:
> +		if (height_div > 1)
> +			f->fmt.pix.field = V4L2_FIELD_TOP;
> +		else
> +			f->fmt.pix.field = V4L2_FIELD_SEQ_TB;
> +	}
> +	height /= height_div;
> +
> +	f->fmt.pix.width = width;
> +	f->fmt.pix.height = height;
> +	f->fmt.pix.bytesperline = f->fmt.pix.width * format->depth / 8;
> +	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
> +

You need to return a valid colorspace here too, in case try_fmt didn't
set one.

> +	return 0;
> +}
> +
> +static int tw686x_s_fmt_vid_cap(struct file *file, void *priv,
> +				struct v4l2_format *f)
> +{
> +	struct tw686x_video_channel *vc = video_drvdata(file);
> +	int err;
> +
> +	err = tw686x_try_fmt_vid_cap(file, priv, f);
> +	if (err)
> +		return err;
> +
> +	vc->format = format_by_fourcc(f->fmt.pix.pixelformat);
> +	vc->field = f->fmt.pix.field;
> +	vc->width = f->fmt.pix.width;
> +	vc->height = f->fmt.pix.height;
> +	return 0;
> +}
> +
> +static int tw686x_querycap(struct file *file, void *priv,
> +			   struct v4l2_capability *cap)
> +{
> +	struct tw686x_video_channel *vc = video_drvdata(file);
> +	struct tw686x_dev *dev = vc->dev;
> +
> +	strcpy(cap->driver, "TW686x");
> +	strcpy(cap->card, dev->name);
> +	sprintf(cap->bus_info, "PCI:%s", pci_name(dev->pci_dev));
> +	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
> +	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
> +	return 0;
> +}
> +
> +static int tw686x_s_std(struct file *file, void *priv, v4l2_std_id id)
> +{
> +	struct tw686x_video_channel *vc = priv;

Are you sure priv has been set? AFAICS, you should do this instead:

struct tw686x_video_channel *vc = video_drvdata(file);

> +	unsigned std, count = 0;
> +	u32 sdt, std_mask = 0;
> +
> +	for (std = 0; std > ARRAY_SIZE(video_standards); std++)
> +		if (id & video_standards[std]) {
> +			sdt = std;
> +			std_mask |= 1 << std;
> +			count++;
> +		}
> +
> +	if (count != 1)
> +		return -EINVAL; /* must request exactly one standard */
> +
> +	reg_write(vc->dev, SDT[vc->ch], sdt);
> +	vc->video_standard = video_standards[sdt];

v4l2-compliance test failed on s_std too. I found the code a bit
obscure, so I re-wrote it like this and it just worked:

static int tw686x_s_std(struct file *file, void *priv, v4l2_std_id id)
{
         struct tw686x_video_channel *vc = video_drvdata(file);
         u32 stdsel;

         if (vc->video_standard == id)
                 return 0;

         if (vb2_is_busy(&vc->vidq))
                 return -EBUSY;

         if (id & V4L2_STD_NTSC)
                 stdsel = 0;
         else if (id & V4L2_STD_PAL)
                 stdsel = 1;
         else if (id & V4L2_STD_SECAM)
                 stdsel = 2;
         else if (id & V4L2_STD_NTSC_443)
                 stdsel = 3;
         else if (id & V4L2_STD_PAL_M)
                 stdsel = 4;
         else if (id & V4L2_STD_PAL_Nc)
                 stdsel = 5;
         else if (id & V4L2_STD_PAL_60)
                 stdsel = 6;
         else
                 return -EINVAL;

         reg_write(vc->dev, SDT[vc->ch], stdsel);
         vc->video_standard = id;
	return 0;
}

> +	return 0;
> +}
> +
> +static int tw686x_g_std(struct file *file, void *priv, v4l2_std_id *id)
> +{
> +	struct tw686x_video_channel *vc = priv;
> +

Ditto about priv.

> +	*id = vc->video_standard;
> +	return 0;
> +}
> +
> +static int tw686x_enum_fmt_vid_cap(struct file *file, void *priv,
> +				   struct v4l2_fmtdesc *f)
> +{
> +	if (f->index >= ARRAY_SIZE(formats))
> +		return -EINVAL;
> +
> +	strlcpy(f->description, formats[f->index].name, sizeof(f->description));
> +	f->pixelformat = formats[f->index].fourcc;
> +	return 0;
> +}
> +
> +static int tw686x_g_parm(struct file *file, void *priv,
> +			 struct v4l2_streamparm *sp)
> +{
> +	struct tw686x_video_channel *vc = priv;
> +
> +	if (sp->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +		return -EINVAL;
> +	memset(&sp->parm.capture, 0, sizeof(sp->parm.capture));
> +	sp->parm.capture.capability = V4L2_CAP_TIMEPERFRAME;
> +	v4l2_video_std_frame_period(vc->video_standard,
> +				    &sp->parm.capture.timeperframe);
> +
> +	return 0;
> +}
> +

You haven't implemented the input ioctls, but the device allows
to mux four inputs per channel.

static int tw686x_s_input(struct file *file, void *priv, unsigned int i)
{
         struct tw686x_video_channel *vc = video_drvdata(file);

         if (i >= TW686X_INPUTS_PER_CH)
                 return -EINVAL;

         /*
          * Not sure we are able to support on the fly input change
          */
         if (vb2_is_busy(&vc->vidq))
                 return -EBUSY;

         vc->input = i;
         return 0;
}

static int
tw686x_g_input(struct file *file, void *priv, unsigned int *i)
{
         struct tw686x_video_channel *vc = video_drvdata(file);

         *i = vc->input;
         return 0;
}

static int tw686x_enum_input(struct file *file, void *priv,
                              struct v4l2_input *i)
{
         struct tw686x_video_channel *vc = video_drvdata(file);

         if (i->index >= TW686X_INPUTS_PER_CH)
                 return -EINVAL;

         sprintf(i->name, "Composite%d", i->index);
         i->type = V4L2_INPUT_TYPE_CAMERA;
         i->std = vc->device->tvnorms;
         i->capabilities = V4L2_IN_CAP_STD;

         return 0;
}

> +const struct v4l2_file_operations tw686x_video_fops = {
> +	.owner		= THIS_MODULE,
> +	.open		= v4l2_fh_open,
> +	.unlocked_ioctl	= video_ioctl2,
> +	.release	= vb2_fop_release,
> +	.poll		= vb2_fop_poll,
> +	.read		= vb2_fop_read,
> +	.mmap		= vb2_fop_mmap,
> +};
> +
> +const struct v4l2_ioctl_ops tw686x_video_ioctl_ops = {
> +	.vidioc_querycap		= tw686x_querycap,
> +	.vidioc_enum_fmt_vid_cap	= tw686x_enum_fmt_vid_cap,
> +	.vidioc_g_fmt_vid_cap		= tw686x_g_fmt_vid_cap,
> +	.vidioc_s_fmt_vid_cap		= tw686x_s_fmt_vid_cap,
> +	.vidioc_try_fmt_vid_cap		= tw686x_try_fmt_vid_cap,
> +	.vidioc_reqbufs			= vb2_ioctl_reqbufs,
> +	.vidioc_querybuf		= vb2_ioctl_querybuf,
> +	.vidioc_qbuf			= vb2_ioctl_qbuf,
> +	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
> +	.vidioc_create_bufs		= vb2_ioctl_create_bufs,
> +	.vidioc_streamon		= vb2_ioctl_streamon,
> +	.vidioc_streamoff		= vb2_ioctl_streamoff,
> +	.vidioc_g_std			= tw686x_g_std,
> +	.vidioc_s_std			= tw686x_s_std,

I think we can also support querystd on this hardware, although
we can pospone it for now.

> +	.vidioc_g_parm			= tw686x_g_parm,
> +	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
> +	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
> +};
> +
> +static int video_thread(void *arg)
> +{

Why a thread a not a workqueue (which has a simpler interface)?

> +	struct tw686x_dev *dev = arg;
> +	DECLARE_WAITQUEUE(wait, current);
> +
> +	set_freezable();
> +	add_wait_queue(&dev->video_thread_wait, &wait);
> +
> +	while (1) {
> +		long timeout = schedule_timeout_interruptible(HZ);
> +		unsigned ch;
> +
> +		if (timeout == -ERESTARTSYS || kthread_should_stop())
> +			break;
> +
> +		for (ch = 0; ch < max_channels(dev); ch++) {
> +			struct tw686x_video_channel *vc;
> +			unsigned long flags;
> +			u32 request, n;
> +
> +			vc = &dev->video_channels[ch];
> +			if (!(dev->video_active & (1 << ch)))
> +				continue;
> +
> +			spin_lock_irq(&dev->irq_lock);
> +			request = dev->dma_requests & (0x01000001 << ch);
> +			if (request)
> +				dev->dma_requests &= ~request;
> +			spin_unlock_irq(&dev->irq_lock);
> +
> +			if (!request)
> +				continue;
> +
> +			request >>= ch;
> +
> +			/* handle channel events */
> +			if ((request & 0x01000000) |
> +			    (reg_read(dev, VIDEO_FIFO_STATUS) & 0x01010001) |
> +			    (reg_read(dev, VIDEO_PARSER_STATUS) & 0x00000101)) {
> +				/* DMA Errors - reset channel */
> +				u32 reg;
> +
> +				spin_lock_irqsave(&dev->irq_lock, flags);
> +				reg = reg_read(dev, DMA_CMD);
> +				/* Reset DMA channel */
> +				reg_write(dev, DMA_CMD, reg & ~(1 << ch));
> +				reg_write(dev, DMA_CMD, reg);
> +				spin_unlock_irqrestore(&dev->irq_lock, flags);

I believe you need to return frames on error too. This way you can show
a nice blue or black screen if there's no signal.

And BTW, v4l2-compliance stalls if you don't.

> +			} else {
> +				/* handle video stream */
> +				mutex_lock(&vc->vb_mutex);
> +				spin_lock(&vc->qlock);
> +				n = !!(reg_read(dev, PB_STATUS) & (1 << ch));
> +				if (vc->curr_bufs[n]) {
> +					struct vb2_buffer *vb;
> +
> +					vb = &vc->curr_bufs[n]->vb;
> +					v4l2_get_timestamp(&vb->v4l2_buf.timestamp);
> +					vb->v4l2_buf.field = vc->field;

You need to set the buf sequence here.
See Hans' recent patch for stk1160:

https://patchwork.linuxtv.org/patch/30103/

> +					vb2_set_plane_payload(vb, 0, vc->width * vc->height * vc->format->depth / 8);
> +					vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
> +				}
> +				setup_descs(vc, n);
> +				spin_unlock(&vc->qlock);
> +				mutex_unlock(&vc->vb_mutex);
> +			}
> +		}
> +		try_to_freeze();
> +	}
> +
> +	remove_wait_queue(&dev->video_thread_wait, &wait);
> +	return 0;
> +}
> +
> +int tw686x_video_irq(struct tw686x_dev *dev)
> +{
> +	unsigned long flags, handled = 0;
> +	u32 requests;
> +
> +	spin_lock_irqsave(&dev->irq_lock, flags);
> +	requests = dev->dma_requests;
> +	spin_unlock_irqrestore(&dev->irq_lock, flags);
> +
> +	if (dev->dma_requests & dev->video_active) {

Hm.. so you don't really need dma_requests, but just a boolean
to tell if there was activity?

Maybe you could make tw686x_video_irq receive such a boolean
from the IRQ handler and avoid taking the lock again.

> +		wake_up_interruptible_all(&dev->video_thread_wait);
> +		handled = 1;
> +	}
> +	return handled;
> +}
> +
> +void tw686x_video_free(struct tw686x_dev *dev)
> +{
> +	unsigned ch, n;
> +
> +	if (dev->video_thread)
> +		kthread_stop(dev->video_thread);
> +
> +	for (ch = 0; ch < max_channels(dev); ch++) {
> +		struct tw686x_video_channel *vc = &dev->video_channels[ch];
> +
> +		v4l2_ctrl_handler_free(&vc->ctrl_handler);
> +		if (vc->device)
> +			video_unregister_device(vc->device);
> +		vb2_dma_sg_cleanup_ctx(vc->alloc_ctx);
> +		for (n = 0; n < 2; n++) {
> +			struct dma_desc *descs = &vc->sg_tables[n];
> +
> +			if (descs->virt)
> +				pci_free_consistent(dev->pci_dev, descs->size,
> +						    descs->virt, descs->phys);
> +		}
> +	}
> +
> +	v4l2_device_unregister(&dev->v4l2_dev);
> +}
> +
> +#define SG_TABLE_SIZE (MAX_SG_DESC_COUNT * sizeof(struct vdma_desc))
> +
> +int tw686x_video_init(struct tw686x_dev *dev)
> +{
> +	unsigned ch, n;
> +	int err;
> +
> +	init_waitqueue_head(&dev->video_thread_wait);
> +
> +	err = v4l2_device_register(&dev->pci_dev->dev, &dev->v4l2_dev);
> +	if (err)
> +		return err;
> +
> +	reg_write(dev, PHASE_REF, 0x00001518); /* Scatter-gather DMA mode */
> +
> +	/* setup required SG table sizes */
> +	for (n = 0; n < 2; n++)
> +		if (is_second_gen(dev)) {
> +			/* TW 6865, TW6869 - each channel needs a pair of
> +			   descriptor tables */
> +			for (ch = 0; ch < max_channels(dev); ch++)
> +				dev->video_channels[ch].sg_tables[n].size =
> +					SG_TABLE_SIZE;
> +
> +		} else
> +			/* TW 6864, TW6868 - we need to allocate a pair of
> +			   descriptor tables, common for all channels.
> +			   Each table will be bigger than 4 KB. */
> +			dev->video_channels[0].sg_tables[n].size =
> +				max_channels(dev) * SG_TABLE_SIZE;
> +
> +	/* allocate SG tables and initialize video channels */
> +	for (ch = 0; ch < max_channels(dev); ch++) {
> +		struct tw686x_video_channel *vc = &dev->video_channels[ch];
> +		struct video_device *vdev;
> +
> +		mutex_init(&vc->vb_mutex);
> +		spin_lock_init(&vc->qlock);
> +		INIT_LIST_HEAD(&vc->vidq_queued);
> +
> +		vc->dev = dev;
> +		vc->ch = ch;
> +
> +		/* default settings */
> +		vc->format = &formats[0];
> +		vc->video_standard = V4L2_STD_PAL;
> +		vc->field = V4L2_FIELD_SEQ_TB;
> +		vc->width = 704;
> +		vc->height = 576;

You need to set a default standard to the card,
or otherwise it seems it won't work unless the
s_std ioctl is called before streamon.

I.e., something like this is enough:

reg_write(vc->dev, SDT[ch], DEF_STD);

> +
> +		for (n = 0; n < 2; n++) {
> +			void *cpu;
> +
> +			if (vc->sg_tables[n].size) {
> +				unsigned reg = n ? DMA_PAGE_TABLE1_ADDR[ch] :
> +					DMA_PAGE_TABLE0_ADDR[ch];
> +
> +				cpu = pci_alloc_consistent(dev->pci_dev,
> +							   vc->sg_tables[n].size,
> +							   &vc->sg_tables[n].phys);
> +				if (!cpu) {
> +					pr_err("Error allocating video DMA scatter-gather tables\n");
> +					err = -ENOMEM;
> +					goto error;
> +				}
> +				vc->sg_tables[n].virt = cpu;
> +				reg_write(dev, reg, vc->sg_tables[n].phys);
> +			} else
> +				cpu = dev->video_channels[0].sg_tables[n].virt +
> +					ch * SG_TABLE_SIZE;
> +
> +			vc->sg_descs[n] = cpu;
> +		}
> +
> +		reg_write(dev, VCTRL1[0], 0x24);
> +		reg_write(dev, LOOP[0], 0xA5);
> +		if (max_channels(dev) > 4) {
> +			reg_write(dev, VCTRL1[1], 0x24);
> +			reg_write(dev, LOOP[1], 0xA5);
> +		}
> +		reg_write(dev, VIDEO_FIELD_CTRL[ch], 0);
> +		reg_write(dev, VDELAY_LO[ch], 0x14);
> +
> +		vdev = video_device_alloc();
> +		if (!vdev) {
> +			pr_warn("Unable to allocate video device\n");
> +			err = -ENOMEM;
> +			goto error;
> +		}
> +
> +		vc->alloc_ctx = vb2_dma_sg_init_ctx(&dev->pci_dev->dev);
> +		if (IS_ERR(vc->alloc_ctx)) {
> +			pr_warn("Unable to initialize DMA scatter-gather context\n");
> +			err = PTR_ERR(vc->alloc_ctx);
> +			goto error;
> +		}
> +
> +		vc->vidq.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +		vc->vidq.io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
> +		vc->vidq.drv_priv = vc;
> +		vc->vidq.buf_struct_size = sizeof(struct tw686x_vb2_buf);
> +		vc->vidq.ops = &tw686x_video_qops;
> +		vc->vidq.mem_ops = &vb2_dma_sg_memops;
> +		vc->vidq.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +		vc->vidq.min_buffers_needed = 2;
> +		vc->vidq.lock = &vc->vb_mutex;
> +
> +		err = vb2_queue_init(&vc->vidq);
> +		if (err)
> +			goto error;
> +
> +		strcpy(vdev->name, "TW686x-video");
> +		snprintf(vdev->name, sizeof(vdev->name), "%s video", dev->name);
> +		vdev->fops = &tw686x_video_fops;
> +		vdev->ioctl_ops = &tw686x_video_ioctl_ops;
> +		vdev->release = video_device_release;
> +		vdev->v4l2_dev = &dev->v4l2_dev;
> +		vdev->queue = &vc->vidq;
> +		vdev->tvnorms = V4L2_STD_PAL | V4L2_STD_NTSC | V4L2_STD_SECAM |
> +			V4L2_STD_PAL_60;

The standards list seems to be incomplete. I think you can
use "V4L2_STD_525_60 | V4L2_STD_625_50" and cover all the supported
norms.

> +		vdev->minor = -1;
> +		vdev->lock = &vc->vb_mutex;
> +
> +		dev->video_channels[ch].device = vdev;
> +		video_set_drvdata(vdev, vc);
> +		err = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
> +		if (err < 0)
> +			goto error;
> +
> +		v4l2_ctrl_handler_init(&vc->ctrl_handler,
> +				       4 /* number of controls */);
> +		vdev->ctrl_handler = &vc->ctrl_handler;
> +		v4l2_ctrl_new_std(&vc->ctrl_handler, &ctrl_ops,
> +				  V4L2_CID_BRIGHTNESS, -128, 127, 1, 0);
> +		v4l2_ctrl_new_std(&vc->ctrl_handler, &ctrl_ops,
> +				  V4L2_CID_CONTRAST, 0, 255, 1, 64);
> +		v4l2_ctrl_new_std(&vc->ctrl_handler, &ctrl_ops,
> +				  V4L2_CID_SATURATION, 0, 255, 1, 128);
> +		v4l2_ctrl_new_std(&vc->ctrl_handler, &ctrl_ops, V4L2_CID_HUE,
> +				  -124, 127, 1, 0);
> +		err = vc->ctrl_handler.error;
> +		if (err)
> +			goto error;
> +
> +		v4l2_ctrl_handler_setup(&vc->ctrl_handler);
> +	}
> +
> +	dev->video_thread = kthread_run(video_thread, dev, "tw686x_video");
> +	if (IS_ERR(dev->video_thread)) {
> +		err = PTR_ERR(dev->video_thread);
> +		goto error;
> +	}
> +
> +	return 0;
> +
> +error:
> +	tw686x_video_free(dev);
> +	return err;
> +}
> diff --git a/drivers/media/pci/tw686x/tw686x.h b/drivers/media/pci/tw686x/tw686x.h
> new file mode 100644
> index 0000000..5fe18d5
> --- /dev/null
> +++ b/drivers/media/pci/tw686x/tw686x.h
> @@ -0,0 +1,117 @@
> +/*
> +  Copyright (C) 2015 Industrial Research Institute for Automation
> +  and Measurements PIAP
> +
> +  Written by Krzysztof Hałasa.
> +
> +  This program is free software; you can redistribute it and/or modify it
> +  under the terms of version 2 of the GNU General Public License
> +  as published by the Free Software Foundation.
> +*/
> +
> +#include <linux/delay.h>
> +#include <linux/freezer.h>
> +#include <linux/interrupt.h>
> +#include <linux/kthread.h>
> +#include <linux/mutex.h>
> +#include <linux/pci.h>
> +#include <media/videobuf2-dma-sg.h>
> +#include <linux/videodev2.h>
> +#include <media/v4l2-common.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-ioctl.h>
> +
> +#define TYPE_MAX_CHANNELS 0x0F
> +#define TYPE_SECOND_GEN   0x10
> +
> +struct tw686x_format {
> +	char *name;
> +	unsigned fourcc;
> +	unsigned depth;
> +	unsigned mode;
> +};
> +
> +struct dma_desc {
> +	dma_addr_t phys;
> +	void *virt;
> +	unsigned size;
> +};
> +
> +struct vdma_desc {
> +	__le32 flags_length;	/* 3 MSBits for flags, 13 LSBits for length */
> +	__le32 phys;
> +};
> +
> +struct tw686x_vb2_buf {
> +	struct vb2_buffer vb;
> +	struct list_head list;
> +};
> +
> +struct tw686x_video_channel {
> +	struct tw686x_dev *dev;
> +
> +	struct vb2_queue vidq;
> +	struct list_head vidq_queued;
> +	struct video_device *device;
> +	struct dma_desc sg_tables[2];
> +	struct tw686x_vb2_buf *curr_bufs[2];
> +	void *alloc_ctx;
> +	struct vdma_desc *sg_descs[2];
> +
> +	struct v4l2_ctrl_handler ctrl_handler;
> +	const struct tw686x_format *format;
> +	struct mutex vb_mutex;
> +	spinlock_t qlock;
> +	v4l2_std_id video_standard;
> +	unsigned width, height;
> +	enum v4l2_field field; /* supported TOP, BOTTOM, SEQ_TB and SEQ_BT */
> +	unsigned ch;
> +};
> +
> +/* global device status */
> +struct tw686x_dev {
> +	spinlock_t irq_lock;
> +
> +	struct v4l2_device v4l2_dev;
> +	struct snd_card *card;	/* sound card */
> +
> +	unsigned video_active;	/* active video channel mask */
> +
> +	char name[32];
> +	unsigned type;
> +	struct pci_dev *pci_dev;
> +	__u32 __iomem *mmio;
> +
> +	struct task_struct *video_thread;
> +	wait_queue_head_t video_thread_wait;
> +	u32 dma_requests;
> +
> +	struct tw686x_video_channel video_channels[0];
> +};
> +
> +static inline uint32_t reg_read(struct tw686x_dev *dev, unsigned reg)
> +{
> +	return readl(dev->mmio + reg);
> +}
> +
> +static inline void reg_write(struct tw686x_dev *dev, unsigned reg,
> +			     uint32_t value)
> +{
> +	writel(value, dev->mmio + reg);
> +}
> +
> +static inline unsigned max_channels(struct tw686x_dev *dev)
> +{
> +	return dev->type & TYPE_MAX_CHANNELS; /* 4 or 8 channels */
> +}
> +
> +static inline unsigned is_second_gen(struct tw686x_dev *dev)
> +{
> +	/* each channel has its own DMA SG table */
> +	return dev->type & TYPE_SECOND_GEN;
> +}
> +
> +int tw686x_video_irq(struct tw686x_dev *dev);
> +int tw686x_video_init(struct tw686x_dev *dev);
> +void tw686x_video_free(struct tw686x_dev *dev);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Ezequiel Garcia, VanguardiaSur
www.vanguardiasur.com.ar
