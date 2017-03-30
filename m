Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:36152 "EHLO
        mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932650AbdC3Hlc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Mar 2017 03:41:32 -0400
Received: by mail-qk0-f173.google.com with SMTP id p22so32799204qka.3
        for <linux-media@vger.kernel.org>; Thu, 30 Mar 2017 00:41:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170329141543.32935-12-hverkuil@xs4all.nl>
References: <20170329141543.32935-1-hverkuil@xs4all.nl> <20170329141543.32935-12-hverkuil@xs4all.nl>
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Date: Thu, 30 Mar 2017 09:41:30 +0200
Message-ID: <CA+M3ks442wftNR8+dctdSkKMCPSw9Rd2CH5UG-VEP7XySGjCjw@mail.gmail.com>
Subject: Re: [PATCHv5 11/11] arm: sti: update sti-cec for CEC notifier support
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Russell King <linux@armlinux.org.uk>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "moderated list:ARM/S5P EXYNOS AR..."
        <linux-samsung-soc@vger.kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        devicetree@vger.kernel.org, Patrice.chotard@st.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

+ Patrice for sti DT

2017-03-29 16:15 GMT+02:00 Hans Verkuil <hverkuil@xs4all.nl>:
> From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
>
> To use CEC notifier sti CEC driver needs to get phandle
> of the hdmi device.
>
> Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> CC: devicetree@vger.kernel.org
> ---
>  arch/arm/boot/dts/stih407-family.dtsi | 12 ------------
>  arch/arm/boot/dts/stih410.dtsi        | 13 +++++++++++++
>  2 files changed, 13 insertions(+), 12 deletions(-)
>
> diff --git a/arch/arm/boot/dts/stih407-family.dtsi b/arch/arm/boot/dts/st=
ih407-family.dtsi
> index d753ac36788f..044184580326 100644
> --- a/arch/arm/boot/dts/stih407-family.dtsi
> +++ b/arch/arm/boot/dts/stih407-family.dtsi
> @@ -742,18 +742,6 @@
>                                  <&clk_s_c0_flexgen CLK_ETH_PHY>;
>                 };
>
> -               cec: sti-cec@094a087c {
> -                       compatible =3D "st,stih-cec";
> -                       reg =3D <0x94a087c 0x64>;
> -                       clocks =3D <&clk_sysin>;
> -                       clock-names =3D "cec-clk";
> -                       interrupts =3D <GIC_SPI 140 IRQ_TYPE_NONE>;
> -                       interrupt-names =3D "cec-irq";
> -                       pinctrl-names =3D "default";
> -                       pinctrl-0 =3D <&pinctrl_cec0_default>;
> -                       resets =3D <&softreset STIH407_LPM_SOFTRESET>;
> -               };
> -
>                 rng10: rng@08a89000 {
>                         compatible      =3D "st,rng";
>                         reg             =3D <0x08a89000 0x1000>;
> diff --git a/arch/arm/boot/dts/stih410.dtsi b/arch/arm/boot/dts/stih410.d=
tsi
> index 3c9672c5b09f..21fe72b183d8 100644
> --- a/arch/arm/boot/dts/stih410.dtsi
> +++ b/arch/arm/boot/dts/stih410.dtsi
> @@ -281,5 +281,18 @@
>                                  <&clk_s_c0_flexgen CLK_ST231_DMU>,
>                                  <&clk_s_c0_flexgen CLK_FLASH_PROMIP>;
>                 };
> +
> +               sti-cec@094a087c {
> +                       compatible =3D "st,stih-cec";
> +                       reg =3D <0x94a087c 0x64>;
> +                       clocks =3D <&clk_sysin>;
> +                       clock-names =3D "cec-clk";
> +                       interrupts =3D <GIC_SPI 140 IRQ_TYPE_NONE>;
> +                       interrupt-names =3D "cec-irq";
> +                       pinctrl-names =3D "default";
> +                       pinctrl-0 =3D <&pinctrl_cec0_default>;
> +                       resets =3D <&softreset STIH407_LPM_SOFTRESET>;
> +                       hdmi-phandle =3D <&sti_hdmi>;
> +               };
>         };
>  };
> --
> 2.11.0
>



--=20
Benjamin Gaignard

Graphic Study Group

Linaro.org =E2=94=82 Open source software for ARM SoCs

Follow Linaro: Facebook | Twitter | Blog
