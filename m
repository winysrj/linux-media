Return-path: <mchehab@pedra>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:41430 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab1EEJdb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 May 2011 05:33:31 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=UTF-8
Date: Thu, 05 May 2011 11:33:27 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v4 3/3] v4l: Add v4l2 subdev driver for S5P/EXYNOS4
	MIPI-CSI receivers
In-reply-to: <201105041400.29090.laurent.pinchart@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sylwester Nawrocki <snjw23@gmail.com>,
	linux-media <linux-media@vger.kernel.org>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Heungjun Kim <riverful.kim@samsung.com>,
	Sungchun Kang <sungchun.kang@samsung.com>,
	Jonghun Han <jonghun.han@samsung.com>
Message-id: <4DC26EE7.2040205@samsung.com>
References: <1303399264-3849-1-git-send-email-s.nawrocki@samsung.com>
 <201105031116.04467.laurent.pinchart@ideasonboard.com>
 <4DC0446F.7020500@gmail.com>
 <201105041400.29090.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent,

On 05/04/2011 02:00 PM, Laurent Pinchart wrote:
> Hi Sylwester,
> 
> On Tuesday 03 May 2011 20:07:43 Sylwester Nawrocki wrote:
>> On 05/03/2011 11:16 AM, Laurent Pinchart wrote:
>>> On Thursday 21 April 2011 17:21:04 Sylwester Nawrocki wrote:
> 
> [snip]
> 
>>>> +	struct media_pad pads[CSIS_PADS_NUM];
>>>> +	struct v4l2_subdev sd;
>>>> +	struct platform_device *pdev;
>>>> +	struct resource *regs_res;
>>>> +	void __iomem *regs;
>>>> +	struct clk *clock[NUM_CSIS_CLOCKS];
>>>> +	int irq;
>>>> +	struct regulator *supply;
>>>> +	u32 flags;
>>>> +	/* Common format for the source and sink pad. */
>>>> +	const struct csis_pix_format *csis_fmt;
>>>> +	struct v4l2_mbus_framefmt mf[CSIS_NUM_FMTS];
>>>
>>> As try formats are stored in the file handle, and as the formats on the
>>> sink and source pads are identical, a single v4l2_mbus_framefmt will do
>>> here.
>>
>> Ok. How about a situation when the caller never provides a file handle?
>> Is it not supposed to happen?
> 
> Good question :-) The subdev pad-level operations have been designed with a 
> userspace interface in mind, so they require a file handle to store try the 
> formats (and crop rectangles).
> 
>> For V4L2_SUBDEV_FORMAT_TRY, should set_fmt just abandon storing the format
>> and should get_fmt just return -EINVAL when passed fh == NULL ?
> 
> For such a simple subdev, that should work as a workaround, yes. You can use 
> it as a temporary solution at least.
> 
>> Or should the host driver allocate the file handle just for the sake of
>> set_fmt/get_fmt calls (assuming that cropping ops are not supported
>> by the subdev) ?
> 
> That's another solution. We could also pass an internal structure that 
> contains formats and crop rectangles to the pad operations handlers, instead 
> of passing the whole file handle. Do you think that would be better ?

So it would then be an additional argument for the pad-level operations ?
Perhaps that would make sense when both format and crop information is
needed at the same time in the subdev driver. However this would only be
required for TRY formats/crop rectangles which wouldn't be supported anyway
because of missing file handle.. or I missed something?

Furthermore I assume more complex pipelines will be handled in user space
and the host drivers could store format and crop information locally
directly from v4l2_subdev_format and v4l2_subdev_crop data structures.

[snip]
> Quoting one of your comments below,
> 
>                         x--- FIMC_0 (/dev/video1)
>  SENSOR -> MIPI_CSIS  --|
>                         x--- FIMC_1 (/dev/video3)
> 
> How do you expect to configure the MIPI_CSIS block from the FIMC_0 and FIMC_1 
> blocks, without any help from userspace ? Conflicts will need to be handled, 
> and the best way to handle them is to have userspace configuring the MIPI_CSIS 
> explicitly.

My priority is to make work the configurations without device nodes at sensor
and MIPI CSIS subdevs.

I agree it would be best to leave the negotiation logic to user space,
however I need to assure the regular V4L2 application also can use the driver.

My idea was to only try format at CSI slave and sensor subdevs when S_FMT is 
called on a video node. So the sensor and CSIS constraints are taken into account.

Then from VIDIOC_STREAMON, formats at pipeline elements would be set on subdevs
without device node or validated on subdevs providing a device node.

Another issue is v4l2 controls. The subdevs are now in my case registered 
to a v4l2_device instance embedded in the media device driver. The video node
drivers (FIMC0...FIMC3) have their own v4l2_device instances. So the control
inheritance between video node and a subdevs is gone :/, i.e. I couldn't find
a standard way to remove back from a parent control handler the controls which 
have been added to it with v4l2_ctrl_handler_add().

I've had similar issue with subdev -> v4l2_device notify callback. Before, when
the subdev was directly registered to a v4l2_instance associated with a video
node, v4l2_subdev_notify had been propagated straight to FIMC{N} device the subdev
was attached to.
Now I just redirect notifications ending up in the media device driver to
relevant FIMC{N} device instance depending on link configuration.  


[snip]
>>>> +#define csis_pad_valid(pad) (pad == CSIS_PAD_SOURCE || pad ==
>>>> CSIS_PAD_SINK) +
>>>> +static struct csis_state *sd_to_csis_state(struct v4l2_subdev *sdev)
>>>> +{
>>>> +	return container_of(sdev, struct csis_state, sd);
>>>> +}
>>>> +
>>>> +static const struct csis_pix_format *find_csis_format(
>>>> +	struct v4l2_mbus_framefmt *mf)
>>>> +{
>>>> +	int i = ARRAY_SIZE(s5pcsis_formats);
>>>> +
>>>> +	while (--i>= 0)
>>>
>>> I'm curious, why do you search backward instead of doing the usual
>>>
>>> for (i = 0; i<  ARRAY_SIZE(s5pcsis_formats); ++i)
>>>
>>> (in that case 'i' could be unsigned) ?
>>
>> Perhaps doing it either way does not make any difference with the
>> toolchains we use, but the loops with test for 0 are supposed to be faster
>> on ARM.
> 
> I didn't know that. I wonder if it makes a real difference with gcc.

I've checked it and gcc 4.5 seem to produce identical number of instructions
for both statements, regardless of the optimization level. Although it may also
depend on the architecture version.

The topic is presented in 
http://infocenter.arm.com/help/topic/com.arm.doc.dui0056d/DUI0056.pdf
chapter 5.3. 
However this is really old book now :-)


> [snip]
> 
>>>> +static void s5pcsis_try_format(struct v4l2_mbus_framefmt *mf)
>>>> +{
>>>> +	struct csis_pix_format const *csis_fmt;
>>>> +
>>>> +	csis_fmt = find_csis_format(mf);
>>>> +	if (csis_fmt == NULL)
>>>> +		csis_fmt =&s5pcsis_formats[0];
>>>> +
>>>> +	mf->code = csis_fmt->code;
>>>> +	v4l_bound_align_image(&mf->width, 1, CSIS_MAX_PIX_WIDTH,
>>>> +			      csis_fmt->pix_hor_align,
>>>> +			&mf->height, 1, CSIS_MAX_PIX_HEIGHT, 1,
>>>> +			      0);
>>>> +}
>>>> +
>>>> +static int s5pcsis_set_fmt(struct v4l2_subdev *sd, struct
>>>> v4l2_subdev_fh *fh, +			    struct v4l2_subdev_format *fmt)
>>>> +{
>>>> +	struct csis_state *state = sd_to_csis_state(sd);
>>>> +	struct v4l2_mbus_framefmt *mf =&fmt->format;
>>>> +	struct csis_pix_format const *csis_fmt = find_csis_format(mf);
>>>> +
>>>> +	v4l2_dbg(1, debug, sd, "%s: %dx%d, code: %x, csis_fmt: %p\n",
>>>> +		 __func__, mf->width, mf->height, mf->code, csis_fmt);
>>>> +
>>>> +	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
>>>> +		s5pcsis_try_format(mf);
>>>
>>> You need to take the pad into account here. As you mention below, source
>>> and sink formats are identical. When the user tries to set the source
>>> format, the driver should just return the sink format without performing
>>> any modification.

Yeah, that's right. Thanks for the hint.

>>>> +		state->mf[CSIS_FMT_TRY] = *mf;
>>>> +		return 0;
>>>> +	}
>>>> +
>>>> +	/* Both source and sink pad have always same format. */
>>>> +	if (!csis_pad_valid(fmt->pad) ||
>>>> +	    csis_fmt == NULL ||
>>>> +	    mf->width>  CSIS_MAX_PIX_WIDTH  ||
>>>> +	    mf->height>  CSIS_MAX_PIX_HEIGHT ||
>>>> +	    mf->width&  (u32)(csis_fmt->pix_hor_align - 1))
>>>> +		return -EINVAL;
>>>
>>> Don't return an error, adjust the user supplied format instead.
>>>
>>>> +
>>>> +	mutex_lock(&state->lock);
>>>> +	state->mf[CSIS_FMT_ACTIVE] = *mf;
>>>> +	state->csis_fmt = csis_fmt;
>>>> +	mutex_unlock(&state->lock);
>>>
>>> The logic in this function is not correct. First of all, you need to
>>> adjust the user-supplied format in all cases, regardless of the format
>>> type (try/active). Then, as the formats on the sink and source pads are
>>> always identical, you should return the sink pad format when the user
>>> tries to set the source pad format. Setting the source pad format will
>>> have no effect. Finally, you should store try formats in the subdev file
>>> handle, not in the csis_state structure (see ccp2_set_format() in
>>> drivers/media/video/omap3isp/ispccp2.c for an example, in your case you
>>> don't need to propagate the format change from sink to source, as the
>>> source always has the same format as the sink).
>>
>> Thanks, that's all very useful. The only thing I am concerned is what
>> should be done when the file handle is null? Is it not allowed by design?
> 
> It wasn't allowed by design. As explained above, we could replace the file 
> handle with another structure, and have the caller allocate it. In your case 
> you could just skip storing try formats. This needs to be thought about some 
> more.
> 
>> I've initially reworked s5pcsis_set_fmt to something like this:
>>
>> static int s5pcsis_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh
>> *fh, struct v4l2_subdev_format *fmt)
>> {
>> 	struct csis_state *state = sd_to_csis_state(sd);
>> 	struct v4l2_mbus_framefmt *mf = &fmt->format;
>> 	struct csis_pix_format const *csis_fmt;
>>
>> 	v4l2_dbg(1, debug, sd, "%s: %dx%d, code: %x\n",
>> 		 __func__, mf->width, mf->height, mf->code);
>>
>> 	if (!csis_pad_valid(fmt->pad))
>> 		return -EINVAL;
>>
>> 	mutex_lock(&state->lock);
>> 	if (fmt->pad == CSIS_PAD_SOURCE) {
>> 		fmt->format = state->format;
>> 		goto unlock;
>> 	}
>> 	csis_fmt = s5pcsis_try_format(&fmt->format);
> 
> Try try_format call doesn't require the mutex to be locked. You can 
> lock/unlock the mutex around fmt->format = state->format; above, and 
> lock/unlock it around state->formt = fmt->format; state->csis_fmt = csis_fmt; 
> below.
> 
>> 	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
>> 		/* TODO: store format in *fh */
>> 		goto unlock;
>> 	}
>>
>> 	/* Common format for the source and the sink pad */
>> 	state->format = fmt->format;
>> 	state->csis_fmt = csis_fmt;
>>  unlock:
>> 	mutex_unlock(&state->lock);
>> 	return 0;
>> }


Regards,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
