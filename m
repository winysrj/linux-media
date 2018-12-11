Return-Path: <SRS0=Y87V=OU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4F1BC07E85
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 11:39:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 837C92084C
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 11:39:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 837C92084C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=jmondi.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbeLKLjU (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 11 Dec 2018 06:39:20 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:59801 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbeLKLjU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Dec 2018 06:39:20 -0500
X-Originating-IP: 2.224.242.101
Received: from w540 (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id CDF601C0008;
        Tue, 11 Dec 2018 11:39:13 +0000 (UTC)
Date:   Tue, 11 Dec 2018 12:39:12 +0100
From:   jacopo mondi <jacopo@jmondi.org>
To:     Michael Nazzareno Trimarchi <michael@amarulasolutions.com>
Cc:     hverkuil@xs4all.nl, Jagan Teki <jagan@amarulasolutions.com>,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: Re: Configure video PAL decoder into media pipeline
Message-ID: <20181211113912.GI5597@w540>
References: <CAMty3ZAa2_o87YJ=1iak-o-rfZjoYz7PKXM9uGrbHsh6JLOCWw@mail.gmail.com>
 <850c2502-217c-a9f0-b433-0cd26d0419fd@xs4all.nl>
 <CAOf5uwkirwRPk3=w1fONLrOpwNqGiJbhh6okDmOTWyKWvW+U1w@mail.gmail.com>
 <CAOf5uw=d6D4FGZp8iWKdA1+77ZQtkNZwbJStmO+L-NtW4gqfaA@mail.gmail.com>
 <20181209193912.GC12193@w540>
 <CAOf5uwncWDqLsAvQ1H0xN1qQRA_NBt=m2Ncuz_3_nCRhFptpAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="j+MD90OnwjQyWNYt"
Content-Disposition: inline
In-Reply-To: <CAOf5uwncWDqLsAvQ1H0xN1qQRA_NBt=m2Ncuz_3_nCRhFptpAw@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--j+MD90OnwjQyWNYt
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Michael,

On Mon, Dec 10, 2018 at 10:45:02PM +0100, Michael Nazzareno Trimarchi wrote:
> Hi Jacopo
>
> Let's see what I have done
>
> On Sun, Dec 9, 2018 at 8:39 PM jacopo mondi <jacopo@jmondi.org> wrote:
> >
> > Hi Michael, Jagan, Hans,
> >
> > On Sat, Dec 08, 2018 at 06:07:04PM +0100, Michael Nazzareno Trimarchi wrote:
> > > Hi
> > >
> > > Down you have my tentative of connection
> > >
> > > I need to hack a bit to have tuner registered. I'm using imx-media
> > >
> > > On Sat, Dec 8, 2018 at 12:48 PM Michael Nazzareno Trimarchi
> > > <michael@amarulasolutions.com> wrote:
> > > >
> > > > Hi
> > > >
> > > > On Fri, Dec 7, 2018 at 1:11 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > > > >
> > > > > On 12/07/2018 12:51 PM, Jagan Teki wrote:
> > > > > > Hi,
> > > > > >
> > > > > > We have some unconventional setup for parallel CSI design where analog
> > > > > > input data is converted into to digital composite using PAL decoder
> > > > > > and it feed to adv7180, camera sensor.
> > > > > >
> > > > > > Analog input =>  Video PAL Decoder => ADV7180 => IPU-CSI0
> > > > >
> > > > > Just PAL? No NTSC support?
> > > > >
> > > > For now does not matter. I have registere the TUNER that support it
> > > > but seems that media-ctl is not suppose to work with the MEDIA_ENT_F_TUNER
> > > >
> > > > Is this correct?
> > > >
> >
> > media-types.rst reports:
> >
> >     *  -  ``MEDIA_ENT_F_IF_VID_DECODER``
> >        -  IF-PLL video decoder. It receives the IF from a PLL and decodes
> >           the analog TV video signal. This is commonly found on some very
> >           old analog tuners, like Philips MK3 designs. They all contain a
> >           tda9887 (or some software compatible similar chip, like tda9885).
> >           Those devices use a different I2C address than the tuner PLL.
> >
> > Is this what you were looking for?
> >
> > > > > >
> > > > > > The PAL decoder is I2C based, tda9885 chip. We setup it up via dt
> > > > > > bindings and the chip is
> > > > > > detected fine.
> > > > > >
> > > > > > But we need to know, is this to be part of media control subdev
> > > > > > pipeline? so-that we can configure pads, links like what we do on
> > > > > > conventional pipeline  or it should not to be part of media pipeline?
> > > > >
> > > > > Yes, I would say it should be part of the pipeline.
> > > > >
> > > >
> > > > Ok I have created a draft patch to add the adv some new endpoint but
> > > > is sufficient to declare tuner type in media control?
> > > >
> > > > Michael
> > > >
> > > > > >
> > > > > > Please advise for best possible way to fit this into the design.
> > > > > >
> > > > > > Another observation is since the IPU has more than one sink, source
> > > > > > pads, we source or sink the other components on the pipeline but look
> > > > > > like the same thing seems not possible with adv7180 since if has only
> > > > > > one pad. If it has only one pad sourcing to adv7180 from tda9885 seems
> > > > > > not possible, If I'm not mistaken.
> > > > >
> > > > > Correct, in all cases where the adv7180 is used it is directly connected
> > > > > to the video input connector on a board.
> > > > >
> > > > > So to support this the adv7180 driver should be modified to add an input pad
> > > > > so you can connect the decoder. It will be needed at some point anyway once
> > > > > we add support for connector entities.
> > > > >
> > > > > Regards,
> > > > >
> > > > >         Hans
> > > > >
> > > > > >
> > > > > > I tried to look for similar design in mainline, but I couldn't find
> > > > > > it. is there any design similar to this in mainline?
> > > > > >
> > > > > > Please let us know if anyone has any suggestions on this.
> > > > > >
> > >
> > > [    3.379129] imx-media: ipu1_vdic:2 -> ipu1_ic_prp:0
> > > [    3.384262] imx-media: ipu2_vdic:2 -> ipu2_ic_prp:0
> > > [    3.389217] imx-media: ipu1_ic_prp:1 -> ipu1_ic_prpenc:0
> > > [    3.394616] imx-media: ipu1_ic_prp:2 -> ipu1_ic_prpvf:0
> > > [    3.399867] imx-media: ipu2_ic_prp:1 -> ipu2_ic_prpenc:0
> > > [    3.405289] imx-media: ipu2_ic_prp:2 -> ipu2_ic_prpvf:0
> > > [    3.410552] imx-media: ipu1_csi0:1 -> ipu1_ic_prp:0
> > > [    3.415502] imx-media: ipu1_csi0:1 -> ipu1_vdic:0
> > > [    3.420305] imx-media: ipu1_csi0_mux:5 -> ipu1_csi0:0
> > > [    3.425427] imx-media: ipu1_csi1:1 -> ipu1_ic_prp:0
> > > [    3.430328] imx-media: ipu1_csi1:1 -> ipu1_vdic:0
> > > [    3.435142] imx-media: ipu1_csi1_mux:5 -> ipu1_csi1:0
> > > [    3.440321] imx-media: adv7180 2-0020:1 -> ipu1_csi0_mux:4
> > >
> > > with
> > >        tuner: tuner@43 {
> > >                 compatible = "tuner";
> > >                 reg = <0x43>;
> > >                 pinctrl-names = "default";
> > >                 pinctrl-0 = <&pinctrl_tuner>;
> > >
> > >                 ports {
> > >                         #address-cells = <1>;
> > >                         #size-cells = <0>;
> > >                         port@1 {
> > >                                 reg = <1>;
> > >
> > >                                 tuner_in: endpoint {
> >
> > Nit: This is the tuner output, I would call this "tuner_out"
> >
>
> Done
>
> > >                                         remote-endpoint = <&tuner_out>;
> > >                                 };
> > >                         };
> > >                 };
> > >         };
> > >
> > >         adv7180: camera@20 {
> > >                 compatible = "adi,adv7180";
> >
> > One minor thing first: look at the adv7180 bindings documentation, and
> > you'll find out that only devices compatible with "adv7180cp" and
> > "adv7180st" shall declare a 'ports' node. This is minor issues (also,
> > I don't see it enforced in driver's code, but still worth pointing it
> > out from the very beginning)
> >
> > >                 reg = <0x20>;
> > >                 pinctrl-names = "default";
> > >                 pinctrl-0 = <&pinctrl_adv7180>;
> > >                 powerdown-gpios = <&gpio3 20 GPIO_ACTIVE_LOW>; /* PDEC_PWRDN */
> > >
> > >                 ports {
> > >                         #address-cells = <1>;
> > >                         #size-cells = <0>;
> > >
> > >                         port@1 {
> > >                                 reg = <1>;
> > >
> > >                                 adv7180_to_ipu1_csi0_mux: endpoint {
> > >                                         remote-endpoint =
> > > <&ipu1_csi0_mux_from_parallel_sensor>;
> > >                                         bus-width = <8>;
> > >                                 };
> > >                         };
> > >
> > >                         port@0 {
> > >                                 reg = <0>;
> > >
> > >                                 tuner_out: endpoint {
> >
> > Nit: That's an adv7180 endpoint, I would call it 'adv7180_in'
> >
>
> Done
>
> > >                                         remote-endpoint = <&tuner_in>;
> > >                                 };
> > >                         };
> > >                 };
> > >         };
> > >
> > > Any help is appreciate
> > >
> >
> > The adv7180(cp|st) bindings says the device can declare one (or more)
> > input endpoints, but that's just to make possible to connect in device
> > tree the 7180's device node with the video input port. You can see an
> > example in arch/arm64/boot/dts/renesas/r8a77995-draak.dts which is
> > similar to what you've done here.
> >
> > The video input port does not show up in the media graph, as it is
> > just a 'place holder' to describe an input port in DTs, the
> > adv7180 driver does not register any sink pad, where to connect any
> > video source to.
> >
> > Your proposed bindings here look almost correct, but to have it
> > working for real you should add a sink pad to the adv7180 registered
> > media entity (possibly only conditionally to the presence of an input
> > endpoint in DTs...). You should then register a subdev-notifier, which
> > registers on an async-subdevice that uses the remote endpoint
> > connected to your newly registered input pad to find out which device
> > you're linked to; then at 'bound' (or possibly 'complete') time
> > register a link between the two entities, on which you can operate on
> > from userspace.
> >
> > Your tuner driver for tda9885 (which I don't see in mainline, so I
> > assume it's downstream or custom code) should register an async subdevice,
> > so that the adv7180 registered subdev-notifier gets matched and your
> > callbacks invoked.
> >
> > If I were you, I would:
> > 1) Add dt-parsing routine to tda7180, to find out if any input
> > endpoint is registered in DT.
>
> Done
>
> > 2) If it is, then register a SINK pad, along with the single SOURCE pad
> > which is registered today.
>
> Done
>
> > 3) When parsing DT, for input endpoints, get a reference to the remote
> > endpoint connected to your input and register a subdev-notifier
>
> Done
>
> > 4) Fill in the notifier 'bound' callback and register the link to
> > your remote device there.
>
> Both are subdevice that has not a v4l2_device, so bound is not called from two
> sub-device. Is this expected?

That should not be an issue. As we discussed, I slightly misleaded
you, pointing you to rcar-csi2, which implements a 'custom' matching
logic, trying to match its remote on endpoints and not on device node.

	priv->asd.match.fwnode =
		fwnode_graph_get_remote_endpoint(of_fwnode_handle(ep));

I'm sorry about this.

You better use something like:

	asd->match.fwnode =
		fwnode_graph_get_remote_port_parent(endpoint);

or the recently introduced 'v4l2_async_notifier_parse_fwnode_endpoints_by_port()'
function, that does most of that for you.

Sorry about this.
Thanks
   j

>
>
> > 5) Make sure your tuner driver registers its subdevice with
> > v4l2_async_register_subdev()
> >
> > A good example on how to register subdev notifier is provided in the
> > rcsi2_parse_dt() function in rcar-csi2.c driver (I'm quite sure imx
> > now uses subdev notifiers from v4.19 on too if you want to have a look
> > there).
>
> Already seen it
>
> >
> > -- Entering slippery territory here: you might want more inputs on this
> >
> > To make thing simpler&nicer (TM), if you blindly do what I've suggested
> > here, you're going to break all current adv7180 users in mainline :(
> >
> > That's because the v4l2-async design 'completes' the root notifier,
> > only if all subdev-notifiers connected to it have completed first.
> > If you add a notifier for the adv7180 input ports unconditionally, and
>
> I don't get to complete. So let's proceed by step
>
> Michael
>
> > to the input port is connected a plain simple "composite-video-connector",
> > as all DTs in mainline are doing right now, the newly registered
> > subdev-notifier will never complete, as the "composite-video-connector"
> > does not register any subdevice to match with. Bummer!
> >
> > A quick look in the code base, returns me that, in example:
> > drivers/gpu/drm/meson/meson_drv.c filters on
> > "composite-video-connector" and a few other compatible values. You
> > might want to do the same, and register a notifier if and only if the
> > remote input endpoint is one of those known not to register a
> > subdevice. I'm sure there are other ways to deal with this issue, but
> > that's the best I can come up with...
> > ---
> >
> > Hope this is reasonably clear and that I'm not misleading you. I had to
> > use adv7180 recently, and its single pad design confused me a bit as well :)
> >
> > Thanks
> >   j
> >
> > > Michael
> > >
> > > > > > Jagan.
> > > > > >
> > > > >
> > > >
> > > >
> > > > --
>
>
>
> --
> | Michael Nazzareno Trimarchi                     Amarula Solutions BV |
> | COO  -  Founder                                      Cruquiuskade 47 |
> | +31(0)851119172                                 Amsterdam 1018 AM NL |
> |                  [`as] http://www.amarulasolutions.com               |

--j+MD90OnwjQyWNYt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJcD6HfAAoJEHI0Bo8WoVY87k4P/RbNR40dsP/V260qTNW2soFF
BTQ5PGyjVggn7BHHaCViSlYVY7hb3iqQDdCzW74BS/xQlHItfRYld8R2bc8sVGCf
maxegR4KoCmrvp33NJ488MjoonDRRPHhbPXOfEO0yHYVQSVpYzAGHpPQbIFt/o7n
cuU43ZTVgJRgDvLQZQZlAfEtt3ymDYfvV3RHcgIIfAL9BfbY3Mt8zZsVJtLzL0N5
2CBFr+t6zs+u8Hb/uuTYoAf1FAFqixmhzZXgUBFdcbKv3NhrK1p+FCj25ojUS0dV
NsYtO+oXUecdxTQ2fr3brzAqjkT7SPLw8BEAf5jy7N9uJv1W8GW9kvdrOuuMdyYi
q74VoHWd6xjobzPyrKw4osSnPLo4LPhXJWQJ177i/RsNDCenQPbeST0tlUKSGI26
AGMppwyJOUh1jLgcqX3y7GHCPYw2hs3YKq8Ng12NcEies6yo1OT+0DjSMfI/IVpi
uBPq4ssJCWDfQtG6Qj7UQYhSchKMJkoTJD02pn+vsNpaAVbyJ0aElFl8pmS460VL
aSN7YWTx1MaWlrY7Z1Hgaac4xuVs2dWnWeQs6OpH6h+obiTQ6vcSzIDiHXROQy6l
8Ta3L/gCdFTgLg4YIX8vEIq/ghyAMfpGjr8EKVMk451PDWqm+j/aDqp8IjTqCVLM
Jj211ze3eSmM906Ds8Lz
=x00n
-----END PGP SIGNATURE-----

--j+MD90OnwjQyWNYt--
