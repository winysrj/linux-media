Return-Path: <SRS0=WMbR=RY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7444DC43381
	for <linux-media@archiver.kernel.org>; Thu, 21 Mar 2019 03:45:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 315EE218A1
	for <linux-media@archiver.kernel.org>; Thu, 21 Mar 2019 03:45:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="DC30iu0p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727868AbfCUDpp (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Mar 2019 23:45:45 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:33751 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbfCUDpp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Mar 2019 23:45:45 -0400
Received: by mail-oi1-f196.google.com with SMTP id e22so3663492oiy.0
        for <linux-media@vger.kernel.org>; Wed, 20 Mar 2019 20:45:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RABvo/85jRVr3bjcc3MeC2+tNsFKQIfmez7YLbjpaoI=;
        b=DC30iu0pS09tHRhg8vWzadFFXYh8EjtEl9xEM9lzclru5Ir3wK6gXL3hyxSVMzcmQH
         z/dECN47tTmNU+5j6C7v35vp556k49fcd5ceZcQP7fCMxJ+b+g+iq8tmC0NpMVmEwT4r
         Lr+78UsXij2IZBmsT/MBcNfNffDtn0F++Cc3U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RABvo/85jRVr3bjcc3MeC2+tNsFKQIfmez7YLbjpaoI=;
        b=ObNUSEF3/t2a4S9X+5eREx002FKtE7/kRVxnZOvHkONkjzXd+4ORCP7d2dL2psHcWg
         7+Tm5NjvDUVOpY5gu3StYaHbHo6LX2FfAfjMFA+l+KrQf0WZ5iOO4uWhW7igLBufE6E6
         jcjxLbRRTbEgB67ymrenTWHrITlIatlAU6sEi25TW2ZoAhUrRpRzcTuTeqpNHB5V7MZo
         ufEKTwGETRCUH0uVYfUywvCLnR8ZTVnOt8ZvDdlVUJX91xIXvRAd4/P5pMwjcm/ewxV5
         VrvzMhYd+ld4jqaVC764YYzieBSBlzGyPasCHbcXU0JYlqqILrCLSdvje4J/E2ZjnVAr
         8Hwg==
X-Gm-Message-State: APjAAAVLqCR5ffMi7agNYciVfwk9tUXrNmbwFdnip+01FprNEpvnXLMF
        MfSJxehsnifcwqsbKhS0ZYdeh3FSD4E=
X-Google-Smtp-Source: APXvYqx/DoeHfNVDl098Wr4rPv5mmkCwkiiEwr46xg7ZhdVo5yHHd7NYvJuyb4vQuf9n84lIwiTsHA==
X-Received: by 2002:aca:d446:: with SMTP id l67mr878979oig.13.1553139944135;
        Wed, 20 Mar 2019 20:45:44 -0700 (PDT)
Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com. [209.85.210.49])
        by smtp.gmail.com with ESMTPSA id g1sm1557879otl.78.2019.03.20.20.45.43
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Mar 2019 20:45:43 -0700 (PDT)
Received: by mail-ot1-f49.google.com with SMTP id u15so4249481otq.10
        for <linux-media@vger.kernel.org>; Wed, 20 Mar 2019 20:45:43 -0700 (PDT)
X-Received: by 2002:a9d:760a:: with SMTP id k10mr1046441otl.367.1553139943140;
 Wed, 20 Mar 2019 20:45:43 -0700 (PDT)
MIME-Version: 1.0
References: <1549348966-14451-1-git-send-email-frederic.chen@mediatek.com>
 <1549348966-14451-8-git-send-email-frederic.chen@mediatek.com>
 <CAAFQd5BGFmTbRF+LdRvXs0MBZifRd9zB_+OT6Xwo=dzwqajgGA@mail.gmail.com> <1552378607.13953.71.camel@mtksdccf07>
In-Reply-To: <1552378607.13953.71.camel@mtksdccf07>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Thu, 21 Mar 2019 12:45:31 +0900
X-Gmail-Original-Message-ID: <CAAFQd5C+Syovzh14PAppyC5gmWqx=Tr_yGpLdgaWHXYXQGCX+g@mail.gmail.com>
Message-ID: <CAAFQd5C+Syovzh14PAppyC5gmWqx=Tr_yGpLdgaWHXYXQGCX+g@mail.gmail.com>
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
        <holmes.chiou@mediatek.com>,
        Jerry-ch Chen <Jerry-ch.Chen@mediatek.com>,
        =?UTF-8?B?UnlubiBXdSAo5ZCz6IKy5oGpKQ==?= <Rynn.Wu@mediatek.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        srv_heupstream@mediatek.com, yuzhao@chromium.org,
        zwisler@chromium.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, Mar 12, 2019 at 5:16 PM Jungo Lin <jungo.lin@mediatek.com> wrote:
>
> On Thu, 2019-03-07 at 19:04 +0900, Tomasz Figa wrote:
[snip]
> > > diff --git a/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-smem-drv.c b/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-smem-drv.c
> > > new file mode 100644
> > > index 0000000..020c38c
> > > --- /dev/null
> > > +++ b/drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-smem-drv.c
> >
> > I don't think we need any of the code that is in this file. We should
> > just use the DMA API. We should be able to create appropriate reserved
> > memory pools in DT and properly assign them to the right allocating
> > devices.
> >
> > Skipping review of this file for the time being.
> >
>
> For this file, we may need your help.
> Its purpose is same as DIP SMEM driver.
> It is used for creating the ISP P1 specific vb2 buffer allocation
> context with reserved memory. Unfortunately, the implementation of
> mtk_cam-smem-drive.c is our best solution now.
>
> Could you give us more hints how to implement?
> Or do you think we could leverage the implementation from "Samsung S5P
> Multi Format Codec driver"?
> drivers/media/platform/s5p-mfc/s5p_mfc.c
> - s5p_mfc_configure_dma_memory function
>   - s5p_mfc_configure_2port_memory
>      - s5p_mfc_alloc_memdev

I think we can indeed take some ideas from there. I need some time to
check this and give you more details.

[snip]
> > > +               }
> > > +
> > > +               dev_dbg(&isp_dev->pdev->dev, "streamed on sensor(%s)\n",
> > > +                       cio->sensor->entity.name);
> > > +
> > > +               ret = mtk_cam_ctx_streamon(&isp_dev->ctx);
> > > +               if (ret) {
> > > +                       dev_err(&isp_dev->pdev->dev,
> > > +                               "Pass 1 stream on failed (%d)\n", ret);
> > > +                       return -EPERM;
> > > +               }
> > > +
> > > +               isp_dev->mem2mem2.streaming = enable;
> > > +
> > > +               ret = mtk_cam_dev_queue_buffers(isp_dev, true);
> > > +               if (ret)
> > > +                       dev_err(&isp_dev->pdev->dev,
> > > +                               "failed to queue initial buffers (%d)", ret);
> > > +
> > > +               dev_dbg(&isp_dev->pdev->dev, "streamed on Pass 1\n");
> > > +       } else {
> > > +               if (cio->sensor) {
> >
> > Is it possible to have cio->sensor NULL here? This function would have
> > failed if it wasn't found when enabling.
> >
>
> In the original design, it is protected to avoid abnormal double stream
> off (s_stream) call from upper layer. For stability reason, it is better
> to check.

If so, having some state (e.g. field in a struct) for tracking the
streaming state would make the code much easier to understand.
Also, the error message on the else case is totally misleading,
because it complains about a missing sensor, rather than double
s_stream.

[snip]
> Thanks for your valued comments on part 2.
> It is helpful for us to make our driver implementation better.
>
> We'd like to know your opinion about the schedule for RFC V1.
> Do you suggest us to send RFC V1 patch set after revising all comments
> on part 1 & 2 or wait for part 3 review?

I'm going to be a bit busy for the next few days, so it may be a good
idea to address the comments for parts 1, 2 and 3 and send RFC V1.
Also, for the more general comments, please check if they don't apply
to the other drivers too (DIP, FD, Seninf, MDP). Thanks in advance!

Best regards,
Tomasz
