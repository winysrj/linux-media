Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:37713 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727308AbeGaHxJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jul 2018 03:53:09 -0400
Received: by mail-yw0-f194.google.com with SMTP id w76-v6so5341779ywg.4
        for <linux-media@vger.kernel.org>; Mon, 30 Jul 2018 23:14:31 -0700 (PDT)
Received: from mail-yw0-f169.google.com (mail-yw0-f169.google.com. [209.85.161.169])
        by smtp.gmail.com with ESMTPSA id 203-v6sm5933262ywv.34.2018.07.30.23.14.30
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Jul 2018 23:14:30 -0700 (PDT)
Received: by mail-yw0-f169.google.com with SMTP id t18-v6so5343341ywg.2
        for <linux-media@vger.kernel.org>; Mon, 30 Jul 2018 23:14:30 -0700 (PDT)
MIME-Version: 1.0
References: <20180617143625.32133-1-matwey@sai.msu.ru> <20180617143625.32133-2-matwey@sai.msu.ru>
 <c02f92a8998fc62d3e3d48aa154fbaa7e223dd10.camel@collabora.com>
 <CAJs94EavBDcFHpd0KcCZJTgWf0JC=AEDY=X8b3P2nZvt8mBCPA@mail.gmail.com>
 <eb2b495fe7e8bbeaf3f9e2814be4923583482852.camel@collabora.com> <20180730130702.27664d15@coco.lan>
In-Reply-To: <20180730130702.27664d15@coco.lan>
From: Tomasz Figa <tfiga@chromium.org>
Date: Tue, 31 Jul 2018 15:06:45 +0900
Message-ID: <CAAFQd5A6hDdPR87r5mq=-JxeSGGwaiTjHFBH04q7tEcd3oZJdQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] media: usb: pwc: Don't use coherent DMA buffers for
 ISO transfer
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Ezequiel Garcia <ezequiel@collabora.com>,
        "Matwey V. Kornilov" <matwey@sai.msu.ru>,
        Alan Stern <stern@rowland.harvard.edu>, hdegoede@redhat.com,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        rostedt@goodmis.org, mingo@redhat.com,
        Mike Isely <isely@pobox.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Colin King <colin.king@canonical.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 31, 2018 at 1:07 AM Mauro Carvalho Chehab
<mchehab+samsung@kernel.org> wrote:
>
> Em Tue, 17 Jul 2018 17:10:22 -0300
> Ezequiel Garcia <ezequiel@collabora.com> escreveu:
>
> > Yeah, and not setting URB_NO_TRANSFER_DMA_MAP makes the USB core
> > create DMA mappings and use the streaming API. Which makes more
> > sense in hardware without hardware coherency.
> >
> > The only thing that bothers me with this patch is that it's not
> > really something specific to this driver. If this fix is valid
> > for pwc, then it's valid for all the drivers allocating coherent
> > memory.
>
> We're actually doing this change on other drivers:
>         https://git.linuxtv.org/media_tree.git/commit/?id=d571b592c6206
>
> I suspect that the reason why all USB media drivers were using
> URB_NO_TRANSFER_DMA_MAP is just because the first media USB driver
> upstream used it.
>
> On that time, I remember I tried once to not use this flag, but there
> was something that broke (perhaps I just didn't know enough about the
> USB layer - or perhaps some fixes happened at USB core - allowing it
> to be used with ISOC transfers).
>
> Anyway, nowadays, I fail to see a reason why not let the USB core
> do the DMA maps. On my tests after this patch, at the boards I tested
> (arm and x86), I was unable to see any regressions.

I can see one reason:

usb_alloc_coherent() would use dma_pool_alloc() with a fallback to
dma_alloc_coherent() to do the allocation. I'm not sure what a typical
size for an URB buffer is, but I assume that it's definitely more than
1 page. Order >0 allocations with page allocator (and SLAB, which
eventually just falls back to page allocator for such large
allocations) are generally considered costly. With allocation through
DMA API, mechanisms such as CMA or IOMMU can be used (if available),
making it much more likely to have the allocation satisfied on heavy
load / long uptime systems.

Best regards,
Tomasz
