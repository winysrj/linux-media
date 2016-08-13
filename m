Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:56334 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752167AbcHNJZq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Aug 2016 05:25:46 -0400
Subject: Re: [PATCH v3 11/14] media: platform: pxa_camera: make a standalone
 v4l2 device
To: Robert Jarzmik <robert.jarzmik@free.fr>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Jiri Kosina <trivial@kernel.org>
References: <1470684652-16295-1-git-send-email-robert.jarzmik@free.fr>
 <1470684652-16295-12-git-send-email-robert.jarzmik@free.fr>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <c51a3d10-58d5-ef7c-ec9c-60dc70e124f3@xs4all.nl>
Date: Sat, 13 Aug 2016 20:58:28 +0200
MIME-Version: 1.0
In-Reply-To: <1470684652-16295-12-git-send-email-robert.jarzmik@free.fr>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/08/2016 09:30 PM, Robert Jarzmik wrote:

<snip>

> +static int pxa_camera_sensor_bound(struct v4l2_async_notifier *notifier,
> +		     struct v4l2_subdev *subdev,
> +		     struct v4l2_async_subdev *asd)
> +{
> +	int err;
> +	struct v4l2_device *v4l2_dev = notifier->v4l2_dev;
> +	struct pxa_camera_dev *pcdev = v4l2_dev_to_pcdev(v4l2_dev);
> +	struct video_device *vdev = &pcdev->vdev;
> +	struct v4l2_pix_format *pix = &pcdev->current_pix;
> +	struct v4l2_subdev_format format = {
> +		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
> +	};
> +	struct v4l2_mbus_framefmt *mf = &format.format;
> +
> +	dev_info(pcdev_to_dev(pcdev), "%s(): trying to bind a device\n",
> +		 __func__);
> +	mutex_lock(&pcdev->mlock);
> +	*vdev = pxa_camera_videodev_template;
> +	vdev->v4l2_dev = v4l2_dev;
> +	vdev->lock = &pcdev->mlock;
> +	pcdev->sensor = subdev;
> +	pcdev->vdev.queue = &pcdev->vb2_vq;
> +	pcdev->vdev.v4l2_dev = &pcdev->v4l2_dev;

You're missing this line here:

	pcdev->vdev.ctrl_handler = subdev->ctrl_handler;

This ensures that the sensor's controls are exposed to the video device node.

> +	video_set_drvdata(&pcdev->vdev, pcdev);
> +
> +	v4l2_disable_ioctl(vdev, VIDIOC_G_STD);
> +	v4l2_disable_ioctl(vdev, VIDIOC_S_STD);

Since you don't implement vidioc_g/s_std these two lines can be removed.

> +
> +	err = pxa_camera_build_formats(pcdev);
> +	if (err) {
> +		dev_err(pcdev_to_dev(pcdev), "building formats failed: %d\n",
> +			err);
> +		goto out;
> +	}
> +
> +	pcdev->current_fmt = pcdev->user_formats;
> +	pix->field = V4L2_FIELD_NONE;
> +	pix->width = DEFAULT_WIDTH;
> +	pix->height = DEFAULT_HEIGHT;
> +	pix->bytesperline =
> +		soc_mbus_bytes_per_line(pix->width,
> +					pcdev->current_fmt->host_fmt);
> +	pix->sizeimage =
> +		soc_mbus_image_size(pcdev->current_fmt->host_fmt,
> +				    pix->bytesperline, pix->height);
> +	pix->pixelformat = pcdev->current_fmt->host_fmt->fourcc;
> +	v4l2_fill_mbus_format(mf, pix, pcdev->current_fmt->code);
> +	err = sensor_call(pcdev, pad, set_fmt, NULL, &format);
> +	if (err)
> +		goto out;
> +
> +	v4l2_fill_pix_format(pix, mf);
> +	pr_info("%s(): colorspace=0x%x pixfmt=0x%x\n",
> +		__func__, pix->colorspace, pix->pixelformat);
> +
> +	err = pxa_camera_init_videobuf2(pcdev);
> +	if (err)
> +		goto out;
> +
> +	err = video_register_device(&pcdev->vdev, VFL_TYPE_GRABBER, -1);
> +	if (err) {
> +		v4l2_err(v4l2_dev, "register video device failed: %d\n", err);
> +		pcdev->sensor = NULL;
> +	} else {
> +		dev_info(pcdev_to_dev(pcdev),
> +			 "PXA Camera driver attached to camera %s\n",
> +			 subdev->name);
> +		subdev->owner = v4l2_dev->dev->driver->owner;
> +	}
> +out:
> +	mutex_unlock(&pcdev->mlock);
> +	return err;
> +}

Regards,

	Hans
