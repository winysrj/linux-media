Return-Path: <SRS0=WMbR=RY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 765A8C43381
	for <linux-media@archiver.kernel.org>; Thu, 21 Mar 2019 03:39:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 31885218AE
	for <linux-media@archiver.kernel.org>; Thu, 21 Mar 2019 03:39:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="U667uDvS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727586AbfCUDjZ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Mar 2019 23:39:25 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:46587 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726914AbfCUDjZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Mar 2019 23:39:25 -0400
Received: by mail-oi1-f196.google.com with SMTP id x188so2692343oia.13
        for <linux-media@vger.kernel.org>; Wed, 20 Mar 2019 20:39:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g8U6snetzO45J3uQhW+/669hYcocGezULFq1HgCm21M=;
        b=U667uDvSQt596UbF8FVBgcLUHCfTThjXQ2aXrqhl4+9otCw0yRH3rexJg/ubxRfbG6
         /qhMPXa79yMCiFz0Ot7ycsljgYwc9wIoX/RgZqQwLDJ7h3wOS57hv5uIqBt5ErA3QxSF
         fB1T6VL8eEd74unnfj32t6nYmT57JXyKmYzmI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g8U6snetzO45J3uQhW+/669hYcocGezULFq1HgCm21M=;
        b=GaLhVOde6FPFxiA0Sw9Fu/anRHNdAUA5MK1idUI6cxOGsoZQXfy2O1LRYVjSv5RPrF
         bqcPeRGkBtAXVgP6KBNB205NuB08WUI914JVbjVLpe3WESDK7EituXVCSc2qJHPzOQaw
         ZsPZ8TOddUcgTbH16mNRsc7bI3arHZIrUvpMkcTlRCeMrEI/XQ9aP23BrxMbPcou2LAi
         fsmCxcluJtiFW/G5KRb8fZAawRD8MtspLytXN1OPqy9Pe6zDW/W9imlAAikwscOyL679
         8LLoXwaKDt7fCOQuvzA0QAugpU8ALvzQBoPfI62QkyDh/uKEJhLgcVp9K4Gbb88RT2ru
         Eslg==
X-Gm-Message-State: APjAAAVRASdcd4GaEmwwEy2fBAq1ixiqJLxBhqzhLWhT7PkXMgSvlOBC
        DitSSLYTgXQdXbxkhzW722rcPVSm7/Q=
X-Google-Smtp-Source: APXvYqwXsbJvfWh6+WdQ1EdKQa+FZoDqxr8TXQduzRnUN1Vs65I1tJOZhE+CVtnH+IqGYsG5A2H/og==
X-Received: by 2002:aca:cf10:: with SMTP id f16mr895805oig.42.1553139564308;
        Wed, 20 Mar 2019 20:39:24 -0700 (PDT)
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com. [209.85.210.51])
        by smtp.gmail.com with ESMTPSA id j131sm1560206oia.37.2019.03.20.20.39.23
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Mar 2019 20:39:24 -0700 (PDT)
Received: by mail-ot1-f51.google.com with SMTP id c18so4197289otl.13
        for <linux-media@vger.kernel.org>; Wed, 20 Mar 2019 20:39:23 -0700 (PDT)
X-Received: by 2002:a05:6830:208d:: with SMTP id y13mr1104752otq.288.1553139199969;
 Wed, 20 Mar 2019 20:33:19 -0700 (PDT)
MIME-Version: 1.0
References: <1549348966-14451-1-git-send-email-frederic.chen@mediatek.com>
 <1549348966-14451-8-git-send-email-frederic.chen@mediatek.com>
 <CAAFQd5CWdZUXVb4F9BLhQdN8WHjzA8acPDx1i+WcoudsdGsfUg@mail.gmail.com>
 <1550372163.11724.59.camel@mtksdccf07> <CAAFQd5CaXz_Lqz8NhGK4DvaxPvuYLj-Y73sG7wFaqW44j+tZQw@mail.gmail.com>
 <1550647867.11724.80.camel@mtksdccf07>
In-Reply-To: <1550647867.11724.80.camel@mtksdccf07>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Thu, 21 Mar 2019 12:33:08 +0900
X-Gmail-Original-Message-ID: <CAAFQd5Addbh8cQBwKnW_g_KWBO6wPbF6MJXX7+gxDmOPg9+zmQ@mail.gmail.com>
Message-ID: <CAAFQd5Addbh8cQBwKnW_g_KWBO6wPbF6MJXX7+gxDmOPg9+zmQ@mail.gmail.com>
Subject: Re: [RFC PATCH V0 7/7] [media] platform: mtk-isp: Add Mediatek ISP
 Pass 1 driver
To:     Jungo Lin <jungo.lin@mediatek.com>
Cc:     frankie_chiu@mediatek.com,
        =?UTF-8?B?U2VhbiBDaGVuZyAo6YSt5piH5byYKQ==?= 
        <Sean.Cheng@mediatek.com>,
        Frederic Chen <frederic.chen@mediatek.com>,
        =?UTF-8?B?UnlubiBXdSAo5ZCz6IKy5oGpKQ==?= <Rynn.Wu@mediatek.com>,
        =?UTF-8?B?Q2hyaXN0aWUgWXUgKOa4uOmbheaDoCk=?= 
        <christie.yu@mediatek.com>, srv_heupstream@mediatek.com,
        =?UTF-8?B?SG9sbWVzIENoaW91ICjpgrHmjLop?= 
        <holmes.chiou@mediatek.com>, seraph_huang@mediatek.com,
        Jerry-ch Chen <Jerry-ch.Chen@mediatek.com>,
        yuzhao@chromium.org, ryan_yu@mediatek.com,
        Sj Huang <sj.huang@mediatek.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-mediatek@lists.infradead.org, zwisler@chromium.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg
        Roedel <joro@8bytes.org>," <linux-arm-kernel@lists.infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        =?UTF-8?B?UnlhbiBZdSAo5L2Z5a2f5L+uKQ==?= <ryan.yu@mediatek.com>,
        =?UTF-8?B?U2VyYXBoIEh1YW5nICjpu4PlnIvpm4Qp?= 
        <Seraph.Huang@mediatek.com>,
        =?UTF-8?B?RnJhbmtpZSBDaGl1ICjpgrHmloflh7Ep?= 
        <frankie.chiu@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, Feb 20, 2019 at 4:31 PM Jungo Lin <jungo.lin@mediatek.com> wrote:
>
> On Tue, 2019-02-19 at 17:51 +0900, Tomasz Figa wrote:
> > Hi Jungo,
> >
> > On Sun, Feb 17, 2019 at 11:56 AM Jungo Lin <jungo.lin@mediatek.com> wrote:
> > >
> > > On Wed, 2019-02-13 at 18:50 +0900, Tomasz Figa wrote:
> > > > (() . ( strHi Frederic, Jungo,
> > > >
> > > > On Tue, Feb 5, 2019 at 3:43 PM Frederic Chen <frederic.chen@mediatek.com> wrote:
> > > > >
> > > > > From: Jungo Lin <jungo.lin@mediatek.com>
> > > > >
> > > > > This patch adds the driver for Pass unit in Mediatek's camera
> > > > > ISP system. Pass 1 unit is embedded in Mediatek SOCs. It
> > > > > provides RAW processing which includes optical black correction,
> > > > > defect pixel correction, W/IR imbalance correction and lens
> > > > > shading correction.
> > > > >
> > > > > The mtk-isp directory will contain drivers for multiple IP
> > > > > blocks found in Mediatek ISP system. It will include ISP Pass 1
> > > > > driver, sensor interface driver, DIP driver and face detection
> > > > > driver.
> > > >
> > > > Thanks for the patches! Please see my comments inline.
> > > >
> > >
> > > Dear Thomas:
> > >
> > > Thanks for your comments.
> > >
> > > We will revise the source codes based on your comments.
> > > Since there are many comments to fix/revise, we will categorize &
> > > prioritize these with below list:
> > >
> > > 1. Coding style issues.
> > > 2. Coding defects, including unused codes.
> > > 3. Driver architecture refactoring, such as removing mtk_cam_ctx,
> > > unnecessary abstraction layer, etc.
> > >
> >
> > Thanks for replying to the comments!
> >
> > Just to clarify, there is no need to hurry with resending a next patch
> > set with only a subset of the changes. Please take your time to
> > address all the comments before sending the next revision. This
> > prevents forgetting about some remaining comments and also lets other
> > reviewers come with new comments or some alternative ideas for already
> > existing comments. Second part of my review is coming too.
> >
> > P.S. Please avoid top-posting on mailing lists. If replying to a
> > message, please reply below the related part of that message. (I've
> > moved your reply to the place in the email where it should be.)
> >
> > [snip]
>
> Hi, Tomasz,
>
> Thanks for your advice.
> We will prepare the next patch set after all comments are revised.
>
>
> > > > > +       phys_addr_t paddr;
> > > >
> > > > We shouldn't need physical address either. I suppose this is for the
> > > > SCP, but then it should be a DMA address obtained from dma_map_*()
> > > > with struct device pointer of the SCP.
> > > >
> > >
> > > Yes, this physical address is designed for SCP.
> > > For tuning buffer, it will be touched by SCP and
> > > SCP can't get the physical address by itself. So we need to get
> > > this physical address in the kernel space via mtk_cam_smem_iova_to_phys
> > > function call and pass it to the SCP. At the same time, DMA address
> > > (daddr) is used for ISP HW.
> > >
> >
> > Right, but my point is that in the kernel phys_addr_t is the physical
> > address from the CPU point of view. Any address from device point of
> > view is dma_addr_t and should be obtained from the DMA mapping API
> > (even if it's numerically the same as physical address).
> >
>
> OK.
> In order to clarify the address usage, is it ok to rename "dma_addr_t
> scp_addr"?

Sounds good to me.

> Moreover, below function will be also renamed.
> dma_addr_t mtk_cam_smem_iova_to_scp_phys(struct device *dev,
>                                       dma_addr_t iova)

Perhaps mtk_cam_smem_iova_to_scp_addr() for consistency with the
struct field above?
