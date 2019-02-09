Return-Path: <SRS0=QP2W=QQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7A78C282C4
	for <linux-media@archiver.kernel.org>; Sat,  9 Feb 2019 18:17:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FF1B217D8
	for <linux-media@archiver.kernel.org>; Sat,  9 Feb 2019 18:17:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="nBD183x5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727173AbfBISRN (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 9 Feb 2019 13:17:13 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:60850 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727109AbfBISRM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 9 Feb 2019 13:17:12 -0500
Received: from pendragon.ideasonboard.com (85-76-143-97-nat.elisa-mobile.fi [85.76.143.97])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id F1A932E2;
        Sat,  9 Feb 2019 19:17:09 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1549736230;
        bh=t0GNSj2MkvQASbyGDRPGjxV1mW30FaJBbB9de/RdDjI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nBD183x5muW9TFd3D1A39fuZOygaD7IpVt4UdTyGzrXARx643CfWM0fw8nfTsn1I4
         gtY6fc8oPxJSXYhMbReIT9j59NyRBjcAM6DBeLwlC+qcuUIIdf7CfTXMYpaOc9oi9f
         Fs38M5ej4XXvZAtgRsZqPXPB3sFGiYyoEJYHzECg=
Date:   Sat, 9 Feb 2019 20:17:05 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Sakari Ailus <sakari.ailus@iki.fi>
Cc:     Frederic Chen <frederic.chen@mediatek.com>, hans.verkuil@cisco.com,
        laurent.pinchart+renesas@ideasonboard.com, tfiga@chromium.org,
        matthias.bgg@gmail.com, mchehab@kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, Sean.Cheng@mediatek.com,
        sj.huang@mediatek.com, christie.yu@mediatek.com,
        holmes.chiou@mediatek.com, Jerry-ch.Chen@mediatek.com,
        jungo.lin@mediatek.com, Rynn.Wu@mediatek.com,
        linux-media@vger.kernel.org, srv_heupstream@mediatek.com
Subject: Re: [RFC PATCH V0 1/7] [media] dt-bindings: mt8183: Add binding for
 DIP shared memory
Message-ID: <20190209181705.GB4505@pendragon.ideasonboard.com>
References: <1549020091-42064-1-git-send-email-frederic.chen@mediatek.com>
 <1549020091-42064-2-git-send-email-frederic.chen@mediatek.com>
 <20190209155907.rbgwbdablndcesid@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190209155907.rbgwbdablndcesid@valkosipuli.retiisi.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Sat, Feb 09, 2019 at 05:59:07PM +0200, Sakari Ailus wrote:
> Hi Frederic,
> 
> Could you cc the devicetree list, please?
> 
> On Fri, Feb 01, 2019 at 07:21:25PM +0800, Frederic Chen wrote:
> > This patch adds the binding for describing the shared memory
> > used to exchange configuration and tuning data between the
> > co-processor and Digital Image Processing (DIP) unit of the
> > camera ISP system on Mediatek SoCs.
> > 
> > Signed-off-by: Frederic Chen <frederic.chen@mediatek.com>
> > ---
> >  .../mediatek,reserve-memory-dip_smem.txt           | 45 ++++++++++++++++++++++
> >  1 file changed, 45 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/reserved-memory/mediatek,reserve-memory-dip_smem.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/reserved-memory/mediatek,reserve-memory-dip_smem.txt b/Documentation/devicetree/bindings/reserved-memory/mediatek,reserve-memory-dip_smem.txt
> > new file mode 100644
> > index 0000000..0ded478
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/reserved-memory/mediatek,reserve-memory-dip_smem.txt
> > @@ -0,0 +1,45 @@
> > +Mediatek DIP Shared Memory binding
> > +
> > +This binding describes the shared memory, which serves the purpose of
> > +describing the shared memory region used to exchange data between Digital
> > +Image Processing (DIP) and co-processor in Mediatek SoCs.
> > +
> > +The co-processor doesn't have the iommu so we need to use the physical
> > +address to access the shared buffer in the firmware.
> > +
> > +The Digital Image Processing (DIP) can access memory through mt8183 IOMMU so
> > +it can use dma address to access the memory region.
> > +(See iommu/mediatek,iommu.txt for the detailed description of Mediatek IOMMU)
> 
> What kind of purpose is the memory used for? Buffers containing video data,
> or something else? Could the buffer objects be mapped on the devices
> based on the need instead?

And could CMA be used when physically contiguous memory is needed ?

> > +
> > +
> > +Required properties:
> > +
> > +- compatible: must be "mediatek,reserve-memory-dip_smem"
> > +
> > +- reg: required for static allocation (see reserved-memory.txt for
> > +  the detailed usage)
> > +
> > +- alloc-range: required for dynamic allocation. The range must
> > +  between 0x00000400 and 0x100000000 due to the co-processer's
> > +  addressing limitation
> > +
> > +- size: required for dynamic allocation. The unit is bytes.
> > +  If you want to enable the full feature of Digital Processing Unit,
> > +  you need 20 MB at least.
> > +
> > +
> > +Example:
> > +
> > +The following example shows the DIP shared memory setup for MT8183.
> > +
> > +	reserved-memory {
> > +		#address-cells = <2>;
> > +		#size-cells = <2>;
> > +		ranges;
> > +		reserve-memory-isp_smem {
> > +			compatible = "mediatek,reserve-memory-dip_smem";
> > +			size = <0 0x1400000>;
> > +			alignment = <0 0x1000>;
> > +			alloc-ranges = <0 0x40000000 0 0x50000000>;
> > +		};
> > +	};

-- 
Regards,

Laurent Pinchart
