Return-Path: <SRS0=QP2W=QQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65189C282C4
	for <linux-media@archiver.kernel.org>; Sat,  9 Feb 2019 15:59:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C5AF218D2
	for <linux-media@archiver.kernel.org>; Sat,  9 Feb 2019 15:59:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbfBIP70 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 9 Feb 2019 10:59:26 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54104 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726894AbfBIP70 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 9 Feb 2019 10:59:26 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id E160F634C7B;
        Sat,  9 Feb 2019 17:59:07 +0200 (EET)
Received: from sailus by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1gsV23-0000wr-Hp; Sat, 09 Feb 2019 17:59:07 +0200
Date:   Sat, 9 Feb 2019 17:59:07 +0200
From:   Sakari Ailus <sakari.ailus@iki.fi>
To:     Frederic Chen <frederic.chen@mediatek.com>
Cc:     hans.verkuil@cisco.com, laurent.pinchart+renesas@ideasonboard.com,
        tfiga@chromium.org, matthias.bgg@gmail.com, mchehab@kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, Sean.Cheng@mediatek.com,
        sj.huang@mediatek.com, christie.yu@mediatek.com,
        holmes.chiou@mediatek.com, Jerry-ch.Chen@mediatek.com,
        jungo.lin@mediatek.com, Rynn.Wu@mediatek.com,
        linux-media@vger.kernel.org, srv_heupstream@mediatek.com
Subject: Re: [RFC PATCH V0 1/7] [media] dt-bindings: mt8183: Add binding for
 DIP shared memory
Message-ID: <20190209155907.rbgwbdablndcesid@valkosipuli.retiisi.org.uk>
References: <1549020091-42064-1-git-send-email-frederic.chen@mediatek.com>
 <1549020091-42064-2-git-send-email-frederic.chen@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1549020091-42064-2-git-send-email-frederic.chen@mediatek.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Frederic,

Could you cc the devicetree list, please?

On Fri, Feb 01, 2019 at 07:21:25PM +0800, Frederic Chen wrote:
> This patch adds the binding for describing the shared memory
> used to exchange configuration and tuning data between the
> co-processor and Digital Image Processing (DIP) unit of the
> camera ISP system on Mediatek SoCs.
> 
> Signed-off-by: Frederic Chen <frederic.chen@mediatek.com>
> ---
>  .../mediatek,reserve-memory-dip_smem.txt           | 45 ++++++++++++++++++++++
>  1 file changed, 45 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/reserved-memory/mediatek,reserve-memory-dip_smem.txt
> 
> diff --git a/Documentation/devicetree/bindings/reserved-memory/mediatek,reserve-memory-dip_smem.txt b/Documentation/devicetree/bindings/reserved-memory/mediatek,reserve-memory-dip_smem.txt
> new file mode 100644
> index 0000000..0ded478
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/reserved-memory/mediatek,reserve-memory-dip_smem.txt
> @@ -0,0 +1,45 @@
> +Mediatek DIP Shared Memory binding
> +
> +This binding describes the shared memory, which serves the purpose of
> +describing the shared memory region used to exchange data between Digital
> +Image Processing (DIP) and co-processor in Mediatek SoCs.
> +
> +The co-processor doesn't have the iommu so we need to use the physical
> +address to access the shared buffer in the firmware.
> +
> +The Digital Image Processing (DIP) can access memory through mt8183 IOMMU so
> +it can use dma address to access the memory region.
> +(See iommu/mediatek,iommu.txt for the detailed description of Mediatek IOMMU)

What kind of purpose is the memory used for? Buffers containing video data,
or something else? Could the buffer objects be mapped on the devices
based on the need instead?

> +
> +
> +Required properties:
> +
> +- compatible: must be "mediatek,reserve-memory-dip_smem"
> +
> +- reg: required for static allocation (see reserved-memory.txt for
> +  the detailed usage)
> +
> +- alloc-range: required for dynamic allocation. The range must
> +  between 0x00000400 and 0x100000000 due to the co-processer's
> +  addressing limitation
> +
> +- size: required for dynamic allocation. The unit is bytes.
> +  If you want to enable the full feature of Digital Processing Unit,
> +  you need 20 MB at least.
> +
> +
> +Example:
> +
> +The following example shows the DIP shared memory setup for MT8183.
> +
> +	reserved-memory {
> +		#address-cells = <2>;
> +		#size-cells = <2>;
> +		ranges;
> +		reserve-memory-isp_smem {
> +			compatible = "mediatek,reserve-memory-dip_smem";
> +			size = <0 0x1400000>;
> +			alignment = <0 0x1000>;
> +			alloc-ranges = <0 0x40000000 0 0x50000000>;
> +		};
> +	};

-- 
Kind regards,

Sakari Ailus
