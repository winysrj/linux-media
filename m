Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ed1-f65.google.com ([209.85.208.65]:40674 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729105AbeKVXMy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Nov 2018 18:12:54 -0500
Received: by mail-ed1-f65.google.com with SMTP id d3so7574651edx.7
        for <linux-media@vger.kernel.org>; Thu, 22 Nov 2018 04:33:43 -0800 (PST)
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com. [209.85.221.44])
        by smtp.gmail.com with ESMTPSA id f35sm5102159edd.80.2018.11.22.04.33.41
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Nov 2018 04:33:41 -0800 (PST)
Received: by mail-wr1-f44.google.com with SMTP id j2so9126342wrw.1
        for <linux-media@vger.kernel.org>; Thu, 22 Nov 2018 04:33:41 -0800 (PST)
MIME-Version: 1.0
References: <20181114145934.26855-1-maxime.ripard@bootlin.com>
 <20181114145934.26855-4-maxime.ripard@bootlin.com> <CAMty3ZDFsaFR1zb3Wt0wJ0XkeNuSHGxDsmZZKgWy=wxJpNTnHQ@mail.gmail.com>
In-Reply-To: <CAMty3ZDFsaFR1zb3Wt0wJ0XkeNuSHGxDsmZZKgWy=wxJpNTnHQ@mail.gmail.com>
From: Chen-Yu Tsai <wens@csie.org>
Date: Thu, 22 Nov 2018 20:33:29 +0800
Message-ID: <CAGb2v67dprbvVNtR-ciH+1d1EsmCejmAMBQ_-y-Jb6Z3S11abA@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] ARM: dts: sun8i: Add the H3/H5 CSI controller
To: Jagan Teki <jagan@amarulasolutions.com>
Cc: Maxime Ripard <maxime.ripard@bootlin.com>,
        Yong Deng <yong.deng@magewell.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        =?UTF-8?Q?Myl=C3=A8ne_Josserand?= <mylene.josserand@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 22, 2018 at 7:45 PM Jagan Teki <jagan@amarulasolutions.com> wrote:
>
> On Wed, Nov 14, 2018 at 8:29 PM Maxime Ripard <maxime.ripard@bootlin.com> wrote:
> >
> > From: Mylène Josserand <mylene.josserand@bootlin.com>
> >
> > The H3 and H5 features the same CSI controller that was initially found on
> > the A31.
> >
> > Add a DT node for it.
> >
> > Signed-off-by: Mylène Josserand <mylene.josserand@bootlin.com>
> > Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> > ---
> >  arch/arm/boot/dts/sunxi-h3-h5.dtsi | 22 ++++++++++++++++++++++
> >  1 file changed, 22 insertions(+)
> >
> > diff --git a/arch/arm/boot/dts/sunxi-h3-h5.dtsi b/arch/arm/boot/dts/sunxi-h3-h5.dtsi
> > index 4b1530ebe427..8779ee750bd8 100644
> > --- a/arch/arm/boot/dts/sunxi-h3-h5.dtsi
> > +++ b/arch/arm/boot/dts/sunxi-h3-h5.dtsi
> > @@ -393,6 +393,13 @@
> >                         interrupt-controller;
> >                         #interrupt-cells = <3>;
> >
> > +                       csi_pins: csi {
> > +                               pins = "PE0", "PE1", "PE2", "PE3", "PE4",
> > +                                      "PE5", "PE6", "PE7", "PE8", "PE9",
> > +                                      "PE10", "PE11";
> > +                               function = "csi";
> > +                       };
> > +
> >                         emac_rgmii_pins: emac0 {
> >                                 pins = "PD0", "PD1", "PD2", "PD3", "PD4",
> >                                        "PD5", "PD7", "PD8", "PD9", "PD10",
> > @@ -744,6 +751,21 @@
> >                         interrupts = <GIC_PPI 9 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_HIGH)>;
> >                 };
> >
> > +               csi: camera@1cb0000 {
> > +                       compatible = "allwinner,sun8i-h3-csi",
> > +                                    "allwinner,sun6i-a31-csi";
> > +                       reg = <0x01cb0000 0x1000>;
> > +                       interrupts = <GIC_SPI 84 IRQ_TYPE_LEVEL_HIGH>;
> > +                       clocks = <&ccu CLK_BUS_CSI>,
> > +                                <&ccu CLK_CSI_SCLK>,
> > +                                <&ccu CLK_DRAM_CSI>;
> > +                       clock-names = "bus", "mod", "ram";
>
> Don't we need CLK_CSI_MCLK which can be pinout via PE1?

The CSI hardware block does not have any controls for MCLK.
It's simply routed from the CCU directly to the pin.

ChenYu
