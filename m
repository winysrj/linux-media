Return-Path: <SRS0=QP2W=QQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D660C282C4
	for <linux-media@archiver.kernel.org>; Sat,  9 Feb 2019 15:59:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5840B21919
	for <linux-media@archiver.kernel.org>; Sat,  9 Feb 2019 15:59:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbfBIP7x (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 9 Feb 2019 10:59:53 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54138 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726894AbfBIP7x (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 9 Feb 2019 10:59:53 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 9BD08634C7D;
        Sat,  9 Feb 2019 17:59:35 +0200 (EET)
Received: from sailus by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1gsV2V-0000wx-Dm; Sat, 09 Feb 2019 17:59:35 +0200
Date:   Sat, 9 Feb 2019 17:59:35 +0200
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
Subject: Re: [RFC PATCH V0 3/7] [media] dt-bindings: mt8183: Added DIP-SMEM
 dt-bindings
Message-ID: <20190209155935.afrrtf3twjmj23sm@valkosipuli.retiisi.org.uk>
References: <1549020091-42064-1-git-send-email-frederic.chen@mediatek.com>
 <1549020091-42064-4-git-send-email-frederic.chen@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1549020091-42064-4-git-send-email-frederic.chen@mediatek.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Frederic,

Thanks for the patchset.

Could you also cc the devicetree list, please?

On Fri, Feb 01, 2019 at 07:21:27PM +0800, Frederic Chen wrote:
> This patch adds the DT binding documentation for the shared memory
> between DIP (Digital Image Processing) unit of the camera ISP system
> and the co-processor in Mediatek SoCs.
> 
> Signed-off-by: Frederic Chen <frederic.chen@mediatek.com>
> ---
>  .../bindings/media/mediatek,dip_smem.txt           | 29 ++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/mediatek,dip_smem.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/mediatek,dip_smem.txt b/Documentation/devicetree/bindings/media/mediatek,dip_smem.txt
> new file mode 100644
> index 0000000..5533721
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/mediatek,dip_smem.txt
> @@ -0,0 +1,29 @@
> +Mediatek ISP Shared Memory Device
> +
> +Mediatek ISP Shared Memory Device is used to manage shared memory
> +among CPU, ISP IPs and coprocessor. It is associated with a reserved
> +memory region (Please see Documentation\devicetree\bindings\
> +reserved-memory\mediatek,reserve-memory-isp_smem.txt) and

s/\\/\//g;

> +and provide the context to allocate memory with dma addresses.
> +
> +Required properties:
> +- compatible: Should be "mediatek,isp_smem"

s/Should/Shall/

> +
> +- iommus: should point to the respective IOMMU block with master port

s/should/shall/

> +  as argument. Please set the ports which may be accessed
> +  through the common path. You can see
> +  Documentation/devicetree/bindings/iommu/mediatek,iommu.txt
> +  for the detail.
> +
> +- mediatek,larb: must contain the local arbiters in the current Socs.

Perhaps "SoCs"?

> +  Please set the larb of camsys for Pass 1 and imgsys for DIP, or both
> +  if you are using all the camera function. You can see
> +  Documentation/devicetree/bindings/memory-controllers/
> +  mediatek,smi-larb.txt for the detail.
> +
> +Example:
> +	isp_smem: isp_smem {
> +		compatible = "mediatek,isp_smem";
> +		mediatek,larb = <&larb5>;
> +		iommus = <&iommu M4U_PORT_CAM_IMGI>;
> +	};

-- 
Kind regards,

Sakari Ailus
