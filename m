Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47072 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966666Ab3HHVLZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Aug 2013 17:11:25 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Su Jiaquan <jiaquan.lnx@gmail.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media <linux-media@vger.kernel.org>, jqsu@marvell.com,
	xzhao10@marvell.com
Subject: Re: How to express planar formats with mediabus format code?
Date: Thu, 08 Aug 2013 23:12:30 +0200
Message-ID: <8999977.SY9Wm17vy3@avalon>
In-Reply-To: <CALxrGmV-SCDntaJGeaCDkuqmdzgk3VEYZG+koj9em+Z4PSG0XQ@mail.gmail.com>
References: <CALxrGmW86b4983Ud5hftjpPkc-KpcPTWiMeDEf1-zSt5POsHBg@mail.gmail.com> <Pine.LNX.4.64.1308042252010.19244@axis700.grange> <CALxrGmV-SCDntaJGeaCDkuqmdzgk3VEYZG+koj9em+Z4PSG0XQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Tuesday 06 August 2013 17:18:14 Su Jiaquan wrote:
> Hi Guennadi,
> 
> Thanks for the reply! Please see my description inline.
> 
> On Mon, Aug 5, 2013 at 5:02 AM, Guennadi Liakhovetski wrote:
> > On Sun, 4 Aug 2013, Su Jiaquan wrote:
> >> Hi,
> >> 
> >> I know the title looks crazy, but here is our problem:
> >> 
> >> In our SoC based ISP, the hardware can be divide to several blocks.
> >> Some blocks can do color space conversion(raw to YUV interleave/planar),
> >> others can do the pixel re-order(interleave/planar/semi-planar
> >> conversion, UV planar switch). We use one subdev to describe each of
> >> them, then came the problem: How can we express the planar formats with
> >> mediabus format code?
> > 
> > Could you please explain more exactly what you mean? How are those your
> > blocks connected? How do they exchange data? If they exchange data over a
> > serial bus, then I don't think planar formats make sense, right? Or do
> > your blocks really output planes one after another, reordering data
> > internally? That would be odd... If OTOH your blocks output data to RAM,
> > and the next block takes data from there, then you use V4L2_PIX_FMT_*
> > formats to describe them and any further processing block should be a
> > mem2mem device. Wouldn't this work?
> 
> These two hardware blocks are both located inside of ISP, and is connected
> by a hardware data bus.
> 
> Actually, there are three blocks inside ISP: One is close to sensor, and can
> do color space conversion(RGB->YUV), we call it IPC; The other two are at
> back end, which are basically DMA Engine, and they are identical. When data
> flow out of IPC, it can go into each one of these DMA Engines and finally
> into RAM. Whether the DMA Engine is turned on/off and the output format can
> be controlled independently. Since they are DMA Engines, they have some
> basic pixel reordering ability(i.e. interleave->planar/semi-planar).
> 
> In our H/W design, when we want to get YUV semi-planar format, the IPC
> output should be configured to interleave, and the DMA engine will do the
> interleave->semi-planar job. If we want planar / interleave format, the IPC
> will output planar format directly, DMA engine simply send the data to RAM,
> and don't do any re-order. So in the planar output case, media-bus formats
> can't express the format of the data between IPC and DMA Engine, that's the
> problem we meet.

If the format between the two subdevs is really planar, I don't see any 
problem defining a media bus pixel code for it. You will have to properly 
document the format of course.

I'm a bit surprised that the IPC could output planar data. It would need to 
buffer a whole image to do so, do you need to give it a temporary system RAM 
buffer ?

> We want to adopt a formal solution before we send our patch to the
> community, that's where our headache comes.

-- 
Regards,

Laurent Pinchart

