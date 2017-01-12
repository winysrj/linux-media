Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:33946 "EHLO
        mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750753AbdALUor (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Jan 2017 15:44:47 -0500
Received: by mail-io0-f178.google.com with SMTP id l66so28323280ioi.1
        for <linux-media@vger.kernel.org>; Thu, 12 Jan 2017 12:44:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1483755102-24785-11-git-send-email-steve_longerbeam@mentor.com>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com> <1483755102-24785-11-git-send-email-steve_longerbeam@mentor.com>
From: Tim Harvey <tharvey@gateworks.com>
Date: Thu, 12 Jan 2017 11:37:32 -0800
Message-ID: <CAJ+vNU1ci=fbeemJcBGCAk40PETdcov7Fm112F5FePL9SR4cFQ@mail.gmail.com>
Subject: Re: [PATCH v3 10/24] ARM: dts: imx6-sabreauto: add pinctrl for gpt
 input capture
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        mchehab@kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Nick Dyer <nick@shmanahar.org>, markus.heiser@darmarit.de,
        Philipp Zabel <p.zabel@pengutronix.de>,
        laurent.pinchart+renesas@ideasonboard.com, bparrot@ti.com,
        geert@linux-m68k.org, Arnd Bergmann <arnd@arndb.de>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        minghsiu.tsai@mediatek.com, Tiffany Lin <tiffany.lin@mediatek.com>,
        Jean-Christophe TROTIN <jean-christophe.trotin@st.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>, robert.jarzmik@free.fr,
        songjun.wu@microchip.com, andrew-ct.chen@mediatek.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        linux-media <linux-media@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jan 6, 2017 at 6:11 PM, Steve Longerbeam <slongerbeam@gmail.com> wrote:
> Add pinctrl groups for both GPT input capture channels.
>
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> ---
>  arch/arm/boot/dts/imx6qdl-sabreauto.dtsi | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi b/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
> index 967c3b8..495709f 100644
> --- a/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
> +++ b/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
> @@ -457,6 +457,18 @@
>                         >;
>                 };
>
> +               pinctrl_gpt_input_capture0: gptinputcapture0grp {
> +                       fsl,pins = <
> +                               MX6QDL_PAD_SD1_DAT0__GPT_CAPTURE1       0x1b0b0
> +                       >;
> +               };
> +
> +               pinctrl_gpt_input_capture1: gptinputcapture1grp {
> +                       fsl,pins = <
> +                               MX6QDL_PAD_SD1_DAT1__GPT_CAPTURE2       0x1b0b0
> +                       >;
> +               };
> +
>                 pinctrl_spdif: spdifgrp {
>                         fsl,pins = <
>                                 MX6QDL_PAD_KEY_COL3__SPDIF_IN 0x1b0b0
> --

Steve,

These are not used anywhere.

Tim
