Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:33325 "EHLO
        mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751099AbdBWPKB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Feb 2017 10:10:01 -0500
Received: by mail-lf0-f54.google.com with SMTP id l12so17585107lfe.0
        for <linux-media@vger.kernel.org>; Thu, 23 Feb 2017 07:09:55 -0800 (PST)
Date: Thu, 23 Feb 2017 16:09:53 +0100
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Thomas Axelsson <Thomas.Axelsson@cybercom.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Ajay kumar <ajaynumb@gmail.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: v4l2: Adding support for multiple MIPI CSI-2 virtual channels
Message-ID: <20170223150952.GC5300@bigcity.dyn.berto.se>
References: <DB5PR0701MB19091F43803C514055C4592A885D0@DB5PR0701MB1909.eurprd07.prod.outlook.com>
 <CAEC9eQMreAGiZW-p457YeR1csfBbrhLBD+RSFKr3oMt0re1mJA@mail.gmail.com>
 <Pine.LNX.4.64.1702221822080.6242@axis700.grange>
 <2309653.TxoyDJYOYi@avalon>
 <DB5PR0701MB190909EEA763FDEE09F553A888530@DB5PR0701MB1909.eurprd07.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DB5PR0701MB190909EEA763FDEE09F553A888530@DB5PR0701MB1909.eurprd07.prod.outlook.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Thomas,

On 2017-02-23 10:07:14 +0000, Thomas Axelsson wrote:
> Hi Laurent and Niklas,
> 
> > -----Original Message-----
> > From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> > Sent: den 22 februari 2017 20:33
> > To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > Cc: Ajay kumar <ajaynumb@gmail.com>; linux-media@vger.kernel.org;
> > Marek Szyprowski <m.szyprowski@samsung.com>; Sylwester Nawrocki
> > <sylvester.nawrocki@gmail.com>; Andrzej Hajda <a.hajda@samsung.com>;
> > Thomas Axelsson <Thomas.Axelsson@cybercom.com>; Sakari Ailus
> > <sakari.ailus@iki.fi>; Niklas Söderlund <niklas.soderlund@ragnatech.se>
> > Subject: Re: v4l2: Adding support for multiple MIPI CSI-2 virtual channels
> > 
> > Hi Guennadi,
> > 
> > On Wednesday 22 Feb 2017 18:54:20 Guennadi Liakhovetski wrote:
> > > On Tue, 21 Feb 2017, Ajay kumar wrote:
> > > > On Fri, Feb 17, 2017 at 7:27 PM, Thomas Axelsson wrote:
> > > >> Hi,
> > > >>
> > > >> I have a v4l2_subdev that provides multiple MIPI CSI-2 Virtual
> > > >> Channels. I want to configure each virtual channel individually (e.g.
> > > >> set_fmt), but the v4l2 interface does not seem to have a clear way
> > > >> to access configuration on a virtual channel level, but only the
> > > >> v4l2_subdev as a whole. Using one v4l2_subdev for multiple virtual
> > > >> channels by extending the "reg" tag to be an array looks like the
> > > >> correct way to do it, based on the mipi-dsi-bus.txt document and
> > > >> current device tree endpoint structure.
> > > >>
> > > >> However, I cannot figure out how to extend e.g. set_fmt/get_fmt
> > > >> subdev ioctls to specify which virtual channel the call applies to.
> > > >> Does anyone have any advice on how to handle this case?
> > > >
> > > > This would be helpful for my project as well since even I need to
> > > > support multiple streams using Virtual Channels.
> > > > Can anyone point out to some V4L2 driver, if this kind of support is
> > > > already implemented?
> > >
> > > My understanding is, that MIPI CSI virtual channel handling requires
> > > extensions to the V4L2 subdev API. These extensions have been
> > > discussed at a media mini-summit almost a year ago, slides are
> > > available at [1], but as my priorities shifted away from this work,
> > > don't think those extensions ever got implemented.
> > 
> > We've also discussed the topic last week in a face to face meeting with Niklas
> > (CC'ed) and Sakari. Niklas will start working on upstreaming the necessary
> > V4L2 API extensions for CSI-2 virtual channel support. The current plan is to
> > start the work at the beginning of April.
> 
> I understand that the code is not ready for prime time, but it would not be 
> optimal for me trying to implement a solution in parallel. Do you have some 
> sketches or drafts that you can share, so that any temporary solution I make 
> will hopefully not be too hard to adjust to match the final implementation?

As Laurent said the plan is to start work on this in April so not much 
code exists yet that can be shared. We do have an idea on how to try and 
do this but I have yet to write it up in a easy to consume text. I'm 
currently on the road but hope to do write it up next week.

> 
> Do you plan to use "pad", as suggested by Guennadi, to map virtual channels?

In short the plan is to use pads that can mux/demux multiple streams 
to/from a single pad and then use routing inside each subdevice to 
connect 'normal' pads to the muxed pad.

On the CSi-2 transmitter subdev each sink pad receive its own stream 
which can be routed to the multiplexed source pad. On the CSI-2 receiver 
the sink pad is multiplexed and each stream coming in is demuxed to a 
separate source pad which once again will once more only carry a single 
stream.

The multiplexed source pad of the transmitter and the multiplexed sink 
pad of the receiver will have no format and user-space will have to look 
at the routing information inside the two subdevices to figure out which 
transmitter sink pad is connected to which receivers source pad to get a 
complete view of the formats in the media pipeline.

> 
> Regarding the ioctls, I had embarrassingly looked at the wrong struct, and I 
> see that e.g. VIDIOC_SUBDEV_S_FMT accepts v4l2_subdev_format, which has a pad 
> member. (Which I assume can be used to index in the v4l2_subdev_pad_config *cfg 
> provided to the ioctl handler).
> 
> > 
> > > [1]
> > >
> > https://linuxtv.org/downloads/presentations/media_summit_2016_san_die
> > g
> > > o/v4l
> > > 2-multistream.pdf
> > >
> > > >> Previous thread: "Device Tree formatting for multiple virtual
> > > >> channels in ti-vpe/cal driver?"
> > > >>
> > > >> Best Regards,
> > > >> Thomas Axelsson
> > > >>
> > > >> PS. First e-mail seems to have gotten caught in the spam filter. I
> > > >> apologize if this is a duplicate.
> > 
> > --
> > Regards,
> > 
> > Laurent Pinchart
> 
> Best Regards,
> Thomas Axelsson

-- 
Regards,
Niklas Söderlund
