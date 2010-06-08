Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:50572 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554Ab0FHCcD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Jun 2010 22:32:03 -0400
Date: Mon, 7 Jun 2010 20:31:58 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: Re: [PATCH] Add the viafb video capture driver
Message-ID: <20100607203158.4ec59ab1@bike.lwn.net>
In-Reply-To: <201006080303.14784.laurent.pinchart@ideasonboard.com>
References: <20100607172615.311edce9@bike.lwn.net>
	<201006080303.14784.laurent.pinchart@ideasonboard.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 8 Jun 2010 03:03:14 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:

> If it's not too late for review, here are some comments. I've reviewed the 
> code from bottom to top, so comments might be a bit inconsistent sometimes.

Never too late to make the code better.  These are good comments, thanks.
Mauro, I guess I've got another version coming...:)  It will take me a bit,
I've got another ocean to cross tomorrow.

Specific responses below.  I've snipped out a fair number of comments; that
means "you're right, I'll fix it."

> Don't define device structures as static object. You must kmalloc the 
> via_camera structure in probe and set the pointer as driver private data to 
> access it later in V4L2 operations and device core callbacks. Otherwise Bad 
> Things (TM) will happen if the device is removed while the video device node 
> is opened.

I understand the comment...but this device is blasted onto the system's
base silicon.  It's not going to be removed in a way which leaves a
functioning computer.  Still, dynamic allocation is easy enough to do.

> > +/*
> > + * Configure the sensor.  It's up to the caller to ensure
> > + * that the camera is in the correct operating state.
> > + */
> > +static int viacam_configure_sensor(struct via_camera *cam)
> > +{
> > +	struct v4l2_format fmt;
> > +	int ret;
> > +
> > +	fmt.fmt.pix = cam->sensor_format;
> > +	ret = sensor_call(cam, core, init, 0);
> > +	if (ret == 0)
> > +		ret = sensor_call(cam, video, s_fmt, &fmt);
> > +	/*
> > +	 * OV7670 does weird things if flip is set *before* format...
> 
> What if the user sets vflip using VIDIOC_S_CTRL directly before setting the 
> format ?

All is well; we remember the setting and set the flip properly afterward.

> > +	/*
> > +	 * Copy over the data and let any waiters know.
> > +	 */
> > +	vdma = videobuf_to_dma(vb);
> > +	viafb_dma_copy_out_sg(cam->cb_offsets[bufn], vdma->sglist, vdma->sglen);
> 
> Ouch that's going to hurt performances !
> 
> What are the hardware restrictions regarding the memory it can capture images 
> to ? Does it just have to be physically contiguous, or does the memory need to 
> come from a specific memory area ? In the first case you could use 
> videobuf_dma_contig and avoid the memcpy completely. In the second case you 
> should still mmap the memory to userspace when using kernel-allocated buffers 
> instead of memcpying the data. If you really need a memcpy, you should then 
> probably use videobuf_vmalloc instead of videobuf_dma_sg.

It's a DMA copy, so performance is actually not a problem.

The video capture engine grabs frames into a three-buffer ring stored in
viafb framebuffer memory.  I *could* let user space map that memory
directly, but it would be an eternal race with the engine and would not end
well.  We really do have to do the copy.  In a sense, the framebuffer
memory is just part of the capture device; the DMA operation is how we make
data available to the rest of the system.

[Incidentally, the biggest cost here, I think, is setting up 150 DMA
descriptors for each transfer.  That's an artifact of the page-at-a-time
memory allocation used by videobuf_dma_sg.  I have a branch with an SG
variant which tries to allocate the largest contiguous buffers possible
without going over; it reduces the number of descriptors to about five.  It
didn't change my life a whole lot, so I back-burnered it, but I might
send that patch out one of these days.]

> > +	viacam_write_reg(cam, VCR_CAPINTC, ~VCR_CI_ENABLE);
> > +	viacam_write_reg(cam, VCR_CAPINTC, ~(VCR_CI_ENABLE|VCR_CI_CLKEN));
> 
> I don't know how the VCR_CAPINTC register works, but did you really mean to 
> write all bits to 1 except VCR_CI_ENABLE and VCR_CI_CLKEN ?

Ouch, no, I don't; that's meant to be a mask operation.

> > +	/*
> > +	 * Disable a bunch of stuff.
> > +	 */
> > +	viacam_write_reg(cam, VCR_HORRANGE, 0x06200120);
> > +	viacam_write_reg(cam, VCR_VERTRANGE, 0x01de0000);
> 
> Any idea what that bunch of stuff is ? Replacing the magic numbers by 
> #define'd constants would be nice.

It's 640x480, modulo weird VIA magic.  I got it straight from them.  I can
add a comment, though.

> > +	(void) viacam_read_reg(cam, VCR_CAPINTC); /* Force post */
> 
> Why a (void) cast ?

It's my way of saying that I meant to ignore the return value of a function
whose purpose is to return a value.

> > +static int viacam_vb_buf_setup(struct videobuf_queue *q,
> > +		unsigned int *count, unsigned int *size)
> > +{
> > +	struct via_camera *cam = q->priv_data;
> > +
> > +	*size = cam->user_format.sizeimage;
> > +	if (*count == 0 || *count > 6)  /* Arbitrary number */
> > +		*count = 6;
> 
> Shouldn't the limit should be computed from the available fb memory ?

That would always be three, but user space might well want more buffering
than that.  I don't quite see why the two need to be tied.

> > +static void viacam_vb_buf_queue(struct videobuf_queue *q,
> > +		struct videobuf_buffer *vb)
> > +{
> > +	struct via_camera *cam = q->priv_data;
> > +
> > +	/*
> > +	 * Note that videobuf holds the lock when it calls
> > +	 * us, so we need not (indeed, cannot) take it here.
> > +	 */
> > +	vb->state = VIDEOBUF_QUEUED;
> > +	list_add_tail(&vb->queue, &cam->buffer_queue);
> > +}
> 
> Shouldn't you also pass the buffer to the hardware if the interrupt handler 
> ran out of buffers earlier ?

The hardware doesn't see this buffer directly - that's what the DMA
operation is for.  I *could* track the existence of a ready buffer and DMA
to it immediately, but that risks racing with the engine.  I don't think
it's worth it.

> > +		videobuf_queue_sg_init(&cam->vb_queue, &viacam_vb_ops,
> > +				&cam->platdev->dev, &cam->viadev->reg_lock,
> > +				V4L2_BUF_TYPE_VIDEO_CAPTURE, V4L2_FIELD_NONE,
> > +				sizeof(struct videobuf_buffer), cam);
> 
> Why don't you initialize the queue on probe ?

...because every example I saw does it at open time?  Looking at the code
now, it doesn't look like it needs to be done at open time.

> > +/*
> > + * Control ops are passed through to the sensor.
> > + */
> > +static int viacam_queryctrl(struct file *filp, void *priv,
> > +		struct v4l2_queryctrl *qc)
> > +{
> > +	struct via_camera *cam = priv;
> > +	int ret;
> > +
> > +	mutex_lock(&cam->lock);
> > +	ret = sensor_call(cam, core, queryctrl, qc);
> > +	mutex_unlock(&cam->lock);
> 
> If the sensor needs locking shouldn't it provide it itself ?

Maybe, but ov7670 doesn't do that.  Changing that would be a job for a
different patch set.

> > +static int viacam_querycap(struct file *filp, void *priv,
> > +		struct v4l2_capability *cap)
> > +{
> > +	strcpy(cap->driver, "via-camera");
> > +	strcpy(cap->card, "via-camera");
> > +	cap->version = 1;
> 
> According to the V4L2 spec the version number should be formatted using 
> KERNEL_VERSION().

Interesting, I'd missed that.  I've just optimized a call to
KERNEL_VERSION(0, 0, 1) :)

> > +static int viacam_streamoff(struct file *filp, void *priv, enum
> > v4l2_buf_type t) +{
> > +	struct via_camera *cam = priv;
> > +	int ret;
> > +
> > +	if (t != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> > +		return -EINVAL;
> > +	pm_qos_remove_requirement(PM_QOS_CPU_DMA_LATENCY, "viafb-dma");
> > +	viacam_stop_engine(cam);
> 
> If the user calls VIDIOC_STREAMOFF twice you will try to remove the DMA 
> latency requirement and stop the engine twice. Is that OK ?

Probably, but it should still check the state.  Plus there's the little
detail that pm_qos_remove_requirement() doesn't exist in 2.6.35...I *know*
I did that merge, I'm not quite sure why it's not reflected here.

> > +static struct video_device viacam_v4l_template = {
> > +	.name		= "via-camera",
> > +	.minor		= -1,
> > +	.tvnorms	= V4L2_STD_NTSC_M,
> > +	.current_norm	= V4L2_STD_NTSC_M,
> 
> It's a webcam, norms don't make sense.

I agree they don't make sense.  When I did the cafe_ccic driver, though, I
found that applications failed if they didn't get some sort of answer
here.  Has that situation improved?

> > +static int viacam_init(void)
> > +{
> > +#ifdef CONFIG_OLPC_XO_1_5
> > +	if (viacam_check_serial_port())
> > +		return -EBUSY;
> > +#endif
> 
> Should this prevent the driver from being loaded at all, or would it
> better to perform the check in the probe function ?

Arguably this code should't be here at all; it really only exists for OLPC
developers.  But, then, perhaps somebody else will be trying to debug
something on an XO 1.5 and will appreciate the check.  Load time and probe
time are almost the same, so I'm not sure it makes a difference one way or
the other, except that a probe-time failure leaves a useless module in the
kernel.

Thanks,

jon
