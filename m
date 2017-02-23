Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-db5eur01on0069.outbound.protection.outlook.com ([104.47.2.69]:6771
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750837AbdBWKHR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Feb 2017 05:07:17 -0500
From: Thomas Axelsson <Thomas.Axelsson@cybercom.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?iso-8859-1?Q?Niklas_S=F6derlund?= <niklas.soderlund@ragnatech.se>
CC: Ajay kumar <ajaynumb@gmail.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
Subject: RE: v4l2: Adding support for multiple MIPI CSI-2 virtual channels
Date: Thu, 23 Feb 2017 10:07:14 +0000
Message-ID: <DB5PR0701MB190909EEA763FDEE09F553A888530@DB5PR0701MB1909.eurprd07.prod.outlook.com>
References: <DB5PR0701MB19091F43803C514055C4592A885D0@DB5PR0701MB1909.eurprd07.prod.outlook.com>
 <CAEC9eQMreAGiZW-p457YeR1csfBbrhLBD+RSFKr3oMt0re1mJA@mail.gmail.com>
 <Pine.LNX.4.64.1702221822080.6242@axis700.grange> <2309653.TxoyDJYOYi@avalon>
In-Reply-To: <2309653.TxoyDJYOYi@avalon>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent and Niklas,

> -----Original Message-----
> From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> Sent: den 22 februari 2017 20:33
> To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Ajay kumar <ajaynumb@gmail.com>; linux-media@vger.kernel.org;
> Marek Szyprowski <m.szyprowski@samsung.com>; Sylwester Nawrocki
> <sylvester.nawrocki@gmail.com>; Andrzej Hajda <a.hajda@samsung.com>;
> Thomas Axelsson <Thomas.Axelsson@cybercom.com>; Sakari Ailus
> <sakari.ailus@iki.fi>; Niklas S=F6derlund <niklas.soderlund@ragnatech.se>
> Subject: Re: v4l2: Adding support for multiple MIPI CSI-2 virtual channel=
s
>=20
> Hi Guennadi,
>=20
> On Wednesday 22 Feb 2017 18:54:20 Guennadi Liakhovetski wrote:
> > On Tue, 21 Feb 2017, Ajay kumar wrote:
> > > On Fri, Feb 17, 2017 at 7:27 PM, Thomas Axelsson wrote:
> > >> Hi,
> > >>
> > >> I have a v4l2_subdev that provides multiple MIPI CSI-2 Virtual
> > >> Channels. I want to configure each virtual channel individually (e.g=
.
> > >> set_fmt), but the v4l2 interface does not seem to have a clear way
> > >> to access configuration on a virtual channel level, but only the
> > >> v4l2_subdev as a whole. Using one v4l2_subdev for multiple virtual
> > >> channels by extending the "reg" tag to be an array looks like the
> > >> correct way to do it, based on the mipi-dsi-bus.txt document and
> > >> current device tree endpoint structure.
> > >>
> > >> However, I cannot figure out how to extend e.g. set_fmt/get_fmt
> > >> subdev ioctls to specify which virtual channel the call applies to.
> > >> Does anyone have any advice on how to handle this case?
> > >
> > > This would be helpful for my project as well since even I need to
> > > support multiple streams using Virtual Channels.
> > > Can anyone point out to some V4L2 driver, if this kind of support is
> > > already implemented?
> >
> > My understanding is, that MIPI CSI virtual channel handling requires
> > extensions to the V4L2 subdev API. These extensions have been
> > discussed at a media mini-summit almost a year ago, slides are
> > available at [1], but as my priorities shifted away from this work,
> > don't think those extensions ever got implemented.
>=20
> We've also discussed the topic last week in a face to face meeting with N=
iklas
> (CC'ed) and Sakari. Niklas will start working on upstreaming the necessar=
y
> V4L2 API extensions for CSI-2 virtual channel support. The current plan i=
s to
> start the work at the beginning of April.

I understand that the code is not ready for prime time, but it would not be=
=20
optimal for me trying to implement a solution in parallel. Do you have some=
=20
sketches or drafts that you can share, so that any temporary solution I mak=
e=20
will hopefully not be too hard to adjust to match the final implementation?

Do you plan to use "pad", as suggested by Guennadi, to map virtual channels=
?

Regarding the ioctls, I had embarrassingly looked at the wrong struct, and =
I=20
see that e.g. VIDIOC_SUBDEV_S_FMT accepts v4l2_subdev_format, which has a p=
ad=20
member. (Which I assume can be used to index in the v4l2_subdev_pad_config =
*cfg=20
provided to the ioctl handler).

>=20
> > [1]
> >
> https://linuxtv.org/downloads/presentations/media_summit_2016_san_die
> g
> > o/v4l
> > 2-multistream.pdf
> >
> > >> Previous thread: "Device Tree formatting for multiple virtual
> > >> channels in ti-vpe/cal driver?"
> > >>
> > >> Best Regards,
> > >> Thomas Axelsson
> > >>
> > >> PS. First e-mail seems to have gotten caught in the spam filter. I
> > >> apologize if this is a duplicate.
>=20
> --
> Regards,
>=20
> Laurent Pinchart

Best Regards,
Thomas Axelsson
