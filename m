Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:44082 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750980AbeEMJly (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 13 May 2018 05:41:54 -0400
Received: by mail-wr0-f195.google.com with SMTP id y15-v6so9232572wrg.11
        for <linux-media@vger.kernel.org>; Sun, 13 May 2018 02:41:53 -0700 (PDT)
Subject: Re: [PATCH 1/4] gspca: convert to vb2
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
References: <20180512144403.13576-1-hverkuil@xs4all.nl>
 <20180512144403.13576-2-hverkuil@xs4all.nl>
 <c093d397-dd71-dd4a-aede-59a103a1d73c@redhat.com>
 <da5b2752-b52d-8483-1afa-e798b76ec2f5@xs4all.nl>
From: Hans de Goede <hdegoede@redhat.com>
Message-ID: <58b8c49b-712a-f256-cfd6-ca8215056228@redhat.com>
Date: Sun, 13 May 2018 11:41:50 +0200
MIME-Version: 1.0
In-Reply-To: <da5b2752-b52d-8483-1afa-e798b76ec2f5@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 05/13/2018 11:32 AM, Hans Verkuil wrote:
> On 05/12/2018 08:00 PM, Hans de Goede wrote:
>> Hi Hans,
>>
>> Overall looks good, 1 comment inline.
>>
>>> -	if (ret == 0 && gspca_dev->sd_desc->dq_callback) {
>>> -		mutex_lock(&gspca_dev->usb_lock);
>>> -		gspca_dev->usb_err = 0;
>>> -		if (gspca_dev->present)
>>> -			gspca_dev->sd_desc->dq_callback(gspca_dev);
>>> -		mutex_unlock(&gspca_dev->usb_lock);
>>> -	}
>>> +	if (!gspca_dev->sd_desc->dq_callback)
>>> +		return;
>>>    
>>> -	return ret;
>>> +	gspca_dev->usb_err = 0;
>>> +	gspca_dev->sd_desc->dq_callback(gspca_dev);
>>>    }
>>
>>
>> You are loosing the "if (gspca_dev->present)" check around
>> the dq_callback here, this may causes issues if the
>> buffer_finish method gets called after the device has
>> been unplugged.
> 
> Good catch, I've added the 'if' here.

Ok, with that change you may add my rev-by to the entire
series.

Regards,

Hans


> 
>>
>> If the vb2 code takes care that the buffer_finish method
>> doesn't get called then you may add my:
>>
>> Reviewed-by: Hans de Goede <hdegoede@redhat.com>
>>
>> To this patch.
>>
>> Patch 2-4 look good to and you may add my:
>>
>> Reviewed-by: Hans de Goede <hdegoede@redhat.com>
>>
>> To those too.
> 
> Thanks!
> 
>>
>> Regards,
>>
>> Hans
>>
>>
>> p.s.
>>
>> If the v4l2-ctl + vb2 frameworks take care of not having
>> any driver callbacks called after disconnect, perhaps
>> the present flag can be removed?
> 
> I actually tried that (using the video_is_registered() function
> instead), but it is used all over in gspca subdrivers, and I didn't
> want to change them all. It's easier to just keep the field.
> 
> The same is true for the streaming field, for that matter. It could
> be replaced by a vb2 function, but it would require lots of changes
> in gspca subdrivers as well.
> 
> Regards,
> 
> 	Hans
> 
>>
>>
>>
>>> -/*
>>> - * queue a video buffer
>>> - *
>>> - * Attempting to queue a buffer that has already been
>>> - * queued will return -EINVAL.
>>> - */
>>> -static int vidioc_qbuf(struct file *file, void *priv,
>>> -			struct v4l2_buffer *v4l2_buf)
>>> +static void gspca_buffer_queue(struct vb2_buffer *vb)
>>>    {
>>> -	struct gspca_dev *gspca_dev = video_drvdata(file);
>>> -	struct gspca_frame *frame;
>>> -	int i, index, ret;
>>> -
>>> -	gspca_dbg(gspca_dev, D_FRAM, "qbuf %d\n", v4l2_buf->index);
>>> -
>>> -	if (mutex_lock_interruptible(&gspca_dev->queue_lock))
>>> -		return -ERESTARTSYS;
>>> -
>>> -	index = v4l2_buf->index;
>>> -	if ((unsigned) index >= gspca_dev->nframes) {
>>> -		gspca_dbg(gspca_dev, D_FRAM,
>>> -			  "qbuf idx %d >= %d\n", index, gspca_dev->nframes);
>>> -		ret = -EINVAL;
>>> -		goto out;
>>> -	}
>>> -	if (v4l2_buf->memory != gspca_dev->memory) {
>>> -		gspca_dbg(gspca_dev, D_FRAM, "qbuf bad memory type\n");
>>> -		ret = -EINVAL;
>>> -		goto out;
>>> -	}
>>> -
>>> -	frame = &gspca_dev->frame[index];
>>> -	if (frame->v4l2_buf.flags & BUF_ALL_FLAGS) {
>>> -		gspca_dbg(gspca_dev, D_FRAM, "qbuf bad state\n");
>>> -		ret = -EINVAL;
>>> -		goto out;
>>> -	}
>>> -
>>> -	frame->v4l2_buf.flags |= V4L2_BUF_FLAG_QUEUED;
>>> -
>>> -	if (frame->v4l2_buf.memory == V4L2_MEMORY_USERPTR) {
>>> -		frame->v4l2_buf.m.userptr = v4l2_buf->m.userptr;
>>> -		frame->v4l2_buf.length = v4l2_buf->length;
>>> -	}
>>> -
>>> -	/* put the buffer in the 'queued' queue */
>>> -	i = atomic_read(&gspca_dev->fr_q);
>>> -	gspca_dev->fr_queue[i] = index;
>>> -	atomic_set(&gspca_dev->fr_q, (i + 1) % GSPCA_MAX_FRAMES);
>>> +	struct gspca_dev *gspca_dev = vb2_get_drv_priv(vb->vb2_queue);
>>> +	struct gspca_buffer *buf = to_gspca_buffer(vb);
>>> +	unsigned long flags;
>>>    
>>> -	v4l2_buf->flags |= V4L2_BUF_FLAG_QUEUED;
>>> -	v4l2_buf->flags &= ~V4L2_BUF_FLAG_DONE;
>>> -	ret = 0;
>>> -out:
>>> -	mutex_unlock(&gspca_dev->queue_lock);
>>> -	return ret;
>>> +	spin_lock_irqsave(&gspca_dev->qlock, flags);
>>> +	list_add_tail(&buf->list, &gspca_dev->buf_list);
>>> +	spin_unlock_irqrestore(&gspca_dev->qlock, flags);
>>>    }
>>>    
>>> -/*
>>> - * allocate the resources for read()
>>> - */
>>> -static int read_alloc(struct gspca_dev *gspca_dev,
>>> -			struct file *file)
>>> +static void gspca_return_all_buffers(struct gspca_dev *gspca_dev,
>>> +				     enum vb2_buffer_state state)
>>>    {
>>> -	struct v4l2_buffer v4l2_buf;
>>> -	int i, ret;
>>> -
>>> -	gspca_dbg(gspca_dev, D_STREAM, "read alloc\n");
>>> +	struct gspca_buffer *buf, *node;
>>> +	unsigned long flags;
>>>    
>>> -	if (mutex_lock_interruptible(&gspca_dev->usb_lock))
>>> -		return -ERESTARTSYS;
>>> -
>>> -	if (gspca_dev->nframes == 0) {
>>> -		struct v4l2_requestbuffers rb;
>>> -
>>> -		memset(&rb, 0, sizeof rb);
>>> -		rb.count = gspca_dev->nbufread;
>>> -		rb.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>>> -		rb.memory = GSPCA_MEMORY_READ;
>>> -		ret = vidioc_reqbufs(file, gspca_dev, &rb);
>>> -		if (ret != 0) {
>>> -			gspca_dbg(gspca_dev, D_STREAM, "read reqbuf err %d\n",
>>> -				  ret);
>>> -			goto out;
>>> -		}
>>> -		memset(&v4l2_buf, 0, sizeof v4l2_buf);
>>> -		v4l2_buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>>> -		v4l2_buf.memory = GSPCA_MEMORY_READ;
>>> -		for (i = 0; i < gspca_dev->nbufread; i++) {
>>> -			v4l2_buf.index = i;
>>> -			ret = vidioc_qbuf(file, gspca_dev, &v4l2_buf);
>>> -			if (ret != 0) {
>>> -				gspca_dbg(gspca_dev, D_STREAM, "read qbuf err: %d\n",
>>> -					  ret);
>>> -				goto out;
>>> -			}
>>> -		}
>>> +	spin_lock_irqsave(&gspca_dev->qlock, flags);
>>> +	list_for_each_entry_safe(buf, node, &gspca_dev->buf_list, list) {
>>> +		vb2_buffer_done(&buf->vb.vb2_buf, state);
>>> +		list_del(&buf->list);
>>>    	}
>>> -
>>> -	/* start streaming */
>>> -	ret = vidioc_streamon(file, gspca_dev, V4L2_BUF_TYPE_VIDEO_CAPTURE);
>>> -	if (ret != 0)
>>> -		gspca_dbg(gspca_dev, D_STREAM, "read streamon err %d\n", ret);
>>> -out:
>>> -	mutex_unlock(&gspca_dev->usb_lock);
>>> -	return ret;
>>> +	spin_unlock_irqrestore(&gspca_dev->qlock, flags);
>>>    }
>>>    
>>> -static __poll_t dev_poll(struct file *file, poll_table *wait)
>>> +static int gspca_start_streaming(struct vb2_queue *vq, unsigned int count)
>>>    {
>>> -	struct gspca_dev *gspca_dev = video_drvdata(file);
>>> -	__poll_t req_events = poll_requested_events(wait);
>>> -	__poll_t ret = 0;
>>> -
>>> -	gspca_dbg(gspca_dev, D_FRAM, "poll\n");
>>> -
>>> -	if (req_events & EPOLLPRI)
>>> -		ret |= v4l2_ctrl_poll(file, wait);
>>> -
>>> -	if (req_events & (EPOLLIN | EPOLLRDNORM)) {
>>> -		/* if reqbufs is not done, the user would use read() */
>>> -		if (gspca_dev->memory == GSPCA_MEMORY_NO) {
>>> -			if (read_alloc(gspca_dev, file) != 0) {
>>> -				ret |= EPOLLERR;
>>> -				goto out;
>>> -			}
>>> -		}
>>> -
>>> -		poll_wait(file, &gspca_dev->wq, wait);
>>> -
>>> -		/* check if an image has been received */
>>> -		if (mutex_lock_interruptible(&gspca_dev->queue_lock) != 0) {
>>> -			ret |= EPOLLERR;
>>> -			goto out;
>>> -		}
>>> -		if (gspca_dev->fr_o != atomic_read(&gspca_dev->fr_i))
>>> -			ret |= EPOLLIN | EPOLLRDNORM;
>>> -		mutex_unlock(&gspca_dev->queue_lock);
>>> -	}
>>> +	struct gspca_dev *gspca_dev = vb2_get_drv_priv(vq);
>>> +	int ret;
>>>    
>>> -out:
>>> -	if (!gspca_dev->present)
>>> -		ret |= EPOLLHUP;
>>> +	gspca_dev->sequence = 0;
>>>    
>>> +	ret = gspca_init_transfer(gspca_dev);
>>> +	if (ret)
>>> +		gspca_return_all_buffers(gspca_dev, VB2_BUF_STATE_QUEUED);
>>>    	return ret;
>>>    }
>>>    
>>> -static ssize_t dev_read(struct file *file, char __user *data,
>>> -		    size_t count, loff_t *ppos)
>>> +static void gspca_stop_streaming(struct vb2_queue *vq)
>>>    {
>>> -	struct gspca_dev *gspca_dev = video_drvdata(file);
>>> -	struct gspca_frame *frame;
>>> -	struct v4l2_buffer v4l2_buf;
>>> -	struct timeval timestamp;
>>> -	int n, ret, ret2;
>>> -
>>> -	gspca_dbg(gspca_dev, D_FRAM, "read (%zd)\n", count);
>>> -	if (gspca_dev->memory == GSPCA_MEMORY_NO) { /* first time ? */
>>> -		ret = read_alloc(gspca_dev, file);
>>> -		if (ret != 0)
>>> -			return ret;
>>> -	}
>>> +	struct gspca_dev *gspca_dev = vb2_get_drv_priv(vq);
>>>    
>>> -	/* get a frame */
>>> -	v4l2_get_timestamp(&timestamp);
>>> -	timestamp.tv_sec--;
>>> -	n = 2;
>>> -	for (;;) {
>>> -		memset(&v4l2_buf, 0, sizeof v4l2_buf);
>>> -		v4l2_buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>>> -		v4l2_buf.memory = GSPCA_MEMORY_READ;
>>> -		ret = vidioc_dqbuf(file, gspca_dev, &v4l2_buf);
>>> -		if (ret != 0) {
>>> -			gspca_dbg(gspca_dev, D_STREAM, "read dqbuf err %d\n",
>>> -				  ret);
>>> -			return ret;
>>> -		}
>>> -
>>> -		/* if the process slept for more than 1 second,
>>> -		 * get a newer frame */
>>> -		frame = &gspca_dev->frame[v4l2_buf.index];
>>> -		if (--n < 0)
>>> -			break;			/* avoid infinite loop */
>>> -		if (frame->v4l2_buf.timestamp.tv_sec >= timestamp.tv_sec)
>>> -			break;
>>> -		ret = vidioc_qbuf(file, gspca_dev, &v4l2_buf);
>>> -		if (ret != 0) {
>>> -			gspca_dbg(gspca_dev, D_STREAM, "read qbuf err %d\n",
>>> -				  ret);
>>> -			return ret;
>>> -		}
>>> -	}
>>> +	gspca_stream_off(gspca_dev);
>>>    
>>> -	/* copy the frame */
>>> -	if (count > frame->v4l2_buf.bytesused)
>>> -		count = frame->v4l2_buf.bytesused;
>>> -	ret = copy_to_user(data, frame->data, count);
>>> -	if (ret != 0) {
>>> -		gspca_err(gspca_dev, "read cp to user lack %d / %zd\n",
>>> -			  ret, count);
>>> -		ret = -EFAULT;
>>> -		goto out;
>>> -	}
>>> -	ret = count;
>>> -out:
>>> -	/* in each case, requeue the buffer */
>>> -	ret2 = vidioc_qbuf(file, gspca_dev, &v4l2_buf);
>>> -	if (ret2 != 0)
>>> -		return ret2;
>>> -	return ret;
>>> +	/* Release all active buffers */
>>> +	gspca_return_all_buffers(gspca_dev, VB2_BUF_STATE_ERROR);
>>>    }
>>>    
>>> +static const struct vb2_ops gspca_qops = {
>>> +	.queue_setup		= gspca_queue_setup,
>>> +	.buf_prepare		= gspca_buffer_prepare,
>>> +	.buf_finish		= gspca_buffer_finish,
>>> +	.buf_queue		= gspca_buffer_queue,
>>> +	.start_streaming	= gspca_start_streaming,
>>> +	.stop_streaming		= gspca_stop_streaming,
>>> +	.wait_prepare		= vb2_ops_wait_prepare,
>>> +	.wait_finish		= vb2_ops_wait_finish,
>>> +};
>>> +
>>>    static const struct v4l2_file_operations dev_fops = {
>>>    	.owner = THIS_MODULE,
>>> -	.open = dev_open,
>>> -	.release = dev_close,
>>> -	.read = dev_read,
>>> -	.mmap = dev_mmap,
>>> +	.open = v4l2_fh_open,
>>> +	.release = vb2_fop_release,
>>>    	.unlocked_ioctl = video_ioctl2,
>>> -	.poll	= dev_poll,
>>> +	.read = vb2_fop_read,
>>> +	.mmap = vb2_fop_mmap,
>>> +	.poll = vb2_fop_poll,
>>>    };
>>>    
>>>    static const struct v4l2_ioctl_ops dev_ioctl_ops = {
>>>    	.vidioc_querycap	= vidioc_querycap,
>>> -	.vidioc_dqbuf		= vidioc_dqbuf,
>>> -	.vidioc_qbuf		= vidioc_qbuf,
>>>    	.vidioc_enum_fmt_vid_cap = vidioc_enum_fmt_vid_cap,
>>>    	.vidioc_try_fmt_vid_cap	= vidioc_try_fmt_vid_cap,
>>>    	.vidioc_g_fmt_vid_cap	= vidioc_g_fmt_vid_cap,
>>>    	.vidioc_s_fmt_vid_cap	= vidioc_s_fmt_vid_cap,
>>> -	.vidioc_streamon	= vidioc_streamon,
>>>    	.vidioc_enum_input	= vidioc_enum_input,
>>>    	.vidioc_g_input		= vidioc_g_input,
>>>    	.vidioc_s_input		= vidioc_s_input,
>>> -	.vidioc_reqbufs		= vidioc_reqbufs,
>>> -	.vidioc_querybuf	= vidioc_querybuf,
>>> -	.vidioc_streamoff	= vidioc_streamoff,
>>>    	.vidioc_g_jpegcomp	= vidioc_g_jpegcomp,
>>>    	.vidioc_s_jpegcomp	= vidioc_s_jpegcomp,
>>>    	.vidioc_g_parm		= vidioc_g_parm,
>>>    	.vidioc_s_parm		= vidioc_s_parm,
>>>    	.vidioc_enum_framesizes = vidioc_enum_framesizes,
>>>    	.vidioc_enum_frameintervals = vidioc_enum_frameintervals,
>>> +
>>> +	.vidioc_reqbufs		= vb2_ioctl_reqbufs,
>>> +	.vidioc_create_bufs	= vb2_ioctl_create_bufs,
>>> +	.vidioc_querybuf	= vb2_ioctl_querybuf,
>>> +	.vidioc_qbuf		= vb2_ioctl_qbuf,
>>> +	.vidioc_dqbuf		= vb2_ioctl_dqbuf,
>>> +	.vidioc_expbuf		= vb2_ioctl_expbuf,
>>> +	.vidioc_streamon	= vb2_ioctl_streamon,
>>> +	.vidioc_streamoff	= vb2_ioctl_streamoff,
>>> +
>>>    #ifdef CONFIG_VIDEO_ADV_DEBUG
>>>    	.vidioc_g_chip_info	= vidioc_g_chip_info,
>>>    	.vidioc_g_register	= vidioc_g_register,
>>> @@ -2034,6 +1441,7 @@ int gspca_dev_probe2(struct usb_interface *intf,
>>>    {
>>>    	struct gspca_dev *gspca_dev;
>>>    	struct usb_device *dev = interface_to_usbdev(intf);
>>> +	struct vb2_queue *q;
>>>    	int ret;
>>>    
>>>    	pr_info("%s-" GSPCA_VERSION " probing %04x:%04x\n",
>>> @@ -2078,20 +1486,37 @@ int gspca_dev_probe2(struct usb_interface *intf,
>>>    	ret = v4l2_device_register(&intf->dev, &gspca_dev->v4l2_dev);
>>>    	if (ret)
>>>    		goto out;
>>> +	gspca_dev->present = true;
>>>    	gspca_dev->sd_desc = sd_desc;
>>> -	gspca_dev->nbufread = 2;
>>>    	gspca_dev->empty_packet = -1;	/* don't check the empty packets */
>>>    	gspca_dev->vdev = gspca_template;
>>>    	gspca_dev->vdev.v4l2_dev = &gspca_dev->v4l2_dev;
>>>    	video_set_drvdata(&gspca_dev->vdev, gspca_dev);
>>>    	gspca_dev->module = module;
>>> -	gspca_dev->present = 1;
>>>    
>>>    	mutex_init(&gspca_dev->usb_lock);
>>>    	gspca_dev->vdev.lock = &gspca_dev->usb_lock;
>>> -	mutex_init(&gspca_dev->queue_lock);
>>>    	init_waitqueue_head(&gspca_dev->wq);
>>>    
>>> +	/* Initialize the vb2 queue */
>>> +	q = &gspca_dev->queue;
>>> +	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>>> +	q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF | VB2_READ;
>>> +	q->drv_priv = gspca_dev;
>>> +	q->buf_struct_size = sizeof(struct gspca_buffer);
>>> +	q->ops = &gspca_qops;
>>> +	q->mem_ops = &vb2_vmalloc_memops;
>>> +	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>>> +	q->min_buffers_needed = 2;
>>> +	q->lock = &gspca_dev->usb_lock;
>>> +	ret = vb2_queue_init(q);
>>> +	if (ret)
>>> +		goto out;
>>> +	gspca_dev->vdev.queue = q;
>>> +
>>> +	INIT_LIST_HEAD(&gspca_dev->buf_list);
>>> +	spin_lock_init(&gspca_dev->qlock);
>>> +
>>>    	/* configure the subdriver and initialize the USB device */
>>>    	ret = sd_desc->config(gspca_dev, id);
>>>    	if (ret < 0)
>>> @@ -2109,14 +1534,6 @@ int gspca_dev_probe2(struct usb_interface *intf,
>>>    	if (ret)
>>>    		goto out;
>>>    
>>> -	/*
>>> -	 * Don't take usb_lock for these ioctls. This improves latency if
>>> -	 * usb_lock is taken for a long time, e.g. when changing a control
>>> -	 * value, and a new frame is ready to be dequeued.
>>> -	 */
>>> -	v4l2_disable_ioctl_locking(&gspca_dev->vdev, VIDIOC_DQBUF);
>>> -	v4l2_disable_ioctl_locking(&gspca_dev->vdev, VIDIOC_QBUF);
>>> -	v4l2_disable_ioctl_locking(&gspca_dev->vdev, VIDIOC_QUERYBUF);
>>>    #ifdef CONFIG_VIDEO_ADV_DEBUG
>>>    	if (!gspca_dev->sd_desc->get_register)
>>>    		v4l2_disable_ioctl(&gspca_dev->vdev, VIDIOC_DBG_G_REGISTER);
>>> @@ -2198,8 +1615,8 @@ void gspca_disconnect(struct usb_interface *intf)
>>>    		  video_device_node_name(&gspca_dev->vdev));
>>>    
>>>    	mutex_lock(&gspca_dev->usb_lock);
>>> +	gspca_dev->present = false;
>>>    
>>> -	gspca_dev->present = 0;
>>>    	destroy_urbs(gspca_dev);
>>>    
>>>    #if IS_ENABLED(CONFIG_INPUT)
>>> @@ -2211,11 +1628,8 @@ void gspca_disconnect(struct usb_interface *intf)
>>>    	}
>>>    #endif
>>>    	/* Free subdriver's streaming resources / stop sd workqueue(s) */
>>> -	if (gspca_dev->sd_desc->stop0 && gspca_dev->streaming)
>>> -		gspca_dev->sd_desc->stop0(gspca_dev);
>>> -	gspca_dev->streaming = 0;
>>> +	vb2_queue_release(&gspca_dev->queue);
>>>    	gspca_dev->dev = NULL;
>>> -	wake_up_interruptible(&gspca_dev->wq);
>>>    
>>>    	v4l2_device_disconnect(&gspca_dev->v4l2_dev);
>>>    	video_unregister_device(&gspca_dev->vdev);
>>> @@ -2234,7 +1648,7 @@ int gspca_suspend(struct usb_interface *intf, pm_message_t message)
>>>    
>>>    	gspca_input_destroy_urb(gspca_dev);
>>>    
>>> -	if (!gspca_dev->streaming)
>>> +	if (!vb2_start_streaming_called(&gspca_dev->queue))
>>>    		return 0;
>>>    
>>>    	mutex_lock(&gspca_dev->usb_lock);
>>> @@ -2266,8 +1680,7 @@ int gspca_resume(struct usb_interface *intf)
>>>    	 * only write to the device registers on s_ctrl when streaming ->
>>>    	 * Clear streaming to avoid setting all ctrls twice.
>>>    	 */
>>> -	streaming = gspca_dev->streaming;
>>> -	gspca_dev->streaming = 0;
>>> +	streaming = vb2_start_streaming_called(&gspca_dev->queue);
>>>    	if (streaming)
>>>    		ret = gspca_init_transfer(gspca_dev);
>>>    	else
>>> diff --git a/drivers/media/usb/gspca/gspca.h b/drivers/media/usb/gspca/gspca.h
>>> index 249cb38a542f..b0ced2e14006 100644
>>> --- a/drivers/media/usb/gspca/gspca.h
>>> +++ b/drivers/media/usb/gspca/gspca.h
>>> @@ -9,6 +9,8 @@
>>>    #include <media/v4l2-common.h>
>>>    #include <media/v4l2-ctrls.h>
>>>    #include <media/v4l2-device.h>
>>> +#include <media/videobuf2-v4l2.h>
>>> +#include <media/videobuf2-vmalloc.h>
>>>    #include <linux/mutex.h>
>>>    
>>>    
>>> @@ -138,19 +140,22 @@ enum gspca_packet_type {
>>>    	LAST_PACKET
>>>    };
>>>    
>>> -struct gspca_frame {
>>> -	__u8 *data;			/* frame buffer */
>>> -	int vma_use_count;
>>> -	struct v4l2_buffer v4l2_buf;
>>> +struct gspca_buffer {
>>> +	struct vb2_v4l2_buffer vb;
>>> +	struct list_head list;
>>>    };
>>>    
>>> +static inline struct gspca_buffer *to_gspca_buffer(struct vb2_buffer *vb2)
>>> +{
>>> +	return container_of(vb2, struct gspca_buffer, vb.vb2_buf);
>>> +}
>>> +
>>>    struct gspca_dev {
>>>    	struct video_device vdev;	/* !! must be the first item */
>>>    	struct module *module;		/* subdriver handling the device */
>>>    	struct v4l2_device v4l2_dev;
>>>    	struct usb_device *dev;
>>> -	struct file *capt_file;		/* file doing video capture */
>>> -					/* protected by queue_lock */
>>> +
>>>    #if IS_ENABLED(CONFIG_INPUT)
>>>    	struct input_dev *input_dev;
>>>    	char phys[64];			/* physical device path */
>>> @@ -176,34 +181,29 @@ struct gspca_dev {
>>>    	struct urb *int_urb;
>>>    #endif
>>>    
>>> -	__u8 *frbuf;				/* buffer for nframes */
>>> -	struct gspca_frame frame[GSPCA_MAX_FRAMES];
>>> -	u8 *image;				/* image beeing filled */
>>> -	__u32 frsz;				/* frame size */
>>> +	u8 *image;				/* image being filled */
>>>    	u32 image_len;				/* current length of image */
>>> -	atomic_t fr_q;				/* next frame to queue */
>>> -	atomic_t fr_i;				/* frame being filled */
>>> -	signed char fr_queue[GSPCA_MAX_FRAMES];	/* frame queue */
>>> -	char nframes;				/* number of frames */
>>> -	u8 fr_o;				/* next frame to dequeue */
>>>    	__u8 last_packet_type;
>>>    	__s8 empty_packet;		/* if (-1) don't check empty packets */
>>> -	__u8 streaming;			/* protected by both mutexes (*) */
>>> +	bool streaming;
>>>    
>>>    	__u8 curr_mode;			/* current camera mode */
>>>    	struct v4l2_pix_format pixfmt;	/* current mode parameters */
>>>    	__u32 sequence;			/* frame sequence number */
>>>    
>>> +	struct vb2_queue queue;
>>> +
>>> +	spinlock_t qlock;
>>> +	struct list_head buf_list;
>>> +
>>>    	wait_queue_head_t wq;		/* wait queue */
>>>    	struct mutex usb_lock;		/* usb exchange protection */
>>> -	struct mutex queue_lock;	/* ISOC queue protection */
>>>    	int usb_err;			/* USB error - protected by usb_lock */
>>>    	u16 pkt_size;			/* ISOC packet size */
>>>    #ifdef CONFIG_PM
>>>    	char frozen;			/* suspend - resume */
>>>    #endif
>>> -	char present;			/* device connected */
>>> -	char nbufread;			/* number of buffers for read() */
>>> +	bool present;
>>>    	char memory;			/* memory type (V4L2_MEMORY_xxx) */
>>>    	__u8 iface;			/* USB interface number */
>>>    	__u8 alt;			/* USB alternate setting */
>>> diff --git a/drivers/media/usb/gspca/m5602/m5602_core.c b/drivers/media/usb/gspca/m5602/m5602_core.c
>>> index b83ec4285a0b..30b7cf1feedd 100644
>>> --- a/drivers/media/usb/gspca/m5602/m5602_core.c
>>> +++ b/drivers/media/usb/gspca/m5602/m5602_core.c
>>> @@ -342,7 +342,7 @@ static void m5602_urb_complete(struct gspca_dev *gspca_dev,
>>>    		data += 4;
>>>    		len -= 4;
>>>    
>>> -		if (cur_frame_len + len <= gspca_dev->frsz) {
>>> +		if (cur_frame_len + len <= gspca_dev->pixfmt.sizeimage) {
>>>    			gspca_dbg(gspca_dev, D_FRAM, "Continuing frame %d copying %d bytes\n",
>>>    				  sd->frame_count, len);
>>>    
>>> @@ -351,7 +351,7 @@ static void m5602_urb_complete(struct gspca_dev *gspca_dev,
>>>    		} else {
>>>    			/* Add the remaining data up to frame size */
>>>    			gspca_frame_add(gspca_dev, INTER_PACKET, data,
>>> -				    gspca_dev->frsz - cur_frame_len);
>>> +				gspca_dev->pixfmt.sizeimage - cur_frame_len);
>>>    		}
>>>    	}
>>>    }
>>> diff --git a/drivers/media/usb/gspca/vc032x.c b/drivers/media/usb/gspca/vc032x.c
>>> index 6b11597977c9..52d071659634 100644
>>> --- a/drivers/media/usb/gspca/vc032x.c
>>> +++ b/drivers/media/usb/gspca/vc032x.c
>>> @@ -3642,7 +3642,7 @@ static void sd_pkt_scan(struct gspca_dev *gspca_dev,
>>>    		int size, l;
>>>    
>>>    		l = gspca_dev->image_len;
>>> -		size = gspca_dev->frsz;
>>> +		size = gspca_dev->pixfmt.sizeimage;
>>>    		if (len > size - l)
>>>    			len = size - l;
>>>    	}
>>>
> 
