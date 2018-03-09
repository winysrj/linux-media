Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:60545 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932101AbeCIODU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Mar 2018 09:03:20 -0500
Subject: Re: [PATCH v6 07/17] media: rkisp1: add ISP1 params driver
To: Jacob Chen <jacob-chen@iotwrt.com>,
        linux-rockchip@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        sakari.ailus@linux.intel.com, hans.verkuil@cisco.com,
        tfiga@chromium.org, zhengsq@rock-chips.com,
        laurent.pinchart@ideasonboard.com, zyc@rock-chips.com,
        eddie.cai.linux@gmail.com, jeffy.chen@rock-chips.com,
        devicetree@vger.kernel.org, heiko@sntech.de,
        Jacob Chen <jacob2.chen@rock-chips.com>,
        Jacob Chen <cc@rock-chips.com>,
        Allon Huang <allon.huang@rock-chips.com>
References: <20180308094807.9443-1-jacob-chen@iotwrt.com>
 <20180308094807.9443-8-jacob-chen@iotwrt.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <bf0561d3-074f-534b-e0a0-afa180372452@xs4all.nl>
Date: Fri, 9 Mar 2018 15:03:17 +0100
MIME-Version: 1.0
In-Reply-To: <20180308094807.9443-8-jacob-chen@iotwrt.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/03/18 10:47, Jacob Chen wrote:
> From: Jacob Chen <jacob2.chen@rock-chips.com>
> 
> Add the output video driver that accept params from userspace.
> 
> Signed-off-by: Jacob Chen <jacob2.chen@rock-chips.com>
> Signed-off-by: Shunqian Zheng <zhengsq@rock-chips.com>
> Signed-off-by: Yichong Zhong <zyc@rock-chips.com>
> Signed-off-by: Jacob Chen <cc@rock-chips.com>
> Signed-off-by: Eddie Cai <eddie.cai.linux@gmail.com>
> Signed-off-by: Jeffy Chen <jeffy.chen@rock-chips.com>
> Signed-off-by: Allon Huang <allon.huang@rock-chips.com>
> Signed-off-by: Tomasz Figa <tfiga@chromium.org>
> ---
>  drivers/media/platform/rockchip/isp1/isp_params.c | 1539 +++++++++++++++++++++
>  drivers/media/platform/rockchip/isp1/isp_params.h |   49 +
>  2 files changed, 1588 insertions(+)
>  create mode 100644 drivers/media/platform/rockchip/isp1/isp_params.c
>  create mode 100644 drivers/media/platform/rockchip/isp1/isp_params.h
> 
> diff --git a/drivers/media/platform/rockchip/isp1/isp_params.c b/drivers/media/platform/rockchip/isp1/isp_params.c
> new file mode 100644
> index 000000000000..747108e02836
> --- /dev/null
> +++ b/drivers/media/platform/rockchip/isp1/isp_params.c

<snip>

> +static int rkisp1_params_querycap(struct file *file,
> +				  void *priv, struct v4l2_capability *cap)
> +{
> +	struct video_device *vdev = video_devdata(file);
> +
> +	strcpy(cap->driver, DRIVER_NAME);

Use strlcpy!

> +	strlcpy(cap->card, vdev->name, sizeof(cap->card));
> +	strlcpy(cap->bus_info, "platform: " DRIVER_NAME, sizeof(cap->bus_info));
> +
> +	return 0;
> +}
> +
> +/* ISP params video device IOCTLs */
> +static const struct v4l2_ioctl_ops rkisp1_params_ioctl = {
> +	.vidioc_reqbufs = vb2_ioctl_reqbufs,
> +	.vidioc_querybuf = vb2_ioctl_querybuf,
> +	.vidioc_create_bufs = vb2_ioctl_create_bufs,
> +	.vidioc_qbuf = vb2_ioctl_qbuf,
> +	.vidioc_dqbuf = vb2_ioctl_dqbuf,
> +	.vidioc_prepare_buf = vb2_ioctl_prepare_buf,
> +	.vidioc_expbuf = vb2_ioctl_expbuf,
> +	.vidioc_streamon = vb2_ioctl_streamon,
> +	.vidioc_streamoff = vb2_ioctl_streamoff,
> +	.vidioc_enum_fmt_meta_out = rkisp1_params_enum_fmt_meta_out,
> +	.vidioc_g_fmt_meta_out = rkisp1_params_g_fmt_meta_out,
> +	.vidioc_s_fmt_meta_out = rkisp1_params_g_fmt_meta_out,
> +	.vidioc_try_fmt_meta_out = rkisp1_params_g_fmt_meta_out,
> +	.vidioc_querycap = rkisp1_params_querycap,
> +	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
> +	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
> +};
> +
> +static int rkisp1_params_vb2_queue_setup(struct vb2_queue *vq,
> +					 unsigned int *num_buffers,
> +					 unsigned int *num_planes,
> +					 unsigned int sizes[],
> +					 struct device *alloc_devs[])
> +{
> +	struct rkisp1_isp_params_vdev *params_vdev = vq->drv_priv;
> +
> +	*num_buffers = clamp_t(u32, *num_buffers,
> +			       RKISP1_ISP_PARAMS_REQ_BUFS_MIN,
> +			       RKISP1_ISP_PARAMS_REQ_BUFS_MAX);
> +
> +	*num_planes = 1;
> +
> +	sizes[0] = sizeof(struct rkisp1_isp_params_cfg);
> +
> +	INIT_LIST_HEAD(&params_vdev->params);
> +	params_vdev->first_params = true;
> +
> +	return 0;
> +}
> +
> +static void rkisp1_params_vb2_buf_queue(struct vb2_buffer *vb)
> +{
> +	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
> +	struct rkisp1_buffer *params_buf = to_rkisp1_buffer(vbuf);
> +	struct vb2_queue *vq = vb->vb2_queue;
> +	struct rkisp1_isp_params_vdev *params_vdev = vq->drv_priv;
> +	struct rkisp1_isp_params_cfg *new_params;
> +	unsigned long flags;
> +
> +	unsigned int cur_frame_id = -1;
> +	cur_frame_id = atomic_read(&params_vdev->dev->isp_sdev.frm_sync_seq) - 1;
> +
> +	if (params_vdev->first_params) {
> +		new_params = (struct rkisp1_isp_params_cfg *)
> +			(vb2_plane_vaddr(vb, 0));
> +		vbuf->sequence = cur_frame_id;
> +		vb2_buffer_done(&params_buf->vb.vb2_buf, VB2_BUF_STATE_DONE);
> +		params_vdev->first_params = false;
> +		params_vdev->cur_params = *new_params;
> +		return;
> +	}
> +
> +	params_buf->vaddr[0] = vb2_plane_vaddr(vb, 0);
> +	spin_lock_irqsave(&params_vdev->config_lock, flags);
> +	list_add_tail(&params_buf->queue, &params_vdev->params);
> +	spin_unlock_irqrestore(&params_vdev->config_lock, flags);
> +}
> +
> +static int rkisp1_params_vb2_buf_prepare(struct vb2_buffer *vb)
> +{
> +        if (vb2_plane_size(vb, 0) < sizeof(struct rkisp1_isp_params_cfg))
> +                return -EINVAL;
> +
> +        vb2_set_plane_payload(vb, 0, sizeof(struct rkisp1_isp_params_cfg));
> +
> +	return 0;
> +}
> +
> +static void rkisp1_params_vb2_stop_streaming(struct vb2_queue *vq)
> +{
> +	struct rkisp1_isp_params_vdev *params_vdev = vq->drv_priv;
> +	struct rkisp1_buffer *buf;
> +	unsigned long flags;
> +	int i;
> +
> +	/* stop params input firstly */
> +	spin_lock_irqsave(&params_vdev->config_lock, flags);
> +	params_vdev->streamon = false;
> +	spin_unlock_irqrestore(&params_vdev->config_lock, flags);
> +
> +	for (i = 0; i < RKISP1_ISP_PARAMS_REQ_BUFS_MAX; i++) {
> +		spin_lock_irqsave(&params_vdev->config_lock, flags);
> +		if (!list_empty(&params_vdev->params)) {
> +			buf = list_first_entry(&params_vdev->params,
> +					       struct rkisp1_buffer, queue);
> +			list_del(&buf->queue);
> +			spin_unlock_irqrestore(&params_vdev->config_lock,
> +					       flags);
> +		} else {
> +			spin_unlock_irqrestore(&params_vdev->config_lock,
> +					       flags);
> +			break;
> +		}
> +
> +		if (buf)
> +			vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
> +		buf = NULL;
> +	}
> +}
> +
> +static int
> +rkisp1_params_vb2_start_streaming(struct vb2_queue *queue, unsigned int count)
> +{
> +	struct rkisp1_isp_params_vdev *params_vdev = queue->drv_priv;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&params_vdev->config_lock, flags);
> +	params_vdev->streamon = true;
> +	spin_unlock_irqrestore(&params_vdev->config_lock, flags);
> +
> +	return 0;
> +}
> +
> +static struct vb2_ops rkisp1_params_vb2_ops = {
> +	.queue_setup = rkisp1_params_vb2_queue_setup,
> +	.wait_prepare = vb2_ops_wait_prepare,
> +	.wait_finish = vb2_ops_wait_finish,
> +	.buf_queue = rkisp1_params_vb2_buf_queue,
> +	.buf_prepare = rkisp1_params_vb2_buf_prepare,
> +	.start_streaming = rkisp1_params_vb2_start_streaming,
> +	.stop_streaming = rkisp1_params_vb2_stop_streaming,
> +
> +};
> +
> +struct v4l2_file_operations rkisp1_params_fops = {
> +	.mmap = vb2_fop_mmap,
> +	.unlocked_ioctl = video_ioctl2,
> +	.poll = vb2_fop_poll,
> +	.open = v4l2_fh_open,
> +	.release = vb2_fop_release
> +};
> +
> +static int
> +rkisp1_params_init_vb2_queue(struct vb2_queue *q,
> +			     struct rkisp1_isp_params_vdev *params_vdev)
> +{
> +	struct rkisp1_vdev_node *node;
> +
> +	node = queue_to_node(q);
> +
> +	q->type = V4L2_BUF_TYPE_META_OUTPUT;
> +	q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
> +	q->drv_priv = params_vdev;
> +	q->ops = &rkisp1_params_vb2_ops;
> +	q->mem_ops = &vb2_vmalloc_memops;
> +	q->buf_struct_size = sizeof(struct rkisp1_buffer);
> +	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	q->lock = &node->vlock;
> +
> +	return vb2_queue_init(q);
> +}
> +
> +static void rkisp1_init_params_vdev(struct rkisp1_isp_params_vdev *params_vdev)
> +{
> +	params_vdev->vdev_fmt.fmt.meta.dataformat =
> +		V4L2_META_FMT_RK_ISP1_PARAMS;
> +	params_vdev->vdev_fmt.fmt.meta.buffersize =
> +		sizeof(struct rkisp1_isp_params_cfg);
> +}
> +
> +int rkisp1_register_params_vdev(struct rkisp1_isp_params_vdev *params_vdev,
> +				struct v4l2_device *v4l2_dev,
> +				struct rkisp1_device *dev)
> +{
> +	int ret;
> +	struct rkisp1_vdev_node *node = &params_vdev->vnode;
> +	struct video_device *vdev = &node->vdev;
> +
> +	params_vdev->dev = dev;
> +	mutex_init(&node->vlock);
> +	spin_lock_init(&params_vdev->config_lock);
> +
> +	strlcpy(vdev->name, "rkisp1-input-params", sizeof(vdev->name));
> +
> +	video_set_drvdata(vdev, params_vdev);
> +	vdev->ioctl_ops = &rkisp1_params_ioctl;
> +	vdev->fops = &rkisp1_params_fops;
> +	vdev->release = video_device_release_empty;
> +	/*
> +	 * Provide a mutex to v4l2 core. It will be used
> +	 * to protect all fops and v4l2 ioctls.
> +	 */
> +	vdev->lock = &node->vlock;
> +	vdev->v4l2_dev = v4l2_dev;
> +	vdev->queue = &node->buf_queue;
> +	vdev->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_META_OUTPUT;

As mentioned in my previous review: the patches adding Meta Output support
haven't been merged yet. This driver is likely to be the first to need this.

Please add Sakari's patches adding support for META_OUTPUT to this patch series
since it is likely that they will be merged together with this driver.

> +	vdev->vfl_dir = VFL_DIR_TX;
> +	rkisp1_params_init_vb2_queue(vdev->queue, params_vdev);
> +	rkisp1_init_params_vdev(params_vdev);
> +	video_set_drvdata(vdev, params_vdev);
> +
> +	node->pad.flags = MEDIA_PAD_FL_SOURCE;
> +	ret = media_entity_pads_init(&vdev->entity, 1, &node->pad);
> +	if (ret < 0)
> +		goto err_release_queue;
> +	ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
> +	if (ret < 0) {
> +		dev_err(&vdev->dev,
> +			"could not register Video for Linux device\n");
> +		goto err_cleanup_media_entity;
> +	}
> +	return 0;
> +err_cleanup_media_entity:
> +	media_entity_cleanup(&vdev->entity);
> +err_release_queue:
> +	vb2_queue_release(vdev->queue);
> +	return ret;
> +}
> +
> +void rkisp1_unregister_params_vdev(struct rkisp1_isp_params_vdev *params_vdev)
> +{
> +	struct rkisp1_vdev_node *node = &params_vdev->vnode;
> +	struct video_device *vdev = &node->vdev;
> +
> +	video_unregister_device(vdev);
> +	media_entity_cleanup(&vdev->entity);
> +	vb2_queue_release(vdev->queue);
> +}
> diff --git a/drivers/media/platform/rockchip/isp1/isp_params.h b/drivers/media/platform/rockchip/isp1/isp_params.h
> new file mode 100644
> index 000000000000..24602e11014d
> --- /dev/null
> +++ b/drivers/media/platform/rockchip/isp1/isp_params.h
> @@ -0,0 +1,49 @@
> +// SPDX-License-Identifier: (GPL-2.0+ OR MIT)
> +/*
> + * Rockchip isp1 driver
> + *
> + * Copyright (C) 2017 Rockchip Electronics Co., Ltd.
> + */
> +
> +#ifndef _RKISP1_ISP_H
> +#define _RKISP1_ISP_H
> +
> +#include <linux/rkisp1-config.h>
> +#include "common.h"
> +
> +/*
> + * struct rkisp1_isp_subdev - ISP input parameters device
> + *
> + * @cur_params: Current ISP parameters
> + * @first_params: the first params should take effect immediately
> + */
> +struct rkisp1_isp_params_vdev {
> +	struct rkisp1_vdev_node vnode;
> +	struct rkisp1_device *dev;
> +
> +	spinlock_t config_lock;
> +	struct list_head params;
> +	struct rkisp1_isp_params_cfg cur_params;
> +	struct v4l2_format vdev_fmt;
> +	bool streamon;
> +	bool first_params;
> +
> +	enum v4l2_quantization quantization;
> +	enum rkisp1_fmt_raw_pat_type raw_type;
> +};
> +
> +/* config params before ISP streaming */
> +void rkisp1_params_configure_isp(struct rkisp1_isp_params_vdev *params_vdev,
> +			  struct ispsd_in_fmt *in_fmt,
> +			  enum v4l2_quantization quantization);
> +void rkisp1_params_disable_isp(struct rkisp1_isp_params_vdev *params_vdev);
> +
> +int rkisp1_register_params_vdev(struct rkisp1_isp_params_vdev *params_vdev,
> +				struct v4l2_device *v4l2_dev,
> +				struct rkisp1_device *dev);
> +
> +void rkisp1_unregister_params_vdev(struct rkisp1_isp_params_vdev *params_vdev);
> +
> +void rkisp1_params_isr(struct rkisp1_isp_params_vdev *params_vdev, u32 isp_mis);
> +
> +#endif /* _RKISP1_ISP_H */
> 

Regards,

	Hans
