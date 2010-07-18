Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:44391 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754158Ab0GRKps (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Jul 2010 06:45:48 -0400
Date: Sun, 18 Jul 2010 12:45:59 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: Confusing mediabus formats
In-Reply-To: <201007181221.51813.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1007181228470.11194@axis700.grange>
References: <201005091032.07893.hverkuil@xs4all.nl> <201007091402.15938.hverkuil@xs4all.nl>
 <Pine.LNX.4.64.1007141541520.2150@axis700.grange> <201007181221.51813.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 18 Jul 2010, Hans Verkuil wrote:

> On Wednesday 14 July 2010 16:53:00 Guennadi Liakhovetski wrote:
> > > 
> > > The problem with the YUV variants is that the term 'sample' does not really apply.
> > > It's similar to the V4L2_MBUS_FMT_SBGGR8_1X8 bayer format: here the sample width is
> > > just 8 bits and 'BGGR' describes the order of the blue, green and red samples over
> > > the bus. I wonder, does the prefix 'S' in the sample description mean that the
> > > sub-sample order is described?
> > 
> > No, the "S" is explained on http://www.siliconimaging.com/RGB%20Bayer.htm 
> > as "sequential RGB," where they also refer to it as "sRGB."
> 
> Ah, good to know!
> 
> > > If so, then to be consistent I would propose these mediabus formats:
> > > 
> > >         V4L2_MBUS_FMT_SYUYV8_1X8,
> > >         V4L2_MBUS_FMT_SYVYU8_1X8,
> > >         V4L2_MBUS_FMT_SUYVY8_1X8,
> > >         V4L2_MBUS_FMT_SVYUY8_1X8,
> > 
> > Well, let me explain, what I meant by <sample> in above names. This is 
> > just the number of bus sampling operations, needed to capture the number 
> > of bits, transferred for each pixel. This is also referred to as "depth," 
> > meaning "color depth," in include/linux/videodev2.h in the fourcc code 
> > list. E.g.
> > 
> > format		colour depth
> > RGB555		15
> > RGB565		16
> > YUV4:2:2	16
> > SBGGR8 etc.	8
> > SBGGR10 etc.	10
> > YUV4:2:0	12
> > 
> > With this in mind all your names above should have _2X8. This just seems 
> > more intuitive to me to be able to see immediately how many times you have 
> > to sample the bus to get "1 pixel of colour information." This is also 
> > consistent with V4L2_MBUS_FMT_SBGGR8_1X8 - its colour-depth is 8.
> 
> I'm sorry, but this simply makes no sense. To get '1 pixel of colour information'
> in the case of YUV you would need to sample the bus *4* times to get all the Y, U
> and V components. The whole concept of colour-depth is frankly dubious for some of
> these formats. For that matter, the concept of 'pixel' is fuzzy as well. It is well
> defined for the Y plane, but for the chroma (UV) plane the 'pixels' are actually
> spread out over multiple Y pixels.

Pixel is just the "picture element" - think about one pixel on a monitor 
or on a sensor. Now, "one pixel of data" is indeed less clear. I would 
define it as "amount of data for the whole image divided through number of 
pixels." So, for a 4x4 image with 8-bit Bayer you get 16 bytes, sampled on 
an 8-bit bus you get 16 samples - 1 8-bit sample per _physical_ pixel, 
even though you're right - if you regard the data - no 8 bit in memory 
describe 1 pixel completely. Now, for YUV4:2:2 you get 32 samples, i.e., 2 
samples per pixel on an 8-bit bus. That's where 2X8 comes from. I think, 
this definition is rigorous and _independent_ of the actual colorspace / 
pixel format. This is just (bytes per image) / pixels / (bus width). 
_This_ alone is the reason why I prefer this definition. It is 
mathematical. You don't need to know _anything_ about the colorspace or 
pixel format. Therefore it is suitable for formal image data transfer in a 
pass-through mode. You look at such a name and you immediately know how 
many times you have to sample the bus to get data for your QVGA image. 
Whereas with your concept you have to understand what YUV422 is to 
actually realise, that V4L2_MBUS_FMT_SYUYV8_1X8 for a 4x4 image you have 
to sample the 8-bit but 32 times.

> But the number of bits for each Y, U and V sample is well defined, and I think that
> is what we should use. And BTW, 'Sequential YUV' makes sense to me as a name as
> well.

Ok, in a way it does, just I never saw it before and I don't think it is 
necessary. sRGB differentiates from RGB, whereas YUV _is_ already 
"sequential," if you like, so, there's nothing to differentiate from, and 
I think, it would just add confision, because people would start to think, 
that SYUV is something different from YUV.

> > > Regarding 4-bit wide busses: the scheme is generic enough for that:
> > > 
> > > E.g. V4L2_MBUS_FMT_SYUYV8_1X8 for a 4-bit bus would become:
> > > 
> > > 	V4L2_MBUS_FMT_SYUYV8_2X4_LE
> > > 	V4L2_MBUS_FMT_SYUYV8_2X4_BE
> > 
> > Ok, this makes sense to me - only let's change them to use _4x4
> > 
> > > Again, how this ends up in memory is unrelated to these mbus_pixelcodes.
> > > 
> > > As discussed in Helsinki we need to get this sorted out soon since this header
> > > is going to be public in the near future.
> > 
> > Ok, I agree, that having 
> > 
> > 	V4L2_MBUS_FMT_YUYV8_2X8,
> > 	V4L2_MBUS_FMT_YVYU8_2X8,
> > 	V4L2_MBUS_FMT_UYVY8_2X8,
> > 	V4L2_MBUS_FMT_VYUY8_2X8,
> > 
> > is better, than
> > 
> > 	V4L2_MBUS_FMT_YUYV8_2X8_LE,
> > 	V4L2_MBUS_FMT_YVYU8_2X8_LE,
> > 	V4L2_MBUS_FMT_YUYV8_2X8_BE,
> > 	V4L2_MBUS_FMT_YVYU8_2X8_BE,
> 
> Why would V4L2_MBUS_FMT_SBGGR8_1X8 be OK and V4L2_MBUS_FMT_SYUYV8_1X8 be wrong?
> I really don't see the difference between the two. Both formats produce a sequence
> of 8 bit color components in a particular order.
> 
> The only difference is the colorspace used.

No. See above - number of samples for the same image size and buswidth is 
different.

> > BTW, this "new" version is essentially the same, as what I've had in v1 of 
> > my RFC;) (v2 for reference: 
> > http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/12830/focus=13394)
> 
> We are more or less still having the same discussion. I would like someone else to
> jump in as well to break this deadlock.

More opinions are always good, sure;)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
