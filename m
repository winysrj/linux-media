Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:37150 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751720AbdFHUZe (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Jun 2017 16:25:34 -0400
Received: by mail-wm0-f53.google.com with SMTP id d73so38101526wma.0
        for <linux-media@vger.kernel.org>; Thu, 08 Jun 2017 13:25:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1496860453-6282-15-git-send-email-steve_longerbeam@mentor.com>
References: <1496860453-6282-1-git-send-email-steve_longerbeam@mentor.com> <1496860453-6282-15-git-send-email-steve_longerbeam@mentor.com>
From: Tim Harvey <tharvey@gateworks.com>
Date: Thu, 8 Jun 2017 13:25:27 -0700
Message-ID: <CAJ+vNU0C0=4hUq+g1P7yTzLzFPidfauQROPOVr4WQWKNZz_xmQ@mail.gmail.com>
Subject: Re: [PATCH v8 14/34] ARM: dts: imx6-sabreauto: add the ADV7180 video decoder
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
        shuah@kernel.org, sakari.ailus@linux.intel.com, pavel@ucw.cz,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        linux-media <linux-media@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 7, 2017 at 11:33 AM, Steve Longerbeam <slongerbeam@gmail.com> wrote:
> Enables the ADV7180 decoder sensor. The ADV7180 connects to the
> parallel-bus mux input on ipu1_csi0_mux.
>
> The ADV7180 power pin is via max7310_b port expander.
>
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
>
> - Use IRQ_TYPE_LEVEL_LOW instead of 0x8 for interrupt type for clarity.
> - For 8-bit parallel IPU1-CSI0 bus connection only data[12-19] are used.
>
> Signed-off-by: Tim Harvey <tharvey@gateworks.com>
> ---
>  arch/arm/boot/dts/imx6qdl-sabreauto.dtsi | 50 ++++++++++++++++++++++++++++++++
>  1 file changed, 50 insertions(+)
>
> diff --git a/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi b/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
> index 1212f82..c24af28 100644
> --- a/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
> +++ b/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
> @@ -124,6 +124,21 @@
>                         #size-cells = <0>;
>                         reg = <1>;
>
> +                       adv7180: camera@21 {
> +                               compatible = "adi,adv7180";
> +                               reg = <0x21>;
> +                               powerdown-gpios = <&max7310_b 2 GPIO_ACTIVE_LOW>;
> +                               interrupt-parent = <&gpio1>;
> +                               interrupts = <27 IRQ_TYPE_LEVEL_LOW>;
> +
> +                               port {
> +                                       adv7180_to_ipu1_csi0_mux: endpoint {
> +                                               remote-endpoint = <&ipu1_csi0_mux_from_parallel_sensor>;
> +                                               bus-width = <8>;
> +                                       };
> +                               };
> +                       };
> +
>                         max7310_a: gpio@30 {
>                                 compatible = "maxim,max7310";
>                                 reg = <0x30>;
> @@ -151,6 +166,25 @@
>         };
>  };
>
> +&ipu1_csi0_from_ipu1_csi0_mux {
> +       bus-width = <8>;
> +};
> +
> +&ipu1_csi0_mux_from_parallel_sensor {
> +       remote-endpoint = <&adv7180_to_ipu1_csi0_mux>;
> +       bus-width = <8>;
> +};
> +
> +&ipu1_csi0 {
> +       pinctrl-names = "default";
> +       pinctrl-0 = <&pinctrl_ipu1_csi0>;
> +
> +       /* enable frame interval monitor on this port */
> +       fim {
> +               status = "okay";
> +       };

Steve,

You need to remove the fim node now that you've moved this to V4L2 controls.

Regards,

Tim
