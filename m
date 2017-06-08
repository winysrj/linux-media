Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:36352 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751470AbdFHQpR (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Jun 2017 12:45:17 -0400
Subject: Re: [PATCH v8 02/34] [media] dt-bindings: Add bindings for i.MX media
 driver
From: Steve Longerbeam <slongerbeam@gmail.com>
To: robh+dt@kernel.org, mark.rutland@arm.com
Cc: kernel@pengutronix.de, mchehab@kernel.org, hverkuil@xs4all.nl,
        p.zabel@pengutronix.de, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
References: <1496860453-6282-1-git-send-email-steve_longerbeam@mentor.com>
 <1496860453-6282-3-git-send-email-steve_longerbeam@mentor.com>
Message-ID: <18997640-8cbd-734d-160e-a930f887d14f@gmail.com>
Date: Thu, 8 Jun 2017 09:45:14 -0700
MIME-Version: 1.0
In-Reply-To: <1496860453-6282-3-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rob, Mark,

Are there any remaining technical issues with this
binding doc? At this point an Ack from you is the only
thing holding up merge of the imx-media driver.

Thanks,
Steve


On 06/07/2017 11:33 AM, Steve Longerbeam wrote:
> Add bindings documentation for the i.MX media driver.
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> ---
>   Documentation/devicetree/bindings/media/imx.txt | 47 +++++++++++++++++++++++++
>   1 file changed, 47 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/media/imx.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/imx.txt b/Documentation/devicetree/bindings/media/imx.txt
> new file mode 100644
> index 0000000..c1e1e2b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/imx.txt
> @@ -0,0 +1,47 @@
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
> +
> +mipi_csi2 node
> +--------------
> +
> +This is the device node for the MIPI CSI-2 Receiver, required for MIPI
> +CSI-2 sensors.
> +
> +Required properties:
> +- compatible	: "fsl,imx6-mipi-csi2", "snps,dw-mipi-csi2";
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
> 
