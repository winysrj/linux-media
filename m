Return-Path: <SRS0=TC89=RZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B67AEC43381
	for <linux-media@archiver.kernel.org>; Fri, 22 Mar 2019 00:18:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 829E321900
	for <linux-media@archiver.kernel.org>; Fri, 22 Mar 2019 00:18:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbfCVASE (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 21 Mar 2019 20:18:04 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:24189 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726944AbfCVASD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Mar 2019 20:18:03 -0400
X-UUID: 1ec1967452424b2bb3341bf18a1904ad-20190322
X-UUID: 1ec1967452424b2bb3341bf18a1904ad-20190322
Received: from mtkcas09.mediatek.inc [(172.21.101.178)] by mailgw02.mediatek.com
        (envelope-from <jungo.lin@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 1215901566; Fri, 22 Mar 2019 08:17:59 +0800
Received: from mtkcas09.mediatek.inc (172.21.101.178) by
 mtkmbs03n1.mediatek.inc (172.21.101.181) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 22 Mar 2019 08:17:57 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkcas09.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 22 Mar 2019 08:17:57 +0800
Message-ID: <1553213877.7066.16.camel@mtksdccf07>
Subject: Re: [RFC PATCH V0 7/7] [media] platform: mtk-isp: Add Mediatek ISP
 Pass 1 driver
From:   Jungo Lin <jungo.lin@mediatek.com>
To:     Tomasz Figa <tfiga@chromium.org>
CC:     Frederic Chen <frederic.chen@mediatek.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg 
        Roedel <joro@8bytes.org>," <linux-arm-kernel@lists.infradead.org>,
        Sean Cheng =?UTF-8?Q?=28=E9=84=AD=E6=98=87=E5=BC=98=29?= 
        <Sean.Cheng@mediatek.com>, "Sj Huang" <sj.huang@mediatek.com>,
        Christie Yu =?UTF-8?Q?=28=E6=B8=B8=E9=9B=85=E6=83=A0=29?= 
        <christie.yu@mediatek.com>,
        Holmes Chiou =?UTF-8?Q?=28=E9=82=B1=E6=8C=BA=29?= 
        <holmes.chiou@mediatek.com>,
        Jerry-ch Chen <Jerry-ch.Chen@mediatek.com>,
        Rynn Wu =?UTF-8?Q?=28=E5=90=B3=E8=82=B2=E6=81=A9=29?= 
        <Rynn.Wu@mediatek.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        <srv_heupstream@mediatek.com>, <yuzhao@chromium.org>,
        <zwisler@chromium.org>
Date:   Fri, 22 Mar 2019 08:17:57 +0800
In-Reply-To: <CAAFQd5C=dmoUU9=FdkaeErSFVpA--uFZJ0P1jrb3DTXFZ_tdpg@mail.gmail.com>
References: <1549348966-14451-1-git-send-email-frederic.chen@mediatek.com>
         <1549348966-14451-8-git-send-email-frederic.chen@mediatek.com>
         <CAAFQd5BGFmTbRF+LdRvXs0MBZifRd9zB_+OT6Xwo=dzwqajgGA@mail.gmail.com>
         <1552378607.13953.71.camel@mtksdccf07>
         <CAAFQd5C=dmoUU9=FdkaeErSFVpA--uFZJ0P1jrb3DTXFZ_tdpg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-MTK:  N
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, 2019-03-21 at 12:48 +0900, Tomasz Figa wrote:
> On Tue, Mar 12, 2019 at 5:16 PM Jungo Lin <jungo.lin@mediatek.com> wrote:
> >
> > On Thu, 2019-03-07 at 19:04 +0900, Tomasz Figa wrote:
> [snip]
> > > > +struct mtk_cam_mem2mem2_device {
> > > > +       const char *name;
> > > > +       const char *model;
> > >
> > > For both of the fields above, they seem to be always
> > > MTK_CAM_DEV_P1_NAME, so we can just use the macro directly whenever
> > > needed. No need for this indirection.
> > >
> >
> > OK. These two fields will be removed in next patch.
> >
> > > > +       struct device *dev;
> > > > +       int num_nodes;
> > > > +       struct mtk_cam_dev_video_device *nodes;
> > > > +       const struct vb2_mem_ops *vb2_mem_ops;
> > >
> > > This is always "vb2_dma_contig_memops", so it can be used directly.
> > >
> >
> > Ditto.
> >
> > > > +       unsigned int buf_struct_size;
> > >
> > > This is always sizeof(struct mtk_cam_dev_buffer), so no need to save
> > > it in the struct.
> > >
> >
> > Ditto.
> >
> > > > +       int streaming;
> > > > +       struct v4l2_device *v4l2_dev;
> > > > +       struct media_device *media_dev;
> > >
> > > These 2 fields are already in mtk_cam_dev which is a superclass of
> > > this struct. One can just access them from there directly.
> > >
> >
> > Ditto.
> >
> > > > +       struct media_pipeline pipeline;
> > > > +       struct v4l2_subdev subdev;
> > >
> > > Could you remind me what was the media topology exposed by this
> > > driver? This is already the second subdev I spotted in this patch,
> > > which looks strange.
> > >
> >
> >
> > For sub-device design, we will remove the sub-device for CIO and keep
> > only one sub-device for ISP driver in next patch. We will also provide
> > the media topology in RFC v1 patch to clarify.
> >
> > > > +       struct media_pad *subdev_pads;
> > > > +       struct v4l2_file_operations v4l2_file_ops;
> > > > +       const struct file_operations fops;
> > > > +};
> > >
> > > Given most of the comments above, it looks like the remaining useful
> > > fields in this struct could be just moved to mtk_cam_dev, without the
> > > need for this separate struct.
> > >
> >
> > This is the final revision for these two structures.
> > Do you suggest to merge it to simplify?
> >
> > struct mtk_cam_mem2mem2_device {
> >         struct mtk_cam_video_device *nodes;
> >         struct media_pipeline pipeline;
> >         struct v4l2_subdev subdev;
> >         struct media_pad *subdev_pads;
> > };
> >
> > struct mtk_cam_dev {
> >         struct platform_device *pdev;
> >         struct mtk_cam_video_device     mem2mem2_nodes[MTK_CAM_DEV_NODE_MAX];
> >         struct mtk_cam_mem2mem2_device mem2mem2;
> >         struct mtk_cam_io_connection cio;
> >         struct v4l2_device v4l2_dev;
> >         struct media_device media_dev;
> >         struct mtk_cam_ctx ctx;
> >         struct v4l2_async_notifier notifier;
> > };
> >
> 
> I feel like there is not much benefit in having this split. Similarly,
> I'm not sure if there is a reason to have separate structs for
> mtk_cam_io_connection and mtk_cam_ctx.
> 
> (Sorry, missed this one in previous reply.)
> 
> Best regards,
> Tomasz

Ok, agree your comment.
We will remove both mtk_cam_io_connection and mtk_cam_ctx and
merge those fields into mtk_cam_dev.

Thanks for your suggestion.

Best regards,


Jungo


