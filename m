Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49502 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752902AbdLRP2e (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Dec 2017 10:28:34 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: jacopo mondi <jacopo@jmondi.org>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, magnus.damm@gmail.com,
        geert@glider.be, mchehab@kernel.org, hverkuil@xs4all.nl,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 03/10] v4l: platform: Add Renesas CEU driver
Date: Mon, 18 Dec 2017 17:28:43 +0200
Message-ID: <12410142.shlMUBZBeR@avalon>
In-Reply-To: <20171218122512.GG20926@w540>
References: <1510743363-25798-1-git-send-email-jacopo+renesas@jmondi.org> <2710170.YbEgzp5Yxe@avalon> <20171218122512.GG20926@w540>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On Monday, 18 December 2017 14:25:12 EET jacopo mondi wrote:
> On Mon, Dec 11, 2017 at 06:15:23PM +0200, Laurent Pinchart wrote:
> > Hi Jacopo,
> > 
> > Thank you for the patch.
> 
> [snip]
> 
> >> +
> >> +/**
> >> + * ceu_buffer - Link vb2 buffer to the list of available buffers
> > 
> > If you use kerneldoc comments please make them compile. You need to
> > document the structure fields and function arguments.
> 
> Ok, no kernel doc for internal structures then and no kernel doc for
> ugly comments you pointed out below

You can use kerneldoc if you want to, but if you do please make sure it 
compiles :-)

> [snip]
> 
> >> +/**
> >> + * ceu_soft_reset() - Software reset the CEU interface
> >> + */
> >> +static int ceu_soft_reset(struct ceu_device *ceudev)
> >> +{
> >> +	unsigned int reset_done;
> >> +	unsigned int i;
> >> +
> >> +	ceu_write(ceudev, CEU_CAPSR, CEU_CAPSR_CPKIL);
> >> +
> >> +	reset_done = 0;
> >> +	for (i = 0; i < 1000 && !reset_done; i++) {
> >> +		udelay(1);
> >> +		if (!(ceu_read(ceudev, CEU_CSTSR) & CEU_CSTRST_CPTON))
> >> +			reset_done++;
> >> +	}
> > 
> > How many iterations does this typically require ? Wouldn't a sleep be
> > better than a delay ? As far as I can tell the ceu_soft_reset() function
> > is only called with interrupts disabled (in interrupt context) from
> > ceu_capture() in an error path, and that code should be reworked to make
> > it possible to sleep if a reset takes too long.
> 
> The HW manual does not provide any indication about absolute timings.
> I can empirically try and see, but that would just be a hint.

That's why I asked how many iterations it typically takes :-) A hint is enough 
to start with, preferably on both SH and ARM SoCs.

> Also, the reset function is called in many places (runtime_pm
> suspend/resume) s_stream(0) and in error path of ceu_capture().
> 
> In ceu_capture() we reset the interface if the previous frame was bad,
> and we do that before re-enabling the capture interrupt (so interrupts
> are not -disabled-, just the one we care about is not enabled yet..)

The ceu_capture() function is called from the driver's interrupt handler, so 
interrupts are disabled in that code path.

> But that's not big deal, as if we fail there, we are about to abort
> capture anyhow and so if we miss some spurious capture interrupt it's
> ok...
> 
> >> +	if (!reset_done) {
> >> +		v4l2_err(&ceudev->v4l2_dev, "soft reset time out\n");
> > 
> > How about dev_err() instead ?
> 
> Is dev_err/dev_dbg preferred over v4l2_err/v4l2_dbg? Is this because
> of dynamic debug?

Yes, and the fact that the V4L2 macros don't provide us anymore with much 
compared to the dev_* macros.

> >> +
> >> +/**
> >> + * ceu_capture() - Trigger start of a capture sequence
> >> + *
> >> + * Return value doesn't reflect the success/failure to queue the new
> >> buffer,
> >> + * but rather the status of the previous capture.
> >> + */
> >> +static int ceu_capture(struct ceu_device *ceudev)
> >> +{
> >> +	struct v4l2_pix_format_mplane *pix = &ceudev->v4l2_pix;
> >> +	dma_addr_t phys_addr_top;
> >> +	u32 status;
> >> +
> >> +	/* Clean interrupt status and re-enable interrupts */
> >> +	status = ceu_read(ceudev, CEU_CETCR);
> >> +	ceu_write(ceudev, CEU_CEIER,
> >> +		  ceu_read(ceudev, CEU_CEIER) & ~CEU_CEIER_MASK);
> >> +	ceu_write(ceudev, CEU_CETCR, ~status & CEU_CETCR_MAGIC);
> >> +	ceu_write(ceudev, CEU_CEIER, CEU_CEIER_MASK);
> > 
> > I wonder why there's a need to disable and reenable interrupts here.
> 
> The original driver clearly said "The hardware is -very- picky about
> this sequence" and I got scared and nerver touched this.

How about experimenting to see how the hardware reacts ?

> Also, I very much dislike the CEU_CETRC_MAGIC mask, but again the old driver
> said "Acknoledge magical interrupt sources" and I was afraid to change it
> (I can rename it though, to something lioke CEU_CETCR_ALL_INT because that's
> what it is, a mask with all available interrupt source enabled).

I think renaming it is a good idea. Additionally, regardless of whether there 
is any hidden interrupt source, the datasheet mentions for all reserved bits 
that "The write  value  should always  be 0". They should read as 0, but 
masking them would be an additional safeguard.

Also not that on the RZ/A1 platform bit 22 is documented as reserved, so you 
might want to compute the mask based on the CEU model.

If you have time you could add a debug print when an undocumented interrupt is 
flagged and see if that happens for real.

> >> +
> >> +static irqreturn_t ceu_irq(int irq, void *data)
> >> +{
> >> +	struct ceu_device *ceudev = data;
> >> +	struct vb2_v4l2_buffer *vbuf;
> >> +	struct ceu_buffer *buf;
> >> +	int ret;
> >> +
> >> +	spin_lock(&ceudev->lock);
> >> +	vbuf = ceudev->active;
> >> +	if (!vbuf)
> >> +		/* Stale interrupt from a released buffer */
> >> +		goto out;
> > 
> > Shouldn't you at least clear the interrupt source (done at the beginning
> > of the ceu_capture() function) in this case ? I'd move the handling of the
> > interrupt status from ceu_capture() to here and pass the status to the
> > capture function. Or even handle the status here completely, as status
> > handling isn't needed when ceu_capture() is called from
> > ceu_start_streaming().
> 
> I'll try to move interrupt management here, and use flags to tell to
> ceu_capture() what happened
> 
> >> +	/* Prepare a new 'active' buffer and trigger a new capture */
> >> +	buf = vb2_to_ceu(vbuf);
> >> +	vbuf->vb2_buf.timestamp = ktime_get_ns();
> >> +
> >> +	if (!list_empty(&ceudev->capture)) {
> >> +		buf = list_first_entry(&ceudev->capture, struct ceu_buffer,
> >> +				       queue);
> >> +		list_del(&buf->queue);
> >> +		ceudev->active = &buf->vb;
> >> +	} else {
> >> +		ceudev->active = NULL;
> >> +	}
> >> +
> >> +	/*
> >> +	 * If the new capture started successfully, mark the previous buffer
> >> +	 * as "DONE".
> >> +	 */
> >> +	ret = ceu_capture(ceudev);
> >> +	if (!ret) {
> >> +		vbuf->field = ceudev->field;
> >> +		vbuf->sequence = ceudev->sequence++;
> > 
> > Shouldn't you set the sequence number even when an error occurs ? You
> > should also complete all buffers with VB2_BUF_STATE_ERROR in that case,
> > as ceu_capture() won't start a new capture, otherwise userspace will hang
> > forever.
> 
> I'll return all buffers in case of failure..
> 
> >> +	}
> >> +
> >> +	vb2_buffer_done(&vbuf->vb2_buf,
> >> +			ret < 0 ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
> >> +
> >> +out:
> >> +	spin_unlock(&ceudev->lock);
> >> +
> >> +	return IRQ_HANDLED;
> > 
> > You shouldn't return IRQ_HANDLED if the IRQ status reported no interrupt.
> 
> Is there a case where we enter the irq handler with no interrupt?

It can happen if the IRQ is shared, which shouldn't be the case here, or if 
there's a bug somewhere, which should also not be the case :-) It's better not 
to fake it though, a large number of unhandled interrupts will cause the 
kernel to disable the CEU master interrupt, while if you make that the IRQs 
are handled the system will slow down to a freeze. Let's not short-circuit the 
safeguard mechanisms.

> >> + * ceu_calc_plane_sizes() - Fill 'struct v4l2_plane_pix_format' per
> >> plane
> >> + *			    information according to the currently configured
> >> + *			    pixel format.
> >> + */
> >> +static int ceu_calc_plane_sizes(struct ceu_device *ceudev,
> >> +				const struct ceu_fmt *ceu_fmt,
> >> +				struct v4l2_pix_format_mplane *pix)
> >> +{
> >> +	struct v4l2_plane_pix_format *plane_fmt = &pix->plane_fmt[0];
> >> +
> >> +	switch (pix->pixelformat) {
> >> +	case V4L2_PIX_FMT_YUYV:
> >> +		pix->num_planes			= 1;
> >> +		plane_fmt[0].bytesperline	= pix->width * ceu_fmt->bpp / 8;
> > 
> > Doesn't the driver support configurable stride ?
> > 
> >> +		plane_fmt[0].sizeimage		= pix->height *
> >> +						  plane_fmt[0].bytesperline;
> > 
> > Padding at the end of the image should be allowed if requested by
> > userspace.
> 
> Isn't stride dependent on the image format only?
> Where do I find informations about userspace requested padding?

Userspace can request a specific bytesperline and sizeimage value. The only 
requirement is that that device should have enough space to store the image, 
so you should increase the requested values if they are too small, but not 
decrease them.

> >> +
> >> +	for (i = 0; i < pix->num_planes; i++) {
> >> +		if (vb2_plane_size(vb, i) < pix->plane_fmt[i].sizeimage) {
> >> +			v4l2_err(&ceudev->v4l2_dev,
> >> +				 "Buffer #%d too small (%lu < %u)\n",
> >> +				 vb->index, vb2_plane_size(vb, i),
> >> +				 pix->plane_fmt[i].sizeimage);
> > 
> > I wouldn't print an error message, otherwise userspace will have yet
> > another way to flood the kernel log.
> 
> dev_dbg for dynamic_debug or drop completely?
> Here and below where you pointed out the same

I'd drop them completely.

> >> +/**
> >> + * ceu_test_mbus_param() - test bus parameters against sensor provided
> >> ones.
> >> + *
> >> + * @return: < 0 for errors
> >> + *	    0 if g_mbus_config is not supported,
> >> + *	    > 0  for bus configuration flags supported by (ceu AND sensor)
> >> + */
> >> +static int ceu_test_mbus_param(struct ceu_device *ceudev)
> >> +{
> >> +	struct v4l2_subdev *sd = ceudev->sd->v4l2_sd;
> >> +	unsigned long common_flags = CEU_BUS_FLAGS;
> >> +	struct v4l2_mbus_config cfg = {
> >> +		.type = V4L2_MBUS_PARALLEL,
> >> +	};
> >> +	int ret;
> >> +
> >> +	ret = v4l2_subdev_call(sd, video, g_mbus_config, &cfg);
> >> +	if (ret < 0 && ret != -ENOIOCTLCMD)
> >> +		return ret;
> >> +	else if (ret == -ENOIOCTLCMD)
> >> +		return 0;
> >> +
> >> +	common_flags = ceu_mbus_config_compatible(&cfg, common_flags);
> >> +	if (!common_flags)
> >> +		return -EINVAL;
> >> +
> >> +	return common_flags;
> > 
> > This is a legacy of soc_camera that tried to negotiate bus parameters with
> > the source subdevice. We have later established that this isn't a good
> > idea, as there could be components on the board that affect those
> > settings (for instance inverters on the synchronization signals). This is
> > why with DT we specify the bus configuration in endpoints on both sides.
> > You should thus always use the bus configuration provided through DT or
> > platform data and ignore the one reported by the subdev.
> 
> Yes, I found that when trying to implement g/s_mbus_config for ov7670
> sensor. I will remove all of this and use flags returned by
> "v4l2_fwnode_endpoint_parse()"
> 
> > [snip]
> > 
> >> +static int ceu_probe(struct platform_device *pdev)
> >> +{
> >> +	struct device *dev = &pdev->dev;
> >> +	struct ceu_device *ceudev;
> >> +	struct resource *res;
> >> +	void __iomem *base;
> >> +	unsigned int irq;
> >> +	int num_sd;
> >> +	int ret;
> >> +
> >> +	ceudev = kzalloc(sizeof(*ceudev), GFP_KERNEL);
> > 
> > The memory is freed in ceu_vdev_release() as expected, but that will only
> > work if the video device is registered. If the subdevs are never bound,
> > the ceudev memory will be leaked if you unbind the CEU device from its
> > driver. In my opinion this calls for registering the video device at
> > probe time (although Hans disagrees).
> 
> Can I do something here to prevent this?

You can register the video node in the probe function ;-) It's a framework 
problem, we need to agree on a solution there before pushing it down to 
drivers.

-- 
Regards,

Laurent Pinchart
