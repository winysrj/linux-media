Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ed1-f67.google.com ([209.85.208.67]:39414 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725864AbeLCJz1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Dec 2018 04:55:27 -0500
MIME-Version: 1.0
References: <20181130075849.16941-1-wens@csie.org> <20181130075849.16941-6-wens@csie.org>
 <CAMty3ZAuBM0s3eNhQBySSaUrUAkiF=Hk+Ab=gsN=QucLJv0zyw@mail.gmail.com>
In-Reply-To: <CAMty3ZAuBM0s3eNhQBySSaUrUAkiF=Hk+Ab=gsN=QucLJv0zyw@mail.gmail.com>
From: Chen-Yu Tsai <wens@csie.org>
Date: Mon, 3 Dec 2018 17:54:54 +0800
Message-ID: <CAGb2v64dbDW9Fpb_B0d8wQW7WTELqGoUzasV_KXonfEkucRZTA@mail.gmail.com>
Subject: Re: [PATCH 5/6] [DO NOT MERGE] ARM: dts: sunxi: bananapi-m2p: Add
 HDF5640 camera module
To: Jagan Teki <jagan@amarulasolutions.com>
Cc: Yong Deng <yong.deng@magewell.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Dec 3, 2018 at 5:52 PM Jagan Teki <jagan@amarulasolutions.com> wrote:
>
> On Fri, Nov 30, 2018 at 1:29 PM Chen-Yu Tsai <wens@csie.org> wrote:
> >
> > The Bananapi M2+ comes with an optional sensor based on the ov5640 from
> > Omnivision. Enable the support for it in the DT.
> >
> > Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> > ---
> >  arch/arm/boot/dts/sunxi-bananapi-m2-plus.dtsi | 87 +++++++++++++++++++
> >  1 file changed, 87 insertions(+)
> >
> > diff --git a/arch/arm/boot/dts/sunxi-bananapi-m2-plus.dtsi b/arch/arm/boot/dts/sunxi-bananapi-m2-plus.dtsi
> > index b3283aeb5b7d..d97a98acf378 100644
> > --- a/arch/arm/boot/dts/sunxi-bananapi-m2-plus.dtsi
> > +++ b/arch/arm/boot/dts/sunxi-bananapi-m2-plus.dtsi
> > @@ -89,6 +89,42 @@
> >                 };
> >         };
> >
> > +       reg_cam_avdd: cam-avdd {
> > +               compatible = "regulator-fixed";
> > +               regulator-name = "csi-avdd";
> > +               regulator-min-microvolt = <2800000>;
> > +               regulator-max-microvolt = <2800000>;
> > +               startup-delay-us = <200>; /* 50 us + board delays */
> > +               enable-active-high;
> > +               gpio = <&pio 3 14 GPIO_ACTIVE_HIGH>; /* PD14 */
> > +       };
> > +
> > +       reg_cam_dovdd: cam-dovdd {
> > +               compatible = "regulator-fixed";
> > +               regulator-name = "csi-dovdd";
> > +               regulator-min-microvolt = <2800000>;
> > +               regulator-max-microvolt = <2800000>;
> > +               /*
> > +                * This regulator also powers the pull-ups for the I2C bus.
> > +                * For some reason, if this is turned off, subsequent use
> > +                * of the I2C bus, even when turned on, does not work.
> > +                */
> > +               startup-delay-us = <200>; /* 50 us + board delays */
> > +               regulator-always-on;
> > +               enable-active-high;
> > +               gpio = <&pio 3 14 GPIO_ACTIVE_HIGH>; /* PD14 */
> > +       };
> > +
> > +       reg_cam_dvdd: cam-dvdd {
> > +               compatible = "regulator-fixed";
> > +               regulator-name = "csi-dvdd";
> > +               regulator-min-microvolt = <1500000>;
> > +               regulator-max-microvolt = <1500000>;
> > +               startup-delay-us = <200>; /* 50 us + board delays */
> > +               enable-active-high;
> > +               gpio = <&pio 3 14 GPIO_ACTIVE_HIGH>; /* PD14 */
> > +       };
> > +
> >         reg_gmac_3v3: gmac-3v3 {
> >                       compatible = "regulator-fixed";
> >                       regulator-name = "gmac-3v3";
> > @@ -106,6 +142,26 @@
> >         };
> >  };
> >
> > +&csi {
> > +       status = "okay";
> > +
> > +       port {
> > +               #address-cells = <1>;
> > +               #size-cells = <0>;
> > +
> > +               /* Parallel bus endpoint */
> > +               csi_from_ov5640: endpoint {
> > +                       remote-endpoint = <&ov5640_to_csi>;
> > +                       bus-width = <8>;
> > +                       data-shift = <2>;
>
> If I'm not wrong, the data-shift is not available in sun6i at-least in
> conf register.

Indeed. Seems only a few drivers actually take this into account. Since
this is just an example, I'm not going to respin it.

ChenYu
