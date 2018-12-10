Return-Path: <SRS0=Hr0N=OT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88927C04EB8
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 21:45:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F9EE20855
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 21:45:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amarulasolutions.com header.i=@amarulasolutions.com header.b="ov3oLr17"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2F9EE20855
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=amarulasolutions.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728483AbeLJVpR (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 10 Dec 2018 16:45:17 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50252 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727868AbeLJVpR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Dec 2018 16:45:17 -0500
Received: by mail-wm1-f65.google.com with SMTP id n190so189905wmd.0
        for <linux-media@vger.kernel.org>; Mon, 10 Dec 2018 13:45:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+Z4cJNoUDdc4GPxswmj6JsPzEmpLOhjva3HgqoYU28o=;
        b=ov3oLr178GAc65keIkipFB3wQNL9ciYd02Xuww2EJDHQzve8gSIHiNq6zG1XHy4v/1
         jWNFFIs2HVtScTGluIFmlGJECpxr03MsvrqvCJe4KyuDjEeQG04zI14gXxDF611TAFy5
         1/kPduDO6MAK99C2aGqm+7o0jLV3iboBTWZ6g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+Z4cJNoUDdc4GPxswmj6JsPzEmpLOhjva3HgqoYU28o=;
        b=TF46FP/LyCHVCey+SH6TLNbI0Ka9Wu1IPzo7rNpoHfEEgvGrjAUhxPktkNuokMFg0y
         Ll1vghEz7UrYDNVW6SJWTMyL0KSo3fpjj0mWLI9EgznF2H/jmtNEz9HUnQBaX+ymepyu
         PFlq38ltSaZzo5svqksX5htvvM8HVvuoW9edg4SdsZnMwLkRxapJo4krTyxPvNSqKcYV
         eMRsriBh+wZGYLaWkqShTHuLBz2rLJRz2ncv7zR2Kl4KsK44avnMPy8fQw11y6K1piiN
         Zl2PG6dhtAPNIQYC/TffOAvrly1GrlUe0UIABFySTE+Pb/2pzJ2RUcr3zRAcXhJfwKCw
         7lvg==
X-Gm-Message-State: AA+aEWZ5//qLFiNI/B9xGzhKJFUjkx8bbj9xU38k2SPqMg5DGSfZw17M
        8elTgnU/TRTQsWPErnASdC/Y979Mwg5LvzOW/JHzRYr/
X-Google-Smtp-Source: AFSGD/VkT/aYmFkffulAZbBBVN0AS4Ef6keGWyInndG3R1xQ+mC6QpuM462QHY5UKF7Wx4c1XqiOibvaexpXrGu1qdk=
X-Received: by 2002:a1c:b456:: with SMTP id d83mr58223wmf.115.1544478314321;
 Mon, 10 Dec 2018 13:45:14 -0800 (PST)
MIME-Version: 1.0
References: <CAMty3ZAa2_o87YJ=1iak-o-rfZjoYz7PKXM9uGrbHsh6JLOCWw@mail.gmail.com>
 <850c2502-217c-a9f0-b433-0cd26d0419fd@xs4all.nl> <CAOf5uwkirwRPk3=w1fONLrOpwNqGiJbhh6okDmOTWyKWvW+U1w@mail.gmail.com>
 <CAOf5uw=d6D4FGZp8iWKdA1+77ZQtkNZwbJStmO+L-NtW4gqfaA@mail.gmail.com> <20181209193912.GC12193@w540>
In-Reply-To: <20181209193912.GC12193@w540>
From:   Michael Nazzareno Trimarchi <michael@amarulasolutions.com>
Date:   Mon, 10 Dec 2018 22:45:02 +0100
Message-ID: <CAOf5uwncWDqLsAvQ1H0xN1qQRA_NBt=m2Ncuz_3_nCRhFptpAw@mail.gmail.com>
Subject: Re: Configure video PAL decoder into media pipeline
To:     jacopo@jmondi.org
Cc:     hverkuil@xs4all.nl, Jagan Teki <jagan@amarulasolutions.com>,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Philipp Zabel <p.zabel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Jacopo

Let's see what I have done

On Sun, Dec 9, 2018 at 8:39 PM jacopo mondi <jacopo@jmondi.org> wrote:
>
> Hi Michael, Jagan, Hans,
>
> On Sat, Dec 08, 2018 at 06:07:04PM +0100, Michael Nazzareno Trimarchi wrote:
> > Hi
> >
> > Down you have my tentative of connection
> >
> > I need to hack a bit to have tuner registered. I'm using imx-media
> >
> > On Sat, Dec 8, 2018 at 12:48 PM Michael Nazzareno Trimarchi
> > <michael@amarulasolutions.com> wrote:
> > >
> > > Hi
> > >
> > > On Fri, Dec 7, 2018 at 1:11 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > > >
> > > > On 12/07/2018 12:51 PM, Jagan Teki wrote:
> > > > > Hi,
> > > > >
> > > > > We have some unconventional setup for parallel CSI design where analog
> > > > > input data is converted into to digital composite using PAL decoder
> > > > > and it feed to adv7180, camera sensor.
> > > > >
> > > > > Analog input =>  Video PAL Decoder => ADV7180 => IPU-CSI0
> > > >
> > > > Just PAL? No NTSC support?
> > > >
> > > For now does not matter. I have registere the TUNER that support it
> > > but seems that media-ctl is not suppose to work with the MEDIA_ENT_F_TUNER
> > >
> > > Is this correct?
> > >
>
> media-types.rst reports:
>
>     *  -  ``MEDIA_ENT_F_IF_VID_DECODER``
>        -  IF-PLL video decoder. It receives the IF from a PLL and decodes
>           the analog TV video signal. This is commonly found on some very
>           old analog tuners, like Philips MK3 designs. They all contain a
>           tda9887 (or some software compatible similar chip, like tda9885).
>           Those devices use a different I2C address than the tuner PLL.
>
> Is this what you were looking for?
>
> > > > >
> > > > > The PAL decoder is I2C based, tda9885 chip. We setup it up via dt
> > > > > bindings and the chip is
> > > > > detected fine.
> > > > >
> > > > > But we need to know, is this to be part of media control subdev
> > > > > pipeline? so-that we can configure pads, links like what we do on
> > > > > conventional pipeline  or it should not to be part of media pipeline?
> > > >
> > > > Yes, I would say it should be part of the pipeline.
> > > >
> > >
> > > Ok I have created a draft patch to add the adv some new endpoint but
> > > is sufficient to declare tuner type in media control?
> > >
> > > Michael
> > >
> > > > >
> > > > > Please advise for best possible way to fit this into the design.
> > > > >
> > > > > Another observation is since the IPU has more than one sink, source
> > > > > pads, we source or sink the other components on the pipeline but look
> > > > > like the same thing seems not possible with adv7180 since if has only
> > > > > one pad. If it has only one pad sourcing to adv7180 from tda9885 seems
> > > > > not possible, If I'm not mistaken.
> > > >
> > > > Correct, in all cases where the adv7180 is used it is directly connected
> > > > to the video input connector on a board.
> > > >
> > > > So to support this the adv7180 driver should be modified to add an input pad
> > > > so you can connect the decoder. It will be needed at some point anyway once
> > > > we add support for connector entities.
> > > >
> > > > Regards,
> > > >
> > > >         Hans
> > > >
> > > > >
> > > > > I tried to look for similar design in mainline, but I couldn't find
> > > > > it. is there any design similar to this in mainline?
> > > > >
> > > > > Please let us know if anyone has any suggestions on this.
> > > > >
> >
> > [    3.379129] imx-media: ipu1_vdic:2 -> ipu1_ic_prp:0
> > [    3.384262] imx-media: ipu2_vdic:2 -> ipu2_ic_prp:0
> > [    3.389217] imx-media: ipu1_ic_prp:1 -> ipu1_ic_prpenc:0
> > [    3.394616] imx-media: ipu1_ic_prp:2 -> ipu1_ic_prpvf:0
> > [    3.399867] imx-media: ipu2_ic_prp:1 -> ipu2_ic_prpenc:0
> > [    3.405289] imx-media: ipu2_ic_prp:2 -> ipu2_ic_prpvf:0
> > [    3.410552] imx-media: ipu1_csi0:1 -> ipu1_ic_prp:0
> > [    3.415502] imx-media: ipu1_csi0:1 -> ipu1_vdic:0
> > [    3.420305] imx-media: ipu1_csi0_mux:5 -> ipu1_csi0:0
> > [    3.425427] imx-media: ipu1_csi1:1 -> ipu1_ic_prp:0
> > [    3.430328] imx-media: ipu1_csi1:1 -> ipu1_vdic:0
> > [    3.435142] imx-media: ipu1_csi1_mux:5 -> ipu1_csi1:0
> > [    3.440321] imx-media: adv7180 2-0020:1 -> ipu1_csi0_mux:4
> >
> > with
> >        tuner: tuner@43 {
> >                 compatible = "tuner";
> >                 reg = <0x43>;
> >                 pinctrl-names = "default";
> >                 pinctrl-0 = <&pinctrl_tuner>;
> >
> >                 ports {
> >                         #address-cells = <1>;
> >                         #size-cells = <0>;
> >                         port@1 {
> >                                 reg = <1>;
> >
> >                                 tuner_in: endpoint {
>
> Nit: This is the tuner output, I would call this "tuner_out"
>

Done

> >                                         remote-endpoint = <&tuner_out>;
> >                                 };
> >                         };
> >                 };
> >         };
> >
> >         adv7180: camera@20 {
> >                 compatible = "adi,adv7180";
>
> One minor thing first: look at the adv7180 bindings documentation, and
> you'll find out that only devices compatible with "adv7180cp" and
> "adv7180st" shall declare a 'ports' node. This is minor issues (also,
> I don't see it enforced in driver's code, but still worth pointing it
> out from the very beginning)
>
> >                 reg = <0x20>;
> >                 pinctrl-names = "default";
> >                 pinctrl-0 = <&pinctrl_adv7180>;
> >                 powerdown-gpios = <&gpio3 20 GPIO_ACTIVE_LOW>; /* PDEC_PWRDN */
> >
> >                 ports {
> >                         #address-cells = <1>;
> >                         #size-cells = <0>;
> >
> >                         port@1 {
> >                                 reg = <1>;
> >
> >                                 adv7180_to_ipu1_csi0_mux: endpoint {
> >                                         remote-endpoint =
> > <&ipu1_csi0_mux_from_parallel_sensor>;
> >                                         bus-width = <8>;
> >                                 };
> >                         };
> >
> >                         port@0 {
> >                                 reg = <0>;
> >
> >                                 tuner_out: endpoint {
>
> Nit: That's an adv7180 endpoint, I would call it 'adv7180_in'
>

Done

> >                                         remote-endpoint = <&tuner_in>;
> >                                 };
> >                         };
> >                 };
> >         };
> >
> > Any help is appreciate
> >
>
> The adv7180(cp|st) bindings says the device can declare one (or more)
> input endpoints, but that's just to make possible to connect in device
> tree the 7180's device node with the video input port. You can see an
> example in arch/arm64/boot/dts/renesas/r8a77995-draak.dts which is
> similar to what you've done here.
>
> The video input port does not show up in the media graph, as it is
> just a 'place holder' to describe an input port in DTs, the
> adv7180 driver does not register any sink pad, where to connect any
> video source to.
>
> Your proposed bindings here look almost correct, but to have it
> working for real you should add a sink pad to the adv7180 registered
> media entity (possibly only conditionally to the presence of an input
> endpoint in DTs...). You should then register a subdev-notifier, which
> registers on an async-subdevice that uses the remote endpoint
> connected to your newly registered input pad to find out which device
> you're linked to; then at 'bound' (or possibly 'complete') time
> register a link between the two entities, on which you can operate on
> from userspace.
>
> Your tuner driver for tda9885 (which I don't see in mainline, so I
> assume it's downstream or custom code) should register an async subdevice,
> so that the adv7180 registered subdev-notifier gets matched and your
> callbacks invoked.
>
> If I were you, I would:
> 1) Add dt-parsing routine to tda7180, to find out if any input
> endpoint is registered in DT.

Done

> 2) If it is, then register a SINK pad, along with the single SOURCE pad
> which is registered today.

Done

> 3) When parsing DT, for input endpoints, get a reference to the remote
> endpoint connected to your input and register a subdev-notifier

Done

> 4) Fill in the notifier 'bound' callback and register the link to
> your remote device there.

Both are subdevice that has not a v4l2_device, so bound is not called from two
sub-device. Is this expected?


> 5) Make sure your tuner driver registers its subdevice with
> v4l2_async_register_subdev()
>
> A good example on how to register subdev notifier is provided in the
> rcsi2_parse_dt() function in rcar-csi2.c driver (I'm quite sure imx
> now uses subdev notifiers from v4.19 on too if you want to have a look
> there).

Already seen it

>
> -- Entering slippery territory here: you might want more inputs on this
>
> To make thing simpler&nicer (TM), if you blindly do what I've suggested
> here, you're going to break all current adv7180 users in mainline :(
>
> That's because the v4l2-async design 'completes' the root notifier,
> only if all subdev-notifiers connected to it have completed first.
> If you add a notifier for the adv7180 input ports unconditionally, and

I don't get to complete. So let's proceed by step

Michael

> to the input port is connected a plain simple "composite-video-connector",
> as all DTs in mainline are doing right now, the newly registered
> subdev-notifier will never complete, as the "composite-video-connector"
> does not register any subdevice to match with. Bummer!
>
> A quick look in the code base, returns me that, in example:
> drivers/gpu/drm/meson/meson_drv.c filters on
> "composite-video-connector" and a few other compatible values. You
> might want to do the same, and register a notifier if and only if the
> remote input endpoint is one of those known not to register a
> subdevice. I'm sure there are other ways to deal with this issue, but
> that's the best I can come up with...
> ---
>
> Hope this is reasonably clear and that I'm not misleading you. I had to
> use adv7180 recently, and its single pad design confused me a bit as well :)
>
> Thanks
>   j
>
> > Michael
> >
> > > > > Jagan.
> > > > >
> > > >
> > >
> > >
> > > --



-- 
| Michael Nazzareno Trimarchi                     Amarula Solutions BV |
| COO  -  Founder                                      Cruquiuskade 47 |
| +31(0)851119172                                 Amsterdam 1018 AM NL |
|                  [`as] http://www.amarulasolutions.com               |
