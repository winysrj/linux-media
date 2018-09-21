Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00252a01.pphosted.com ([91.207.212.211]:57434 "EHLO
        mx08-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390212AbeIUTdF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Sep 2018 15:33:05 -0400
Received: from pps.filterd (m0102629.ppops.net [127.0.0.1])
        by mx08-00252a01.pphosted.com (8.16.0.23/8.16.0.23) with SMTP id w8LDXBAE009518
        for <linux-media@vger.kernel.org>; Fri, 21 Sep 2018 14:38:47 +0100
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
        by mx08-00252a01.pphosted.com with ESMTP id 2mmkmd0a1g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <linux-media@vger.kernel.org>; Fri, 21 Sep 2018 14:38:47 +0100
Received: by mail-pg1-f199.google.com with SMTP id r130-v6so5726345pgr.13
        for <linux-media@vger.kernel.org>; Fri, 21 Sep 2018 06:38:47 -0700 (PDT)
MIME-Version: 1.0
References: <20180918014509.6394-1-niklas.soderlund+renesas@ragnatech.se>
 <1658112.YQ0khu1noY@avalon> <CAAoAYcPrEx9bsB0TZ87N8CqsHhWBDzLStOptv2nv6iyfWZqcZg@mail.gmail.com>
 <6518376.j8BxZoQUpz@avalon>
In-Reply-To: <6518376.j8BxZoQUpz@avalon>
From: Dave Stevenson <dave.stevenson@raspberrypi.org>
Date: Fri, 21 Sep 2018 14:38:32 +0100
Message-ID: <CAAoAYcNa2sO0EFa-iZL4SWO3iCHttoFMr0XxPpPWS_qBT4b8Jg@mail.gmail.com>
Subject: Re: [PATCH 1/3] i2c: adv748x: store number of CSI-2 lanes described
 in device tree
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: kieran.bingham@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se, jacopo@jmondi.org,
        LMML <linux-media@vger.kernel.org>,
        linux-renesas-soc@vger.kernel.org,
        Sakari Ailus <sakari.ailus@iki.fi>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the response.

On Fri, 21 Sep 2018 at 11:00, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>
> Hi Dave,
>
> On Friday, 21 September 2018 12:33:39 EEST Dave Stevenson wrote:
> > On Tue, 18 Sep 2018 at 12:13, Laurent Pinchart wrote:
> > > On Tuesday, 18 September 2018 13:51:34 EEST Kieran Bingham wrote:
> > >> On 18/09/18 11:46, Laurent Pinchart wrote:
> > >>> On Tuesday, 18 September 2018 13:37:55 EEST Kieran Bingham wrote:
> > >>>> On 18/09/18 11:28, Laurent Pinchart wrote:
> > >>>>> On Tuesday, 18 September 2018 13:19:39 EEST Kieran Bingham wrote:
> > >>>>>> On 18/09/18 02:45, Niklas S=C3=B6derlund wrote:
> > >>>>>>> The adv748x CSI-2 transmitters TXA and TXB can use different
> > >>>>>>> number of lines to transmit data on. In order to be able config=
ure
> > >>>>>>> the device correctly this information need to be parsed from
> > >>>>>>> device tree and stored in each TX private data structure.
> > >>>>>>>
> > >>>>>>> TXA supports 1, 2 and 4 lanes while TXB supports 1 lane.
> > >>>>>>
> > >>>>>> Am I right in assuming that it is the CSI device which specifies
> > >>>>>> the number of lanes in their DT?
> > >>>>>
> > >>>>> Do you mean the CSI-2 receiver ? Both the receiver and the
> > >>>>> transmitter should specify the data lanes in their DT node.
> > >>>>
> > >>>> Yes, I should have said CSI-2 receiver.
> > >>>>
> > >>>> Aha - so *both* sides of the link have to specify the lanes and
> > >>>> presumably match with each other?
> > >>>
> > >>> Yes, they should certainly match :-)
> > >>
> > >> I assumed so :) - do we need to validate that at a framework level?
> > >> (or perhaps it already is, all I've only looked at this morning is
> > >> e-mails :D )
> > >
> > > It's not done yet as far as I know. CC'ing Sakari who may have a comm=
ent
> > > regarding whether this should be added.
> >
> > (Interested party here due to CSI2 interfacing on the Pi, and I'd like
> > to try and get adv748x working on the Pi once I can get some hardware)
> >
> > Do they need to match? DT is supposedly describing the hardware. Where
> > are you drawing the boundary between the two devices from the
> > hardware/devicetree perspective?
> >
> > As an example, the CSI2 receiver can support 4 lanes, whilst the
> > source only needs 2, or only has 2 connected. As long as the two ends
> > agree on the value in use (which will typically match the source),
> > then there is no issue.
> > It does require the CSI2 receiver driver to validate the remote
> > endpoint settings to ensure that the source doesn't try to use more
> > lanes than the receiver can cope with. That isn't a big deal as you
> > already have the link to the remote end-point. Presumably you're
> > already checking it to determine settings such as if the source is
> > using continuous clocks or not, unless you expect that to be
> > duplicated on both endpoints or your hardware doesn't care.
>
> At least for the data-lanes property, the value is meant to describe how =
lanes
> are physically connected on the board from the transmitter to the receive=
r. It
> does not tell the maximum of lanes that the device supports, which is
> intrinsic information known to the driver already.

Where is the driver getting that information from if not DT?
On the Pi we have two instances of the same peripheral, but it is
parameterised such that one instance only has 2 lanes implemented, and
the other has 4 lanes. Also we have some boards with both the 4-lane
instance where only 2 are wired out to the camera connector.

When trying to get the Pi DT bindings accepted I got blocked from
adding a DT parameter that specified the number of lanes implemented
by the peripheral and told to use data-lanes [1]. Now you say the
driver is meant to intrinsically know. I'm confused.

> Regarding other parameters, such as the clock mode you mentioned, they sh=
ould
> usually be queried and negotiated at runtime, especially given that both =
the
> transmitting and receiving devices may very well support multiple options=
. We
> usually don't involve DT in those cases. Parsing DT properties of a remot=
e
> node is frowned upon, because those properties are qualified by the compa=
tible
> string of the node they sit in. A driver matching "foo,abc" knows what
> properties are defined for the corresponding DT node, but when that drive=
r
> crosses links to DT node "bar,xyz", it has no a priori knowledge of what =
to
> expect there.
>
> Following the OF graph through endpoints and ports is still fine, as if a=
 DT
> node uses the OF graph bindings, the nodes it is connected to are assumed=
 to
> use the same bindings. No assumption can usually be made on other propert=
ies
> though, including the ones describing the bus configuration. For that rea=
son
> the properties for the CSI-2 source should be parsed by the CSI-2 source
> driver, and the configuration of the source should be queried by the CSI-=
2
> receiver at runtime using the v4l2_subdev API (which is routinely extende=
d
> with additional configuration information when the need arises).

You've lost me as to what you are saying is and isn't frowned upon.
data-lanes is in the endpoint, so we're following the OF graph through
the remote-endpoint. Are you saying that it is, or isn't, valid to
assume anything about data-lanes in remote-endpoint?

Do we have a subdev API call that provides this information at
runtime? There are the relatively new fwnode calls, but that is
parsing the endpoint, and you you're saying we're not meant to look at
the remote-endpoint.
Or are you saying that it should be done through the subdev API, but
isn't at the moment? I'd just like to know for definite.

>From what you say it appears I need to update my example DT binding
[2] as it should duplicate "clock-noncontinuous;" in both endpoints.
Is that right?

> > I'm genuinely interested on views here. On the Pi there will be a
> > variety of CSI2 devices connected, generally configured using
> > dtoverlays, and they will have varying requirements on number of
> > lanes. Standard Pis only have 2 CSI-2 lanes exposed out of a possible
> > 4 for the peripheral. The Compute Module is the exception where one
> > CSI2 interface has all 4 lanes brought out, the other only supports 2
> > lanes anyway.
> > I'm expecting the CSI2 receiver endpoint data-lanes property to match
> > that exposed by the Pi board, whilst the source endpoint data-lanes
> > property defines what the source uses. That allows easy validation by
> > the driver that the configuration can work. Otherwise an overlay would
> > have to write the number of lanes used on both the CSI endpoints and
> > potentially configuring it to use more lanes than can be supported.
>
> As explained above, we currently expect the latter, with the overlay modi=
fying
> the data-lanes property of the receiver as well. This is partly due to th=
e
> fact that receivers can support data lanes remapping, so the data-lanes
> property of the receiver needs not only to specify the number of lanes, b=
ut
> also how they are connected.

So data-lanes can't be used as any form of sanity checking, and
multiple parameters get duplicated between the endpoints. Ack.

> If you want to validate the data-lanes property to ensure the overlay doe=
sn't
> try to use more lanes than available, you can do so either against a hard=
coded
> value in the receiver driver (when the maximum is fixed for a given compa=
tible
> string), or against a value read from DT (when the maximum depends on the
> board).

As above, I was told by Sakari to use data-lanes [1].
His comment:
"Please use "data-lanes" endpoint property instead. This is the number of
connected physical lanes and specific to the hardware."

I'd read that as It is the number of physical lanes connected to the
camera connector (not necessarily the camera itself) on that
particular board, otherwise it isn't a max-lanes parameter just a
lanes.
You're saying it should be specific to the board and sensor combination.

> > There is also the oddball one of the TC358743 which dynamically
> > switches the number of lanes in use based on the data rate required.
> > That's probably a separate discussion, but is currently dealt with via
> > g_mbus_config as amended back in Sept 2017 [1].
>
> This falls into the case of dynamic configuration discovery and negotiati=
on I
> mentioned above, and we clearly need to make sure the v4l2_subdev API sup=
ports
> this use case.

So it doesn't support it at the moment?
We're relying 100% on both DT entries being matched and consistent,
and can't cope with dynamic reconfig (I see Phillipp's patch for the
workaround with g_mbus_config never got merged).

I thought I'd got a handle on this DT stuff, but obviously not :-(

Thanks,
  Dave

[1] https://www.spinics.net/lists/linux-media/msg117080.html
[2] https://www.spinics.net/lists/linux-media/msg122299.html
