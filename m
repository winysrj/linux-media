Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:39748 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965746AbaLLKQN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Dec 2014 05:16:13 -0500
Message-ID: <548AC061.3050700@xs4all.nl>
Date: Fri, 12 Dec 2014 11:16:01 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Shuah Khan <shuahkh@osg.samsung.com>
Subject: [REVIEW] au0828-video.c
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shuah,

This is the video.c review with your patch applied.

> /*
>  * Auvitek AU0828 USB Bridge (Analog video support)
>  *
>  * Copyright (C) 2009 Devin Heitmueller <dheitmueller@linuxtv.org>
>  * Copyright (C) 2005-2008 Auvitek International, Ltd.
>  *
>  * This program is free software; you can redistribute it and/or
>  * modify it under the terms of the GNU General Public License
>  * As published by the Free Software Foundation; either version 2
>  * of the License, or (at your option) any later version.
>  *
>  * This program is distributed in the hope that it will be useful,
>  * but WITHOUT ANY WARRANTY; without even the implied warranty of
>  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>  * GNU General Public License for more details.
>  *
>  * You should have received a copy of the GNU General Public License
>  * along with this program; if not, write to the Free Software
>  * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
>  * 02110-1301, USA.
>  */
> 
> /* Developer Notes:
>  *
>  * VBI support is not yet working

I'll see if I can get this to work quickly. If not, then we should
probably just strip the VBI support from this driver. It's pointless to
have non-functioning VBI support.

>  * The hardware scaler supported is unimplemented
>  * AC97 audio support is unimplemented (only i2s audio mode)
>  *
>  */
> 
> #include "au0828.h"
> 
> #include <linux/module.h>
> #include <linux/slab.h>
> #include <linux/init.h>
> #include <linux/device.h>
> #include <media/v4l2-common.h>
> #include <media/v4l2-ioctl.h>
> #include <media/v4l2-event.h>
> #include <media/tuner.h>
> #include "au0828-reg.h"

<snip>

> static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
> 		       unsigned int *nbuffers, unsigned int *nplanes,
> 		       unsigned int sizes[], void *alloc_ctxs[])
> {
> 	struct au0828_dev *dev = vb2_get_drv_priv(vq);
> 	unsigned long size;
> 
> 	if (fmt)
> 		size = fmt->fmt.pix.sizeimage;
> 	else
> 		size =
> 		    (dev->width * dev->height * dev->bytesperline + 7) >> 3;

This is wrong. It should be 'size = dev->bytesperline * dev->height;'


If fmt is set, then you need to check if the fmt size is large enough for
the current format.

> 
> 	if (size == 0)

This should be 'size < img_size'.

> 		return -EINVAL;
> 
> 	if (0 == *nbuffers)
> 		*nbuffers = 32;

Bogus check.

> 
> 	*nplanes = 1;
> 	sizes[0] = size;
> 
> 	return 0;
> }

I would rewrite this function as:

{      
       struct au0828_dev *dev = vb2_get_drv_priv(vq);
       unsigned img_size = dev->bytesperline * dev->height;
       unsigned long size;

       size = fmt ? fmt->fmt.pix.sizeimage : img_size;
       if (size < img_size)
               return -EINVAL;
                   
       *nplanes = 1;
       sizes[0] = size;
       return 0;
}

> 
> static int
> buffer_prepare(struct vb2_buffer *vb)
> {
> 	struct au0828_buffer *buf = container_of(vb, struct au0828_buffer, vb);
> 	struct au0828_dev    *dev = vb2_get_drv_priv(vb->vb2_queue);
> 
> 	buf->length = (dev->width * dev->height * 16 + 7) >> 3;

Use buf->length = dev->bytesperline * dev->height;

> 
> 	if (vb2_plane_size(vb, 0) < buf->length) {
> 		pr_err("%s data will not fit into plane (%lu < %lu)\n",
> 			__func__, vb2_plane_size(vb, 0), buf->length);
> 		return -EINVAL;
> 	}
> 	vb2_set_plane_payload(&buf->vb, 0, buf->length);
> 	return 0;
> }
> 
> static void
> buffer_queue(struct vb2_buffer *vb)
> {
> 	struct au0828_buffer    *buf     = container_of(vb,
> 							struct au0828_buffer,
> 							vb);
> 	struct au0828_dev       *dev     = vb2_get_drv_priv(vb->vb2_queue);
> 	struct au0828_dmaqueue  *vidq    = &dev->vidq;
> 	unsigned long flags = 0;
> 
> 	buf->mem = vb2_plane_vaddr(vb, 0);
> 	buf->length = vb2_plane_size(vb, 0);
> 
> 	spin_lock_irqsave(&dev->slock, flags);
> 	list_add_tail(&buf->list, &vidq->active);
> 	spin_unlock_irqrestore(&dev->slock, flags);
> }
> 
> static int au0828_i2s_init(struct au0828_dev *dev)
> {
> 	/* Enable i2s mode */
> 	au0828_writereg(dev, AU0828_AUDIOCTRL_50C, 0x01);
> 	return 0;
> }
> 
> /*
>  * Auvitek au0828 analog stream enable
>  */
> static int au0828_analog_stream_enable(struct au0828_dev *d)
> {
> 	struct usb_interface *iface;
> 	int ret, h, w;
> 
> 	dprintk(1, "au0828_analog_stream_enable called\n");
> 
> 	iface = usb_ifnum_to_if(d->usbdev, 0);
> 	if (iface && iface->cur_altsetting->desc.bAlternateSetting != 5) {
> 		dprintk(1, "Changing intf#0 to alt 5\n");
> 		/* set au0828 interface0 to AS5 here again */
> 		ret = usb_set_interface(d->usbdev, 0, 5);
> 		if (ret < 0) {
> 			pr_info("Au0828 can't set alt setting to 5!\n");
> 			return -EBUSY;
> 		}
> 	}
> 
> 	h = d->height / 2 + 2;
> 	w = d->width * 2;
> 
> 	au0828_writereg(d, AU0828_SENSORCTRL_VBI_103, 0x00);
> 	au0828_writereg(d, 0x106, 0x00);
> 	/* set x position */
> 	au0828_writereg(d, 0x110, 0x00);
> 	au0828_writereg(d, 0x111, 0x00);
> 	au0828_writereg(d, 0x114, w & 0xff);
> 	au0828_writereg(d, 0x115, w >> 8);
> 	/* set y position */
> 	au0828_writereg(d, 0x112, 0x00);
> 	au0828_writereg(d, 0x113, 0x00);
> 	au0828_writereg(d, 0x116, h & 0xff);
> 	au0828_writereg(d, 0x117, h >> 8);
> 	au0828_writereg(d, AU0828_SENSORCTRL_100, 0xb3);
> 
> 	return 0;
> }
> 
> static int au0828_analog_stream_disable(struct au0828_dev *d)
> {
> 	dprintk(1, "au0828_analog_stream_disable called\n");
> 	au0828_writereg(d, AU0828_SENSORCTRL_100, 0x0);
> 	return 0;
> }
> 
> static void au0828_analog_stream_reset(struct au0828_dev *dev)
> {
> 	dprintk(1, "au0828_analog_stream_reset called\n");
> 	au0828_writereg(dev, AU0828_SENSORCTRL_100, 0x0);
> 	mdelay(30);
> 	au0828_writereg(dev, AU0828_SENSORCTRL_100, 0xb3);
> }
> 
> /*
>  * Some operations needs to stop current streaming
>  */
> static int au0828_stream_interrupt(struct au0828_dev *dev)
> {
> 	int ret = 0;
> 
> 	dev->stream_state = STREAM_INTERRUPT;
> 	if (dev->dev_state == DEV_DISCONNECTED)
> 		return -ENODEV;
> 	else if (ret) {
> 		dev->dev_state = DEV_MISCONFIGURED;
> 		dprintk(1, "%s device is misconfigured!\n", __func__);
> 		return ret;
> 	}
> 	return 0;
> }
> 
> int au0828_start_analog_streaming(struct vb2_queue *vq, unsigned int count)
> {
> 	struct au0828_dev *dev = vb2_get_drv_priv(vq);
> 	int rc = 0;
> 
> 	dprintk(1, "au0828_start_analog_streaming called %d\n",
> 		dev->streaming_users);
> 
> 	/* Make sure streaming is not already in progress for this type
> 	   of filehandle (e.g. video, vbi) */
> 	if (vb2_is_streaming(vq))
> 		return -EBUSY;

Can never happen, so this test can be removed.

> 

You need to initialize the counters:

       if (vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
               dev->field_count = 0;
       else
               dev->vbi_field_count = 0;

I would also recommend renaming 'field' to 'frame', since you're counting
frames, not fields.


> 	if (dev->streaming_users == 0) {
> 		/* If we were doing ac97 instead of i2s, it would go here...*/
> 		au0828_i2s_init(dev);
> 		rc = au0828_init_isoc(dev, AU0828_ISO_PACKETS_PER_URB,
> 				   AU0828_MAX_ISO_BUFS, dev->max_pkt_size,
> 				   au0828_isoc_copy);
> 		if (rc < 0) {
> 			pr_info("au0828_init_isoc failed\n");
> 			return rc;
> 		}
> 
> 		if (vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
> 			v4l2_device_call_all(&dev->v4l2_dev, 0, video,
> 						s_stream, 1);
> 			dev->vid_timeout_running = 1;
> 			mod_timer(&dev->vid_timeout, jiffies + (HZ / 10));
> 		} else if (vq->type == V4L2_BUF_TYPE_VBI_CAPTURE) {
> 			dev->vbi_timeout_running = 1;
> 			mod_timer(&dev->vbi_timeout, jiffies + (HZ / 10));
> 		}
> 	}
> 	dev->streaming_users++;
> 	return rc;
> }
> 
> static void au0828_stop_streaming(struct vb2_queue *vq)
> {
> 	struct au0828_dev *dev = vb2_get_drv_priv(vq);
> 	struct au0828_dmaqueue *vidq = &dev->vidq;
> 	unsigned long flags = 0;
> 	int i;
> 
> 	dprintk(1, "au0828_stop_streaming called %d\n", dev->streaming_users);
> 
> 	if (!vb2_is_streaming(vq))
> 		return;

Unnecessary test.

> 
> 	if (dev->streaming_users-- == 1)
> 		au0828_uninit_isoc(dev);
> 	dprintk(1, "au0828_stop_streaming %d\n", dev->streaming_users);
> 
> 	spin_lock_irqsave(&dev->slock, flags);
> 	if (dev->isoc_ctl.buf != NULL) {
> 		vb2_buffer_done(&dev->isoc_ctl.buf->vb, VB2_BUF_STATE_ERROR);
> 		dev->isoc_ctl.buf = NULL;
> 	}
> 	while (!list_empty(&vidq->active)) {
> 		struct au0828_buffer *buf;
> 
> 		buf = list_entry(vidq->active.next, struct au0828_buffer, list);
> 		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
> 		list_del(&buf->list);
> 	}
> 
> 	dev->vid_timeout_running = 0;
> 	del_timer_sync(&dev->vid_timeout);
> 
> 	v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_stream, 0);
> 
> 	for (i = 0; i < AU0828_MAX_INPUT; i++) {
> 		if (AUVI_INPUT(i).audio_setup == NULL)
> 			continue;
> 		(AUVI_INPUT(i).audio_setup)(dev, 0);
> 	}
> 	spin_unlock_irqrestore(&dev->slock, flags);

Very bad. This unlock should go before the 'dev->vid_timeout_running = 0;' line.
The way it is now the lines between the spinlock run without interrupts, so
calls like del_timer_sync() will complain about scheduling in atomic context.

Hint: you should turn on at least the basic lock checks that the kernel offers
when testing.

> }
> 
> void au0828_stop_vbi_streaming(struct vb2_queue *vq)
> {
> 	struct au0828_dev *dev = vb2_get_drv_priv(vq);
> 	struct au0828_dmaqueue *vbiq = &dev->vbiq;
> 	unsigned long flags = 0;
> 
> 	dprintk(1, "au0828_stop_vbi_streaming called %d\n",
> 		dev->streaming_users);
> 	if (!vb2_is_streaming(vq))
> 		return;
> 
> 	if (dev->streaming_users-- == 1)
> 		au0828_uninit_isoc(dev);
> 	dprintk(1, "au0828_stop_vbi_streaming %d\n", dev->streaming_users);
> 
> 	spin_lock_irqsave(&dev->slock, flags);
> 	if (dev->isoc_ctl.vbi_buf != NULL) {
> 		vb2_buffer_done(&dev->isoc_ctl.vbi_buf->vb,
> 				VB2_BUF_STATE_ERROR);
> 		dev->isoc_ctl.vbi_buf = NULL;
> 	}
> 	while (!list_empty(&vbiq->active)) {
> 		struct au0828_buffer *buf;
> 
> 		buf = list_entry(vbiq->active.next, struct au0828_buffer, list);
> 		list_del(&buf->list);
> 		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
> 	}
> 
> 	dev->vbi_timeout_running = 0;
> 	del_timer_sync(&dev->vbi_timeout);
> 
> 	spin_unlock_irqrestore(&dev->slock, flags);

Same problem here, move up the spin_unlock to before the 'dev->vbi_timeout_running = 0;'
line.

> }
> 
> static struct vb2_ops au0828_video_qops = {
> 	.queue_setup     = queue_setup,
> 	.buf_prepare     = buffer_prepare,
> 	.buf_queue       = buffer_queue,
> 	.start_streaming = au0828_start_analog_streaming,
> 	.stop_streaming  = au0828_stop_streaming,
> 	.wait_prepare    = vb2_ops_wait_prepare,
> 	.wait_finish     = vb2_ops_wait_finish,
> };
> 
> /* ------------------------------------------------------------------
>    V4L2 interface
>    ------------------------------------------------------------------*/
> /*
>  * au0828_analog_unregister
>  * unregister v4l2 devices
>  */
> void au0828_analog_unregister(struct au0828_dev *dev)
> {
> 	dprintk(1, "au0828_analog_unregister called\n");
> 	mutex_lock(&au0828_sysfs_lock);
> 
> 	if (dev->vdev)
> 		video_unregister_device(dev->vdev);
> 	if (dev->vbi_dev)
> 		video_unregister_device(dev->vbi_dev);
> 
> 	mutex_unlock(&au0828_sysfs_lock);
> }
> 
> /* This function ensures that video frames continue to be delivered even if
>    the ITU-656 input isn't receiving any data (thereby preventing applications
>    such as tvtime from hanging) */

Why would tvtime be hanging? Make a separate patch that just removes all this
timeout nonsense. If there are no frames, then tvtime (and any other app) should
just wait for frames to arrive. And ctrl-C should always be able to break the app
(or they can timeout themselves).

It's not the driver's responsibility to do this and it only makes the code overly
complex.

> static void au0828_vid_buffer_timeout(unsigned long data)
> {
> 	struct au0828_dev *dev = (struct au0828_dev *) data;
> 	struct au0828_dmaqueue *dma_q = &dev->vidq;
> 	struct au0828_buffer *buf;
> 	unsigned char *vid_data;
> 	unsigned long flags = 0;
> 
> 	spin_lock_irqsave(&dev->slock, flags);
> 
> 	buf = dev->isoc_ctl.buf;
> 	if (buf != NULL) {
> 		vid_data = vb2_plane_vaddr(&buf->vb, 0);
> 		memset(vid_data, 0x00, buf->length); /* Blank green frame */
> 		buffer_filled(dev, dma_q, buf);
> 	}
> 	get_next_buf(dma_q, &buf);
> 
> 	if (dev->vid_timeout_running == 1)
> 		mod_timer(&dev->vid_timeout, jiffies + (HZ / 10));
> 
> 	spin_unlock_irqrestore(&dev->slock, flags);
> }
> 
> static void au0828_vbi_buffer_timeout(unsigned long data)
> {
> 	struct au0828_dev *dev = (struct au0828_dev *) data;
> 	struct au0828_dmaqueue *dma_q = &dev->vbiq;
> 	struct au0828_buffer *buf;
> 	unsigned char *vbi_data;
> 	unsigned long flags = 0;
> 
> 	spin_lock_irqsave(&dev->slock, flags);
> 
> 	buf = dev->isoc_ctl.vbi_buf;
> 	if (buf != NULL) {
> 		vbi_data = vb2_plane_vaddr(&buf->vb, 0);
> 		memset(vbi_data, 0x00, buf->length);
> 		vbi_buffer_filled(dev, dma_q, buf);
> 	}
> 	vbi_get_next_buf(dma_q, &buf);
> 
> 	if (dev->vbi_timeout_running == 1)
> 		mod_timer(&dev->vbi_timeout, jiffies + (HZ / 10));
> 	spin_unlock_irqrestore(&dev->slock, flags);
> }
> 
> static int au0828_v4l2_open(struct file *filp)
> {
> 	struct video_device *vdev = video_devdata(filp);
> 	struct au0828_dev *dev = video_drvdata(filp);
> 	int type;
> 	int ret = 0;
> 
> 	switch (vdev->vfl_type) {
> 	case VFL_TYPE_GRABBER:
> 		type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> 		break;
> 	case VFL_TYPE_VBI:
> 		type = V4L2_BUF_TYPE_VBI_CAPTURE;
> 		break;
> 	default:
> 		return -EINVAL;
> 	}
> 
> 	dprintk(1,
> 		"%s called std_set %d dev_state %d stream users %d users %d\n",
> 		__func__, dev->std_set_in_tuner_core, dev->dev_state,
> 		dev->streaming_users, dev->users);
> 
> 	if (mutex_lock_interruptible(&dev->lock))
> 		return -ERESTARTSYS;
> 
> 	ret = v4l2_fh_open(filp);
> 	if (ret) {
> 		au0828_isocdbg("%s: v4l2_fh_open() returned error %d\n",
> 				__func__, ret);
> 		mutex_unlock(&dev->lock);
> 		return ret;
> 	}
> 
> 	if (dev->users == 0) {

Replace with 'v4l2_fh_is_singular_file(filp)'. That way you can drop the user field.
This can be a separate patch.

> 		au0828_analog_stream_enable(dev);
> 		au0828_analog_stream_reset(dev);
> 		dev->stream_state = STREAM_OFF;
> 		dev->dev_state |= DEV_INITIALIZED;
> 	}
> 	dev->users++;
> 	mutex_unlock(&dev->lock);
> 	return ret;
> }
> 
> static int au0828_v4l2_close(struct file *filp)
> {
> 	int ret;
> 	struct au0828_dev *dev = video_drvdata(filp);
> 	struct video_device *vdev = video_devdata(filp);
> 
> 	dprintk(1,
> 		"%s called std_set %d dev_state %d stream users %d users %d\n",
> 		__func__, dev->std_set_in_tuner_core, dev->dev_state,
> 		dev->streaming_users, dev->users);
> 
> 	vb2_fop_release(filp);

Drop this vb2_fop_release() call, will move to the end of the function.

> 	mutex_lock(&dev->lock);

Change to:

	mutex_lock(&dev->lock);

> 	if (vdev->vfl_type == VFL_TYPE_GRABBER && dev->vid_timeout_running) {
> 		/* Cancel timeout thread in case they didn't call streamoff */
> 		dev->vid_timeout_running = 0;
> 		del_timer_sync(&dev->vid_timeout);
> 	} else if (vdev->vfl_type == VFL_TYPE_VBI &&
> 			dev->vbi_timeout_running) {
> 		/* Cancel timeout thread in case they didn't call streamoff */
> 		dev->vbi_timeout_running = 0;
> 		del_timer_sync(&dev->vbi_timeout);
> 	}
> 
> 	if (dev->dev_state == DEV_DISCONNECTED)
> 		goto end;
> 
> 	if (dev->users == 1) {

And:

	if (v4l2_fh_is_singular_file(filp))

> 		/* Save some power by putting tuner to sleep */
> 		v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_power, 0);
> 		dev->std_set_in_tuner_core = 0;
> 
> 		/* When close the device, set the usb intf0 into alt0 to free
> 		   USB bandwidth */
> 		ret = usb_set_interface(dev->usbdev, 0, 0);
> 		if (ret < 0)
> 			pr_info("Au0828 can't set alternate to 0!\n");
> 	}
> end:

And the release goes here:

	_vb2_fop_release(filp, NULL);

> 	dev->users--;
> 	mutex_unlock(&dev->lock);
> 	wake_up_interruptible_nr(&dev->open, 1);

Huh? Seems unused and certainly looks very bogus.

> 	return 0;
> }
> 
> /* Must be called with dev->lock held */
> static void au0828_init_tuner(struct au0828_dev *dev)
> {
> 	struct v4l2_frequency f = {
> 		.frequency = dev->ctrl_freq,
> 		.type = V4L2_TUNER_ANALOG_TV,
> 	};
> 
> 	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
> 		dev->std_set_in_tuner_core, dev->dev_state);
> 
> 	if (dev->std_set_in_tuner_core)
> 		return;
> 	dev->std_set_in_tuner_core = 1;
> 	i2c_gate_ctrl(dev, 1);
> 	/* If we've never sent the standard in tuner core, do so now.
> 	   We don't do this at device probe because we don't want to
> 	   incur the cost of a firmware load */
> 	v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_std, dev->std);
> 	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_frequency, &f);
> 	i2c_gate_ctrl(dev, 0);
> }
> 
> static int au0828_set_format(struct au0828_dev *dev, unsigned int cmd,
> 			     struct v4l2_format *format)
> {
> 	int ret;
> 	int width = format->fmt.pix.width;
> 	int height = format->fmt.pix.height;
> 
> 	/* If they are demanding a format other than the one we support,
> 	   bail out (tvtime asks for UYVY and then retries with YUYV) */
> 	if (format->fmt.pix.pixelformat != V4L2_PIX_FMT_UYVY)
> 		return -EINVAL;
> 
> 	/* format->fmt.pix.width only support 720 and height 480 */
> 	if (width != 720)
> 		width = 720;
> 	if (height != 480)
> 		height = 480;
> 
> 	format->fmt.pix.width = width;
> 	format->fmt.pix.height = height;
> 	format->fmt.pix.pixelformat = V4L2_PIX_FMT_UYVY;
> 	format->fmt.pix.bytesperline = width * 2;
> 	format->fmt.pix.sizeimage = width * height * 2;
> 	format->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
> 	format->fmt.pix.field = V4L2_FIELD_INTERLACED;
> 	format->fmt.pix.priv = 0;
> 
> 	if (cmd == VIDIOC_TRY_FMT)
> 		return 0;
> 
> 	/* maybe set new image format, driver current only support 720*480 */
> 	dev->width = width;
> 	dev->height = height;
> 	dev->frame_size = width * height * 2;
> 	dev->field_size = width * height;
> 	dev->bytesperline = width * 2;
> 
> 	if (dev->stream_state == STREAM_ON) {
> 		dprintk(1, "VIDIOC_SET_FMT: interrupting stream!\n");
> 		ret = au0828_stream_interrupt(dev);
> 		if (ret != 0) {
> 			dprintk(1, "error interrupting video stream!\n");
> 			return ret;
> 		}
> 	}
> 
> 	au0828_analog_stream_enable(dev);
> 
> 	return 0;
> }
> 
> static int vidioc_querycap(struct file *file, void  *priv,
> 			   struct v4l2_capability *cap)
> {
> 	struct video_device *vdev = video_devdata(file);
> 	struct au0828_dev *dev = video_drvdata(file);
> 
> 	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
> 		dev->std_set_in_tuner_core, dev->dev_state);
> 
> 	strlcpy(cap->driver, "au0828", sizeof(cap->driver));
> 	strlcpy(cap->card, dev->board.name, sizeof(cap->card));
> 	usb_make_path(dev->usbdev, cap->bus_info, sizeof(cap->bus_info));
> 
> 	/* set the device capabilities */
> 	cap->device_caps = V4L2_CAP_AUDIO |
> 		V4L2_CAP_READWRITE |
> 		V4L2_CAP_STREAMING |
> 		V4L2_CAP_TUNER;
> 	if (vdev->vfl_type == VFL_TYPE_GRABBER)
> 		cap->device_caps |= V4L2_CAP_VIDEO_CAPTURE;
> 	else
> 		cap->device_caps |= V4L2_CAP_VBI_CAPTURE;
> 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS |
> 		V4L2_CAP_VBI_CAPTURE | V4L2_CAP_VIDEO_CAPTURE;
> 	return 0;
> }
> 
> static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
> 					struct v4l2_fmtdesc *f)
> {
> 	if (f->index)
> 		return -EINVAL;
> 
> 	dprintk(1, "%s called\n", __func__);
> 
> 	f->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> 	strcpy(f->description, "Packed YUV2");
> 
> 	f->flags = 0;
> 	f->pixelformat = V4L2_PIX_FMT_UYVY;
> 
> 	return 0;
> }
> 
> static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
> 					struct v4l2_format *f)
> {
> 	struct au0828_dev *dev = video_drvdata(file);
> 
> 	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
> 		dev->std_set_in_tuner_core, dev->dev_state);
> 
> 	f->fmt.pix.width = dev->width;
> 	f->fmt.pix.height = dev->height;
> 	f->fmt.pix.pixelformat = V4L2_PIX_FMT_UYVY;
> 	f->fmt.pix.bytesperline = dev->bytesperline;
> 	f->fmt.pix.sizeimage = dev->frame_size;
> 	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M; /* NTSC/PAL */
> 	f->fmt.pix.field = V4L2_FIELD_INTERLACED;
> 	f->fmt.pix.priv = 0;
> 	return 0;
> }
> 
> static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
> 				  struct v4l2_format *f)
> {
> 	struct au0828_dev *dev = video_drvdata(file);
> 
> 	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
> 		dev->std_set_in_tuner_core, dev->dev_state);
> 
> 	return au0828_set_format(dev, VIDIOC_TRY_FMT, f);
> }
> 
> static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
> 				struct v4l2_format *f)
> {
> 	struct au0828_dev *dev = video_drvdata(file);
> 	int rc;
> 
> 	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
> 		dev->std_set_in_tuner_core, dev->dev_state);
> 
> 	rc = check_dev(dev);
> 	if (rc < 0)
> 		return rc;
> 
> 	if (vb2_is_busy(&dev->vb_vidq)) {
> 		pr_info("%s queue busy\n", __func__);
> 		rc = -EBUSY;
> 		goto out;
> 	}
> 
> 	rc = au0828_set_format(dev, VIDIOC_S_FMT, f);
> out:
> 	return rc;
> }
> 
> static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id norm)
> {
> 	struct au0828_dev *dev = video_drvdata(file);
> 
> 	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
> 		dev->std_set_in_tuner_core, dev->dev_state);
> 
> 	if (norm == dev->std)
> 		return 0;
> 
> 	if (dev->streaming_users > 0)
> 		return -EBUSY;
> 
> 	dev->std = norm;
> 
> 	au0828_init_tuner(dev);
> 
> 	i2c_gate_ctrl(dev, 1);
> 
> 	/*
> 	 * FIXME: when we support something other than 60Hz standards,
> 	 * we are going to have to make the au0828 bridge adjust the size
> 	 * of its capture buffer, which is currently hardcoded at 720x480
> 	 */
> 
> 	v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_std, norm);
> 
> 	i2c_gate_ctrl(dev, 0);
> 
> 	return 0;
> }
> 
> static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *norm)
> {
> 	struct au0828_dev *dev = video_drvdata(file);
> 
> 	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
> 		dev->std_set_in_tuner_core, dev->dev_state);
> 
> 	*norm = dev->std;
> 	return 0;
> }
> 
> static int vidioc_enum_input(struct file *file, void *priv,
> 				struct v4l2_input *input)
> {
> 	struct au0828_dev *dev = video_drvdata(file);
> 	unsigned int tmp;
> 
> 	static const char *inames[] = {
> 		[AU0828_VMUX_UNDEFINED] = "Undefined",
> 		[AU0828_VMUX_COMPOSITE] = "Composite",
> 		[AU0828_VMUX_SVIDEO] = "S-Video",
> 		[AU0828_VMUX_CABLE] = "Cable TV",
> 		[AU0828_VMUX_TELEVISION] = "Television",
> 		[AU0828_VMUX_DVB] = "DVB",
> 		[AU0828_VMUX_DEBUG] = "tv debug"
> 	};
> 
> 	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
> 		dev->std_set_in_tuner_core, dev->dev_state);
> 
> 	tmp = input->index;
> 
> 	if (tmp >= AU0828_MAX_INPUT)
> 		return -EINVAL;
> 	if (AUVI_INPUT(tmp).type == 0)
> 		return -EINVAL;
> 
> 	input->index = tmp;
> 	strcpy(input->name, inames[AUVI_INPUT(tmp).type]);
> 	if ((AUVI_INPUT(tmp).type == AU0828_VMUX_TELEVISION) ||
> 	    (AUVI_INPUT(tmp).type == AU0828_VMUX_CABLE)) {
> 		input->type |= V4L2_INPUT_TYPE_TUNER;
> 		input->audioset = 1;
> 	} else {
> 		input->type |= V4L2_INPUT_TYPE_CAMERA;
> 		input->audioset = 2;
> 	}
> 
> 	input->std = dev->vdev->tvnorms;
> 
> 	return 0;
> }
> 
> static int vidioc_g_input(struct file *file, void *priv, unsigned int *i)
> {
> 	struct au0828_dev *dev = video_drvdata(file);
> 
> 	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
> 		dev->std_set_in_tuner_core, dev->dev_state);
> 
> 	*i = dev->ctrl_input;
> 	return 0;
> }
> 
> static void au0828_s_input(struct au0828_dev *dev, int index)
> {
> 	int i;
> 
> 	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
> 		dev->std_set_in_tuner_core, dev->dev_state);
> 
> 	switch (AUVI_INPUT(index).type) {
> 	case AU0828_VMUX_SVIDEO:
> 		dev->input_type = AU0828_VMUX_SVIDEO;
> 		dev->ctrl_ainput = 1;
> 		break;
> 	case AU0828_VMUX_COMPOSITE:
> 		dev->input_type = AU0828_VMUX_COMPOSITE;
> 		dev->ctrl_ainput = 1;
> 		break;
> 	case AU0828_VMUX_TELEVISION:
> 		dev->input_type = AU0828_VMUX_TELEVISION;
> 		dev->ctrl_ainput = 0;
> 		break;
> 	default:
> 		dprintk(1, "unknown input type set [%d]\n",
> 			AUVI_INPUT(index).type);
> 		break;
> 	}
> 
> 	v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_routing,
> 			AUVI_INPUT(index).vmux, 0, 0);
> 
> 	for (i = 0; i < AU0828_MAX_INPUT; i++) {
> 		int enable = 0;
> 		if (AUVI_INPUT(i).audio_setup == NULL)
> 			continue;
> 
> 		if (i == index)
> 			enable = 1;
> 		else
> 			enable = 0;
> 		if (enable) {
> 			(AUVI_INPUT(i).audio_setup)(dev, enable);
> 		} else {
> 			/* Make sure we leave it turned on if some
> 			   other input is routed to this callback */
> 			if ((AUVI_INPUT(i).audio_setup) !=
> 			    ((AUVI_INPUT(index).audio_setup))) {
> 				(AUVI_INPUT(i).audio_setup)(dev, enable);
> 			}
> 		}
> 	}
> 
> 	v4l2_device_call_all(&dev->v4l2_dev, 0, audio, s_routing,
> 			AUVI_INPUT(index).amux, 0, 0);
> }
> 
> static int vidioc_s_input(struct file *file, void *priv, unsigned int index)
> {
> 	struct au0828_dev *dev = video_drvdata(file);
> 
> 	dprintk(1, "VIDIOC_S_INPUT in function %s, input=%d\n", __func__,
> 		index);
> 	if (index >= AU0828_MAX_INPUT)
> 		return -EINVAL;
> 	if (AUVI_INPUT(index).type == 0)
> 		return -EINVAL;
> 	dev->ctrl_input = index;
> 	au0828_s_input(dev, index);
> 	return 0;
> }
> 
> static int vidioc_enumaudio(struct file *file, void *priv, struct v4l2_audio *a)
> {
> 	if (a->index > 1)
> 		return -EINVAL;
> 
> 	dprintk(1, "%s called\n", __func__);
> 
> 	if (a->index == 0)
> 		strcpy(a->name, "Television");
> 	else
> 		strcpy(a->name, "Line in");
> 
> 	a->capability = V4L2_AUDCAP_STEREO;
> 	return 0;
> }
> 
> static int vidioc_g_audio(struct file *file, void *priv, struct v4l2_audio *a)
> {
> 	struct au0828_dev *dev = video_drvdata(file);
> 
> 	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
> 		dev->std_set_in_tuner_core, dev->dev_state);
> 
> 	a->index = dev->ctrl_ainput;
> 	if (a->index == 0)
> 		strcpy(a->name, "Television");
> 	else
> 		strcpy(a->name, "Line in");
> 
> 	a->capability = V4L2_AUDCAP_STEREO;
> 	return 0;
> }
> 
> static int vidioc_s_audio(struct file *file, void *priv, const struct v4l2_audio *a)
> {
> 	struct au0828_dev *dev = video_drvdata(file);
> 
> 	if (a->index != dev->ctrl_ainput)
> 		return -EINVAL;
> 
> 	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
> 		dev->std_set_in_tuner_core, dev->dev_state);
> 	return 0;
> }
> 
> static int vidioc_g_tuner(struct file *file, void *priv, struct v4l2_tuner *t)
> {
> 	struct au0828_dev *dev = video_drvdata(file);
> 
> 	if (t->index != 0)
> 		return -EINVAL;
> 
> 	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
> 		dev->std_set_in_tuner_core, dev->dev_state);
> 
> 	strcpy(t->name, "Auvitek tuner");
> 
> 	au0828_init_tuner(dev);
> 	i2c_gate_ctrl(dev, 1);
> 	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, g_tuner, t);
> 	i2c_gate_ctrl(dev, 0);
> 	return 0;
> }
> 
> static int vidioc_s_tuner(struct file *file, void *priv,
> 				const struct v4l2_tuner *t)
> {
> 	struct au0828_dev *dev = video_drvdata(file);
> 
> 	if (t->index != 0)
> 		return -EINVAL;
> 
> 	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
> 		dev->std_set_in_tuner_core, dev->dev_state);
> 
> 	au0828_init_tuner(dev);
> 	i2c_gate_ctrl(dev, 1);
> 	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_tuner, t);
> 	i2c_gate_ctrl(dev, 0);
> 
> 	dprintk(1, "VIDIOC_S_TUNER: signal = %x, afc = %x\n", t->signal,
> 		t->afc);
> 
> 	return 0;
> 
> }
> 
> static int vidioc_g_frequency(struct file *file, void *priv,
> 				struct v4l2_frequency *freq)
> {
> 	struct au0828_dev *dev = video_drvdata(file);
> 
> 	if (freq->tuner != 0)
> 		return -EINVAL;
> 	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
> 		dev->std_set_in_tuner_core, dev->dev_state);
> 	freq->frequency = dev->ctrl_freq;
> 	return 0;
> }
> 
> static int vidioc_s_frequency(struct file *file, void *priv,
> 				const struct v4l2_frequency *freq)
> {
> 	struct au0828_dev *dev = video_drvdata(file);
> 	struct v4l2_frequency new_freq = *freq;
> 
> 	if (freq->tuner != 0)
> 		return -EINVAL;
> 
> 	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
> 		dev->std_set_in_tuner_core, dev->dev_state);
> 
> 	au0828_init_tuner(dev);
> 	i2c_gate_ctrl(dev, 1);
> 
> 	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_frequency, freq);
> 	/* Get the actual set (and possibly clamped) frequency */
> 	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, g_frequency, &new_freq);
> 	dev->ctrl_freq = new_freq.frequency;
> 
> 	i2c_gate_ctrl(dev, 0);
> 
> 	au0828_analog_stream_reset(dev);
> 
> 	return 0;
> }
> 
> 
> /* RAW VBI ioctls */
> 
> static int vidioc_g_fmt_vbi_cap(struct file *file, void *priv,
> 				struct v4l2_format *format)
> {
> 	struct au0828_dev *dev = video_drvdata(file);
> 
> 	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
> 		dev->std_set_in_tuner_core, dev->dev_state);
> 
> 	format->fmt.vbi.samples_per_line = dev->vbi_width;
> 	format->fmt.vbi.sample_format = V4L2_PIX_FMT_GREY;
> 	format->fmt.vbi.offset = 0;
> 	format->fmt.vbi.flags = 0;
> 	format->fmt.vbi.sampling_rate = 6750000 * 4 / 2;
> 
> 	format->fmt.vbi.count[0] = dev->vbi_height;
> 	format->fmt.vbi.count[1] = dev->vbi_height;
> 	format->fmt.vbi.start[0] = 21;
> 	format->fmt.vbi.start[1] = 284;
> 	memset(format->fmt.vbi.reserved, 0, sizeof(format->fmt.vbi.reserved));
> 
> 	return 0;
> }
> 
> static int vidioc_cropcap(struct file *file, void *priv,
> 			  struct v4l2_cropcap *cc)
> {
> 	struct au0828_dev *dev = video_drvdata(file);
> 
> 	if (cc->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> 		return -EINVAL;
> 
> 	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
> 		dev->std_set_in_tuner_core, dev->dev_state);
> 
> 	cc->bounds.left = 0;
> 	cc->bounds.top = 0;
> 	cc->bounds.width = dev->width;
> 	cc->bounds.height = dev->height;
> 
> 	cc->defrect = cc->bounds;
> 
> 	cc->pixelaspect.numerator = 54;
> 	cc->pixelaspect.denominator = 59;
> 
> 	return 0;
> }
> 
> #ifdef CONFIG_VIDEO_ADV_DEBUG
> static int vidioc_g_register(struct file *file, void *priv,
> 			     struct v4l2_dbg_register *reg)
> {
> 	struct au0828_dev *dev = video_drvdata(file);
> 
> 	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
> 		dev->std_set_in_tuner_core, dev->dev_state);
> 
> 	reg->val = au0828_read(dev, reg->reg);
> 	reg->size = 1;
> 	return 0;
> }
> 
> static int vidioc_s_register(struct file *file, void *priv,
> 			     const struct v4l2_dbg_register *reg)
> {
> 	struct au0828_dev *dev = video_drvdata(file);
> 
> 	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
> 		dev->std_set_in_tuner_core, dev->dev_state);
> 
> 	return au0828_writereg(dev, reg->reg, reg->val);
> }
> #endif
> 
> static int vidioc_log_status(struct file *file, void *fh)
> {
> 	struct video_device *vdev = video_devdata(file);
> 
> 	dprintk(1, "%s called\n", __func__);
> 
> 	v4l2_ctrl_log_status(file, fh);
> 	v4l2_device_call_all(vdev->v4l2_dev, 0, core, log_status);
> 	return 0;
> }
> 
> void au0828_v4l2_suspend(struct au0828_dev *dev)
> {
> 	struct urb *urb;
> 	int i;
> 
> 	pr_info("stopping V4L2\n");
> 
> 	if (dev->stream_state == STREAM_ON) {
> 		pr_info("stopping V4L2 active URBs\n");
> 		au0828_analog_stream_disable(dev);
> 		/* stop urbs */
> 		for (i = 0; i < dev->isoc_ctl.num_bufs; i++) {
> 			urb = dev->isoc_ctl.urb[i];
> 			if (urb) {
> 				if (!irqs_disabled())
> 					usb_kill_urb(urb);
> 				else
> 					usb_unlink_urb(urb);
> 			}
> 		}
> 	}
> 
> 	if (dev->vid_timeout_running)
> 		del_timer_sync(&dev->vid_timeout);
> 	if (dev->vbi_timeout_running)
> 		del_timer_sync(&dev->vbi_timeout);
> }
> 
> void au0828_v4l2_resume(struct au0828_dev *dev)
> {
> 	int i, rc;
> 
> 	pr_info("restarting V4L2\n");
> 
> 	if (dev->stream_state == STREAM_ON) {
> 		au0828_stream_interrupt(dev);
> 		au0828_init_tuner(dev);
> 	}
> 
> 	if (dev->vid_timeout_running)
> 		mod_timer(&dev->vid_timeout, jiffies + (HZ / 10));
> 	if (dev->vbi_timeout_running)
> 		mod_timer(&dev->vbi_timeout, jiffies + (HZ / 10));
> 
> 	/* If we were doing ac97 instead of i2s, it would go here...*/
> 	au0828_i2s_init(dev);
> 
> 	au0828_analog_stream_enable(dev);
> 
> 	if (!(dev->stream_state == STREAM_ON)) {
> 		au0828_analog_stream_reset(dev);
> 		/* submit urbs */
> 		for (i = 0; i < dev->isoc_ctl.num_bufs; i++) {
> 			rc = usb_submit_urb(dev->isoc_ctl.urb[i], GFP_ATOMIC);
> 			if (rc) {
> 				au0828_isocdbg("submit of urb %i failed (error=%i)\n",
> 					       i, rc);
> 				au0828_uninit_isoc(dev);
> 			}
> 		}
> 	}
> }
> 
> static struct v4l2_file_operations au0828_v4l_fops = {
> 	.owner      = THIS_MODULE,
> 	.open       = au0828_v4l2_open,
> 	.release    = au0828_v4l2_close,
> 	.read       = vb2_fop_read,
> 	.poll       = vb2_fop_poll,
> 	.mmap       = vb2_fop_mmap,
> 	.unlocked_ioctl = video_ioctl2,
> };
> 
> static const struct v4l2_ioctl_ops video_ioctl_ops = {
> 	.vidioc_querycap            = vidioc_querycap,
> 	.vidioc_enum_fmt_vid_cap    = vidioc_enum_fmt_vid_cap,
> 	.vidioc_g_fmt_vid_cap       = vidioc_g_fmt_vid_cap,
> 	.vidioc_try_fmt_vid_cap     = vidioc_try_fmt_vid_cap,
> 	.vidioc_s_fmt_vid_cap       = vidioc_s_fmt_vid_cap,
> 	.vidioc_g_fmt_vbi_cap       = vidioc_g_fmt_vbi_cap,
> 	.vidioc_try_fmt_vbi_cap     = vidioc_g_fmt_vbi_cap,
> 	.vidioc_s_fmt_vbi_cap       = vidioc_g_fmt_vbi_cap,
> 	.vidioc_enumaudio           = vidioc_enumaudio,
> 	.vidioc_g_audio             = vidioc_g_audio,
> 	.vidioc_s_audio             = vidioc_s_audio,
> 	.vidioc_cropcap             = vidioc_cropcap,
> 
> 	.vidioc_reqbufs             = vb2_ioctl_reqbufs,
> 	.vidioc_create_bufs         = vb2_ioctl_create_bufs,
> 	.vidioc_prepare_buf         = vb2_ioctl_prepare_buf,
> 	.vidioc_querybuf            = vb2_ioctl_querybuf,
> 	.vidioc_qbuf                = vb2_ioctl_qbuf,
> 	.vidioc_dqbuf               = vb2_ioctl_dqbuf,
> 
> 	.vidioc_s_std               = vidioc_s_std,
> 	.vidioc_g_std               = vidioc_g_std,
> 	.vidioc_enum_input          = vidioc_enum_input,
> 	.vidioc_g_input             = vidioc_g_input,
> 	.vidioc_s_input             = vidioc_s_input,
> 
> 	.vidioc_streamon            = vb2_ioctl_streamon,
> 	.vidioc_streamoff           = vb2_ioctl_streamoff,
> 
> 	.vidioc_g_tuner             = vidioc_g_tuner,
> 	.vidioc_s_tuner             = vidioc_s_tuner,
> 	.vidioc_g_frequency         = vidioc_g_frequency,
> 	.vidioc_s_frequency         = vidioc_s_frequency,
> #ifdef CONFIG_VIDEO_ADV_DEBUG
> 	.vidioc_g_register          = vidioc_g_register,
> 	.vidioc_s_register          = vidioc_s_register,
> #endif
> 	.vidioc_log_status	    = vidioc_log_status,
> 	.vidioc_subscribe_event     = v4l2_ctrl_subscribe_event,
> 	.vidioc_unsubscribe_event   = v4l2_event_unsubscribe,
> };
> 
> static const struct video_device au0828_video_template = {
> 	.fops                       = &au0828_v4l_fops,
> 	.release                    = video_device_release,
> 	.ioctl_ops 		    = &video_ioctl_ops,
> 	.tvnorms                    = V4L2_STD_NTSC_M | V4L2_STD_PAL_M,
> };
> 
> static int au0828_vb2_setup(struct au0828_dev *dev)
> {
> 	int rc;
> 	struct vb2_queue *q;
> 
> 	/* Setup Videobuf2 for Video capture */
> 	q = &dev->vb_vidq;
> 	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> 	q->io_modes = VB2_READ | VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
> 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> 	q->drv_priv = dev;
> 	q->buf_struct_size = sizeof(struct au0828_buffer);
> 	q->ops = &au0828_video_qops;
> 	q->mem_ops = &vb2_vmalloc_memops;
> 
> 	rc = vb2_queue_init(q);
> 	if (rc < 0)
> 		return rc;
> 
> 	/* Setup Videobuf2 for VBI capture */
> 	q = &dev->vb_vbiq;
> 	q->type = V4L2_BUF_TYPE_VBI_CAPTURE;
> 	q->io_modes = VB2_READ | VB2_MMAP | VB2_USERPTR;
> 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> 	q->drv_priv = dev;
> 	q->buf_struct_size = sizeof(struct au0828_buffer);
> 	q->ops = &au0828_vbi_qops;
> 	q->mem_ops = &vb2_vmalloc_memops;
> 
> 	rc = vb2_queue_init(q);
> 	if (rc < 0)
> 		return rc;
> 
> 	return 0;
> }
> 
> /**************************************************************************/
> 
> int au0828_analog_register(struct au0828_dev *dev,
> 			   struct usb_interface *interface)
> {
> 	int retval = -ENOMEM;
> 	struct usb_host_interface *iface_desc;
> 	struct usb_endpoint_descriptor *endpoint;
> 	int i, ret;
> 
> 	dprintk(1, "au0828_analog_register called for intf#%d!\n",
> 		interface->cur_altsetting->desc.bInterfaceNumber);
> 
> 	/* set au0828 usb interface0 to as5 */
> 	retval = usb_set_interface(dev->usbdev,
> 			interface->cur_altsetting->desc.bInterfaceNumber, 5);
> 	if (retval != 0) {
> 		pr_info("Failure setting usb interface0 to as5\n");
> 		return retval;
> 	}
> 
> 	/* Figure out which endpoint has the isoc interface */
> 	iface_desc = interface->cur_altsetting;
> 	for (i = 0; i < iface_desc->desc.bNumEndpoints; i++) {
> 		endpoint = &iface_desc->endpoint[i].desc;
> 		if (((endpoint->bEndpointAddress & USB_ENDPOINT_DIR_MASK)
> 		     == USB_DIR_IN) &&
> 		    ((endpoint->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
> 		     == USB_ENDPOINT_XFER_ISOC)) {
> 
> 			/* we find our isoc in endpoint */
> 			u16 tmp = le16_to_cpu(endpoint->wMaxPacketSize);
> 			dev->max_pkt_size = (tmp & 0x07ff) *
> 				(((tmp & 0x1800) >> 11) + 1);
> 			dev->isoc_in_endpointaddr = endpoint->bEndpointAddress;
> 			dprintk(1,
> 				"Found isoc endpoint 0x%02x, max size = %d\n",
> 				dev->isoc_in_endpointaddr, dev->max_pkt_size);
> 		}
> 	}
> 	if (!(dev->isoc_in_endpointaddr)) {
> 		pr_info("Could not locate isoc endpoint\n");
> 		kfree(dev);
> 		return -ENODEV;
> 	}
> 
> 	init_waitqueue_head(&dev->open);
> 	spin_lock_init(&dev->slock);
> 
> 	/* init video dma queues */
> 	INIT_LIST_HEAD(&dev->vidq.active);
> 	INIT_LIST_HEAD(&dev->vbiq.active);
> 
> 	dev->vid_timeout.function = au0828_vid_buffer_timeout;
> 	dev->vid_timeout.data = (unsigned long) dev;
> 	init_timer(&dev->vid_timeout);
> 
> 	dev->vbi_timeout.function = au0828_vbi_buffer_timeout;
> 	dev->vbi_timeout.data = (unsigned long) dev;
> 	init_timer(&dev->vbi_timeout);
> 
> 	dev->width = NTSC_STD_W;
> 	dev->height = NTSC_STD_H;
> 	dev->field_size = dev->width * dev->height;
> 	dev->frame_size = dev->field_size << 1;
> 	dev->bytesperline = dev->width << 1;
> 	dev->vbi_width = 720;
> 	dev->vbi_height = 1;
> 	dev->ctrl_ainput = 0;
> 	dev->ctrl_freq = 960;
> 	dev->std = V4L2_STD_NTSC_M;
> 	au0828_s_input(dev, 0);
> 
> 	/* allocate and fill v4l2 video struct */
> 	dev->vdev = video_device_alloc();
> 	if (NULL == dev->vdev) {
> 		dprintk(1, "Can't allocate video_device.\n");
> 		return -ENOMEM;
> 	}
> 
> 	/* allocate the VBI struct */
> 	dev->vbi_dev = video_device_alloc();

I recommend that these video_device structs are embedded in au0828_dev.
That way you don't need to check for errors here.

> 	if (NULL == dev->vbi_dev) {
> 		dprintk(1, "Can't allocate vbi_device.\n");
> 		ret = -ENOMEM;
> 		goto err_vdev;
> 	}
> 
> 	mutex_init(&dev->vb_queue_lock);
> 	mutex_init(&dev->vb_vbi_queue_lock);
> 
> 	/* Fill the video capture device struct */
> 	*dev->vdev = au0828_video_template;
> 	dev->vdev->v4l2_dev = &dev->v4l2_dev;
> 	dev->vdev->lock = &dev->lock;
> 	dev->vdev->queue = &dev->vb_vidq;
> 	dev->vdev->queue->lock = &dev->vb_queue_lock;
> 	strcpy(dev->vdev->name, "au0828a video");
> 
> 	/* Setup the VBI device */
> 	*dev->vbi_dev = au0828_video_template;
> 	dev->vbi_dev->v4l2_dev = &dev->v4l2_dev;
> 	dev->vbi_dev->lock = &dev->lock;
> 	dev->vbi_dev->queue = &dev->vb_vbiq;
> 	dev->vbi_dev->queue->lock = &dev->vb_vbi_queue_lock;
> 	strcpy(dev->vbi_dev->name, "au0828a vbi");
> 
> 	/* Register the v4l2 device */
> 	video_set_drvdata(dev->vdev, dev);
> 	retval = video_register_device(dev->vdev, VFL_TYPE_GRABBER, -1);
> 	if (retval != 0) {
> 		dprintk(1, "unable to register video device (error = %d).\n",
> 			retval);
> 		ret = -ENODEV;
> 		goto err_vbi_dev;
> 	}
> 
> 	/* Register the vbi device */
> 	video_set_drvdata(dev->vbi_dev, dev);
> 	retval = video_register_device(dev->vbi_dev, VFL_TYPE_VBI, -1);
> 	if (retval != 0) {
> 		dprintk(1, "unable to register vbi device (error = %d).\n",
> 			retval);
> 		ret = -ENODEV;
> 		goto err_vbi_dev;
> 	}
> 
> 	/* initialize videobuf2 stuff */
> 	retval = au0828_vb2_setup(dev);

This should be done *before* calling video_register_device.

> 	if (retval != 0) {
> 		dprintk(1, "unable to setup videobuf2 queues (error = %d).\n",
> 			retval);
> 		ret = -ENODEV;
> 		goto err_vbi_dev;
> 	}
> 
> 	dprintk(1, "%s completed!\n", __func__);
> 
> 	return 0;
> 
> err_vbi_dev:
> 	video_device_release(dev->vbi_dev);
> err_vdev:
> 	video_device_release(dev->vdev);
> 	return ret;
> }
> 

Regards,

	Hans
