Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:42278 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754877AbdJJHps (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Oct 2017 03:45:48 -0400
Date: Tue, 10 Oct 2017 10:45:44 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Yong Zhi <yong.zhi@intel.com>
Cc: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com, jian.xu.zheng@intel.com,
        tfiga@chromium.org, rajmohan.mani@intel.com,
        tuukka.toivonen@intel.com, hyungwoo.yang@intel.com,
        ramya.vijaykumar@intel.com, chiranjeevi.rapolu@intel.com
Subject: Re: [PATCH v5 3/3] intel-ipu3: cio2: Add new MIPI-CSI2 driver
Message-ID: <20171010074543.xmqavghypbnv25xr@valkosipuli.retiisi.org.uk>
References: <1507333141-28242-1-git-send-email-yong.zhi@intel.com>
 <1507333141-28242-4-git-send-email-yong.zhi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1507333141-28242-4-git-send-email-yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Yong,

Thanks for the update! Please see my comments below.

On Fri, Oct 06, 2017 at 06:39:01PM -0500, Yong Zhi wrote:
> This patch adds CIO2 CSI-2 device driver for
> Intel's IPU3 camera sub-system support.
> 
> Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> Signed-off-by: Hyungwoo Yang <hyungwoo.yang@intel.com>
> Signed-off-by: Rajmohan Mani <rajmohan.mani@intel.com>
> Signed-off-by: Vijaykumar Ramya <ramya.vijaykumar@intel.com>
> ---
>  drivers/media/pci/Kconfig                |    2 +
>  drivers/media/pci/Makefile               |    3 +-
>  drivers/media/pci/intel/Makefile         |    5 +
>  drivers/media/pci/intel/ipu3/Kconfig     |   19 +
>  drivers/media/pci/intel/ipu3/Makefile    |    1 +
>  drivers/media/pci/intel/ipu3/ipu3-cio2.c | 2052 ++++++++++++++++++++++++++++++
>  drivers/media/pci/intel/ipu3/ipu3-cio2.h |  452 +++++++
>  7 files changed, 2533 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/media/pci/intel/Makefile
>  create mode 100644 drivers/media/pci/intel/ipu3/Kconfig
>  create mode 100644 drivers/media/pci/intel/ipu3/Makefile
>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-cio2.c
>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-cio2.h
> 
> diff --git a/drivers/media/pci/Kconfig b/drivers/media/pci/Kconfig
> index da28e68c87d8..5932e225f9c0 100644
> --- a/drivers/media/pci/Kconfig
> +++ b/drivers/media/pci/Kconfig
> @@ -54,5 +54,7 @@ source "drivers/media/pci/smipcie/Kconfig"
>  source "drivers/media/pci/netup_unidvb/Kconfig"
>  endif
>  
> +source "drivers/media/pci/intel/ipu3/Kconfig"
> +
>  endif #MEDIA_PCI_SUPPORT
>  endif #PCI
> diff --git a/drivers/media/pci/Makefile b/drivers/media/pci/Makefile
> index a7e8af0f64a7..d8f98434fb8c 100644
> --- a/drivers/media/pci/Makefile
> +++ b/drivers/media/pci/Makefile
> @@ -13,7 +13,8 @@ obj-y        +=	ttpci/		\
>  		ddbridge/	\
>  		saa7146/	\
>  		smipcie/	\
> -		netup_unidvb/
> +		netup_unidvb/	\
> +		intel/
>  
>  obj-$(CONFIG_VIDEO_IVTV) += ivtv/
>  obj-$(CONFIG_VIDEO_ZORAN) += zoran/
> diff --git a/drivers/media/pci/intel/Makefile b/drivers/media/pci/intel/Makefile
> new file mode 100644
> index 000000000000..745c8b2a7819
> --- /dev/null
> +++ b/drivers/media/pci/intel/Makefile
> @@ -0,0 +1,5 @@
> +#
> +# Makefile for the IPU3 cio2 and ImGU drivers
> +#
> +
> +obj-y	+= ipu3/
> diff --git a/drivers/media/pci/intel/ipu3/Kconfig b/drivers/media/pci/intel/ipu3/Kconfig
> new file mode 100644
> index 000000000000..0861077a4dae
> --- /dev/null
> +++ b/drivers/media/pci/intel/ipu3/Kconfig
> @@ -0,0 +1,19 @@
> +config VIDEO_IPU3_CIO2
> +	tristate "Intel ipu3-cio2 driver"
> +	depends on VIDEO_V4L2 && PCI
> +	depends on VIDEO_V4L2_SUBDEV_API
> +	depends on MEDIA_CONTROLLER
> +	depends on HAS_DMA
> +	depends on ACPI
> +	depends on X86_64 || COMPILE_TEST

Why X86_64?

> +	select V4L2_FWNODE
> +	select VIDEOBUF2_DMA_SG
> +
> +	---help---
> +	This is the Intel IPU3 CIO2 CSI-2 receiver unit, found in Intel
> +	Skylake and Kaby Lake SoCs and used for capturing images and
> +	video from a camera sensor.
> +
> +	Say Y or M here if you have a Skylake/Kaby Lake SoC with MIPI CSI-2
> +	connected camera.
> +	The module will be called ipu3-cio2.
> diff --git a/drivers/media/pci/intel/ipu3/Makefile b/drivers/media/pci/intel/ipu3/Makefile
> new file mode 100644
> index 000000000000..20186e3ff2ae
> --- /dev/null
> +++ b/drivers/media/pci/intel/ipu3/Makefile
> @@ -0,0 +1 @@
> +obj-$(CONFIG_VIDEO_IPU3_CIO2) += ipu3-cio2.o
> diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
> new file mode 100644
> index 000000000000..2c2faa8f1d25
> --- /dev/null
> +++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
> @@ -0,0 +1,2052 @@
> +/*
> + * Copyright (c) 2017 Intel Corporation.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License version
> + * 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * Based partially on Intel IPU4 driver written by
> + *  Sakari Ailus <sakari.ailus@linux.intel.com>
> + *  Samu Onkalo <samu.onkalo@intel.com>
> + *  Jouni Högander <jouni.hogander@intel.com>
> + *  Jouni Ukkonen <jouni.ukkonen@intel.com>
> + *  Antti Laakso <antti.laakso@intel.com>
> + * et al.
> + *
> + */
> +
> +#include <linux/delay.h>
> +#include <linux/interrupt.h>
> +#include <linux/module.h>
> +#include <linux/pci.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/property.h>
> +#include <linux/vmalloc.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-event.h>
> +#include <media/v4l2-fwnode.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/videobuf2-dma-sg.h>
> +
> +#include "ipu3-cio2.h"
> +
> +struct ipu3_cio2_fmt {
> +	u32 mbus_code;
> +	u32 fourcc;
> +	u8 mipicode;
> +};
> +
> +/*
> + * These are raw formats used in Intel's third generation of
> + * Image Processing Unit known as IPU3.
> + * 10bit raw bayer packed, 32 bytes for every 25 pixels,
> + * last LSB 6 bits unused.
> + */
> +static const struct ipu3_cio2_fmt formats[] = {
> +	{	/* put default entry at beginning */
> +		.mbus_code	= MEDIA_BUS_FMT_SGRBG10_1X10,
> +		.fourcc		= V4L2_PIX_FMT_IPU3_SGRBG10,
> +		.mipicode	= 0x2b,
> +	}, {
> +		.mbus_code	= MEDIA_BUS_FMT_SGBRG10_1X10,
> +		.fourcc		= V4L2_PIX_FMT_IPU3_SGBRG10,
> +		.mipicode	= 0x2b,
> +	}, {
> +		.mbus_code	= MEDIA_BUS_FMT_SBGGR10_1X10,
> +		.fourcc		= V4L2_PIX_FMT_IPU3_SBGGR10,
> +		.mipicode	= 0x2b,
> +	}, {
> +		.mbus_code	= MEDIA_BUS_FMT_SRGGB10_1X10,
> +		.fourcc		= V4L2_PIX_FMT_IPU3_SRGGB10,
> +		.mipicode	= 0x2b,
> +	},
> +};
> +
> +#define NUM_FORMATS ARRAY_SIZE(formats)

Please use ARRAY_SIZE(formats) instead of NUM_FORMATS.

> +
> +/*
> + * cio2_find_format - lookup color format by fourcc or/and media bus code
> + * @pixelformat: fourcc to match, ignored if null
> + * @mbus_code: media bus code to match, ignored if null
> + */
> +static const struct ipu3_cio2_fmt *cio2_find_format(const u32 *pixelformat,
> +			const u32 *mbus_code)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < NUM_FORMATS; i++) {
> +		if (pixelformat && *pixelformat != formats[i].fourcc)
> +			continue;
> +		if (mbus_code && *mbus_code != formats[i].mbus_code)
> +			continue;
> +
> +		return &formats[i];
> +	}
> +
> +	return NULL;
> +}
> +
> +static inline u32 cio2_bytesperline(const unsigned int width)
> +{
> +	/*
> +	 * 64 bytes for every 50 pixels, the line length
> +	 * in bytes is multiple of 64 (line end alignment).
> +	 */
> +	return DIV_ROUND_UP(width, 50) * 64;
> +}
> +
> +/**************** FBPT operations ****************/
> +
> +static void cio2_fbpt_exit_dummy(struct cio2_device *cio2)
> +{
> +	if (cio2->dummy_lop) {
> +		dma_free_coherent(&cio2->pci_dev->dev, CIO2_PAGE_SIZE,
> +				cio2->dummy_lop, cio2->dummy_lop_bus_addr);
> +		cio2->dummy_lop = NULL;
> +	}
> +	if (cio2->dummy_page) {
> +		dma_free_coherent(&cio2->pci_dev->dev, CIO2_PAGE_SIZE,
> +				cio2->dummy_page, cio2->dummy_page_bus_addr);
> +		cio2->dummy_page = NULL;
> +	}
> +}
> +
> +static int cio2_fbpt_init_dummy(struct cio2_device *cio2)
> +{
> +	unsigned int i;
> +
> +	cio2->dummy_page = dma_alloc_coherent(&cio2->pci_dev->dev,
> +				CIO2_PAGE_SIZE, &cio2->dummy_page_bus_addr,
> +				GFP_KERNEL);
> +	cio2->dummy_lop = dma_alloc_coherent(&cio2->pci_dev->dev,
> +				CIO2_PAGE_SIZE, &cio2->dummy_lop_bus_addr,
> +				GFP_KERNEL);
> +	if (!cio2->dummy_page || !cio2->dummy_lop) {
> +		cio2_fbpt_exit_dummy(cio2);
> +		return -ENOMEM;
> +	}
> +	/*
> +	 * List of Pointers(LOP) contains 1024x32b pointers to 4KB page each
> +	 * Initialize each entry to dummy_page bus base address.
> +	 */
> +	for (i = 0; i < CIO2_PAGE_SIZE / sizeof(*cio2->dummy_lop); i++)
> +		cio2->dummy_lop[i] = cio2->dummy_page_bus_addr >> PAGE_SHIFT;
> +
> +	return 0;
> +}
> +
> +static void cio2_fbpt_entry_enable(struct cio2_device *cio2,
> +				   struct cio2_fbpt_entry entry[CIO2_MAX_LOPS])
> +{
> +	/*
> +	 * The CPU first initializes some fields in fbpt, then sets
> +	 * the VALID bit, this barrier is to ensure that the DMA(device)
> +	 * does not see the VALID bit enabled before other fields are
> +	 * initialized; otherwise it could lead to havoc.
> +	 */
> +	dma_wmb();
> +
> +	/*
> +	 * Request interrupts for start and completion
> +	 * Valid bit is applicable only to 1st entry
> +	 */
> +	entry[0].first_entry.ctrl = CIO2_FBPT_CTRL_VALID |
> +		CIO2_FBPT_CTRL_IOC | CIO2_FBPT_CTRL_IOS;
> +}
> +
> +/* Initialize fpbt entries to point to dummy frame */
> +static void cio2_fbpt_entry_init_dummy(struct cio2_device *cio2,
> +				       struct cio2_fbpt_entry
> +				       entry[CIO2_MAX_LOPS])
> +{
> +	unsigned int i;
> +
> +	entry[0].first_entry.first_page_offset = 0;
> +	entry[1].second_entry.num_of_pages =
> +		CIO2_PAGE_SIZE / sizeof(u32) * CIO2_MAX_LOPS;
> +	entry[1].second_entry.last_page_available_bytes = CIO2_PAGE_SIZE - 1;
> +
> +	for (i = 0; i < CIO2_MAX_LOPS; i++)
> +		entry[i].lop_page_addr = cio2->dummy_lop_bus_addr >> PAGE_SHIFT;
> +
> +	cio2_fbpt_entry_enable(cio2, entry);
> +}
> +
> +/* Initialize fpbt entries to point to a given buffer */
> +static void cio2_fbpt_entry_init_buf(struct cio2_device *cio2,
> +				     struct cio2_buffer *b,
> +				     struct cio2_fbpt_entry
> +				     entry[CIO2_MAX_LOPS])
> +{
> +	struct vb2_buffer *vb = &b->vbb.vb2_buf;
> +	unsigned int length = vb->planes[0].length;
> +	int remaining, i;
> +
> +	entry[0].first_entry.first_page_offset = b->offset;
> +	remaining = length + entry[0].first_entry.first_page_offset;
> +	entry[1].second_entry.num_of_pages =
> +		DIV_ROUND_UP(remaining, CIO2_PAGE_SIZE);
> +	/*
> +	 * last_page_available_bytes has the offset of the last byte in the
> +	 * last page which is still accessible by DMA. DMA cannot access
> +	 * beyond this point. Valid range for this is from 0 to 4095.
> +	 * 0 indicates 1st byte in the page is DMA accessible.
> +	 * 4095 (CIO2_PAGE_SIZE - 1) means every single byte in the last page
> +	 * is available for DMA transfer.
> +	 */
> +	entry[1].second_entry.last_page_available_bytes =
> +			(remaining & ~PAGE_MASK) ?
> +				(remaining & ~PAGE_MASK) - 1 :
> +				CIO2_PAGE_SIZE - 1;
> +	/* Fill FBPT */
> +	remaining = length;
> +	i = 0;
> +	while (remaining > 0) {
> +		entry->lop_page_addr = b->lop_bus_addr[i] >> PAGE_SHIFT;
> +		remaining -= CIO2_PAGE_SIZE / sizeof(u32) * CIO2_PAGE_SIZE;
> +		entry++;
> +		i++;
> +	}
> +
> +	/*
> +	 * The first not meaningful FBPT entry should point to a valid LOP
> +	 */
> +	entry->lop_page_addr = cio2->dummy_lop_bus_addr >> PAGE_SHIFT;
> +
> +	cio2_fbpt_entry_enable(cio2, entry);
> +}
> +
> +static int cio2_fbpt_init(struct cio2_device *cio2, struct cio2_queue *q)
> +{
> +	struct device *dev = &cio2->pci_dev->dev;
> +
> +	q->fbpt = dma_alloc_coherent(dev, CIO2_FBPT_SIZE, &q->fbpt_bus_addr,
> +					GFP_KERNEL);
> +	if (!q->fbpt)
> +		return -ENOMEM;
> +
> +	memset(q->fbpt, 0, CIO2_FBPT_SIZE);
> +
> +	return 0;
> +}
> +
> +static int cio2_fbpt_rearrange(struct cio2_device *cio2, struct cio2_queue *q)
> +{
> +	struct cio2_fbpt_entry *fbpt_temp;
> +	int i, j;
> +	int size, entries;
> +	struct cio2_buffer *bufs[CIO2_MAX_BUFFERS];
> +
> +	for (i = 0, j = q->bufs_first; i < CIO2_MAX_BUFFERS;
> +		i++, j = (j + 1) % CIO2_MAX_BUFFERS)
> +		if (q->bufs[j])
> +			break;
> +
> +	if (i == CIO2_MAX_BUFFERS)
> +		return 0;
> +
> +	fbpt_temp = vmalloc(CIO2_FBPT_SIZE);

This is called when the device is resuming. It'd be much better to allocate
when going to sleep because you can somewhat graciously fail there. Not
here. Even better it would be not to need the temporary storage at all,
which could be done e.g. by individually swapping the entries in a loop.

> +	if (!fbpt_temp)
> +		return -ENOMEM;
> +
> +	entries = (CIO2_MAX_BUFFERS - j) * CIO2_MAX_LOPS;
> +	size = entries * sizeof(struct cio2_fbpt_entry);
> +
> +	memcpy(fbpt_temp, q->fbpt + j * CIO2_MAX_LOPS, size);
> +	memcpy(fbpt_temp + entries, q->fbpt, CIO2_FBPT_SIZE - size);
> +	memcpy(q->fbpt, fbpt_temp, CIO2_FBPT_SIZE);
> +	memcpy(bufs, q->bufs + j, (CIO2_MAX_BUFFERS - j) * sizeof(*bufs));
> +	memcpy(bufs + CIO2_MAX_BUFFERS - j, q->bufs, j * sizeof(*bufs));
> +	memcpy(q->bufs, bufs, CIO2_MAX_BUFFERS * sizeof(*bufs));
> +
> +	/*
> +	 * DMA clears the valid bit when accessing the buffer.
> +	 * When stopping stream in suspend callback, some of the buffers
> +	 * may be in invalid state. After resume, when DMA meets the inavlid
> +	 * buffer, it will halt and stop receiving new data.
> +	 * To avoid DMA halting, set the valid bit for all buffers in FBPT.
> +	 */
> +	for (i = 0; i < CIO2_MAX_BUFFERS; i++)
> +		cio2_fbpt_entry_enable(cio2, q->fbpt + i * CIO2_MAX_LOPS);
> +
> +	vfree(fbpt_temp);
> +
> +	return 0;
> +}
> +
> +static void cio2_fbpt_exit(struct cio2_queue *q, struct device *dev)
> +{
> +	dma_free_coherent(dev, CIO2_FBPT_SIZE, q->fbpt, q->fbpt_bus_addr);
> +}
> +
> +/**************** CSI2 hardware setup ****************/
> +
> +/*
> + * The CSI2 receiver has several parameters affecting
> + * the receiver timings. These depend on the MIPI bus frequency
> + * F in Hz (sensor transmitter rate) as follows:
> + *     register value = (A/1e9 + B * UI) / COUNT_ACC
> + * where
> + *      UI = 1 / (2 * F) in seconds
> + *      COUNT_ACC = counter accuracy in seconds
> + *      For IPU3 COUNT_ACC = 0.0625
> + *
> + * A and B are coefficients from the table below,
> + * depending whether the register minimum or maximum value is
> + * calculated.
> + *                                     Minimum     Maximum
> + * Clock lane                          A     B     A     B
> + * reg_rx_csi_dly_cnt_termen_clane     0     0    38     0
> + * reg_rx_csi_dly_cnt_settle_clane    95    -8   300   -16
> + * Data lanes
> + * reg_rx_csi_dly_cnt_termen_dlane0    0     0    35     4
> + * reg_rx_csi_dly_cnt_settle_dlane0   85    -2   145    -6
> + * reg_rx_csi_dly_cnt_termen_dlane1    0     0    35     4
> + * reg_rx_csi_dly_cnt_settle_dlane1   85    -2   145    -6
> + * reg_rx_csi_dly_cnt_termen_dlane2    0     0    35     4
> + * reg_rx_csi_dly_cnt_settle_dlane2   85    -2   145    -6
> + * reg_rx_csi_dly_cnt_termen_dlane3    0     0    35     4
> + * reg_rx_csi_dly_cnt_settle_dlane3   85    -2   145    -6
> + *
> + * We use the minimum values of both A and B.
> + */
> +
> +/*
> + * shift for keeping value range suitable for 32-bit integer arithmetics
> + */
> +#define LIMIT_SHIFT	8
> +
> +static s32 cio2_rx_timing(s32 a, s32 b, s64 freq, int def)
> +{
> +	const u32 accinv = 16; /* invert of counter resolution */
> +	const u32 uiinv = 500000000; /* 1e9 / 2 */
> +	s32 r;
> +
> +	freq >>= LIMIT_SHIFT;
> +
> +	if (WARN_ON(freq <= 0 || freq > S32_MAX))
> +		return def;
> +	/*
> +	 * b could be 0, -2 or -8, so |accinv * b| is always
> +	 * less than (1 << ds) and thus |r| < 500000000.
> +	 */
> +	r = accinv * b * (uiinv >> LIMIT_SHIFT);
> +	r = r / (s32) freq;
> +	/* max value of a is 95 */
> +	r += accinv * a;
> +
> +	return r;
> +};
> +
> +/* Calculate the the delay value for termination enable of clock lane HS Rx */
> +static int cio2_csi2_calc_timing(struct cio2_device *cio2, struct cio2_queue *q,
> +			    struct cio2_csi2_timing *timing)
> +{
> +	struct device *dev = &cio2->pci_dev->dev;
> +	struct v4l2_querymenu qm = {.id = V4L2_CID_LINK_FREQ, };
> +	struct v4l2_ctrl *link_freq;
> +	s64 freq;
> +	int r;
> +
> +	if (!q->sensor)
> +		return -ENODEV;
> +
> +	link_freq = v4l2_ctrl_find(q->sensor->ctrl_handler, V4L2_CID_LINK_FREQ);
> +	if (!link_freq) {
> +		dev_err(dev, "failed to find LINK_FREQ\n");
> +		return -EPIPE;
> +	};
> +
> +	qm.index = v4l2_ctrl_g_ctrl(link_freq);
> +	r = v4l2_querymenu(q->sensor->ctrl_handler, &qm);
> +	if (r) {
> +		dev_err(dev, "failed to get menu item\n");
> +		return r;
> +	}
> +
> +	if (!qm.value) {
> +		dev_err(dev, "error invalid link_freq\n");
> +		return -EINVAL;
> +	}
> +	freq = qm.value;
> +
> +	timing->clk_termen = cio2_rx_timing(CIO2_CSIRX_DLY_CNT_TERMEN_CLANE_A,
> +				CIO2_CSIRX_DLY_CNT_TERMEN_CLANE_B, freq,
> +				CIO2_CSIRX_DLY_CNT_TERMEN_DEFAULT);
> +	timing->clk_settle = cio2_rx_timing(CIO2_CSIRX_DLY_CNT_SETTLE_CLANE_A,
> +				CIO2_CSIRX_DLY_CNT_SETTLE_CLANE_B, freq,
> +				CIO2_CSIRX_DLY_CNT_SETTLE_DEFAULT);
> +	timing->dat_termen = cio2_rx_timing(CIO2_CSIRX_DLY_CNT_TERMEN_DLANE_A,
> +				CIO2_CSIRX_DLY_CNT_TERMEN_DLANE_B, freq,
> +				CIO2_CSIRX_DLY_CNT_TERMEN_DEFAULT);
> +	timing->dat_settle = cio2_rx_timing(CIO2_CSIRX_DLY_CNT_SETTLE_DLANE_A,
> +				CIO2_CSIRX_DLY_CNT_SETTLE_DLANE_B, freq,
> +				CIO2_CSIRX_DLY_CNT_SETTLE_DEFAULT);
> +
> +	dev_dbg(dev, "freq ct value is %d\n", timing->clk_termen);
> +	dev_dbg(dev, "freq cs value is %d\n", timing->clk_settle);
> +	dev_dbg(dev, "freq dt value is %d\n", timing->dat_termen);
> +	dev_dbg(dev, "freq ds value is %d\n", timing->dat_settle);
> +
> +	return 0;
> +};
> +
> +static int cio2_hw_init(struct cio2_device *cio2, struct cio2_queue *q)
> +{
> +	static const int NUM_VCS = 4;
> +	static const int SID;	/* Stream id */
> +	static const int ENTRY;
> +	static const int FBPT_WIDTH = DIV_ROUND_UP(CIO2_MAX_LOPS,
> +					CIO2_FBPT_SUBENTRY_UNIT);
> +	const u32 num_buffers1 = CIO2_MAX_BUFFERS - 1;
> +	const struct ipu3_cio2_fmt *fmt;
> +	void __iomem *const base = cio2->base;
> +	u8 lanes, csi2bus = q->csi2.port;
> +	u8 sensor_vc = SENSOR_VIR_CH_DFLT;
> +	struct cio2_csi2_timing timing;
> +	int i, r;
> +
> +	fmt = cio2_find_format(NULL, &q->subdev_fmt.code);
> +	if (!fmt)
> +		return -EINVAL;
> +
> +	lanes = q->csi2.lanes;
> +
> +	r = cio2_csi2_calc_timing(cio2, q, &timing);
> +	if (r)
> +		return r;
> +
> +	writel(timing.clk_termen, q->csi_rx_base +
> +		CIO2_REG_CSIRX_DLY_CNT_TERMEN(CIO2_CSIRX_DLY_CNT_CLANE_IDX));
> +	writel(timing.clk_settle, q->csi_rx_base +
> +		CIO2_REG_CSIRX_DLY_CNT_SETTLE(CIO2_CSIRX_DLY_CNT_CLANE_IDX));
> +
> +	for (i = 0; i < lanes; i++) {
> +		writel(timing.dat_termen, q->csi_rx_base +
> +			CIO2_REG_CSIRX_DLY_CNT_TERMEN(i));
> +		writel(timing.dat_settle, q->csi_rx_base +
> +			CIO2_REG_CSIRX_DLY_CNT_SETTLE(i));
> +	}
> +
> +	writel(CIO2_PBM_WMCTRL1_MIN_2CK |
> +	       CIO2_PBM_WMCTRL1_MID1_2CK |
> +	       CIO2_PBM_WMCTRL1_MID2_2CK, base + CIO2_REG_PBM_WMCTRL1);
> +	writel(CIO2_PBM_WMCTRL2_HWM_2CK << CIO2_PBM_WMCTRL2_HWM_2CK_SHIFT |
> +	       CIO2_PBM_WMCTRL2_LWM_2CK << CIO2_PBM_WMCTRL2_LWM_2CK_SHIFT |
> +	       CIO2_PBM_WMCTRL2_OBFFWM_2CK <<
> +	       CIO2_PBM_WMCTRL2_OBFFWM_2CK_SHIFT |
> +	       CIO2_PBM_WMCTRL2_TRANSDYN << CIO2_PBM_WMCTRL2_TRANSDYN_SHIFT |
> +	       CIO2_PBM_WMCTRL2_OBFF_MEM_EN, base + CIO2_REG_PBM_WMCTRL2);
> +	writel(CIO2_PBM_ARB_CTRL_LANES_DIV <<
> +	       CIO2_PBM_ARB_CTRL_LANES_DIV_SHIFT |
> +	       CIO2_PBM_ARB_CTRL_LE_EN |
> +	       CIO2_PBM_ARB_CTRL_PLL_POST_SHTDN <<
> +	       CIO2_PBM_ARB_CTRL_PLL_POST_SHTDN_SHIFT |
> +	       CIO2_PBM_ARB_CTRL_PLL_AHD_WK_UP <<
> +	       CIO2_PBM_ARB_CTRL_PLL_AHD_WK_UP_SHIFT,
> +	       base + CIO2_REG_PBM_ARB_CTRL);
> +	writel(CIO2_CSIRX_STATUS_DLANE_HS_MASK,
> +	       q->csi_rx_base + CIO2_REG_CSIRX_STATUS_DLANE_HS);
> +	writel(CIO2_CSIRX_STATUS_DLANE_LP_MASK,
> +	       q->csi_rx_base + CIO2_REG_CSIRX_STATUS_DLANE_LP);
> +
> +	writel(CIO2_FB_HPLL_FREQ, base + CIO2_REG_FB_HPLL_FREQ);
> +	writel(CIO2_ISCLK_RATIO, base + CIO2_REG_ISCLK_RATIO);
> +
> +	/* Configure MIPI backend */
> +	for (i = 0; i < NUM_VCS; i++)
> +		writel(1, q->csi_rx_base + CIO2_REG_MIPIBE_SP_LUT_ENTRY(i));
> +
> +	/* There are 16 short packet LUT entry */
> +	for (i = 0; i < 16; i++)
> +		writel(CIO2_MIPIBE_LP_LUT_ENTRY_DISREGARD,
> +		       q->csi_rx_base + CIO2_REG_MIPIBE_LP_LUT_ENTRY(i));
> +	writel(CIO2_MIPIBE_GLOBAL_LUT_DISREGARD,
> +	       q->csi_rx_base + CIO2_REG_MIPIBE_GLOBAL_LUT_DISREGARD);
> +
> +	writel(CIO2_INT_EN_EXT_IE_MASK, base + CIO2_REG_INT_EN_EXT_IE);
> +	writel(CIO2_IRQCTRL_MASK, q->csi_rx_base + CIO2_REG_IRQCTRL_MASK);
> +	writel(CIO2_IRQCTRL_MASK, q->csi_rx_base + CIO2_REG_IRQCTRL_ENABLE);
> +	writel(0, q->csi_rx_base + CIO2_REG_IRQCTRL_EDGE);
> +	writel(0, q->csi_rx_base + CIO2_REG_IRQCTRL_LEVEL_NOT_PULSE);
> +	writel(CIO2_INT_EN_EXT_OE_MASK, base + CIO2_REG_INT_EN_EXT_OE);
> +
> +	writel(CIO2_REG_INT_EN_IRQ | CIO2_INT_IOC(CIO2_DMA_CHAN) |
> +	       CIO2_REG_INT_EN_IOS(CIO2_DMA_CHAN),
> +	       base + CIO2_REG_INT_EN);
> +
> +	writel((CIO2_PXM_PXF_FMT_CFG_BPP_10 | CIO2_PXM_PXF_FMT_CFG_PCK_64B)
> +	       << CIO2_PXM_PXF_FMT_CFG_SID0_SHIFT,
> +	       base + CIO2_REG_PXM_PXF_FMT_CFG0(csi2bus));
> +	writel(SID << CIO2_MIPIBE_LP_LUT_ENTRY_SID_SHIFT |
> +	       sensor_vc << CIO2_MIPIBE_LP_LUT_ENTRY_VC_SHIFT |
> +	       fmt->mipicode << CIO2_MIPIBE_LP_LUT_ENTRY_FORMAT_TYPE_SHIFT,
> +	       q->csi_rx_base + CIO2_REG_MIPIBE_LP_LUT_ENTRY(ENTRY));
> +	writel(0, q->csi_rx_base + CIO2_REG_MIPIBE_COMP_FORMAT(sensor_vc));
> +	writel(0, q->csi_rx_base + CIO2_REG_MIPIBE_FORCE_RAW8);
> +	writel(0, base + CIO2_REG_PXM_SID2BID0(csi2bus));
> +
> +	writel(lanes, q->csi_rx_base + CIO2_REG_CSIRX_NOF_ENABLED_LANES);
> +	writel(CIO2_CGC_PRIM_TGE |
> +	       CIO2_CGC_SIDE_TGE |
> +	       CIO2_CGC_XOSC_TGE |
> +	       CIO2_CGC_D3I3_TGE |
> +	       CIO2_CGC_CSI2_INTERFRAME_TGE |
> +	       CIO2_CGC_CSI2_PORT_DCGE |
> +	       CIO2_CGC_SIDE_DCGE |
> +	       CIO2_CGC_PRIM_DCGE |
> +	       CIO2_CGC_ROSC_DCGE |
> +	       CIO2_CGC_XOSC_DCGE |
> +	       CIO2_CGC_CLKGATE_HOLDOFF << CIO2_CGC_CLKGATE_HOLDOFF_SHIFT |
> +	       CIO2_CGC_CSI_CLKGATE_HOLDOFF
> +	       << CIO2_CGC_CSI_CLKGATE_HOLDOFF_SHIFT, base + CIO2_REG_CGC);
> +	writel(CIO2_LTRCTRL_LTRDYNEN, base + CIO2_REG_LTRCTRL);
> +	writel(CIO2_LTRVAL0_VAL << CIO2_LTRVAL02_VAL_SHIFT |
> +	       CIO2_LTRVAL0_SCALE << CIO2_LTRVAL02_SCALE_SHIFT |
> +	       CIO2_LTRVAL1_VAL << CIO2_LTRVAL13_VAL_SHIFT |
> +	       CIO2_LTRVAL1_SCALE << CIO2_LTRVAL13_SCALE_SHIFT,
> +	       base + CIO2_REG_LTRVAL01);
> +	writel(CIO2_LTRVAL2_VAL << CIO2_LTRVAL02_VAL_SHIFT |
> +	       CIO2_LTRVAL2_SCALE << CIO2_LTRVAL02_SCALE_SHIFT |
> +	       CIO2_LTRVAL3_VAL << CIO2_LTRVAL13_VAL_SHIFT |
> +	       CIO2_LTRVAL3_SCALE << CIO2_LTRVAL13_SCALE_SHIFT,
> +	       base + CIO2_REG_LTRVAL23);
> +
> +	for (i = 0; i < CIO2_NUM_DMA_CHAN; i++) {
> +		writel(0, base + CIO2_REG_CDMABA(i));
> +		writel(0, base + CIO2_REG_CDMAC0(i));
> +		writel(0, base + CIO2_REG_CDMAC1(i));
> +	}
> +
> +	/* Enable DMA */
> +	writel(q->fbpt_bus_addr >> PAGE_SHIFT,
> +	       base + CIO2_REG_CDMABA(CIO2_DMA_CHAN));
> +
> +	writel(num_buffers1 << CIO2_CDMAC0_FBPT_LEN_SHIFT |
> +	       FBPT_WIDTH << CIO2_CDMAC0_FBPT_WIDTH_SHIFT |
> +	       CIO2_CDMAC0_DMA_INTR_ON_FE |
> +	       CIO2_CDMAC0_FBPT_UPDATE_FIFO_FULL |
> +	       CIO2_CDMAC0_DMA_EN |
> +	       CIO2_CDMAC0_DMA_INTR_ON_FS |
> +	       CIO2_CDMAC0_DMA_HALTED, base + CIO2_REG_CDMAC0(CIO2_DMA_CHAN));
> +
> +	writel(1 << CIO2_CDMAC1_LINENUMUPDATE_SHIFT,
> +	       base + CIO2_REG_CDMAC1(CIO2_DMA_CHAN));
> +
> +	writel(0, base + CIO2_REG_PBM_FOPN_ABORT);
> +
> +	writel(CIO2_PXM_FRF_CFG_CRC_TH << CIO2_PXM_FRF_CFG_CRC_TH_SHIFT |
> +	       CIO2_PXM_FRF_CFG_MSK_ECC_DPHY_NR |
> +	       CIO2_PXM_FRF_CFG_MSK_ECC_RE |
> +	       CIO2_PXM_FRF_CFG_MSK_ECC_DPHY_NE,
> +	       base + CIO2_REG_PXM_FRF_CFG(q->csi2.port));
> +
> +	/* Clear interrupts */
> +	writel(CIO2_IRQCTRL_MASK, q->csi_rx_base + CIO2_REG_IRQCTRL_CLEAR);
> +	writel(~0, base + CIO2_REG_INT_STS_EXT_OE);
> +	writel(~0, base + CIO2_REG_INT_STS_EXT_IE);
> +	writel(~0, base + CIO2_REG_INT_STS);
> +
> +	/* Enable devices, starting from the last device in the pipe */
> +	writel(1, q->csi_rx_base + CIO2_REG_MIPIBE_ENABLE);
> +	writel(1, q->csi_rx_base + CIO2_REG_CSIRX_ENABLE);
> +
> +	return 0;
> +}
> +
> +static void cio2_hw_exit(struct cio2_device *cio2, struct cio2_queue *q)
> +{
> +	void __iomem *base = cio2->base;
> +	unsigned int i, maxloops = 1000;
> +
> +	/* Disable CSI receiver and MIPI backend devices */
> +	writel(0, q->csi_rx_base + CIO2_REG_CSIRX_ENABLE);
> +	writel(0, q->csi_rx_base + CIO2_REG_MIPIBE_ENABLE);
> +
> +	/* Halt DMA */
> +	writel(0, base + CIO2_REG_CDMAC0(CIO2_DMA_CHAN));
> +	do {
> +		if (readl(base + CIO2_REG_CDMAC0(CIO2_DMA_CHAN)) &
> +		    CIO2_CDMAC0_DMA_HALTED)
> +			break;
> +		usleep_range(1000, 2000);
> +	} while (--maxloops);
> +	if (!maxloops)
> +		dev_err(&cio2->pci_dev->dev,
> +			"DMA %i can not be halted\n", CIO2_DMA_CHAN);
> +
> +	for (i = 0; i < CIO2_NUM_PORTS; i++) {
> +		writel(readl(base + CIO2_REG_PXM_FRF_CFG(i)) |
> +		       CIO2_PXM_FRF_CFG_ABORT, base + CIO2_REG_PXM_FRF_CFG(i));
> +		writel(readl(base + CIO2_REG_PBM_FOPN_ABORT) |
> +		       CIO2_PBM_FOPN_ABORT(i), base + CIO2_REG_PBM_FOPN_ABORT);
> +	}
> +}
> +
> +static void cio2_buffer_done(struct cio2_device *cio2, unsigned int dma_chan)
> +{
> +	struct device *dev = &cio2->pci_dev->dev;
> +	struct cio2_queue *q = cio2->cur_queue;
> +	int buffers_found = 0;
> +	u64 ns;
> +
> +	if (dma_chan >= CIO2_QUEUES) {
> +		dev_err(dev, "bad DMA channel %i\n", dma_chan);
> +		return;
> +	}
> +
> +	ns = ktime_get_ns();

You can assign in variable initialisation.

> +
> +	/* Find out which buffer(s) are ready */
> +	do {
> +		struct cio2_fbpt_entry *const entry =
> +			&q->fbpt[q->bufs_first * CIO2_MAX_LOPS];
> +		struct cio2_buffer *b;
> +
> +		if (entry->first_entry.ctrl & CIO2_FBPT_CTRL_VALID)
> +			break;
> +
> +		b = q->bufs[q->bufs_first];
> +		if (b) {
> +			unsigned int bytes = entry[1].second_entry.num_of_bytes;
> +
> +			q->bufs[q->bufs_first] = NULL;
> +			atomic_dec(&q->bufs_queued);
> +			dev_dbg(&cio2->pci_dev->dev,
> +				"buffer %i done\n", b->vbb.vb2_buf.index);
> +
> +			b->vbb.vb2_buf.timestamp = ns;
> +			b->vbb.field = V4L2_FIELD_NONE;
> +			b->vbb.sequence = atomic_read(&q->frame_sequence);
> +			if (b->vbb.vb2_buf.planes[0].length != bytes)
> +				dev_warn(dev, "buffer length is %d received %d\n",
> +					b->vbb.vb2_buf.planes[0].length, bytes);
> +			vb2_buffer_done(&b->vbb.vb2_buf, VB2_BUF_STATE_DONE);
> +		}
> +		atomic_inc(&q->frame_sequence);
> +		cio2_fbpt_entry_init_dummy(cio2, entry);
> +		q->bufs_first = (q->bufs_first + 1) % CIO2_MAX_BUFFERS;
> +		buffers_found++;
> +	} while (1);
> +
> +	if (buffers_found == 0)
> +		dev_warn(&cio2->pci_dev->dev,
> +			 "no ready buffers found on DMA channel %u\n",
> +			 dma_chan);
> +}
> +
> +static void cio2_queue_event_sof(struct cio2_device *cio2, struct cio2_queue *q)
> +{
> +	/*
> +	 * For the user space camera control algorithms it is essential
> +	 * to know when the reception of a frame has begun. That's often
> +	 * the best timing information to get from the hardware.
> +	 */
> +	struct v4l2_event event = {
> +		.type = V4L2_EVENT_FRAME_SYNC,
> +		.u.frame_sync.frame_sequence = atomic_read(&q->frame_sequence),
> +	};
> +
> +	v4l2_event_queue(q->subdev.devnode, &event);
> +}
> +
> +static const char *const cio2_irq_errs[] = {
> +	"single packet header error corrected",
> +	"multiple packet header errors detected",
> +	"payload checksum (CRC) error",
> +	"fifo overflow",
> +	"reserved short packet data type detected",
> +	"reserved long packet data type detected",
> +	"incomplete long packet detected",
> +	"frame sync error",
> +	"line sync error",
> +	"DPHY start of transmission error",
> +	"DPHY synchronization error",
> +	"escape mode error",
> +	"escape mode trigger event",
> +	"escape mode ultra-low power state for data lane(s)",
> +	"escape mode ultra-low power state exit for clock lane",
> +	"inter-frame short packet discarded",
> +	"inter-frame long packet discarded",
> +	"non-matching Long Packet stalled",
> +};
> +
> +static const char *const cio2_port_errs[] = {
> +	"ECC recoverable",
> +	"DPHY not recoverable",
> +	"ECC not recoverable",
> +	"CRC error",
> +	"INTERFRAMEDATA",
> +	"PKT2SHORT",
> +	"PKT2LONG",
> +};
> +
> +static irqreturn_t cio2_irq(int irq, void *cio2_ptr)
> +{
> +	struct cio2_device *cio2 = cio2_ptr;
> +	void __iomem *const base = cio2->base;
> +	struct device *dev = &cio2->pci_dev->dev;
> +	u32 int_status, int_clear;
> +
> +	int_clear = int_status = readl(base + CIO2_REG_INT_STS);
> +	if (!int_status)
> +		return IRQ_NONE;
> +
> +	if (int_status & CIO2_INT_IOOE) {
> +		/*
> +		 * Interrupt on Output Error:
> +		 * 1) SRAM is full and FS received, or
> +		 * 2) An invalid bit detected by DMA.
> +		 */
> +		u32 oe_status, oe_clear;
> +
> +		oe_clear = readl(base + CIO2_REG_INT_STS_EXT_OE);
> +		oe_status = oe_clear;
> +
> +		if (oe_status & CIO2_INT_EXT_OE_DMAOE_MASK) {
> +			dev_err(dev, "DMA output error: 0x%x\n",
> +				(oe_status & CIO2_INT_EXT_OE_DMAOE_MASK)
> +				>> CIO2_INT_EXT_OE_DMAOE_SHIFT);
> +			oe_status &= ~CIO2_INT_EXT_OE_DMAOE_MASK;
> +		}
> +		if (oe_status & CIO2_INT_EXT_OE_OES_MASK) {
> +			dev_err(dev, "DMA output error on CSI2 buses: 0x%x\n",
> +				(oe_status & CIO2_INT_EXT_OE_OES_MASK)
> +				>> CIO2_INT_EXT_OE_OES_SHIFT);
> +			oe_status &= ~CIO2_INT_EXT_OE_OES_MASK;
> +		}
> +		writel(oe_clear, base + CIO2_REG_INT_STS_EXT_OE);
> +		if (oe_status)
> +			dev_warn(dev, "unknown interrupt 0x%x on OE\n",
> +				 oe_status);
> +		int_status &= ~CIO2_INT_IOOE;
> +	}
> +
> +	if (int_status & CIO2_INT_IOC_MASK) {
> +		/* DMA IO done -- frame ready */
> +		u32 clr = 0;
> +		unsigned int d;
> +
> +		for (d = 0; d < CIO2_NUM_DMA_CHAN; d++)
> +			if (int_status & CIO2_INT_IOC(d)) {
> +				clr |= CIO2_INT_IOC(d);
> +				dev_dbg(dev, "DMA %i done\n", d);
> +				cio2_buffer_done(cio2, d);
> +			}
> +		int_status &= ~clr;
> +	}
> +
> +	if (int_status & CIO2_INT_IOS_IOLN_MASK) {
> +		/* DMA IO starts or reached specified line */
> +		u32 clr = 0;
> +		unsigned int d;
> +
> +		for (d = 0; d < CIO2_NUM_DMA_CHAN; d++)
> +			if (int_status & CIO2_INT_IOS_IOLN(d)) {
> +				clr |= CIO2_INT_IOS_IOLN(d);
> +				if (d == CIO2_DMA_CHAN)
> +					cio2_queue_event_sof(cio2,
> +							     cio2->cur_queue);
> +				dev_dbg(dev,
> +					"DMA %i started or reached line\n", d);
> +			}
> +		int_status &= ~clr;
> +	}
> +
> +	if (int_status & (CIO2_INT_IOIE | CIO2_INT_IOIRQ)) {
> +		/* CSI2 receiver (error) interrupt */
> +		u32 ie_status, ie_clear;
> +		unsigned int port;
> +
> +		ie_clear = readl(base + CIO2_REG_INT_STS_EXT_IE);
> +		ie_status = ie_clear;
> +
> +		for (port = 0; port < CIO2_NUM_PORTS; port++) {
> +			u32 port_status = (ie_status >> (port * 8)) & 0xff;
> +			u32 err_mask = BIT_MASK(ARRAY_SIZE(cio2_port_errs)) - 1;
> +			void __iomem *const csi_rx_base =
> +						base + CIO2_REG_PIPE_BASE(port);
> +			unsigned int i;
> +
> +			while (port_status & err_mask) {
> +				i = ffs(port_status) - 1;
> +				dev_err(dev, "port %i error %s\n",
> +					port, cio2_port_errs[i]);
> +				ie_status &= ~BIT(port * 8 + i);
> +				port_status &= ~BIT(i);
> +			}
> +
> +			if (ie_status & CIO2_INT_EXT_IE_IRQ(port)) {
> +				u32 csi2_status, csi2_clear;
> +
> +				csi2_status = readl(csi_rx_base +
> +						CIO2_REG_IRQCTRL_STATUS);
> +				csi2_clear = csi2_status;
> +				err_mask =
> +					BIT_MASK(ARRAY_SIZE(cio2_irq_errs)) - 1;
> +
> +				while (csi2_status & err_mask) {
> +					i = ffs(csi2_status) - 1;
> +					dev_err(dev,
> +						"CSI-2 receiver port %i: %s\n",
> +							port, cio2_irq_errs[i]);
> +					csi2_status &= ~BIT(i);
> +				}
> +
> +				writel(csi2_clear,
> +				       csi_rx_base + CIO2_REG_IRQCTRL_CLEAR);
> +				if (csi2_status)
> +					dev_warn(dev,
> +						 "unknown CSI2 error 0x%x on port %i\n",
> +						 csi2_status, port);
> +
> +				ie_status &= ~CIO2_INT_EXT_IE_IRQ(port);
> +			}
> +		}
> +
> +		writel(ie_clear, base + CIO2_REG_INT_STS_EXT_IE);
> +		if (ie_status)
> +			dev_warn(dev, "unknown interrupt 0x%x on IE\n",
> +				 ie_status);
> +
> +		int_status &= ~(CIO2_INT_IOIE | CIO2_INT_IOIRQ);
> +	}
> +
> +	writel(int_clear, base + CIO2_REG_INT_STS);
> +	if (int_status)
> +		dev_warn(dev, "unknown interrupt 0x%x on INT\n", int_status);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +/**************** Videobuf2 interface ****************/
> +
> +static void cio2_vb2_return_all_buffers(struct cio2_queue *q)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < CIO2_MAX_BUFFERS; i++) {
> +		if (q->bufs[i]) {
> +			atomic_dec(&q->bufs_queued);
> +			vb2_buffer_done(&q->bufs[i]->vbb.vb2_buf,
> +					VB2_BUF_STATE_ERROR);
> +		}
> +	}
> +}
> +
> +static int cio2_vb2_queue_setup(struct vb2_queue *vq,
> +				unsigned int *num_buffers,
> +				unsigned int *num_planes,
> +				unsigned int sizes[],
> +				struct device *alloc_devs[])
> +{
> +	struct cio2_device *cio2 = vb2_get_drv_priv(vq);
> +	struct cio2_queue *q = vb2q_to_cio2_queue(vq);
> +	unsigned int i;
> +
> +	*num_planes = q->format.num_planes;
> +
> +	for (i = 0; i < *num_planes; ++i) {
> +		sizes[i] = q->format.plane_fmt[i].sizeimage;
> +		alloc_devs[i] = &cio2->pci_dev->dev;
> +	}
> +
> +	*num_buffers = clamp_val(*num_buffers, 1, CIO2_MAX_BUFFERS);
> +
> +	/* Initialize buffer queue */
> +	for (i = 0; i < CIO2_MAX_BUFFERS; i++) {
> +		q->bufs[i] = NULL;
> +		cio2_fbpt_entry_init_dummy(cio2, &q->fbpt[i * CIO2_MAX_LOPS]);
> +	}
> +	atomic_set(&q->bufs_queued, 0);
> +	q->bufs_first = 0;
> +	q->bufs_next = 0;
> +
> +	return 0;
> +}
> +
> +/* Called after each buffer is allocated */
> +static int cio2_vb2_buf_init(struct vb2_buffer *vb)
> +{
> +	struct cio2_device *cio2 = vb2_get_drv_priv(vb->vb2_queue);
> +	struct device *dev = &cio2->pci_dev->dev;
> +	struct cio2_buffer *b =
> +		container_of(vb, struct cio2_buffer, vbb.vb2_buf);
> +	static const unsigned int entries_per_page =
> +		CIO2_PAGE_SIZE / sizeof(u32);
> +	unsigned int pages = DIV_ROUND_UP(vb->planes[0].length, CIO2_PAGE_SIZE);
> +	unsigned int lops = DIV_ROUND_UP(pages + 1, entries_per_page);
> +	struct sg_table *sg;
> +	struct sg_page_iter sg_iter;
> +	unsigned int i, j;
> +
> +	if (lops <= 0 || lops > CIO2_MAX_LOPS) {
> +		dev_err(dev, "%s: bad buffer size (%i)\n", __func__,
> +			vb->planes[0].length);
> +		return -ENOSPC;		/* Should never happen */
> +	}
> +
> +	memset(b->lop, CIO2_MAX_LOPS, sizeof(*b->lop));
> +	/* Allocate LOP table */
> +	for (i = 0; i < lops; i++) {
> +		b->lop[i] = dma_alloc_coherent(dev, CIO2_PAGE_SIZE,
> +					&b->lop_bus_addr[i], GFP_KERNEL);
> +		if (!b->lop[i])
> +			goto fail;
> +	}
> +
> +	/* Fill LOP */
> +	sg = vb2_dma_sg_plane_desc(vb, 0);
> +	if (!sg)
> +		return -ENOMEM;
> +
> +	if (sg->nents && sg->sgl)
> +		b->offset = sg->sgl->offset;
> +
> +	i = j = 0;
> +	for_each_sg_page(sg->sgl, &sg_iter, sg->nents, 0) {
> +		b->lop[i][j] = sg_page_iter_dma_address(&sg_iter) >> PAGE_SHIFT;
> +		j++;
> +		if (j == entries_per_page) {
> +			i++;
> +			j = 0;
> +		}
> +	}
> +
> +	b->lop[i][j] = cio2->dummy_page_bus_addr >> PAGE_SHIFT;
> +	return 0;
> +fail:
> +	for (; i >= 0; i--)
> +		dma_free_coherent(dev, CIO2_PAGE_SIZE,
> +				b->lop[i], b->lop_bus_addr[i]);
> +	return -ENOMEM;
> +}
> +
> +/* Transfer buffer ownership to cio2 */
> +static void cio2_vb2_buf_queue(struct vb2_buffer *vb)
> +{
> +	struct cio2_device *cio2 = vb2_get_drv_priv(vb->vb2_queue);
> +	struct cio2_queue *q =
> +		container_of(vb->vb2_queue, struct cio2_queue, vbq);
> +	struct cio2_buffer *b =
> +		container_of(vb, struct cio2_buffer, vbb.vb2_buf);
> +	struct cio2_fbpt_entry *entry;
> +	unsigned long flags;
> +	unsigned int i, next = q->bufs_next;
> +	int bufs_queued = atomic_inc_return(&q->bufs_queued);
> +	u32 fbpt_rp;
> +
> +	dev_dbg(&cio2->pci_dev->dev, "queue buffer %d\n", vb->index);
> +
> +	/*
> +	 * This code queues the buffer to the CIO2 DMA engine, which starts
> +	 * running once streaming has started. It is possible that this code
> +	 * gets pre-empted due to increased CPU load. Upon this, the driver
> +	 * does not get an opportunity to queue new buffers to the CIO2 DMA
> +	 * engine. When the DMA engine encounters an FBPT entry without the
> +	 * VALID bit set, the DMA engine halts, which requires a restart of
> +	 * the DMA engine and sensor, to continue streaming.
> +	 * This is not desired and is highly unlikely given that there are
> +	 * 32 FBPT entries that the DMA engine needs to process, to run into
> +	 * an FBPT entry, without the VALID bit set. We try to mitigate this
> +	 * by disabling interrupts for the duration of this queueing.
> +	 */
> +	local_irq_save(flags);
> +
> +	fbpt_rp = (readl(cio2->base + CIO2_REG_CDMARI(CIO2_DMA_CHAN))
> +		   >> CIO2_CDMARI_FBPT_RP_SHIFT)
> +		   & CIO2_CDMARI_FBPT_RP_MASK;
> +
> +	/*
> +	 * fbpt_rp is the fbpt entry that the dma is currently working
> +	 * on, but since it could jump to next entry at any time,
> +	 * assume that we might already be there.
> +	 */
> +	fbpt_rp = (fbpt_rp + 1) % CIO2_MAX_BUFFERS;
> +
> +	if (bufs_queued <= 1 || fbpt_rp == next)
> +		/* Buffers were drained */
> +		next = (fbpt_rp + 1) % CIO2_MAX_BUFFERS;
> +
> +	for (i = 0; i < CIO2_MAX_BUFFERS; i++) {
> +		/*
> +		 * We have allocated CIO2_MAX_BUFFERS circularly for the
> +		 * hw, the user has requested N buffer queue. The driver
> +		 * ensures N <= CIO2_MAX_BUFFERS and guarantees that whenever
> +		 * user queues a buffer, there necessarily is a free buffer.
> +		 */
> +		if (!q->bufs[next]) {
> +			q->bufs[next] = b;
> +			entry = &q->fbpt[next * CIO2_MAX_LOPS];
> +			cio2_fbpt_entry_init_buf(cio2, b, entry);
> +			local_irq_restore(flags);
> +			q->bufs_next = (next + 1) % CIO2_MAX_BUFFERS;
> +			vb2_set_plane_payload(vb, 0,
> +					q->format.plane_fmt[0].sizeimage);
> +			return;
> +		}
> +
> +		dev_dbg(&cio2->pci_dev->dev, "entry %i was full!\n", next);
> +		next = (next + 1) % CIO2_MAX_BUFFERS;
> +	}
> +
> +	local_irq_restore(flags);
> +	dev_err(&cio2->pci_dev->dev, "error: all cio2 entries were full!\n");
> +	atomic_dec(&q->bufs_queued);
> +	vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
> +	for (i = 0; i < vb->num_planes; i++)
> +		vb2_set_plane_payload(vb, i, q->format.plane_fmt[i].sizeimage);
> +}
> +
> +/* Called when each buffer is freed */
> +static void cio2_vb2_buf_cleanup(struct vb2_buffer *vb)
> +{
> +	struct cio2_device *cio2 = vb2_get_drv_priv(vb->vb2_queue);
> +	struct cio2_buffer *b =
> +		container_of(vb, struct cio2_buffer, vbb.vb2_buf);
> +	unsigned int i;
> +
> +	/* Free LOP table */
> +	for (i = 0; i < CIO2_MAX_LOPS; i++) {
> +		if (b->lop[i])
> +			dma_free_coherent(&cio2->pci_dev->dev, CIO2_PAGE_SIZE,
> +					  b->lop[i], b->lop_bus_addr[i]);
> +	}
> +}
> +
> +static int cio2_vb2_start_streaming(struct vb2_queue *vq, unsigned int count)
> +{
> +	struct cio2_queue *q = vb2q_to_cio2_queue(vq);
> +	struct cio2_device *cio2 = vb2_get_drv_priv(vq);
> +	int r;
> +
> +	cio2->cur_queue = q;
> +	atomic_set(&q->frame_sequence, 0);
> +
> +	r = pm_runtime_get_sync(&cio2->pci_dev->dev);
> +	if (r < 0) {
> +		dev_info(&cio2->pci_dev->dev,
> +			"failed to set power %d\n", r);
> +		pm_runtime_put(&cio2->pci_dev->dev);
> +		return r;
> +	}
> +
> +	r = media_pipeline_start(&q->vdev.entity, &q->pipe);
> +	if (r)
> +		goto fail_pipeline;
> +
> +	r = cio2_hw_init(cio2, q);
> +	if (r)
> +		goto fail_hw;
> +
> +	/* Start streaming on sensor */
> +	r = v4l2_subdev_call(q->sensor, video, s_stream, 1);
> +	if (r)
> +		goto fail_csi2_subdev;
> +
> +	cio2->streaming = true;
> +
> +	return 0;
> +
> +fail_csi2_subdev:
> +	cio2_hw_exit(cio2, q);
> +fail_hw:
> +	media_pipeline_stop(&q->vdev.entity);
> +fail_pipeline:
> +	dev_dbg(&cio2->pci_dev->dev, "failed to start streaming (%d)\n", r);
> +	cio2_vb2_return_all_buffers(q);
> +
> +	return r;
> +}
> +
> +static void cio2_vb2_stop_streaming(struct vb2_queue *vq)
> +{
> +	struct cio2_queue *q = vb2q_to_cio2_queue(vq);
> +	struct cio2_device *cio2 = vb2_get_drv_priv(vq);
> +
> +	if (v4l2_subdev_call(q->sensor, video, s_stream, 0))
> +		dev_err(&cio2->pci_dev->dev,
> +			"failed to stop sensor streaming\n");
> +
> +	cio2_hw_exit(cio2, q);
> +	cio2_vb2_return_all_buffers(q);
> +	media_pipeline_stop(&q->vdev.entity);
> +	pm_runtime_put(&cio2->pci_dev->dev);
> +	cio2->streaming = false;
> +}
> +
> +static const struct vb2_ops cio2_vb2_ops = {
> +	.buf_init = cio2_vb2_buf_init,
> +	.buf_queue = cio2_vb2_buf_queue,
> +	.buf_cleanup = cio2_vb2_buf_cleanup,
> +	.queue_setup = cio2_vb2_queue_setup,
> +	.start_streaming = cio2_vb2_start_streaming,
> +	.stop_streaming = cio2_vb2_stop_streaming,
> +	.wait_prepare = vb2_ops_wait_prepare,
> +	.wait_finish = vb2_ops_wait_finish,
> +};
> +
> +/**************** V4L2 interface ****************/
> +
> +static int cio2_v4l2_querycap(struct file *file, void *fh,
> +			      struct v4l2_capability *cap)
> +{
> +	struct cio2_device *cio2 = video_drvdata(file);
> +	struct cio2_queue *q = file_to_cio2_queue(file);
> +
> +	strlcpy(cap->driver, CIO2_NAME, sizeof(cap->driver));
> +	strlcpy(cap->card, CIO2_DEVICE_NAME, sizeof(cap->card));
> +	snprintf(cap->bus_info, sizeof(cap->bus_info),
> +		 "PCI:%s", pci_name(cio2->pci_dev));
> +	cap->capabilities = q->vdev.device_caps | V4L2_CAP_DEVICE_CAPS;
> +	return 0;
> +}
> +
> +static int cio2_v4l2_enum_fmt(struct file *file, void *fh,
> +			      struct v4l2_fmtdesc *f)
> +{
> +	if (f->index >= NUM_FORMATS)
> +		return -EINVAL;
> +
> +	f->pixelformat = formats[f->index].fourcc;
> +
> +	return 0;
> +}
> +
> +/* The format is validated in cio2_video_link_validate() */
> +static int cio2_v4l2_g_fmt(struct file *file, void *fh, struct v4l2_format *f)
> +{
> +	struct cio2_queue *q = file_to_cio2_queue(file);
> +
> +	f->fmt.pix_mp = q->format;
> +
> +	return 0;
> +}
> +
> +static int cio2_v4l2_try_fmt(struct file *file, void *fh, struct v4l2_format *f)
> +{
> +	const struct ipu3_cio2_fmt *fmt;
> +	struct v4l2_pix_format_mplane *mpix = &f->fmt.pix_mp;
> +
> +	fmt = cio2_find_format(&mpix->pixelformat, NULL);
> +	if (!fmt)
> +		fmt = &formats[0];
> +
> +	/* Only supports up to 4224x3136 */
> +	if (mpix->width > CIO2_IMAGE_MAX_WIDTH)
> +		mpix->width = CIO2_IMAGE_MAX_WIDTH;
> +	if (mpix->height > CIO2_IMAGE_MAX_LENGTH)
> +		mpix->height = CIO2_IMAGE_MAX_LENGTH;
> +
> +	mpix->num_planes = 1;
> +	mpix->pixelformat = fmt->fourcc;
> +	mpix->colorspace = V4L2_COLORSPACE_RAW;
> +	mpix->field = V4L2_FIELD_NONE;
> +	memset(mpix->reserved, 0, sizeof(mpix->reserved));
> +	mpix->plane_fmt[0].bytesperline = cio2_bytesperline(mpix->width);
> +	mpix->plane_fmt[0].sizeimage = mpix->plane_fmt[0].bytesperline *
> +							mpix->height;
> +	memset(mpix->plane_fmt[0].reserved, 0,
> +		sizeof(mpix->plane_fmt[0].reserved));
> +
> +	/* use default */
> +	mpix->ycbcr_enc = V4L2_YCBCR_ENC_DEFAULT;
> +	mpix->quantization = V4L2_QUANTIZATION_DEFAULT;
> +	mpix->xfer_func = V4L2_XFER_FUNC_DEFAULT;
> +
> +	return 0;
> +}
> +
> +static int cio2_v4l2_s_fmt(struct file *file, void *fh, struct v4l2_format *f)
> +{
> +	struct cio2_queue *q = file_to_cio2_queue(file);
> +
> +	cio2_v4l2_try_fmt(file, fh, f);
> +	q->format = f->fmt.pix_mp;
> +
> +	return 0;
> +}
> +
> +static int
> +cio2_video_enum_input(struct file *file, void *fh, struct v4l2_input *input)
> +{
> +	if (input->index > 0)
> +		return -EINVAL;
> +
> +	strlcpy(input->name, "camera", sizeof(input->name));
> +	input->type = V4L2_INPUT_TYPE_CAMERA;
> +
> +	return 0;
> +}
> +
> +static int
> +cio2_video_g_input(struct file *file, void *fh, unsigned int *input)
> +{
> +	*input = 0;
> +
> +	return 0;
> +}
> +
> +static int
> +cio2_video_s_input(struct file *file, void *fh, unsigned int input)
> +{
> +	return input == 0 ? 0 : -EINVAL;
> +}
> +
> +static const struct v4l2_file_operations cio2_v4l2_fops = {
> +	.owner = THIS_MODULE,
> +	.unlocked_ioctl = video_ioctl2,
> +	.open = v4l2_fh_open,
> +	.release = vb2_fop_release,
> +	.poll = vb2_fop_poll,
> +	.mmap = vb2_fop_mmap,
> +};
> +
> +static const struct v4l2_ioctl_ops cio2_v4l2_ioctl_ops = {
> +	.vidioc_querycap = cio2_v4l2_querycap,
> +	.vidioc_enum_fmt_vid_cap_mplane = cio2_v4l2_enum_fmt,
> +	.vidioc_g_fmt_vid_cap_mplane = cio2_v4l2_g_fmt,
> +	.vidioc_s_fmt_vid_cap_mplane = cio2_v4l2_s_fmt,
> +	.vidioc_try_fmt_vid_cap_mplane = cio2_v4l2_try_fmt,
> +	.vidioc_reqbufs = vb2_ioctl_reqbufs,
> +	.vidioc_create_bufs = vb2_ioctl_create_bufs,
> +	.vidioc_prepare_buf = vb2_ioctl_prepare_buf,
> +	.vidioc_querybuf = vb2_ioctl_querybuf,
> +	.vidioc_qbuf = vb2_ioctl_qbuf,
> +	.vidioc_dqbuf = vb2_ioctl_dqbuf,
> +	.vidioc_streamon = vb2_ioctl_streamon,
> +	.vidioc_streamoff = vb2_ioctl_streamoff,
> +	.vidioc_expbuf = vb2_ioctl_expbuf,
> +	.vidioc_enum_input = cio2_video_enum_input,
> +	.vidioc_g_input	= cio2_video_g_input,
> +	.vidioc_s_input	= cio2_video_s_input,
> +};
> +
> +static int cio2_subdev_subscribe_event(struct v4l2_subdev *sd,
> +				       struct v4l2_fh *fh,
> +				       struct v4l2_event_subscription *sub)
> +{
> +	if (sub->type != V4L2_EVENT_FRAME_SYNC)
> +		return -EINVAL;
> +
> +	/* Line number. For now only zero accepted. */
> +	if (sub->id != 0)
> +		return -EINVAL;
> +
> +	return v4l2_event_subscribe(fh, sub, 0, NULL);
> +}
> +
> +static int cio2_subdev_open(struct v4l2_subdev *sd,
> +				struct v4l2_subdev_fh *fh)
> +{
> +	struct v4l2_mbus_framefmt fmt;
> +	struct v4l2_mbus_framefmt *format;
> +	static const u32 default_width = 1936;
> +	static const u32 default_height = 1096;
> +
> +	/* Initialize try_fmt */
> +	format = v4l2_subdev_get_try_format(sd, fh->pad, CIO2_PAD_SINK);
> +	fmt.width = default_width;
> +	fmt.height = default_height;
> +	fmt.code = formats[NUM_FORMATS - 1].mbus_code;
> +	fmt.field = V4L2_FIELD_NONE;
> +	fmt.colorspace = V4L2_COLORSPACE_RAW;
> +	fmt.ycbcr_enc = V4L2_YCBCR_ENC_DEFAULT;
> +	fmt.quantization = V4L2_QUANTIZATION_DEFAULT;
> +	fmt.xfer_func = V4L2_XFER_FUNC_DEFAULT;
> +	*format = fmt;
> +
> +	/* same as sink */
> +	format = v4l2_subdev_get_try_format(sd, fh->pad, CIO2_PAD_SOURCE);
> +	*format = fmt;
> +
> +	return 0;
> +}
> +
> +/*
> + * cio2_subdev_get_fmt - Handle get format by pads subdev method
> + * @sd : pointer to v4l2 subdev structure
> + * @cfg: V4L2 subdev pad config
> + * @fmt: pointer to v4l2 subdev format structure
> + * return -EINVAL or zero on success
> + */
> +static int cio2_subdev_get_fmt(struct v4l2_subdev *sd,
> +			       struct v4l2_subdev_pad_config *cfg,
> +			       struct v4l2_subdev_format *fmt)
> +{
> +	struct cio2_queue *q = container_of(sd, struct cio2_queue, subdev);
> +	struct v4l2_subdev_format sensor_fmt;
> +	int ret;
> +
> +	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
> +		fmt->format = *v4l2_subdev_get_try_format(sd, cfg, fmt->pad);
> +		return 0;
> +	}
> +
> +	if (fmt->pad == CIO2_PAD_SINK) {
> +		sensor_fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> +		ret = v4l2_subdev_call(q->sensor, pad, get_fmt,
> +					NULL, &sensor_fmt);
> +		if (ret)
> +			return ret;
> +		/* update colorspace etc from sensor */
> +		q->subdev_fmt.colorspace = sensor_fmt.format.colorspace;
> +		q->subdev_fmt.ycbcr_enc = sensor_fmt.format.ycbcr_enc;
> +		q->subdev_fmt.quantization = sensor_fmt.format.quantization;
> +		q->subdev_fmt.xfer_func = sensor_fmt.format.xfer_func;
> +	}
> +
> +	fmt->format = q->subdev_fmt;
> +
> +	return 0;
> +}
> +
> +/*
> + * cio2_subdev_set_fmt - Handle set format by pads subdev method
> + * @sd : pointer to v4l2 subdev structure
> + * @cfg: V4L2 subdev pad config
> + * @fmt: pointer to v4l2 subdev format structure
> + * return -EINVAL or zero on success
> + */
> +static int cio2_subdev_set_fmt(struct v4l2_subdev *sd,
> +			       struct v4l2_subdev_pad_config *cfg,
> +			       struct v4l2_subdev_format *fmt)
> +{
> +	struct cio2_queue *q = container_of(sd, struct cio2_queue, subdev);
> +
> +	/*
> +	 * Only allow setting sink pad format;
> +	 * source always propagates from sink
> +	 */
> +	if (fmt->pad == CIO2_PAD_SOURCE)
> +		return cio2_subdev_get_fmt(sd, cfg, fmt);
> +
> +	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
> +		*v4l2_subdev_get_try_format(sd, cfg, fmt->pad) = fmt->format;
> +	} else {
> +		/* It's the sink, allow changing frame size */
> +		q->subdev_fmt.width = fmt->format.width;
> +		q->subdev_fmt.height = fmt->format.height;
> +		q->subdev_fmt.code = fmt->format.code;
> +		fmt->format = q->subdev_fmt;
> +	}
> +
> +	return 0;
> +}
> +
> +static int cio2_subdev_enum_mbus_code(struct v4l2_subdev *sd,
> +				      struct v4l2_subdev_pad_config *cfg,
> +				      struct v4l2_subdev_mbus_code_enum *code)
> +{
> +	if (code->index >= NUM_FORMATS)
> +		return -EINVAL;
> +
> +	code->code = formats[code->index].mbus_code;
> +	return 0;
> +}
> +
> +static int cio2_subdev_link_validate_get_format(struct media_pad *pad,
> +				     struct v4l2_subdev_format *fmt)
> +{
> +	if (is_media_entity_v4l2_subdev(pad->entity)) {
> +		struct v4l2_subdev *sd =
> +			media_entity_to_v4l2_subdev(pad->entity);
> +
> +		fmt->which = V4L2_SUBDEV_FORMAT_ACTIVE;
> +		fmt->pad = pad->index;
> +		return v4l2_subdev_call(sd, pad, get_fmt, NULL, fmt);
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +static int cio2_video_link_validate(struct media_link *link)
> +{
> +	struct video_device *vd = container_of(link->sink->entity,
> +						struct video_device, entity);
> +	struct cio2_queue *q = container_of(vd, struct cio2_queue, vdev);
> +	struct cio2_device *cio2 = video_get_drvdata(vd);
> +	struct v4l2_subdev_format source_fmt;
> +	int ret;
> +
> +	if (!media_entity_remote_pad(link->sink->entity->pads)) {
> +		dev_info(&cio2->pci_dev->dev,
> +			"video node %s pad not connected\n", vd->name);
> +		return -ENOTCONN;
> +	}
> +
> +	ret = cio2_subdev_link_validate_get_format(link->source, &source_fmt);
> +	if (ret < 0)
> +		return 0;
> +
> +	if (source_fmt.format.width != q->format.width ||
> +	    source_fmt.format.height != q->format.height) {
> +		dev_err(&cio2->pci_dev->dev,
> +			"Wrong width or height %ux%u (%ux%u expected)\n",
> +			q->format.width, q->format.height,
> +			source_fmt.format.width, source_fmt.format.height);
> +		return -EINVAL;
> +	}
> +
> +	if (!cio2_find_format(&q->format.pixelformat, &source_fmt.format.code))
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_subdev_core_ops cio2_subdev_core_ops = {
> +	.subscribe_event = cio2_subdev_subscribe_event,
> +	.unsubscribe_event = v4l2_event_subdev_unsubscribe,
> +};
> +
> +static const struct v4l2_subdev_internal_ops cio2_subdev_internal_ops = {
> +	.open = cio2_subdev_open,
> +};
> +
> +static const struct v4l2_subdev_pad_ops cio2_subdev_pad_ops = {
> +	.link_validate = v4l2_subdev_link_validate_default,
> +	.get_fmt = cio2_subdev_get_fmt,
> +	.set_fmt = cio2_subdev_set_fmt,
> +	.enum_mbus_code = cio2_subdev_enum_mbus_code,
> +};
> +
> +static const struct v4l2_subdev_ops cio2_subdev_ops = {
> +	.core = &cio2_subdev_core_ops,
> +	.pad = &cio2_subdev_pad_ops,
> +};
> +
> +/******* V4L2 sub-device asynchronous registration callbacks***********/
> +
> +struct sensor_async_subdev {
> +	struct v4l2_async_subdev asd;
> +	struct csi2_bus_info csi2;
> +};
> +
> +static struct cio2_queue *cio2_find_queue_by_sensor_node(struct cio2_queue *q,
> +						struct fwnode_handle *fwnode)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < CIO2_QUEUES; i++) {
> +		if (q[i].sensor->fwnode == fwnode)
> +			return &q[i];
> +	}
> +
> +	return NULL;
> +}
> +
> +/* The .bound() notifier callback when a match is found */
> +static int cio2_notifier_bound(struct v4l2_async_notifier *notifier,
> +			       struct v4l2_subdev *sd,
> +			       struct v4l2_async_subdev *asd)
> +{
> +	struct cio2_device *cio2 = container_of(notifier,
> +					struct cio2_device, notifier);
> +	struct sensor_async_subdev *s_asd = container_of(asd,
> +					struct sensor_async_subdev, asd);
> +	struct cio2_queue *q;
> +	unsigned int i;
> +
> +
> +	/* Find first free slot for the subdev */
> +	for (i = 0; i < CIO2_QUEUES; i++)
> +		if (!cio2->queue[i].sensor)
> +			break;
> +
> +	if (i >= CIO2_QUEUES) {
> +		dev_err(&cio2->pci_dev->dev, "too many subdevs\n");
> +		return -ENOSPC;
> +	}
> +	q = &cio2->queue[i];
> +
> +	q->csi2 = s_asd->csi2;
> +	q->sensor = sd;
> +	q->csi_rx_base = cio2->base + CIO2_REG_PIPE_BASE(q->csi2.port);
> +
> +	return 0;
> +}
> +
> +/* The .unbind callback */
> +static void cio2_notifier_unbind(struct v4l2_async_notifier *notifier,
> +				 struct v4l2_subdev *sd,
> +				 struct v4l2_async_subdev *asd)
> +{
> +	struct cio2_device *cio2 = container_of(notifier,
> +						struct cio2_device, notifier);
> +	unsigned int i;
> +
> +	/* Note: sd may here point to unallocated memory. Do not access. */

That may be the case but the patchset that this driver depends on changes
it. :-) So you can remove the comment.

> +	for (i = 0; i < CIO2_QUEUES; i++) {
> +		if (cio2->queue[i].sensor == sd) {
> +			cio2->queue[i].sensor = NULL;
> +			return;
> +		}
> +	}
> +}
> +
> +/* .complete() is called after all subdevices have been located */
> +static int cio2_notifier_complete(struct v4l2_async_notifier *notifier)
> +{
> +	struct cio2_device *cio2 = container_of(notifier, struct cio2_device,
> +						notifier);
> +	struct sensor_async_subdev *s_asd;
> +	struct cio2_queue *q;
> +	unsigned int i, pad;
> +	int ret;
> +
> +	for (i = 0; i < notifier->num_subdevs; i++) {
> +		s_asd = container_of(cio2->notifier.subdevs[i],
> +					struct sensor_async_subdev,
> +					asd);
> +
> +		q = cio2_find_queue_by_sensor_node(
> +						cio2->queue,
> +						s_asd->asd.match.fwnode.fwnode);
> +		if (!q) {
> +			dev_err(&cio2->pci_dev->dev,
> +					"failed to find cio2 queue %d\n", ret);
> +			return -ENXIO;
> +		}
> +
> +		for (pad = 0; pad < q->sensor->entity.num_pads; pad++)
> +			if (q->sensor->entity.pads[pad].flags &
> +						MEDIA_PAD_FL_SOURCE)
> +				break;
> +
> +		if (pad == q->sensor->entity.num_pads) {
> +			dev_err(&cio2->pci_dev->dev,
> +				"failed to find src pad for %s\n",
> +				q->sensor->name);
> +			return -ENXIO;
> +		}
> +
> +		ret = media_create_pad_link(
> +				&q->sensor->entity, pad,
> +				&q->subdev.entity, CIO2_PAD_SINK,
> +				0);
> +		if (ret) {
> +			dev_err(&cio2->pci_dev->dev,
> +					"failed to create link for %s\n",
> +					cio2->queue[i].sensor->name);
> +			return ret;
> +		}
> +	}
> +
> +	return v4l2_device_register_subdev_nodes(&cio2->v4l2_dev);
> +}
> +
> +static const struct v4l2_async_notifier_operations cio2_async_ops = {
> +	.bound = cio2_notifier_bound,
> +	.unbind = cio2_notifier_unbind,
> +	.complete = cio2_notifier_complete,
> +};
> +
> +static int cio2_fwnode_parse(struct device *dev,
> +			     struct v4l2_fwnode_endpoint *vep,
> +			     struct v4l2_async_subdev *asd)
> +{
> +	struct sensor_async_subdev *s_asd =
> +			container_of(asd, struct sensor_async_subdev, asd);
> +
> +	if (vep->bus_type != V4L2_MBUS_CSI2) {
> +		dev_err(dev, "endpoint bus type error\n");
> +		return -EINVAL;
> +	}
> +
> +	s_asd->csi2.port = vep->base.port;
> +	s_asd->csi2.lanes = vep->bus.mipi_csi2.num_data_lanes;
> +
> +	return 0;
> +}
> +
> +static int cio2_notifier_init(struct cio2_device *cio2)
> +{
> +	int ret;
> +
> +	ret = v4l2_async_notifier_parse_fwnode_endpoints(
> +		&cio2->pci_dev->dev, &cio2->notifier,
> +		sizeof(struct sensor_async_subdev),
> +		cio2_fwnode_parse);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (!cio2->notifier.num_subdevs)
> +		return 0;	/* no endpoint */

You could make this an error as well: there device won't do anything in
that case anyway. -ENODEV, perhaps.

> +
> +	cio2->notifier.ops = &cio2_async_ops;
> +	ret = v4l2_async_notifier_register(&cio2->v4l2_dev, &cio2->notifier);
> +	if (ret) {
> +		dev_err(&cio2->pci_dev->dev,
> +			"failed to register async notifier : %d\n", ret);
> +		goto error;
> +	}
> +
> +	return 0;
> +
> +error:
> +	v4l2_async_notifier_cleanup(&cio2->notifier);
> +
> +	return ret;
> +}
> +
> +static void cio2_notifier_exit(struct cio2_device *cio2)
> +{
> +	v4l2_async_notifier_unregister(&cio2->notifier);
> +	v4l2_async_notifier_cleanup(&cio2->notifier);
> +}
> +
> +/**************** Queue initialization ****************/
> +static const struct media_entity_operations cio2_media_ops = {
> +	.link_validate = v4l2_subdev_link_validate,
> +};
> +
> +static const struct media_entity_operations cio2_video_entity_ops = {
> +	.link_validate = cio2_video_link_validate,
> +};
> +
> +int cio2_queue_init(struct cio2_device *cio2, struct cio2_queue *q)
> +{
> +	static const u32 default_width = 1936;
> +	static const u32 default_height = 1096;
> +	const struct ipu3_cio2_fmt dflt_fmt = formats[0];
> +
> +	struct video_device *vdev = &q->vdev;
> +	struct vb2_queue *vbq = &q->vbq;
> +	struct v4l2_subdev *subdev = &q->subdev;
> +	struct v4l2_mbus_framefmt *fmt;
> +	int r;
> +
> +	/* Initialize miscellaneous variables */
> +	mutex_init(&q->lock);
> +
> +	/* Initialize formats to default values */
> +	fmt = &q->subdev_fmt;
> +	fmt->width = default_width;
> +	fmt->height = default_height;
> +	fmt->code = dflt_fmt.mbus_code;
> +	fmt->field = V4L2_FIELD_NONE;
> +
> +	q->format.width = default_width;
> +	q->format.height = default_height;
> +	q->format.pixelformat = dflt_fmt.fourcc;
> +	q->format.colorspace = V4L2_COLORSPACE_RAW;
> +	q->format.field = V4L2_FIELD_NONE;
> +	q->format.num_planes = 1;
> +	q->format.plane_fmt[0].bytesperline =
> +				cio2_bytesperline(q->format.width);
> +	q->format.plane_fmt[0].sizeimage = q->format.plane_fmt[0].bytesperline *
> +						q->format.height;
> +
> +	/* Initialize fbpt */
> +	r = cio2_fbpt_init(cio2, q);
> +	if (r)
> +		goto fail_fbpt;
> +
> +	/* Initialize media entities */
> +	q->subdev_pads[CIO2_PAD_SINK].flags = MEDIA_PAD_FL_SINK |
> +		MEDIA_PAD_FL_MUST_CONNECT;
> +	q->subdev_pads[CIO2_PAD_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
> +	subdev->entity.ops = &cio2_media_ops;
> +	subdev->internal_ops = &cio2_subdev_internal_ops;
> +	r = media_entity_pads_init(&subdev->entity, CIO2_PADS, q->subdev_pads);
> +	if (r) {
> +		dev_err(&cio2->pci_dev->dev,
> +			"failed initialize subdev media entity (%d)\n", r);
> +		goto fail_subdev_media_entity;
> +	}
> +
> +	q->vdev_pad.flags = MEDIA_PAD_FL_SINK | MEDIA_PAD_FL_MUST_CONNECT;
> +	vdev->entity.ops = &cio2_video_entity_ops;
> +	r = media_entity_pads_init(&vdev->entity, 1, &q->vdev_pad);
> +	if (r) {
> +		dev_err(&cio2->pci_dev->dev,
> +			"failed initialize videodev media entity (%d)\n", r);
> +		goto fail_vdev_media_entity;
> +	}
> +
> +	/* Initialize subdev */
> +	v4l2_subdev_init(subdev, &cio2_subdev_ops);
> +	subdev->flags = V4L2_SUBDEV_FL_HAS_DEVNODE | V4L2_SUBDEV_FL_HAS_EVENTS;
> +	subdev->owner = THIS_MODULE;
> +	snprintf(subdev->name, sizeof(subdev->name),
> +		 CIO2_ENTITY_NAME ":%li", q - cio2->queue);
> +	v4l2_set_subdevdata(subdev, cio2);
> +	r = v4l2_device_register_subdev(&cio2->v4l2_dev, subdev);
> +	if (r) {
> +		dev_err(&cio2->pci_dev->dev,
> +			"failed initialize subdev (%d)\n", r);
> +		goto fail_subdev;
> +	}
> +
> +	/* Initialize vbq */
> +	vbq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> +	vbq->io_modes = VB2_USERPTR | VB2_MMAP | VB2_DMABUF;
> +	vbq->ops = &cio2_vb2_ops;
> +	vbq->mem_ops = &vb2_dma_sg_memops;
> +	vbq->buf_struct_size = sizeof(struct cio2_buffer);
> +	vbq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	vbq->min_buffers_needed = 1;
> +	vbq->drv_priv = cio2;
> +	vbq->lock = &q->lock;
> +	r = vb2_queue_init(vbq);
> +	if (r) {
> +		dev_err(&cio2->pci_dev->dev,
> +			"failed to initialize videobuf2 queue (%d)\n", r);
> +		goto fail_vbq;
> +	}
> +
> +	/* Initialize vdev */
> +	snprintf(vdev->name, sizeof(vdev->name),
> +		 "%s:%li", CIO2_NAME, q - cio2->queue);
> +	vdev->release = video_device_release_empty;
> +	vdev->fops = &cio2_v4l2_fops;
> +	vdev->ioctl_ops = &cio2_v4l2_ioctl_ops;
> +	vdev->lock = &cio2->lock;
> +	vdev->v4l2_dev = &cio2->v4l2_dev;
> +	vdev->queue = &q->vbq;
> +	vdev->device_caps = V4L2_CAP_VIDEO_CAPTURE_MPLANE | V4L2_CAP_STREAMING;
> +	video_set_drvdata(vdev, cio2);
> +	r = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
> +	if (r) {
> +		dev_err(&cio2->pci_dev->dev,
> +			"failed to register video device (%d)\n", r);
> +		goto fail_vdev;
> +	}
> +
> +	/* Create link from CIO2 subdev to output node */
> +	r = media_create_pad_link(
> +		&subdev->entity, CIO2_PAD_SOURCE, &vdev->entity, 0,
> +		MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE);
> +	if (r)
> +		goto fail_link;
> +
> +	return 0;
> +
> +fail_link:
> +	video_unregister_device(&q->vdev);
> +fail_vdev:
> +	vb2_queue_release(vbq);
> +fail_vbq:
> +	v4l2_device_unregister_subdev(subdev);
> +fail_subdev:
> +	media_entity_cleanup(&vdev->entity);
> +fail_vdev_media_entity:
> +	media_entity_cleanup(&subdev->entity);
> +fail_subdev_media_entity:
> +	cio2_fbpt_exit(q, &cio2->pci_dev->dev);
> +fail_fbpt:
> +	mutex_destroy(&q->lock);
> +
> +	return r;
> +}
> +
> +static void cio2_queue_exit(struct cio2_device *cio2, struct cio2_queue *q)
> +{
> +	video_unregister_device(&q->vdev);
> +	media_entity_cleanup(&q->vdev.entity);
> +	vb2_queue_release(&q->vbq);
> +	v4l2_device_unregister_subdev(&q->subdev);
> +	media_entity_cleanup(&q->subdev.entity);
> +	cio2_fbpt_exit(q, &cio2->pci_dev->dev);
> +	mutex_destroy(&q->lock);
> +}
> +
> +static int cio2_queues_init(struct cio2_device *cio2)
> +{
> +	int i, r;
> +
> +	for (i = 0; i < CIO2_QUEUES; i++) {
> +		r = cio2_queue_init(cio2, &cio2->queue[i]);
> +		if (r)
> +			break;
> +	}
> +
> +	if (i == CIO2_QUEUES)
> +		return 0;
> +
> +	for (i--; i >= 0; i--)
> +		cio2_queue_exit(cio2, &cio2->queue[i]);
> +
> +	return r;
> +}
> +
> +static void cio2_queues_exit(struct cio2_device *cio2)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < CIO2_QUEUES; i++)
> +		cio2_queue_exit(cio2, &cio2->queue[i]);
> +}
> +
> +/**************** PCI interface ****************/
> +
> +static int cio2_pci_config_setup(struct pci_dev *dev)
> +{
> +	u16 pci_command;
> +	int r = pci_enable_msi(dev);
> +
> +	if (r) {
> +		dev_err(&dev->dev, "failed to enable MSI (%d)\n", r);
> +		return r;
> +	}
> +
> +	pci_read_config_word(dev, PCI_COMMAND, &pci_command);
> +	pci_command |= PCI_COMMAND_MEMORY | PCI_COMMAND_MASTER |
> +		PCI_COMMAND_INTX_DISABLE;
> +	pci_write_config_word(dev, PCI_COMMAND, pci_command);
> +
> +	return 0;
> +}
> +
> +static int cio2_pci_probe(struct pci_dev *pci_dev,
> +			  const struct pci_device_id *id)
> +{
> +	struct cio2_device *cio2;
> +	phys_addr_t phys;
> +	void __iomem *const *iomap;
> +	int r;
> +
> +	cio2 = devm_kzalloc(&pci_dev->dev, sizeof(*cio2), GFP_KERNEL);
> +	if (!cio2)
> +		return -ENOMEM;
> +	cio2->pci_dev = pci_dev;
> +
> +	r = pcim_enable_device(pci_dev);
> +	if (r) {
> +		dev_err(&pci_dev->dev, "failed to enable device (%d)\n", r);
> +		return r;
> +	}
> +
> +	dev_info(&pci_dev->dev, "device 0x%x (rev: 0x%x)\n",
> +		 pci_dev->device, pci_dev->revision);
> +
> +	phys = pci_resource_start(pci_dev, CIO2_PCI_BAR);
> +
> +	r = pcim_iomap_regions(pci_dev, 1 << CIO2_PCI_BAR, pci_name(pci_dev));
> +	if (r) {
> +		dev_err(&pci_dev->dev, "failed to remap I/O memory (%d)\n", r);
> +		return -ENODEV;
> +	}
> +
> +	iomap = pcim_iomap_table(pci_dev);
> +	if (!iomap) {
> +		dev_err(&pci_dev->dev, "failed to iomap table\n");
> +		return -ENODEV;
> +	}
> +
> +	cio2->base = iomap[CIO2_PCI_BAR];
> +
> +	pci_set_drvdata(pci_dev, cio2);
> +
> +	pci_set_master(pci_dev);
> +
> +	r = pci_set_dma_mask(pci_dev, CIO2_DMA_MASK);
> +	if (r) {
> +		dev_err(&pci_dev->dev, "failed to set DMA mask (%d)\n", r);
> +		return -ENODEV;
> +	}
> +
> +	r = cio2_pci_config_setup(pci_dev);
> +	if (r)
> +		return -ENODEV;
> +
> +	mutex_init(&cio2->lock);
> +
> +	cio2->media_dev.dev = &cio2->pci_dev->dev;
> +	strlcpy(cio2->media_dev.model, CIO2_DEVICE_NAME,
> +		sizeof(cio2->media_dev.model));
> +	snprintf(cio2->media_dev.bus_info, sizeof(cio2->media_dev.bus_info),
> +		 "PCI:%s", pci_name(cio2->pci_dev));
> +	cio2->media_dev.hw_revision = 0;
> +
> +	media_device_init(&cio2->media_dev);
> +	r = media_device_register(&cio2->media_dev);
> +	if (r < 0)
> +		goto fail_mutex_destroy;
> +
> +	cio2->v4l2_dev.mdev = &cio2->media_dev;
> +	r = v4l2_device_register(&pci_dev->dev, &cio2->v4l2_dev);
> +	if (r) {
> +		dev_err(&pci_dev->dev,
> +			"failed to register V4L2 device (%d)\n", r);
> +		goto fail_media_device_unregister;
> +	}

Registering the devices should be done as last, when the hardware has
already been initialised.

> +
> +	r = cio2_queues_init(cio2);
> +	if (r)
> +		goto fail_v4l2_device_unregister;
> +
> +	r = cio2_fbpt_init_dummy(cio2);
> +	if (r)
> +		goto fail_cio2_queue_exit;
> +
> +	/* Register notifier for subdevices we care */
> +	r = cio2_notifier_init(cio2);
> +	if (r)
> +		goto fail_cio2_fbpt_exit_dummy;
> +
> +	r = devm_request_irq(&pci_dev->dev, pci_dev->irq, cio2_irq,
> +			     IRQF_SHARED, CIO2_NAME, cio2);
> +	if (r) {
> +		dev_err(&pci_dev->dev, "failed to request IRQ (%d)\n", r);
> +		goto fail;
> +	}
> +
> +	pm_runtime_put_noidle(&pci_dev->dev);
> +	pm_runtime_allow(&pci_dev->dev);
> +
> +	return 0;
> +
> +fail:
> +	cio2_notifier_exit(cio2);
> +fail_cio2_fbpt_exit_dummy:
> +	cio2_fbpt_exit_dummy(cio2);
> +fail_cio2_queue_exit:
> +	cio2_queues_exit(cio2);
> +fail_v4l2_device_unregister:
> +	v4l2_device_unregister(&cio2->v4l2_dev);
> +fail_media_device_unregister:
> +	media_device_unregister(&cio2->media_dev);
> +	media_device_cleanup(&cio2->media_dev);
> +fail_mutex_destroy:
> +	mutex_destroy(&cio2->lock);
> +
> +	return r;
> +}
> +
> +static void cio2_pci_remove(struct pci_dev *pci_dev)
> +{
> +	struct cio2_device *cio2 = pci_get_drvdata(pci_dev);
> +	unsigned int i;
> +
> +	cio2_notifier_exit(cio2);
> +	cio2_fbpt_exit_dummy(cio2);
> +	for (i = 0; i < CIO2_QUEUES; i++)
> +		cio2_queue_exit(cio2, &cio2->queue[i]);
> +	v4l2_device_unregister(&cio2->v4l2_dev);
> +	media_device_unregister(&cio2->media_dev);
> +	media_device_cleanup(&cio2->media_dev);
> +	mutex_destroy(&cio2->lock);
> +}
> +
> +static int cio2_runtime_suspend(struct device *dev)
> +{
> +	struct pci_dev *pci_dev = to_pci_dev(dev);
> +	struct cio2_device *cio2 = pci_get_drvdata(pci_dev);
> +	void __iomem *const base = cio2->base;
> +	u16 pm;
> +
> +	writel(CIO2_D0I3C_I3, base + CIO2_REG_D0I3C);
> +	dev_dbg(dev, "cio2 runtime suspend.\n");
> +
> +	pci_read_config_word(pci_dev, pci_dev->pm_cap + CIO2_PMCSR_OFFSET,
> +				&pm);
> +	pm = (pm >> CIO2_PMCSR_D0D3_SHIFT) << CIO2_PMCSR_D0D3_SHIFT;
> +	pm |= CIO2_PMCSR_D3;
> +	pci_write_config_word(pci_dev, pci_dev->pm_cap + CIO2_PMCSR_OFFSET,
> +				pm);
> +
> +	return 0;
> +}
> +
> +static int cio2_runtime_resume(struct device *dev)
> +{
> +	struct pci_dev *pci_dev = to_pci_dev(dev);
> +	struct cio2_device *cio2 = pci_get_drvdata(pci_dev);
> +	void __iomem *const base = cio2->base;
> +	u16 pm;
> +
> +	writel(CIO2_D0I3C_RR, base + CIO2_REG_D0I3C);
> +	dev_dbg(dev, "cio2 runtime resume.\n");
> +
> +	pci_read_config_word(pci_dev, pci_dev->pm_cap + CIO2_PMCSR_OFFSET,
> +				&pm);
> +	pm = (pm >> CIO2_PMCSR_D0D3_SHIFT) << CIO2_PMCSR_D0D3_SHIFT;
> +	pci_write_config_word(pci_dev, pci_dev->pm_cap + CIO2_PMCSR_OFFSET,
> +				pm);
> +
> +	return 0;
> +}
> +
> +static int cio2_suspend(struct device *dev)
> +{
> +	struct pci_dev *pci_dev = to_pci_dev(dev);
> +	struct cio2_device *cio2 = pci_get_drvdata(pci_dev);
> +	struct cio2_queue *q = cio2->cur_queue;
> +
> +	dev_dbg(dev, "cio2 suspend\n");
> +	if (!cio2->streaming)
> +		return 0;
> +
> +	/* Stop stream */
> +	cio2_hw_exit(cio2, q);
> +	pm_runtime_force_suspend(dev);
> +	return 0;
> +}
> +
> +static int cio2_resume(struct device *dev)
> +{
> +	struct pci_dev *pci_dev = to_pci_dev(dev);
> +	struct cio2_device *cio2 = pci_get_drvdata(pci_dev);
> +	int r = 0;
> +	struct cio2_queue *q = cio2->cur_queue;
> +
> +	dev_dbg(dev, "cio2 resume\n");
> +	if (!cio2->streaming)
> +		return 0;
> +	/* Start stream */
> +	r = pm_runtime_force_resume(&cio2->pci_dev->dev);
> +	if (r < 0) {
> +		dev_err(&cio2->pci_dev->dev,
> +			"failed to set power %d\n", r);
> +		return r;
> +	}
> +
> +	cio2_fbpt_rearrange(cio2, q);
> +	q->bufs_first = 0;
> +	q->bufs_next = 0;
> +
> +	r = cio2_hw_init(cio2, q);
> +	if (r)
> +		dev_err(dev, "fail to init cio2 hw\n");
> +
> +	return r;
> +}
> +
> +static const struct dev_pm_ops cio2_pm_ops = {
> +	SET_RUNTIME_PM_OPS(&cio2_runtime_suspend, &cio2_runtime_resume, NULL)
> +	SET_SYSTEM_SLEEP_PM_OPS(&cio2_suspend, &cio2_resume)
> +};
> +
> +static const struct pci_device_id cio2_pci_id_table[] = {
> +	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, CIO2_PCI_ID) },
> +	{ 0 }
> +};
> +
> +MODULE_DEVICE_TABLE(pci, cio2_pci_id_table);
> +
> +static struct pci_driver cio2_pci_driver = {
> +	.name = CIO2_NAME,
> +	.id_table = cio2_pci_id_table,
> +	.probe = cio2_pci_probe,
> +	.remove = cio2_pci_remove,
> +	.driver = {
> +		.pm = &cio2_pm_ops,
> +	},
> +};
> +
> +module_pci_driver(cio2_pci_driver);
> +
> +MODULE_AUTHOR("Tuukka Toivonen <tuukka.toivonen@intel.com>");
> +MODULE_AUTHOR("Tianshu Qiu <tian.shu.qiu@intel.com>");
> +MODULE_AUTHOR("Jian Xu Zheng <jian.xu.zheng@intel.com>");
> +MODULE_AUTHOR("Yuning Pu <yuning.pu@intel.com>");
> +MODULE_AUTHOR("Yong Zhi <yong.zhi@intel.com>");
> +MODULE_LICENSE("GPL v2");
> +MODULE_DESCRIPTION("IPU3 CIO2 driver");
> diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.h b/drivers/media/pci/intel/ipu3/ipu3-cio2.h
> new file mode 100644
> index 000000000000..275b287359e3
> --- /dev/null
> +++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.h
> @@ -0,0 +1,452 @@
> +/*
> + * Copyright (c) 2017 Intel Corporation.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License version
> + * 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef __IPU3_CIO2_H
> +#define __IPU3_CIO2_H
> +
> +#define CIO2_NAME					"ipu3-cio2"
> +#define CIO2_DEVICE_NAME				"Intel IPU3 CIO2"
> +#define CIO2_ENTITY_NAME				"ipu3-csi2"
> +#define CIO2_PCI_ID					0x9d32
> +#define CIO2_PCI_BAR					0
> +#define CIO2_DMA_MASK					DMA_BIT_MASK(39)
> +#define CIO2_IMAGE_MAX_WIDTH				4224
> +#define CIO2_IMAGE_MAX_LENGTH				3136
> +
> +#define CIO2_IMAGE_MAX_WIDTH				4224
> +#define CIO2_IMAGE_MAX_LENGTH				3136
> +
> +/* 1 for each sensor */
> +#define CIO2_QUEUES					2

You have four CSI-2 ports. Why two queues? You could allocate them
dynamically but I see no reason to restrict the driver to support just two.

> +/* 32MB = 8xFBPT_entry */
> +#define CIO2_MAX_LOPS					8
> +#define CIO2_MAX_BUFFERS			(PAGE_SIZE / 16 / CIO2_MAX_LOPS)
> +
> +#define CIO2_PAD_SINK					0
> +#define CIO2_PAD_SOURCE					1
> +#define CIO2_PADS					2
> +
> +#define CIO2_NUM_DMA_CHAN				20
> +#define CIO2_NUM_PORTS					4 /* DPHYs */
> +
> +/* Register and bit field definitions */
> +#define CIO2_REG_PIPE_BASE(n)			((n) * 0x0400)	/* n = 0..3 */
> +#define CIO2_REG_CSIRX_BASE				0x000
> +#define CIO2_REG_MIPIBE_BASE				0x100
> +#define CIO2_REG_PIXELGEN_BAS				0x200
> +#define CIO2_REG_IRQCTRL_BASE				0x300
> +#define CIO2_REG_GPREG_BASE				0x1000
> +
> +/* base register: CIO2_REG_PIPE_BASE(pipe) * CIO2_REG_CSIRX_BASE */
> +#define CIO2_REG_CSIRX_ENABLE			(CIO2_REG_CSIRX_BASE + 0x0)
> +#define CIO2_REG_CSIRX_NOF_ENABLED_LANES	(CIO2_REG_CSIRX_BASE + 0x4)
> +#define CIO2_REG_CSIRX_SP_IF_CONFIG		(CIO2_REG_CSIRX_BASE + 0x10)
> +#define CIO2_REG_CSIRX_LP_IF_CONFIG		(CIO2_REG_CSIRX_BASE + 0x14)
> +#define CIO2_CSIRX_IF_CONFIG_FILTEROUT			0x00
> +#define CIO2_CSIRX_IF_CONFIG_FILTEROUT_VC_INACTIVE	0x01
> +#define CIO2_CSIRX_IF_CONFIG_PASS			0x02
> +#define CIO2_CSIRX_IF_CONFIG_FLAG_ERROR			BIT(2)
> +#define CIO2_REG_CSIRX_STATUS			(CIO2_REG_CSIRX_BASE + 0x18)
> +#define CIO2_REG_CSIRX_STATUS_DLANE_HS		(CIO2_REG_CSIRX_BASE + 0x1c)
> +#define CIO2_CSIRX_STATUS_DLANE_HS_MASK			0xff
> +#define CIO2_REG_CSIRX_STATUS_DLANE_LP		(CIO2_REG_CSIRX_BASE + 0x20)
> +#define CIO2_CSIRX_STATUS_DLANE_LP_MASK			0xffffff
> +/* Termination enable and settle in 0.0625ns units, lane=0..3 or -1 for clock */
> +#define CIO2_REG_CSIRX_DLY_CNT_TERMEN(lane) \
> +				(CIO2_REG_CSIRX_BASE + 0x2c + 8*(lane))
> +#define CIO2_REG_CSIRX_DLY_CNT_SETTLE(lane) \
> +				(CIO2_REG_CSIRX_BASE + 0x30 + 8*(lane))
> +/* base register: CIO2_REG_PIPE_BASE(pipe) * CIO2_REG_MIPIBE_BASE */
> +#define CIO2_REG_MIPIBE_ENABLE		(CIO2_REG_MIPIBE_BASE + 0x0)
> +#define CIO2_REG_MIPIBE_STATUS		(CIO2_REG_MIPIBE_BASE + 0x4)
> +#define CIO2_REG_MIPIBE_COMP_FORMAT(vc) \
> +				(CIO2_REG_MIPIBE_BASE + 0x8 + 0x4*(vc))
> +#define CIO2_REG_MIPIBE_FORCE_RAW8	(CIO2_REG_MIPIBE_BASE + 0x20)
> +#define CIO2_REG_MIPIBE_FORCE_RAW8_ENABLE		BIT(0)
> +#define CIO2_REG_MIPIBE_FORCE_RAW8_USE_TYPEID		BIT(1)
> +#define CIO2_REG_MIPIBE_FORCE_RAW8_TYPEID_SHIFT		2
> +
> +#define CIO2_REG_MIPIBE_IRQ_STATUS	(CIO2_REG_MIPIBE_BASE + 0x24)
> +#define CIO2_REG_MIPIBE_IRQ_CLEAR	(CIO2_REG_MIPIBE_BASE + 0x28)
> +#define CIO2_REG_MIPIBE_GLOBAL_LUT_DISREGARD (CIO2_REG_MIPIBE_BASE + 0x68)
> +#define CIO2_MIPIBE_GLOBAL_LUT_DISREGARD		1
> +#define CIO2_REG_MIPIBE_PKT_STALL_STATUS (CIO2_REG_MIPIBE_BASE + 0x6c)
> +#define CIO2_REG_MIPIBE_PARSE_GSP_THROUGH_LP_LUT_REG_IDX \
> +					(CIO2_REG_MIPIBE_BASE + 0x70)
> +#define CIO2_REG_MIPIBE_SP_LUT_ENTRY(vc) \
> +				       (CIO2_REG_MIPIBE_BASE + 0x74 + 4*(vc))
> +#define CIO2_REG_MIPIBE_LP_LUT_ENTRY(m)	/* m = 0..15 */ \
> +					(CIO2_REG_MIPIBE_BASE + 0x84 + 4*(m))
> +#define CIO2_MIPIBE_LP_LUT_ENTRY_DISREGARD		1
> +#define CIO2_MIPIBE_LP_LUT_ENTRY_SID_SHIFT		1
> +#define CIO2_MIPIBE_LP_LUT_ENTRY_VC_SHIFT		5
> +#define CIO2_MIPIBE_LP_LUT_ENTRY_FORMAT_TYPE_SHIFT	7
> +
> +/* base register: CIO2_REG_PIPE_BASE(pipe) * CIO2_REG_IRQCTRL_BASE */
> +/* IRQ registers are 18-bit wide, see cio2_irq_error for bit definitions */
> +#define CIO2_REG_IRQCTRL_EDGE		(CIO2_REG_IRQCTRL_BASE + 0x00)
> +#define CIO2_REG_IRQCTRL_MASK		(CIO2_REG_IRQCTRL_BASE + 0x04)
> +#define CIO2_REG_IRQCTRL_STATUS		(CIO2_REG_IRQCTRL_BASE + 0x08)
> +#define CIO2_REG_IRQCTRL_CLEAR		(CIO2_REG_IRQCTRL_BASE + 0x0c)
> +#define CIO2_REG_IRQCTRL_ENABLE		(CIO2_REG_IRQCTRL_BASE + 0x10)
> +#define CIO2_REG_IRQCTRL_LEVEL_NOT_PULSE	(CIO2_REG_IRQCTRL_BASE + 0x14)
> +
> +#define CIO2_REG_GPREG_SRST		(CIO2_REG_GPREG_BASE + 0x0)
> +#define CIO2_GPREG_SRST_ALL				0xffff	/* Reset all */
> +#define CIO2_REG_FB_HPLL_FREQ		(CIO2_REG_GPREG_BASE + 0x08)
> +#define CIO2_REG_ISCLK_RATIO		(CIO2_REG_GPREG_BASE + 0xc)
> +
> +#define CIO2_REG_CGC					0x1400
> +#define CIO2_CGC_CSI2_TGE				BIT(0)
> +#define CIO2_CGC_PRIM_TGE				BIT(1)
> +#define CIO2_CGC_SIDE_TGE				BIT(2)
> +#define CIO2_CGC_XOSC_TGE				BIT(3)
> +#define CIO2_CGC_MPLL_SHUTDOWN_EN			BIT(4)
> +#define CIO2_CGC_D3I3_TGE				BIT(5)
> +#define CIO2_CGC_CSI2_INTERFRAME_TGE			BIT(6)
> +#define CIO2_CGC_CSI2_PORT_DCGE				BIT(8)
> +#define CIO2_CGC_CSI2_DCGE				BIT(9)
> +#define CIO2_CGC_SIDE_DCGE				BIT(10)
> +#define CIO2_CGC_PRIM_DCGE				BIT(11)
> +#define CIO2_CGC_ROSC_DCGE				BIT(12)
> +#define CIO2_CGC_XOSC_DCGE				BIT(13)
> +#define CIO2_CGC_FLIS_DCGE				BIT(14)
> +#define CIO2_CGC_CLKGATE_HOLDOFF_SHIFT			20
> +#define CIO2_CGC_CSI_CLKGATE_HOLDOFF_SHIFT		24
> +#define CIO2_REG_D0I3C					0x1408
> +#define CIO2_D0I3C_I3					BIT(2)	/* Set D0I3 */
> +#define CIO2_D0I3C_RR					BIT(3)	/* Restore? */
> +#define CIO2_REG_SWRESET				0x140c
> +#define CIO2_SWRESET_SWRESET				1
> +#define CIO2_REG_SENSOR_ACTIVE				0x1410
> +#define CIO2_REG_INT_STS				0x1414
> +#define CIO2_REG_INT_STS_EXT_OE				0x1418
> +#define CIO2_INT_EXT_OE_DMAOE_SHIFT			0
> +#define CIO2_INT_EXT_OE_DMAOE_MASK			0x7ffff
> +#define CIO2_INT_EXT_OE_OES_SHIFT			24
> +#define CIO2_INT_EXT_OE_OES_MASK	(0xf << CIO2_INT_EXT_OE_OES_SHIFT)
> +#define CIO2_REG_INT_EN					0x1420
> +#define CIO2_REG_INT_EN_IRQ				(1 << 24)
> +#define CIO2_REG_INT_EN_IOS(dma)	(1 << (((dma) >> 1) + 12))
> +/*
> + * Interrupt on completion bit, Eg. DMA 0-3 maps to bit 0-3,
> + * DMA4 & DMA5 map to bit 4 ... DMA18 & DMA19 map to bit 11 Et cetera
> + */
> +#define CIO2_INT_IOC(dma)	(1 << ((dma) < 4 ? (dma) : ((dma) >> 1) + 2))
> +#define CIO2_INT_IOC_SHIFT				0
> +#define CIO2_INT_IOC_MASK		(0x7ff << CIO2_INT_IOC_SHIFT)
> +#define CIO2_INT_IOS_IOLN(dma)		(1 << (((dma) >> 1) + 12))
> +#define CIO2_INT_IOS_IOLN_SHIFT				12
> +#define CIO2_INT_IOS_IOLN_MASK		(0x3ff << CIO2_INT_IOS_IOLN_SHIFT)
> +#define CIO2_INT_IOIE					BIT(22)
> +#define CIO2_INT_IOOE					BIT(23)
> +#define CIO2_INT_IOIRQ					BIT(24)
> +#define CIO2_REG_INT_EN_EXT_OE				0x1424
> +#define CIO2_REG_DMA_DBG				0x1448
> +#define CIO2_REG_DMA_DBG_DMA_INDEX_SHIFT		0
> +#define CIO2_REG_PBM_ARB_CTRL				0x1460
> +#define CIO2_PBM_ARB_CTRL_LANES_DIV			0 /* 4-4-2-2 lanes */
> +#define CIO2_PBM_ARB_CTRL_LANES_DIV_SHIFT		0
> +#define CIO2_PBM_ARB_CTRL_LE_EN				BIT(7)
> +#define CIO2_PBM_ARB_CTRL_PLL_POST_SHTDN		2
> +#define CIO2_PBM_ARB_CTRL_PLL_POST_SHTDN_SHIFT		8
> +#define CIO2_PBM_ARB_CTRL_PLL_AHD_WK_UP			480
> +#define CIO2_PBM_ARB_CTRL_PLL_AHD_WK_UP_SHIFT		16
> +#define CIO2_REG_PBM_WMCTRL1				0x1464
> +#define CIO2_PBM_WMCTRL1_MIN_2CK_SHIFT			0
> +#define CIO2_PBM_WMCTRL1_MID1_2CK_SHIFT			8
> +#define CIO2_PBM_WMCTRL1_MID2_2CK_SHIFT			16
> +#define CIO2_PBM_WMCTRL1_TS_COUNT_DISABLE		BIT(31)
> +#define CIO2_PBM_WMCTRL1_MIN_2CK	(4 << CIO2_PBM_WMCTRL1_MIN_2CK_SHIFT)
> +#define CIO2_PBM_WMCTRL1_MID1_2CK	(16 << CIO2_PBM_WMCTRL1_MID1_2CK_SHIFT)
> +#define CIO2_PBM_WMCTRL1_MID2_2CK	(21 << CIO2_PBM_WMCTRL1_MID2_2CK_SHIFT)
> +#define CIO2_REG_PBM_WMCTRL2				0x1468
> +#define CIO2_PBM_WMCTRL2_HWM_2CK			40
> +#define CIO2_PBM_WMCTRL2_HWM_2CK_SHIFT			0
> +#define CIO2_PBM_WMCTRL2_LWM_2CK			22
> +#define CIO2_PBM_WMCTRL2_LWM_2CK_SHIFT			8
> +#define CIO2_PBM_WMCTRL2_OBFFWM_2CK			2
> +#define CIO2_PBM_WMCTRL2_OBFFWM_2CK_SHIFT		16
> +#define CIO2_PBM_WMCTRL2_TRANSDYN			1
> +#define CIO2_PBM_WMCTRL2_TRANSDYN_SHIFT			24
> +#define CIO2_PBM_WMCTRL2_DYNWMEN			BIT(28)
> +#define CIO2_PBM_WMCTRL2_OBFF_MEM_EN			BIT(29)
> +#define CIO2_PBM_WMCTRL2_OBFF_CPU_EN			BIT(30)
> +#define CIO2_PBM_WMCTRL2_DRAINNOW			BIT(31)
> +#define CIO2_REG_PBM_TS_COUNT				0x146c
> +#define CIO2_REG_PBM_FOPN_ABORT				0x1474
> +/* below n = 0..3 */
> +#define CIO2_PBM_FOPN_ABORT(n)				(0x1 << 8*(n))
> +#define CIO2_PBM_FOPN_FORCE_ABORT(n)			(0x2 << 8*(n))
> +#define CIO2_PBM_FOPN_FRAMEOPEN(n)			(0x8 << 8*(n))
> +#define CIO2_REG_LTRCTRL				0x1480
> +#define CIO2_LTRCTRL_LTRDYNEN				BIT(16)
> +#define CIO2_LTRCTRL_LTRSTABLETIME_SHIFT		8
> +#define CIO2_LTRCTRL_LTRSTABLETIME_MASK			0xff
> +#define CIO2_LTRCTRL_LTRSEL1S3				BIT(7)
> +#define CIO2_LTRCTRL_LTRSEL1S2				BIT(6)
> +#define CIO2_LTRCTRL_LTRSEL1S1				BIT(5)
> +#define CIO2_LTRCTRL_LTRSEL1S0				BIT(4)
> +#define CIO2_LTRCTRL_LTRSEL2S3				BIT(3)
> +#define CIO2_LTRCTRL_LTRSEL2S2				BIT(2)
> +#define CIO2_LTRCTRL_LTRSEL2S1				BIT(1)
> +#define CIO2_LTRCTRL_LTRSEL2S0				BIT(0)
> +#define CIO2_REG_LTRVAL23				0x1484
> +#define CIO2_REG_LTRVAL01				0x1488
> +#define CIO2_LTRVAL02_VAL_SHIFT				0
> +#define CIO2_LTRVAL02_SCALE_SHIFT			10
> +#define CIO2_LTRVAL13_VAL_SHIFT				16
> +#define CIO2_LTRVAL13_SCALE_SHIFT			26
> +
> +#define CIO2_LTRVAL0_VAL				175
> +/* Value times 1024 ns */
> +#define CIO2_LTRVAL0_SCALE				2
> +#define CIO2_LTRVAL1_VAL				90
> +#define CIO2_LTRVAL1_SCALE				2
> +#define CIO2_LTRVAL2_VAL				90
> +#define CIO2_LTRVAL2_SCALE				2
> +#define CIO2_LTRVAL3_VAL				90
> +#define CIO2_LTRVAL3_SCALE				2
> +
> +#define CIO2_REG_CDMABA(n)		(0x1500 + 0x10*(n))	/* n = 0..19 */
> +#define CIO2_REG_CDMARI(n)		(0x1504 + 0x10*(n))
> +#define CIO2_CDMARI_FBPT_RP_SHIFT			0
> +#define CIO2_CDMARI_FBPT_RP_MASK			0xff
> +#define CIO2_REG_CDMAC0(n)		(0x1508 + 0x10*(n))
> +#define CIO2_CDMAC0_FBPT_LEN_SHIFT			0
> +#define CIO2_CDMAC0_FBPT_WIDTH_SHIFT			8
> +#define CIO2_CDMAC0_FBPT_NS				BIT(25)
> +#define CIO2_CDMAC0_DMA_INTR_ON_FS			BIT(26)
> +#define CIO2_CDMAC0_DMA_INTR_ON_FE			BIT(27)
> +#define CIO2_CDMAC0_FBPT_UPDATE_FIFO_FULL		BIT(28)
> +#define CIO2_CDMAC0_FBPT_FIFO_FULL_FIX_DIS		BIT(29)
> +#define CIO2_CDMAC0_DMA_EN				BIT(30)
> +#define CIO2_CDMAC0_DMA_HALTED				BIT(31)
> +#define CIO2_REG_CDMAC1(n)		(0x150c + 0x10*(n))
> +#define CIO2_CDMAC1_LINENUMINT_SHIFT			0
> +#define CIO2_CDMAC1_LINENUMUPDATE_SHIFT			16
> +/* n = 0..3 */
> +#define CIO2_REG_PXM_PXF_FMT_CFG0(n)	(0x1700 + 0x30*(n))
> +#define CIO2_PXM_PXF_FMT_CFG_SID0_SHIFT			0
> +#define CIO2_PXM_PXF_FMT_CFG_SID1_SHIFT			16
> +#define CIO2_PXM_PXF_FMT_CFG_PCK_64B			(0 << 0)
> +#define CIO2_PXM_PXF_FMT_CFG_PCK_32B			(1 << 0)
> +#define CIO2_PXM_PXF_FMT_CFG_BPP_08			(0 << 2)
> +#define CIO2_PXM_PXF_FMT_CFG_BPP_10			(1 << 2)
> +#define CIO2_PXM_PXF_FMT_CFG_BPP_12			(2 << 2)
> +#define CIO2_PXM_PXF_FMT_CFG_BPP_14			(3 << 2)
> +#define CIO2_PXM_PXF_FMT_CFG_SPEC_4PPC			(0 << 4)
> +#define CIO2_PXM_PXF_FMT_CFG_SPEC_3PPC_RGBA		(1 << 4)
> +#define CIO2_PXM_PXF_FMT_CFG_SPEC_3PPC_ARGB		(2 << 4)
> +#define CIO2_PXM_PXF_FMT_CFG_SPEC_PLANAR2		(3 << 4)
> +#define CIO2_PXM_PXF_FMT_CFG_SPEC_PLANAR3		(4 << 4)
> +#define CIO2_PXM_PXF_FMT_CFG_SPEC_NV16			(5 << 4)
> +#define CIO2_PXM_PXF_FMT_CFG_PSWAP4_1ST_AB		(1 << 7)
> +#define CIO2_PXM_PXF_FMT_CFG_PSWAP4_1ST_CD		(1 << 8)
> +#define CIO2_PXM_PXF_FMT_CFG_PSWAP4_2ND_AC		(1 << 9)
> +#define CIO2_PXM_PXF_FMT_CFG_PSWAP4_2ND_BD		(1 << 10)
> +#define CIO2_REG_INT_STS_EXT_IE				0x17e4
> +#define CIO2_REG_INT_EN_EXT_IE				0x17e8
> +#define CIO2_INT_EXT_IE_ECC_RE(n)			(0x01 << (8 * (n)))
> +#define CIO2_INT_EXT_IE_DPHY_NR(n)			(0x02 << (8 * (n)))
> +#define CIO2_INT_EXT_IE_ECC_NR(n)			(0x04 << (8 * (n)))
> +#define CIO2_INT_EXT_IE_CRCERR(n)			(0x08 << (8 * (n)))
> +#define CIO2_INT_EXT_IE_INTERFRAMEDATA(n)		(0x10 << (8 * (n)))
> +#define CIO2_INT_EXT_IE_PKT2SHORT(n)			(0x20 << (8 * (n)))
> +#define CIO2_INT_EXT_IE_PKT2LONG(n)			(0x40 << (8 * (n)))
> +#define CIO2_INT_EXT_IE_IRQ(n)				(0x80 << (8 * (n)))
> +#define CIO2_REG_PXM_FRF_CFG(n)				(0x1720 + 0x30*(n))
> +#define CIO2_PXM_FRF_CFG_FNSEL				BIT(0)
> +#define CIO2_PXM_FRF_CFG_FN_RST				BIT(1)
> +#define CIO2_PXM_FRF_CFG_ABORT				BIT(2)
> +#define CIO2_PXM_FRF_CFG_CRC_TH_SHIFT			3
> +#define CIO2_PXM_FRF_CFG_MSK_ECC_DPHY_NR		BIT(8)
> +#define CIO2_PXM_FRF_CFG_MSK_ECC_RE			BIT(9)
> +#define CIO2_PXM_FRF_CFG_MSK_ECC_DPHY_NE		BIT(10)
> +#define CIO2_PXM_FRF_CFG_EVEN_ODD_MODE_SHIFT		11
> +#define CIO2_PXM_FRF_CFG_MASK_CRC_THRES			BIT(13)
> +#define CIO2_PXM_FRF_CFG_MASK_CSI_ACCEPT		BIT(14)
> +#define CIO2_PXM_FRF_CFG_CIOHC_FS_MODE			BIT(15)
> +#define CIO2_PXM_FRF_CFG_CIOHC_FRST_FRM_SHIFT		16
> +#define CIO2_REG_PXM_SID2BID0(n)			(0x1724 + 0x30*(n))
> +#define CIO2_FB_HPLL_FREQ				0x2
> +#define CIO2_ISCLK_RATIO				0xc
> +
> +#define CIO2_IRQCTRL_MASK				0x3ffff
> +
> +#define CIO2_INT_EN_EXT_OE_MASK				0x8f0fffff
> +
> +#define CIO2_CGC_CLKGATE_HOLDOFF			3
> +#define CIO2_CGC_CSI_CLKGATE_HOLDOFF			5
> +
> +#define CIO2_PXM_FRF_CFG_CRC_TH				16
> +
> +#define CIO2_INT_EN_EXT_IE_MASK				0xffffffff
> +
> +#define CIO2_DMA_CHAN					0
> +
> +#define CIO2_CSIRX_DLY_CNT_CLANE_IDX			-1
> +
> +#define CIO2_CSIRX_DLY_CNT_TERMEN_CLANE_A		0
> +#define CIO2_CSIRX_DLY_CNT_TERMEN_CLANE_B		0
> +#define CIO2_CSIRX_DLY_CNT_SETTLE_CLANE_A		95
> +#define CIO2_CSIRX_DLY_CNT_SETTLE_CLANE_B		-8
> +
> +#define CIO2_CSIRX_DLY_CNT_TERMEN_DLANE_A		0
> +#define CIO2_CSIRX_DLY_CNT_TERMEN_DLANE_B		0
> +#define CIO2_CSIRX_DLY_CNT_SETTLE_DLANE_A		85
> +#define CIO2_CSIRX_DLY_CNT_SETTLE_DLANE_B		-2
> +
> +#define CIO2_CSIRX_DLY_CNT_TERMEN_DEFAULT		0x4
> +#define CIO2_CSIRX_DLY_CNT_SETTLE_DEFAULT		0x570
> +
> +#define CIO2_PMCSR_OFFSET				4
> +#define CIO2_PMCSR_D0D3_SHIFT				2
> +#define CIO2_PMCSR_D3					0x3
> +
> +struct cio2_csi2_timing {
> +	s32 clk_termen;
> +	s32 clk_settle;
> +	s32 dat_termen;
> +	s32 dat_settle;
> +};
> +
> +struct cio2_buffer {
> +	struct vb2_v4l2_buffer vbb;
> +	u32 *lop[CIO2_MAX_LOPS];
> +	dma_addr_t lop_bus_addr[CIO2_MAX_LOPS];
> +	unsigned int offset;
> +};
> +
> +struct csi2_bus_info {
> +	u32 port;
> +	u32 lanes;
> +};
> +
> +struct cio2_queue {
> +	/* mutex to be used by vb2_queue */
> +	struct mutex lock;
> +	struct media_pipeline pipe;
> +	struct csi2_bus_info csi2;
> +	struct v4l2_subdev *sensor;
> +	void __iomem *csi_rx_base;
> +
> +	/* Subdev, /dev/v4l-subdevX */
> +	struct v4l2_subdev subdev;
> +	struct media_pad subdev_pads[CIO2_PADS];
> +	struct v4l2_mbus_framefmt subdev_fmt;
> +	atomic_t frame_sequence;
> +
> +	/* Video device, /dev/videoX */
> +	struct video_device vdev;
> +	struct media_pad vdev_pad;
> +	struct v4l2_pix_format_mplane format;
> +	struct vb2_queue vbq;
> +
> +	/* Buffer queue handling */
> +	struct cio2_fbpt_entry *fbpt;	/* Frame buffer pointer table */
> +	dma_addr_t fbpt_bus_addr;
> +	struct cio2_buffer *bufs[CIO2_MAX_BUFFERS];
> +	unsigned int bufs_first;	/* Index of the first used entry */
> +	unsigned int bufs_next;	/* Index of the first unused entry */
> +	atomic_t bufs_queued;
> +};
> +
> +struct cio2_device {
> +	struct pci_dev *pci_dev;
> +	void __iomem *base;
> +	struct v4l2_device v4l2_dev;
> +	struct cio2_queue queue[CIO2_QUEUES];
> +	struct cio2_queue *cur_queue;
> +	/* mutex to be used by video_device */
> +	struct mutex lock;
> +
> +	bool streaming;
> +	struct v4l2_async_notifier notifier;
> +	struct media_device media_dev;
> +
> +	/*
> +	 * Safety net to catch DMA fetch ahead
> +	 * when reaching the end of LOP
> +	 */
> +	void *dummy_page;
> +	/* DMA handle of dummy_page */
> +	dma_addr_t dummy_page_bus_addr;
> +	/* single List of Pointers (LOP) page */
> +	u32 *dummy_lop;
> +	/* DMA handle of dummy_lop */
> +	dma_addr_t dummy_lop_bus_addr;
> +};
> +
> +/**************** Virtual channel ****************/
> +/*
> + * This should come from sensor driver. No
> + * driver interface nor requirement yet.
> + */
> +#define SENSOR_VIR_CH_DFLT		0
> +
> +/**************** FBPT operations ****************/
> +#define CIO2_FBPT_SIZE			(CIO2_MAX_BUFFERS * CIO2_MAX_LOPS * \
> +					 sizeof(struct cio2_fbpt_entry))
> +
> +#define CIO2_FBPT_SUBENTRY_UNIT		4
> +#define CIO2_PAGE_SIZE			PAGE_SIZE
> +
> +/* cio2 fbpt first_entry ctrl status */
> +#define CIO2_FBPT_CTRL_VALID		BIT(0)
> +#define CIO2_FBPT_CTRL_IOC		BIT(1)
> +#define CIO2_FBPT_CTRL_IOS		BIT(2)
> +#define CIO2_FBPT_CTRL_SUCCXFAIL	BIT(3)
> +#define CIO2_FBPT_CTRL_CMPLCODE_SHIFT	4
> +
> +/*
> + * Frame Buffer Pointer Table(FBPT) entry
> + * each entry describe an output buffer and consists of
> + * several sub-entries
> + */
> +struct __packed cio2_fbpt_entry {
> +	union {
> +		struct __packed {
> +			u32 ctrl; /* status ctrl */
> +			u16 cur_line_num; /* current line # written to DDR */
> +			u16 frame_num; /* updated by DMA upon FE */
> +			u32 first_page_offset; /* offset for 1st page in LOP */
> +		} first_entry;
> +		/* Second entry per buffer */
> +		struct __packed {
> +			u32 timestamp;
> +			u32 num_of_bytes;
> +			/* the number of bytes for write on last page */
> +			u16 last_page_available_bytes;
> +			/* the number of pages allocated for this buf */
> +			u16 num_of_pages;
> +		} second_entry;
> +		struct __packed {
> +			u64 __reserved1;
> +			u32 __reserved0;
> +		} other_entries;

other_entries isn't used anywhere nor if affects the union size. How about
removing it? Or replacing the struct with an u32 array of 3?

> +	};
> +	u32 lop_page_addr;	/* Points to list of pointers (LOP) table */
> +};
> +
> +static inline struct cio2_queue *file_to_cio2_queue(struct file *file)
> +{
> +	return container_of(video_devdata(file), struct cio2_queue, vdev);
> +}
> +
> +static inline struct cio2_queue *vb2q_to_cio2_queue(struct vb2_queue *vq)
> +{
> +	return container_of(vq, struct cio2_queue, vbq);
> +}
> +
> +#endif

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
