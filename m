Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:56317 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755385Ab3HFJkU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Aug 2013 05:40:20 -0400
Date: Tue, 6 Aug 2013 11:40:17 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Su Jiaquan <jiaquan.lnx@gmail.com>
cc: linux-media <linux-media@vger.kernel.org>, jqsu@marvell.com,
	xzhao10@marvell.com
Subject: Re: How to express planar formats with mediabus format code?
In-Reply-To: <CALxrGmV-SCDntaJGeaCDkuqmdzgk3VEYZG+koj9em+Z4PSG0XQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1308061129570.772@axis700.grange>
References: <CALxrGmW86b4983Ud5hftjpPkc-KpcPTWiMeDEf1-zSt5POsHBg@mail.gmail.com>
 <Pine.LNX.4.64.1308042252010.19244@axis700.grange>
 <CALxrGmV-SCDntaJGeaCDkuqmdzgk3VEYZG+koj9em+Z4PSG0XQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Su Jiaquan,

On Tue, 6 Aug 2013, Su Jiaquan wrote:

> Hi Guennadi,
> 
> Thanks for the reply! Please see my description inline.
> 
> On Mon, Aug 5, 2013 at 5:02 AM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> > Hi Su Jiaquan
> >
> > On Sun, 4 Aug 2013, Su Jiaquan wrote:
> >
> >> Hi,
> >>
> >> I know the title looks crazy, but here is our problem:
> >>
> >> In our SoC based ISP, the hardware can be divide to several blocks.
> >> Some blocks can do color space conversion(raw to YUV
> >> interleave/planar), others can do the pixel
> >> re-order(interleave/planar/semi-planar conversion, UV planar switch).
> >> We use one subdev to describe each of them, then came the problem: How
> >> can we express the planar formats with mediabus format code?
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
> These two hardware blocks are both located inside of ISP, and is
> connected by a hardware data bus.
> 
> Actually, there are three blocks inside ISP: One is close to sensor,
> and can do color space conversion(RGB->YUV), we call it IPC; The other
> two are at back end, which are basically DMA Engine, and they are
> identical. When data flow out of IPC, it can go into each one of these
> DMA Engines and finally into RAM. Whether the DMA Engine is turned
> on/off and the output format can be controlled independently. Since
> they are DMA Engines, they have some basic pixel reordering
> ability(i.e. interleave->planar/semi-planar).
> 
> In our H/W design, when we want to get YUV semi-planar format, the IPC
> output should be configured to interleave, and the DMA engine will do
> the interleave->semi-planar job. If we want planar / interleave
> format, the IPC will output planar format directly, DMA engine simply
> send the data to RAM, and don't do any re-order. So in the planar
> output case, media-bus formats can't express the format of the data
> between IPC and DMA Engine, that's the problem we meet.

Ok, so, do I understand you correctly, that in the case, where IPC outputs 
planar data you have:

1. your sensor is sending data to IPC

Then one of the following happens

2a. IPC stores the complete frame first, and only when the frame is 
complete, it first outputs the Y plane amd then the UV plane.

A slight optimisation of this would be

2b. it outputs Y components as pixels arrive and stores UV data 
internally, and at the end of the frame it sends out UV

If this is indeed the case, well, then I'm on the same page with you - I 
don't know a standard solution for this, sorry. It seems to me, that you 
will indeed need a new mediabus pixel code for this - either a generic one 
or a vendor-specific one. Let's see what others say.

Thanks
Guennadi

> We want to adopt a formal solution before we send our patch to the
> community, that's where our headache comes.
> >
> > Thanks
> > Guennadi
> >
> >> I understand at beginning, media-bus was designed to describe the data
> >> link between camera sensor and camera controller, where sensor is
> >> described in subdev. So interleave formats looks good enough at that
> >> time. But now as Media-controller is introduced, subdev can describe a
> >> much wider range of hardware, which is not limited to camera sensor.
> >> So now planar formats are possible to be passed between subdevs.
> >>
> >> I think the problem we meet can be very common for SoC based ISP
> >> solutions, what do you think about it?
> >>
> >> there are many possible solution for it:
> >>
> >> 1> change the definition of v4l2_subdev_format::format, use v4l2_format;
> >>
> >> 2> extend the mediabus format code, add planar format code;
> >>
> >> 3> use a extra bit to tell the meaning of v4l2_mbus_framefmt::code, is
> >> it in mediabus-format or in fourcc
> >>
> >>  Do you have any suggestions?
> >>
> >>  Thanks a lot!
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>
> >
> > ---
> > Guennadi Liakhovetski, Ph.D.
> > Freelance Open-Source Software Developer
> > http://www.open-technology.de/
> 
> Thanks!
> 
> Jiaquan
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
