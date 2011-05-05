Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47051 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214Ab1EEMZN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 May 2011 08:25:13 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v4 3/3] v4l: Add v4l2 subdev driver for S5P/EXYNOS4 MIPI-CSI receivers
Date: Thu, 5 May 2011 14:25:44 +0200
Cc: Sylwester Nawrocki <snjw23@gmail.com>,
	"linux-media" <linux-media@vger.kernel.org>,
	"linux-samsung-soc" <linux-samsung-soc@vger.kernel.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Heungjun Kim <riverful.kim@samsung.com>,
	Sungchun Kang <sungchun.kang@samsung.com>,
	Jonghun Han <jonghun.han@samsung.com>
References: <1303399264-3849-1-git-send-email-s.nawrocki@samsung.com> <201105041400.29090.laurent.pinchart@ideasonboard.com> <4DC26EE7.2040205@samsung.com>
In-Reply-To: <4DC26EE7.2040205@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105051425.45392.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Sylwester,

On Thursday 05 May 2011 11:33:27 Sylwester Nawrocki wrote:
> On 05/04/2011 02:00 PM, Laurent Pinchart wrote:
> > On Tuesday 03 May 2011 20:07:43 Sylwester Nawrocki wrote:
> >> On 05/03/2011 11:16 AM, Laurent Pinchart wrote:
> >>> On Thursday 21 April 2011 17:21:04 Sylwester Nawrocki wrote:
> > [snip]
> > 
> >>>> +	struct media_pad pads[CSIS_PADS_NUM];
> >>>> +	struct v4l2_subdev sd;
> >>>> +	struct platform_device *pdev;
> >>>> +	struct resource *regs_res;
> >>>> +	void __iomem *regs;
> >>>> +	struct clk *clock[NUM_CSIS_CLOCKS];
> >>>> +	int irq;
> >>>> +	struct regulator *supply;
> >>>> +	u32 flags;
> >>>> +	/* Common format for the source and sink pad. */
> >>>> +	const struct csis_pix_format *csis_fmt;
> >>>> +	struct v4l2_mbus_framefmt mf[CSIS_NUM_FMTS];
> >>> 
> >>> As try formats are stored in the file handle, and as the formats on the
> >>> sink and source pads are identical, a single v4l2_mbus_framefmt will do
> >>> here.
> >> 
> >> Ok. How about a situation when the caller never provides a file handle?
> >> Is it not supposed to happen?
> > 
> > Good question :-) The subdev pad-level operations have been designed with
> > a userspace interface in mind, so they require a file handle to store
> > try the formats (and crop rectangles).
> > 
> >> For V4L2_SUBDEV_FORMAT_TRY, should set_fmt just abandon storing the
> >> format and should get_fmt just return -EINVAL when passed fh == NULL ?
> > 
> > For such a simple subdev, that should work as a workaround, yes. You can
> > use it as a temporary solution at least.
> > 
> >> Or should the host driver allocate the file handle just for the sake of
> >> set_fmt/get_fmt calls (assuming that cropping ops are not supported
> >> by the subdev) ?
> > 
> > That's another solution. We could also pass an internal structure that
> > contains formats and crop rectangles to the pad operations handlers,
> > instead of passing the whole file handle. Do you think that would be
> > better ?
> 
> So it would then be an additional argument for the pad-level operations ?

It would replace the file handle argument.

> Perhaps that would make sense when both format and crop information is
> needed at the same time in the subdev driver. However this would only be
> required for TRY formats/crop rectangles which wouldn't be supported anyway
> because of missing file handle.. or I missed something?

The reason why we pass the file handle to the pad operations is to let drivers 
access formats/crop try settings that are stored in the file handle. If we 
moved those settings to a separate structure, and embedded that structure into 
the file handle structure, we could pass &fh->settings instead of fh to the 
pad operations. Drivers that want to call pad operations would then need to 
allocate a settings structure, instead of a complete fake fh.

> Furthermore I assume more complex pipelines will be handled in user space

The pad-level API has been designed to get/set formats/crop settings directly 
from userspace, not from inside the kernel, so that would certainly work.

> and the host drivers could store format and crop information locally
> directly from v4l2_subdev_format and v4l2_subdev_crop data structures.

I'm not sure to understand what you mean there.

> > Quoting one of your comments below,
> > 
> >                         x--- FIMC_0 (/dev/video1)
> >  
> >  SENSOR -> MIPI_CSIS  --|
> >  
> >                         x--- FIMC_1 (/dev/video3)
> > 
> > How do you expect to configure the MIPI_CSIS block from the FIMC_0 and
> > FIMC_1 blocks, without any help from userspace ? Conflicts will need to
> > be handled, and the best way to handle them is to have userspace
> > configuring the MIPI_CSIS explicitly.
> 
> My priority is to make work the configurations without device nodes at
> sensor and MIPI CSIS subdevs.
> 
> I agree it would be best to leave the negotiation logic to user space,
> however I need to assure the regular V4L2 application also can use the
> driver.
> 
> My idea was to only try format at CSI slave and sensor subdevs when S_FMT
> is called on a video node. So the sensor and CSIS constraints are taken
> into account.
>
> Then from VIDIOC_STREAMON, formats at pipeline elements would be set on
> subdevs without device node or validated on subdevs providing a device
> node.

For subdevs without device nodes, why don't you set the active format directly 
when S_FMT is called, instead of postponing the operation until 
VIDIOC_STREAMON time ? You wouldn't need to use TRY formats then.

> Another issue is v4l2 controls. The subdevs are now in my case registered
> to a v4l2_device instance embedded in the media device driver. The video
> node drivers (FIMC0...FIMC3) have their own v4l2_device instances. So the
> control inheritance between video node and a subdevs is gone :/, i.e. I
> couldn't find a standard way to remove back from a parent control handler
> the controls which have been added to it with v4l2_ctrl_handler_add().

I think you should expose sensor controls through subdev devices nodes, not 
through the V4L2 device node.
 
> I've had similar issue with subdev -> v4l2_device notify callback. Before,
> when the subdev was directly registered to a v4l2_instance associated with
> a video node, v4l2_subdev_notify had been propagated straight to FIMC{N}
> device the subdev was attached to.
> Now I just redirect notifications ending up in the media device driver to
> relevant FIMC{N} device instance depending on link configuration.
>
> >>>> +#define csis_pad_valid(pad) (pad == CSIS_PAD_SOURCE || pad ==
> >>>> CSIS_PAD_SINK) +
> >>>> +static struct csis_state *sd_to_csis_state(struct v4l2_subdev *sdev)
> >>>> +{
> >>>> +	return container_of(sdev, struct csis_state, sd);
> >>>> +}
> >>>> +
> >>>> +static const struct csis_pix_format *find_csis_format(
> >>>> +	struct v4l2_mbus_framefmt *mf)
> >>>> +{
> >>>> +	int i = ARRAY_SIZE(s5pcsis_formats);
> >>>> +
> >>>> +	while (--i>= 0)
> >>> 
> >>> I'm curious, why do you search backward instead of doing the usual
> >>> 
> >>> for (i = 0; i<  ARRAY_SIZE(s5pcsis_formats); ++i)
> >>> 
> >>> (in that case 'i' could be unsigned) ?
> >> 
> >> Perhaps doing it either way does not make any difference with the
> >> toolchains we use, but the loops with test for 0 are supposed to be
> >> faster on ARM.
> > 
> > I didn't know that. I wonder if it makes a real difference with gcc.
> 
> I've checked it and gcc 4.5 seem to produce identical number of
> instructions for both statements, regardless of the optimization level.
> Although it may also depend on the architecture version.
> 
> The topic is presented in
> http://infocenter.arm.com/help/topic/com.arm.doc.dui0056d/DUI0056.pdf
> chapter 5.3.
> However this is really old book now :-)

Yes it is :-)

(and I can't find this topic in chapter 5.3)

-- 
Regards,

Laurent Pinchart
