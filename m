Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:60859 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753674AbdH2Ojw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Aug 2017 10:39:52 -0400
Date: Tue, 29 Aug 2017 16:39:51 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Benoit Parrot <bparrot@ti.com>,
        linux-renesas-soc@vger.kernel.org,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: [PATCH 00/20] Add multiplexed media pads to support CSI-2
 virtual channels
Message-ID: <20170829143950.j5jhdvyt72qzjmnt@flea.lan>
References: <20170811095703.6170-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="4vlwlrh45ujvoroj"
Content-Disposition: inline
In-Reply-To: <20170811095703.6170-1-niklas.soderlund+renesas@ragnatech.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--4vlwlrh45ujvoroj
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Niklas,

On Fri, Aug 11, 2017 at 11:56:43AM +0200, Niklas S=F6derlund wrote:
> This series is a RFC for how I think one could add CSI-2 virtual channel=
=20
> support to the V4L2 framework. The problem is that there is no way to in=
=20
> the media framework describe and control links between subdevices which=
=20
> carry more then one video stream, for example a CSI-2 bus which can have=
=20
> 4 virtual channels carrying different video streams.
>=20
> This series adds a new pad flag which would indicate that a pad carries=
=20
> multiplexed streams, adds a new s_stream() operation to the pad=20
> operations structure which takes a new argument 'stream'. This new=20
> s_stream() operation then is both pad and stream aware. It also extends=
=20
> struct v4l2_mbus_frame_desc_entry with a new sub-struct to describe how=
=20
> a CSI-2 link multiplexes virtual channels. I also include one=20
> implementation based on Renesas R-Car which makes use of these patches=20
> as I think they help with understanding but they have no impact on the=20
> RFC feature itself.
>=20
> The idea is that on both sides of the multiplexed media link there are=20
> one multiplexer subdevice and one demultiplexer subdevice. These two=20
> subdevices can't do any format conversions, there sole purpose is to=20
> (de)multiplex the CSI-2 link. If there is hardware which can do both=20
> CSI-2 multiplexing and format conversions they can be modeled as two=20
> subdevices from the same device driver and using the still pending=20
> incremental async mechanism to connect the external pads. The reason=20
> there is no format conversion is important as the multiplexed pads can't=
=20
> have a format in the current V4L2 model, get/set_fmt are not aware of=20
> streams.
>=20
>         +------------------+              +------------------+
>      +-------+  subdev 1   |              |  subdev 2   +-------+
>   +--+ Pad 1 |             |              |             | Pad 3 +---+
>      +--+----+   +---------+---+      +---+---------+   +----+--+
>         |        | Muxed pad A +------+ Muxed pad B |        |
>      +--+----+   +---------+---+      +---+---------+   +----+--+
>   +--+ Pad 2 |             |              |             | Pad 4 +---+
>      +-------+             |              |             +-------+
>         +------------------+              +------------------+
>=20
> In the simple example above Pad 1 is routed to Pad 3 and Pad 2 to Pad 4,=
=20
> and the video data for both of them travels the link between pad A and=20
> B. One shortcoming of this RFC is that there currently are no way to=20
> express to user-space which pad is routed to which stream of the=20
> multiplexed link. But inside the kernel this is known and format=20
> validation is done by comparing the format of Pad 1 to Pad 3 and Pad 2=20
> to Pad 4 by the V4L2 framework. But it would be nice for the user to=20
> also be able to get this information while setting up the MC graph in=20
> user-space.

Thanks for your patches.

I guess I already have a different use-case for this, one you might
not have envisionned (on top of the Cadence CSI2-RX driver I've been
posting and that would need it at some point).

I have a CSI2-TX controller that I'm currently writing a driver
for. That controller takes 4 video streams in input, and aggregates
them on a single CSI-2 link. Those video streams use some kind of
parallel interfaces. So far, so good.

However, those parallel interfaces come with additional signals that
set the virtual channel and data types of the associated video
signal. Those signals are under control of the upstream video output
device, and can change at runtime.

The virtual channel are direcly mapped to the CSI-2 Virtual Channels,
so that part is completely transparent to the transmitter. However,
the video input datatype is a 0-7 value. Each data type value has a
separate set of registers where you need to set up the width and
height of the video data, and the corresponding CSI-2 Data Type.

You can use this to do some interleaving of either the virtual
channels or the data types, or both.

To make things (slightly) more complicated, the FIFO registers are
per-video input. Which means that while most of the (input)
configuration will be done per-datatype, we still have to know which
input stream is generating it, for example to optimise the FIFO fill
levels to the resolution...

Since the stream is multiplexed both using the virtual channels and
the data-types, I'm not sure representing it using only muxed pads
like you did would work.

And I don't really know what a good stop gap measure would be either.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--4vlwlrh45ujvoroj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJZpXy2AAoJEBx+YmzsjxAgJ1oP/ilI8bx+SWkbY3IcqTjfAg+r
BHq5Y+80e0unJJ4pYN4aLAz0vTyCo4MaaRm2zM1JmD04YWudttkcw4e5AjuSpCQo
WEPvcSDiRSYxsd7GgBalKRnRyxN/PJxL1/qOnSCEncMxEawKMwsGdLmQ8eiJFU/y
gCEtTEkMgmlNRrKZsJZoifEDsk7/0CxUrU0mhYUkODVr6iTLuOOn4uV/doGyV/Jh
+fkgeUgzygLmD4jzdtm+mYwMOWSDYHdbsk794fd9hZOY6F7wx66ijuvGoeEH4njJ
Ti3tzRsLTRBLsOVwyXYTcI3ap4tDiDz7gNnOS+zVHAxdOJFnzWA9oDzCXq0lYZCh
uWKyaNOiM8BHdu36JmWXF3d3SqkEIyBcCoFypSV7qZ04FGXTiRw7QT3GWfDo6/lL
AgcOah/aJY27bW1BLpr59liZVNHBp1cD3iBd5R79GZzB1azDWWlK+01Ry6eFk8/U
JA6sOYlr3CzH463dsi85/JYmStZSgcKmYco7ui7RaSRNOwb564PkJaeZeab0R+HU
NmY5d6GHc089b62/YeewHhc8WoyUUtDQclH+NzRkfBLXW4TVmpTp3teT586c7s7G
E+uhfrVyadYNlDdu+5Jf4l/asE5g+o04/Dml46zAPwdd3hBuLVOFHaxx1LBvOlJM
qHQz/+PH3K+ByS5EUs7l
=goIk
-----END PGP SIGNATURE-----

--4vlwlrh45ujvoroj--
