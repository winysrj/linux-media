Return-Path: <SRS0=qcaw=OS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C66EAC65BAF
	for <linux-media@archiver.kernel.org>; Sun,  9 Dec 2018 19:39:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8690520831
	for <linux-media@archiver.kernel.org>; Sun,  9 Dec 2018 19:39:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8690520831
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=jmondi.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbeLITjV (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 9 Dec 2018 14:39:21 -0500
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:50473 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbeLITjV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 9 Dec 2018 14:39:21 -0500
X-Originating-IP: 2.224.242.101
Received: from w540 (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 46035240002;
        Sun,  9 Dec 2018 19:39:14 +0000 (UTC)
Date:   Sun, 9 Dec 2018 20:39:12 +0100
From:   jacopo mondi <jacopo@jmondi.org>
To:     Michael Nazzareno Trimarchi <michael@amarulasolutions.com>
Cc:     hverkuil@xs4all.nl, Jagan Teki <jagan@amarulasolutions.com>,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: Re: Configure video PAL decoder into media pipeline
Message-ID: <20181209193912.GC12193@w540>
References: <CAMty3ZAa2_o87YJ=1iak-o-rfZjoYz7PKXM9uGrbHsh6JLOCWw@mail.gmail.com>
 <850c2502-217c-a9f0-b433-0cd26d0419fd@xs4all.nl>
 <CAOf5uwkirwRPk3=w1fONLrOpwNqGiJbhh6okDmOTWyKWvW+U1w@mail.gmail.com>
 <CAOf5uw=d6D4FGZp8iWKdA1+77ZQtkNZwbJStmO+L-NtW4gqfaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="3siQDZowHQqNOShm"
Content-Disposition: inline
In-Reply-To: <CAOf5uw=d6D4FGZp8iWKdA1+77ZQtkNZwbJStmO+L-NtW4gqfaA@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--3siQDZowHQqNOShm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Michael, Jagan, Hans,

On Sat, Dec 08, 2018 at 06:07:04PM +0100, Michael Nazzareno Trimarchi wrote:
> Hi
>
> Down you have my tentative of connection
>
> I need to hack a bit to have tuner registered. I'm using imx-media
>
> On Sat, Dec 8, 2018 at 12:48 PM Michael Nazzareno Trimarchi
> <michael@amarulasolutions.com> wrote:
> >
> > Hi
> >
> > On Fri, Dec 7, 2018 at 1:11 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > >
> > > On 12/07/2018 12:51 PM, Jagan Teki wrote:
> > > > Hi,
> > > >
> > > > We have some unconventional setup for parallel CSI design where ana=
log
> > > > input data is converted into to digital composite using PAL decoder
> > > > and it feed to adv7180, camera sensor.
> > > >
> > > > Analog input =3D>  Video PAL Decoder =3D> ADV7180 =3D> IPU-CSI0
> > >
> > > Just PAL? No NTSC support?
> > >
> > For now does not matter. I have registere the TUNER that support it
> > but seems that media-ctl is not suppose to work with the MEDIA_ENT_F_TU=
NER
> >
> > Is this correct?
> >

media-types.rst reports:

    *  -  ``MEDIA_ENT_F_IF_VID_DECODER``
       -  IF-PLL video decoder. It receives the IF from a PLL and decodes
	  the analog TV video signal. This is commonly found on some very
	  old analog tuners, like Philips MK3 designs. They all contain a
	  tda9887 (or some software compatible similar chip, like tda9885).
	  Those devices use a different I2C address than the tuner PLL.

Is this what you were looking for?

> > > >
> > > > The PAL decoder is I2C based, tda9885 chip. We setup it up via dt
> > > > bindings and the chip is
> > > > detected fine.
> > > >
> > > > But we need to know, is this to be part of media control subdev
> > > > pipeline? so-that we can configure pads, links like what we do on
> > > > conventional pipeline  or it should not to be part of media pipelin=
e?
> > >
> > > Yes, I would say it should be part of the pipeline.
> > >
> >
> > Ok I have created a draft patch to add the adv some new endpoint but
> > is sufficient to declare tuner type in media control?
> >
> > Michael
> >
> > > >
> > > > Please advise for best possible way to fit this into the design.
> > > >
> > > > Another observation is since the IPU has more than one sink, source
> > > > pads, we source or sink the other components on the pipeline but lo=
ok
> > > > like the same thing seems not possible with adv7180 since if has on=
ly
> > > > one pad. If it has only one pad sourcing to adv7180 from tda9885 se=
ems
> > > > not possible, If I'm not mistaken.
> > >
> > > Correct, in all cases where the adv7180 is used it is directly connec=
ted
> > > to the video input connector on a board.
> > >
> > > So to support this the adv7180 driver should be modified to add an in=
put pad
> > > so you can connect the decoder. It will be needed at some point anywa=
y once
> > > we add support for connector entities.
> > >
> > > Regards,
> > >
> > >         Hans
> > >
> > > >
> > > > I tried to look for similar design in mainline, but I couldn't find
> > > > it. is there any design similar to this in mainline?
> > > >
> > > > Please let us know if anyone has any suggestions on this.
> > > >
>
> [    3.379129] imx-media: ipu1_vdic:2 -> ipu1_ic_prp:0
> [    3.384262] imx-media: ipu2_vdic:2 -> ipu2_ic_prp:0
> [    3.389217] imx-media: ipu1_ic_prp:1 -> ipu1_ic_prpenc:0
> [    3.394616] imx-media: ipu1_ic_prp:2 -> ipu1_ic_prpvf:0
> [    3.399867] imx-media: ipu2_ic_prp:1 -> ipu2_ic_prpenc:0
> [    3.405289] imx-media: ipu2_ic_prp:2 -> ipu2_ic_prpvf:0
> [    3.410552] imx-media: ipu1_csi0:1 -> ipu1_ic_prp:0
> [    3.415502] imx-media: ipu1_csi0:1 -> ipu1_vdic:0
> [    3.420305] imx-media: ipu1_csi0_mux:5 -> ipu1_csi0:0
> [    3.425427] imx-media: ipu1_csi1:1 -> ipu1_ic_prp:0
> [    3.430328] imx-media: ipu1_csi1:1 -> ipu1_vdic:0
> [    3.435142] imx-media: ipu1_csi1_mux:5 -> ipu1_csi1:0
> [    3.440321] imx-media: adv7180 2-0020:1 -> ipu1_csi0_mux:4
>
> with
>        tuner: tuner@43 {
>                 compatible =3D "tuner";
>                 reg =3D <0x43>;
>                 pinctrl-names =3D "default";
>                 pinctrl-0 =3D <&pinctrl_tuner>;
>
>                 ports {
>                         #address-cells =3D <1>;
>                         #size-cells =3D <0>;
>                         port@1 {
>                                 reg =3D <1>;
>
>                                 tuner_in: endpoint {

Nit: This is the tuner output, I would call this "tuner_out"

>                                         remote-endpoint =3D <&tuner_out>;
>                                 };
>                         };
>                 };
>         };
>
>         adv7180: camera@20 {
>                 compatible =3D "adi,adv7180";

One minor thing first: look at the adv7180 bindings documentation, and
you'll find out that only devices compatible with "adv7180cp" and
"adv7180st" shall declare a 'ports' node. This is minor issues (also,
I don't see it enforced in driver's code, but still worth pointing it
out from the very beginning)

>                 reg =3D <0x20>;
>                 pinctrl-names =3D "default";
>                 pinctrl-0 =3D <&pinctrl_adv7180>;
>                 powerdown-gpios =3D <&gpio3 20 GPIO_ACTIVE_LOW>; /* PDEC_=
PWRDN */
>
>                 ports {
>                         #address-cells =3D <1>;
>                         #size-cells =3D <0>;
>
>                         port@1 {
>                                 reg =3D <1>;
>
>                                 adv7180_to_ipu1_csi0_mux: endpoint {
>                                         remote-endpoint =3D
> <&ipu1_csi0_mux_from_parallel_sensor>;
>                                         bus-width =3D <8>;
>                                 };
>                         };
>
>                         port@0 {
>                                 reg =3D <0>;
>
>                                 tuner_out: endpoint {

Nit: That's an adv7180 endpoint, I would call it 'adv7180_in'

>                                         remote-endpoint =3D <&tuner_in>;
>                                 };
>                         };
>                 };
>         };
>
> Any help is appreciate
>

The adv7180(cp|st) bindings says the device can declare one (or more)
input endpoints, but that's just to make possible to connect in device
tree the 7180's device node with the video input port. You can see an
example in arch/arm64/boot/dts/renesas/r8a77995-draak.dts which is
similar to what you've done here.

The video input port does not show up in the media graph, as it is
just a 'place holder' to describe an input port in DTs, the
adv7180 driver does not register any sink pad, where to connect any
video source to.

Your proposed bindings here look almost correct, but to have it
working for real you should add a sink pad to the adv7180 registered
media entity (possibly only conditionally to the presence of an input
endpoint in DTs...). You should then register a subdev-notifier, which
registers on an async-subdevice that uses the remote endpoint
connected to your newly registered input pad to find out which device
you're linked to; then at 'bound' (or possibly 'complete') time
register a link between the two entities, on which you can operate on
=66rom userspace.

Your tuner driver for tda9885 (which I don't see in mainline, so I
assume it's downstream or custom code) should register an async subdevice,
so that the adv7180 registered subdev-notifier gets matched and your
callbacks invoked.

If I were you, I would:
1) Add dt-parsing routine to tda7180, to find out if any input
endpoint is registered in DT.
2) If it is, then register a SINK pad, along with the single SOURCE pad
which is registered today.
3) When parsing DT, for input endpoints, get a reference to the remote
endpoint connected to your input and register a subdev-notifier
4) Fill in the notifier 'bound' callback and register the link to
your remote device there.
5) Make sure your tuner driver registers its subdevice with
v4l2_async_register_subdev()

A good example on how to register subdev notifier is provided in the
rcsi2_parse_dt() function in rcar-csi2.c driver (I'm quite sure imx
now uses subdev notifiers from v4.19 on too if you want to have a look
there).

-- Entering slippery territory here: you might want more inputs on this

To make thing simpler&nicer (TM), if you blindly do what I've suggested
here, you're going to break all current adv7180 users in mainline :(

That's because the v4l2-async design 'completes' the root notifier,
only if all subdev-notifiers connected to it have completed first.
If you add a notifier for the adv7180 input ports unconditionally, and
to the input port is connected a plain simple "composite-video-connector",
as all DTs in mainline are doing right now, the newly registered
subdev-notifier will never complete, as the "composite-video-connector"
does not register any subdevice to match with. Bummer!

A quick look in the code base, returns me that, in example:
drivers/gpu/drm/meson/meson_drv.c filters on
"composite-video-connector" and a few other compatible values. You
might want to do the same, and register a notifier if and only if the
remote input endpoint is one of those known not to register a
subdevice. I'm sure there are other ways to deal with this issue, but
that's the best I can come up with...
---

Hope this is reasonably clear and that I'm not misleading you. I had to
use adv7180 recently, and its single pad design confused me a bit as well :)

Thanks
  j

> Michael
>
> > > > Jagan.
> > > >
> > >
> >
> >
> > --

--3siQDZowHQqNOShm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJcDW9gAAoJEHI0Bo8WoVY8kTsP/3lveDuNBVCo7E/WUslJtGm7
I7mRVZjKARgQsTU806eMeoDThe+XL7+gdujiG+V+9n2R+55tge2IANc1IEFT3gHp
38bPw0UXD279DzRk9lZGCc5iCIa9EQlSCzpg20uLsPsNuzqpuSYyIbIEn0kUjoq7
CETACyhDNNz5hN2oATJREReKZYD8mUdBYkWX3pSgXCitMDVism+DYUyt3MeTIgTm
ieOaLSWBAOcpl7Yfk8nu4eTjlZlL9Z2pjMRTvxvs5T3fZuXXvEd1DiLstHCWY9cK
r+nk2H5+ZlQO4mA4WAwaurioKWJyI5FBQ0AUpNLz00C/nr2PFHKmmBEbWbe50EYk
al/nwP6JDOnidE+W8xqdByK6zOg5RRxFT++WL9ffbJKvP2G0TNNaI1mGGXNEZYeG
GPz8XfYSKy1JlCSu0d5MHxGXaVtDfGYKmVB4rrZWRcAxRJ77LVD7RhTtGihyWBX2
BgEqkeOejJUT/qETzpxaasEhfeJooH3oIai7SEJp/kSiksTh/VbcJL6bwv/Y3BJC
iufOImzWX5pPRyMAX/cOM6mzCgpE+n50hOPghpTw7uO+g3q+D4qBU9IMHm9eupLH
Iv5xon/8TFpeAudhITTizK/T6/7kghIkN7tIapwUUY5G8+7lPZv5UMrp/9DtsgEk
kr+IcCFDQKYvBz2FaGHz
=qGAc
-----END PGP SIGNATURE-----

--3siQDZowHQqNOShm--
