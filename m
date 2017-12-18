Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:36112 "EHLO
        smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757709AbdLRIgU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Dec 2017 03:36:20 -0500
MIME-Version: 1.0
In-Reply-To: <1510558344-45402-1-git-send-email-yong.deng@magewell.com>
References: <1510558344-45402-1-git-send-email-yong.deng@magewell.com>
From: Chen-Yu Tsai <wens@csie.org>
Date: Mon, 18 Dec 2017 16:35:51 +0800
Message-ID: <CAGb2v67JhMfba8Ao7WyrYikkxvTxX8WaBRqu3GkrhOCWndresg@mail.gmail.com>
Subject: Re: [linux-sunxi] [PATCH v3 2/3] dt-bindings: media: Add Allwinner
 V3s Camera Sensor Interface (CSI)
To: Yong Deng <yong.deng@magewell.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Benoit Parrot <bparrot@ti.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Yannick Fertre <yannick.fertre@st.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Rick Chang <rick.chang@mediatek.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        =?UTF-8?Q?Ond=C5=99ej_Jirman?= <megous@megous.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 13, 2017 at 3:32 PM, Yong Deng <yong.deng@magewell.com> wrote:
> Add binding documentation for Allwinner V3s CSI.
>
> Signed-off-by: Yong Deng <yong.deng@magewell.com>
> ---
>  .../devicetree/bindings/media/sun6i-csi.txt        | 51 ++++++++++++++++++++++
>  1 file changed, 51 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/sun6i-csi.txt
>
> diff --git a/Documentation/devicetree/bindings/media/sun6i-csi.txt b/Documentation/devicetree/bindings/media/sun6i-csi.txt
> new file mode 100644
> index 0000000..f3916a2
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/sun6i-csi.txt
> @@ -0,0 +1,51 @@
> +Allwinner V3s Camera Sensor Interface
> +------------------------------
> +
> +Required properties:
> +  - compatible: value must be "allwinner,sun8i-v3s-csi"
> +  - reg: base address and size of the memory-mapped region.
> +  - interrupts: interrupt associated to this IP
> +  - clocks: phandles to the clocks feeding the CSI
> +    * bus: the CSI interface clock
> +    * mod: the CSI module clock
> +    * ram: the CSI DRAM clock
> +  - clock-names: the clock names mentioned above
> +  - resets: phandles to the reset line driving the CSI
> +
> +- ports: A ports node with endpoint definitions as defined in
> +  Documentation/devicetree/bindings/media/video-interfaces.txt.
> +  Currently, the driver only support the parallel interface. So, a single port
> +  node with one endpoint and parallel bus is supported.
> +
> +Example:
> +
> +       csi1: csi@01cb4000 {

Drop the leading zero in the address part.

> +               compatible = "allwinner,sun8i-v3s-csi";
> +               reg = <0x01cb4000 0x1000>;
> +               interrupts = <GIC_SPI 84 IRQ_TYPE_LEVEL_HIGH>;
> +               clocks = <&ccu CLK_BUS_CSI>,
> +                        <&ccu CLK_CSI1_SCLK>,

CSI also has an MCLK. Do you need that one?

ChenYu

> +                        <&ccu CLK_DRAM_CSI>;
> +               clock-names = "bus", "mod", "ram";
> +               resets = <&ccu RST_BUS_CSI>;
> +
> +               port {
> +                       #address-cells = <1>;
> +                       #size-cells = <0>;
> +
> +                       /* Parallel bus endpoint */
> +                       csi1_ep: endpoint {
> +                               remote-endpoint = <&adv7611_ep>;
> +                               bus-width = <16>;
> +                               data-shift = <0>;
> +
> +                               /* If hsync-active/vsync-active are missing,
> +                                  embedded BT.656 sync is used */
> +                               hsync-active = <0>; /* Active low */
> +                               vsync-active = <0>; /* Active low */
> +                               data-active = <1>;  /* Active high */
> +                               pclk-sample = <1>;  /* Rising */
> +                       };
> +               };
> +       };
> +
> --
> 1.8.3.1
>
> --
> You received this message because you are subscribed to the Google Groups "linux-sunxi" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to linux-sunxi+unsubscribe@googlegroups.com.
> For more options, visit https://groups.google.com/d/optout.
