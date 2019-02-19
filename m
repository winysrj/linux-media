Return-Path: <SRS0=RQn6=Q2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 648D2C43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 08:51:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28F602147C
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 08:51:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Xbl66mYw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbfBSIve (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Feb 2019 03:51:34 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:41592 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727246AbfBSIve (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Feb 2019 03:51:34 -0500
Received: by mail-ot1-f67.google.com with SMTP id t7so16520329otk.8
        for <linux-media@vger.kernel.org>; Tue, 19 Feb 2019 00:51:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tlV9vLB+KSMsmXO/I53mLkrat4UHKAVvOR8nqbfYTjw=;
        b=Xbl66mYw6fd/AAeklC09hLlPoGGov/UOZz7vOpQDOC6a71lsbpuv2jtTVvgJFUg38T
         FEs3q1yEXzo2JFtKPT7HA1CzP9z6LrOHQXCR4oM0GFQxlA/KwNOnnKMaG9C/FNhnHI1U
         xhCiuIcQfs+NclRvCqwHMonV1iGp9OL0KqqGc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tlV9vLB+KSMsmXO/I53mLkrat4UHKAVvOR8nqbfYTjw=;
        b=n9Rv/zKjQHtYid8M5O74HU8QsiiVeEm+kEEcXHa8vaUh1Agqy795BccCzWZ4iSgIUR
         sbOdmPsaLKN72iTHC/rocZhmfAtZ4ZC7bqsMgZyKUfAp3l/KfASDi11t02yhTfvYbcwu
         eeHvexKABYNwEu+slWaXHCxGXYlsB88pmxfhQyNBXXJ9pVCl0+hdle8IcWeNl6Kq7mvQ
         tOzQtWRZhihSFZdAdVeoRWvdcVqZViKdSx5lhcJCXX6kxHyc+fvuz5RRFAtVHxHi2QW2
         Dos7QE27IT3fhfJfbyzN/Mb7IJrqk4CH17dreg1tHCB7FA2likPp9b6kJXBdQYLCh9UA
         Eu0A==
X-Gm-Message-State: AHQUAuZi42njOU/oaayYQIlEw10LKMOzb19QPi+05OnG6LMQXdA8VEii
        fyfjWE1gaHmcMTZpfq/e51DLLux0LwI=
X-Google-Smtp-Source: AHgI3IaiO6sh435myVcTGR7QrCMRNroRJV1Ei9EHkh/v4QBORNMj01asAhnaZJRjTFItIOf/W3/pZg==
X-Received: by 2002:aca:a904:: with SMTP id s4mr1941190oie.20.1550566293059;
        Tue, 19 Feb 2019 00:51:33 -0800 (PST)
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com. [209.85.210.46])
        by smtp.gmail.com with ESMTPSA id w17sm6684875otk.12.2019.02.19.00.51.31
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Feb 2019 00:51:31 -0800 (PST)
Received: by mail-ot1-f46.google.com with SMTP id v20so962365otk.7
        for <linux-media@vger.kernel.org>; Tue, 19 Feb 2019 00:51:31 -0800 (PST)
X-Received: by 2002:aca:5657:: with SMTP id k84mr1883764oib.173.1550566290647;
 Tue, 19 Feb 2019 00:51:30 -0800 (PST)
MIME-Version: 1.0
References: <1549348966-14451-1-git-send-email-frederic.chen@mediatek.com>
 <1549348966-14451-8-git-send-email-frederic.chen@mediatek.com>
 <CAAFQd5CWdZUXVb4F9BLhQdN8WHjzA8acPDx1i+WcoudsdGsfUg@mail.gmail.com> <1550372163.11724.59.camel@mtksdccf07>
In-Reply-To: <1550372163.11724.59.camel@mtksdccf07>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Tue, 19 Feb 2019 17:51:19 +0900
X-Gmail-Original-Message-ID: <CAAFQd5CaXz_Lqz8NhGK4DvaxPvuYLj-Y73sG7wFaqW44j+tZQw@mail.gmail.com>
Message-ID: <CAAFQd5CaXz_Lqz8NhGK4DvaxPvuYLj-Y73sG7wFaqW44j+tZQw@mail.gmail.com>
Subject: Re: [RFC PATCH V0 7/7] [media] platform: mtk-isp: Add Mediatek ISP
 Pass 1 driver
To:     Jungo Lin <jungo.lin@mediatek.com>
Cc:     Frederic Chen <frederic.chen@mediatek.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-mediatek@lists.infradead.org,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg
        Roedel <joro@8bytes.org>," <linux-arm-kernel@lists.infradead.org>,
        =?UTF-8?B?U2VhbiBDaGVuZyAo6YSt5piH5byYKQ==?= 
        <Sean.Cheng@mediatek.com>, Sj Huang <sj.huang@mediatek.com>,
        =?UTF-8?B?Q2hyaXN0aWUgWXUgKOa4uOmbheaDoCk=?= 
        <christie.yu@mediatek.com>,
        =?UTF-8?B?SG9sbWVzIENoaW91ICjpgrHmjLop?= 
        <holmes.chiou@mediatek.com>, Jerry-ch.Chen@mediatek.com,
        =?UTF-8?B?UnlubiBXdSAo5ZCz6IKy5oGpKQ==?= <Rynn.Wu@mediatek.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        srv_heupstream@mediatek.com, yuzhao@chromium.org,
        zwisler@chromium.org, seraph_huang@mediatek.com,
        frankie_chiu@mediatek.com, ryan_yu@mediatek.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Jungo,

On Sun, Feb 17, 2019 at 11:56 AM Jungo Lin <jungo.lin@mediatek.com> wrote:
>
> On Wed, 2019-02-13 at 18:50 +0900, Tomasz Figa wrote:
> > (() . ( strHi Frederic, Jungo,
> >
> > On Tue, Feb 5, 2019 at 3:43 PM Frederic Chen <frederic.chen@mediatek.com> wrote:
> > >
> > > From: Jungo Lin <jungo.lin@mediatek.com>
> > >
> > > This patch adds the driver for Pass unit in Mediatek's camera
> > > ISP system. Pass 1 unit is embedded in Mediatek SOCs. It
> > > provides RAW processing which includes optical black correction,
> > > defect pixel correction, W/IR imbalance correction and lens
> > > shading correction.
> > >
> > > The mtk-isp directory will contain drivers for multiple IP
> > > blocks found in Mediatek ISP system. It will include ISP Pass 1
> > > driver, sensor interface driver, DIP driver and face detection
> > > driver.
> >
> > Thanks for the patches! Please see my comments inline.
> >
>
> Dear Thomas:
>
> Thanks for your comments.
>
> We will revise the source codes based on your comments.
> Since there are many comments to fix/revise, we will categorize &
> prioritize these with below list:
>
> 1. Coding style issues.
> 2. Coding defects, including unused codes.
> 3. Driver architecture refactoring, such as removing mtk_cam_ctx,
> unnecessary abstraction layer, etc.
>

Thanks for replying to the comments!

Just to clarify, there is no need to hurry with resending a next patch
set with only a subset of the changes. Please take your time to
address all the comments before sending the next revision. This
prevents forgetting about some remaining comments and also lets other
reviewers come with new comments or some alternative ideas for already
existing comments. Second part of my review is coming too.

P.S. Please avoid top-posting on mailing lists. If replying to a
message, please reply below the related part of that message. (I've
moved your reply to the place in the email where it should be.)

[snip]
> > > +       phys_addr_t paddr;
> >
> > We shouldn't need physical address either. I suppose this is for the
> > SCP, but then it should be a DMA address obtained from dma_map_*()
> > with struct device pointer of the SCP.
> >
>
> Yes, this physical address is designed for SCP.
> For tuning buffer, it will be touched by SCP and
> SCP can't get the physical address by itself. So we need to get
> this physical address in the kernel space via mtk_cam_smem_iova_to_phys
> function call and pass it to the SCP. At the same time, DMA address
> (daddr) is used for ISP HW.
>

Right, but my point is that in the kernel phys_addr_t is the physical
address from the CPU point of view. Any address from device point of
view is dma_addr_t and should be obtained from the DMA mapping API
(even if it's numerically the same as physical address).

Best regards,
Tomasz
