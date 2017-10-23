Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:10610 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751216AbdJWWmA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Oct 2017 18:42:00 -0400
From: "Zhi, Yong" <yong.zhi@intel.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        "Vijaykumar, Ramya" <ramya.vijaykumar@intel.com>
Subject: RE: [PATCH v4 11/12] intel-ipu3: Add imgu v4l2 driver
Date: Mon, 23 Oct 2017 22:41:57 +0000
Message-ID: <C193D76D23A22742993887E6D207B54D1AE2BFC9@ORSMSX106.amr.corp.intel.com>
References: <1508298896-26096-1-git-send-email-yong.zhi@intel.com>
 <1508298896-26096-8-git-send-email-yong.zhi@intel.com>
 <20171020112940.2ptehi2ejl5mhjez@valkosipuli.retiisi.org.uk>
In-Reply-To: <20171020112940.2ptehi2ejl5mhjez@valkosipuli.retiisi.org.uk>
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
> Sent: Friday, October 20, 2017 4:30 AM
> To: Zhi, Yong <yong.zhi@intel.com>
> Cc: linux-media@vger.kernel.org; sakari.ailus@linux.intel.com; Zheng, Jian
> Xu <jian.xu.zheng@intel.com>; Mani, Rajmohan
> <rajmohan.mani@intel.com>; Toivonen, Tuukka
> <tuukka.toivonen@intel.com>; Hu, Jerry W <jerry.w.hu@intel.com>;
> Vijaykumar, Ramya <ramya.vijaykumar@intel.com>
> Subject: Re: [PATCH v4 11/12] intel-ipu3: Add imgu v4l2 driver
> 
> Hi Yong,
> 
> On Tue, Oct 17, 2017 at 10:54:56PM -0500, Yong Zhi wrote:
> > ipu3 imgu video device based on v4l2, vb2 and media controller
> > framework.
> >
> > Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> > Signed-off-by: Ramya Vijaykumar <ramya.vijaykumar@intel.com>
> > ---
> >  drivers/media/pci/intel/ipu3/ipu3-v4l2.c | 1150
> > ++++++++++++++++++++++++++++++
> >  1 file changed, 1150 insertions(+)
> >  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-v4l2.c
> >
> > diff --git a/drivers/media/pci/intel/ipu3/ipu3-v4l2.c
> > b/drivers/media/pci/intel/ipu3/ipu3-v4l2.c
> > new file mode 100644
> > index 000000000000..4618880b8675
> > --- /dev/null
> > +++ b/drivers/media/pci/intel/ipu3/ipu3-v4l2.c
> > @@ -0,0 +1,1150 @@
(snip)
> > +static int mem2mem2_g_selection(struct ipu3_mem2mem2_device
> *m2m2_dev,
> > +				int node, struct v4l2_selection *s) {
> > +	struct imgu_device *const imgu =
> > +		container_of(m2m2_dev, struct imgu_device, mem2mem2);
> > +
> > +	if (node != IPU3_CSS_QUEUE_IN)
> > +		return -ENOIOCTLCMD;
> > +
> > +	switch (s->target) {
> > +	case V4L2_SEL_TGT_CROP:
> > +		s->r = imgu->rect.eff;
> > +		break;
> > +	case V4L2_SEL_TGT_CROP_BOUNDS:
> > +		break;
> > +	case V4L2_SEL_TGT_CROP_DEFAULT:
> > +		break;
> > +	case V4L2_SEL_TGT_COMPOSE_PADDED:
> > +		break;
> > +	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
> > +		break;
> > +	case V4L2_SEL_TGT_COMPOSE:
> > +		s->r = imgu->rect.bds;
> > +		break;
> > +	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
> > +		break;
> > +
> 
> As the driver uses the V4L2 sub-device interface, the selection API belongsis
> implemented in the sub-device node, not the video nodes.
> 

Ok, will study how to make necessary changes to use sub-dev interface for above.

> > +	default:
> > +		return -EINVAL;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int ipu3_try_fmt(struct file *file, void *fh, struct
> > +v4l2_format *f) {
> > +	struct v4l2_pix_format_mplane *pixm = &f->fmt.pix_mp;
> > +	const struct ipu3_fmt *fmt;
> > +
> > +	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> > +		fmt = find_format(f, M2M_CAPTURE);
> > +	else if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> > +		fmt = find_format(f, M2M_OUTPUT);
> > +	else
> > +		return -EINVAL;
> > +
> > +	pixm->pixelformat = fmt->fourcc;
> > +
> > +	memset(pixm->plane_fmt[0].reserved, 0,
> > +	       sizeof(pixm->plane_fmt[0].reserved));
> 
> No need for the memset here, the framework handles this.
> 
> Are there limits on the image size?
> 

The memset is added to fix v4l2-compliance failure here.

The image size limit is checked in ipu3-css.c/ipu3_css_queue_init().

(snip)
> > +int ipu3_v4l2_register(struct imgu_device *dev) {
> > +	struct ipu3_mem2mem2_device *m2m2 = &dev->mem2mem2;
> > +	struct v4l2_mbus_framefmt def_bus_fmt;
> > +	struct v4l2_pix_format_mplane def_pix_fmt;
> > +
> > +	int i, r;
> > +
> > +	/* Initialize miscellaneous variables */
> > +	m2m2->streaming = false;
> > +	m2m2->v4l2_file_ops = ipu3_v4l2_fops;
> > +
> > +	/* Set up media device */
> > +	m2m2->media_dev.dev = m2m2->dev;
> > +	strlcpy(m2m2->media_dev.model, m2m2->model,
> > +		sizeof(m2m2->media_dev.model));
> > +	snprintf(m2m2->media_dev.bus_info, sizeof(m2m2-
> >media_dev.bus_info),
> > +		 "%s", dev_name(m2m2->dev));
> > +	m2m2->media_dev.hw_revision = 0;
> > +	media_device_init(&m2m2->media_dev);
> > +	r = media_device_register(&m2m2->media_dev);
> > +	if (r) {
> > +		dev_err(m2m2->dev, "failed to register media device (%d)\n",
> r);
> > +		goto fail_media_dev;
> 
> If there's nothing to clean up you can simply return the error here.

Ack, quite obvious indeed.

> 
> > +	}
> > +
> > +	/* Set up v4l2 device */
> > +	m2m2->v4l2_dev.mdev = &m2m2->media_dev;
> > +	m2m2->v4l2_dev.ctrl_handler = m2m2->ctrl_handler;
> > +	r = v4l2_device_register(m2m2->dev, &m2m2->v4l2_dev);
> > +	if (r) {
> > +		dev_err(m2m2->dev, "failed to register V4L2 device (%d)\n",
> r);
> > +		goto fail_v4l2_dev;
> > +	}
> > +
> > +	/* Initialize subdev media entity */
> > +	m2m2->subdev_pads = kzalloc(sizeof(*m2m2->subdev_pads) *
> > +					m2m2->num_nodes, GFP_KERNEL);
> > +	if (!m2m2->subdev_pads) {
> > +		r = -ENOMEM;
> > +		goto fail_subdev_pads;
> > +	}
> > +
> > +	r = media_entity_pads_init(&m2m2->subdev.entity, m2m2-
> >num_nodes,
> > +				   m2m2->subdev_pads);
> > +	if (r) {
> > +		dev_err(m2m2->dev,
> > +			"failed initialize subdev media entity (%d)\n", r);
> > +		goto fail_media_entity;
> > +	}
> > +	m2m2->subdev.entity.ops = &ipu3_media_ops;
> > +	for (i = 0; i < m2m2->num_nodes; i++) {
> > +		m2m2->subdev_pads[i].flags = m2m2->nodes[i].output ?
> > +			MEDIA_PAD_FL_SINK : MEDIA_PAD_FL_SOURCE;
> > +	}
> > +
> > +	/* Initialize subdev */
> > +	v4l2_subdev_init(&m2m2->subdev, &ipu3_subdev_ops);
> > +	m2m2->subdev.flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
> > +	snprintf(m2m2->subdev.name, sizeof(m2m2->subdev.name),
> > +		 "%s", m2m2->name);
> > +	v4l2_set_subdevdata(&m2m2->subdev, m2m2);
> > +	m2m2->subdev.ctrl_handler = m2m2->ctrl_handler;
> > +	r = v4l2_device_register_subdev(&m2m2->v4l2_dev, &m2m2-
> >subdev);
> > +	if (r) {
> > +		dev_err(m2m2->dev, "failed initialize subdev (%d)\n", r);
> > +		goto fail_subdev;
> > +	}
> > +	r = v4l2_device_register_subdev_nodes(&m2m2->v4l2_dev);
> > +	if (r) {
> > +		dev_err(m2m2->dev, "failed to register subdevs (%d)\n", r);
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
> > +	for (i = 0; i < m2m2->num_nodes; i++) {
> > +		struct imgu_video_device *node = &m2m2->nodes[i];
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
> > +
> > +		/* Initialize media entities */
> > +		r = media_entity_pads_init(&vdev->entity, 1, &node-
> >vdev_pad);
> > +		if (r) {
> > +			dev_err(m2m2->dev,
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
> > +		vbq->mem_ops = m2m2->vb2_mem_ops;
> 
> dma_sg is the right one for all except the parameters; they are only accessed
> by the driver, aren't they?
> 

Agree, will set to &vb2_dma_sg_memops directly instead.

> > +		if (m2m2->buf_struct_size <= 0)
> > +			m2m2->buf_struct_size =
> > +				sizeof(struct ipu3_mem2mem2_buffer);
> > +		vbq->buf_struct_size = m2m2->buf_struct_size;
> > +		vbq->timestamp_flags =
> V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> > +		vbq->min_buffers_needed = 0;	/* Can streamon w/o buffers
> */
> > +		vbq->drv_priv = m2m2;
> > +		vbq->lock = &node->lock;
> > +		r = vb2_queue_init(vbq);
> > +		if (r) {
> > +			dev_err(m2m2->dev,
> > +				"failed to initialize video queue (%d)\n", r);
> > +			goto fail_vdev;
> > +		}
> > +
> > +		/* Initialize vdev */
> > +		strlcpy(vdev->name, node->name, sizeof(vdev->name));
> > +		vdev->release = video_device_release_empty;
> > +		vdev->fops = &m2m2->v4l2_file_ops;
> > +		vdev->lock = &node->lock;
> > +		vdev->v4l2_dev = &m2m2->v4l2_dev;
> > +		vdev->queue = &node->vbq;
> > +		vdev->vfl_dir = node->output ? VFL_DIR_TX : VFL_DIR_RX;
> > +		video_set_drvdata(vdev, m2m2);
> > +		r = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
> > +		if (r) {
> > +			dev_err(m2m2->dev,
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
> > +			r = media_create_pad_link(
> > +						 &vdev->entity, 0,
> > +						 &m2m2->subdev.entity,
> > +						 i, flags);
> > +		} else {
> > +			r = media_create_pad_link(
> > +						 &m2m2->subdev.entity,
> > +						 i, &vdev->entity, 0,
> > +						 flags);
> > +		}
> > +		if (r)
> > +			goto fail_link;
> > +	}
> > +
> > +	return 0;
> > +
> > +	for (; i >= 0; i--) {
> > +fail_link:
> > +		video_unregister_device(&m2m2->nodes[i].vdev);
> > +fail_vdev:
> > +		media_entity_cleanup(&m2m2->nodes[i].vdev.entity);
> > +fail_vdev_media_entity:
> > +		mutex_destroy(&m2m2->nodes[i].lock);
> > +	}
> > +fail_subdevs:
> > +	v4l2_device_unregister_subdev(&m2m2->subdev);
> > +fail_subdev:
> > +	media_entity_cleanup(&m2m2->subdev.entity);
> > +fail_media_entity:
> > +	kfree(m2m2->subdev_pads);
> > +fail_subdev_pads:
> > +	v4l2_device_unregister(&m2m2->v4l2_dev);
> > +fail_v4l2_dev:
> > +	media_device_unregister(&m2m2->media_dev);
> > +	media_device_cleanup(&m2m2->media_dev);
> > +fail_media_dev:
> > +
> > +	return r;
> > +}
> > +EXPORT_SYMBOL_GPL(ipu3_v4l2_register);
> > +
> > +int ipu3_v4l2_unregister(struct imgu_device *dev) {
> > +	struct ipu3_mem2mem2_device *m2m2 = &dev->mem2mem2;
> > +	unsigned int i;
> > +
> > +	for (i = 0; i < m2m2->num_nodes; i++) {
> > +		video_unregister_device(&m2m2->nodes[i].vdev);
> > +		media_entity_cleanup(&m2m2->nodes[i].vdev.entity);
> > +		mutex_destroy(&m2m2->nodes[i].lock);
> > +	}
> > +
> > +	v4l2_device_unregister_subdev(&m2m2->subdev);
> > +	media_entity_cleanup(&m2m2->subdev.entity);
> > +	kfree(m2m2->subdev_pads);
> > +	v4l2_device_unregister(&m2m2->v4l2_dev);
> > +	media_device_unregister(&m2m2->media_dev);
> > +	media_device_cleanup(&m2m2->media_dev);
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(ipu3_v4l2_unregister);
> > +
> > +void ipu3_v4l2_buffer_done(struct vb2_buffer *vb,
> > +			   enum vb2_buffer_state state)
> > +{
> > +	struct ipu3_mem2mem2_buffer *b =
> > +		container_of(vb, struct ipu3_mem2mem2_buffer,
> vbb.vb2_buf);
> > +
> > +	list_del(&b->list);
> > +	vb2_buffer_done(&b->vbb.vb2_buf, state); }
> > +EXPORT_SYMBOL_GPL(ipu3_v4l2_buffer_done);
> > --
> > 2.7.4
> >
> 
> --
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi
