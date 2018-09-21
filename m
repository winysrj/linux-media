Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:43326 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727392AbeIUPtF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Sep 2018 11:49:05 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Dave Stevenson <dave.stevenson@raspberrypi.org>
Cc: kieran.bingham@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se, jacopo@jmondi.org,
        LMML <linux-media@vger.kernel.org>,
        linux-renesas-soc@vger.kernel.org,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH 1/3] i2c: adv748x: store number of CSI-2 lanes described in device tree
Date: Fri, 21 Sep 2018 13:01:09 +0300
Message-ID: <6518376.j8BxZoQUpz@avalon>
In-Reply-To: <CAAoAYcPrEx9bsB0TZ87N8CqsHhWBDzLStOptv2nv6iyfWZqcZg@mail.gmail.com>
References: <20180918014509.6394-1-niklas.soderlund+renesas@ragnatech.se> <1658112.YQ0khu1noY@avalon> <CAAoAYcPrEx9bsB0TZ87N8CqsHhWBDzLStOptv2nv6iyfWZqcZg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dave,

On Friday, 21 September 2018 12:33:39 EEST Dave Stevenson wrote:
> On Tue, 18 Sep 2018 at 12:13, Laurent Pinchart wrote:
> > On Tuesday, 18 September 2018 13:51:34 EEST Kieran Bingham wrote:
> >> On 18/09/18 11:46, Laurent Pinchart wrote:
> >>> On Tuesday, 18 September 2018 13:37:55 EEST Kieran Bingham wrote:
> >>>> On 18/09/18 11:28, Laurent Pinchart wrote:
> >>>>> On Tuesday, 18 September 2018 13:19:39 EEST Kieran Bingham wrote:
> >>>>>> On 18/09/18 02:45, Niklas S=F6derlund wrote:
> >>>>>>> The adv748x CSI-2 transmitters TXA and TXB can use different
> >>>>>>> number of lines to transmit data on. In order to be able configure
> >>>>>>> the device correctly this information need to be parsed from
> >>>>>>> device tree and stored in each TX private data structure.
> >>>>>>>=20
> >>>>>>> TXA supports 1, 2 and 4 lanes while TXB supports 1 lane.
> >>>>>>=20
> >>>>>> Am I right in assuming that it is the CSI device which specifies
> >>>>>> the number of lanes in their DT?
> >>>>>=20
> >>>>> Do you mean the CSI-2 receiver ? Both the receiver and the
> >>>>> transmitter should specify the data lanes in their DT node.
> >>>>=20
> >>>> Yes, I should have said CSI-2 receiver.
> >>>>=20
> >>>> Aha - so *both* sides of the link have to specify the lanes and
> >>>> presumably match with each other?
> >>>=20
> >>> Yes, they should certainly match :-)
> >>=20
> >> I assumed so :) - do we need to validate that at a framework level?
> >> (or perhaps it already is, all I've only looked at this morning is
> >> e-mails :D )
> >=20
> > It's not done yet as far as I know. CC'ing Sakari who may have a comment
> > regarding whether this should be added.
>=20
> (Interested party here due to CSI2 interfacing on the Pi, and I'd like
> to try and get adv748x working on the Pi once I can get some hardware)
>=20
> Do they need to match? DT is supposedly describing the hardware. Where
> are you drawing the boundary between the two devices from the
> hardware/devicetree perspective?
>=20
> As an example, the CSI2 receiver can support 4 lanes, whilst the
> source only needs 2, or only has 2 connected. As long as the two ends
> agree on the value in use (which will typically match the source),
> then there is no issue.
> It does require the CSI2 receiver driver to validate the remote
> endpoint settings to ensure that the source doesn't try to use more
> lanes than the receiver can cope with. That isn't a big deal as you
> already have the link to the remote end-point. Presumably you're
> already checking it to determine settings such as if the source is
> using continuous clocks or not, unless you expect that to be
> duplicated on both endpoints or your hardware doesn't care.

At least for the data-lanes property, the value is meant to describe how la=
nes=20
are physically connected on the board from the transmitter to the receiver.=
 It=20
does not tell the maximum of lanes that the device supports, which is=20
intrinsic information known to the driver already.

Regarding other parameters, such as the clock mode you mentioned, they shou=
ld=20
usually be queried and negotiated at runtime, especially given that both th=
e=20
transmitting and receiving devices may very well support multiple options. =
We=20
usually don't involve DT in those cases. Parsing DT properties of a remote=
=20
node is frowned upon, because those properties are qualified by the compati=
ble=20
string of the node they sit in. A driver matching "foo,abc" knows what=20
properties are defined for the corresponding DT node, but when that driver=
=20
crosses links to DT node "bar,xyz", it has no a priori knowledge of what to=
=20
expect there.

=46ollowing the OF graph through endpoints and ports is still fine, as if a=
 DT=20
node uses the OF graph bindings, the nodes it is connected to are assumed t=
o=20
use the same bindings. No assumption can usually be made on other propertie=
s=20
though, including the ones describing the bus configuration. For that reaso=
n=20
the properties for the CSI-2 source should be parsed by the CSI-2 source=20
driver, and the configuration of the source should be queried by the CSI-2=
=20
receiver at runtime using the v4l2_subdev API (which is routinely extended=
=20
with additional configuration information when the need arises).

> I'm genuinely interested on views here. On the Pi there will be a
> variety of CSI2 devices connected, generally configured using
> dtoverlays, and they will have varying requirements on number of
> lanes. Standard Pis only have 2 CSI-2 lanes exposed out of a possible
> 4 for the peripheral. The Compute Module is the exception where one
> CSI2 interface has all 4 lanes brought out, the other only supports 2
> lanes anyway.
> I'm expecting the CSI2 receiver endpoint data-lanes property to match
> that exposed by the Pi board, whilst the source endpoint data-lanes
> property defines what the source uses. That allows easy validation by
> the driver that the configuration can work. Otherwise an overlay would
> have to write the number of lanes used on both the CSI endpoints and
> potentially configuring it to use more lanes than can be supported.

As explained above, we currently expect the latter, with the overlay modify=
ing=20
the data-lanes property of the receiver as well. This is partly due to the=
=20
fact that receivers can support data lanes remapping, so the data-lanes=20
property of the receiver needs not only to specify the number of lanes, but=
=20
also how they are connected.

If you want to validate the data-lanes property to ensure the overlay doesn=
't=20
try to use more lanes than available, you can do so either against a hardco=
ded=20
value in the receiver driver (when the maximum is fixed for a given compati=
ble=20
string), or against a value read from DT (when the maximum depends on the=20
board).

> There is also the oddball one of the TC358743 which dynamically
> switches the number of lanes in use based on the data rate required.
> That's probably a separate discussion, but is currently dealt with via
> g_mbus_config as amended back in Sept 2017 [1].

This falls into the case of dynamic configuration discovery and negotiation=
 I=20
mentioned above, and we clearly need to make sure the v4l2_subdev API suppo=
rts=20
this use case.

> [1] Discussion https://www.spinics.net/lists/linux-media/msg122287.html
> and patch https://www.spinics.net/lists/linux-media/msg122435.html
>=20
> >>>>>> Could we make this clear in the commit log (and possibly an extra
> >>>>>> comment in the code). At first I was assuming we would have to
> >>>>>> declare the number of lanes in the ADV748x TX DT node, but I don't
> >>>>>> think that's the case.
> >>>>>>=20
> >>>>>>> Signed-off-by: Niklas S=F6derlund
> >>>>>>> <niklas.soderlund+renesas@ragnatech.se>
> >>>>>>> ---
> >>>>>>>=20
> >>>>>>>  drivers/media/i2c/adv748x/adv748x-core.c | 49 ++++++++++++++++++=
+++
> >>>>>>>  drivers/media/i2c/adv748x/adv748x.h      |  1 +
> >>>>>>>  2 files changed, 50 insertions(+)

[snip]

=2D-=20
Regards,

Laurent Pinchart
