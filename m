Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:2277 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525Ab3JCGnu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Oct 2013 02:43:50 -0400
Message-ID: <524D1144.5040904@xs4all.nl>
Date: Thu, 03 Oct 2013 08:40:04 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: devel@driverdev.osuosl.org, linux-media@vger.kernel.org,
	Sergio Aguirre <sergio.a.aguirre@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH 1/6] v4l: omap4iss: Add support for OMAP4 camera interface
 - Core
References: <1380758133-16866-1-git-send-email-laurent.pinchart@ideasonboard.com> <1380758133-16866-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1380758133-16866-2-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A few small comments below...

On 10/03/2013 01:55 AM, Laurent Pinchart wrote:
> From: Sergio Aguirre <sergio.a.aguirre@gmail.com>
> 
> This adds a very simplistic driver to utilize the CSI2A interface inside
> the ISS subsystem in OMAP4, and dump the data to memory.
> 
> Check Documentation/video4linux/omap4_camera.txt for details.
> 
> This commit adds the driver core, registers definitions and
> documentation.
> 
> Signed-off-by: Sergio Aguirre <sergio.a.aguirre@gmail.com>
> 
> [Port the driver to v3.12-rc3, including the following changes
> - Don't include plat/ headers
> - Don't use cpu_is_omap44xx() macro
> - Don't depend on EXPERIMENTAL
> - Fix s_crop operation prototype
> - Update link_notify prototype
> - Rename media_entity_remote_source to media_entity_remote_pad]
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  Documentation/video4linux/omap4_camera.txt |   63 ++
>  drivers/staging/media/omap4iss/iss.c       | 1477 ++++++++++++++++++++++++++++
>  drivers/staging/media/omap4iss/iss.h       |  153 +++
>  drivers/staging/media/omap4iss/iss_regs.h  |  883 +++++++++++++++++
>  include/media/omap4iss.h                   |   65 ++
>  5 files changed, 2641 insertions(+)
>  create mode 100644 Documentation/video4linux/omap4_camera.txt
>  create mode 100644 drivers/staging/media/omap4iss/iss.c
>  create mode 100644 drivers/staging/media/omap4iss/iss.h
>  create mode 100644 drivers/staging/media/omap4iss/iss_regs.h
>  create mode 100644 include/media/omap4iss.h
> 
> diff --git a/Documentation/video4linux/omap4_camera.txt b/Documentation/video4linux/omap4_camera.txt
> new file mode 100644
> index 0000000..2ebbd1d
> --- /dev/null
> +++ b/Documentation/video4linux/omap4_camera.txt
> @@ -0,0 +1,63 @@
> +                              OMAP4 ISS Driver
> +                              ================
> +
> +Introduction
> +------------
> +
> +The OMAP44XX family of chips contains the Imaging SubSystem (a.k.a. ISS),
> +Which contains several components that can be categorized in 3 big groups:
> +
> +- Interfaces (2 Interfaces: CSI2-A & CSI2-B/CCP2)
> +- ISP (Image Signal Processor)
> +- SIMCOP (Still Image Coprocessor)
> +
> +For more information, please look in [1] for latest version of:
> +	"OMAP4430 Multimedia Device Silicon Revision 2.x"
> +
> +As of Revision AB, the ISS is described in detail in section 8.
> +
> +This driver is supporting _only_ the CSI2-A/B interfaces for now.
> +
> +It makes use of the Media Controller framework [2], and inherited most of the
> +code from OMAP3 ISP driver (found under drivers/media/video/omap3isp/*), except

Update the omap3isp path.

> +that it doesn't need an IOMMU now for ISS buffers memory mapping.
> +
> +Supports usage of MMAP buffers only (for now).
> +
> +IMPORTANT: It is recommended to have this patchset:
> +  Contiguous Memory Allocator (v22) [3].

This note can be removed as CMA has been merged.

> +
> +Tested platforms
> +----------------
> +
> +- OMAP4430SDP, w/ ES2.1 GP & SEVM4430-CAM-V1-0 (Contains IMX060 & OV5640, in
> +  which only the last one is supported, outputting YUV422 frames).
> +
> +- TI Blaze MDP, w/ OMAP4430 ES2.2 EMU (Contains 1 IMX060 & 2 OV5650 sensors, in
> +  which only the OV5650 are supported, outputting RAW10 frames).
> +
> +- PandaBoard, Rev. A2, w/ OMAP4430 ES2.1 GP & OV adapter board, tested with
> +  following sensors:
> +  * OV5640
> +  * OV5650
> +
> +- Tested on mainline kernel:
> +
> +	http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=summary
> +
> +  Tag: v3.3 (commit c16fa4f2ad19908a47c63d8fa436a1178438c7e7)
> +
> +File list
> +---------
> +drivers/media/video/omap4iss/

Wrong path.

> +include/media/omap4iss.h
> +
> +References
> +----------
> +
> +[1] http://focus.ti.com/general/docs/wtbu/wtbudocumentcenter.tsp?navigationId=12037&templateId=6123#62
> +[2] http://lwn.net/Articles/420485/
> +[3] http://www.spinics.net/lists/linux-media/msg44370.html
> +--
> +Author: Sergio Aguirre <sergio.a.aguirre@gmail.com>
> +Copyright (C) 2012, Texas Instruments
> diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
> new file mode 100644
> index 0000000..d054d9b
> --- /dev/null
> +++ b/drivers/staging/media/omap4iss/iss.c
> @@ -0,0 +1,1477 @@
> +/*
> + * TI OMAP4 ISS V4L2 Driver
> + *
> + * Copyright (C) 2012, Texas Instruments
> + *
> + * Author: Sergio Aguirre <sergio.a.aguirre@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/delay.h>
> +#include <linux/device.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/i2c.h>
> +#include <linux/interrupt.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <linux/sched.h>
> +#include <linux/vmalloc.h>
> +
> +#include <media/v4l2-common.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-ctrls.h>
> +
> +#include "iss.h"
> +#include "iss_regs.h"
> +
> +#define ISS_PRINT_REGISTER(iss, name)\
> +	dev_dbg(iss->dev, "###ISS " #name "=0x%08x\n", \
> +		readl(iss->regs[OMAP4_ISS_MEM_TOP] + ISS_##name))
> +
> +static void iss_print_status(struct iss_device *iss)
> +{
> +	dev_dbg(iss->dev, "-------------ISS HL Register dump-------------\n");
> +
> +	ISS_PRINT_REGISTER(iss, HL_REVISION);
> +	ISS_PRINT_REGISTER(iss, HL_SYSCONFIG);
> +	ISS_PRINT_REGISTER(iss, HL_IRQSTATUS_5);
> +	ISS_PRINT_REGISTER(iss, HL_IRQENABLE_5_SET);
> +	ISS_PRINT_REGISTER(iss, HL_IRQENABLE_5_CLR);
> +	ISS_PRINT_REGISTER(iss, CTRL);
> +	ISS_PRINT_REGISTER(iss, CLKCTRL);
> +	ISS_PRINT_REGISTER(iss, CLKSTAT);
> +
> +	dev_dbg(iss->dev, "-----------------------------------------------\n");
> +}
> +
> +/*
> + * omap4iss_flush - Post pending L3 bus writes by doing a register readback
> + * @iss: OMAP4 ISS device
> + *
> + * In order to force posting of pending writes, we need to write and
> + * readback the same register, in this case the revision register.
> + *
> + * See this link for reference:
> + *   http://www.mail-archive.com/linux-omap@vger.kernel.org/msg08149.html
> + */
> +void omap4iss_flush(struct iss_device *iss)
> +{
> +	writel(0, iss->regs[OMAP4_ISS_MEM_TOP] + ISS_HL_REVISION);
> +	readl(iss->regs[OMAP4_ISS_MEM_TOP] + ISS_HL_REVISION);
> +}
> +
> +/*
> + * iss_enable_interrupts - Enable ISS interrupts.
> + * @iss: OMAP4 ISS device
> + */
> +static void iss_enable_interrupts(struct iss_device *iss)
> +{
> +	static const u32 hl_irq = ISS_HL_IRQ_CSIA | ISS_HL_IRQ_CSIB | ISS_HL_IRQ_ISP(0);
> +
> +	/* Enable HL interrupts */
> +	writel(hl_irq, iss->regs[OMAP4_ISS_MEM_TOP] + ISS_HL_IRQSTATUS_5);
> +	writel(hl_irq, iss->regs[OMAP4_ISS_MEM_TOP] + ISS_HL_IRQENABLE_5_SET);
> +
> +}
> +
> +/*
> + * iss_disable_interrupts - Disable ISS interrupts.
> + * @iss: OMAP4 ISS device
> + */
> +static void iss_disable_interrupts(struct iss_device *iss)
> +{
> +	writel(-1, iss->regs[OMAP4_ISS_MEM_TOP] + ISS_HL_IRQENABLE_5_CLR);
> +}
> +
> +/*
> + * iss_isp_enable_interrupts - Enable ISS ISP interrupts.
> + * @iss: OMAP4 ISS device
> + */
> +void omap4iss_isp_enable_interrupts(struct iss_device *iss)
> +{
> +	static const u32 isp_irq = ISP5_IRQ_OCP_ERR |
> +				   ISP5_IRQ_RSZ_FIFO_IN_BLK |
> +				   ISP5_IRQ_RSZ_FIFO_OVF |
> +				   ISP5_IRQ_RSZ_INT_DMA |
> +				   ISP5_IRQ_ISIF0;
> +
> +	/* Enable ISP interrupts */
> +	writel(isp_irq, iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_IRQSTATUS(0));
> +	writel(isp_irq, iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_IRQENABLE_SET(0));
> +}
> +
> +/*
> + * iss_isp_disable_interrupts - Disable ISS interrupts.
> + * @iss: OMAP4 ISS device
> + */
> +void omap4iss_isp_disable_interrupts(struct iss_device *iss)
> +{
> +	writel(-1, iss->regs[OMAP4_ISS_MEM_ISP_SYS1] + ISP5_IRQENABLE_CLR(0));
> +}
> +
> +int omap4iss_get_external_info(struct iss_pipeline *pipe,
> +			       struct media_link *link)
> +{
> +	struct iss_device *iss =
> +		container_of(pipe, struct iss_video, pipe)->iss;
> +	struct v4l2_subdev_format fmt;
> +	struct v4l2_ext_controls ctrls;
> +	struct v4l2_ext_control ctrl;
> +	int ret;
> +
> +	if (!pipe->external)
> +		return 0;
> +
> +	if (pipe->external_rate)
> +		return 0;
> +
> +	memset(&fmt, 0, sizeof(fmt));
> +
> +	fmt.pad = link->source->index;
> +	fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> +	ret = v4l2_subdev_call(media_entity_to_v4l2_subdev(link->sink->entity),
> +			       pad, get_fmt, NULL, &fmt);
> +	if (ret < 0)
> +		return -EPIPE;
> +
> +	pipe->external_bpp = omap4iss_video_format_info(fmt.format.code)->bpp;
> +
> +	memset(&ctrls, 0, sizeof(ctrls));
> +	memset(&ctrl, 0, sizeof(ctrl));
> +
> +	ctrl.id = V4L2_CID_PIXEL_RATE;
> +
> +	ctrls.ctrl_class = V4L2_CTRL_ID2CLASS(ctrl.id);
> +	ctrls.count = 1;
> +	ctrls.controls = &ctrl;
> +
> +	ret = v4l2_g_ext_ctrls(pipe->external->ctrl_handler, &ctrls);

Instead of using v4l2_g_ext_ctrls use v4l2_ctrl_find + v4l2_ctrl_g_ctrl_int64.

> +	if (ret < 0) {
> +		dev_warn(iss->dev, "no pixel rate control in subdev %s\n",
> +			 pipe->external->name);
> +		return ret;
> +	}
> +
> +	pipe->external_rate = ctrl.value64;
> +
> +	return 0;
> +}

Regards,

	Hans
