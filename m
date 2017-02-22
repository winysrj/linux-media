Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38974 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933642AbdBVTcr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Feb 2017 14:32:47 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Ajay kumar <ajaynumb@gmail.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Thomas Axelsson <Thomas.Axelsson@cybercom.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
Subject: Re: v4l2: Adding support for multiple MIPI CSI-2 virtual channels
Date: Wed, 22 Feb 2017 21:33:16 +0200
Message-ID: <2309653.TxoyDJYOYi@avalon>
In-Reply-To: <Pine.LNX.4.64.1702221822080.6242@axis700.grange>
References: <DB5PR0701MB19091F43803C514055C4592A885D0@DB5PR0701MB1909.eurprd07.prod.outlook.com> <CAEC9eQMreAGiZW-p457YeR1csfBbrhLBD+RSFKr3oMt0re1mJA@mail.gmail.com> <Pine.LNX.4.64.1702221822080.6242@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Wednesday 22 Feb 2017 18:54:20 Guennadi Liakhovetski wrote:
> On Tue, 21 Feb 2017, Ajay kumar wrote:
> > On Fri, Feb 17, 2017 at 7:27 PM, Thomas Axelsson wrote:
> >> Hi,
> >> 
> >> I have a v4l2_subdev that provides multiple MIPI CSI-2 Virtual
> >> Channels. I want to configure each virtual channel individually (e.g.
> >> set_fmt), but the v4l2 interface does not seem to have a clear way to
> >> access configuration on a virtual channel level, but only the
> >> v4l2_subdev as a whole. Using one v4l2_subdev for multiple virtual
> >> channels by extending the "reg" tag to be an array looks like the
> >> correct way to do it, based on the mipi-dsi-bus.txt document and
> >> current device tree endpoint structure.
> >> 
> >> However, I cannot figure out how to extend e.g. set_fmt/get_fmt subdev
> >> ioctls to specify which virtual channel the call applies to. Does
> >> anyone have any advice on how to handle this case?
> > 
> > This would be helpful for my project as well since even I need to
> > support multiple streams using Virtual Channels.
> > Can anyone point out to some V4L2 driver, if this kind of support is
> > already implemented?
> 
> My understanding is, that MIPI CSI virtual channel handling requires
> extensions to the V4L2 subdev API. These extensions have been discussed at
> a media mini-summit almost a year ago, slides are available at [1], but as
> my priorities shifted away from this work, don't think those extensions
> ever got implemented.

We've also discussed the topic last week in a face to face meeting with Niklas 
(CC'ed) and Sakari. Niklas will start working on upstreaming the necessary 
V4L2 API extensions for CSI-2 virtual channel support. The current plan is to 
start the work at the beginning of April.

> [1]
> https://linuxtv.org/downloads/presentations/media_summit_2016_san_diego/v4l
> 2-multistream.pdf
>
> >> Previous thread: "Device Tree formatting for multiple virtual channels
> >> in ti-vpe/cal driver?"
> >> 
> >> Best Regards,
> >> Thomas Axelsson
> >> 
> >> PS. First e-mail seems to have gotten caught in the spam filter. I
> >> apologize if this is a duplicate.

-- 
Regards,

Laurent Pinchart
