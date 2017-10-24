Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:30633 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751216AbdJXA5L (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Oct 2017 20:57:11 -0400
From: "Zhi, Yong" <yong.zhi@intel.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        "arnd@arndb.de" <arnd@arndb.de>, "hch@lst.de" <hch@lst.de>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Tomasz Figa <tfiga@chromium.org>
Subject: RE: [PATCH v4 12/12] intel-ipu3: imgu top level pci device
Date: Tue, 24 Oct 2017 00:57:08 +0000
Message-ID: <C193D76D23A22742993887E6D207B54D1AE2C061@ORSMSX106.amr.corp.intel.com>
References: <1508298959-26148-1-git-send-email-yong.zhi@intel.com>
 <20171020111508.rqcuqer62xveqhty@valkosipuli.retiisi.org.uk>
In-Reply-To: <20171020111508.rqcuqer62xveqhty@valkosipuli.retiisi.org.uk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Sakari,

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Sakari Ailus
> Sent: Friday, October 20, 2017 4:15 AM
> To: Zhi, Yong <yong.zhi@intel.com>
> Cc: linux-media@vger.kernel.org; sakari.ailus@linux.intel.com; Zheng, Jian
> Xu <jian.xu.zheng@intel.com>; Mani, Rajmohan
> <rajmohan.mani@intel.com>; Toivonen, Tuukka
> <tuukka.toivonen@intel.com>; Hu, Jerry W <jerry.w.hu@intel.com>;
> arnd@arndb.de; hch@lst.de; robin.murphy@arm.com; iommu@lists.linux-
> foundation.org; Tomasz Figa <tfiga@chromium.org>
> Subject: Re: [PATCH v4 12/12] intel-ipu3: imgu top level pci device
> 
> On Tue, Oct 17, 2017 at 10:55:59PM -0500, Yong Zhi wrote:
> > This patch adds support for the Intel IPU v3 as found on Skylake and
> > Kaby Lake SoCs. The driver has a dependency on the firmware binary to
> > function properly.
> >
> > Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> > Signed-off-by: Tomasz Figa <tfiga@chromium.org>
> > ---
> >  drivers/media/pci/intel/ipu3/Kconfig  |  17 +
> >  drivers/media/pci/intel/ipu3/Makefile |   6 +
> >  drivers/media/pci/intel/ipu3/ipu3.c   | 882
> ++++++++++++++++++++++++++++++++++
> >  drivers/media/pci/intel/ipu3/ipu3.h   | 186 +++++++
> >  4 files changed, 1091 insertions(+)
> >  create mode 100644 drivers/media/pci/intel/ipu3/ipu3.c
> >  create mode 100644 drivers/media/pci/intel/ipu3/ipu3.h
> >
(snip)
> > +/*
> > + * imgu_mem2mem2_ops - used by v4l2 and vb2  */ static const struct
> > +ipu3_mem2mem2_ops imgu_mem2mem2_ops = {
> > +	.s_stream = imgu_mem2mem2_s_stream,
> 
> You have a single instance of this. How about just using
> imgu_mem2mem2_s_stream instead?
> 

Yes, we can remove another level of indirectness.

(snip)
> > +++ b/drivers/media/pci/intel/ipu3/ipu3.h
> > @@ -0,0 +1,186 @@
> > +/*
> > + * Copyright (c) 2017 Intel Corporation.
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License
> > +version
> > + * 2 as published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + */
> > +
> > +#ifndef __IPU3_H
> > +#define __IPU3_H
> > +
> > +#include <linux/iova.h>
> > +#include <linux/pci.h>
> > +#include <media/v4l2-device.h>
> > +#include <media/videobuf2-v4l2.h>
> > +#include "ipu3-css.h"
> > +
> > +/*
> > + * The semantics of the driver is that whenever there is a buffer
> > +available in
> > + * master queue, the driver queues a buffer also to all other active nodes.
> > + * If user space hasn't provided a buffer to all other video nodes
> > +first,
> > + * the driver gets an internal dummy buffer and queues it.
> > + */
> > +#define IMGU_QUEUE_MASTER		IPU3_CSS_QUEUE_IN
> > +#define IMGU_QUEUE_FIRST_INPUT		IPU3_CSS_QUEUE_OUT
> > +#define IMGU_MAX_QUEUE_DEPTH		(2 + 2)
> > +
> > +#define IMGU_NODE_IN			0 /* Input RAW image */
> > +#define IMGU_NODE_PARAMS		1 /* Input parameters */
> > +#define IMGU_NODE_OUT			2 /* Main output for still or
> video */
> > +#define IMGU_NODE_VF			3 /* Preview */
> > +#define IMGU_NODE_PV			4 /* Postview for still capture
> */
> > +#define IMGU_NODE_STAT_3A		5 /* 3A statistics */
> > +#define IMGU_NODE_STAT_DVS		6 /* DVS statistics */
> > +#define IMGU_NODE_STAT_LACE		7 /* Lace statistics */
> > +#define IMGU_NODE_NUM			8
> > +
> > +#define file_to_intel_ipu3_node(__file) \
> > +	container_of(video_devdata(__file), struct imgu_video_device, vdev)
> > +
> > +#define IPU3_INPUT_MIN_WIDTH		0U
> > +#define IPU3_INPUT_MIN_HEIGHT		0U
> > +#define IPU3_INPUT_MAX_WIDTH		5120U
> > +#define IPU3_INPUT_MAX_HEIGHT		38404U
> > +#define IPU3_OUTPUT_MIN_WIDTH		2U
> > +#define IPU3_OUTPUT_MIN_HEIGHT		2U
> > +#define IPU3_OUTPUT_MAX_WIDTH		4480U
> > +#define IPU3_OUTPUT_MAX_HEIGHT		34004U
> > +
> > +struct ipu3_mem2mem2_buffer {
> > +	/* Public fields */
> > +	struct vb2_v4l2_buffer vbb;	/* Must be the first field */
> > +
> > +	/* Private fields */
> > +	struct list_head list;
> > +};
> > +
> > +struct imgu_buffer {
> > +	struct ipu3_mem2mem2_buffer m2m2_buf;	/* Must be the first
> field */
> > +	struct ipu3_css_buffer css_buf;
> > +	struct ipu3_css_map map;
> > +};
> > +
> > +struct imgu_node_mapping {
> > +	int css_queue;
> > +	const char *name;
> > +};
> > +
> > +/**
> > + * struct imgu_video_device
> > + * each node registers as video device and maintains its
> > + * own vb2_queue.
> > + */
> > +struct imgu_video_device {
> > +	const char *name;
> > +	bool output;		/* Frames to the driver? */
> > +	bool immutable;		/* Can not be enabled/disabled */
> > +	bool enabled;
> > +	int queued;		/* Buffers already queued */
> > +	struct v4l2_format vdev_fmt;	/* Currently set format */
> > +
> > +	/* Private fields */
> > +	struct video_device vdev;
> > +	struct media_pad vdev_pad;
> > +	struct v4l2_mbus_framefmt pad_fmt;
> > +	struct vb2_queue vbq;
> > +	struct list_head buffers;
> > +	/* Protect vb2_queue and vdev structs*/
> > +	struct mutex lock;
> > +	atomic_t sequence;
> > +};
> > +
> > +/**
> > + * struct ipu3_mem2mem2_device - mem2mem device
> > + * this is the top level helper struct used by parent PCI device
> > + * to bind everything together for media operations.
> > + */
> > +struct ipu3_mem2mem2_device {
> 
> There's always 1:1 mapping between ipu3_mem2mem2_device and
> imgu_device.
> Could you merge the two?
> 

You mean remove the hierarchy relationship between ipu3_mem2mem2_device and imgu_video_device? in other word, remove imgu_video_device and let ipu3_mem2mem2_device directly own nodes' member data(with redundancy removed)? Just want to have a clear picture before attempt to change, thanks!!

> > +	/* Public fields, fill before registering */
> > +	const char *name;
> > +	const char *model;
> > +	struct device *dev;
> > +	int num_nodes;
> > +	struct imgu_video_device *nodes;
> > +	struct device *vb2_alloc_dev;
> > +	const struct ipu3_mem2mem2_ops *ops;
> > +	const struct vb2_mem_ops *vb2_mem_ops;
> > +	unsigned int buf_struct_size;
> > +	bool streaming;		/* Public read only */
> > +	struct v4l2_ctrl_handler *ctrl_handler;
> > +
> > +	/* Private fields */
> > +	struct v4l2_device v4l2_dev;
> > +	struct media_device media_dev;
> > +	struct media_pipeline pipeline;
> > +	struct v4l2_subdev subdev;
> > +	struct media_pad *subdev_pads;
> > +	struct v4l2_file_operations v4l2_file_ops; };
> > +
> > +/**
> > + * struct ipu3_mem2mem2_ops - mem2mem2 ops
> > + * defines driver specific callback APIs like
> > + * start stream.
> > + */
> > +struct ipu3_mem2mem2_ops {
> > +	int (*s_stream)(struct ipu3_mem2mem2_device *m2m2_dev, int
> enable);
> > +};
> > +
> > +/*
> > + * imgu_device -- ImgU (Imaging Unit) driver  */ struct imgu_device {
> > +	struct pci_dev *pci_dev;
> > +	void __iomem *base;
> > +
> > +	/* Internally enabled queues */
> > +	struct {
> > +		struct ipu3_css_map dmap;
> > +		struct ipu3_css_buffer
> dummybufs[IMGU_MAX_QUEUE_DEPTH];
> > +	} queues[IPU3_CSS_QUEUES];
> > +	struct imgu_video_device mem2mem2_nodes[IMGU_NODE_NUM];
> > +	bool queue_enabled[IMGU_NODE_NUM];
> > +
> > +	/* Delegate v4l2 support */
> > +	struct ipu3_mem2mem2_device mem2mem2;
> > +	/* MMU driver for css */
> > +	struct device *mmu;
> > +	struct iommu_domain *domain;
> > +	struct iova_domain iova_domain;
> > +	/* css - Camera Sub-System */
> > +	struct ipu3_css css;
> > +
> > +	/*
> > +	 * Coarse-grained lock to protect
> > +	 * m2m2_buf.list and css->queue
> > +	 */
> > +	struct mutex lock;
> > +	/* Forbit streaming and buffer queuing during system suspend. */
> > +	struct mutex qbuf_lock;
> > +	struct {
> > +		struct v4l2_rect eff; /* effective resolution */
> > +		struct v4l2_rect bds; /* bayer-domain scaled resolution*/
> > +		struct v4l2_rect gdc; /* gdc output resolution */
> > +	} rect;
> > +	/* Indicate if system suspend take place while imgu is streaming. */
> > +	bool suspend_in_stream;
> > +	/* Used to wait for FW buffer queue drain. */
> > +	wait_queue_head_t buf_drain_wq;
> > +};
> > +
> > +int imgu_node_to_queue(int node);
> > +int imgu_map_node(struct imgu_device *imgu, int css_queue); int
> > +imgu_queue_buffers(struct imgu_device *imgu, bool initial);
> > +
> > +int ipu3_v4l2_register(struct imgu_device *dev); int
> > +ipu3_v4l2_unregister(struct imgu_device *dev); void
> > +ipu3_v4l2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state
> > +state);
> > +
> > +#endif
> > --
> > 2.7.4
> >
> 
> --
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi
