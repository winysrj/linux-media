Return-Path: <SRS0=2Dg0=OV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,T_MIXED_ES,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A841C04EB8
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 08:55:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0285E2084E
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 08:55:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0285E2084E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=jmondi.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726625AbeLLIzF (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 12 Dec 2018 03:55:05 -0500
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:58059 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726242AbeLLIzF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Dec 2018 03:55:05 -0500
X-Originating-IP: 2.224.242.101
Received: from w540 (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id 25A02C000B;
        Wed, 12 Dec 2018 08:54:58 +0000 (UTC)
Date:   Wed, 12 Dec 2018 09:54:57 +0100
From:   jacopo mondi <jacopo@jmondi.org>
To:     Michael Nazzareno Trimarchi <michael@amarulasolutions.com>
Cc:     hverkuil@xs4all.nl, Jagan Teki <jagan@amarulasolutions.com>,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: Re: Configure video PAL decoder into media pipeline
Message-ID: <20181212085457.GO5597@w540>
References: <CAMty3ZAa2_o87YJ=1iak-o-rfZjoYz7PKXM9uGrbHsh6JLOCWw@mail.gmail.com>
 <850c2502-217c-a9f0-b433-0cd26d0419fd@xs4all.nl>
 <CAOf5uwkirwRPk3=w1fONLrOpwNqGiJbhh6okDmOTWyKWvW+U1w@mail.gmail.com>
 <CAOf5uw=d6D4FGZp8iWKdA1+77ZQtkNZwbJStmO+L-NtW4gqfaA@mail.gmail.com>
 <20181209193912.GC12193@w540>
 <CAOf5uwncWDqLsAvQ1H0xN1qQRA_NBt=m2Ncuz_3_nCRhFptpAw@mail.gmail.com>
 <20181211113912.GI5597@w540>
 <CAOf5uwk0U0BA2vDB1=_Uay30cgtfGuWOm8339jsAwn+O78ZnFA@mail.gmail.com>
 <20181212083934.GM5597@w540>
 <CAOf5uw=toowCCR9hEA13+qKPPrZTaOgjCCxoWXwgc5x4TnQ_Xg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="NDuspjMMC1Ui5ypn"
Content-Disposition: inline
In-Reply-To: <CAOf5uw=toowCCR9hEA13+qKPPrZTaOgjCCxoWXwgc5x4TnQ_Xg@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--NDuspjMMC1Ui5ypn
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Wed, Dec 12, 2018 at 09:43:23AM +0100, Michael Nazzareno Trimarchi wrote:
> Hi
>
> On Wed, Dec 12, 2018 at 9:39 AM jacopo mondi <jacopo@jmondi.org> wrote:
> >
> > Hi Michael,
> >
> > On Tue, Dec 11, 2018 at 02:53:24PM +0100, Michael Nazzareno Trimarchi wrote:
> > > Hi Jacopo
> > >
> > > On Tue, Dec 11, 2018 at 12:39 PM jacopo mondi <jacopo@jmondi.org> wrote:
> > > >
> > > > Hi Michael,
> > > >
> > > > On Mon, Dec 10, 2018 at 10:45:02PM +0100, Michael Nazzareno Trimarchi wrote:
> > > > > Hi Jacopo
> > > > >
> > > > > Let's see what I have done
> > > > >
> > > > > On Sun, Dec 9, 2018 at 8:39 PM jacopo mondi <jacopo@jmondi.org> wrote:
> > > > > >
> > > > > > Hi Michael, Jagan, Hans,
> > > > > >
>
> media-ctl --links "'tda9887':1->'adv7180 2-0020':1[1]"

According to what you pasted below, this is a source->source link,
which you don't need as you already have
"'tda9887':1->'adv7180 2-0020':0"
enabled and immutable (I would question the immutable, but that's ok
for now)

 - entity 80: adv7180 2-0020 (2 pads, 5 links)
              type V4L2 subdev subtype Decoder flags 0
              device node name /dev/v4l-subdev11
 pad0: Sink
 [fmt:UYVY8_2X8/720x240@1001/30000 field:alternate colorspace:smpte170m]
 <- "ipu1_csi0_mux":4 []                  <--- THIS shouldn't be here
 -> "ipu1_csi0_mux":4 []                  <--- THIS shouldn't be here
 <- "tda9887":1 [ENABLED,IMMUTABLE]
 pad1: Source
 [fmt:UYVY8_2X8/720x240@1001/30000 field:alternate colorspace:smpte170m]
 -> "tda9887":1 []                  <--- THIS shouldn't be here
 <- "tda9887":1 []                  <--- THIS shouldn't be here

 - entity 83: tda9887 (2 pads, 3 links)
              type V4L2 subdev subtype Unknown flags 0
 pad0: Sink
 pad1: Source
 <- "adv7180 2-0020":1 []                  <--- THIS shouldn't be here
 -> "adv7180 2-0020":0 [ENABLED,IMMUTABLE]
 -> "adv7180 2-0020":1 []                  <--- THIS shouldn't be here

So fix your DTS, or your parsing routines, the media graph should look
like

 - entity 80: adv7180 2-0020 (2 pads, 5 links)
              type V4L2 subdev subtype Decoder flags 0
              device node name /dev/v4l-subdev11
 pad0: Sink
 [fmt:UYVY8_2X8/720x240@1001/30000 field:alternate colorspace:smpte170m]
 <- "tda9887":1 [ENABLED,IMMUTABLE]
 pad1: Source
 [fmt:UYVY8_2X8/720x240@1001/30000 field:alternate colorspace:smpte170m]
 -> "ipu1_csi0_mux":4 []

 - entity 83: tda9887 (2 pads, 3 links)
              type V4L2 subdev subtype Unknown flags 0
 pad0: Sink
 pad1: Source
 -> "adv7180 2-0020":0 [ENABLED,IMMUTABLE]

Thanks
   j

> media-ctl --links "'adv7180 2-0020':0->'ipu1_csi0_mux':4[1]"
> media-ctl --links "'ipu1_csi0_mux':5->'ipu1_csi0':0[1]"
> media-ctl --links "'ipu1_csi0':1->'ipu1_vdic':0[1]"
> media-ctl --links "'ipu1_vdic':2->'ipu1_ic_prp':0[1]"
> media-ctl -l "'ipu1_ic_prp':2 -> 'ipu1_ic_prpvf':0[1]"
> media-ctl -l "'ipu1_ic_prpvf':1 -> 'ipu1_ic_prpvf capture':0[1]"
>
> If I try to activate this one or any other go to the end, it's just dealock.
>
> Michael
>
> > > > > > On Sat, Dec 08, 2018 at 06:07:04PM +0100, Michael Nazzareno Trimarchi wrote:
> > > > > > > Hi
> > > > > > >
> > > > > > > Down you have my tentative of connection
> > > > > > >
> > > > > > > I need to hack a bit to have tuner registered. I'm using imx-media
> > > > > > >
> > > > > > > On Sat, Dec 8, 2018 at 12:48 PM Michael Nazzareno Trimarchi
> > > > > > > <michael@amarulasolutions.com> wrote:
> > > > > > > >
> > > > > > > > Hi
> > > > > > > >
> > > > > > > > On Fri, Dec 7, 2018 at 1:11 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > > > > > > > >
> > > > > > > > > On 12/07/2018 12:51 PM, Jagan Teki wrote:
> > > > > > > > > > Hi,
> > > > > > > > > >
> > > > > > > > > > We have some unconventional setup for parallel CSI design where analog
> > > > > > > > > > input data is converted into to digital composite using PAL decoder
> > > > > > > > > > and it feed to adv7180, camera sensor.
> > > > > > > > > >
> > > > > > > > > > Analog input =>  Video PAL Decoder => ADV7180 => IPU-CSI0
> > > > > > > > >
> > > > > > > > > Just PAL? No NTSC support?
> > > > > > > > >
> > > > > > > > For now does not matter. I have registere the TUNER that support it
> > > > > > > > but seems that media-ctl is not suppose to work with the MEDIA_ENT_F_TUNER
> > > > > > > >
> > > > > > > > Is this correct?
> > > > > > > >
> > > > > >
> > > > > > media-types.rst reports:
> > > > > >
> > > > > >     *  -  ``MEDIA_ENT_F_IF_VID_DECODER``
> > > > > >        -  IF-PLL video decoder. It receives the IF from a PLL and decodes
> > > > > >           the analog TV video signal. This is commonly found on some very
> > > > > >           old analog tuners, like Philips MK3 designs. They all contain a
> > > > > >           tda9887 (or some software compatible similar chip, like tda9885).
> > > > > >           Those devices use a different I2C address than the tuner PLL.
> > > > > >
> > > > > > Is this what you were looking for?
> > > > > >
> > > > > > > > > >
> > > > > > > > > > The PAL decoder is I2C based, tda9885 chip. We setup it up via dt
> > > > > > > > > > bindings and the chip is
> > > > > > > > > > detected fine.
> > > > > > > > > >
> > > > > > > > > > But we need to know, is this to be part of media control subdev
> > > > > > > > > > pipeline? so-that we can configure pads, links like what we do on
> > > > > > > > > > conventional pipeline  or it should not to be part of media pipeline?
> > > > > > > > >
> > > > > > > > > Yes, I would say it should be part of the pipeline.
> > > > > > > > >
> > > > > > > >
> > > > > > > > Ok I have created a draft patch to add the adv some new endpoint but
> > > > > > > > is sufficient to declare tuner type in media control?
> > > > > > > >
> > > > > > > > Michael
> > > > > > > >
> > > > > > > > > >
> > > > > > > > > > Please advise for best possible way to fit this into the design.
> > > > > > > > > >
> > > > > > > > > > Another observation is since the IPU has more than one sink, source
> > > > > > > > > > pads, we source or sink the other components on the pipeline but look
> > > > > > > > > > like the same thing seems not possible with adv7180 since if has only
> > > > > > > > > > one pad. If it has only one pad sourcing to adv7180 from tda9885 seems
> > > > > > > > > > not possible, If I'm not mistaken.
> > > > > > > > >
> > > > > > > > > Correct, in all cases where the adv7180 is used it is directly connected
> > > > > > > > > to the video input connector on a board.
> > > > > > > > >
> > > > > > > > > So to support this the adv7180 driver should be modified to add an input pad
> > > > > > > > > so you can connect the decoder. It will be needed at some point anyway once
> > > > > > > > > we add support for connector entities.
> > > > > > > > >
> > > > > > > > > Regards,
> > > > > > > > >
> > > > > > > > >         Hans
> > > > > > > > >
> > > > > > > > > >
> > > > > > > > > > I tried to look for similar design in mainline, but I couldn't find
> > > > > > > > > > it. is there any design similar to this in mainline?
> > > > > > > > > >
> > > > > > > > > > Please let us know if anyone has any suggestions on this.
> > > > > > > > > >
> > > > > > >
> > > > > > > [    3.379129] imx-media: ipu1_vdic:2 -> ipu1_ic_prp:0
> > > > > > > [    3.384262] imx-media: ipu2_vdic:2 -> ipu2_ic_prp:0
> > > > > > > [    3.389217] imx-media: ipu1_ic_prp:1 -> ipu1_ic_prpenc:0
> > > > > > > [    3.394616] imx-media: ipu1_ic_prp:2 -> ipu1_ic_prpvf:0
> > > > > > > [    3.399867] imx-media: ipu2_ic_prp:1 -> ipu2_ic_prpenc:0
> > > > > > > [    3.405289] imx-media: ipu2_ic_prp:2 -> ipu2_ic_prpvf:0
> > > > > > > [    3.410552] imx-media: ipu1_csi0:1 -> ipu1_ic_prp:0
> > > > > > > [    3.415502] imx-media: ipu1_csi0:1 -> ipu1_vdic:0
> > > > > > > [    3.420305] imx-media: ipu1_csi0_mux:5 -> ipu1_csi0:0
> > > > > > > [    3.425427] imx-media: ipu1_csi1:1 -> ipu1_ic_prp:0
> > > > > > > [    3.430328] imx-media: ipu1_csi1:1 -> ipu1_vdic:0
> > > > > > > [    3.435142] imx-media: ipu1_csi1_mux:5 -> ipu1_csi1:0
> > > > > > > [    3.440321] imx-media: adv7180 2-0020:1 -> ipu1_csi0_mux:4
> > > > > > >
> > > > > > > with
> > > > > > >        tuner: tuner@43 {
> > > > > > >                 compatible = "tuner";
> > > > > > >                 reg = <0x43>;
> > > > > > >                 pinctrl-names = "default";
> > > > > > >                 pinctrl-0 = <&pinctrl_tuner>;
> > > > > > >
> > > > > > >                 ports {
> > > > > > >                         #address-cells = <1>;
> > > > > > >                         #size-cells = <0>;
> > > > > > >                         port@1 {
> > > > > > >                                 reg = <1>;
> > > > > > >
> > > > > > >                                 tuner_in: endpoint {
> > > > > >
> > > > > > Nit: This is the tuner output, I would call this "tuner_out"
> > > > > >
> > > > >
> > > > > Done
> > > > >
> > > > > > >                                         remote-endpoint = <&tuner_out>;
> > > > > > >                                 };
> > > > > > >                         };
> > > > > > >                 };
> > > > > > >         };
> > > > > > >
> > > > > > >         adv7180: camera@20 {
> > > > > > >                 compatible = "adi,adv7180";
> > > > > >
> > > > > > One minor thing first: look at the adv7180 bindings documentation, and
> > > > > > you'll find out that only devices compatible with "adv7180cp" and
> > > > > > "adv7180st" shall declare a 'ports' node. This is minor issues (also,
> > > > > > I don't see it enforced in driver's code, but still worth pointing it
> > > > > > out from the very beginning)
> > > > > >
> > > > > > >                 reg = <0x20>;
> > > > > > >                 pinctrl-names = "default";
> > > > > > >                 pinctrl-0 = <&pinctrl_adv7180>;
> > > > > > >                 powerdown-gpios = <&gpio3 20 GPIO_ACTIVE_LOW>; /* PDEC_PWRDN */
> > > > > > >
> > > > > > >                 ports {
> > > > > > >                         #address-cells = <1>;
> > > > > > >                         #size-cells = <0>;
> > > > > > >
> > > > > > >                         port@1 {
> > > > > > >                                 reg = <1>;
> > > > > > >
> > > > > > >                                 adv7180_to_ipu1_csi0_mux: endpoint {
> > > > > > >                                         remote-endpoint =
> > > > > > > <&ipu1_csi0_mux_from_parallel_sensor>;
> > > > > > >                                         bus-width = <8>;
> > > > > > >                                 };
> > > > > > >                         };
> > > > > > >
> > > > > > >                         port@0 {
> > > > > > >                                 reg = <0>;
> > > > > > >
> > > > > > >                                 tuner_out: endpoint {
> > > > > >
> > > > > > Nit: That's an adv7180 endpoint, I would call it 'adv7180_in'
> > > > > >
> > > > >
> > > > > Done
> > > > >
> > > > > > >                                         remote-endpoint = <&tuner_in>;
> > > > > > >                                 };
> > > > > > >                         };
> > > > > > >                 };
> > > > > > >         };
> > > > > > >
> > > > > > > Any help is appreciate
> > > > > > >
> > > > > >
> > > > > > The adv7180(cp|st) bindings says the device can declare one (or more)
> > > > > > input endpoints, but that's just to make possible to connect in device
> > > > > > tree the 7180's device node with the video input port. You can see an
> > > > > > example in arch/arm64/boot/dts/renesas/r8a77995-draak.dts which is
> > > > > > similar to what you've done here.
> > > > > >
> > > > > > The video input port does not show up in the media graph, as it is
> > > > > > just a 'place holder' to describe an input port in DTs, the
> > > > > > adv7180 driver does not register any sink pad, where to connect any
> > > > > > video source to.
> > > > > >
> > > > > > Your proposed bindings here look almost correct, but to have it
> > > > > > working for real you should add a sink pad to the adv7180 registered
> > > > > > media entity (possibly only conditionally to the presence of an input
> > > > > > endpoint in DTs...). You should then register a subdev-notifier, which
> > > > > > registers on an async-subdevice that uses the remote endpoint
> > > > > > connected to your newly registered input pad to find out which device
> > > > > > you're linked to; then at 'bound' (or possibly 'complete') time
> > > > > > register a link between the two entities, on which you can operate on
> > > > > > from userspace.
> > > > > >
> > > > > > Your tuner driver for tda9885 (which I don't see in mainline, so I
> > > > > > assume it's downstream or custom code) should register an async subdevice,
> > > > > > so that the adv7180 registered subdev-notifier gets matched and your
> > > > > > callbacks invoked.
> > > > > >
> > > > > > If I were you, I would:
> > > > > > 1) Add dt-parsing routine to tda7180, to find out if any input
> > > > > > endpoint is registered in DT.
> > > > >
> > > > > Done
> > > > >
> > > > > > 2) If it is, then register a SINK pad, along with the single SOURCE pad
> > > > > > which is registered today.
> > > > >
> > > > > Done
> > > > >
> > > > > > 3) When parsing DT, for input endpoints, get a reference to the remote
> > > > > > endpoint connected to your input and register a subdev-notifier
> > > > >
> > > > > Done
> > > > >
> > > > > > 4) Fill in the notifier 'bound' callback and register the link to
> > > > > > your remote device there.
> > > > >
> > > > > Both are subdevice that has not a v4l2_device, so bound is not called from two
> > > > > sub-device. Is this expected?
> > > >
> > > > That should not be an issue. As we discussed, I slightly misleaded
> > > > you, pointing you to rcar-csi2, which implements a 'custom' matching
> > > > logic, trying to match its remote on endpoints and not on device node.
> > > >
> > > >         priv->asd.match.fwnode =
> > > >                 fwnode_graph_get_remote_endpoint(of_fwnode_handle(ep));
> > > >
> > > > I'm sorry about this.
> > > >
> > > > You better use something like:
> > > >
> > > >         asd->match.fwnode =
> > > >                 fwnode_graph_get_remote_port_parent(endpoint);
> > > >
> > > > or the recently introduced 'v4l2_async_notifier_parse_fwnode_endpoints_by_port()'
> > > > function, that does most of that for you.
> > > >
> > >
> > > - entity 80: adv7180 2-0020 (2 pads, 5 links)
> > >              type V4L2 subdev subtype Decoder flags 0
> > >              device node name /dev/v4l-subdev11
> > > pad0: Sink
> > > [fmt:UYVY8_2X8/720x240@1001/30000 field:alternate colorspace:smpte170m]
> > > <- "ipu1_csi0_mux":4 []
> > > -> "ipu1_csi0_mux":4 []
> > > <- "tda9887":1 [ENABLED,IMMUTABLE]
> > > pad1: Source
> > > [fmt:UYVY8_2X8/720x240@1001/30000 field:alternate colorspace:smpte170m]
> > > -> "tda9887":1 []
> > > <- "tda9887":1 []
> > >
> > > - entity 83: tda9887 (2 pads, 3 links)
> > >              type V4L2 subdev subtype Unknown flags 0
> > > pad0: Sink
> > > pad1: Source
> > > <- "adv7180 2-0020":1 []
> > > -> "adv7180 2-0020":0 [ENABLED,IMMUTABLE]
> > > -> "adv7180 2-0020":1 []
> > >
> > >
> > > Now the only problem is that I have a link in the graph that I have
> > > not defined that not le me to stream. Look and png file I can see an
> > > hard link from tda9887 to csi. Do you know why is coming?
> > >
> >
> > I don't see any link between tda and csi in the snippet you pasted
> > above (nor I see a .png representing the media graph attached).
> >
> > What I see is the link: '"adv7180 2-0020":0 -> "tda9887":1' which is
> > fine, but you're missing a link '"adv7180 2-0020":1 -> "ipu1_csi0_mux":4'
> >
> > From what I see your DTS (or parsing routines, I can't tell without
> > the seeing the code) links  adv7180:1->tda9887:1 which is a
> > source->source link, and the same time creates an
> > adv7180:0->ipu1_csi0_mux:4 which is a sink->sink link.
> >
> > If you fix that by creating instead a adv7180:1->ipu1_csi0_mux:4 you
> > should be fine (provided you keep the tda9887:1->adv7180:0 link you have
> > already).
> >
> > If you send patches, we can comment further, otherwise it gets hard
> > without seeing what's happening for real.
> >
> > Thanks
> >    j
> >
> > > Michael
> > >
> > > > Sorry about this.
> > > > Thanks
> > > >    j
> > > >
> > > > >
> > > > >
> > > > > > 5) Make sure your tuner driver registers its subdevice with
> > > > > > v4l2_async_register_subdev()
> > > > > >
> > > > > > A good example on how to register subdev notifier is provided in the
> > > > > > rcsi2_parse_dt() function in rcar-csi2.c driver (I'm quite sure imx
> > > > > > now uses subdev notifiers from v4.19 on too if you want to have a look
> > > > > > there).
> > > > >
> > > > > Already seen it
> > > > >
> > > > > >
> > > > > > -- Entering slippery territory here: you might want more inputs on this
> > > > > >
> > > > > > To make thing simpler&nicer (TM), if you blindly do what I've suggested
> > > > > > here, you're going to break all current adv7180 users in mainline :(
> > > > > >
> > > > > > That's because the v4l2-async design 'completes' the root notifier,
> > > > > > only if all subdev-notifiers connected to it have completed first.
> > > > > > If you add a notifier for the adv7180 input ports unconditionally, and
> > > > >
> > > > > I don't get to complete. So let's proceed by step
> > > > >
> > > > > Michael
> > > > >
> > > > > > to the input port is connected a plain simple "composite-video-connector",
> > > > > > as all DTs in mainline are doing right now, the newly registered
> > > > > > subdev-notifier will never complete, as the "composite-video-connector"
> > > > > > does not register any subdevice to match with. Bummer!
> > > > > >
> > > > > > A quick look in the code base, returns me that, in example:
> > > > > > drivers/gpu/drm/meson/meson_drv.c filters on
> > > > > > "composite-video-connector" and a few other compatible values. You
> > > > > > might want to do the same, and register a notifier if and only if the
> > > > > > remote input endpoint is one of those known not to register a
> > > > > > subdevice. I'm sure there are other ways to deal with this issue, but
> > > > > > that's the best I can come up with...
> > > > > > ---
> > > > > >
> > > > > > Hope this is reasonably clear and that I'm not misleading you. I had to
> > > > > > use adv7180 recently, and its single pad design confused me a bit as well :)
> > > > > >
> > > > > > Thanks
> > > > > >   j
> > > > > >
> > > > > > > Michael
> > > > > > >
> > > > > > > > > > Jagan.
> > > > > > > > > >
> > > > > > > > >
> > > > > > > >
> > > > > > > >
> > > > > > > > --
> > > > >
> > > > >
> > > > >
> > > > > --
> > > > > | Michael Nazzareno Trimarchi                     Amarula Solutions BV |
> > > > > | COO  -  Founder                                      Cruquiuskade 47 |
> > > > > | +31(0)851119172                                 Amsterdam 1018 AM NL |
> > > > > |                  [`as] http://www.amarulasolutions.com               |
> > >
> > >
> > >
> > > --
> > > | Michael Nazzareno Trimarchi                     Amarula Solutions BV |
> > > | COO  -  Founder                                      Cruquiuskade 47 |
> > > | +31(0)851119172                                 Amsterdam 1018 AM NL |
> > > |                  [`as] http://www.amarulasolutions.com               |
>
>
>
> --
> | Michael Nazzareno Trimarchi                     Amarula Solutions BV |
> | COO  -  Founder                                      Cruquiuskade 47 |
> | +31(0)851119172                                 Amsterdam 1018 AM NL |
> |                  [`as] http://www.amarulasolutions.com               |



--NDuspjMMC1Ui5ypn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJcEMzhAAoJEHI0Bo8WoVY8mjIP/0NIgxxWOMk/2DQ7s2gYV1oC
CqsOKJpLRRtKb/E8OXBBB8qB+cN5Dc7UL8LHJUux3meLHvp4vMlgqq/oxIM9RhoD
qEox1W4Y2ISAwE4poS/hr951J3QYtSczad/YPfqanBsexbKULOTCQr+JUQHPGRjf
KvbKRstmBUbpastOu73S9QIDjrlhvTenFPiobWxpw76DhgE1AuwmTnsp5hs1Air+
WdHeoeRLK6IHMPJUjkmW5IeTrRY4pEmzo3D5tiKdPmRh9rCMzZsnkwg1/aVMznJG
2nAHa7BID5iu2I6Sw7r06hipn8S2G4uQCXT7mwz1iFgBX0kSkinPxPwt4wz6azdx
uN/wWSm7zSdhHG4pOhEeqEIuwmSi61MBS8O3enP1+fOYI+2msdOTuBJcLV7pgoAK
1g8pRvf9eqnxl+i6NNUvpXmTpRZSXkscGDMoRYVca2wZEMylRx3XL4ouy/DDAtfv
9A6JDwwqDsbMpC56WBe0YlEpT3ZtLHwERT4P0PldrF6oOhXk80L4lvR7S7qTGWbJ
YI4mTLuwSImaxrIh9fWbythI5+ApiNS8xDqN1qlOGEZGx9iFce3BtP6V8KCZaI79
Oo0f0v6yc4wGuNFogGjqH4x1RzpM7ueo5Max5QPySzM2n+gDt5GaWyinzi1H5b1T
Ab5DZ89dIa8qlCjat5cI
=1XXg
-----END PGP SIGNATURE-----

--NDuspjMMC1Ui5ypn--
