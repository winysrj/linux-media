Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:49530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932285AbdC2AWD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Mar 2017 20:22:03 -0400
MIME-Version: 1.0
In-Reply-To: <1490661656-10318-3-git-send-email-steve_longerbeam@mentor.com>
References: <1490661656-10318-1-git-send-email-steve_longerbeam@mentor.com> <1490661656-10318-3-git-send-email-steve_longerbeam@mentor.com>
From: Rob Herring <robh+dt@kernel.org>
Date: Tue, 28 Mar 2017 19:21:34 -0500
Message-ID: <CAL_JsqJm_JjuVPcOBERCqsnjTDdNoKr9xRE9MXMO4ivxGath2Q@mail.gmail.com>
Subject: Re: [PATCH v6 02/39] [media] dt-bindings: Add bindings for i.MX media driver
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>,
        Shawn Guo <shawnguo@kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Russell King <linux@armlinux.org.uk>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Nick Dyer <nick@shmanahar.org>, markus.heiser@darmarit.de,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Benoit Parrot <bparrot@ti.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>,
        tiffany lin <tiffany.lin@mediatek.com>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Songjun Wu <songjun.wu@microchip.com>,
        =?UTF-8?B?QW5kcmV3LUNUIENoZW4gKOmZs+aZuui/qik=?=
        <andrew-ct.chen@mediatek.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        shuah@kernel.org, Sakari Ailus <sakari.ailus@linux.intel.com>,
        Pavel Machek <pavel@ucw.cz>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 27, 2017 at 7:40 PM, Steve Longerbeam <slongerbeam@gmail.com> wrote:
> Add bindings documentation for the i.MX media driver.
>
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> ---
>  Documentation/devicetree/bindings/media/imx.txt | 74 +++++++++++++++++++++++++
>  1 file changed, 74 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/imx.txt
>
> diff --git a/Documentation/devicetree/bindings/media/imx.txt b/Documentation/devicetree/bindings/media/imx.txt
> new file mode 100644
> index 0000000..3059c06
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/imx.txt
> @@ -0,0 +1,74 @@
> +Freescale i.MX Media Video Device
> +=================================
> +
> +Video Media Controller node
> +---------------------------
> +
> +This is the media controller node for video capture support. It is a
> +virtual device that lists the camera serial interface nodes that the
> +media device will control.
> +
> +Required properties:
> +- compatible : "fsl,imx-capture-subsystem";
> +- ports      : Should contain a list of phandles pointing to camera
> +               sensor interface ports of IPU devices
> +
> +example:
> +
> +capture-subsystem {
> +       compatible = "fsl,imx-capture-subsystem";
> +       ports = <&ipu1_csi0>, <&ipu1_csi1>;
> +};
> +
> +fim child node
> +--------------
> +
> +This is an optional child node of the ipu_csi port nodes. If present and
> +available, it enables the Frame Interval Monitor. Its properties can be
> +used to modify the method in which the FIM measures frame intervals.
> +Refer to Documentation/media/v4l-drivers/imx.rst for more info on the
> +Frame Interval Monitor.
> +
> +Optional properties:
> +- fsl,input-capture-channel: an input capture channel and channel flags,
> +                            specified as <chan flags>. The channel number
> +                            must be 0 or 1. The flags can be
> +                            IRQ_TYPE_EDGE_RISING, IRQ_TYPE_EDGE_FALLING, or
> +                            IRQ_TYPE_EDGE_BOTH, and specify which input
> +                            capture signal edge will trigger the input
> +                            capture event. If an input capture channel is
> +                            specified, the FIM will use this method to
> +                            measure frame intervals instead of via the EOF
> +                            interrupt. The input capture method is much
> +                            preferred over EOF as it is not subject to
> +                            interrupt latency errors. However it requires
> +                            routing the VSYNC or FIELD output signals of
> +                            the camera sensor to one of the i.MX input
> +                            capture pads (SD1_DAT0, SD1_DAT1), which also
> +                            gives up support for SD1.
> +
> +
> +mipi_csi2 node
> +--------------
> +
> +This is the device node for the MIPI CSI-2 Receiver, required for MIPI
> +CSI-2 sensors.
> +
> +Required properties:
> +- compatible   : "fsl,imx6-mipi-csi2", "snps,dw-mipi-csi2";

As I mentioned in v5, there's a DW CSI2 binding in progress. This
needs to be based on that.

Rob
