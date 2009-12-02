Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1277 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319AbZLBR3T (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Dec 2009 12:29:19 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 1/2 v3] v4l: add a media-bus API for configuring v4l2 subdev pixel and frame formats
Date: Wed, 2 Dec 2009 22:57:33 +0530
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
References: <Pine.LNX.4.64.0911261509100.5450@axis700.grange> <200912020811.12156.hverkuil@xs4all.nl> <Pine.LNX.4.64.0912020847350.4694@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0912020847350.4694@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912022257.33941.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 02 December 2009 13:32:35 Guennadi Liakhovetski wrote:
> Hi Hans
>
> On Wed, 2 Dec 2009, Hans Verkuil wrote:
> > On Tuesday 01 December 2009 16:22:55 Guennadi Liakhovetski wrote:
> > > On Tue, 1 Dec 2009, Hans Verkuil wrote:
> > > > On Monday 30 November 2009 14:49:07 Guennadi Liakhovetski wrote:
> > > > > Right, how about this:
> > > > >
> > > > > /*
> > > > >  * These pixel codes uniquely identify data formats on the media
> > > > > bus. Mostly * they correspond to similarly named V4L2_PIX_FMT_*
> > > > > formats, format 0 is * reserved, V4L2_MBUS_FMT_FIXED shall be used
> > > > > by host-client pairs, where the * data format is fixed.
> > > > > Additionally, "2X8" means that one pixel is transferred * in two
> > > > > 8-bit samples, "BE" or "LE" specify in which order those samples
> > > > > are * transferred over the bus: "LE" means that the least
> > > > > significant bits are * transferred first, "BE" means that the most
> > > > > significant bits are transferred * first, and "PADHI" and "PADLO"
> > > > > define which bits - low or high, in the * incomplete high byte, are
> > > > > filled with padding bits.
> > > > >  */
> > > > > enum v4l2_mbus_pixelcode {
> > > > > 	V4L2_MBUS_FMT_FIXED = 1,
> > > > > 	V4L2_MBUS_FMT_YUYV_2X8_LE,
> > > > > 	V4L2_MBUS_FMT_YVYU_2X8_LE,
> > > > > 	V4L2_MBUS_FMT_UYVY_2X8_LE,
> > > > > 	V4L2_MBUS_FMT_VYUY_2X8_LE,
> > > >
> > > > These possibly may need a comment saying that each Y/U/V sample is 8
> > > > bits wide. I'm not sure how far we want to go with systematic naming
> > > > schemes here. Adding a short comment if there is a possible ambiguity
> > > > is probably sufficient.
> > >
> > > Is there an ambiguity? Aren't these formats standardised?
> >
> > HDMI receivers/transmitters can do YUV with 8, 10 or 12 bits. So when you
> > say YUYV_2X8_LE do you mean that 10 bits are transported over two bytes,
> > or that a Y and a U (or V) are transferred one after another? From the
> > absence of a PADHI or PADLO I can infer that it is the latter, but it is
> > not exactly obvious.
> >
> > Actually, why not name these formats YUYV8, etc. and the order of the
> > bytes going over the bus is just the order of the text 'YUYV'. There is
> > not really any big or little endian issues since you just need to know
> > the sequence of Ys, Us and Vs.
>
> Ok, we could keep discussing these things for a while, but I don't think
> we have that time, and it's not _that_ important to me what these things
> will be called - will use whatever names there are.

I agree that this is dragging on a bit too long. The main reason is my busy 
schedule since normally we could hash this out quickly on irc. Apologies for 
that.

> Just to explain 2X8 - this notation comes from packing and means, to get
> one _pixel_ you need two 8-bit wide samples. With YUYV one pixel is
> defined as YU or YV, so, that gives you (at most) 8 bits per component.
>
> Ok, I'm planning to submit a version of this patch a bit later today with
> names like
>
> enum v4l2_mbus_pixelcode {
> 	V4L2_MBUS_FMT_FIXED = 1,
> 	V4L2_MBUS_FMT_YUYV8,
> 	V4L2_MBUS_FMT_YVYU8,
>
> according to your last suggestion.
>
> > > Do we then have
> > > to explain what rgb555 means etc?
> > >
> > > > > 	V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE,
> > > > > 	V4L2_MBUS_FMT_RGB555X_2X8_PADHI_LE,
> > > >
> > > > Shouldn't this be: V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE? Since the 555X
> > > > format is just the big-endian variant of the RGB555 if I am not
> > > > mistaken.
> > >
> > > No, don't think so. As an RGB555X format it is sent in LE order, if you
> > > send RGB555X in BE order you get RGB555 (without an "X"). In fact,
> > > you'll never have a RGB555X_BE format, because, that's just the
> > > RGB555_LE. So, you may only have BE variants for formats, whoch
> > > byte-swapped variants do not have an own name.
> >
> > RGB 5:5:5 consists of 16 bits arrrrrgg gggbbbbb ('a' is either padding or
> > an alpha bit).
>
> From what I read, RGB555 has high bit unused. With the alpha bit (or
> transparency bit) it's already RGBA or RGBT.
>
> > RGB 5:5:5 over an 8 bit data bus is either with the MSB byte first (big
> > endian aka RGB555X aka RGB555_2X8_PADHI_BE) or with the LSB byte first
> > (little endian aka RGB555 aka RGB555_2X8_PADHI_LE).
> >
> > The use of RGB555X in the pixel formats is a really ugly accident of
> > history. 'RGB555' is the name of the format, and _LE or _BE should define
> > what the order of the LSB and MSB over the data bus is.
>
> So, I'll make them
>
> 	V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE,
> 	V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE,
>
> and "555X" will just vanish?

Yup.

>
> > > > > 	V4L2_MBUS_FMT_RGB565_2X8_LE,
> > > > > 	V4L2_MBUS_FMT_RGB565X_2X8_LE,
> > > >
> > > > Ditto.
> > > >
> > > > > 	V4L2_MBUS_FMT_SBGGR8_1X8,
> > > > > 	V4L2_MBUS_FMT_SBGGR10_1X10,
> > > > > 	V4L2_MBUS_FMT_GREY_1X8,
> > > >
> > > > This is also 8 bits per sample, right? This might be renamed to
> > > > GREY8_1X8.
> > >
> > > I named it after V4L2_PIX_FMT_GREY. If we ever get GREY7 or similar, I
> > > think, we anyway will need a new fourcc code for it, then we'll call
> > > the MBUS_FMT similarly.
> >
> > Why not do it right from the start? Frankly, the PIX_FMT names aren't
> > that great. And since this will become a public API in the future I think
> > it is reasonable to spend some time on it (and it is the reason why I'm
> > so picky about it :-) ).
>
> The whole then becomes:
>
> /*
>  * These pixel codes uniquely identify data formats on the media bus.
> Mostly * they correspond to similarly named V4L2_PIX_FMT_* formats, format
> 0 is * reserved, V4L2_MBUS_FMT_FIXED shall be used by host-client pairs,
> where the * data format is fixed. Additionally, "2X8" means that one pixel
> is transferred * in two 8-bit samples, "BE" or "LE" specify in which order
> those samples are * transferred over the bus: "LE" means that the least
> significant bits are * transferred first, "BE" means that the most
> significant bits are transferred * first, and "PADHI" and "PADLO" define
> which bits - low or high, in the * incomplete high byte, are filled with
> padding bits.
>  */
> enum v4l2_mbus_pixelcode {
> 	V4L2_MBUS_FMT_FIXED = 1,
> 	V4L2_MBUS_FMT_YUYV8,
> 	V4L2_MBUS_FMT_YVYU8,
> 	V4L2_MBUS_FMT_UYVY8,
> 	V4L2_MBUS_FMT_VYUY8,
> 	V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE,
> 	V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE,
> 	V4L2_MBUS_FMT_RGB565_2X8_LE,
> 	V4L2_MBUS_FMT_RGB565_2X8_BE,
> 	V4L2_MBUS_FMT_SBGGR8_1X8,
> 	V4L2_MBUS_FMT_SBGGR10_1X10,
> 	V4L2_MBUS_FMT_GREY8_1X8,
> 	V4L2_MBUS_FMT_Y10_1X10,
> 	V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE,
> 	V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_BE,
> 	V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE,
> 	V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_LE,
> };
>
> Agree? Would be much appreciated if you could reply yet today.

Looking at this I propose that we drop the '_1X8' and '_1X10' suffixes. I 
think it is reasonable to assume that without that suffix all pins are used 
for each sample.

Either that or we need to add _1X8 to the four YUV formats at the start to be 
consistent, but I prefer to just drop it. I leave this up to you.

Regards,

	Hans

PS: I really appreciate the work you are doing. If I sometimes sound abrupt 
then that has everything to do with lack of time on my side and nothing to do 
with the great job you are doing.

>
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/

