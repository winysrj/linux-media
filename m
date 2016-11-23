Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:33309 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753420AbcKWByZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Nov 2016 20:54:25 -0500
Message-ID: <1479866054.8964.21.camel@mtksdaap41>
Subject: Re: [PATCH v6 3/3] arm: dts: mt2701: Add node for Mediatek JPEG
 Decoder
From: Rick Chang <rick.chang@mediatek.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "Rob Herring" <robh+dt@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <srv_heupstream@mediatek.com>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>
Date: Wed, 23 Nov 2016 09:54:14 +0800
In-Reply-To: <badf8125-27ed-9c5b-fbc0-75716ffdfb0e@xs4all.nl>
References: <1479353915-5043-1-git-send-email-rick.chang@mediatek.com>
         <1479353915-5043-4-git-send-email-rick.chang@mediatek.com>
         <d602365a-e87b-5bae-8698-bd43063ef079@xs4all.nl>
         <1479784905.8964.15.camel@mtksdaap41>
         <badf8125-27ed-9c5b-fbc0-75716ffdfb0e@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tue, 2016-11-22 at 13:43 +0100, Hans Verkuil wrote:
> On 22/11/16 04:21, Rick Chang wrote:
> > Hi Hans,
> >
> > On Mon, 2016-11-21 at 15:51 +0100, Hans Verkuil wrote:
> >> On 17/11/16 04:38, Rick Chang wrote:
> >>> Signed-off-by: Rick Chang <rick.chang@mediatek.com>
> >>> Signed-off-by: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
> >>> ---
> >>> This patch depends on:
> >>>   CCF "Add clock support for Mediatek MT2701"[1]
> >>>   iommu and smi "Add the dtsi node of iommu and smi for mt2701"[2]
> >>>
> >>> [1] http://lists.infradead.org/pipermail/linux-mediatek/2016-October/007271.html
> >>> [2] https://patchwork.kernel.org/patch/9164013/
> >>
> >> I assume that 1 & 2 will appear in 4.10? So this patch needs to go in
> >> after the
> >> other two are merged in 4.10?
> >>
> >> Regards,
> >>
> >> 	Hans
> >
> > [1] will appear in 4.10, but [2] will appear latter than 4.10.So this
> > patch needs to go in after [1] & [2] will be merged in 4.11.
> 
> So what should I do? Merge the driver for 4.11 and wait with this patch
> until [2] is merged in 4.11? Does that sound reasonable?
> 
> Regards,
> 
> 	Hans

What do you think about this? You merge the driver first and I send this
patch again after [1] & [2] is merged.



