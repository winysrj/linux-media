Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga17.intel.com ([192.55.52.151]:42485 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727557AbeKJJJf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Nov 2018 04:09:35 -0500
From: "Zhi, Yong" <yong.zhi@intel.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "tfiga@chromium.org" <tfiga@chromium.org>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "hans.verkuil@cisco.com" <hans.verkuil@cisco.com>,
        "laurent.pinchart@ideasonboard.com"
        <laurent.pinchart@ideasonboard.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        "Cao, Bingbu" <bingbu.cao@intel.com>
Subject: RE: [PATCH v7 14/16] intel-ipu3: Add v4l2 driver based on media
 framework
Date: Fri, 9 Nov 2018 23:26:46 +0000
Message-ID: <C193D76D23A22742993887E6D207B54D3DB2FF78@ORSMSX106.amr.corp.intel.com>
References: <1540851790-1777-1-git-send-email-yong.zhi@intel.com>
 <1540851790-1777-15-git-send-email-yong.zhi@intel.com>
 <20181109123637.kwfjzuic5vry2774@paasikivi.fi.intel.com>
In-Reply-To: <20181109123637.kwfjzuic5vry2774@paasikivi.fi.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Sakari,

Thanks for the feedback.

> -----Original Message-----
> From: Sakari Ailus [mailto:sakari.ailus@linux.intel.com]
> Sent: Friday, November 9, 2018 6:37 AM
> To: Zhi, Yong <yong.zhi@intel.com>
> Cc: linux-media@vger.kernel.org; tfiga@chromium.org;
> mchehab@kernel.org; hans.verkuil@cisco.com;
> laurent.pinchart@ideasonboard.com; Mani, Rajmohan
> <rajmohan.mani@intel.com>; Zheng, Jian Xu <jian.xu.zheng@intel.com>; Hu,
> Jerry W <jerry.w.hu@intel.com>; Toivonen, Tuukka
> <tuukka.toivonen@intel.com>; Qiu, Tian Shu <tian.shu.qiu@intel.com>; Cao,
> Bingbu <bingbu.cao@intel.com>
> Subject: Re: [PATCH v7 14/16] intel-ipu3: Add v4l2 driver based on media
> framework
> 
> Hi Yong,
> 
> On Mon, Oct 29, 2018 at 03:23:08PM -0700, Yong Zhi wrote:
> > Implement video driver that utilizes v4l2, vb2 queue support and media
> > controller APIs. The driver exposes single subdevice and six nodes.
> >
> > Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> > ---
> >  drivers/media/pci/intel/ipu3/ipu3-v4l2.c | 1091
> > ++++++++++++++++++++++++++++++
> >  1 file changed, 1091 insertions(+)
> >  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-v4l2.c
> >
> > diff --git a/drivers/media/pci/intel/ipu3/ipu3-v4l2.c
> > b/drivers/media/pci/intel/ipu3/ipu3-v4l2.c
> > new file mode 100644
> > index 0000000..31a3514
> > --- /dev/null
> > +++ b/drivers/media/pci/intel/ipu3/ipu3-v4l2.c
> > @@ -0,0 +1,1091 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +// Copyright (C) 2018 Intel Corporation
> > +
> > +#include <linux/module.h>
> > +#include <linux/pm_runtime.h>
> > +
> > +#include <media/v4l2-ioctl.h>
> > +
> > +#include "ipu3.h"
> > +#include "ipu3-dmamap.h"
> > +
> > +/******************** v4l2_subdev_ops ********************/
> > +
> > +static int ipu3_subdev_open(struct v4l2_subdev *sd, struct
> > +v4l2_subdev_fh *fh) {
> > +	struct imgu_device *imgu = container_of(sd, struct imgu_device,
> subdev);
> > +	struct v4l2_rect try_crop = {
> > +		.top = 0,
> > +		.left = 0,
> > +		.height = imgu-
> >nodes[IMGU_NODE_IN].vdev_fmt.fmt.pix_mp.height,
> > +		.width = imgu-
> >nodes[IMGU_NODE_IN].vdev_fmt.fmt.pix_mp.width,
> > +	};
> > +	unsigned int i;
> > +
> > +	/* Initialize try_fmt */
> > +	for (i = 0; i < IMGU_NODE_NUM; i++)
> > +		*v4l2_subdev_get_try_format(sd, fh->pad, i) =
> > +			imgu->nodes[i].pad_fmt;
> 
> The try formats should reflect the defaults, not the current device state.
> 

Ack, will fix in next update.

> > +
> > +	*v4l2_subdev_get_try_crop(sd, fh->pad, IMGU_NODE_IN) = try_crop;
> 
> Same for the crop. How about the compose rectangle?
> 

Ok, will check both crop and compose rectangle.

> > +
> > +	return 0;
> > +}
> 
> ...
> 
> > +int ipu3_v4l2_register(struct imgu_device *imgu) {
> > +	struct v4l2_mbus_framefmt def_bus_fmt = { 0 };
> > +	struct v4l2_pix_format_mplane def_pix_fmt = { 0 };
> > +
> 
> Extra newline.

Ack.

> 
> > +	int i, r;
> > +
> > +	/* Initialize miscellaneous variables */
> > +	imgu->streaming = false;
> > +
> > +	/* Init media device */
> > +	media_device_pci_init(&imgu->media_dev, imgu->pci_dev,
> IMGU_NAME);
> > +
> > +	/* Set up v4l2 device */
> > +	imgu->v4l2_dev.mdev = &imgu->media_dev;
> > +	imgu->v4l2_dev.ctrl_handler = imgu->ctrl_handler;
> > +	r = v4l2_device_register(&imgu->pci_dev->dev, &imgu->v4l2_dev);
> > +	if (r) {
> > +		dev_err(&imgu->pci_dev->dev,
> > +			"failed to register V4L2 device (%d)\n", r);
> > +		goto fail_v4l2_dev;
> > +	}
> > +
> > +	/* Initialize subdev media entity */
> > +	imgu->subdev_pads = kzalloc(sizeof(*imgu->subdev_pads) *
> > +					IMGU_NODE_NUM, GFP_KERNEL);
> 
> As the number of pads is static, could you instead put the array directly to
> the struct, instead of using a pointer? Remember to remove to
> corresponding kfree, too.

Good point, kzalloc does not serve its purpose here.

> 
> > +	if (!imgu->subdev_pads) {
> > +		r = -ENOMEM;
> > +		goto fail_subdev_pads;
> > +	}
> > +	r = media_entity_pads_init(&imgu->subdev.entity,
> IMGU_NODE_NUM,
> > +				   imgu->subdev_pads);
> > +	if (r) {
> > +		dev_err(&imgu->pci_dev->dev,
> > +			"failed initialize subdev media entity (%d)\n", r);
> > +		goto fail_media_entity;
> > +	}
> > +	imgu->subdev.entity.ops = &ipu3_media_ops;
> > +	for (i = 0; i < IMGU_NODE_NUM; i++) {
> > +		imgu->subdev_pads[i].flags = imgu->nodes[i].output ?
> > +			MEDIA_PAD_FL_SINK : MEDIA_PAD_FL_SOURCE;
> > +	}
> > +
> > +	/* Initialize subdev */
> > +	v4l2_subdev_init(&imgu->subdev, &ipu3_subdev_ops);
> > +	imgu->subdev.entity.function =
> MEDIA_ENT_F_PROC_VIDEO_STATISTICS;
> > +	imgu->subdev.internal_ops = &ipu3_subdev_internal_ops;
> > +	imgu->subdev.flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
> > +	strlcpy(imgu->subdev.name, IMGU_NAME, sizeof(imgu-
> >subdev.name));
> 
> strscpy(), please. Same elsewhere in this and also on the 13th.
> 
> > +	v4l2_set_subdevdata(&imgu->subdev, imgu);
> > +	imgu->subdev.ctrl_handler = imgu->ctrl_handler;
> > +	r = v4l2_device_register_subdev(&imgu->v4l2_dev, &imgu->subdev);
> > +	if (r) {
> > +		dev_err(&imgu->pci_dev->dev,
> > +			"failed initialize subdev (%d)\n", r);
> > +		goto fail_subdev;
> > +	}
> > +	r = v4l2_device_register_subdev_nodes(&imgu->v4l2_dev);
> > +	if (r) {
> > +		dev_err(&imgu->pci_dev->dev,
> > +			"failed to register subdevs (%d)\n", r);
> > +		goto fail_subdevs;
> > +	}
> > +
> > +	/* Initialize formats to default values */
> > +	def_bus_fmt.width = 1920;
> > +	def_bus_fmt.height = 1080;
> > +	def_bus_fmt.code = MEDIA_BUS_FMT_UYVY8_2X8;
> > +	def_bus_fmt.field = V4L2_FIELD_NONE;
> > +	def_bus_fmt.colorspace = V4L2_COLORSPACE_RAW;
> > +	def_bus_fmt.ycbcr_enc = V4L2_YCBCR_ENC_DEFAULT;
> > +	def_bus_fmt.quantization = V4L2_QUANTIZATION_DEFAULT;
> > +	def_bus_fmt.xfer_func = V4L2_XFER_FUNC_DEFAULT;
> > +
> > +	def_pix_fmt.width = def_bus_fmt.width;
> > +	def_pix_fmt.height = def_bus_fmt.height;
> > +	def_pix_fmt.field = def_bus_fmt.field;
> > +	def_pix_fmt.num_planes = 1;
> > +	def_pix_fmt.plane_fmt[0].bytesperline = def_pix_fmt.width * 2;
> > +	def_pix_fmt.plane_fmt[0].sizeimage =
> > +		def_pix_fmt.height * def_pix_fmt.plane_fmt[0].bytesperline;
> > +	def_pix_fmt.flags = 0;
> > +	def_pix_fmt.colorspace = def_bus_fmt.colorspace;
> > +	def_pix_fmt.ycbcr_enc = def_bus_fmt.ycbcr_enc;
> > +	def_pix_fmt.quantization = def_bus_fmt.quantization;
> > +	def_pix_fmt.xfer_func = def_bus_fmt.xfer_func;
> > +
> > +	/* Create video nodes and links */
> > +	for (i = 0; i < IMGU_NODE_NUM; i++) {
> > +		struct imgu_video_device *node = &imgu->nodes[i];
> > +		struct video_device *vdev = &node->vdev;
> > +		struct vb2_queue *vbq = &node->vbq;
> > +		u32 flags;
> > +
> > +		/* Initialize miscellaneous variables */
> > +		mutex_init(&node->lock);
> > +		INIT_LIST_HEAD(&node->buffers);
> > +
> > +		/* Initialize formats to default values */
> > +		node->pad_fmt = def_bus_fmt;
> > +		ipu3_node_to_v4l2(i, vdev, &node->vdev_fmt);
> > +		if (node->vdev_fmt.type ==
> V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE ||
> > +		    node->vdev_fmt.type ==
> V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> > +			def_pix_fmt.pixelformat = node->output ?
> > +
> 	V4L2_PIX_FMT_IPU3_SGRBG10 :
> > +						V4L2_PIX_FMT_NV12;
> > +			node->vdev_fmt.fmt.pix_mp = def_pix_fmt;
> > +		}
> > +		/* Initialize media entities */
> > +		r = media_entity_pads_init(&vdev->entity, 1, &node-
> >vdev_pad);
> > +		if (r) {
> > +			dev_err(&imgu->pci_dev->dev,
> > +				"failed initialize media entity (%d)\n", r);
> > +			goto fail_vdev_media_entity;
> > +		}
> > +		node->vdev_pad.flags = node->output ?
> > +			MEDIA_PAD_FL_SOURCE : MEDIA_PAD_FL_SINK;
> > +		vdev->entity.ops = NULL;
> > +
> > +		/* Initialize vbq */
> > +		vbq->type = node->vdev_fmt.type;
> > +		vbq->io_modes = VB2_USERPTR | VB2_MMAP |
> VB2_DMABUF;
> > +		vbq->ops = &ipu3_vb2_ops;
> > +		vbq->mem_ops = &vb2_dma_sg_memops;
> > +		if (imgu->buf_struct_size <= 0)
> > +			imgu->buf_struct_size = sizeof(struct
> ipu3_vb2_buffer);
> > +		vbq->buf_struct_size = imgu->buf_struct_size;
> > +		vbq->timestamp_flags =
> V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> > +		vbq->min_buffers_needed = 0;	/* Can streamon w/o buffers
> */
> > +		vbq->drv_priv = imgu;
> > +		vbq->lock = &node->lock;
> > +		r = vb2_queue_init(vbq);
> > +		if (r) {
> > +			dev_err(&imgu->pci_dev->dev,
> > +				"failed to initialize video queue (%d)\n", r);
> > +			goto fail_vdev;
> > +		}
> > +
> > +		/* Initialize vdev */
> > +		snprintf(vdev->name, sizeof(vdev->name), "%s %s",
> > +			 IMGU_NAME, node->name);
> > +		vdev->release = video_device_release_empty;
> > +		vdev->fops = &ipu3_v4l2_fops;
> > +		vdev->lock = &node->lock;
> > +		vdev->v4l2_dev = &imgu->v4l2_dev;
> > +		vdev->queue = &node->vbq;
> > +		vdev->vfl_dir = node->output ? VFL_DIR_TX : VFL_DIR_RX;
> > +		video_set_drvdata(vdev, imgu);
> > +		r = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
> > +		if (r) {
> > +			dev_err(&imgu->pci_dev->dev,
> > +				"failed to register video device (%d)\n", r);
> > +			goto fail_vdev;
> > +		}
> > +
> > +		/* Create link between video node and the subdev pad */
> > +		flags = 0;
> > +		if (node->enabled)
> > +			flags |= MEDIA_LNK_FL_ENABLED;
> > +		if (node->immutable)
> > +			flags |= MEDIA_LNK_FL_IMMUTABLE;
> > +		if (node->output) {
> > +			r = media_create_pad_link(&vdev->entity, 0,
> > +						  &imgu->subdev.entity,
> > +						 i, flags);
> > +		} else {
> > +			r = media_create_pad_link(&imgu->subdev.entity,
> > +						  i, &vdev->entity, 0, flags);
> > +		}
> > +		if (r)
> > +			goto fail_link;
> > +	}
> > +
> > +	r = media_device_register(&imgu->media_dev);
> > +	if (r) {
> > +		dev_err(&imgu->pci_dev->dev,
> > +			"failed to register media device (%d)\n", r);
> > +		i--;
> > +		goto fail_link;
> > +	}
> > +
> > +	return 0;
> > +
> > +	for (; i >= 0; i--) {
> > +fail_link:
> > +		video_unregister_device(&imgu->nodes[i].vdev);
> > +fail_vdev:
> > +		media_entity_cleanup(&imgu->nodes[i].vdev.entity);
> > +fail_vdev_media_entity:
> > +		mutex_destroy(&imgu->nodes[i].lock);
> > +	}
> > +fail_subdevs:
> > +	v4l2_device_unregister_subdev(&imgu->subdev);
> > +fail_subdev:
> > +	media_entity_cleanup(&imgu->subdev.entity);
> > +fail_media_entity:
> > +	kfree(imgu->subdev_pads);
> > +fail_subdev_pads:
> > +	v4l2_device_unregister(&imgu->v4l2_dev);
> > +fail_v4l2_dev:
> > +	media_device_cleanup(&imgu->media_dev);
> > +
> > +	return r;
> > +}
> > +EXPORT_SYMBOL_GPL(ipu3_v4l2_register);
> > +
> > +int ipu3_v4l2_unregister(struct imgu_device *imgu) {
> > +	unsigned int i;
> > +
> > +	media_device_unregister(&imgu->media_dev);
> > +	media_device_cleanup(&imgu->media_dev);
> 
> media_device_cleanup() should take place after unregistering the sub-
> devices.
> 

Thanks for catching this.

Yong

> > +
> > +	for (i = 0; i < IMGU_NODE_NUM; i++) {
> > +		video_unregister_device(&imgu->nodes[i].vdev);
> > +		media_entity_cleanup(&imgu->nodes[i].vdev.entity);
> > +		mutex_destroy(&imgu->nodes[i].lock);
> > +	}
> > +
> > +	v4l2_device_unregister_subdev(&imgu->subdev);
> > +	media_entity_cleanup(&imgu->subdev.entity);
> > +	kfree(imgu->subdev_pads);
> > +	v4l2_device_unregister(&imgu->v4l2_dev);
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(ipu3_v4l2_unregister);
> > +
> > +void ipu3_v4l2_buffer_done(struct vb2_buffer *vb,
> > +			   enum vb2_buffer_state state)
> > +{
> > +	struct ipu3_vb2_buffer *b =
> > +		container_of(vb, struct ipu3_vb2_buffer, vbb.vb2_buf);
> > +
> > +	list_del(&b->list);
> > +	vb2_buffer_done(&b->vbb.vb2_buf, state); }
> > +EXPORT_SYMBOL_GPL(ipu3_v4l2_buffer_done);
> 
> --
> Kind regards,
> 
> Sakari Ailus
> sakari.ailus@linux.intel.com
