Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:33594 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750973AbdLGXUf (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Dec 2017 18:20:35 -0500
Date: Thu, 7 Dec 2017 17:20:33 -0600
From: Rob Herring <robh@kernel.org>
To: Jacob Chen <jacob-chen@iotwrt.com>
Cc: linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, mchehab@kernel.org,
        linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com, tfiga@chromium.org, zhengsq@rock-chips.com,
        laurent.pinchart@ideasonboard.com, zyc@rock-chips.com,
        eddie.cai.linux@gmail.com, jeffy.chen@rock-chips.com,
        allon.huang@rock-chips.com, devicetree@vger.kernel.org,
        heiko@sntech.de, Joao.Pinto@synopsys.com,
        Luis.Oliveira@synopsys.com, Jose.Abreu@synopsys.com,
        Jacob Chen <jacob2.chen@rock-chips.com>
Subject: Re: [PATCH v3 06/12] dt-bindings: Document the Rockchip ISP1 bindings
Message-ID: <20171207232033.itx4pvdgkyl4a5qp@rob-hp-laptop>
References: <20171206111939.1153-1-jacob-chen@iotwrt.com>
 <20171206111939.1153-7-jacob-chen@iotwrt.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171206111939.1153-7-jacob-chen@iotwrt.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Dec 06, 2017 at 07:19:33PM +0800, Jacob Chen wrote:
> From: Jacob Chen <jacob2.chen@rock-chips.com>
> 
> Add DT bindings documentation for Rockchip ISP1
> 
> Signed-off-by: Jacob Chen <jacob2.chen@rock-chips.com>
> ---
>  .../devicetree/bindings/media/rockchip-isp1.txt    | 57 ++++++++++++++++++++++
>  1 file changed, 57 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/rockchip-isp1.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/rockchip-isp1.txt b/Documentation/devicetree/bindings/media/rockchip-isp1.txt
> new file mode 100644
> index 000000000000..0971ed94ed69
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/rockchip-isp1.txt
> @@ -0,0 +1,57 @@
> +Rockchip SoC Image Signal Processing unit v1
> +----------------------------------------------
> +
> +Rockchip ISP1 is the Camera interface for the Rockchip series of SoCs
> +which contains image processing, scaling, and compression funcitons.
> +
> +Required properties:
> +  - compatible: value should be one of the following
> +      "rockchip,rk3288-cif-isp";
> +      "rockchip,rk3399-cif-isp";
> +  - reg : offset and length of the register set for the device.
> +  - interrupts: should contain ISP interrupt.
> +  - clocks: phandle to the required clocks.
> +  - clock-names: required clock name.
> +  - iommus: required a iommu node.
> +
> +The device node should contain one 'port' child node with child 'endpoint'
> +nodes, according to the bindings defined in Documentation/devicetree/bindings/
> +media/video-interfaces.txt.
> +
> +For sensor with a parallel video bus, it could be linked directly to the isp.
> +For sensor with a MIPI CSI-2 video bus, it should be linked through the
> +MIPI-DPHY, which is defined in rockchip-mipi-dphy.txt.

As I mentioned on the last version, you need to list that there are 2 
endpoints for the port and what their assignment is.

Rob
