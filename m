Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59238 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751479AbeACLTY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 3 Jan 2018 06:19:24 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: jacopo mondi <jacopo@jmondi.org>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, magnus.damm@gmail.com,
        geert@glider.be, mchehab@kernel.org, hverkuil@xs4all.nl,
        robh+dt@kernel.org, mark.rutland@arm.com,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/9] v4l: platform: Add Renesas CEU driver
Date: Wed, 03 Jan 2018 13:19:44 +0200
Message-ID: <4054216.2BkSFUv9xJ@avalon>
In-Reply-To: <20180103104748.GC9493@w540>
References: <1514469681-15602-1-git-send-email-jacopo+renesas@jmondi.org> <1538398.BnUWTlhJjz@avalon> <20180103104748.GC9493@w540>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On Wednesday, 3 January 2018 12:47:48 EET jacopo mondi wrote:
> On Tue, Jan 02, 2018 at 03:46:27PM +0200, Laurent Pinchart wrote:
> >> +/*
> >> + * ceu_device - CEU device instance
> >> + */
> >> +struct ceu_device {
> >> +	struct device		*dev;
> >> +	struct video_device	vdev;
> >> +	struct v4l2_device	v4l2_dev;
> >> +
> >> +	/* subdevices descriptors */
> >> +	struct ceu_subdev	*subdevs;
> >> +	/* the subdevice currently in use */
> >> +	struct ceu_subdev	*sd;
> >> +	unsigned int		sd_index;
> >> +	unsigned int		num_sd;
> >> +
> >> +	/* platform specific mask with all IRQ sources flagged */
> >> +	u32			irq_mask;
> >> +
> >> +	/* currently configured field and pixel format */
> >> +	enum v4l2_field	field;
> >> +	struct v4l2_pix_format_mplane v4l2_pix;
> >> +
> >> +	/* async subdev notification helpers */
> >> +	struct v4l2_async_notifier notifier;
> >> +	/* pointers to "struct ceu_subdevice -> asd" */
> >> +	struct v4l2_async_subdev **asds;
> >> +
> >> +	/* vb2 queue, capture buffer list and active buffer pointer */
> >> +	struct vb2_queue	vb2_vq;
> >> +	struct list_head	capture;
> >> +	struct vb2_v4l2_buffer	*active;
> >> +	unsigned int		sequence;
> >> +
> >> +	/* mlock - lock device suspend/resume and videobuf2 operations */
> > 
> > In my review of v1 I commented that lock documentation should explain what
> > data is protected by the lock. As my point seems not to have come across
> > it must not have been clear enough, I'll try to fix that.
> > 
> > The purpose of a lock is to protect from concurrent access to a resource.
> > In device drivers resources are in most cases either in-memory data or
> > device registers. To design a good locking scheme you need to ask
> > yourself what resources can be accessed concurrently, and then protect
> > all accesses to those resources using locking primitives. Some accesses
> > don't need to be protected (for instance it's common to initialize
> > structure fields in the probe function where no concurrent access from
> > userspace can occur as device nodes are not registered yet), and locking
> > can then be omitted in a case by case basis.
> > 
> > Lock documentation is essential to understand the locking scheme and
> > should explain what resources are protected by the lock. It's tempting
> > (because it's easy) to instead focus on what code sections the lock
> > covers, but that's not how the locking scheme should be designed, and will
> > eventually be prone to bugs leading to race conditions.
> 
> Thanks, I got this, but that lock is used to protect concurrent
> accesses to suspend/resume (and thus interface reset) and is used as
> vb2 queue lock. I can mention it guards concurrent interfaces resets,
> but I don't see it being that much different from what I already
> mentioned.

You're right, in this case the way videobuf2 operates makes it difficult to 
find out what the lock protects exactly. That's why I don't like locks that 
cover code sections instead of protecting data, they're much harder to check 
for correctness. There's nothing you can do about it.

> > Obviously a lock will end up preventing multiple code sections from
> > running at the same time, but that's the consequence of the locking
> > scheme, it shouldn't be its cause.
> > 
> >> +	struct mutex	mlock;
> >> +
> >> +	/* lock - lock access to capture buffer queue and active buffer */
> >> +	spinlock_t	lock;
> >> +
> >> +	/* base - CEU memory base address */
> >> +	void __iomem	*base;
> >> +};

[snip]

> >> +/* CEU Capture Operations */
> > 
> > Just curious, why have you replaced the block comments by single-line
> > comments ? I pointed out that the format was wrong as you started them
> > with /** and they were not kerneldoc, but I have nothing against
> > splitting the code in sections with headers such as
> > 
> > /* -----------------------------------------------------------------------
> >  * CEU Capture Operations
> >  */
> > 
> > as I do so routinely in my drivers. If that's your preferred style and you
> > thought I asked for a change you can switch back, if you prefer
> > single-line comments that's fine with me too.
> 
> Yes I borrowed that commenting style from other Renesas drivers you
> wrote, so I went for it for consistency.
> 
> I recently read about some discussions on block comments, when Mauro
> was trying to replace /***...***/ block comments with a script, and
> I had the feeling there's not that much love for block comments around
> here, and I also find them a bit invasive.
> 
> I used the
> /* --- Code section --- */
> style in the past which I find is a good balance between
> intrusiveness and noticeability but I don't want to introduce
> yet-another-comment-style so I went for single line and that's it.

I think this is a matter of personal preference and best left to the driver 
author. Of course minimizing the number of style differences is a good idea, 
but I don't see anything wrong with a block comment (quite obviously as I use 
them ;-)) or your /* --- Code section --- */ comment. I find that having a 
comment that stands out improves readability in long source files. It's up to 
you.

> > [snip]
> > 
> >> +/*
> >> + * ceu_calc_plane_sizes() - Fill per-plane 'struct
> >> v4l2_plane_pix_format'
> >> + *			    information according to the currently configured
> >> + *			    pixel format.
> >> + * @ceu_device: CEU device.
> >> + * @ceu_fmt: Active image format.
> >> + * @pix: Pixel format information (store line width and image sizes)
> >> + *
> >> + * Returns 0 for success.
> >> + */
> >> +static int ceu_calc_plane_sizes(struct ceu_device *ceudev,
> >> +				const struct ceu_fmt *ceu_fmt,
> >> +				struct v4l2_pix_format_mplane *pix)
> >> +{
> >> +	unsigned int bpl, szimage;
> >> +
> >> +	switch (pix->pixelformat) {
> >> +	case V4L2_PIX_FMT_YUYV:
> >> +		pix->num_planes	= 1;
> >> +		bpl		= pix->width * ceu_fmt->bpp / 8;
> >> +		szimage		= pix->height * bpl;
> >> +		ceu_update_plane_sizes(&pix->plane_fmt[0], bpl, szimage);
> >> +		break;
> >> +
> >> +	case V4L2_PIX_FMT_NV16:
> >> +	case V4L2_PIX_FMT_NV61:
> >> +		pix->num_planes	= 2;
> >> +		bpl		= pix->width;
> >> +		szimage		= pix->height * pix->width;
> >> +		ceu_update_plane_sizes(&pix->plane_fmt[0], bpl, szimage);
> >> +		ceu_update_plane_sizes(&pix->plane_fmt[1], bpl, szimage);
> >> +		break;
> >> +
> >> +	case V4L2_PIX_FMT_NV12:
> >> +	case V4L2_PIX_FMT_NV21:
> >> +		pix->num_planes	= 2;
> >> +		bpl		= pix->width;
> >> +		szimage		= pix->height * pix->width;
> >> +		ceu_update_plane_sizes(&pix->plane_fmt[0], bpl, szimage);
> >> +		ceu_update_plane_sizes(&pix->plane_fmt[1], bpl, szimage / 2);
> >> +		break;
> >> +
> >> +	default:
> >> +		pix->num_planes	= 0;
> >> +		dev_err(ceudev->dev,
> >> +			"Format 0x%x not supported\n", pix->pixelformat);
> >> +		return -EINVAL;
> > 
> > I think you can remove the default case as ceu_try_fmt() should have
> > validated the format already. The compiler will then likely warn so you
> > need to keep a default cause, but it will never be hit, so it can default
> > to any format you want. The function can then be turned into a void.
> 
> Yes, that was only to silence the compiler actually...

Which has to be done, but let's try to not add dead code :-) Putting the 
default case right below the pixel format that the try format function 
defaults to should be enough for instance.

> >> +	}
> >> +
> >> +	return 0;
> >> +}

-- 
Regards,

Laurent Pinchart
