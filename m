Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:58323 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479Ab0FHIX2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Jun 2010 04:23:28 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] Add the viafb video capture driver
Date: Tue, 8 Jun 2010 10:26:08 +0200
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
References: <20100607172615.311edce9@bike.lwn.net> <201006080303.14784.laurent.pinchart@ideasonboard.com> <20100607203158.4ec59ab1@bike.lwn.net>
In-Reply-To: <20100607203158.4ec59ab1@bike.lwn.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006081026.09325.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jonathan,

On Tuesday 08 June 2010 04:31:58 Jonathan Corbet wrote:
> On Tue, 8 Jun 2010 03:03:14 +0200 Laurent Pinchart wrote:

[snip]

> > Don't define device structures as static object. You must kmalloc the
> > via_camera structure in probe and set the pointer as driver private data
> > to access it later in V4L2 operations and device core callbacks.
> > Otherwise Bad Things (TM) will happen if the device is removed while the
> > video device node is opened.
> 
> I understand the comment...but this device is blasted onto the system's
> base silicon.  It's not going to be removed in a way which leaves a
> functioning computer.  Still, dynamic allocation is easy enough to do.

I think it would still be better. The hardware device can't be removed (unless 
you seriously damage the system, but you'll have other problems then :-)) but 
the platform device could easily be unregistered. It's a good practice not to 
store instance-specific data in static variables anyway.

[snip]

> > > +	/*
> > > +	 * Copy over the data and let any waiters know.
> > > +	 */
> > > +	vdma = videobuf_to_dma(vb);
> > > +	viafb_dma_copy_out_sg(cam->cb_offsets[bufn], vdma->sglist,
> > > vdma->sglen);
> > 
> > Ouch that's going to hurt performances !
> > 
> > What are the hardware restrictions regarding the memory it can capture
> > images to ? Does it just have to be physically contiguous, or does the
> > memory need to come from a specific memory area ? In the first case you
> > could use videobuf_dma_contig and avoid the memcpy completely. In the
> > second case you should still mmap the memory to userspace when using
> > kernel-allocated buffers instead of memcpying the data. If you really
> > need a memcpy, you should then probably use videobuf_vmalloc instead of
> > videobuf_dma_sg.
> 
> It's a DMA copy, so performance is actually not a problem.
> 
> The video capture engine grabs frames into a three-buffer ring stored in
> viafb framebuffer memory.

OK.

> I *could* let user space map that memory directly, but it would be an
> eternal race with the engine and would not end well. We really do have to
> do the copy.  In a sense, the framebuffer memory is just part of the capture
> device;

Just to make sure I understand things correctly, the hardware captures to a 
dedicated ring buffer continuously, and generates IRQs when the next frame is 
available. No software action is needed to feed the engine with new buffers. 
Is that correct ?

> the DMA operation is how we make data available to the rest of the system.

Is that why you're using a threaded IRQ handler, to wait for the DMA 
completion ? Isn't there a risk of racing with the engine, where the same 
buffer could be overwritten with a new image while DMA is ongoing ? The 
threaded IRQ handler would have to have been delayed quite a lot for that to 
happen though, and I suppose there's not much you can do about it anyway.

> [Incidentally, the biggest cost here, I think, is setting up 150 DMA
> descriptors for each transfer.  That's an artifact of the page-at-a-time
> memory allocation used by videobuf_dma_sg.  I have a branch with an SG
> variant which tries to allocate the largest contiguous buffers possible
> without going over; it reduces the number of descriptors to about five.  It
> didn't change my life a whole lot, so I back-burnered it, but I might
> send that patch out one of these days.]

[snip]

> > > +		videobuf_queue_sg_init(&cam->vb_queue, &viacam_vb_ops,
> > > +				&cam->platdev->dev, &cam->viadev->reg_lock,
> > > +				V4L2_BUF_TYPE_VIDEO_CAPTURE, V4L2_FIELD_NONE,
> > > +				sizeof(struct videobuf_buffer), cam);
> > 
> > Why don't you initialize the queue on probe ?
> 
> ...because every example I saw does it at open time?  Looking at the code
> now, it doesn't look like it needs to be done at open time.

That's one of the problems with videobuf. Drivers often use it in sub-optimal 
ways, or even completely abuse the API, giving a hard time to developers when 
they're looking for examples.

[snip]

> > > +static int viacam_querycap(struct file *filp, void *priv,
> > > +		struct v4l2_capability *cap)
> > > +{
> > > +	strcpy(cap->driver, "via-camera");
> > > +	strcpy(cap->card, "via-camera");
> > > +	cap->version = 1;
> > 
> > According to the V4L2 spec the version number should be formatted using
> > KERNEL_VERSION().
> 
> Interesting, I'd missed that. I've just optimized a call to
> KERNEL_VERSION(0, 0, 1) :)

You've saved the compiler a few cycles. I wonder how many times people will 
need to compile the driver to notice a different in energy consumption and 
green house effect ;-)

[snip]

> > > +static struct video_device viacam_v4l_template = {
> > > +	.name		= "via-camera",
> > > +	.minor		= -1,
> > > +	.tvnorms	= V4L2_STD_NTSC_M,
> > > +	.current_norm	= V4L2_STD_NTSC_M,
> > 
> > It's a webcam, norms don't make sense.
> 
> I agree they don't make sense.  When I did the cafe_ccic driver, though, I
> found that applications failed if they didn't get some sort of answer
> here. Has that situation improved?

Slightly I think. The best way to get applications fixed would be to not 
provide APIs in new drivers that they shouldn't be using :-)

-- 
Regards,

Laurent Pinchart
