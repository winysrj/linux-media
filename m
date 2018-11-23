Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io1-f66.google.com ([209.85.166.66]:46590 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729253AbeKWREj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Nov 2018 12:04:39 -0500
Received: by mail-io1-f66.google.com with SMTP id v10so2400337ios.13
        for <linux-media@vger.kernel.org>; Thu, 22 Nov 2018 22:21:51 -0800 (PST)
MIME-Version: 1.0
References: <20181114145934.26855-1-maxime.ripard@bootlin.com> <20181114145934.26855-5-maxime.ripard@bootlin.com>
In-Reply-To: <20181114145934.26855-5-maxime.ripard@bootlin.com>
From: Jagan Teki <jagan@amarulasolutions.com>
Date: Fri, 23 Nov 2018 11:51:38 +0530
Message-ID: <CAMty3ZDtKNvH75r3m3D1b=0HKrZ+ZVsrP-OwS_Ws2NRqtf4v5g@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] [DO NOT MERGE] ARM: dts: sun8i: Add CAM500B camera
 module to the Nano Pi M1+
To: Maxime Ripard <maxime.ripard@bootlin.com>
Cc: Yong Deng <yong.deng@magewell.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media <linux-media@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 14, 2018 at 8:29 PM Maxime Ripard <maxime.ripard@bootlin.com> w=
rote:
>
> From: Myl=C3=A8ne Josserand <mylene.josserand@bootlin.com>
>
> The Nano Pi M1+ comes with an optional sensor based on the ov5640 from
> Omnivision. Enable the support for it in the DT.
>
> Signed-off-by: Myl=C3=A8ne Josserand <mylene.josserand@bootlin.com>
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> ---
>  arch/arm/boot/dts/sun8i-h3-nanopi-m1-plus.dts | 85 +++++++++++++++++++
>  1 file changed, 85 insertions(+)
>
> diff --git a/arch/arm/boot/dts/sun8i-h3-nanopi-m1-plus.dts b/arch/arm/boo=
t/dts/sun8i-h3-nanopi-m1-plus.dts
> index 06010a9afba0..2ac62d109285 100644
> --- a/arch/arm/boot/dts/sun8i-h3-nanopi-m1-plus.dts
> +++ b/arch/arm/boot/dts/sun8i-h3-nanopi-m1-plus.dts
> @@ -52,6 +52,37 @@
>                 ethernet1 =3D &sdio_wifi;
>         };
>
> +       cam_xclk: cam-xclk {
> +                #clock-cells =3D <0>;
> +                compatible =3D "fixed-clock";
> +                clock-frequency =3D <24000000>;
> +                clock-output-names =3D "cam-xclk";
> +        };
> +
> +        reg_cam_avdd: cam-avdd {
> +                compatible =3D "regulator-fixed";
> +                regulator-name =3D "cam500b-avdd";
> +                regulator-min-microvolt =3D <2800000>;
> +                regulator-max-microvolt =3D <2800000>;
> +                vin-supply =3D <&reg_vcc3v3>;
> +        };
> +
> +        reg_cam_dovdd: cam-dovdd {
> +                compatible =3D "regulator-fixed";
> +                regulator-name =3D "cam500b-dovdd";
> +                regulator-min-microvolt =3D <1800000>;
> +                regulator-max-microvolt =3D <1800000>;
> +                vin-supply =3D <&reg_vcc3v3>;
> +        };
> +
> +        reg_cam_dvdd: cam-dvdd {
> +                compatible =3D "regulator-fixed";
> +                regulator-name =3D "cam500b-dvdd";
> +                regulator-min-microvolt =3D <1500000>;
> +                regulator-max-microvolt =3D <1500000>;
> +                vin-supply =3D <&reg_vcc3v3>;
> +        };
> +
>         reg_gmac_3v3: gmac-3v3 {
>                 compatible =3D "regulator-fixed";
>                 regulator-name =3D "gmac-3v3";
> @@ -69,6 +100,26 @@
>         };
>  };
>
> +&csi {
> +        status =3D "okay";
> +
> +        port {
> +                #address-cells =3D <1>;
> +                #size-cells =3D <0>;
> +
> +                /* Parallel bus endpoint */
> +                csi_from_ov5640: endpoint {
> +                        remote-endpoint =3D <&ov5640_to_csi>;
> +                        bus-width =3D <8>;
> +                        data-shift =3D <2>;
> +                        hsync-active =3D <1>; /* Active high */
> +                        vsync-active =3D <0>; /* Active low */
> +                        data-active =3D <1>;  /* Active high */
> +                        pclk-sample =3D <1>;  /* Rising */
> +                };
> +        };
> +};
> +
>  &ehci1 {
>         status =3D "okay";
>  };
> @@ -94,6 +145,40 @@
>         };
>  };
>
> +&i2c2 {
> +       status =3D "okay";
> +
> +       ov5640: camera@3c {
> +                compatible =3D "ovti,ov5640";
> +                reg =3D <0x3c>;
> +                clocks =3D <&cam_xclk>;

I think we can directly use existing 24MHz oscillator, &osc24M
