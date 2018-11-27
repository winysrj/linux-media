Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:53474 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728921AbeK0Stj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Nov 2018 13:49:39 -0500
Date: Tue, 27 Nov 2018 08:08:55 +0100
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Jagan Teki <jagan@amarulasolutions.com>
Cc: Yong Deng <yong.deng@magewell.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media <linux-media@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>
Subject: Re: [PATCH v2 4/4] [DO NOT MERGE] ARM: dts: sun8i: Add CAM500B
 camera module to the Nano Pi M1+
Message-ID: <20181127070855.74xbogjmxglaumsn@flea>
References: <20181114145934.26855-1-maxime.ripard@bootlin.com>
 <20181114145934.26855-5-maxime.ripard@bootlin.com>
 <CAMty3ZDtKNvH75r3m3D1b=0HKrZ+ZVsrP-OwS_Ws2NRqtf4v5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMty3ZDtKNvH75r3m3D1b=0HKrZ+ZVsrP-OwS_Ws2NRqtf4v5g@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 23, 2018 at 11:51:38AM +0530, Jagan Teki wrote:
> On Wed, Nov 14, 2018 at 8:29 PM Maxime Ripard <maxime.ripard@bootlin.com> wrote:
> > From: Mylène Josserand <mylene.josserand@bootlin.com>
> >
> > The Nano Pi M1+ comes with an optional sensor based on the ov5640 from
> > Omnivision. Enable the support for it in the DT.
> >
> > Signed-off-by: Mylène Josserand <mylene.josserand@bootlin.com>
> > Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> > ---
> >  arch/arm/boot/dts/sun8i-h3-nanopi-m1-plus.dts | 85 +++++++++++++++++++
> >  1 file changed, 85 insertions(+)
> >
> > diff --git a/arch/arm/boot/dts/sun8i-h3-nanopi-m1-plus.dts b/arch/arm/boot/dts/sun8i-h3-nanopi-m1-plus.dts
> > index 06010a9afba0..2ac62d109285 100644
> > --- a/arch/arm/boot/dts/sun8i-h3-nanopi-m1-plus.dts
> > +++ b/arch/arm/boot/dts/sun8i-h3-nanopi-m1-plus.dts
> > @@ -52,6 +52,37 @@
> >                 ethernet1 = &sdio_wifi;
> >         };
> >
> > +       cam_xclk: cam-xclk {
> > +                #clock-cells = <0>;
> > +                compatible = "fixed-clock";
> > +                clock-frequency = <24000000>;
> > +                clock-output-names = "cam-xclk";
> > +        };
> > +
> > +        reg_cam_avdd: cam-avdd {
> > +                compatible = "regulator-fixed";
> > +                regulator-name = "cam500b-avdd";
> > +                regulator-min-microvolt = <2800000>;
> > +                regulator-max-microvolt = <2800000>;
> > +                vin-supply = <&reg_vcc3v3>;
> > +        };
> > +
> > +        reg_cam_dovdd: cam-dovdd {
> > +                compatible = "regulator-fixed";
> > +                regulator-name = "cam500b-dovdd";
> > +                regulator-min-microvolt = <1800000>;
> > +                regulator-max-microvolt = <1800000>;
> > +                vin-supply = <&reg_vcc3v3>;
> > +        };
> > +
> > +        reg_cam_dvdd: cam-dvdd {
> > +                compatible = "regulator-fixed";
> > +                regulator-name = "cam500b-dvdd";
> > +                regulator-min-microvolt = <1500000>;
> > +                regulator-max-microvolt = <1500000>;
> > +                vin-supply = <&reg_vcc3v3>;
> > +        };
> > +
> >         reg_gmac_3v3: gmac-3v3 {
> >                 compatible = "regulator-fixed";
> >                 regulator-name = "gmac-3v3";
> > @@ -69,6 +100,26 @@
> >         };
> >  };
> >
> > +&csi {
> > +        status = "okay";
> > +
> > +        port {
> > +                #address-cells = <1>;
> > +                #size-cells = <0>;
> > +
> > +                /* Parallel bus endpoint */
> > +                csi_from_ov5640: endpoint {
> > +                        remote-endpoint = <&ov5640_to_csi>;
> > +                        bus-width = <8>;
> > +                        data-shift = <2>;
> > +                        hsync-active = <1>; /* Active high */
> > +                        vsync-active = <0>; /* Active low */
> > +                        data-active = <1>;  /* Active high */
> > +                        pclk-sample = <1>;  /* Rising */
> > +                };
> > +        };
> > +};
> > +
> >  &ehci1 {
> >         status = "okay";
> >  };
> > @@ -94,6 +145,40 @@
> >         };
> >  };
> >
> > +&i2c2 {
> > +       status = "okay";
> > +
> > +       ov5640: camera@3c {
> > +                compatible = "ovti,ov5640";
> > +                reg = <0x3c>;
> > +                clocks = <&cam_xclk>;
> 
> I think we can directly use existing 24MHz oscillator, &osc24M

That's not how the hardware is built, so not really.

Maxime

-- 
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
