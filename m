Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor3.renesas.com ([210.160.252.173]:19994 "EHLO
        relmlie2.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752860AbeBELmS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Feb 2018 06:42:18 -0500
From: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
To: Maxime Ripard <maxime.ripard@bootlin.com>
CC: Hugues Fruchet <hugues.fruchet@st.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "Sakari Ailus" <sakari.ailus@iki.fi>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: RE: [PATCH v5 4/5] media: ov5640: add support of DVP parallel
 interface
Date: Mon, 5 Feb 2018 11:42:11 +0000
Message-ID: <TY1PR06MB08954787E362BF24C7FD41DBC0FE0@TY1PR06MB0895.apcprd06.prod.outlook.com>
References: <1514973452-10464-1-git-send-email-hugues.fruchet@st.com>
 <1514973452-10464-5-git-send-email-hugues.fruchet@st.com>
 <TY1PR06MB089512437228BAFF910B133FC0FA0@TY1PR06MB0895.apcprd06.prod.outlook.com>
 <20180202185045.vvhmj5wtagalkucf@flea.lan>
In-Reply-To: <20180202185045.vvhmj5wtagalkucf@flea.lan>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Maxime,

thank you for your feedback.

> > > +/*
> > > + * configure parallel port control lines polarity
> > > + *
> > > + * POLARITY CTRL0
> > > + * - [5]:PCLK polarity (0: active low, 1: active high)
> > > + * - [1]:HREF polarity (0: active low, 1: active high)
> > > + * - [0]:VSYNC polarity (mismatch here between
> > > + *datasheet and hardware, 0 is active high
> > > + *and 1 is active low...)
> >
> > I know that yourself and Maxime have both confirmed that VSYNC
> > polarity is inverted, but I am looking at HSYNC and VSYNC with a
> > logic analyser and I am dumping the values written to
> > OV5640_REG_POLARITY_CTRL00 and to me it looks like that HSYNC is
> > active HIGH when hsync_pol =3D=3D 0, and VSYNC is active HIGH when
> > vsync_pol =3D=3D 1.
>
> Which mode are you testing this on?

My testing environment is made of the sensor connected to a SoC with 8 data=
 lines, vsync, hsync, and pclk, and of course I am specifying hsync-active,=
 vsync-active, and pclk-sample in the device tree on both ends so that they=
 configure themselves accordingly to work in DVP mode (V4L2_MBUS_PARALLEL),=
 with the correct polarities.
Between the sensor and the SoC there is a noninverting bus transceiver (vol=
tage translator), for my experiments I have plugged myself onto the outputs=
 of this transceiver only to be compliant with the voltage level of my logi=
c analyser.

>
> The non-active periods are insanely high in most modes (1896 for an
> active horizontal length of 640 in 640x480 for example), especially
> hsync, and it's really easy to invert the two.

I am looking at all the data lines, so that I don't confuse the non-active =
periods with the active periods, and with my setup what I reported is what =
I get. I wonder if this difference comes from the sensor revision at all? U=
nfortunately I can only test the one camera I have got.

Thanks,
Fab

>
> Maxime
>
> --
> Maxime Ripard, Bootlin (formerly Free Electrons)
> Embedded Linux and Kernel engineering
> http://bootlin.com



Renesas Electronics Europe Ltd, Dukes Meadow, Millboard Road, Bourne End, B=
uckinghamshire, SL8 5FH, UK. Registered in England & Wales under Registered=
 No. 04586709.
