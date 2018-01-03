Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:54244 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751245AbeACKrz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 3 Jan 2018 05:47:55 -0500
Date: Wed, 3 Jan 2018 11:47:48 +0100
From: jacopo mondi <jacopo@jmondi.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, magnus.damm@gmail.com,
        geert@glider.be, mchehab@kernel.org, hverkuil@xs4all.nl,
        robh+dt@kernel.org, mark.rutland@arm.com,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/9] v4l: platform: Add Renesas CEU driver
Message-ID: <20180103104748.GC9493@w540>
References: <1514469681-15602-1-git-send-email-jacopo+renesas@jmondi.org>
 <1514469681-15602-4-git-send-email-jacopo+renesas@jmondi.org>
 <1538398.BnUWTlhJjz@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1538398.BnUWTlhJjz@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Tue, Jan 02, 2018 at 03:46:27PM +0200, Laurent Pinchart wrote:
> Hi Jacopo,
>
> Thank you for the patch.
>
> > +/*
> > + * ceu_device - CEU device instance
> > + */
> > +struct ceu_device {
> > +	struct device		*dev;
> > +	struct video_device	vdev;
> > +	struct v4l2_device	v4l2_dev;
> > +
> > +	/* subdevices descriptors */
> > +	struct ceu_subdev	*subdevs;
> > +	/* the subdevice currently in use */
> > +	struct ceu_subdev	*sd;
> > +	unsigned int		sd_index;
> > +	unsigned int		num_sd;
> > +
> > +	/* platform specific mask with all IRQ sources flagged */
> > +	u32			irq_mask;
> > +
> > +	/* currently configured field and pixel format */
> > +	enum v4l2_field	field;
> > +	struct v4l2_pix_format_mplane v4l2_pix;
> > +
> > +	/* async subdev notification helpers */
> > +	struct v4l2_async_notifier notifier;
> > +	/* pointers to "struct ceu_subdevice -> asd" */
> > +	struct v4l2_async_subdev **asds;
> > +
> > +	/* vb2 queue, capture buffer list and active buffer pointer */
> > +	struct vb2_queue	vb2_vq;
> > +	struct list_head	capture;
> > +	struct vb2_v4l2_buffer	*active;
> > +	unsigned int		sequence;
> > +
> > +	/* mlock - lock device suspend/resume and videobuf2 operations */
>
> In my review of v1 I commented that lock documentation should explain what
> data is protected by the lock. As my point seems not to have come across it
> must not have been clear enough, I'll try to fix that.
>
> The purpose of a lock is to protect from concurrent access to a resource. In
> device drivers resources are in most cases either in-memory data or device
> registers. To design a good locking scheme you need to ask yourself what
> resources can be accessed concurrently, and then protect all accesses to those
> resources using locking primitives. Some accesses don't need to be protected
> (for instance it's common to initialize structure fields in the probe function
> where no concurrent access from userspace can occur as device nodes are not
> registered yet), and locking can then be omitted in a case by case basis.
>
> Lock documentation is essential to understand the locking scheme and should
> explain what resources are protected by the lock. It's tempting (because it's
> easy) to instead focus on what code sections the lock covers, but that's not
> how the locking scheme should be designed, and will eventually be prone to
> bugs leading to race conditions.

Thanks, I got this, but that lock is used to protect concurrent
accesses to suspend/resume (and thus interface reset) and is used as
vb2 queue lock. I can mention it guards concurrent interfaces resets,
but I don't see it being that much different from what I already
mentioned.

>
> Obviously a lock will end up preventing multiple code sections from running at
> the same time, but that's the consequence of the locking scheme, it shouldn't
> be its cause.
>
> > +	struct mutex	mlock;
> > +
> > +	/* lock - lock access to capture buffer queue and active buffer */
> > +	spinlock_t	lock;
> > +
> > +	/* base - CEU memory base address */
> > +	void __iomem	*base;
> > +};
>
> [snip]
>
> > +/*
> > + * ceu_soft_reset() - Software reset the CEU interface
> > + * @ceu_device: CEU device.
> > + *
> > + * Returns 0 for success, -EIO for error.
> > + */
> > +static int ceu_soft_reset(struct ceu_device *ceudev)
> > +{
> > +	unsigned int i;
> > +
> > +	ceu_write(ceudev, CEU_CAPSR, CEU_CAPSR_CPKIL);
> > +
> > +	for (i = 0; i < 100; i++) {
> > +		udelay(1);
>
> How about moving the delay after the check in case the condition is true
> immediately ?
>
> > +		if (!(ceu_read(ceudev, CEU_CSTSR) & CEU_CSTRST_CPTON))
> > +			break;
> > +	}
> > +
> > +	if (i == 100) {
> > +		dev_err(ceudev->dev, "soft reset time out\n");
> > +		return -EIO;
> > +	}
> > +
> > +	for (i = 0; i < 100; i++) {
> > +		udelay(1);
>
> Same here.
>
> > +		if (!(ceu_read(ceudev, CEU_CAPSR) & CEU_CAPSR_CPKIL))
> > +			return 0;
> > +	}
> > +
> > +	/* if we get here, CEU has not reset properly */
> > +	return -EIO;
> > +}
> > +
> > +/* CEU Capture Operations */
>
> Just curious, why have you replaced the block comments by single-line comments
> ? I pointed out that the format was wrong as you started them with /** and
> they were not kerneldoc, but I have nothing against splitting the code in
> sections with headers such as
>
> /* --------------------------------------------------------------------------
>  * CEU Capture Operations
>  */
>
> as I do so routinely in my drivers. If that's your preferred style and you
> thought I asked for a change you can switch back, if you prefer single-line
> comments that's fine with me too.

Yes I borrowed that commenting style from other Renesas drivers you
wrote, so I went for it for consistency.

I recently read about some discussions on block comments, when Mauro
was trying to replace /***...***/ block comments with a script, and
I had the feeling there's not that much love for block comments around
here, and I also find them a bit invasive.

I used the
/* --- Code section --- */
style in the past which I find is a good balance between
intrusiveness and noticeability but I don't want to introduce
yet-another-comment-style so I went for single line and that's it.

>
> [snip]
>
> > +/*
> > + * ceu_calc_plane_sizes() - Fill per-plane 'struct v4l2_plane_pix_format'
> > + *			    information according to the currently configured
> > + *			    pixel format.
> > + * @ceu_device: CEU device.
> > + * @ceu_fmt: Active image format.
> > + * @pix: Pixel format information (store line width and image sizes)
> > + *
> > + * Returns 0 for success.
> > + */
> > +static int ceu_calc_plane_sizes(struct ceu_device *ceudev,
> > +				const struct ceu_fmt *ceu_fmt,
> > +				struct v4l2_pix_format_mplane *pix)
> > +{
> > +	unsigned int bpl, szimage;
> > +
> > +	switch (pix->pixelformat) {
> > +	case V4L2_PIX_FMT_YUYV:
> > +		pix->num_planes	= 1;
> > +		bpl		= pix->width * ceu_fmt->bpp / 8;
> > +		szimage		= pix->height * bpl;
> > +		ceu_update_plane_sizes(&pix->plane_fmt[0], bpl, szimage);
> > +		break;
> > +
> > +	case V4L2_PIX_FMT_NV16:
> > +	case V4L2_PIX_FMT_NV61:
> > +		pix->num_planes	= 2;
> > +		bpl		= pix->width;
> > +		szimage		= pix->height * pix->width;
> > +		ceu_update_plane_sizes(&pix->plane_fmt[0], bpl, szimage);
> > +		ceu_update_plane_sizes(&pix->plane_fmt[1], bpl, szimage);
> > +		break;
> > +
> > +	case V4L2_PIX_FMT_NV12:
> > +	case V4L2_PIX_FMT_NV21:
> > +		pix->num_planes	= 2;
> > +		bpl		= pix->width;
> > +		szimage		= pix->height * pix->width;
> > +		ceu_update_plane_sizes(&pix->plane_fmt[0], bpl, szimage);
> > +		ceu_update_plane_sizes(&pix->plane_fmt[1], bpl, szimage / 2);
> > +		break;
> > +
> > +	default:
> > +		pix->num_planes	= 0;
> > +		dev_err(ceudev->dev,
> > +			"Format 0x%x not supported\n", pix->pixelformat);
> > +		return -EINVAL;
>
> I think you can remove the default case as ceu_try_fmt() should have validated
> the format already. The compiler will then likely warn so you need to keep a
> default cause, but it will never be hit, so it can default to any format you
> want. The function can then be turned into a void.

Yes, that was only to silence the compiler actually...

>
> > +	}
> > +
> > +	return 0;
> > +}
>
> [snip]
>
> > +/*
> > + * ceu_set_default_fmt() - Apply default NV16 memory output format with VGA
> > + *			   sizes.
> > + */
> > +static int ceu_set_default_fmt(struct ceu_device *ceudev)
> > +{
> > +	struct v4l2_format v4l2_fmt = {
> > +		.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE,
> > +		.fmt.pix_mp = {
> > +			.width		= VGA_WIDTH,
> > +			.height		= VGA_HEIGHT,
> > +			.field		= V4L2_FIELD_NONE,
> > +			.pixelformat	= V4L2_PIX_FMT_NV16,
> > +			.num_planes	= 2,
> > +			.plane_fmt	= {
> > +				[0]	= {
> > +					.sizeimage = VGA_WIDTH * VGA_HEIGHT * 2,
> > +					.bytesperline = VGA_WIDTH * 2,
> > +				},
> > +				[1]	= {
> > +					.sizeimage = VGA_WIDTH * VGA_HEIGHT * 2,
> > +					.bytesperline = VGA_WIDTH * 2,
> > +				},
> > +			},
> > +		},
> > +	};
> > +
> > +	ceu_try_fmt(ceudev, &v4l2_fmt);
>
> You've removed the error check here. ceu_try_fmt() shouldn't fail, but it
> calls a sensor driver subdev operation over which you have no control. It's up
> to you, but if you decide to ignore errors, I would turn this function into
> void.
>
> I know I've asked in my review of v1 for the error check to be removed, but I
> think I had missed the fact that a subdev operation was called.
>

Yes, and I blindly changed it, so my bad as well..


> > +	ceudev->v4l2_pix = v4l2_fmt.fmt.pix_mp;
> > +
> > +	return 0;
> > +}
>
> [snip]
>
>
>
> [snip]
>

I have now fixed all of the above comments, and will send v3 shortly!

Thanks
   j

> --
> Regards,
>
> Laurent Pinchart
>
