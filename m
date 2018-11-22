Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io1-f67.google.com ([209.85.166.67]:38625 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726671AbeKVWYl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Nov 2018 17:24:41 -0500
Received: by mail-io1-f67.google.com with SMTP id l14so6276316ioj.5
        for <linux-media@vger.kernel.org>; Thu, 22 Nov 2018 03:45:39 -0800 (PST)
MIME-Version: 1.0
References: <20181114145934.26855-1-maxime.ripard@bootlin.com> <20181114145934.26855-4-maxime.ripard@bootlin.com>
In-Reply-To: <20181114145934.26855-4-maxime.ripard@bootlin.com>
From: Jagan Teki <jagan@amarulasolutions.com>
Date: Thu, 22 Nov 2018 17:15:27 +0530
Message-ID: <CAMty3ZDFsaFR1zb3Wt0wJ0XkeNuSHGxDsmZZKgWy=wxJpNTnHQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] ARM: dts: sun8i: Add the H3/H5 CSI controller
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
> The H3 and H5 features the same CSI controller that was initially found o=
n
> the A31.
>
> Add a DT node for it.
>
> Signed-off-by: Myl=C3=A8ne Josserand <mylene.josserand@bootlin.com>
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> ---
>  arch/arm/boot/dts/sunxi-h3-h5.dtsi | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
>
> diff --git a/arch/arm/boot/dts/sunxi-h3-h5.dtsi b/arch/arm/boot/dts/sunxi=
-h3-h5.dtsi
> index 4b1530ebe427..8779ee750bd8 100644
> --- a/arch/arm/boot/dts/sunxi-h3-h5.dtsi
> +++ b/arch/arm/boot/dts/sunxi-h3-h5.dtsi
> @@ -393,6 +393,13 @@
>                         interrupt-controller;
>                         #interrupt-cells =3D <3>;
>
> +                       csi_pins: csi {
> +                               pins =3D "PE0", "PE1", "PE2", "PE3", "PE4=
",
> +                                      "PE5", "PE6", "PE7", "PE8", "PE9",
> +                                      "PE10", "PE11";
> +                               function =3D "csi";
> +                       };
> +
>                         emac_rgmii_pins: emac0 {
>                                 pins =3D "PD0", "PD1", "PD2", "PD3", "PD4=
",
>                                        "PD5", "PD7", "PD8", "PD9", "PD10"=
,
> @@ -744,6 +751,21 @@
>                         interrupts =3D <GIC_PPI 9 (GIC_CPU_MASK_SIMPLE(4)=
 | IRQ_TYPE_LEVEL_HIGH)>;
>                 };
>
> +               csi: camera@1cb0000 {
> +                       compatible =3D "allwinner,sun8i-h3-csi",
> +                                    "allwinner,sun6i-a31-csi";
> +                       reg =3D <0x01cb0000 0x1000>;
> +                       interrupts =3D <GIC_SPI 84 IRQ_TYPE_LEVEL_HIGH>;
> +                       clocks =3D <&ccu CLK_BUS_CSI>,
> +                                <&ccu CLK_CSI_SCLK>,
> +                                <&ccu CLK_DRAM_CSI>;
> +                       clock-names =3D "bus", "mod", "ram";

Don't we need CLK_CSI_MCLK which can be pinout via PE1?
