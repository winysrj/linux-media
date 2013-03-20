Return-path: <linux-media-owner@vger.kernel.org>
Received: from cm-84.215.157.11.getinternet.no ([84.215.157.11]:47169 "EHLO
	server.arpanet.local" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751464Ab3CTJkI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Mar 2013 05:40:08 -0400
Date: Wed, 20 Mar 2013 10:43:26 +0100
From: Jon Arne =?utf-8?Q?J=C3=B8rgensen?= <jonarne@jonarne.no>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Jon Arne =?utf-8?Q?J=C3=B8rgensen?= <jonarne@jonarne.no>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	elezegarcia@gmail.com
Subject: Re: [RFC V1 4/8] smi2021: Add smi2021_v4l2.c
Message-ID: <20130320094326.GK17291@dell.arpanet.local>
References: <1363270024-12127-1-git-send-email-jonarne@jonarne.no>
 <1363270024-12127-5-git-send-email-jonarne@jonarne.no>
 <201303180912.31603.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201303180912.31603.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 18, 2013 at 09:12:31AM +0100, Hans Verkuil wrote:
> On Thu March 14 2013 15:07:00 Jon Arne Jørgensen wrote:
> > This file is responsible for registering the device with the v4l2 subsystem,
> > and the communication with v4l2.
> > Most of the v4l2 ioctls are just passed on to vidbuf2.
> > 
> > Signed-off-by: Jon Arne Jørgensen <jonarne@jonarne.no>
> > ---
> >  drivers/media/usb/smi2021/smi2021_v4l2.c | 566 +++++++++++++++++++++++++++++++
> >  1 file changed, 566 insertions(+)
> >  create mode 100644 drivers/media/usb/smi2021/smi2021_v4l2.c
> > 
> > diff --git a/drivers/media/usb/smi2021/smi2021_v4l2.c b/drivers/media/usb/smi2021/smi2021_v4l2.c
> > new file mode 100644
> > index 0000000..d402093
> > --- /dev/null
> > +++ b/drivers/media/usb/smi2021/smi2021_v4l2.c
> > @@ -0,0 +1,566 @@
> > +/*******************************************************************************
> > + * smi2021_v4l2.c                                                              *
> > + *                                                                             *
> > + * USB Driver for smi2021 - EasyCap                                            *
> > + * USB ID 1c88:003c                                                            *
> > + *                                                                             *
> > + * *****************************************************************************
> > + *
> > + * Copyright 2011-2013 Jon Arne Jørgensen
> > + * <jonjon.arnearne--a.t--gmail.com>
> > + *
> > + * Copyright 2011, 2012 Tony Brown, Michal Demin, Jeffry Johnston
> > + *
> > + * This file is part of SMI2021
> > + * http://code.google.com/p/easycap-somagic-linux/
> > + *
> > + * This program is free software: you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation, either version 2 of the License, or
> > + * (at your option) any later version.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, see <http://www.gnu.org/licenses/>.
> > + *
> > + * This driver is heavily influensed by the STK1160 driver.
> > + * Copyright (C) 2012 Ezequiel Garcia
> > + * <elezegarcia--a.t--gmail.com>
> > + *
> > + */
> > +
> > +#include "smi2021.h"
> > +
> > +static struct smi2021_fmt format[] = {
> 
> const.
> 

Ok

> > +	{
> > +		.name = "16bpp YU2, 4:2:2, packed",
> > +		.fourcc = V4L2_PIX_FMT_UYVY,
> > +		.depth = 16,
> > +	}
> > +};
> > +
> > +static const int inputs = 2;
> > +static struct smi2021_input input[] = {
> > +	{
> > +		.name = "Composite",
> > +		.type = SAA7115_COMPOSITE0,
> > +	},
> > +	{
> > +		.name = "S-Video",
> > +		.type = SAA7115_SVIDEO1,
> > +	}
> > +};
> 
> const
> 

Ditto

> > +
> > +static void smi2021_set_input(struct smi2021_dev *dev)
> > +{
> > +	if (dev->udev == NULL)
> > +		return;
> 
> These udev tests are unnecessary. Once the video_unregister is called no
> new ioctls or file operations (except release()) can ever be issued.
>

Ok.

> > +
> > +	if (dev->ctl_input >= inputs) {
> > +		smi2021_err("BUG: ctl_input to big!\n");
> > +		return;
> > +	}
> > +
> > +	v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_routing,
> > +		input[dev->ctl_input].type, 0, 0);
> > +}
> > +
> > +static int smi2021_start_streaming(struct smi2021_dev *dev)
> > +{
> > +	u8 data[2];
> > +	int i, rc = 0;
> 
> Extra newline.
>

Ok.

I guess I also have to move this data array to the heap?
 
> > +	data[0] = 0x01;
> > +	data[1] = 0x05;
> > +
> > +	if (!dev->udev)
> > +		return -ENODEV;
> > +
> > +	dev->sync_state = HSYNC;
> > +	dev->buf_count = 0;
> > +
> > +	if (mutex_lock_interruptible(&dev->v4l2_lock))
> > +		return -ERESTARTSYS;
> > +
> > +	v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_stream, 1);
> > +
> > +	/* The saa 7115 driver sets these wrong,
> > +	 * this leads to sync issues.
> > +	 * V_GATE1_START
> > +	 * V_GATE1_STOP
> > +	 * V_GATE1_MSB
> > +	 * All these should be 0x00 for this device.
> > +	 */
> > +	smi2021_write_reg(dev, 0x4a, 0x15, 0x00);
> > +	smi2021_write_reg(dev, 0x4a, 0x16, 0x00);
> > +	smi2021_write_reg(dev, 0x4a, 0x17, 0x00);
> > +
> > +	rc = usb_control_msg(dev->udev, usb_sndctrlpipe(dev->udev, 0x00),
> > +			0x01, USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
> > +			0x01, 0x00, data, sizeof(data), 1000);
> > +	if (rc < 0) {
> > +		smi2021_err("Could not start device!\n");
> > +		goto out_unlock;
> > +	}
> > +
> > +	/* It's mandatory to set alt interface before allocating isoc buffer */
> > +	usb_set_interface(dev->udev, 0, 2);
> > +
> > +	smi2021_write_reg(dev, 0, 0x1740, 0x1d);
> > +
> > +	if (!dev->isoc_ctl.num_bufs) {
> > +		rc = smi2021_alloc_isoc(dev);
> > +		if (rc < 0)
> > +			goto out_stop_hw;
> > +	}
> > +
> > +	/* submit urbs and enable IRQ */
> > +	for (i = 0; i < dev->isoc_ctl.num_bufs; i++) {
> > +		rc = usb_submit_urb(dev->isoc_ctl.urb[i], GFP_KERNEL);
> > +		if (rc) {
> > +			smi2021_err("cannot submit urb[%d] (%d)\n", i, rc);
> > +			goto out_uninit;
> > +		}
> > +	}
> > +
> > +	mutex_unlock(&dev->v4l2_lock);
> > +
> > +	smi2021_dbg("Streaming started!");
> > +	return 0;
> > +
> > +out_uninit:
> > +	smi2021_uninit_isoc(dev);
> > +out_stop_hw:
> > +	usb_set_interface(dev->udev, 0, 0);
> > +	smi2021_clear_queue(dev);
> > +
> > +out_unlock:
> > +	mutex_unlock(&dev->v4l2_lock);
> > +
> > +	return rc;
> > +}
> > +
> > +/* Must be called with v4l2_lock hold */
> > +static void smi2021_stop_hw(struct smi2021_dev *dev)
> > +{
> > +	int rc = 0;
> > +	u8 data[] = { 0x01, 0x03 };
> > +
> > +	if (!dev->udev)
> > +		return;
> > +
> > +	usb_set_interface(dev->udev, 0, 0);
> > +
> > +	rc = usb_control_msg(dev->udev, usb_sndctrlpipe(dev->udev, 0x00),
> > +			0x01, USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
> > +			0x01, 0x00, data, sizeof(data), 1000);
> > +	if (rc < 0)
> > +		smi2021_err("Could not stop device!\n");
> > +
> > +	v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_stream, 0);
> > +}
> > +
> > +static int smi2021_stop_streaming(struct smi2021_dev *dev)
> > +{
> > +	/* HACK: Stop the audio subsystem,
> > +	 * without this, the pcm middle-layer will hang waiting for more data.
> > +	 *
> > +	 * Is there a better way to do this?
> > +	 */
> > +	if (dev->pcm_substream && dev->pcm_substream->runtime) {
> > +		struct snd_pcm_runtime *runtime = dev->pcm_substream->runtime;
> > +		if (runtime->status) {
> > +			runtime->status->state = SNDRV_PCM_STATE_DRAINING;
> > +			wake_up(&runtime->sleep);
> > +		}
> > +	}
> > +
> > +	if (mutex_lock_interruptible(&dev->v4l2_lock))
> > +		return -ERESTARTSYS;
> > +
> > +	smi2021_cancel_isoc(dev);
> > +	smi2021_free_isoc(dev);
> > +	smi2021_stop_hw(dev);
> > +	smi2021_clear_queue(dev);
> > +
> > +	smi2021_dbg("Streaming stopped!\n");
> > +
> > +	mutex_unlock(&dev->v4l2_lock);
> > +
> > +	return 0;
> > +}
> > +
> > +static struct v4l2_file_operations smi2021_fops = {
> > +	.owner = THIS_MODULE,
> > +	.open = v4l2_fh_open,
> > +	.release = vb2_fop_release,
> > +	.read = vb2_fop_read,
> > +	.poll = vb2_fop_poll,
> > +	.mmap = vb2_fop_mmap,
> > +	.unlocked_ioctl = video_ioctl2,
> > +};
> > +
> > +/******************************************************************************/
> > +/*                                                                            */
> > +/*          Vidioc IOCTLS                                                     */
> > +/*                                                                            */
> > +/******************************************************************************/
> > +
> > +static int vidioc_enum_fmt_vid_cap(struct file *file, void *priv,
> > +			struct v4l2_fmtdesc *f)
> > +{
> > +	if (f->index != 0)
> > +		return -EINVAL;
> > +
> > +	strlcpy(f->description, format[f->index].name, sizeof(f->description));
> > +	f->pixelformat = format[f->index].fourcc;
> > +
> > +	return 0;
> > +}
> > +
> > +static int vidioc_querycap(struct file *file, void *priv,
> > +			struct v4l2_capability *cap)
> > +{
> > +	struct smi2021_dev *dev = video_drvdata(file);
> > +
> > +	strcpy(cap->driver, "smi2021");
> > +	strcpy(cap->card, "smi2021");
> > +	usb_make_path(dev->udev, cap->bus_info, sizeof(cap->bus_info));
> > +	cap->device_caps =
> > +		V4L2_CAP_VIDEO_CAPTURE |
> > +		V4L2_CAP_STREAMING |
> > +		V4L2_CAP_READWRITE;
> > +	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
> > +
> > +	return 0;
> > +}
> > +
> > +static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
> > +			struct v4l2_format *f)
> > +{
> > +	struct smi2021_dev *dev = video_drvdata(file);
> > +
> > +	f->fmt.pix.pixelformat = dev->fmt->fourcc;
> > +	f->fmt.pix.width = dev->width;
> > +	f->fmt.pix.height = dev->height;
> > +	f->fmt.pix.field = V4L2_FIELD_INTERLACED;
> > +	f->fmt.pix.bytesperline = dev->width * 2;
> > +	f->fmt.pix.sizeimage = dev->height * f->fmt.pix.bytesperline;
> > +	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
> > +	f->fmt.pix.priv = 0;
> > +
> > +	return 0;
> > +}
> > +
> > +static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
> > +			struct v4l2_format *f)
> > +{
> > +	struct smi2021_dev *dev = video_drvdata(file);
> > +
> > +	f->fmt.pix.pixelformat = dev->fmt->fourcc;
> > +	f->fmt.pix.width = dev->width;
> > +	f->fmt.pix.height = dev->height;
> > +	f->fmt.pix.field = V4L2_FIELD_INTERLACED;
> > +	f->fmt.pix.bytesperline = dev->width * 2;
> > +	f->fmt.pix.sizeimage = dev->height * f->fmt.pix.bytesperline;
> > +	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
> > +	f->fmt.pix.priv = 0;
> > +
> > +	return 0;
> > +}
> > +
> > +static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
> > +			struct v4l2_format *f)
> > +{
> > +	struct smi2021_dev *dev = video_drvdata(file);
> > +	struct vb2_queue *q = &dev->vb_vidq;
> > +
> > +	if (vb2_is_busy(q))
> > +		return -EBUSY;
> > +
> > +	vidioc_try_fmt_vid_cap(file, priv, f);
> > +	return 0;
> > +}
> > +
> > +static int vidioc_querystd(struct file *file, void *priv, v4l2_std_id *norm)
> > +{
> > +	struct smi2021_dev *dev = video_drvdata(file);
> > +
> > +	v4l2_device_call_all(&dev->v4l2_dev, 0, video, querystd, norm);
> > +	return 0;
> > +}
> > +
> > +static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *norm)
> > +{
> > +	struct smi2021_dev *dev = video_drvdata(file);
> > +
> > +	*norm = dev->norm;
> > +	return 0;
> > +}
> > +
> > +static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *norm)
> > +{
> > +	struct smi2021_dev *dev = video_drvdata(file);
> > +	struct vb2_queue *q = &dev->vb_vidq;
> > +
> > +	if (vb2_is_busy(q))
> > +		return -EBUSY;
> > +
> > +	if (!dev->udev)
> > +		return -ENODEV;
> > +
> > +	dev->norm = *norm;
> > +	if (dev->norm & V4L2_STD_525_60) {
> > +		dev->width = SMI2021_BYTES_PER_LINE / 2;
> > +		dev->height = SMI2021_NTSC_LINES;
> > +	} else if (dev->norm & V4L2_STD_625_50) {
> > +		dev->width = SMI2021_BYTES_PER_LINE / 2;
> > +		dev->height =  SMI2021_PAL_LINES;
> > +	} else {
> > +		smi2021_err("Invalid standard\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_std, dev->norm);
> > +	return 0;
> > +}
> > +
> > +static int vidioc_enum_input(struct file *file, void *priv,
> > +				struct v4l2_input *i)
> > +{
> > +	struct smi2021_dev *dev = video_drvdata(file);
> > +
> > +	if (i->index >= inputs)
> > +		return -EINVAL;
> > +
> > +	strlcpy(i->name, input[i->index].name, sizeof(i->name));
> > +	i->type = V4L2_INPUT_TYPE_CAMERA;
> > +	i->std = dev->vdev.tvnorms;
> > +	return 0;
> > +}
> > +
> > +static int vidioc_g_input(struct file *file, void *priv, unsigned int *i)
> > +{
> > +	struct smi2021_dev *dev = video_drvdata(file);
> 
> newline
>
> > +	*i = dev->ctl_input;
> > +	return 0;
> > +}
> > +
> > +static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
> > +{
> > +	struct smi2021_dev *dev = video_drvdata(file);
> > +
> > +	if (i >= inputs)
> > +		return -EINVAL;
> > +
> > +	dev->ctl_input = i;
> > +	smi2021_set_input(dev);
> > +
> > +	return 0;
> > +}
> > +
> > +static int vidioc_g_chip_ident(struct file *file, void *priv,
> > +			struct v4l2_dbg_chip_ident *chip)
> > +{
> > +	switch (chip->match.type) {
> > +	case V4L2_CHIP_MATCH_HOST:
> > +		chip->ident = V4L2_IDENT_NONE;
> > +		chip->revision = 0;
> > +		return 0;
> > +	default:
> > +		return -EINVAL;
> > +	}
> > +}
> > +
> > +static const struct v4l2_ioctl_ops smi2021_ioctl_ops = {
> > +	.vidioc_querycap		= vidioc_querycap,
> > +	.vidioc_enum_fmt_vid_cap	= vidioc_enum_fmt_vid_cap,
> > +	.vidioc_g_fmt_vid_cap		= vidioc_g_fmt_vid_cap,
> > +	.vidioc_try_fmt_vid_cap		= vidioc_try_fmt_vid_cap,
> > +	.vidioc_s_fmt_vid_cap		= vidioc_s_fmt_vid_cap,
> > +	.vidioc_querystd		= vidioc_querystd,
> > +	.vidioc_g_std			= vidioc_g_std,
> > +	.vidioc_s_std			= vidioc_s_std,
> > +	.vidioc_enum_input		= vidioc_enum_input,
> > +	.vidioc_g_input			= vidioc_g_input,
> > +	.vidioc_s_input			= vidioc_s_input,
> > +
> > +	/* vb2 handle these */
> > +	.vidioc_reqbufs			= vb2_ioctl_reqbufs,
> > +	.vidioc_create_bufs		= vb2_ioctl_create_bufs,
> > +	.vidioc_querybuf		= vb2_ioctl_querybuf,
> > +	.vidioc_qbuf			= vb2_ioctl_qbuf,
> > +	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
> > +	.vidioc_streamon		= vb2_ioctl_streamon,
> > +	.vidioc_streamoff		= vb2_ioctl_streamoff,
> > +
> > +	.vidioc_log_status		= v4l2_ctrl_log_status,
> > +	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
> > +	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
> > +	.vidioc_g_chip_ident		= vidioc_g_chip_ident,
> > +
> > +};
> > +
> > +/******************************************************************************/
> > +/*                                                                            */
> > +/*          Videobuf2 operations                                              */
> > +/*                                                                            */
> > +/******************************************************************************/
> > +static int queue_setup(struct vb2_queue *vq,
> > +				const struct v4l2_format *v4l2_fmt,
> > +				unsigned int *nbuffers, unsigned int *nplanes,
> > +				unsigned int sizes[], void *alloc_ctxs[])
> > +{
> > +	struct smi2021_dev *dev = vb2_get_drv_priv(vq);
> > +	unsigned long size;
> > +
> > +	size = dev->width * dev->height * 2;
> > +
> > +	*nbuffers = clamp_t(unsigned int, *nbuffers, 2, 4);
> > +
> > +	/* Packed color format */
> > +	*nplanes = 1;
> > +	sizes[0] = size;
> > +
> > +	return 0;
> > +}
> > +
> > +static void buffer_queue(struct vb2_buffer *vb)
> > +{
> > +	unsigned long flags;
> > +	struct smi2021_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
> > +	struct smi2021_buffer *buf = container_of(vb, struct smi2021_buffer,
> > +							vb);
> 
> Just put this in one line, the dangling vb looks odd.
>

Ok,
are you sure no one will kill me for breaking the 80
characters per line limit?

> > +
> > +	spin_lock_irqsave(&dev->buf_lock, flags);
> > +	if (!dev->udev) {
> > +		/*
> > +		 * If the device is disconnected return the buffer to userspace
> > +		 * directly. The next QBUF call will fail with -ENODEV.
> > +		 */
> > +		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
> > +	} else {
> > +		buf->mem = vb2_plane_vaddr(vb, 0);
> > +		buf->length = vb2_plane_size(vb, 0);
> > +
> > +		buf->pos = 0;
> > +		buf->trc_av = 0;
> > +		buf->in_blank = true;
> > +		buf->second_field = false;
> > +
> > +		if (buf->length < dev->width * dev->height * 2)
> > +			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
> > +		else
> > +			list_add_tail(&buf->list, &dev->avail_bufs);
> > +	}
> > +	spin_unlock_irqrestore(&dev->buf_lock, flags);
> > +}
> > +
> > +static int start_streaming(struct vb2_queue *vq, unsigned int count)
> > +{
> > +	struct smi2021_dev *dev = vb2_get_drv_priv(vq);
> 
> newline
> 
> > +	return smi2021_start_streaming(dev);
> 
> Why not move smi2021_start_streaming in here?
> 

That is a good question, I'll do that.

> > +}
> > +
> > +static int stop_streaming(struct vb2_queue *vq)
> > +{
> > +	struct smi2021_dev *dev = vb2_get_drv_priv(vq);
> 
> newline
> 
> > +	return smi2021_stop_streaming(dev);
> 
> same question.
> 

Same answer.

> > +}
> > +
> > +static struct vb2_ops smi2021_video_qops = {
> > +	.queue_setup		= queue_setup,
> > +	.buf_queue		= buffer_queue,
> > +	.start_streaming	= start_streaming,
> > +	.stop_streaming		= stop_streaming,
> > +	.wait_prepare		= vb2_ops_wait_prepare,
> > +	.wait_finish		= vb2_ops_wait_finish,
> > +};
> > +
> > +static struct video_device v4l2_template = {
> > +	.name			= "easycap_smi2021_dc60",
> > +	.tvnorms		= V4L2_STD_625_50 | V4L2_STD_525_60,
> 
> Use V4L2_STD_ALL.
> 

Ok

> > +	.fops			= &smi2021_fops,
> > +	.ioctl_ops		= &smi2021_ioctl_ops,
> > +	.release		= video_device_release_empty,
> > +};
> > +
> > +/* Must be called with both v4l2_lock and vb_queue_lock hold */
> > +void smi2021_clear_queue(struct smi2021_dev *dev)
> > +{
> > +	struct smi2021_buffer *buf;
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&dev->buf_lock, flags);
> > +	while (!list_empty(&dev->avail_bufs)) {
> > +		buf = list_first_entry(&dev->avail_bufs,
> > +			struct smi2021_buffer, list);
> > +		list_del(&buf->list);
> > +		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
> > +	}
> > +	dev->isoc_ctl.buf = NULL;
> > +	spin_unlock_irqrestore(&dev->buf_lock, flags);
> > +}
> > +
> > +int smi2021_vb2_setup(struct smi2021_dev *dev)
> > +{
> > +	int rc;
> > +	struct vb2_queue *q;
> > +
> > +	q = &dev->vb_vidq;
> > +	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> > +	q->io_modes = VB2_READ | VB2_MMAP | VB2_USERPTR;
> > +	q->drv_priv = dev;
> > +	q->buf_struct_size = sizeof(struct smi2021_buffer);
> > +	q->ops = &smi2021_video_qops;
> > +	q->mem_ops = &vb2_vmalloc_memops;
> > +
> > +	rc = vb2_queue_init(q);
> > +	if (rc < 0)
> > +		return rc;
> > +
> > +	/* Initialize video dma queue */
> > +	INIT_LIST_HEAD(&dev->avail_bufs);
> > +
> > +	return 0;
> > +}
> > +
> > +int smi2021_video_register(struct smi2021_dev *dev)
> > +{
> > +	int rc;
> > +
> > +	dev->vdev = v4l2_template;
> > +	dev->vdev.debug = 0;
> 
> No need for this, it's already 0.
> 

I had it there to make it easy for me to enable debug :)

> > +	dev->vdev.queue = &dev->vb_vidq;
> > +
> > +	dev->vdev.lock = &dev->v4l2_lock;
> > +	dev->vdev.queue->lock = &dev->vb_queue_lock;
> > +
> > +	dev->vdev.v4l2_dev = &dev->v4l2_dev;
> > +	set_bit(V4L2_FL_USE_FH_PRIO, &dev->vdev.flags);
> > +
> > +	/* PAL is default */
> > +	dev->norm = V4L2_STD_PAL;
> > +	dev->width = SMI2021_BYTES_PER_LINE / 2;
> > +	dev->height = SMI2021_PAL_LINES;
> > +
> > +	dev->fmt = &format[0];
> > +
> > +	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_std, dev->norm);
> > +	smi2021_set_input(dev);
> > +
> > +	video_set_drvdata(&dev->vdev, dev);
> > +	rc = video_register_device(&dev->vdev, VFL_TYPE_GRABBER, -1);
> > +	if (rc < 0) {
> > +		smi2021_err("video_register_device failed %d\n", rc);
> > +		return rc;
> > +	}
> > +
> > +	v4l2_info(&dev->v4l2_dev, "V4L2 device registered as %s\n",
> > +		video_device_node_name(&dev->vdev));
> > +
> > +	return 0;
> > +}
> > 
> 
> Regards,
> 
> 	Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
