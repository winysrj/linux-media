Return-Path: <SRS0=TC89=RZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5017BC43381
	for <linux-media@archiver.kernel.org>; Fri, 22 Mar 2019 00:13:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1AF1421917
	for <linux-media@archiver.kernel.org>; Fri, 22 Mar 2019 00:13:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727378AbfCVANo (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 21 Mar 2019 20:13:44 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:45030 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726374AbfCVANo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Mar 2019 20:13:44 -0400
X-UUID: 30445ccfd60c434bafb39280caf2239d-20190322
X-UUID: 30445ccfd60c434bafb39280caf2239d-20190322
Received: from mtkcas09.mediatek.inc [(172.21.101.178)] by mailgw01.mediatek.com
        (envelope-from <jungo.lin@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 1471784933; Fri, 22 Mar 2019 08:13:38 +0800
Received: from MTKMBS01DR.mediatek.inc (172.21.101.111) by
 mtkmbs05n1.mediatek.inc (172.21.101.15) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 22 Mar 2019 08:13:36 +0800
Received: from mtkcas09.mediatek.inc (172.21.101.178) by
 mtkmbs01dr.mediatek.inc (172.21.101.111) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 22 Mar 2019 08:13:36 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkcas09.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 22 Mar 2019 08:13:30 +0800
Message-ID: <1553213610.7066.14.camel@mtksdccf07>
Subject: Re: [RFC PATCH V0 7/7] [media] platform: mtk-isp: Add Mediatek ISP
 Pass 1 driver
From:   Jungo Lin <jungo.lin@mediatek.com>
To:     Tomasz Figa <tfiga@chromium.org>
CC:     Sean Cheng =?UTF-8?Q?=28=E9=84=AD=E6=98=87=E5=BC=98=29?= 
        <Sean.Cheng@mediatek.com>,
        Frederic Chen <frederic.chen@mediatek.com>,
        "Rynn Wu =?UTF-8?Q?=28=E5=90=B3=E8=82=B2=E6=81=A9=29?=" 
        <Rynn.Wu@mediatek.com>,
        Christie Yu =?UTF-8?Q?=28=E6=B8=B8=E9=9B=85=E6=83=A0=29?= 
        <christie.yu@mediatek.com>, <srv_heupstream@mediatek.com>,
        Holmes Chiou =?UTF-8?Q?=28=E9=82=B1=E6=8C=BA=29?= 
        <holmes.chiou@mediatek.com>,
        "Jerry-ch Chen" <Jerry-ch.Chen@mediatek.com>,
        <yuzhao@chromium.org>, Sj Huang <sj.huang@mediatek.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        <linux-mediatek@lists.infradead.org>, <zwisler@chromium.org>,
        "Matthias Brugger" <matthias.bgg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg 
        Roedel <joro@8bytes.org>," <linux-arm-kernel@lists.infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Date:   Fri, 22 Mar 2019 08:13:30 +0800
In-Reply-To: <CAAFQd5C+Syovzh14PAppyC5gmWqx=Tr_yGpLdgaWHXYXQGCX+g@mail.gmail.com>
References: <1549348966-14451-1-git-send-email-frederic.chen@mediatek.com>
         <1549348966-14451-8-git-send-email-frederic.chen@mediatek.com>
         <CAAFQd5BGFmTbRF+LdRvXs0MBZifRd9zB_+OT6Xwo=dzwqajgGA@mail.gmail.com>
         <1552378607.13953.71.camel@mtksdccf07>
         <CAAFQd5C+Syovzh14PAppyC5gmWqx=Tr_yGpLdgaWHXYXQGCX+g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-MTK:  N
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, 2019-03-21 at 12:45 +0900, Tomasz Figa wrote:
> On Tue, Mar 12, 2019 at 5:16 PM Jungo Lin <jungo.lin@mediatek.com> wrote:
> >
> > On Thu, 2019-03-07 at 19:04 +0900, Tomasz Figa wrote:
> [snip]
> > > > diff --git a/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-smem-drv.c b/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-smem-drv.c
> > > > new file mode 100644
> > > > index 0000000..020c38c
> > > > --- /dev/null
> > > > +++ b/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-smem-drv.c
> > >
> > > I don't think we need any of the code that is in this file. We should
> > > just use the DMA API. We should be able to create appropriate reserved
> > > memory pools in DT and properly assign them to the right allocating
> > > devices.
> > >
> > > Skipping review of this file for the time being.
> > >
> >
> > For this file, we may need your help.
> > Its purpose is same as DIP SMEM driver.
> > It is used for creating the ISP P1 specific vb2 buffer allocation
> > context with reserved memory. Unfortunately, the implementation of
> > mtk_cam-smem-drive.c is our best solution now.
> >
> > Could you give us more hints how to implement?
> > Or do you think we could leverage the implementation from "Samsung S5P
> > Multi Format Codec driver"?
> > drivers/media/platform/s5p-mfc/s5p_mfc.c
> > - s5p_mfc_configure_dma_memory function
> >   - s5p_mfc_configure_2port_memory
> >      - s5p_mfc_alloc_memdev
> 
> I think we can indeed take some ideas from there. I need some time to
> check this and give you more details.
> 
> [snip]

Thanks for your support.
If you have any input, please kindly let us know.
We will list this revision in the to-do list of V1 version.
At the same time, we will also continue to investigate how to implement
based on current information.

> > > > +               }
> > > > +
> > > > +               dev_dbg(&isp_dev->pdev->dev, "streamed on sensor(%s)\n",
> > > > +                       cio->sensor->entity.name);
> > > > +
> > > > +               ret = mtk_cam_ctx_streamon(&isp_dev->ctx);
> > > > +               if (ret) {
> > > > +                       dev_err(&isp_dev->pdev->dev,
> > > > +                               "Pass 1 stream on failed (%d)\n", ret);
> > > > +                       return -EPERM;
> > > > +               }
> > > > +
> > > > +               isp_dev->mem2mem2.streaming = enable;
> > > > +
> > > > +               ret = mtk_cam_dev_queue_buffers(isp_dev, true);
> > > > +               if (ret)
> > > > +                       dev_err(&isp_dev->pdev->dev,
> > > > +                               "failed to queue initial buffers (%d)", ret);
> > > > +
> > > > +               dev_dbg(&isp_dev->pdev->dev, "streamed on Pass 1\n");
> > > > +       } else {
> > > > +               if (cio->sensor) {
> > >
> > > Is it possible to have cio->sensor NULL here? This function would have
> > > failed if it wasn't found when enabling.
> > >
> >
> > In the original design, it is protected to avoid abnormal double stream
> > off (s_stream) call from upper layer. For stability reason, it is better
> > to check.
> 
> If so, having some state (e.g. field in a struct) for tracking the
> streaming state would make the code much easier to understand.
> Also, the error message on the else case is totally misleading,
> because it complains about a missing sensor, rather than double
> s_stream.
> 
> [snip]

Yes, your suggestion is helpful.
We will correct our implementation to make it more clear in next
version.

> > Thanks for your valued comments on part 2.
> > It is helpful for us to make our driver implementation better.
> >
> > We'd like to know your opinion about the schedule for RFC V1.
> > Do you suggest us to send RFC V1 patch set after revising all comments
> > on part 1 & 2 or wait for part 3 review?
> 
> I'm going to be a bit busy for the next few days, so it may be a good
> idea to address the comments for parts 1, 2 and 3 and send RFC V1.
> Also, for the more general comments, please check if they don't apply
> to the other drivers too (DIP, FD, Seninf, MDP). Thanks in advance!
> 
> Best regards,
> Tomasz
> 

Ok, we plan to send our RFC V1 for ISP P1 driver next week after
revising current comments.
For DIP & FD drivers, they also have common implementations with P1
driver. We will sync current comments to them. For Seninf & MDP drivers.
we will share our coding style & coding defect issues to them.

Moreover, we will provide our V4L2_Compliance testing report from RFC
V1.

Best regards,


Jungo



> _______________________________________________
> Linux-mediatek mailing list
> Linux-mediatek@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-mediatek


