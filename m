Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:42733 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728757AbeKOW7H (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Nov 2018 17:59:07 -0500
Subject: Re: [PATCH v7 14/16] intel-ipu3: Add v4l2 driver based on media
 framework
To: Yong Zhi <yong.zhi@intel.com>, linux-media@vger.kernel.org,
        sakari.ailus@linux.intel.com
Cc: tfiga@chromium.org, mchehab@kernel.org, hans.verkuil@cisco.com,
        laurent.pinchart@ideasonboard.com, rajmohan.mani@intel.com,
        jian.xu.zheng@intel.com, jerry.w.hu@intel.com,
        tuukka.toivonen@intel.com, tian.shu.qiu@intel.com,
        bingbu.cao@intel.com
References: <1540851790-1777-1-git-send-email-yong.zhi@intel.com>
 <1540851790-1777-15-git-send-email-yong.zhi@intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <bb5f135c-4042-1665-4218-802c6441aa2b@xs4all.nl>
Date: Thu, 15 Nov 2018 13:51:17 +0100
MIME-Version: 1.0
In-Reply-To: <1540851790-1777-15-git-send-email-yong.zhi@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/29/18 23:23, Yong Zhi wrote:
> Implement video driver that utilizes v4l2, vb2 queue support
> and media controller APIs. The driver exposes single
> subdevice and six nodes.
> 
> Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> ---
>  drivers/media/pci/intel/ipu3/ipu3-v4l2.c | 1091 ++++++++++++++++++++++++++++++
>  1 file changed, 1091 insertions(+)
>  create mode 100644 drivers/media/pci/intel/ipu3/ipu3-v4l2.c
> 
> diff --git a/drivers/media/pci/intel/ipu3/ipu3-v4l2.c b/drivers/media/pci/intel/ipu3/ipu3-v4l2.c

<snip>

> +int ipu3_v4l2_register(struct imgu_device *imgu)
> +{

<snip>

> +		/* Initialize vbq */
> +		vbq->type = node->vdev_fmt.type;
> +		vbq->io_modes = VB2_USERPTR | VB2_MMAP | VB2_DMABUF;

Are you sure USERPTR works? If you have alignment requirements that
the buffer starts at a multiple of more than (I think) 8 bytes, then
USERPTR won't work.

> +		vbq->ops = &ipu3_vb2_ops;
> +		vbq->mem_ops = &vb2_dma_sg_memops;
> +		if (imgu->buf_struct_size <= 0)
> +			imgu->buf_struct_size = sizeof(struct ipu3_vb2_buffer);
> +		vbq->buf_struct_size = imgu->buf_struct_size;
> +		vbq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +		vbq->min_buffers_needed = 0;	/* Can streamon w/o buffers */
> +		vbq->drv_priv = imgu;
> +		vbq->lock = &node->lock;
> +		r = vb2_queue_init(vbq);
> +		if (r) {
> +			dev_err(&imgu->pci_dev->dev,
> +				"failed to initialize video queue (%d)\n", r);
> +			goto fail_vdev;
> +		}
> +
> +		/* Initialize vdev */
> +		snprintf(vdev->name, sizeof(vdev->name), "%s %s",
> +			 IMGU_NAME, node->name);
> +		vdev->release = video_device_release_empty;
> +		vdev->fops = &ipu3_v4l2_fops;
> +		vdev->lock = &node->lock;
> +		vdev->v4l2_dev = &imgu->v4l2_dev;
> +		vdev->queue = &node->vbq;
> +		vdev->vfl_dir = node->output ? VFL_DIR_TX : VFL_DIR_RX;
> +		video_set_drvdata(vdev, imgu);
> +		r = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
> +		if (r) {
> +			dev_err(&imgu->pci_dev->dev,
> +				"failed to register video device (%d)\n", r);
> +			goto fail_vdev;
> +		}
> +
> +		/* Create link between video node and the subdev pad */
> +		flags = 0;
> +		if (node->enabled)
> +			flags |= MEDIA_LNK_FL_ENABLED;
> +		if (node->immutable)
> +			flags |= MEDIA_LNK_FL_IMMUTABLE;
> +		if (node->output) {
> +			r = media_create_pad_link(&vdev->entity, 0,
> +						  &imgu->subdev.entity,
> +						 i, flags);
> +		} else {
> +			r = media_create_pad_link(&imgu->subdev.entity,
> +						  i, &vdev->entity, 0, flags);
> +		}
> +		if (r)
> +			goto fail_link;
> +	}
> +
> +	r = media_device_register(&imgu->media_dev);
> +	if (r) {
> +		dev_err(&imgu->pci_dev->dev,
> +			"failed to register media device (%d)\n", r);
> +		i--;
> +		goto fail_link;
> +	}
> +
> +	return 0;
> +
> +	for (; i >= 0; i--) {
> +fail_link:
> +		video_unregister_device(&imgu->nodes[i].vdev);
> +fail_vdev:
> +		media_entity_cleanup(&imgu->nodes[i].vdev.entity);
> +fail_vdev_media_entity:
> +		mutex_destroy(&imgu->nodes[i].lock);
> +	}
> +fail_subdevs:
> +	v4l2_device_unregister_subdev(&imgu->subdev);
> +fail_subdev:
> +	media_entity_cleanup(&imgu->subdev.entity);
> +fail_media_entity:
> +	kfree(imgu->subdev_pads);
> +fail_subdev_pads:
> +	v4l2_device_unregister(&imgu->v4l2_dev);
> +fail_v4l2_dev:
> +	media_device_cleanup(&imgu->media_dev);
> +
> +	return r;
> +}
> +EXPORT_SYMBOL_GPL(ipu3_v4l2_register);
> +
> +int ipu3_v4l2_unregister(struct imgu_device *imgu)
> +{
> +	unsigned int i;
> +
> +	media_device_unregister(&imgu->media_dev);
> +	media_device_cleanup(&imgu->media_dev);
> +
> +	for (i = 0; i < IMGU_NODE_NUM; i++) {
> +		video_unregister_device(&imgu->nodes[i].vdev);
> +		media_entity_cleanup(&imgu->nodes[i].vdev.entity);
> +		mutex_destroy(&imgu->nodes[i].lock);
> +	}
> +
> +	v4l2_device_unregister_subdev(&imgu->subdev);
> +	media_entity_cleanup(&imgu->subdev.entity);
> +	kfree(imgu->subdev_pads);
> +	v4l2_device_unregister(&imgu->v4l2_dev);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(ipu3_v4l2_unregister);
> +
> +void ipu3_v4l2_buffer_done(struct vb2_buffer *vb,
> +			   enum vb2_buffer_state state)
> +{
> +	struct ipu3_vb2_buffer *b =
> +		container_of(vb, struct ipu3_vb2_buffer, vbb.vb2_buf);
> +
> +	list_del(&b->list);
> +	vb2_buffer_done(&b->vbb.vb2_buf, state);
> +}
> +EXPORT_SYMBOL_GPL(ipu3_v4l2_buffer_done);
> 

Regards,

	Hans
