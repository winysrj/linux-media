Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:39513 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389969AbeKVUU6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Nov 2018 15:20:58 -0500
Subject: Re: [PATCH v10 1/4] media: dt-bindings: Document the Rockchip VPU
 bindings
To: Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-rockchip@lists.infradead.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Miouyouyou <myy@miouyouyou.fr>
References: <20181121191652.22814-1-ezequiel@collabora.com>
 <20181121191652.22814-2-ezequiel@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <c452bffd-7fd5-cb06-85d3-c82f35a94e22@xs4all.nl>
Date: Thu, 22 Nov 2018 10:42:13 +0100
MIME-Version: 1.0
In-Reply-To: <20181121191652.22814-2-ezequiel@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/21/2018 08:16 PM, Ezequiel Garcia wrote:
> Add devicetree binding documentation for Rockchip Video Processing
> Unit IP.
> 
> Reviewed-by: Rob Herring <robh@kernel.org>
> Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>

This one has been merged already.

Regards,

	Hans

> ---
>  .../bindings/media/rockchip-vpu.txt           | 29 +++++++++++++++++++
>  1 file changed, 29 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/rockchip-vpu.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/rockchip-vpu.txt b/Documentation/devicetree/bindings/media/rockchip-vpu.txt
> new file mode 100644
> index 000000000000..35dc464ad7c8
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/rockchip-vpu.txt
> @@ -0,0 +1,29 @@
> +device-tree bindings for rockchip VPU codec
> +
> +Rockchip (Video Processing Unit) present in various Rockchip platforms,
> +such as RK3288 and RK3399.
> +
> +Required properties:
> +- compatible: value should be one of the following
> +		"rockchip,rk3288-vpu";
> +		"rockchip,rk3399-vpu";
> +- interrupts: encoding and decoding interrupt specifiers
> +- interrupt-names: should be "vepu" and "vdpu"
> +- clocks: phandle to VPU aclk, hclk clocks
> +- clock-names: should be "aclk" and "hclk"
> +- power-domains: phandle to power domain node
> +- iommus: phandle to a iommu node
> +
> +Example:
> +SoC-specific DT entry:
> +	vpu: video-codec@ff9a0000 {
> +		compatible = "rockchip,rk3288-vpu";
> +		reg = <0x0 0xff9a0000 0x0 0x800>;
> +		interrupts = <GIC_SPI 9 IRQ_TYPE_LEVEL_HIGH>,
> +			     <GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>;
> +		interrupt-names = "vepu", "vdpu";
> +		clocks = <&cru ACLK_VCODEC>, <&cru HCLK_VCODEC>;
> +		clock-names = "aclk", "hclk";
> +		power-domains = <&power RK3288_PD_VIDEO>;
> +		iommus = <&vpu_mmu>;
> +	};
> 
