Return-Path: <SRS0=KeAI=PK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2170C43387
	for <linux-media@archiver.kernel.org>; Wed,  2 Jan 2019 10:53:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FA7B218CD
	for <linux-media@archiver.kernel.org>; Wed,  2 Jan 2019 10:53:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qt5z6qJG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728716AbfABKxa (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 2 Jan 2019 05:53:30 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:32860 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727631AbfABKx3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 2 Jan 2019 05:53:29 -0500
Received: by mail-lj1-f193.google.com with SMTP id v1-v6so26702943ljd.0;
        Wed, 02 Jan 2019 02:53:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SezKeaYuk6nk7occBjh6L8uqtXsHTPs6Hbj337dY8hk=;
        b=Qt5z6qJGB9o9aGKd2wu1bhsmzEmdcDzaLxP82MQjif7xhWIw1UWk0ZnlJTMC9xvoN6
         mBIXkib4q11Ofmjr++AElHoRXjW2lvlTw+Gd+RbJFOrrcVyQTOnaIAOGVTj8Ec/D6WEV
         Xt4ni8bIGny1nGnbEp6gYIBs+xrkOy3fG1ykkyHzdsrAS69uhcl/1+hadweqRUG4sIEy
         lbPd/8Y4pAHNkKA+zkIbSw3sMt+jw5nMsQ7dTVDtFyciFa43x93Y8BjuWlygWrOOSHaV
         RTwlWIJXdj05/Jdg/5Z/6y+x7+1pI11xPhnhbSZ3+08BMNSK0e29ewTR43WCAHis0qmm
         meIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SezKeaYuk6nk7occBjh6L8uqtXsHTPs6Hbj337dY8hk=;
        b=hF2LgKaYZW9aF3RFvelJRO+fxqR2w61hDsonSBiG9KmWcMVNtuufJvrK1BJsLPKOLE
         1LM3Syd3j2n9b0LCHNeJfGQ/wHdmzk6pVjtsuPNPkiPrgzWSniSA0HN9ZjTl3wAQgF8+
         1XFSU52rCAzYYUu9Wo+GML3PfmUm1HTOmACnE475v76dxx1zp7w+sJ+B2PBMVf5G+6oV
         UwdkfVL7AM19qR2sDgyM3s9c1HtIWnq74zGd5ZN6bvLkJk2XWboT+AdOd9q9ZB8DCKj6
         uraboiqt8zOH7oKTu30FzvpP7XEt6gAHZwP4TPvC9ZDF6I4c42kpm1/gbqd9o0tn8TA1
         cuZA==
X-Gm-Message-State: AA+aEWbyGHKKSBRIzMhZYG1moUID6wy0CFZiP/D5YOj5FJFyTkWeJL9Y
        3xut5iwMBYFSB6knXwo+D38m9JOm+99kaHxE7j4=
X-Google-Smtp-Source: AFSGD/UwYlr3G2cGWuGxEPCHMUa9rHoeFQ8/rz6abHSV1vjPvvVhGgT7iCng27XKmqtsRwEco9RU++5BMOiXMuziz3c=
X-Received: by 2002:a2e:630a:: with SMTP id x10-v6mr23330309ljb.11.1546426407321;
 Wed, 02 Jan 2019 02:53:27 -0800 (PST)
MIME-Version: 1.0
References: <20181224132658.GA22166@jordon-HP-15-Notebook-PC>
In-Reply-To: <20181224132658.GA22166@jordon-HP-15-Notebook-PC>
From:   Souptick Joarder <jrdr.linux@gmail.com>
Date:   Wed, 2 Jan 2019 16:23:15 +0530
Message-ID: <CAFqt6zZU6c3MyVQpCegntu1ZxtFri=HMwZJ3xg+tCxRARo3zMA@mail.gmail.com>
Subject: Re: [PATCH v5 7/9] videobuf2/videobuf2-dma-sg.c: Convert to use vm_insert_range
To:     Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Hocko <mhocko@suse.com>, pawel@osciak.com,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, mchehab@kernel.org,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        robin.murphy@arm.com
Cc:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linux-MM <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Mon, Dec 24, 2018 at 6:53 PM Souptick Joarder <jrdr.linux@gmail.com> wrote:
>
> Convert to use vm_insert_range to map range of kernel memory
> to user vma.
>
> Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
> Reviewed-by: Matthew Wilcox <willy@infradead.org>
> Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Acked-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> ---
>  drivers/media/common/videobuf2/videobuf2-dma-sg.c | 23 +++++++----------------
>  1 file changed, 7 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/media/common/videobuf2/videobuf2-dma-sg.c b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
> index 015e737..898adef 100644
> --- a/drivers/media/common/videobuf2/videobuf2-dma-sg.c
> +++ b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
> @@ -328,28 +328,19 @@ static unsigned int vb2_dma_sg_num_users(void *buf_priv)
>  static int vb2_dma_sg_mmap(void *buf_priv, struct vm_area_struct *vma)
>  {
>         struct vb2_dma_sg_buf *buf = buf_priv;
> -       unsigned long uaddr = vma->vm_start;
> -       unsigned long usize = vma->vm_end - vma->vm_start;
> -       int i = 0;
> +       unsigned long page_count = vma_pages(vma);
> +       int err;
>
>         if (!buf) {
>                 printk(KERN_ERR "No memory to map\n");
>                 return -EINVAL;
>         }
>
> -       do {
> -               int ret;
> -
> -               ret = vm_insert_page(vma, uaddr, buf->pages[i++]);
> -               if (ret) {
> -                       printk(KERN_ERR "Remapping memory, error: %d\n", ret);
> -                       return ret;
> -               }
> -
> -               uaddr += PAGE_SIZE;
> -               usize -= PAGE_SIZE;
> -       } while (usize > 0);
> -
> +       err = vm_insert_range(vma, vma->vm_start, buf->pages, page_count);
> +       if (err) {
> +               printk(KERN_ERR "Remapping memory, error: %d\n", err);
> +               return err;
> +       }
>

Looking into the original code -
drivers/media/common/videobuf2/videobuf2-dma-sg.c

Inside vb2_dma_sg_alloc(),
           ...
           buf->num_pages = size >> PAGE_SHIFT;
           buf->dma_sgt = &buf->sg_table;

           buf->pages = kvmalloc_array(buf->num_pages, sizeof(struct page *),
                                                       GFP_KERNEL | __GFP_ZERO);
           ...

buf->pages has index upto  *buf->num_pages*.

now inside vb2_dma_sg_mmap(),

           unsigned long usize = vma->vm_end - vma->vm_start;
           int i = 0;
           ...
           do {
                 int ret;

                 ret = vm_insert_page(vma, uaddr, buf->pages[i++]);
                 if (ret) {
                           printk(KERN_ERR "Remapping memory, error:
%d\n", ret);
                           return ret;
                 }

                uaddr += PAGE_SIZE;
                usize -= PAGE_SIZE;
           } while (usize > 0);
           ...
is it possible for any value of  *i  > (buf->num_pages)*,
buf->pages[i] is going to overrun the page boundary ?
