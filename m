Return-Path: <SRS0=4gUs=QT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBDC3C282C4
	for <linux-media@archiver.kernel.org>; Tue, 12 Feb 2019 09:37:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE287218A3
	for <linux-media@archiver.kernel.org>; Tue, 12 Feb 2019 09:37:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728087AbfBLJhi (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Feb 2019 04:37:38 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:42890 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726003AbfBLJhi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Feb 2019 04:37:38 -0500
X-UUID: d13d239f94b14bf4ac887b4b633ca697-20190212
X-UUID: d13d239f94b14bf4ac887b4b633ca697-20190212
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw02.mediatek.com
        (envelope-from <frederic.chen@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 2048410000; Tue, 12 Feb 2019 17:37:24 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs01n2.mediatek.inc (172.21.101.79) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Tue, 12 Feb 2019 17:37:22 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Tue, 12 Feb 2019 17:37:22 +0800
Message-ID: <1549964242.27207.11.camel@mtksdccf07>
Subject: Re: [RFC PATCH V0 1/7] [media] dt-bindings: mt8183: Add binding for
 DIP shared memory
From:   Frederic Chen <frederic.chen@mediatek.com>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
CC:     <devicetree@vger.kernel.org>, Sakari Ailus <sakari.ailus@iki.fi>,
        <hans.verkuil@cisco.com>,
        <laurent.pinchart+renesas@ideasonboard.com>, <tfiga@chromium.org>,
        <matthias.bgg@gmail.com>, <mchehab@kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>, <Sean.Cheng@mediatek.com>,
        <sj.huang@mediatek.com>, <christie.yu@mediatek.com>,
        <holmes.chiou@mediatek.com>, <Jerry-ch.Chen@mediatek.com>,
        <jungo.lin@mediatek.com>, <Rynn.Wu@mediatek.com>,
        <linux-media@vger.kernel.org>, <srv_heupstream@mediatek.com>
Date:   Tue, 12 Feb 2019 17:37:22 +0800
In-Reply-To: <20190209181705.GB4505@pendragon.ideasonboard.com>
References: <1549020091-42064-1-git-send-email-frederic.chen@mediatek.com>
         <1549020091-42064-2-git-send-email-frederic.chen@mediatek.com>
         <20190209155907.rbgwbdablndcesid@valkosipuli.retiisi.org.uk>
         <20190209181705.GB4505@pendragon.ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
X-TM-SNTS-SMTP: 15DFA9F8853A480109641174D41DD23EE4B87532B6C53798FB2B77326F4856F52000:8
X-MTK:  N
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Dear Laurent and Sakari,

I appreciate your messages.

On Sat, 2019-02-09 at 20:17 +0200, Laurent Pinchart wrote:
> On Sat, Feb 09, 2019 at 05:59:07PM +0200, Sakari Ailus wrote:
> > Hi Frederic,
> > 
> > Could you cc the devicetree list, please?
> > 
> > On Fri, Feb 01, 2019 at 07:21:25PM +0800, Frederic Chen wrote:
> > > This patch adds the binding for describing the shared memory
> > > used to exchange configuration and tuning data between the
> > > co-processor and Digital Image Processing (DIP) unit of the
> > > camera ISP system on Mediatek SoCs.
> > > 
> > > Signed-off-by: Frederic Chen <frederic.chen@mediatek.com>
> > > ---
> > >  .../mediatek,reserve-memory-dip_smem.txt           | 45 ++++++++++++++++++++++
> > >  1 file changed, 45 insertions(+)
> > >  create mode 100644 Documentation/devicetree/bindings/reserved-memory/mediatek,reserve-memory-dip_smem.txt
> > > 
> > > diff --git a/Documentation/devicetree/bindings/reserved-memory/mediatek,reserve-memory-dip_smem.txt b/Documentation/devicetree/bindings/reserved-memory/mediatek,reserve-memory-dip_smem.txt
> > > new file mode 100644
> > > index 0000000..0ded478
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/reserved-memory/mediatek,reserve-memory-dip_smem.txt
> > > @@ -0,0 +1,45 @@
> > > +Mediatek DIP Shared Memory binding
> > > +
> > > +This binding describes the shared memory, which serves the purpose of
> > > +describing the shared memory region used to exchange data between Digital
> > > +Image Processing (DIP) and co-processor in Mediatek SoCs.
> > > +
> > > +The co-processor doesn't have the iommu so we need to use the physical
> > > +address to access the shared buffer in the firmware.
> > > +
> > > +The Digital Image Processing (DIP) can access memory through mt8183 IOMMU so
> > > +it can use dma address to access the memory region.
> > > +(See iommu/mediatek,iommu.txt for the detailed description of Mediatek IOMMU)
> > 
> > What kind of purpose is the memory used for? Buffers containing video data,
> > or something else? Could the buffer objects be mapped on the devices
> > based on the need instead?

The memory buffers contain camera 3A tuning data, which are used by the
co-processor and DIP IP. About mapping the buffer based on the need
instead, I’m not sure I understand this point. Do you mean that
allocating and mapping the memory dynamically?

> 
> And could CMA be used when physically contiguous memory is needed ?

DIP driver does not use CMA now, because the first version will be used
by CrOS but CrOS won’t enable CMA.

> 
> > > +
> > > +
> > > +Required properties:
> > > +
> > > +- compatible: must be "mediatek,reserve-memory-dip_smem"
> > > +
> > > +- reg: required for static allocation (see reserved-memory.txt for
> > > +  the detailed usage)
> > > +
> > > +- alloc-range: required for dynamic allocation. The range must
> > > +  between 0x00000400 and 0x100000000 due to the co-processer's
> > > +  addressing limitation
> > > +
> > > +- size: required for dynamic allocation. The unit is bytes.
> > > +  If you want to enable the full feature of Digital Processing Unit,
> > > +  you need 20 MB at least.
> > > +
> > > +
> > > +Example:
> > > +
> > > +The following example shows the DIP shared memory setup for MT8183.
> > > +
> > > +	reserved-memory {
> > > +		#address-cells = <2>;
> > > +		#size-cells = <2>;
> > > +		ranges;
> > > +		reserve-memory-isp_smem {
> > > +			compatible = "mediatek,reserve-memory-dip_smem";
> > > +			size = <0 0x1400000>;
> > > +			alignment = <0 0x1000>;
> > > +			alloc-ranges = <0 0x40000000 0 0x50000000>;
> > > +		};
> > > +	};
> 

Sincerely,

Frederic Chen


