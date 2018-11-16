Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ed1-f66.google.com ([209.85.208.66]:34038 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbeKPL5H (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Nov 2018 06:57:07 -0500
Received: by mail-ed1-f66.google.com with SMTP id w19-v6so18371399eds.1
        for <linux-media@vger.kernel.org>; Thu, 15 Nov 2018 17:46:43 -0800 (PST)
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com. [209.85.208.52])
        by smtp.gmail.com with ESMTPSA id c29sm2153655eda.75.2018.11.15.17.46.42
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Nov 2018 17:46:42 -0800 (PST)
Received: by mail-ed1-f52.google.com with SMTP id j6so13338554edp.9
        for <linux-media@vger.kernel.org>; Thu, 15 Nov 2018 17:46:42 -0800 (PST)
MIME-Version: 1.0
References: <20181114122029.16766-1-kraxel@redhat.com>
In-Reply-To: <20181114122029.16766-1-kraxel@redhat.com>
From: Gurchetan Singh <gurchetansingh@chromium.org>
Date: Thu, 15 Nov 2018 17:46:30 -0800
Message-ID: <CAAfnVBmhpMDi8EVUNZxWTU38ZWoO61eyG1-=bRqoe3hoQ08E0A@mail.gmail.com>
Subject: Re: [PATCH] udmabuf: set read/write flag when exporting
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: ML dri-devel <dri-devel@lists.freedesktop.org>,
        sumit.semwal@linaro.org, linux-media@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reviewed-by: Gurchetan Singh <gurchetansingh@chromium.org>
Tested-by: Gurchetan Singh <gurchetansingh@chromium.org>
On Wed, Nov 14, 2018 at 4:20 AM Gerd Hoffmann <kraxel@redhat.com> wrote:
>
> Otherwise, mmap fails when done with PROT_WRITE.
>
> Suggested-by: Gurchetan Singh <gurchetansingh@chromium.org>
> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
> ---
>  drivers/dma-buf/udmabuf.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/dma-buf/udmabuf.c b/drivers/dma-buf/udmabuf.c
> index e70328ab7e..d9ff246093 100644
> --- a/drivers/dma-buf/udmabuf.c
> +++ b/drivers/dma-buf/udmabuf.c
> @@ -189,6 +189,7 @@ static long udmabuf_create(const struct udmabuf_create_list *head,
>         exp_info.ops  = &udmabuf_ops;
>         exp_info.size = ubuf->pagecount << PAGE_SHIFT;
>         exp_info.priv = ubuf;
> +       exp_info.flags = O_RDWR;
>
>         buf = dma_buf_export(&exp_info);
>         if (IS_ERR(buf)) {
> --
> 2.9.3
>
