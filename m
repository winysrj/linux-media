Return-Path: <SRS0=4gUs=QT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60840C282C4
	for <linux-media@archiver.kernel.org>; Tue, 12 Feb 2019 09:50:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 368D22083E
	for <linux-media@archiver.kernel.org>; Tue, 12 Feb 2019 09:50:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728208AbfBLJuQ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Feb 2019 04:50:16 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:60602 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727600AbfBLJuP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Feb 2019 04:50:15 -0500
X-UUID: 21ac637db0604c1a8f7893bdcdb291fc-20190212
X-UUID: 21ac637db0604c1a8f7893bdcdb291fc-20190212
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw02.mediatek.com
        (envelope-from <frederic.chen@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 257948865; Tue, 12 Feb 2019 17:50:08 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs01n1.mediatek.inc (172.21.101.68) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Tue, 12 Feb 2019 17:50:00 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Tue, 12 Feb 2019 17:50:00 +0800
Message-ID: <1549965000.29488.4.camel@mtksdccf07>
Subject: Re: [RFC PATCH V0 3/7] [media] dt-bindings: mt8183: Added DIP-SMEM
 dt-bindings
From:   Frederic Chen <frederic.chen@mediatek.com>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
CC:     <devicetree@vger.kernel.org>, <hans.verkuil@cisco.com>,
        <laurent.pinchart+renesas@ideasonboard.com>, <tfiga@chromium.org>,
        <matthias.bgg@gmail.com>, <mchehab@kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>, <Sean.Cheng@mediatek.com>,
        <sj.huang@mediatek.com>, <christie.yu@mediatek.com>,
        <holmes.chiou@mediatek.com>, <Jerry-ch.Chen@mediatek.com>,
        <jungo.lin@mediatek.com>, <Rynn.Wu@mediatek.com>,
        <linux-media@vger.kernel.org>, <srv_heupstream@mediatek.com>
Date:   Tue, 12 Feb 2019 17:50:00 +0800
In-Reply-To: <20190209182034.GC4505@pendragon.ideasonboard.com>
References: <1549020091-42064-1-git-send-email-frederic.chen@mediatek.com>
         <1549020091-42064-4-git-send-email-frederic.chen@mediatek.com>
         <20190209155935.afrrtf3twjmj23sm@valkosipuli.retiisi.org.uk>
         <20190209182034.GC4505@pendragon.ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
X-MTK:  N
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Dear Laurent and Sakari,


On Sat, 2019-02-09 at 20:20 +0200, Laurent Pinchart wrote:
> Hello Frederic,
> 
> On Sat, Feb 09, 2019 at 05:59:35PM +0200, Sakari Ailus wrote:
> > Hi Frederic,
> > 
> > Thanks for the patchset.
> > 
> > Could you also cc the devicetree list, please?
> > 
> > On Fri, Feb 01, 2019 at 07:21:27PM +0800, Frederic Chen wrote:
> > > This patch adds the DT binding documentation for the shared memory
> > > between DIP (Digital Image Processing) unit of the camera ISP system
> > > and the co-processor in Mediatek SoCs.
> > > 
> > > Signed-off-by: Frederic Chen <frederic.chen@mediatek.com>
> > > ---
> > >  .../bindings/media/mediatek,dip_smem.txt           | 29 ++++++++++++++++++++++
> > >  1 file changed, 29 insertions(+)
> > >  create mode 100644 Documentation/devicetree/bindings/media/mediatek,dip_smem.txt
> > > 
> > > diff --git a/Documentation/devicetree/bindings/media/mediatek,dip_smem.txt b/Documentation/devicetree/bindings/media/mediatek,dip_smem.txt
> > > new file mode 100644
> > > index 0000000..5533721
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/media/mediatek,dip_smem.txt
> > > @@ -0,0 +1,29 @@
> > > +Mediatek ISP Shared Memory Device
> > > +
> > > +Mediatek ISP Shared Memory Device is used to manage shared memory
> > > +among CPU, ISP IPs and coprocessor. It is associated with a reserved
> > > +memory region (Please see Documentation\devicetree\bindings\
> > > +reserved-memory\mediatek,reserve-memory-isp_smem.txt) and
> > 
> > s/\\/\//g;
> > 
> > > +and provide the context to allocate memory with dma addresses.
> 
> Does this represent a real device (as in IP core) in the SoC ? There
> seems to be no driver associated with the compatible string defined
> herein in this patch series, what is this node used for ?

It does not represent a real device. It is used for creating the
DIP-specific vb2 buffer allocation context (implemented
in /drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-smem-drv.c).
The compatible string has been renamed as “mediatek,dip_smem” in this
patch series and I will correct it in this binding document.

> 
> > > +Required properties:
> > > +- compatible: Should be "mediatek,isp_smem"
> > 
> > s/Should/Shall/
> > 
> > > +
> > > +- iommus: should point to the respective IOMMU block with master port
> > 
> > s/should/shall/
> > 
> > > +  as argument. Please set the ports which may be accessed
> > > +  through the common path. You can see
> > > +  Documentation/devicetree/bindings/iommu/mediatek,iommu.txt
> > > +  for the detail.
> > > +
> > > +- mediatek,larb: must contain the local arbiters in the current Socs.
> > 
> > Perhaps "SoCs"?
> > 
> > > +  Please set the larb of camsys for Pass 1 and imgsys for DIP, or both
> > > +  if you are using all the camera function. You can see
> > > +  Documentation/devicetree/bindings/memory-controllers/
> > > +  mediatek,smi-larb.txt for the detail.
> > > +
> > > +Example:
> > > +	isp_smem: isp_smem {
> > > +		compatible = "mediatek,isp_smem";
> > > +		mediatek,larb = <&larb5>;
> > > +		iommus = <&iommu M4U_PORT_CAM_IMGI>;
> > > +	};
> 


Sincerely,

Frederic Chen


