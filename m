Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f193.google.com ([209.85.217.193]:46205 "EHLO
        mail-ua0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754255AbeALIRU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Jan 2018 03:17:20 -0500
Received: by mail-ua0-f193.google.com with SMTP id u2so3497220uad.13
        for <linux-media@vger.kernel.org>; Fri, 12 Jan 2018 00:17:20 -0800 (PST)
Received: from mail-ua0-f177.google.com (mail-ua0-f177.google.com. [209.85.217.177])
        by smtp.gmail.com with ESMTPSA id s125sm3309564vkb.30.2018.01.12.00.17.18
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Jan 2018 00:17:18 -0800 (PST)
Received: by mail-ua0-f177.google.com with SMTP id l12so3491844uaa.10
        for <linux-media@vger.kernel.org>; Fri, 12 Jan 2018 00:17:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1515034637-3517-1-git-send-email-yong.zhi@intel.com>
References: <1515034637-3517-1-git-send-email-yong.zhi@intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Fri, 12 Jan 2018 17:16:57 +0900
Message-ID: <CAAFQd5AO4n4kge1dijXLK-Ckudd5wJnuRnNMef+H4W00G2mpwQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] media: intel-ipu3: cio2: fix a crash with
 out-of-bounds access
To: Yong Zhi <yong.zhi@intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        Cao Bing Bu <bingbu.cao@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 4, 2018 at 11:57 AM, Yong Zhi <yong.zhi@intel.com> wrote:
> When dmabuf is used for BLOB type frame, the frame
> buffers allocated by gralloc will hold more pages
> than the valid frame data due to height alignment.
>
> In this case, the page numbers in sg list could exceed the
> FBPT upper limit value - max_lops(8)*1024 to cause crash.
>
> Limit the LOP access to the valid data length
> to avoid FBPT sub-entries overflow.
>
> Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> Signed-off-by: Cao Bing Bu <bingbu.cao@intel.com>
> ---
>  drivers/media/pci/intel/ipu3/ipu3-cio2.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
> index 941caa987dab..949f43d206ad 100644
> --- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
> +++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
> @@ -838,8 +838,9 @@ static int cio2_vb2_buf_init(struct vb2_buffer *vb)
>                 container_of(vb, struct cio2_buffer, vbb.vb2_buf);
>         static const unsigned int entries_per_page =
>                 CIO2_PAGE_SIZE / sizeof(u32);
> -       unsigned int pages = DIV_ROUND_UP(vb->planes[0].length, CIO2_PAGE_SIZE);
> -       unsigned int lops = DIV_ROUND_UP(pages + 1, entries_per_page);
> +       unsigned int pages = DIV_ROUND_UP(vb->planes[0].length,
> +                                         CIO2_PAGE_SIZE) + 1;

Why + 1? This would still overflow the buffer, wouldn't it?

> +       unsigned int lops = DIV_ROUND_UP(pages, entries_per_page);
>         struct sg_table *sg;
>         struct sg_page_iter sg_iter;
>         int i, j;
> @@ -869,6 +870,8 @@ static int cio2_vb2_buf_init(struct vb2_buffer *vb)
>
>         i = j = 0;
>         for_each_sg_page(sg->sgl, &sg_iter, sg->nents, 0) {
> +               if (!pages--)
> +                       break;

Or perhaps we should check here for (pages > 1)?

Best regards,
Tomasz
