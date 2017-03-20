Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:36826 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754261AbdCTPLD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 11:11:03 -0400
Date: Mon, 20 Mar 2017 10:02:35 -0500
From: Rob Herring <robh@kernel.org>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>
Cc: mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, linux@armlinux.org.uk, mchehab@kernel.org,
        hverkuil@xs4all.nl, nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org,
        shuah@kernel.org, sakari.ailus@linux.intel.com, pavel@ucw.cz,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [PATCH v5 02/39] [media] dt-bindings: Add bindings for i.MX
 media driver
Message-ID: <20170320150235.xfd7c3a26au5qmyz@rob-hp-laptop>
References: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
 <1489121599-23206-3-git-send-email-steve_longerbeam@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1489121599-23206-3-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

+Ramiro

On Thu, Mar 09, 2017 at 08:52:42PM -0800, Steve Longerbeam wrote:
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
> +		sensor interface ports of IPU devices
> +
> +example:
> +
> +capture-subsystem {
> +	compatible = "fsl,imx-capture-subsystem";
> +	ports = <&ipu1_csi0>, <&ipu1_csi1>;
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
> +			     specified as <chan flags>. The channel number
> +			     must be 0 or 1. The flags can be
> +			     IRQ_TYPE_EDGE_RISING, IRQ_TYPE_EDGE_FALLING, or
> +			     IRQ_TYPE_EDGE_BOTH, and specify which input
> +			     capture signal edge will trigger the input
> +			     capture event. If an input capture channel is
> +			     specified, the FIM will use this method to
> +			     measure frame intervals instead of via the EOF
> +			     interrupt. The input capture method is much
> +			     preferred over EOF as it is not subject to
> +			     interrupt latency errors. However it requires
> +			     routing the VSYNC or FIELD output signals of
> +			     the camera sensor to one of the i.MX input
> +			     capture pads (SD1_DAT0, SD1_DAT1), which also
> +			     gives up support for SD1.
> +
> +
> +mipi_csi2 node
> +--------------
> +
> +This is the device node for the MIPI CSI-2 Receiver, required for MIPI
> +CSI-2 sensors.
> +
> +Required properties:
> +- compatible	: "fsl,imx6-mipi-csi2", "snps,dw-mipi-csi2";

Ramiro is also working on a binding for DW MIPI CSI2 block[1]. We need 1 
binding for that.

> +- reg           : physical base address and length of the register set;
> +- clocks	: the MIPI CSI-2 receiver requires three clocks: hsi_tx
> +		  (the D-PHY clock), video_27m (D-PHY PLL reference
> +		  clock), and eim_podf;
> +- clock-names	: must contain "dphy", "ref", "pix";
> +- port@*        : five port nodes must exist, containing endpoints
> +		  connecting to the source and sink devices according to
> +		  of_graph bindings. The first port is an input port,
> +		  connecting with a MIPI CSI-2 source, and ports 1
> +		  through 4 are output ports connecting with parallel
> +		  bus sink endpoint nodes and correspond to the four
> +		  MIPI CSI-2 virtual channel outputs.
> +
> +Optional properties:
> +- interrupts	: must contain two level-triggered interrupts,
> +		  in order: 100 and 101;
> -- 
> 2.7.4
> 

[1] https://lkml.org/lkml/2017/3/7/395
