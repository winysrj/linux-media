Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:58874 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754354AbdECUXo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 3 May 2017 16:23:44 -0400
Date: Wed, 3 May 2017 23:23:10 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Tuukka Toivonen <tuukka.toivonen@intel.com>
Cc: Yong Zhi <yong.zhi@intel.com>, linux-media@vger.kernel.org,
        sakari.ailus@linux.intel.com, jian.xu.zheng@intel.com,
        rajmohan.mani@intel.com, hyungwoo.yang@intel.com
Subject: Re: [PATCH 3/3] [media] intel-ipu3: cio2: Add new MIPI-CSI2 driver
Message-ID: <20170503202310.GQ7456@valkosipuli.retiisi.org.uk>
References: <cover.1493479141.git.yong.zhi@intel.com>
 <9cf19d01f6f85ac0e5969a2b2fcd5ad5ef8c1e22.1493479141.git.yong.zhi@intel.com>
 <20170502130020.GL7456@valkosipuli.retiisi.org.uk>
 <1949600.6YvaTrFNdz@ttoivone-desk1>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1949600.6YvaTrFNdz@ttoivone-desk1>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moi,

On Wed, May 03, 2017 at 01:57:31PM +0300, Tuukka Toivonen wrote:
> Hi Sakari,
> 
> Thanks for the comments.
> 
> On Tuesday, May 02, 2017 16:00:20 Sakari Ailus wrote:
> > Hi Yong,
> > 
> > Thanks for the patches! Some comments below.
> > 
> > On Sat, Apr 29, 2017 at 06:34:36PM -0500, Yong Zhi wrote:
> > > This patch adds CIO2 CSI-2 device driver for
> > > Intel's IPU3 camera sub-system support.
> > > 
> > > The V4L2 fwnode matching depends on the following work:
> > > 
> > > <URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=v4l2-acpi>
> > > 
> > > Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> > > ---
> > >  drivers/media/pci/Kconfig          |    2 +
> > >  drivers/media/pci/Makefile         |    3 +-
> > >  drivers/media/pci/ipu3/Kconfig     |   17 +
> > >  drivers/media/pci/ipu3/Makefile    |    1 +
> > >  drivers/media/pci/ipu3/ipu3-cio2.c | 1813 ++++++++++++++++++++++++++++++++++++
> > >  drivers/media/pci/ipu3/ipu3-cio2.h |  425 +++++++++
> > >  6 files changed, 2260 insertions(+), 1 deletion(-)
> > >  create mode 100644 drivers/media/pci/ipu3/Kconfig
> > >  create mode 100644 drivers/media/pci/ipu3/Makefile
> > >  create mode 100644 drivers/media/pci/ipu3/ipu3-cio2.c
> > >  create mode 100644 drivers/media/pci/ipu3/ipu3-cio2.h
> > > 
> > > diff --git a/drivers/media/pci/Kconfig b/drivers/media/pci/Kconfig
> > > index da28e68..63ece75 100644
> > > --- a/drivers/media/pci/Kconfig
> > > +++ b/drivers/media/pci/Kconfig
> > > @@ -54,5 +54,7 @@ source "drivers/media/pci/smipcie/Kconfig"
> > >  source "drivers/media/pci/netup_unidvb/Kconfig"
> > >  endif
> > >  
> > > +source "drivers/media/pci/ipu3/Kconfig"
> > > +
> > >  endif #MEDIA_PCI_SUPPORT
> > >  endif #PCI
> > > diff --git a/drivers/media/pci/Makefile b/drivers/media/pci/Makefile
> > > index a7e8af0..8d5e8db 100644
> > > --- a/drivers/media/pci/Makefile
> > > +++ b/drivers/media/pci/Makefile
> > > @@ -13,7 +13,8 @@ obj-y        +=	ttpci/		\
> > >  		ddbridge/	\
> > >  		saa7146/	\
> > >  		smipcie/	\
> > > -		netup_unidvb/
> > > +		netup_unidvb/	\
> > > +		ipu3/
> > >  
> > >  obj-$(CONFIG_VIDEO_IVTV) += ivtv/
> > >  obj-$(CONFIG_VIDEO_ZORAN) += zoran/
> > > diff --git a/drivers/media/pci/ipu3/Kconfig b/drivers/media/pci/ipu3/Kconfig
> > > new file mode 100644
> > > index 0000000..2a895d6
> > > --- /dev/null
> > > +++ b/drivers/media/pci/ipu3/Kconfig
> > > @@ -0,0 +1,17 @@
> > > +config VIDEO_IPU3_CIO2
> > > +	tristate "Intel ipu3-cio2 driver"
> > > +	depends on VIDEO_V4L2 && PCI
> > > +	depends on MEDIA_CONTROLLER
> > > +	depends on HAS_DMA
> > > +	depends on ACPI
> > > +	select V4L2_FWNODE
> > > +	select VIDEOBUF2_DMA_SG
> > > +
> > > +	---help---
> > > +	This is the Intel IPU3 CIO2 CSI-2 receiver unit, found in Intel
> > > +	Skylake and Kaby Lake SoCs and used for capturing images and
> > > +	video from a camera sensor.
> > > +
> > > +	Say Y or M here if you have a Skylake/Kaby Lake SoC with MIPI CSI-2
> > > +	connected camera.
> > > +	The module will be called ipu3-cio2.
> > > diff --git a/drivers/media/pci/ipu3/Makefile b/drivers/media/pci/ipu3/Makefile
> > > new file mode 100644
> > > index 0000000..20186e3
> > > --- /dev/null
> > > +++ b/drivers/media/pci/ipu3/Makefile
> > > @@ -0,0 +1 @@
> > > +obj-$(CONFIG_VIDEO_IPU3_CIO2) += ipu3-cio2.o
> > > diff --git a/drivers/media/pci/ipu3/ipu3-cio2.c b/drivers/media/pci/ipu3/ipu3-cio2.c
> > > new file mode 100644
> > > index 0000000..2b641ad
> > > --- /dev/null
> > > +++ b/drivers/media/pci/ipu3/ipu3-cio2.c
> > > @@ -0,0 +1,1813 @@
> > > +/*
> > > + * Copyright (c) 2017 Intel Corporation.
> > > + *
> > > + * This program is free software; you can redistribute it and/or
> > > + * modify it under the terms of the GNU General Public License version
> > > + * 2 as published by the Free Software Foundation.
> > > + *
> > > + * This program is distributed in the hope that it will be useful,
> > > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > > + * GNU General Public License for more details.
> > > + *
> > > + * Based partially on Intel IPU4 driver written by
> > > + *  Sakari Ailus <sakari.ailus@linux.intel.com>
> > > + *  Samu Onkalo <samu.onkalo@intel.com>
> > > + *  Jouni Högander <jouni.hogander@intel.com>
> > > + *  Jouni Ukkonen <jouni.ukkonen@intel.com>
> > > + *  Antti Laakso <antti.laakso@intel.com>
> > > + * et al.
> > > + *
> > > + */
> > > +
> > > +#include <asm/cacheflush.h>
> > 
> > I believe you shouldn't need this one.
> > 
> > > +#include <linux/delay.h>
> > > +#include <linux/interrupt.h>
> > > +#include <linux/module.h>
> > > +#include <linux/pci.h>
> > > +#include <linux/pm_runtime.h>
> > > +#include <linux/property.h>
> > > +#include <linux/vmalloc.h>
> > > +#include <media/v4l2-ctrls.h>
> > > +#include <media/v4l2-device.h>
> > > +#include <media/v4l2-event.h>
> > > +#include <media/v4l2-ioctl.h>
> > > +#include <media/videobuf2-dma-sg.h>
> > > +#include <media/v4l2-fwnode.h>
> > 
> > Alphabetical order, please.
> > 
> > > +#include "ipu3-cio2.h"
> > > +
> > > +MODULE_AUTHOR("Tianshu Qiu <tian.shu.qiu@intel.com>");
> > > +MODULE_AUTHOR("Jian Xu Zheng <jian.xu.zheng@intel.com>");
> > > +MODULE_AUTHOR("Yuning Pu <yuning.pu@intel.com>");
> > > +MODULE_AUTHOR("Tuukka Toivonen <tuukka.toivonen@intel.com>");
> > > +MODULE_LICENSE("GPL");
> > > +MODULE_DESCRIPTION("IPU3 CIO2 driver");
> > > +
> > > +/*
> > > + * These are raw formats used in Intel's third generation of
> > > + * Image Processing Unit known as IPU3.
> > > + * 10bit raw bayer packed, 32 bytes for every 25 pixels, last 6 bits unused
> > > + */
> > > +static const u32 cio2_csi2_fmts[] = {
> > > +	V4L2_PIX_FMT_IPU3_SRGGB10,
> > > +	V4L2_PIX_FMT_IPU3_SGBRG10,
> > > +	V4L2_PIX_FMT_IPU3_SGRBG10,
> > > +	V4L2_PIX_FMT_IPU3_SBGGR10,
> > > +};
> > > +
> > > +static inline u32 cio2_bytesperline(const unsigned int width)
> > > +{
> > > +	/* 64 bytes for every 50 pixels */
> > > +	return DIV_ROUND_UP(width, 50) * 64;
> > > +}
> > > +
> > > +/**************** FBPT operations ****************/
> > > +
> > > +static void cio2_fbpt_exit_dummy(struct cio2_device *cio2)
> > > +{
> > > +	if (cio2->dummy_lop) {
> > > +		dma_free_noncoherent(&cio2->pci_dev->dev, PAGE_SIZE,
> > > +				cio2->dummy_lop, cio2->dummy_lop_bus_addr);
> > > +		cio2->dummy_lop = NULL;
> > > +	}
> > > +	if (cio2->dummy_page) {
> > > +		dma_free_noncoherent(&cio2->pci_dev->dev, PAGE_SIZE,
> > > +				cio2->dummy_page, cio2->dummy_page_bus_addr);
> > > +		cio2->dummy_page = NULL;
> > > +	}
> > > +}
> > > +
> > > +static int cio2_fbpt_init_dummy(struct cio2_device *cio2)
> > > +{
> > > +	unsigned int i;
> > > +
> > > +	cio2->dummy_page = dma_alloc_noncoherent(&cio2->pci_dev->dev, PAGE_SIZE,
> > > +					&cio2->dummy_page_bus_addr, GFP_KERNEL);
> > > +	cio2->dummy_lop = dma_alloc_noncoherent(&cio2->pci_dev->dev, PAGE_SIZE,
> > > +					&cio2->dummy_lop_bus_addr, GFP_KERNEL);
> > > +	if (!cio2->dummy_page || !cio2->dummy_lop) {
> > > +		cio2_fbpt_exit_dummy(cio2);
> > > +		return -ENOMEM;
> > > +	}
> > > +	/*
> > > +	 * List of Pointers(LOP) contains 1024x32b pointers to 4KB page each
> > > +	 * Initialize each entry to dummy_page bus base address.
> > > +	 */
> > > +	for (i = 0; i < PAGE_SIZE / sizeof(*cio2->dummy_lop); i++)
> > > +		cio2->dummy_lop[i] = cio2->dummy_page_bus_addr >> PAGE_SHIFT;
> > > +
> > > +	dma_sync_single_for_device(&cio2->pci_dev->dev, /* DMA phy addr */
> > > +			cio2->dummy_lop_bus_addr, PAGE_SIZE, DMA_TO_DEVICE);
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static void cio2_fbpt_entry_enable(struct cio2_device *cio2,
> > > +				   struct cio2_fbpt_entry entry[CIO2_MAX_LOPS])
> > > +{
> > > +	dma_wmb();
> > 
> > Is there a particular reason to have this?
> > 
> > The documentation states that (Documentation/memory-barriers.txt):
> > 
> >      These are for use with consistent memory to guarantee the ordering
> >      of writes or reads of shared memory accessible to both the CPU and a
> >      DMA capable device.
> > 
> > This is while the device does not do cache coherent DMA.
> > 
> 
> Yes. The device must see the entry enabled only after the lop
> table address (and other fields) have been written first.
> Without the dma_wmb() here I don't see how this would be
> guaranteed not to happen:
> 
> - Compiler rearranges memory store instructions so that
>   CPU first writes the ctrl entry, enabling the entry
> - CPU cache gets full and it flushes the memory allowing
>   the device to see the entry enabled
> - Hardware fetches and starts processing the entry, with
>   old incorrect lop table address
> - The new lop table address is written, but now it is too late
> 
> dma_wmb() here guarantees that enabling the VALID bit in
> the ctrl field is seen last by the hardware.
> 
> A comment should be added here to describe this.
> 
> It is true that the documentation describes dma_wmb()
> to be used with consistent memory, but it looks like it
> would do the correct thing in this case too. Something
> more general like wmb() doesn't look really better to me.
> Calling dma_sync_single_for_device twice, on the other hand,
> looks like a bit overkill here.

But that's what you need to do, don't you? If it's possible that the write
will only end up into the cache makes no difference: this device does not
see what's in the cache. Unless you explicitly clean the cache using e.g.
dma_sync_*_for_device(..., DMA_TO_DEVICE), it may take a long time until the
device can actually see that data. And in the meantime it sees something
else...

> 
> > > +
> > > +	/*
> > > +	 * Request interrupts for start and completion
> > > +	 * Valid bit is applicable only to 1st entry
> > > +	 */
> > > +	entry[0].first_entry.ctrl = CIO2_FBPT_CTRL_VALID |
> > > +		CIO2_FBPT_CTRL_IOC | CIO2_FBPT_CTRL_IOS;
> > > +	dma_sync_single_for_device(&cio2->pci_dev->dev, /* DMA phy addr */
> > > +			virt_to_phys(entry), sizeof(*entry) * CIO2_MAX_LOPS,
> > > +			DMA_BIDIRECTIONAL);
> > > +}
> > > +
> > > +/* Initialize fpbt entries to point to dummy frame */
> > > +static void cio2_fbpt_entry_init_dummy(struct cio2_device *cio2,
> > > +				       struct cio2_fbpt_entry
> > > +				       entry[CIO2_MAX_LOPS])
> > > +{
> > > +	unsigned int i;
> > > +
> > > +	entry[0].first_entry.first_page_offset = 0;
> > > +	entry[1].second_entry.num_of_pages =
> > > +		PAGE_SIZE / sizeof(u32) * CIO2_MAX_LOPS;
> > > +	entry[1].second_entry.last_page_available_bytes = PAGE_SIZE - 1;
> > > +
> > > +	for (i = 0; i < CIO2_MAX_LOPS; i++)
> > > +		entry[i].lop_page_addr = cio2->dummy_lop_bus_addr >> PAGE_SHIFT;
> > > +
> > > +	cio2_fbpt_entry_enable(cio2, entry);
> > > +}
> > > +

...

> > > +static void cio2_hw_exit(struct cio2_device *cio2, struct cio2_queue *q)
> > > +{
> > > +	void __iomem *base = cio2->base;
> > > +	unsigned int i, maxloops = 1000;
> > > +
> > > +	/* Disable CSI receiver and MIPI backend devices */
> > > +	writel(0, q->csi_rx_base + CIO2_REG_CSIRX_ENABLE);
> > > +	writel(0, q->csi_rx_base + CIO2_REG_MIPIBE_ENABLE);
> > > +
> > > +	/* Halt DMA */
> > > +	writel(0, base + CIO2_REG_CDMAC0(CIO2_DMA_CHAN));
> > > +	do {
> > > +		if (readl(base + CIO2_REG_CDMAC0(CIO2_DMA_CHAN)) &
> > > +		    CIO2_CDMAC0_DMA_HALTED)
> > > +			break;
> > > +		usleep_range(1000, 2000);
> > > +	} while (--maxloops);
> > > +	if (!maxloops)
> > > +		dev_err(&cio2->pci_dev->dev,
> > > +			"DMA %i can not be halted\n", CIO2_DMA_CHAN);
> > > +
> > > +	for (i = 0; i < CIO2_NUM_PORTS; i++) {
> > > +		writel(readl(base + CIO2_REG_PXM_FRF_CFG(i)) |
> > > +		       CIO2_PXM_FRF_CFG_ABORT, base + CIO2_REG_PXM_FRF_CFG(i));
> > > +		writel(readl(base + CIO2_REG_PBM_FOPN_ABORT) |
> > > +		       CIO2_PBM_FOPN_ABORT(i), base + CIO2_REG_PBM_FOPN_ABORT);
> > > +	}
> > > +}
> > > +
> > > +static void cio2_buffer_done(struct cio2_device *cio2, unsigned int dma_chan)
> > > +{
> > > +	struct device *dev = &cio2->pci_dev->dev;
> > > +	struct cio2_queue *q = cio2->cur_queue;
> > > +	int buffers_found = 0;
> > > +
> > > +	if (dma_chan >= CIO2_QUEUES) {
> > > +		dev_err(dev, "bad DMA channel %i\n", dma_chan);
> > > +		return;
> > > +	}
> > > +
> > > +	/* Find out which buffer(s) are ready */
> > > +	do {
> > > +		struct cio2_fbpt_entry *const entry =
> > > +			&q->fbpt[q->bufs_first * CIO2_MAX_LOPS];
> > > +		struct cio2_buffer *b;
> > > +
> > > +		dma_sync_single_for_cpu(dev, virt_to_phys(entry),
> > > +				sizeof(*entry) * 2, DMA_FROM_DEVICE);
> > > +		if (entry->first_entry.ctrl & CIO2_FBPT_CTRL_VALID)
> > > +			break;
> > > +
> > > +		b = q->bufs[q->bufs_first];
> > > +		if (b) {
> > > +			u64 ns = CIO2_FBPT_TIMESTAMP_TO_NS(
> > > +					entry[1].second_entry.timestamp);
> > 
> > How is this related to system time?
> > 
> > If it's not, how about replacing it with ktime_get_ns()?
> 
> It's not related. Also the timestamp entry could wrap-around,
> which is not taken into account here. The nice thing in the
> hardware timestamp is that it's very accurate and corresponds
> to frame start time, but it would need to be synchronized
> with system time. That would be easy to do.

Until it's done, please use ktime_get_ns().

> 
> > 
> > > +			int bytes = entry[1].second_entry.num_of_bytes;
> > > +
> > > +			q->bufs[q->bufs_first] = NULL;
> > > +			atomic_dec(&q->bufs_queued);
> > > +			dev_dbg(&cio2->pci_dev->dev,
> > > +				"buffer %i done\n", b->vbb.vb2_buf.index);
> > 
> > How about removing the debug print?
> > 
> > > +
> > > +			/* Fill vb2 buffer entries and tell it's ready */
> > > +			vb2_set_plane_payload(&b->vbb.vb2_buf, 0, bytes);
> > 
> > This should be done when the buffer is prepared, i.e. in buf_prepare
> > callback.
> 
> Hmm? At that point the amount of data in the buffer is not
> known. It might be filled only partially due to an error.
> The bytes here is coming from hardware which sets the
> number of bytes received.

This is not the number of bytes written by the hardware to the buffer, but
the data size of the format configured to the device. That's known in
advance for uncompressed formats.

...

> > > +module_pci_driver(cio2_pci_driver);
> > > diff --git a/drivers/media/pci/ipu3/ipu3-cio2.h b/drivers/media/pci/ipu3/ipu3-cio2.h
> > > new file mode 100644
> > > index 0000000..5a8886b
> > > --- /dev/null
> > > +++ b/drivers/media/pci/ipu3/ipu3-cio2.h
> > > @@ -0,0 +1,425 @@
> > > +/*
> > > + * Copyright (c) 2017 Intel Corporation.
> > > + *
> > > + * This program is free software; you can redistribute it and/or
> > > + * modify it under the terms of the GNU General Public License version
> > > + * 2 as published by the Free Software Foundation.
> > > + *
> > > + * This program is distributed in the hope that it will be useful,
> > > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > > + * GNU General Public License for more details.
> > > + */
> > > +
> > > +#ifndef __IPU3_CIO2_H
> > > +#define __IPU3_CIO2_H
> > > +
> > > +#define CIO2_NAME			"ipu3-cio2"
> > > +#define CIO2_DEVICE_NAME		"Intel IPU3 CIO2"
> > > +#define CIO2_ENTITY_NAME		"ipu3-csi2"
> > > +#define CIO2_PCI_ID			0x9d32
> > > +#define CIO2_PCI_BAR			0
> > > +#define CIO2_DMA_MASK			DMA_BIT_MASK(39)
> > > +#define CIO2_QUEUES			2 /* 1 for each sensor */
> > 
> > How many sensors can you support per CIO2 device? The cover page says four.
> > I presume this is currently a driver limitation?
> > 
> > > +
> > > +#define CIO2_MAX_LOPS			8 /* 32MB = 8xFBPT_entry */
> > > +#define CIO2_MAX_BUFFERS		(PAGE_SIZE / 16 / CIO2_MAX_LOPS)
> > > +
> > > +#define CIO2_PAD_SINK			0 /* sinking data */
> > > +#define CIO2_PAD_SOURCE			1 /* sourcing data */
> > 
> > No need for the two comments, these are just pad numbers...
> > 
> > > +#define CIO2_PADS			2
> > > +
> > > +#define CIO2_NUM_DMA_CHAN		20
> > > +#define CIO2_NUM_PORTS			4 /* DPHYs */
> > > +
> > > +/* Register and bit field definitions */
> > > +#define CIO2_REG_PIPE_BASE(n)		((n) * 0x0400)	/* n = 0..3 */
> > > +#define CIO2_REG_CSIRX_BASE		0x000
> > > +#define CIO2_REG_MIPIBE_BASE		0x100
> > > +#define CIO2_REG_PIXELGEN_BAS		0x200
> > > +#define CIO2_REG_IRQCTRL_BASE		0x300
> > > +#define CIO2_REG_GPREG_BASE		0x1000
> > > +
> > > +/* base register: CIO2_REG_PIPE_BASE(pipe) * CIO2_REG_CSIRX_BASE */
> > > +#define CIO2_REG_CSIRX_ENABLE			(CIO2_REG_CSIRX_BASE + 0x0)
> > > +#define CIO2_REG_CSIRX_NOF_ENABLED_LANES	(CIO2_REG_CSIRX_BASE + 0x4)
> > > +#define CIO2_REG_CSIRX_SP_IF_CONFIG		(CIO2_REG_CSIRX_BASE + 0x10)
> > > +#define CIO2_REG_CSIRX_LP_IF_CONFIG		(CIO2_REG_CSIRX_BASE + 0x14)
> > > +#define CIO2_CSIRX_IF_CONFIG_FILTEROUT			0x00
> > > +#define CIO2_CSIRX_IF_CONFIG_FILTEROUT_VC_INACTIVE	0x01
> > > +#define CIO2_CSIRX_IF_CONFIG_PASS			0x02
> > > +#define CIO2_CSIRX_IF_CONFIG_FLAG_ERROR			(1 << 2)
> > > +#define CIO2_REG_CSIRX_STATUS			(CIO2_REG_CSIRX_BASE + 0x18)
> > > +#define CIO2_REG_CSIRX_STATUS_DLANE_HS		(CIO2_REG_CSIRX_BASE + 0x1c)
> > > +#define CIO2_CSIRX_STATUS_DLANE_HS_MASK			0xff
> > > +#define CIO2_REG_CSIRX_STATUS_DLANE_LP		(CIO2_REG_CSIRX_BASE + 0x20)
> > > +#define CIO2_CSIRX_STATUS_DLANE_LP_MASK			0xffffff
> > > +/* Termination enable and settle in 0.0625ns units, lane=0..3 or -1 for clock */
> > > +#define CIO2_REG_CSIRX_DLY_CNT_TERMEN(lane) \
> > > +				(CIO2_REG_CSIRX_BASE + 0x2c + 8*(lane))
> > > +#define CIO2_REG_CSIRX_DLY_CNT_SETTLE(lane) \
> > > +				(CIO2_REG_CSIRX_BASE + 0x30 + 8*(lane))
> > > +/* base register: CIO2_REG_PIPE_BASE(pipe) * CIO2_REG_MIPIBE_BASE */
> > > +#define CIO2_REG_MIPIBE_ENABLE		(CIO2_REG_MIPIBE_BASE + 0x0)
> > > +#define CIO2_REG_MIPIBE_STATUS		(CIO2_REG_MIPIBE_BASE + 0x4)
> > > +#define CIO2_REG_MIPIBE_COMP_FORMAT(vc) \
> > > +				(CIO2_REG_MIPIBE_BASE + 0x8 + 0x4*(vc))
> > > +#define CIO2_REG_MIPIBE_FORCE_RAW8	(CIO2_REG_MIPIBE_BASE + 0x20)
> > > +#define CIO2_REG_MIPIBE_FORCE_RAW8_ENABLE		(1 << 0)
> > > +#define CIO2_REG_MIPIBE_FORCE_RAW8_USE_TYPEID		(1 << 1)
> > > +#define CIO2_REG_MIPIBE_FORCE_RAW8_TYPEID_SHIFT		2
> > > +
> > > +#define CIO2_REG_MIPIBE_IRQ_STATUS	(CIO2_REG_MIPIBE_BASE + 0x24)
> > > +#define CIO2_REG_MIPIBE_IRQ_CLEAR	(CIO2_REG_MIPIBE_BASE + 0x28)
> > > +#define CIO2_REG_MIPIBE_GLOBAL_LUT_DISREGARD (CIO2_REG_MIPIBE_BASE + 0x68)
> > > +#define CIO2_MIPIBE_GLOBAL_LUT_DISREGARD		1
> > > +#define CIO2_REG_MIPIBE_PKT_STALL_STATUS (CIO2_REG_MIPIBE_BASE + 0x6c)
> > > +#define CIO2_REG_MIPIBE_PARSE_GSP_THROUGH_LP_LUT_REG_IDX \
> > > +					(CIO2_REG_MIPIBE_BASE + 0x70)
> > > +#define CIO2_REG_MIPIBE_SP_LUT_ENTRY(vc) \
> > > +				       (CIO2_REG_MIPIBE_BASE + 0x74 + 4*(vc))
> > > +#define CIO2_REG_MIPIBE_LP_LUT_ENTRY(m)	/* m = 0..15 */ \
> > > +					(CIO2_REG_MIPIBE_BASE + 0x84 + 4*(m))
> > > +#define CIO2_MIPIBE_LP_LUT_ENTRY_DISREGARD		1
> > > +#define CIO2_MIPIBE_LP_LUT_ENTRY_SID_SHIFT		1
> > > +#define CIO2_MIPIBE_LP_LUT_ENTRY_VC_SHIFT		5
> > > +#define CIO2_MIPIBE_LP_LUT_ENTRY_FORMAT_TYPE_SHIFT	7
> > > +
> > > +/* base register: CIO2_REG_PIPE_BASE(pipe) * CIO2_REG_IRQCTRL_BASE */
> > > +/* IRQ registers are 18-bit wide, see cio2_irq_error for bit definitions */
> > > +#define CIO2_REG_IRQCTRL_EDGE		(CIO2_REG_IRQCTRL_BASE + 0x00)
> > > +#define CIO2_REG_IRQCTRL_MASK		(CIO2_REG_IRQCTRL_BASE + 0x04)
> > > +#define CIO2_REG_IRQCTRL_STATUS		(CIO2_REG_IRQCTRL_BASE + 0x08)
> > > +#define CIO2_REG_IRQCTRL_CLEAR		(CIO2_REG_IRQCTRL_BASE + 0x0c)
> > > +#define CIO2_REG_IRQCTRL_ENABLE		(CIO2_REG_IRQCTRL_BASE + 0x10)
> > > +#define CIO2_REG_IRQCTRL_LEVEL_NOT_PULSE	(CIO2_REG_IRQCTRL_BASE + 0x14)
> > > +
> > > +#define CIO2_REG_GPREG_SRST		(CIO2_REG_GPREG_BASE + 0x0)
> > > +#define CIO2_GPREG_SRST_ALL				0xffff	/* Reset all */
> > > +#define CIO2_REG_FB_HPLL_FREQ		(CIO2_REG_GPREG_BASE + 0x08)
> > > +#define CIO2_REG_ISCLK_RATIO		(CIO2_REG_GPREG_BASE + 0xc)
> > > +
> > > +#define CIO2_REG_CGC			0x1400
> > > +#define CIO2_CGC_CSI2_TGE				(1 << 0)
> > > +#define CIO2_CGC_PRIM_TGE				(1 << 1)
> > > +#define CIO2_CGC_SIDE_TGE				(1 << 2)
> > > +#define CIO2_CGC_XOSC_TGE				(1 << 3)
> > > +#define CIO2_CGC_MPLL_SHUTDOWN_EN			(1 << 4)
> > > +#define CIO2_CGC_D3I3_TGE				(1 << 5)
> > > +#define CIO2_CGC_CSI2_INTERFRAME_TGE			(1 << 6)
> > > +#define CIO2_CGC_CSI2_PORT_DCGE				(1 << 8)
> > > +#define CIO2_CGC_CSI2_DCGE				(1 << 9)
> > > +#define CIO2_CGC_SIDE_DCGE				(1 << 10)
> > > +#define CIO2_CGC_PRIM_DCGE				(1 << 11)
> > > +#define CIO2_CGC_ROSC_DCGE				(1 << 12)
> > > +#define CIO2_CGC_XOSC_DCGE				(1 << 13)
> > > +#define CIO2_CGC_FLIS_DCGE				(1 << 14)
> > > +#define CIO2_CGC_CLKGATE_HOLDOFF_SHIFT			20
> > > +#define CIO2_CGC_CSI_CLKGATE_HOLDOFF_SHIFT		24
> > > +#define CIO2_REG_D0I3C			0x1408
> > > +#define CIO2_D0I3C_I3				(1 << 2)	/* Set D0I3 */
> > > +#define CIO2_D0I3C_RR				(1 << 3)	/* Restore? */
> > > +#define CIO2_REG_SWRESET		0x140c
> > > +#define CIO2_SWRESET_SWRESET				1
> > > +#define CIO2_REG_SENSOR_ACTIVE		0x1410
> > > +#define CIO2_REG_INT_STS		0x1414
> > > +#define CIO2_REG_INT_STS_EXT_OE		0x1418
> > > +#define CIO2_INT_EXT_OE_DMAOE_SHIFT			0
> > > +#define CIO2_INT_EXT_OE_DMAOE_MASK			0x7ffff
> > > +#define CIO2_INT_EXT_OE_OES_SHIFT			24
> > > +#define CIO2_INT_EXT_OE_OES_MASK	(0xf << CIO2_INT_EXT_OE_OES_SHIFT)
> > > +#define CIO2_REG_INT_EN			0x1420
> > > +#define CIO2_INT_IOC(dma)	(1 << ((dma) < 4 ? (dma) : ((dma) >> 1) + 2))
> > > +#define CIO2_INT_IOC_SHIFT				0
> > > +#define CIO2_INT_IOC_MASK		(0x7ff << CIO2_INT_IOC_SHIFT)
> > > +#define CIO2_INT_IOS_IOLN(dma)			(1 << (((dma) >> 1) + 12))
> > > +#define CIO2_INT_IOS_IOLN_SHIFT				12
> > > +#define CIO2_INT_IOS_IOLN_MASK		(0x3ff << CIO2_INT_IOS_IOLN_SHIFT)
> > > +#define CIO2_INT_IOIE					(1 << 22)
> > > +#define CIO2_INT_IOOE					(1 << 23)
> > > +#define CIO2_INT_IOIRQ					(1 << 24)
> > > +#define CIO2_REG_INT_EN_EXT_OE		0x1424
> > > +#define CIO2_REG_DMA_DBG		0x1448
> > > +#define CIO2_REG_DMA_DBG_DMA_INDEX_SHIFT 0
> > > +#define CIO2_REG_PBM_ARB_CTRL		0x1460
> > > +#define CIO2_PBM_ARB_CTRL_LANES_DIV_SHIFT		0
> > > +#define CIO2_PBM_ARB_CTRL_LE_EN				(1 << 7)
> > > +#define CIO2_PBM_ARB_CTRL_PLL_POST_SHTDN_SHIFT		8
> > > +#define CIO2_PBM_ARB_CTRL_PLL_AHD_WK_UP_SHIFT		16
> > > +#define CIO2_REG_PBM_WMCTRL1		0x1464
> > > +#define CIO2_PBM_WMCTRL1_MIN_2CK_SHIFT			0
> > > +#define CIO2_PBM_WMCTRL1_MID1_2CK_SHIFT			8
> > > +#define CIO2_PBM_WMCTRL1_MID2_2CK_SHIFT			16
> > > +#define CIO2_PBM_WMCTRL1_TS_COUNT_DISABLE		(1 << 31)
> > > +#define CIO2_REG_PBM_WMCTRL2		0x1468
> > > +#define CIO2_PBM_WMCTRL2_HWM_2CK_SHIFT			0
> > > +#define CIO2_PBM_WMCTRL2_LWM_2CK_SHIFT			8
> > > +#define CIO2_PBM_WMCTRL2_OBFFWM_2CK_SHIFT		16
> > > +#define CIO2_PBM_WMCTRL2_TRANSDYN_SHIFT			24
> > > +#define CIO2_PBM_WMCTRL2_DYNWMEN			(1 << 28)
> > > +#define CIO2_PBM_WMCTRL2_OBFF_MEM_EN			(1 << 29)
> > > +#define CIO2_PBM_WMCTRL2_OBFF_CPU_EN			(1 << 30)
> > > +#define CIO2_PBM_WMCTRL2_DRAINNOW			(1 << 31)
> > > +#define CIO2_REG_PBM_TS_COUNT		0x146c
> > > +#define CIO2_REG_PBM_FOPN_ABORT	0x1474	/* below n = 0..3 */
> > > +#define CIO2_PBM_FOPN_ABORT(n)				(0x1 << 8*(n))
> > > +#define CIO2_PBM_FOPN_FORCE_ABORT(n)			(0x2 << 8*(n))
> > > +#define CIO2_PBM_FOPN_FRAMEOPEN(n)			(0x8 << 8*(n))
> > > +#define CIO2_REG_LTRCTRL		0x1480
> > > +#define CIO2_LTRCTRL_LTRDYNEN				(1 << 16)
> > > +#define CIO2_LTRCTRL_LTRSTABLETIME_SHIFT		8
> > > +#define CIO2_LTRCTRL_LTRSTABLETIME_MASK			0xff
> > > +#define CIO2_LTRCTRL_LTRSEL1S3				(1 << 7)
> > > +#define CIO2_LTRCTRL_LTRSEL1S2				(1 << 6)
> > > +#define CIO2_LTRCTRL_LTRSEL1S1				(1 << 5)
> > > +#define CIO2_LTRCTRL_LTRSEL1S0				(1 << 4)
> > > +#define CIO2_LTRCTRL_LTRSEL2S3				(1 << 3)
> > > +#define CIO2_LTRCTRL_LTRSEL2S2				(1 << 2)
> > > +#define CIO2_LTRCTRL_LTRSEL2S1				(1 << 1)
> > > +#define CIO2_LTRCTRL_LTRSEL2S0				(1 << 0)
> > > +#define CIO2_REG_LTRVAL23		0x1484
> > > +#define CIO2_REG_LTRVAL01		0x1488
> > > +#define CIO2_LTRVAL02_VAL_SHIFT				0
> > > +#define CIO2_LTRVAL02_SCALE_SHIFT			10
> > > +#define CIO2_LTRVAL13_VAL_SHIFT				16
> > > +#define CIO2_LTRVAL13_SCALE_SHIFT			26
> > > +
> > > +#define CIO2_REG_CDMABA(n)		(0x1500 + 0x10*(n))	/* n = 0..19 */
> > > +#define CIO2_REG_CDMARI(n)		(0x1504 + 0x10*(n))
> > > +#define CIO2_CDMARI_FBPT_RP_SHIFT			0
> > > +#define CIO2_CDMARI_FBPT_RP_MASK			0xff
> > > +#define CIO2_REG_CDMAC0(n)		(0x1508 + 0x10*(n))
> > > +#define CIO2_CDMAC0_FBPT_LEN_SHIFT			0
> > > +#define CIO2_CDMAC0_FBPT_WIDTH_SHIFT			8
> > > +#define CIO2_CDMAC0_FBPT_NS				(1 << 25)
> > > +#define CIO2_CDMAC0_DMA_INTR_ON_FS			(1 << 26)
> > > +#define CIO2_CDMAC0_DMA_INTR_ON_FE			(1 << 27)
> > > +#define CIO2_CDMAC0_FBPT_UPDATE_FIFO_FULL		(1 << 28)
> > > +#define CIO2_CDMAC0_FBPT_FIFO_FULL_FIX_DIS		(1 << 29)
> > > +#define CIO2_CDMAC0_DMA_EN				(1 << 30)
> > > +#define CIO2_CDMAC0_DMA_HALTED				(1 << 31)
> > > +#define CIO2_REG_CDMAC1(n)		(0x150c + 0x10*(n))
> > > +#define CIO2_CDMAC1_LINENUMINT_SHIFT			0
> > > +#define CIO2_CDMAC1_LINENUMUPDATE_SHIFT			16
> > > +
> > > +#define CIO2_REG_PXM_PXF_FMT_CFG0(n)	(0x1700 + 0x30*(n))	/* n = 0..3 */
> > > +#define CIO2_PXM_PXF_FMT_CFG_SID0_SHIFT			0
> > > +#define CIO2_PXM_PXF_FMT_CFG_SID1_SHIFT			16
> > > +#define CIO2_PXM_PXF_FMT_CFG_PCK_64B			(0 << 0)
> > > +#define CIO2_PXM_PXF_FMT_CFG_PCK_32B			(1 << 0)
> > > +#define CIO2_PXM_PXF_FMT_CFG_BPP_08			(0 << 2)
> > > +#define CIO2_PXM_PXF_FMT_CFG_BPP_10			(1 << 2)
> > > +#define CIO2_PXM_PXF_FMT_CFG_BPP_12			(2 << 2)
> > > +#define CIO2_PXM_PXF_FMT_CFG_BPP_14			(3 << 2)
> > > +#define CIO2_PXM_PXF_FMT_CFG_SPEC_4PPC			(0 << 4)
> > > +#define CIO2_PXM_PXF_FMT_CFG_SPEC_3PPC_RGBA		(1 << 4)
> > > +#define CIO2_PXM_PXF_FMT_CFG_SPEC_3PPC_ARGB		(2 << 4)
> > > +#define CIO2_PXM_PXF_FMT_CFG_SPEC_PLANAR2		(3 << 4)
> > > +#define CIO2_PXM_PXF_FMT_CFG_SPEC_PLANAR3		(4 << 4)
> > > +#define CIO2_PXM_PXF_FMT_CFG_SPEC_NV16			(5 << 4)
> > > +#define CIO2_PXM_PXF_FMT_CFG_PSWAP4_1ST_AB		(1 << 7)
> > > +#define CIO2_PXM_PXF_FMT_CFG_PSWAP4_1ST_CD		(1 << 8)
> > > +#define CIO2_PXM_PXF_FMT_CFG_PSWAP4_2ND_AC		(1 << 9)
> > > +#define CIO2_PXM_PXF_FMT_CFG_PSWAP4_2ND_BD		(1 << 10)
> > > +#define CIO2_REG_INT_STS_EXT_IE		0x17e4	/* See CIO_INT_EXT_IE_* */
> > > +#define CIO2_REG_INT_EN_EXT_IE		0x17e8
> > > +#define CIO2_INT_EXT_IE_ECC_RE(n)			(0x01 << (8 * (n)))
> > > +#define CIO2_INT_EXT_IE_DPHY_NR(n)			(0x02 << (8 * (n)))
> > > +#define CIO2_INT_EXT_IE_ECC_NR(n)			(0x04 << (8 * (n)))
> > > +#define CIO2_INT_EXT_IE_CRCERR(n)			(0x08 << (8 * (n)))
> > > +#define CIO2_INT_EXT_IE_INTERFRAMEDATA(n)		(0x10 << (8 * (n)))
> > > +#define CIO2_INT_EXT_IE_PKT2SHORT(n)			(0x20 << (8 * (n)))
> > > +#define CIO2_INT_EXT_IE_PKT2LONG(n)			(0x40 << (8 * (n)))
> > > +#define CIO2_INT_EXT_IE_IRQ(n)				(0x80 << (8 * (n)))
> > > +#define CIO2_REG_PXM_FRF_CFG(n)		(0x1720 + 0x30*(n))
> > > +#define CIO2_PXM_FRF_CFG_FNSEL				(1 << 0)
> > > +#define CIO2_PXM_FRF_CFG_FN_RST				(1 << 1)
> > > +#define CIO2_PXM_FRF_CFG_ABORT				(1 << 2)
> > > +#define CIO2_PXM_FRF_CFG_CRC_TH_SHIFT			3
> > > +#define CIO2_PXM_FRF_CFG_MSK_ECC_DPHY_NR		(1 << 8)
> > > +#define CIO2_PXM_FRF_CFG_MSK_ECC_RE			(1 << 9)
> > > +#define CIO2_PXM_FRF_CFG_MSK_ECC_DPHY_NE		(1 << 10)
> > > +#define CIO2_PXM_FRF_CFG_EVEN_ODD_MODE_SHIFT		11
> > > +#define CIO2_PXM_FRF_CFG_MASK_CRC_THRES			(1 << 13)
> > > +#define CIO2_PXM_FRF_CFG_MASK_CSI_ACCEPT		(1 << 14)
> > > +#define CIO2_PXM_FRF_CFG_CIOHC_FS_MODE			(1 << 15)
> > > +#define CIO2_PXM_FRF_CFG_CIOHC_FRST_FRM_SHIFT		16
> > > +#define CIO2_REG_PXM_SID2BID0(n)	(0x1724 + 0x30*(n))
> > > +#define CIO2_FB_HPLL_FREQ		0x2
> > > +#define CIO2_ISCLK_RATIO		0xc
> > > +
> > > +#define CIO2_PBM_WMCTRL1_MIN_2CK	(4 << CIO2_PBM_WMCTRL1_MIN_2CK_SHIFT)
> > > +#define CIO2_PBM_WMCTRL1_MID1_2CK	(16 << CIO2_PBM_WMCTRL1_MID1_2CK_SHIFT)
> > > +#define CIO2_PBM_WMCTRL1_MID2_2CK	(21 << CIO2_PBM_WMCTRL1_MID2_2CK_SHIFT)
> > > +
> > > +#define CIO2_PBM_WMCTRL2_HWM_2CK	53
> > > +#define CIO2_PBM_WMCTRL2_LWM_2CK	22
> > > +#define CIO2_PBM_WMCTRL2_OBFFWM_2CK	2
> > > +#define CIO2_PBM_WMCTRL2_TRANSDYN	1
> > > +
> > > +#define CIO2_PBM_ARB_CTRL_LANES_DIV	0	/* 4-4-2-2 lanes */
> > 
> > Shouldn't this be defined next to the register it applies to?
> 
> It's here because it doesn't describe the format of the
> register but the particular value of the register used
> by the driver for now. When support for different lane
> configurations are added, this definition will go away.

Fair enough.

-- 
Terveisin,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
