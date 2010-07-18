Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:1417 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102Ab0GRKTQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Jul 2010 06:19:16 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: Confusing mediabus formats
Date: Sun, 18 Jul 2010 12:21:51 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <201005091032.07893.hverkuil@xs4all.nl> <201007091402.15938.hverkuil@xs4all.nl> <Pine.LNX.4.64.1007141541520.2150@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1007141541520.2150@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007181221.51813.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 14 July 2010 16:53:00 Guennadi Liakhovetski wrote:
> Hi Hans
> 
> Thanks for returning to this topic. Sorry, it took me a few days again to 
> get back to it...
> 
> On Fri, 9 Jul 2010, Hans Verkuil wrote:
> 
> > On Tuesday 11 May 2010 09:07:25 Guennadi Liakhovetski wrote:
> > > On Mon, 10 May 2010, Guennadi Liakhovetski wrote:
> > > 
> > > > (added Laurent to CC as he once asked me about these on IRC too)
> > > > 
> > > > On Sun, 9 May 2010, Hans Verkuil wrote:
> > > > 
> > > > > Hi Guennadi,
> > > > > 
> > > > > I'm preparing a patch series that replaces enum/g/try/s_fmt with
> > > > > enum/g/try/s/_mbus_fmt in all subdevs. While doing that I stumbled on a
> > > > > confusing definition of the YUV mediabus formats. Currently we have these:
> > > > > 
> > > > >         V4L2_MBUS_FMT_YUYV8_2X8_LE,
> > > > >         V4L2_MBUS_FMT_YVYU8_2X8_LE,
> > > > >         V4L2_MBUS_FMT_YUYV8_2X8_BE,
> > > > >         V4L2_MBUS_FMT_YVYU8_2X8_BE,
> > > > > 
> > > > > The meaning of "2X8" is defined as: 'one pixel is transferred in
> > > > > two 8-bit samples'.
> > > > > 
> > > > > This is confusing since you cannot really say that a Y and U pair constitutes
> > > > > one pixel. And is it Y or U/V which constitutes the 'most-significant bits' in
> > > > > such a 16-bit number?
> > > > 
> > > > To recap, as we discussed it earlier this notation was one of your 
> > > > suggestions:
> > > > 
> > > > http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/12830/focus=13394
> > > > 
> > > > Yes, I certainly agree, that LE and BE notations are not necessarily very 
> > > > logical here, as you say, they don't make much sense in the YUV case. But 
> > > > they do, e.g., in RGB565 case, as we discussed this with Laurent on IRC. 
> > > > Basically, the information we want to include in the name is:
> > > > 
> > > > pixel format family (YUYV8)
> > > > number of samples, that constitute one "pixel" (*) and bits per sample
> > > > order of samples in "pixel"
> > > 
> > > Now that I think about it a bit more, it looks like we only have to 
> > > distinguish between two cases: consecutive storage order of samples in 
> > > memory (sample0 to address0, sample1 to address1, etc.) or reverse order. 
> > > This is relatively easy to formulate, when samples span across bytes, but 
> > > not so easy, when they get packed into one byte. E.g., for a 4-bit 
> > > interface, do we have to specify two ordering parameters: nibbles in bytes 
> > > and bytes in memory? Any name propositions for these ordering variants?
> > 
> > Remember that in the case of a bus there are no 'bytes' as such. Just data
> > flowing through the bus.
> > 
> > In all existing mbus_pixelcodes (except the four YUV codes) it is clear what
> > the meaning is:
> > 
> > V4L2_MBUS_FMT_<sample>_<bus width>[_padding][_endianness]
> > 
> > Where <sample> describes what a single pixel sample looks like: the total width and
> > the order of the subsamples inside.
> 
> I think, a more accurate way to describe those names is
> 
> V4L2_MBUS_FMT_<name>_<sample>X<bus width>[_padding][_endianness]
> 
> > The bus width is the number of lines used to transport the sample over the bus.
> > If a sample is split up in two consecutive writes (e.g. 2X8), then additional info
> > is provided for optional padding and endianness.
> 
> Correct.
> 
> > Perfectly understandable.
> > 
> > The problem with the YUV variants is that the term 'sample' does not really apply.
> > It's similar to the V4L2_MBUS_FMT_SBGGR8_1X8 bayer format: here the sample width is
> > just 8 bits and 'BGGR' describes the order of the blue, green and red samples over
> > the bus. I wonder, does the prefix 'S' in the sample description mean that the
> > sub-sample order is described?
> 
> No, the "S" is explained on http://www.siliconimaging.com/RGB%20Bayer.htm 
> as "sequential RGB," where they also refer to it as "sRGB."

Ah, good to know!

> > If so, then to be consistent I would propose these mediabus formats:
> > 
> >         V4L2_MBUS_FMT_SYUYV8_1X8,
> >         V4L2_MBUS_FMT_SYVYU8_1X8,
> >         V4L2_MBUS_FMT_SUYVY8_1X8,
> >         V4L2_MBUS_FMT_SVYUY8_1X8,
> 
> Well, let me explain, what I meant by <sample> in above names. This is 
> just the number of bus sampling operations, needed to capture the number 
> of bits, transferred for each pixel. This is also referred to as "depth," 
> meaning "color depth," in include/linux/videodev2.h in the fourcc code 
> list. E.g.
> 
> format		colour depth
> RGB555		15
> RGB565		16
> YUV4:2:2	16
> SBGGR8 etc.	8
> SBGGR10 etc.	10
> YUV4:2:0	12
> 
> With this in mind all your names above should have _2X8. This just seems 
> more intuitive to me to be able to see immediately how many times you have 
> to sample the bus to get "1 pixel of colour information." This is also 
> consistent with V4L2_MBUS_FMT_SBGGR8_1X8 - its colour-depth is 8.

I'm sorry, but this simply makes no sense. To get '1 pixel of colour information'
in the case of YUV you would need to sample the bus *4* times to get all the Y, U
and V components. The whole concept of colour-depth is frankly dubious for some of
these formats. For that matter, the concept of 'pixel' is fuzzy as well. It is well
defined for the Y plane, but for the chroma (UV) plane the 'pixels' are actually
spread out over multiple Y pixels.

But the number of bits for each Y, U and V sample is well defined, and I think that
is what we should use. And BTW, 'Sequential YUV' makes sense to me as a name as
well.

> 
> > Regarding 4-bit wide busses: the scheme is generic enough for that:
> > 
> > E.g. V4L2_MBUS_FMT_SYUYV8_1X8 for a 4-bit bus would become:
> > 
> > 	V4L2_MBUS_FMT_SYUYV8_2X4_LE
> > 	V4L2_MBUS_FMT_SYUYV8_2X4_BE
> 
> Ok, this makes sense to me - only let's change them to use _4x4
> 
> > Again, how this ends up in memory is unrelated to these mbus_pixelcodes.
> > 
> > As discussed in Helsinki we need to get this sorted out soon since this header
> > is going to be public in the near future.
> 
> Ok, I agree, that having 
> 
> 	V4L2_MBUS_FMT_YUYV8_2X8,
> 	V4L2_MBUS_FMT_YVYU8_2X8,
> 	V4L2_MBUS_FMT_UYVY8_2X8,
> 	V4L2_MBUS_FMT_VYUY8_2X8,
> 
> is better, than
> 
> 	V4L2_MBUS_FMT_YUYV8_2X8_LE,
> 	V4L2_MBUS_FMT_YVYU8_2X8_LE,
> 	V4L2_MBUS_FMT_YUYV8_2X8_BE,
> 	V4L2_MBUS_FMT_YVYU8_2X8_BE,

Why would V4L2_MBUS_FMT_SBGGR8_1X8 be OK and V4L2_MBUS_FMT_SYUYV8_1X8 be wrong?
I really don't see the difference between the two. Both formats produce a sequence
of 8 bit color components in a particular order.

The only difference is the colorspace used.

> 
> BTW, this "new" version is essentially the same, as what I've had in v1 of 
> my RFC;) (v2 for reference: 
> http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/12830/focus=13394)

We are more or less still having the same discussion. I would like someone else to
jump in as well to break this deadlock.

Regards,

	Hans

> 
> Thanks
> Guennadi
> 
> > 
> > Regards,
> > 
> > 	Hans
> > 
> > > 
> > > Thanks
> > > Guennadi
> > > 
> > > > (*) "pixel" is not necessarily a "complete pixel," i.e., might not carry 
> > > > all colours in it. E.g., in YUYV "pixel" refers to any of the YU and YV 
> > > > pairs. In other words, this is just = frame size * 8 / number of pixels / 
> > > > bits-per-sample.
> > > > 
> > > > > In my particular case I have to translate a V4L2_PIX_FMT_UYVY to a suitable
> > > > > mediabus format. I think it would map to V4L2_MBUS_FMT_YUYV8_2X8_LE, but
> > > > > frankly I'm not sure.
> > > > > 
> > > > > My suggestion is to rename these mediabus formats to:
> > > > > 
> > > > >         V4L2_MBUS_FMT_YUYV8_1X8,
> > > > >         V4L2_MBUS_FMT_YVYU8_1X8,
> > > > >         V4L2_MBUS_FMT_UYVY8_1X8,
> > > > >         V4L2_MBUS_FMT_VYUY8_1X8,
> > > > 
> > > > 
> > > > But what do you do with, e.g., RGB565? Y>ou have to differentiate between
> > > > 
> > > > rrrrrggggggbbbbb
> > > > bbbbbggggggrrrrr
> > > > gggrrrrrbbbbbggg
> > > > gggbbbbbrrrrrggg
> > > > 
> > > > with the current notation they are
> > > > 
> > > > RGB565_2X8_BE
> > > > BGR565_2X8_BE
> > > > BGR565_2X8_LE
> > > > RGB565_2X8_LE
> > > > 
> > > > and how would you call them? And what do you do with Y10_2X8_LE and _BE 
> > > > (padding omitted for simplicity)?
> > > > 
> > > > Also, Laurent has suggested
> > > > 
> > > > 	V4L2_MBUS_FMT_YUYV8_2X8,
> > > > 	V4L2_MBUS_FMT_YVYU8_2X8,
> > > > 	V4L2_MBUS_FMT_UYVY8_2X8,
> > > > 	V4L2_MBUS_FMT_VYUY8_2X8,
> > > > 
> > > > and I like that better, than "1X8," but still it doesn't resolve my above 
> > > > doubts.
> > > > 
> > > > Ideas? Suggestions?
> > > > 
> > > > > Here it is immediately clear what is going on. This scheme is also used with
> > > > > the Bayer formats, so it would be consistent with that as well.
> > > > > 
> > > > > However, does V4L2_MBUS_FMT_YUYV8_2X8_LE map to V4L2_MBUS_FMT_YUYV8_1X8 or to
> > > > > V4L2_MBUS_FMT_UYVY8_1X8? I still don't know.
> > > > > 
> > > > > What do you think?
> > > > 
> > > > Thanks
> > > > Guennadi
> > > > ---
> > > > Guennadi Liakhovetski, Ph.D.
> > > > Freelance Open-Source Software Developer
> > > > http://www.open-technology.de/
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > 
> > > 
> > > ---
> > > Guennadi Liakhovetski, Ph.D.
> > > Freelance Open-Source Software Developer
> > > http://www.open-technology.de/
> > > 
> > 
> 
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
