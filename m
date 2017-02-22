Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:51270 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932705AbdBVRy7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Feb 2017 12:54:59 -0500
Date: Wed, 22 Feb 2017 18:54:20 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Ajay kumar <ajaynumb@gmail.com>
cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Thomas Axelsson <Thomas.Axelsson@cybercom.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: v4l2: Adding support for multiple MIPI CSI-2 virtual channels
In-Reply-To: <CAEC9eQMreAGiZW-p457YeR1csfBbrhLBD+RSFKr3oMt0re1mJA@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1702221822080.6242@axis700.grange>
References: <DB5PR0701MB19091F43803C514055C4592A885D0@DB5PR0701MB1909.eurprd07.prod.outlook.com>
 <CAEC9eQMreAGiZW-p457YeR1csfBbrhLBD+RSFKr3oMt0re1mJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Tue, 21 Feb 2017, Ajay kumar wrote:

> Hi Everyone,
> 
> On Fri, Feb 17, 2017 at 7:27 PM, Thomas Axelsson
> <Thomas.Axelsson@cybercom.com> wrote:
> > Hi,
> >
> > I have a v4l2_subdev that provides multiple MIPI CSI-2 Virtual 
> > Channels. I want to configure each virtual channel individually (e.g. 
> > set_fmt), but the v4l2 interface does not seem to have a clear way to 
> > access configuration on a virtual channel level, but only the 
> > v4l2_subdev as a whole. Using one v4l2_subdev for multiple virtual 
> > channels by extending the "reg" tag to be an array looks like the 
> > correct way to do it, based on the mipi-dsi-bus.txt document and 
> > current device tree endpoint structure.
> >
> > However, I cannot figure out how to extend e.g. set_fmt/get_fmt subdev 
> > ioctls to specify which virtual channel the call applies to. Does 
> > anyone have any advice on how to handle this case?
> This would be helpful for my project as well since even I need to
> support multiple streams using Virtual Channels.
> Can anyone point out to some V4L2 driver, if this kind of support is
> already implemented?

My understanding is, that MIPI CSI virtual channel handling requires 
extensions to the V4L2 subdev API. These extensions have been discussed at 
a media mini-summit almost a year ago, slides are available at [1], but as 
my priorities shifted away from this work, don't think those extensions 
ever got implemented.

Thanks
Guennadi

[1] https://linuxtv.org/downloads/presentations/media_summit_2016_san_diego/v4l2-multistream.pdf

> 
> Thanks.
> >
> > Previous thread: "Device Tree formatting for multiple virtual channels in ti-vpe/cal driver?"
> >
> >
> > Best Regards,
> > Thomas Axelsson
> >
> > PS. First e-mail seems to have gotten caught in the spam filter. I apologize if this is a duplicate.
> 
