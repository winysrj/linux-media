Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io1-f65.google.com ([209.85.166.65]:45269 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729004AbeK0V6k (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Nov 2018 16:58:40 -0500
Received: by mail-io1-f65.google.com with SMTP id w7so16598141iom.12
        for <linux-media@vger.kernel.org>; Tue, 27 Nov 2018 03:01:08 -0800 (PST)
MIME-Version: 1.0
References: <cover.71b0f9855c251f9dc389ee77ee6f0e1fad91fb0b.1542097288.git-series.maxime.ripard@bootlin.com>
 <12093630fdd7d8b43ebcb0340691e0f2200e26c6.1542097288.git-series.maxime.ripard@bootlin.com>
 <CAMty3ZBO6B=vgduv5u28zC8P1DOm1TYGFAVjDtJOpU8dozrk=A@mail.gmail.com> <20181127103106.vykudp36vkyy5vme@flea>
In-Reply-To: <20181127103106.vykudp36vkyy5vme@flea>
From: Jagan Teki <jagan@amarulasolutions.com>
Date: Tue, 27 Nov 2018 16:30:55 +0530
Message-ID: <CAMty3ZAhGAN2nEJkiRLHqFHz9Oi1WboiyqLL4ox+-0z7NhbG8w@mail.gmail.com>
Subject: Re: [PATCH 5/5] DO NOT MERGE: ARM: dts: bananapi: Add Camera support
To: Maxime Ripard <maxime.ripard@bootlin.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        laurent.pinchart@ideasonboard.com,
        linux-media <linux-media@vger.kernel.org>, a.hajda@samsung.com,
        Chen-Yu Tsai <wens@csie.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>, frowand.list@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 27, 2018 at 4:01 PM Maxime Ripard <maxime.ripard@bootlin.com> wrote:
>
> On Tue, Nov 27, 2018 at 12:26:09PM +0530, Jagan Teki wrote:
> > On Tue, Nov 13, 2018 at 1:54 PM Maxime Ripard <maxime.ripard@bootlin.com> wrote:
> > >
> > > Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> > > ---
> > >  arch/arm/boot/dts/sun7i-a20-bananapi.dts | 98 +++++++++++++++++++++++++-
> > >  1 file changed, 98 insertions(+)
> > >
> > > diff --git a/arch/arm/boot/dts/sun7i-a20-bananapi.dts b/arch/arm/boot/dts/sun7i-a20-bananapi.dts
> > > index 70dfc4ac0bb5..18dbff9f1ce9 100644
> > > --- a/arch/arm/boot/dts/sun7i-a20-bananapi.dts
> > > +++ b/arch/arm/boot/dts/sun7i-a20-bananapi.dts
> > > @@ -54,6 +54,9 @@
> > >         compatible = "lemaker,bananapi", "allwinner,sun7i-a20";
> > >
> > >         aliases {
> > > +               i2c0 = &i2c0;
> > > +               i2c1 = &i2c1;
> > > +               i2c2 = &i2c2;
> > >                 serial0 = &uart0;
> > >                 serial1 = &uart3;
> > >                 serial2 = &uart7;
> > > @@ -63,6 +66,41 @@
> > >                 stdout-path = "serial0:115200n8";
> > >         };
> > >
> > > +       reg_cam: cam {
> > > +               compatible = "regulator-fixed";
> > > +               regulator-name = "cam";
> > > +               regulator-min-microvolt = <5000000>;
> > > +               regulator-max-microvolt = <5000000>;
> > > +               vin-supply = <&reg_vcc5v0>;
> > > +               gpio = <&pio 7 16 GPIO_ACTIVE_HIGH>;
> > > +               enable-active-high;
> > > +               regulator-always-on;
> > > +       };
> > > +
> > > +        reg_cam_avdd: cam-avdd {
> > > +                compatible = "regulator-fixed";
> > > +                regulator-name = "cam500b-avdd";
> > > +                regulator-min-microvolt = <2800000>;
> > > +                regulator-max-microvolt = <2800000>;
> > > +                vin-supply = <&reg_cam>;
> > > +        };
> > > +
> > > +        reg_cam_dovdd: cam-dovdd {
> > > +                compatible = "regulator-fixed";
> > > +                regulator-name = "cam500b-dovdd";
> > > +                regulator-min-microvolt = <1800000>;
> > > +                regulator-max-microvolt = <1800000>;
> > > +                vin-supply = <&reg_cam>;
> > > +        };
> > > +
> > > +        reg_cam_dvdd: cam-dvdd {
> > > +                compatible = "regulator-fixed";
> > > +                regulator-name = "cam500b-dvdd";
> > > +                regulator-min-microvolt = <1500000>;
> > > +                regulator-max-microvolt = <1500000>;
> > > +                vin-supply = <&reg_cam>;
> > > +        };
> > > +
> > >         hdmi-connector {
> > >                 compatible = "hdmi-connector";
> > >                 type = "a";
> > > @@ -120,6 +158,27 @@
> > >                 >;
> > >  };
> > >
> > > +&csi0 {
> > > +       pinctrl-names = "default";
> > > +       pinctrl-0 = <&csi0_pins_a>;
> > > +       status = "okay";
> > > +
> > > +       port {
> > > +               #address-cells = <1>;
> > > +               #size-cells = <0>;
> > > +
> > > +               csi_from_ov5640: endpoint {
> > > +                        remote-endpoint = <&ov5640_to_csi>;
> > > +                        bus-width = <8>;
> > > +                        data-shift = <2>;
> > > +                        hsync-active = <1>; /* Active high */
> > > +                        vsync-active = <0>; /* Active low */
> > > +                        data-active = <1>;  /* Active high */
> > > +                        pclk-sample = <1>;  /* Rising */
> > > +                };
> > > +       };
> > > +};
> > > +
> > >  &de {
> > >         status = "okay";
> > >  };
> > > @@ -167,6 +226,39 @@
> > >         };
> > >  };
> > >
> > > +&i2c1 {
> > > +       pinctrl-names = "default";
> > > +       pinctrl-0 = <&i2c1_pins_a>;
> > > +       status = "okay";
> > > +
> > > +       camera: camera@21 {
> > > +               compatible = "ovti,ov5640";
> > > +               reg = <0x21>;
> > > +                clocks = <&ccu CLK_CSI0>;
> > > +                clock-names = "xclk";
> > > +               assigned-clocks = <&ccu CLK_CSI0>;
> > > +               assigned-clock-rates = <24000000>;
> > > +
> > > +                reset-gpios = <&pio 7 14 GPIO_ACTIVE_LOW>;
> > > +                powerdown-gpios = <&pio 7 19 GPIO_ACTIVE_HIGH>;
> > > +                AVDD-supply = <&reg_cam_avdd>;
> > > +                DOVDD-supply = <&reg_cam_dovdd>;
> > > +                DVDD-supply = <&reg_cam_dvdd>;
> > > +
> > > +                port {
> > > +                        ov5640_to_csi: endpoint {
> > > +                                remote-endpoint = <&csi_from_ov5640>;
> > > +                                bus-width = <8>;
> > > +                                data-shift = <2>;
> > > +                                hsync-active = <1>; /* Active high */
> > > +                                vsync-active = <0>; /* Active low */
> > > +                                data-active = <1>;  /* Active high */
> > > +                                pclk-sample = <1>;  /* Rising */
> > > +                        };
> > > +                };
> > > +       };
> >
> > Does ov5640 need any further patches, wrt linux-next? I'm trying to
> > test this on top of linux-next but the slave id seems not detecting.
> >
> > [    2.304711] ov5640 1-0021: Linked as a consumer to regulator.5
> > [    2.310639] ov5640 1-0021: Linked as a consumer to regulator.6
> > [    2.316592] ov5640 1-0021: Linked as a consumer to regulator.4
> > [    2.351540] ov5640 1-0021: ov5640_init_slave_id: failed with -6
> > [    2.357543] ov5640 1-0021: Dropping the link to regulator.5
> > [    2.363224] ov5640 1-0021: Dropping the link to regulator.6
> > [    2.368829] ov5640 1-0021: Dropping the link to regulator.4
> >
> > Here is the full log [1], please let me know if I miss anything, I
> > even tried to remove MCLK pin
>
> You seem to have made local modifications to your tree, what are they?
> This indicates that the communication over i2c doesn't work, what is
> your setup?

I just used your commits on linux-next [2], with the setup similar in
Page 5 on datasheet[3]. The only difference is csi build issue, I have
updated similar fix you mentioned on sun6i_csi [4]

[2] https://github.com/amarula/linux-amarula/commits/CSI-A20
[3] https://www.tme.eu/gb/Document/187887186b98a8f78b47da2774a34f4c/BPI-CAMERA.pdf
[4] https://github.com/amarula/linux-amarula/commit/a6762ecd38f000e2bd02dd255f6fd0c1ae755429#diff-0809a7f97ca58771c1cda186e73ec657
