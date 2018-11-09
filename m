Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:44429 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727676AbeKIWe5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Nov 2018 17:34:57 -0500
Date: Fri, 9 Nov 2018 14:54:21 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Yong Zhi <yong.zhi@intel.com>
Cc: linux-media@vger.kernel.org, tfiga@chromium.org,
        mchehab@kernel.org, hans.verkuil@cisco.com,
        laurent.pinchart@ideasonboard.com, rajmohan.mani@intel.com,
        jian.xu.zheng@intel.com, jerry.w.hu@intel.com,
        tuukka.toivonen@intel.com, tian.shu.qiu@intel.com,
        bingbu.cao@intel.com
Subject: Re: [PATCH v7 15/16] intel-ipu3: Add imgu top level pci device driver
Message-ID: <20181109125421.nepjtykhke76gwfa@paasikivi.fi.intel.com>
References: <1540851790-1777-1-git-send-email-yong.zhi@intel.com>
 <1540851790-1777-16-git-send-email-yong.zhi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1540851790-1777-16-git-send-email-yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Yong,

On Mon, Oct 29, 2018 at 03:23:09PM -0700, Yong Zhi wrote:
> This patch adds support for the Intel IPU v3 as found
> on Skylake and Kaby Lake SoCs.
> 
> The driver glues v4l2, css(camera sub system) and other
> pieces together to perform its functions, it also loads
> the IPU3 firmware binary as part of its initialization.
> 
> Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> Signed-off-by: Tomasz Figa <tfiga@chromium.org>
> ---
>  drivers/media/pci/intel/ipu3/Kconfig  |  16 +
>  drivers/media/pci/intel/ipu3/Makefile |  12 +
>  drivers/media/pci/intel/ipu3/ipu3.c   | 844 ++++++++++++++++++++++++++++++++++
>  drivers/media/pci/intel/ipu3/ipu3.h   | 153 ++++++
>  4 files changed, 1025 insertions(+)
>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3.c
>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3.h
> 
> diff --git a/drivers/media/pci/intel/ipu3/Kconfig b/drivers/media/pci/intel/ipu3/Kconfig
> index 715f776..44ebcbb 100644
> --- a/drivers/media/pci/intel/ipu3/Kconfig
> +++ b/drivers/media/pci/intel/ipu3/Kconfig
> @@ -15,3 +15,19 @@ config VIDEO_IPU3_CIO2
>  	  Say Y or M here if you have a Skylake/Kaby Lake SoC with MIPI CSI-2
>  	  connected camera.
>  	  The module will be called ipu3-cio2.
> +
> +config VIDEO_IPU3_IMGU
> +	tristate "Intel ipu3-imgu driver"
> +	depends on PCI && VIDEO_V4L2
> +	depends on MEDIA_CONTROLLER && VIDEO_V4L2_SUBDEV_API
> +	depends on X86
> +	select IOMMU_IOVA
> +	select VIDEOBUF2_DMA_SG
> +

Extra newline.

> +	---help---
> +	  This is the video4linux2 driver for Intel IPU3 image processing unit,

"Video4Linux2"

> +	  found in Intel Skylake and Kaby Lake SoCs and used for processing
> +	  images and video.
> +
> +	  Say Y or M here if you have a Skylake/Kaby Lake SoC with a MIPI
> +	  camera.	The module will be called ipu3-imgu.

The latter tab should be a space only.

> diff --git a/drivers/media/pci/intel/ipu3/Makefile b/drivers/media/pci/intel/ipu3/Makefile
> index 20186e3..60bd5db 100644
> --- a/drivers/media/pci/intel/ipu3/Makefile
> +++ b/drivers/media/pci/intel/ipu3/Makefile
> @@ -1 +1,13 @@
> +#
> +# Makefile for the IPU3 cio2 and ImgU drivers
> +#
> +
>  obj-$(CONFIG_VIDEO_IPU3_CIO2) += ipu3-cio2.o
> +
> +ipu3-imgu-objs += \
> +		ipu3-mmu.o ipu3-dmamap.o \
> +		ipu3-tables.o ipu3-css-pool.o \
> +		ipu3-css-fw.o ipu3-css-params.o \
> +		ipu3-css.o ipu3-v4l2.o ipu3.o
> +
> +obj-$(CONFIG_VIDEO_IPU3_IMGU) += ipu3-imgu.o
> diff --git a/drivers/media/pci/intel/ipu3/ipu3.c b/drivers/media/pci/intel/ipu3/ipu3.c
> new file mode 100644
> index 0000000..eda7299
> --- /dev/null
> +++ b/drivers/media/pci/intel/ipu3/ipu3.c
> @@ -0,0 +1,844 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2017 Intel Corporation
> + * Copyright 2017 Google LLC
> + *
> + * Based on Intel IPU4 driver.
> + *
> + */
> +
> +#include <linux/delay.h>
> +#include <linux/interrupt.h>
> +#include <linux/module.h>
> +#include <linux/pm_runtime.h>
> +
> +#include "ipu3.h"
> +#include "ipu3-dmamap.h"
> +#include "ipu3-mmu.h"
> +
> +#define IMGU_PCI_ID			0x1919
> +#define IMGU_PCI_BAR			0
> +#define IMGU_DMA_MASK			DMA_BIT_MASK(39)
> +#define IMGU_MAX_QUEUE_DEPTH		(2 + 2)
> +
> +/*
> + * pre-allocated buffer size for IMGU dummy buffers. Those
> + * values should be tuned to big enough to avoid buffer
> + * re-allocation when streaming to lower streaming latency.
> + */
> +#define CSS_QUEUE_IN_BUF_SIZE		0
> +#define CSS_QUEUE_PARAMS_BUF_SIZE	0
> +#define CSS_QUEUE_OUT_BUF_SIZE		(4160 * 3120 * 12 / 8)
> +#define CSS_QUEUE_VF_BUF_SIZE		(1920 * 1080 * 12 / 8)
> +#define CSS_QUEUE_STAT_3A_BUF_SIZE	125664

Could you use sizeof(struct ipu3_uapi_stats_3a) instead?

That said, it might not be a bad idea to add a sanity check on the size:

	BUILD_BUG_ON(sizeof(struct ipu3_uapi_stats_3a) !=
		     CSS_QUEUE_STAT_3A_BUF_SIZE);

...

> diff --git a/drivers/media/pci/intel/ipu3/ipu3.h b/drivers/media/pci/intel/ipu3/ipu3.h
> new file mode 100644
> index 0000000..5c2b420
> --- /dev/null
> +++ b/drivers/media/pci/intel/ipu3/ipu3.h
> @@ -0,0 +1,153 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright (C) 2018 Intel Corporation */
> +
> +#ifndef __IPU3_H
> +#define __IPU3_H
> +
> +#include <linux/iova.h>
> +#include <linux/pci.h>
> +
> +#include <media/v4l2-device.h>
> +#include <media/videobuf2-dma-sg.h>
> +
> +#include "ipu3-css.h"
> +
> +#define IMGU_NAME			"ipu3-imgu"
> +
> +/*
> + * The semantics of the driver is that whenever there is a buffer available in
> + * master queue, the driver queues a buffer also to all other active nodes.
> + * If user space hasn't provided a buffer to all other video nodes first,
> + * the driver gets an internal dummy buffer and queues it.
> + */
> +#define IMGU_QUEUE_MASTER		IPU3_CSS_QUEUE_IN
> +#define IMGU_QUEUE_FIRST_INPUT		IPU3_CSS_QUEUE_OUT
> +#define IMGU_MAX_QUEUE_DEPTH		(2 + 2)
> +
> +#define IMGU_NODE_IN			0 /* Input RAW image */
> +#define IMGU_NODE_PARAMS		1 /* Input parameters */
> +#define IMGU_NODE_OUT			2 /* Main output for still or video */
> +#define IMGU_NODE_VF			3 /* Preview */
> +#define IMGU_NODE_PV			4 /* Postview for still capture */
> +#define IMGU_NODE_STAT_3A		5 /* 3A statistics */
> +#define IMGU_NODE_NUM			6
> +
> +#define file_to_intel_ipu3_node(__file) \
> +	container_of(video_devdata(__file), struct imgu_video_device, vdev)
> +
> +#define IPU3_INPUT_MIN_WIDTH		0U
> +#define IPU3_INPUT_MIN_HEIGHT		0U
> +#define IPU3_INPUT_MAX_WIDTH		5120U
> +#define IPU3_INPUT_MAX_HEIGHT		38404U
> +#define IPU3_OUTPUT_MIN_WIDTH		2U
> +#define IPU3_OUTPUT_MIN_HEIGHT		2U
> +#define IPU3_OUTPUT_MAX_WIDTH		4480U
> +#define IPU3_OUTPUT_MAX_HEIGHT		34004U
> +
> +struct ipu3_vb2_buffer {
> +	/* Public fields */
> +	struct vb2_v4l2_buffer vbb;	/* Must be the first field */
> +
> +	/* Private fields */
> +	struct list_head list;
> +};
> +
> +struct imgu_buffer {
> +	struct ipu3_vb2_buffer vid_buf;	/* Must be the first field */
> +	struct ipu3_css_buffer css_buf;
> +	struct ipu3_css_map map;
> +};
> +
> +struct imgu_node_mapping {
> +	unsigned int css_queue;
> +	const char *name;
> +};
> +
> +/**
> + * struct imgu_video_device
> + * each node registers as video device and maintains its
> + * own vb2_queue.
> + */
> +struct imgu_video_device {
> +	const char *name;
> +	bool output;		/* Frames to the driver? */
> +	bool immutable;		/* Can not be enabled/disabled */
> +	bool enabled;
> +	int queued;		/* Buffers already queued */

The queued field is unused.

> +	struct v4l2_format vdev_fmt;	/* Currently set format */
> +
> +	/* Private fields */
> +	struct video_device vdev;
> +	struct media_pad vdev_pad;
> +	struct v4l2_mbus_framefmt pad_fmt;
> +	struct vb2_queue vbq;
> +	struct list_head buffers;
> +	/* Protect vb2_queue and vdev structs*/
> +	struct mutex lock;
> +	atomic_t sequence;
> +};
> +

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
