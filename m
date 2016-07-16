Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:36698 "EHLO
	mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbcGPXBP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jul 2016 19:01:15 -0400
Date: Sat, 16 Jul 2016 18:01:13 -0500
From: Rob Herring <robh@kernel.org>
To: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>, daniel.thompson@linaro.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Pawel Osciak <posciak@chromium.org>,
	srv_heupstream@mediatek.com,
	Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH 2/4] dt-bindings: Add a binding for Mediatek MDP
Message-ID: <20160716230113.GA31551@rob-hp-laptop>
References: <1468498681-19955-1-git-send-email-minghsiu.tsai@mediatek.com>
 <1468498681-19955-3-git-send-email-minghsiu.tsai@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1468498681-19955-3-git-send-email-minghsiu.tsai@mediatek.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 14, 2016 at 08:17:59PM +0800, Minghsiu Tsai wrote:
> Add a DT binding documentation of MDP for the MT8173 SoC
> from Mediatek
> 
> Signed-off-by: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
> ---
>  .../devicetree/bindings/media/mediatek-mdp.txt     |   92 ++++++++++++++++++++
>  1 file changed, 92 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/mediatek-mdp.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/mediatek-mdp.txt b/Documentation/devicetree/bindings/media/mediatek-mdp.txt
> new file mode 100644
> index 0000000..ef570c3
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/mediatek-mdp.txt
> @@ -0,0 +1,92 @@
> +* Mediatek Media Data Path
> +
> +Media Data Path is used for scaling and color space conversion.
> +
> +Required properties:
> +  - compatible : should contain them as below:
> +        "mediatek,mt8173-mdp"
> +        "mediatek,mt8173-mdp-rdma"
> +        "mediatek,mt8173-mdp-rsz"
> +        "mediatek,mt8173-mdp-wdma"
> +        "mediatek,mt8173-mdp-wrot"
> +  - clocks : device clocks
> +  - power-domains : a phandle to the power domain.
> +  - mediatek,larb : should contain the larbes of current platform
> +  - iommus : Mediatek IOMMU H/W has designed the fixed associations with
> +        the multimedia H/W. and there is only one multimedia iommu domain.
> +        "iommus = <&iommu portid>" the "portid" is from
> +        dt-bindings\iommu\mt8173-iommu-port.h, it means that this portid will
> +        enable iommu. The portid default is disable iommu if "<&iommu portid>"
> +        don't be added.
> +  - mediatek,vpu : the node of video processor unit

These properties don't apply to all the nodes. I think you need a 
section for each IP block.
