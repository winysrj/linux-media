Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00252a01.pphosted.com ([62.209.51.214]:54080 "EHLO
        mx07-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726479AbeIUPcz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Sep 2018 11:32:55 -0400
Received: from pps.filterd (m0102628.ppops.net [127.0.0.1])
        by mx07-00252a01.pphosted.com (8.16.0.23/8.16.0.23) with SMTP id w8L9VJIr010290
        for <linux-media@vger.kernel.org>; Fri, 21 Sep 2018 10:33:54 +0100
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
        by mx07-00252a01.pphosted.com with ESMTP id 2mmkmdr6r9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <linux-media@vger.kernel.org>; Fri, 21 Sep 2018 10:33:54 +0100
Received: by mail-pf1-f197.google.com with SMTP id e15-v6so6394186pfi.5
        for <linux-media@vger.kernel.org>; Fri, 21 Sep 2018 02:33:54 -0700 (PDT)
MIME-Version: 1.0
References: <20180918014509.6394-1-niklas.soderlund+renesas@ragnatech.se>
 <1715235.WJqBHKOvrx@avalon> <21b8a885-48c5-70c8-8866-1830c45c27a9@ideasonboard.com>
 <1658112.YQ0khu1noY@avalon>
In-Reply-To: <1658112.YQ0khu1noY@avalon>
From: Dave Stevenson <dave.stevenson@raspberrypi.org>
Date: Fri, 21 Sep 2018 10:33:39 +0100
Message-ID: <CAAoAYcPrEx9bsB0TZ87N8CqsHhWBDzLStOptv2nv6iyfWZqcZg@mail.gmail.com>
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

Hi All,

On Tue, 18 Sep 2018 at 12:13, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>
> Hi Kieran,
>
> On Tuesday, 18 September 2018 13:51:34 EEST Kieran Bingham wrote:
> > On 18/09/18 11:46, Laurent Pinchart wrote:
> > > On Tuesday, 18 September 2018 13:37:55 EEST Kieran Bingham wrote:
> > >> On 18/09/18 11:28, Laurent Pinchart wrote:
> > >>> On Tuesday, 18 September 2018 13:19:39 EEST Kieran Bingham wrote:
> > >>>> On 18/09/18 02:45, Niklas S=C3=B6derlund wrote:
> > >>>>> The adv748x CSI-2 transmitters TXA and TXB can use different numb=
er of
> > >>>>> lines to transmit data on. In order to be able configure the devi=
ce
> > >>>>> correctly this information need to be parsed from device tree and
> > >>>>> stored in each TX private data structure.
> > >>>>>
> > >>>>> TXA supports 1, 2 and 4 lanes while TXB supports 1 lane.
> > >>>>
> > >>>> Am I right in assuming that it is the CSI device which specifies t=
he
> > >>>> number of lanes in their DT?
> > >>>
> > >>> Do you mean the CSI-2 receiver ? Both the receiver and the transmit=
ter
> > >>> should specify the data lanes in their DT node.
> > >>
> > >> Yes, I should have said CSI-2 receiver.
> > >>
> > >> Aha - so *both* sides of the link have to specify the lanes and
> > >> presumably match with each other?
> > >
> > > Yes, they should certainly match :-)
> >
> > I assumed so :) - do we need to validate that at a framework level?
> > (or perhaps it already is, all I've only looked at this morning is
> > e-mails :D )
>
> It's not done yet as far as I know. CC'ing Sakari who may have a comment
> regarding whether this should be added.

(Interested party here due to CSI2 interfacing on the Pi, and I'd like
to try and get adv748x working on the Pi once I can get some hardware)

Do they need to match? DT is supposedly describing the hardware. Where
are you drawing the boundary between the two devices from the
hardware/devicetree perspective?

As an example, the CSI2 receiver can support 4 lanes, whilst the
source only needs 2, or only has 2 connected. As long as the two ends
agree on the value in use (which will typically match the source),
then there is no issue.
It does require the CSI2 receiver driver to validate the remote
endpoint settings to ensure that the source doesn't try to use more
lanes than the receiver can cope with. That isn't a big deal as you
already have the link to the remote end-point. Presumably you're
already checking it to determine settings such as if the source is
using continuous clocks or not, unless you expect that to be
duplicated on both endpoints or your hardware doesn't care.

I'm genuinely interested on views here. On the Pi there will be a
variety of CSI2 devices connected, generally configured using
dtoverlays, and they will have varying requirements on number of
lanes. Standard Pis only have 2 CSI-2 lanes exposed out of a possible
4 for the peripheral. The Compute Module is the exception where one
CSI2 interface has all 4 lanes brought out, the other only supports 2
lanes anyway.
I'm expecting the CSI2 receiver endpoint data-lanes property to match
that exposed by the Pi board, whilst the source endpoint data-lanes
property defines what the source uses. That allows easy validation by
the driver that the configuration can work. Otherwise an overlay would
have to write the number of lanes used on both the CSI endpoints and
potentially configuring it to use more lanes than can be supported.


There is also the oddball one of the TC358743 which dynamically
switches the number of lanes in use based on the data rate required.
That's probably a separate discussion, but is currently dealt with via
g_mbus_config as amended back in Sept 2017 [1].

Cheers,
  Dave

[1] Discussion https://www.spinics.net/lists/linux-media/msg122287.html
and patch https://www.spinics.net/lists/linux-media/msg122435.html

> > >>>> Could we make this clear in the commit log (and possibly an extra
> > >>>> comment in the code). At first I was assuming we would have to dec=
lare
> > >>>> the number of lanes in the ADV748x TX DT node, but I don't think t=
hat's
> > >>>> the case.
> > >>>>
> > >>>>> Signed-off-by: Niklas S=C3=B6derlund
> > >>>>> <niklas.soderlund+renesas@ragnatech.se>
> > >>>>> ---
> > >>>>>
> > >>>>>  drivers/media/i2c/adv748x/adv748x-core.c | 49 ++++++++++++++++++=
+++++
> > >>>>>  drivers/media/i2c/adv748x/adv748x.h      |  1 +
> > >>>>>  2 files changed, 50 insertions(+)
> > >>>>>
> > >>>>> diff --git a/drivers/media/i2c/adv748x/adv748x-core.c
> > >>>>> b/drivers/media/i2c/adv748x/adv748x-core.c index
> > >>>>> 85c027bdcd56748d..a93f8ea89a228474 100644
> > >>>>> --- a/drivers/media/i2c/adv748x/adv748x-core.c
> > >>>>> +++ b/drivers/media/i2c/adv748x/adv748x-core.c
> > >
> > > [snip]
> > >
> > >>>>> +static int adv748x_parse_csi2_lanes(struct adv748x_state *state,
> > >>>>> +                                   unsigned int port,
> > >>>>> +                                   struct device_node *ep)
> > >>>>> +{
> > >>>>> +       struct v4l2_fwnode_endpoint vep;
> > >>>>> +       unsigned int num_lanes;
> > >>>>> +       int ret;
> > >>>>> +
> > >>>>> +       if (port !=3D ADV748X_PORT_TXA && port !=3D ADV748X_PORT_=
TXB)
> > >>>>> +               return 0;
> > >>>>> +
> > >>>>> +       ret =3D v4l2_fwnode_endpoint_parse(of_fwnode_handle(ep), =
&vep);
> > >>>>> +       if (ret)
> > >>>>> +               return ret;
> > >>>>> +
> > >>>>> +       num_lanes =3D vep.bus.mipi_csi2.num_data_lanes;
> > >>>>> +
> > >>>>
> > >>>> If I'm not mistaken we are parsing /someone elses/ DT node here (t=
he
> > >>>> CSI receiver or such).
> > >>>
> > >>> Aren't we parsing our own endpoint ? The ep argument comes from ep_=
np in
> > >>> adv748x_parse_dt(), and that's the endpoint iterator used with
> > >>>
> > >>>   for_each_endpoint_of_node(state->dev->of_node, ep_np)
> > >>
> > >> Bah - my head was polluted with the async subdevice stuff where we w=
ere
> > >> getting the endpoint of the other device, but of course that's
> > >> completely unrelated here.
> > >>
> > >>>> Is it now guaranteed on the mipi_csi2 bus to have the (correct) la=
nes
> > >>>> defined?
> > >>>>
> > >>>> Do we need to fall back to some safe defaults at all (1 lane?) ?
> > >>>> Actually - perhaps there is no safe default. I guess if the lanes
> > >>>> aren't configured correctly we're not going to get a good signal a=
t the
> > >>>> other end.
> > >>>
> > >>> The endpoints should contain a data-lanes property. That's the case=
 in
> > >>> the mainline DT sources, but it's not explicitly stated as a mandat=
ory
> > >>> property. I think we should update the bindings.
> > >>
> > >> Yes, - as this code change is making the property mandatory - we sho=
uld
> > >> certainly state that in the bindings, unless we can fall back to a
> > >> sensible default (perhaps the max supported on that component?)
> > >
> > > I'm not sure there's a sensible default, I'd rather specify it explic=
itly.
> > > Note that the data-lanes property doesn't just specify the number of
> > > lanes, but also how they are remapped, when that feature is supported=
 by
> > > the CSI-2 transmitter or receiver.
> >
> > Ok understood. As I feared - we can't really default - because it has t=
o
> > match and be defined.
> >
> > So making the DT property mandatory really is the way to go then.
> >
> > >>>>> +       if (vep.base.port =3D=3D ADV748X_PORT_TXA) {
> > >>>>> +               if (num_lanes !=3D 1 && num_lanes !=3D 2 && num_l=
anes !=3D 4) {
> > >>>>> +                       adv_err(state, "TXA: Invalid number (%d) =
of lanes\n",
> > >>>>> +                               num_lanes);
> > >>>>> +                       return -EINVAL;
> > >>>>> +               }
> > >>>>> +
> > >>>>> +               state->txa.num_lanes =3D num_lanes;
> > >>>>> +               adv_dbg(state, "TXA: using %d lanes\n", state->tx=
a.num_lanes);
> > >>>>> +       }
> > >>>>> +
> > >>>>> +       if (vep.base.port =3D=3D ADV748X_PORT_TXB) {
> > >>>>> +               if (num_lanes !=3D 1) {
> > >>>>> +                       adv_err(state, "TXB: Invalid number (%d) =
of lanes\n",
> > >>>>> +                               num_lanes);
> > >>>>> +                       return -EINVAL;
> > >>>>> +               }
> > >>>>> +
> > >>>>> +               state->txb.num_lanes =3D num_lanes;
> > >>>>> +               adv_dbg(state, "TXB: using %d lanes\n", state->tx=
b.num_lanes);
> > >>>>> +       }
> > >>>>> +
> > >>>>> +       return 0;
> > >>>>> +}
> > >
> > > [snip]
>
> --
> Regards,
>
> Laurent Pinchart
>
>
>
