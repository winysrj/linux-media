Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46157 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012Ab3HTMwh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Aug 2013 08:52:37 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Su Jiaquan <jiaquan.lnx@gmail.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media <linux-media@vger.kernel.org>, jqsu@marvell.com,
	xzhao10@marvell.com
Subject: Re: How to express planar formats with mediabus format code?
Date: Tue, 20 Aug 2013 14:53:48 +0200
Message-ID: <2205654.JNC8mWJ5su@avalon>
In-Reply-To: <CALxrGmUW3AQts3kDHJ79K82qL4huGp0QceTL3ZtnUPW2VzNfeA@mail.gmail.com>
References: <CALxrGmW86b4983Ud5hftjpPkc-KpcPTWiMeDEf1-zSt5POsHBg@mail.gmail.com> <CALxrGmWgpHtmBTSwz0+P18VtZOcYO=3E0m6npa_1mR8ownNtcQ@mail.gmail.com> <CALxrGmUW3AQts3kDHJ79K82qL4huGp0QceTL3ZtnUPW2VzNfeA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jiaquan,

On Thursday 15 August 2013 16:27:43 Su Jiaquan wrote:
> On Sat, Aug 10, 2013 at 1:06 AM, Su Jiaquan <jiaquan.lnx@gmail.com> wrote:
> > On Fri, Aug 9, 2013 at 5:12 AM, Laurent Pinchart wrote:
> >> On Tuesday 06 August 2013 17:18:14 Su Jiaquan wrote:
> >>> On Mon, Aug 5, 2013 at 5:02 AM, Guennadi Liakhovetski wrote:
> >>> > On Sun, 4 Aug 2013, Su Jiaquan wrote:
> >>> >> Hi,
> >>> >> 
> >>> >> I know the title looks crazy, but here is our problem:
> >>> >> 
> >>> >> In our SoC based ISP, the hardware can be divide to several blocks.
> >>> >> Some blocks can do color space conversion(raw to YUV
> >>> >> interleave/planar), others can do the pixel re-
> >>> >> order(interleave/planar/semi-planar conversion, UV planar switch). We
> >>> >> use one subdev to describe each of them, then came the problem: How
> >>> >> can we express the planar formats with mediabus format code?
> >>> > 
> >>> > Could you please explain more exactly what you mean? How are those
> >>> > your blocks connected? How do they exchange data? If they exchange
> >>> > data over a serial bus, then I don't think planar formats make sense,
> >>> > right? Or do your blocks really output planes one after another,
> >>> > reordering data internally? That would be odd... If OTOH your blocks
> >>> > output data to RAM, and the next block takes data from there, then you
> >>> > use V4L2_PIX_FMT_* formats to describe them and any further processing
> >>> > block should be a mem2mem device. Wouldn't this work?
> >>> 
> >>> These two hardware blocks are both located inside of ISP, and is
> >>> connected by a hardware data bus.
> >>> 
> >>> Actually, there are three blocks inside ISP: One is close to sensor, and
> >>> can do color space conversion(RGB->YUV), we call it IPC; The other two
> >>> are at back end, which are basically DMA Engine, and they are
> >>> identical. When data flow out of IPC, it can go into each one of these
> >>> DMA Engines and finally into RAM. Whether the DMA Engine is turned
> >>> on/off and the output format can be controlled independently. Since
> >>> they are DMA Engines, they have some basic pixel reordering
> >>> ability(i.e. interleave->planar/semi-planar).
> >>> 
> >>> In our H/W design, when we want to get YUV semi-planar format, the IPC
> >>> output should be configured to interleave, and the DMA engine will do
> >>> the interleave->semi-planar job. If we want planar / interleave format,
> >>> the IPC will output planar format directly, DMA engine simply send the
> >>> data to RAM, and don't do any re-order. So in the planar output case,
> >>> media-bus formats can't express the format of the data between IPC and
> >>> DMA Engine, that's the problem we meet.
> >> 
> >> If the format between the two subdevs is really planar, I don't see any
> >> problem defining a media bus pixel code for it. You will have to properly
> >> document the format of course.
> >> 
> >> I'm a bit surprised that the IPC could output planar data. It would need
> >> to buffer a whole image to do so, do you need to give it a temporary
> >> system RAM buffer ?
> >> 
> >>> We want to adopt a formal solution before we send our patch to the
> >>> community, that's where our headache comes.
> > 
> > Thanks for the reply!
> > 
> > Actually, we don't need to buffer the frame inside IPC, there are
> > three channels in the data bus. When transfering interleave format,
> > only one channel is used, for planar formats, three channels send one
> > planar each, and to difference address(Let me confirm this with our
> > H/W team and get back to you later). So the planars is not sent one
> > after an other, but in parallel.
> > 
> > This may be a bit different from the planar formats as people think it
> > should be. Can we use planar format to describe it? Since this won't
> > cause any misunderstanding given it's used in this special case.
> > Please advice.
> > 
> 
> I have to say I'm sorry for the wrong information. I just double checked
> with hardware team, and turns out there is only one channel for the data bus
> between IPC and ispdma.
> If ispdma output planar format, the data format between IPC and ispdma
> should be configured to a special format, that is not the same with any know
> media-bus format.
> So I think what we need is to define vendor-specific media-bus code.
> Since others any want to do the same thing, shall we define a base address
> for the vendor specific formats? For example:
> 
> enum v4l2_mbus_pixelcode {
>     V4L2_MBUS_FMT_FIXED = 0x0001,
> 
>     ...
> 
> /* JPEG compressed formats - next is 0x4002 */
>     V4L2_MBUS_FMT_JPEG_1X8 = 0x4001,
> +   V4L2_MBUS_FMT_PRIVATE_BASE = 0xF001,
> };
> 
> If you are OK with this, I'll prepare a patch to add it

I'm not sure if that's needed here. Vendor-specific formats still need to be 
documented, so we could just create a custom YUV format for your case. Let's 
start with the beginning, could you describe what gets transmitted on the bus 
when that special format is selected ?

-- 
Regards,

Laurent Pinchart

