Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46498 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752663AbdFPOuQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Jun 2017 10:50:16 -0400
Date: Fri, 16 Jun 2017 17:50:10 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Yong Zhi <yong.zhi@intel.com>
Cc: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        jian.xu.zheng@intel.com, tfiga@chromium.org,
        rajmohan.mani@intel.com, tuukka.toivonen@intel.com
Subject: Re: [PATCH v2 11/12] intel-ipu3: Add imgu v4l2 driver
Message-ID: <20170616145010.GS12407@valkosipuli.retiisi.org.uk>
References: <1497478767-10270-1-git-send-email-yong.zhi@intel.com>
 <1497478767-10270-12-git-send-email-yong.zhi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1497478767-10270-12-git-send-email-yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Yong,

On Wed, Jun 14, 2017 at 05:19:26PM -0500, Yong Zhi wrote:
> +int ipu3_v4l2_register(struct imgu_device *dev)
> +{
> +	struct ipu3_mem2mem2_device *m2m2 = &dev->mem2mem2;
> +	int i, r;
> +
> +	/* Initialize miscellaneous variables */
> +	m2m2->streaming = false;
> +	m2m2->v4l2_file_ops = ipu3_v4l2_fops;
> +
> +	/* Set up media device */
> +	m2m2->media_dev.dev = m2m2->dev;
> +	strlcpy(m2m2->media_dev.model, m2m2->model,
> +		sizeof(m2m2->media_dev.model));
> +	snprintf(m2m2->media_dev.bus_info, sizeof(m2m2->media_dev.bus_info),
> +		 "%s", dev_name(m2m2->dev));
> +	m2m2->media_dev.driver_version = KERNEL_VERSION(4, 12, 0);
> +	m2m2->media_dev.hw_revision = 0;
> +	media_device_init(&m2m2->media_dev);
> +	r = media_device_register(&m2m2->media_dev);
> +	if (r) {
> +		dev_err(m2m2->dev, "failed to register media device (%d)\n", r);
> +		goto fail_media_dev;
> +	}
> +
> +	/* Set up v4l2 device */
> +	m2m2->v4l2_dev.mdev = &m2m2->media_dev;
> +	m2m2->v4l2_dev.ctrl_handler = m2m2->ctrl_handler;
> +	r = v4l2_device_register(m2m2->dev, &m2m2->v4l2_dev);
> +	if (r) {
> +		dev_err(m2m2->dev, "failed to register V4L2 device (%d)\n", r);
> +		goto fail_v4l2_dev;
> +	}
> +
> +	/* Initialize subdev media entity */
> +	m2m2->subdev_pads = kzalloc(sizeof(*m2m2->subdev_pads) *
> +					m2m2->num_nodes, GFP_KERNEL);
> +	if (!m2m2->subdev_pads) {
> +		r = -ENOMEM;
> +		goto fail_subdev_pads;
> +	}
> +	r = media_entity_pads_init(&m2m2->subdev.entity, m2m2->num_nodes,
> +				   m2m2->subdev_pads);
> +	if (r) {
> +		dev_err(m2m2->dev,
> +			"failed initialize subdev media entity (%d)\n", r);
> +		goto fail_media_entity;
> +	}
> +	m2m2->subdev.entity.ops = &ipu3_media_ops;
> +	for (i = 0; i < m2m2->num_nodes; i++) {
> +		m2m2->subdev_pads[i].flags = m2m2->nodes[i].output ?
> +			MEDIA_PAD_FL_SINK : MEDIA_PAD_FL_SOURCE;
> +	}
> +
> +	/* Initialize subdev */
> +	v4l2_subdev_init(&m2m2->subdev, &ipu3_subdev_ops);
> +	m2m2->subdev.flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
> +	snprintf(m2m2->subdev.name, sizeof(m2m2->subdev.name),
> +		 "%s", m2m2->name);
> +	v4l2_set_subdevdata(&m2m2->subdev, m2m2);
> +	m2m2->subdev.ctrl_handler = m2m2->ctrl_handler;
> +	r = v4l2_device_register_subdev(&m2m2->v4l2_dev, &m2m2->subdev);
> +	if (r) {
> +		dev_err(m2m2->dev, "failed initialize subdev (%d)\n", r);
> +		goto fail_subdev;
> +	}
> +	r = v4l2_device_register_subdev_nodes(&m2m2->v4l2_dev);
> +	if (r) {
> +		dev_err(m2m2->dev, "failed to register subdevs (%d)\n", r);
> +		goto fail_subdevs;
> +	}
> +
> +	/* Create video nodes and links */
> +	for (i = 0; i < m2m2->num_nodes; i++) {
> +		struct imgu_video_device *node = &m2m2->nodes[i];
> +		struct video_device *vdev = &node->vdev;
> +		struct vb2_queue *vbq = &node->vbq;
> +		struct v4l2_mbus_framefmt *fmt;
> +		u32 flags;
> +
> +		/* Initialize miscellaneous variables */
> +		mutex_init(&node->lock);
> +		INIT_LIST_HEAD(&node->buffers);
> +
> +		/* Initialize formats to default values */
> +		fmt = &node->pad_fmt;
> +		fmt->width = 352;
> +		fmt->height = 288;
> +		fmt->code = MEDIA_BUS_FMT_UYVY8_2X8;
> +		fmt->field = V4L2_FIELD_NONE;
> +		fmt->colorspace = V4L2_COLORSPACE_RAW;
> +		fmt->ycbcr_enc = V4L2_YCBCR_ENC_DEFAULT;
> +		fmt->quantization = V4L2_QUANTIZATION_DEFAULT;
> +		fmt->xfer_func = V4L2_XFER_FUNC_DEFAULT;
> +		fmt = &node->pad_fmt;
> +		node->vdev_fmt.type = node->output ?
> +			V4L2_BUF_TYPE_VIDEO_OUTPUT :
> +			V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +		node->vdev_fmt.fmt.pix.width = fmt->width;
> +		node->vdev_fmt.fmt.pix.height = fmt->height;
> +		node->vdev_fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_YUYV;
> +		node->vdev_fmt.fmt.pix.field = fmt->field;
> +		node->vdev_fmt.fmt.pix.bytesperline = fmt->width * 2;
> +		node->vdev_fmt.fmt.pix.sizeimage =
> +			node->vdev_fmt.fmt.pix.bytesperline * fmt->height;
> +		node->vdev_fmt.fmt.pix.colorspace = fmt->colorspace;
> +		node->vdev_fmt.fmt.pix.priv = 0;
> +		node->vdev_fmt.fmt.pix.flags = 0;
> +		node->vdev_fmt.fmt.pix.ycbcr_enc = fmt->ycbcr_enc;
> +		node->vdev_fmt.fmt.pix.quantization = fmt->quantization;
> +		node->vdev_fmt.fmt.pix.xfer_func = fmt->xfer_func;
> +
> +		/* Initialize media entities */
> +		r = media_entity_pads_init(&vdev->entity, 1, &node->vdev_pad);
> +		if (r) {
> +			dev_err(m2m2->dev,
> +				"failed initialize media entity (%d)\n", r);
> +			goto fail_vdev_media_entity;
> +		}
> +		node->vdev_pad.flags = node->output ?
> +			MEDIA_PAD_FL_SOURCE : MEDIA_PAD_FL_SINK;
> +		vdev->entity.ops = NULL;
> +
> +		/* Initialize vbq */
> +		vbq->type = node->output ?
> +		    V4L2_BUF_TYPE_VIDEO_OUTPUT : V4L2_BUF_TYPE_VIDEO_CAPTURE;

You should use a META_CAPTURE buffer type for the statistics. META_OUTPUT
for the parameters (I'll cc you to the patches shortly).

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
