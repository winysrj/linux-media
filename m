Return-Path: <SRS0=TC89=RZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F795C43381
	for <linux-media@archiver.kernel.org>; Fri, 22 Mar 2019 00:00:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CF8F21925
	for <linux-media@archiver.kernel.org>; Fri, 22 Mar 2019 00:00:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbfCVAAx (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 21 Mar 2019 20:00:53 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:54014 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726377AbfCVAAx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Mar 2019 20:00:53 -0400
X-UUID: 8a50bf25e92b470ba1371685864e0274-20190322
X-UUID: 8a50bf25e92b470ba1371685864e0274-20190322
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw02.mediatek.com
        (envelope-from <jungo.lin@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 1485215290; Fri, 22 Mar 2019 08:00:46 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs01n1.mediatek.inc (172.21.101.68) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 22 Mar 2019 08:00:45 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 22 Mar 2019 08:00:45 +0800
Message-ID: <1553212845.7066.3.camel@mtksdccf07>
Subject: Re: [RFC PATCH V0 7/7] [media] platform: mtk-isp: Add Mediatek ISP
 Pass 1 driver
From:   Jungo Lin <jungo.lin@mediatek.com>
To:     Tomasz Figa <tfiga@chromium.org>
CC:     <frankie_chiu@mediatek.com>,
        Sean Cheng =?UTF-8?Q?=28=E9=84=AD=E6=98=87=E5=BC=98=29?= 
        <Sean.Cheng@mediatek.com>,
        Frederic Chen <frederic.chen@mediatek.com>,
        Rynn Wu =?UTF-8?Q?=28=E5=90=B3=E8=82=B2=E6=81=A9=29?= 
        <Rynn.Wu@mediatek.com>,
        Christie Yu =?UTF-8?Q?=28=E6=B8=B8=E9=9B=85=E6=83=A0=29?= 
        <christie.yu@mediatek.com>, <srv_heupstream@mediatek.com>,
        Holmes Chiou =?UTF-8?Q?=28=E9=82=B1=E6=8C=BA=29?= 
        <holmes.chiou@mediatek.com>, <seraph_huang@mediatek.com>,
        Jerry-ch Chen <Jerry-ch.Chen@mediatek.com>,
        <yuzhao@chromium.org>, <ryan_yu@mediatek.com>,
        Sj Huang <sj.huang@mediatek.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        <linux-mediatek@lists.infradead.org>, <zwisler@chromium.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg 
        Roedel <joro@8bytes.org>," <linux-arm-kernel@lists.infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Ryan Yu =?UTF-8?Q?=28=E4=BD=99=E5=AD=9F=E4=BF=AE=29?= 
        <ryan.yu@mediatek.com>,
        Seraph Huang =?UTF-8?Q?=28=E9=BB=83=E5=9C=8B=E9=9B=84=29?= 
        <Seraph.Huang@mediatek.com>,
        Frankie Chiu =?UTF-8?Q?=28=E9=82=B1=E6=96=87=E5=87=B1=29?= 
        <frankie.chiu@mediatek.com>
Date:   Fri, 22 Mar 2019 08:00:45 +0800
In-Reply-To: <CAAFQd5Addbh8cQBwKnW_g_KWBO6wPbF6MJXX7+gxDmOPg9+zmQ@mail.gmail.com>
References: <1549348966-14451-1-git-send-email-frederic.chen@mediatek.com>
         <1549348966-14451-8-git-send-email-frederic.chen@mediatek.com>
         <CAAFQd5CWdZUXVb4F9BLhQdN8WHjzA8acPDx1i+WcoudsdGsfUg@mail.gmail.com>
         <1550372163.11724.59.camel@mtksdccf07>
         <CAAFQd5CaXz_Lqz8NhGK4DvaxPvuYLj-Y73sG7wFaqW44j+tZQw@mail.gmail.com>
         <1550647867.11724.80.camel@mtksdccf07>
         <CAAFQd5Addbh8cQBwKnW_g_KWBO6wPbF6MJXX7+gxDmOPg9+zmQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-MTK:  N
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, 2019-03-21 at 12:33 +0900, Tomasz Figa wrote:
> On Wed, Feb 20, 2019 at 4:31 PM Jungo Lin <jungo.lin@mediatek.com> wrote:
> >
> > On Tue, 2019-02-19 at 17:51 +0900, Tomasz Figa wrote:
> > > Hi Jungo,
> > >
> > > On Sun, Feb 17, 2019 at 11:56 AM Jungo Lin <jungo.lin@mediatek.com> wrote:
> > > >
> > > > On Wed, 2019-02-13 at 18:50 +0900, Tomasz Figa wrote:
> > > > > (() . ( strHi Frederic, Jungo,
> > > > >
> > > > > On Tue, Feb 5, 2019 at 3:43 PM Frederic Chen <frederic.chen@mediatek.com> wrote:
> > > > > >
> > > > > > From: Jungo Lin <jungo.lin@mediatek.com>
> > > > > >
> > > > > > This patch adds the driver for Pass unit in Mediatek's camera
> > > > > > ISP system. Pass 1 unit is embedded in Mediatek SOCs. It
> > > > > > provides RAW processing which includes optical black correction,
> > > > > > defect pixel correction, W/IR imbalance correction and lens
> > > > > > shading correction.
> > > > > >
> > > > > > The mtk-isp directory will contain drivers for multiple IP
> > > > > > blocks found in Mediatek ISP system. It will include ISP Pass 1
> > > > > > driver, sensor interface driver, DIP driver and face detection
> > > > > > driver.
> > > > >
> > > > > Thanks for the patches! Please see my comments inline.
> > > > >
> > > >
> > > > Dear Thomas:
> > > >
> > > > Thanks for your comments.
> > > >
> > > > We will revise the source codes based on your comments.
> > > > Since there are many comments to fix/revise, we will categorize &
> > > > prioritize these with below list:
> > > >
> > > > 1. Coding style issues.
> > > > 2. Coding defects, including unused codes.
> > > > 3. Driver architecture refactoring, such as removing mtk_cam_ctx,
> > > > unnecessary abstraction layer, etc.
> > > >
> > >
> > > Thanks for replying to the comments!
> > >
> > > Just to clarify, there is no need to hurry with resending a next patch
> > > set with only a subset of the changes. Please take your time to
> > > address all the comments before sending the next revision. This
> > > prevents forgetting about some remaining comments and also lets other
> > > reviewers come with new comments or some alternative ideas for already
> > > existing comments. Second part of my review is coming too.
> > >
> > > P.S. Please avoid top-posting on mailing lists. If replying to a
> > > message, please reply below the related part of that message. (I've
> > > moved your reply to the place in the email where it should be.)
> > >
> > > [snip]
> >
> > Hi, Tomasz,
> >
> > Thanks for your advice.
> > We will prepare the next patch set after all comments are revised.
> >
> >
> > > > > > +       phys_addr_t paddr;
> > > > >
> > > > > We shouldn't need physical address either. I suppose this is for the
> > > > > SCP, but then it should be a DMA address obtained from dma_map_*()
> > > > > with struct device pointer of the SCP.
> > > > >
> > > >
> > > > Yes, this physical address is designed for SCP.
> > > > For tuning buffer, it will be touched by SCP and
> > > > SCP can't get the physical address by itself. So we need to get
> > > > this physical address in the kernel space via mtk_cam_smem_iova_to_phys
> > > > function call and pass it to the SCP. At the same time, DMA address
> > > > (daddr) is used for ISP HW.
> > > >
> > >
> > > Right, but my point is that in the kernel phys_addr_t is the physical
> > > address from the CPU point of view. Any address from device point of
> > > view is dma_addr_t and should be obtained from the DMA mapping API
> > > (even if it's numerically the same as physical address).
> > >
> >
> > OK.
> > In order to clarify the address usage, is it ok to rename "dma_addr_t
> > scp_addr"?
> 
> Sounds good to me.
> 
> > Moreover, below function will be also renamed.
> > dma_addr_t mtk_cam_smem_iova_to_scp_phys(struct device *dev,
> >                                       dma_addr_t iova)
> 
> Perhaps mtk_cam_smem_iova_to_scp_addr() for consistency with the
> struct field above?


Ok, we will align the function name to struct field.
This fix will be included in v1 version.

Thanks for your comments.

Best regards,


Jungo


