Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f175.google.com ([209.85.128.175]:36033 "EHLO
        mail-wr0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752701AbdDCQey (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Apr 2017 12:34:54 -0400
Received: by mail-wr0-f175.google.com with SMTP id w11so175749814wrc.3
        for <linux-media@vger.kernel.org>; Mon, 03 Apr 2017 09:34:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <E1cttOq-0006GX-U7@rmk-PC.armlinux.org.uk>
References: <E1cttOq-0006GX-U7@rmk-PC.armlinux.org.uk>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Mon, 3 Apr 2017 22:04:32 +0530
Message-ID: <CAO_48GHyQ8G-okTf4hkWZghE2Zdbp7wpZVaUoq8H=mm7Ra-fhg@mail.gmail.com>
Subject: Re: [PATCH] dma-buf: align debugfs output
To: Russell King <rmk+kernel@armlinux.org.uk>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Linaro MM SIG <linaro-mm-sig@lists.linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Russell,


On 31 March 2017 at 15:33, Russell King <rmk+kernel@armlinux.org.uk> wrote:
> Align the heading with the values output from debugfs.
>
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Thanks for your patch; applied to drm-misc-next.

> ---
>  drivers/dma-buf/dma-buf.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> index ebaf1923ad6b..f72aaacbe023 100644
> --- a/drivers/dma-buf/dma-buf.c
> +++ b/drivers/dma-buf/dma-buf.c
> @@ -1072,7 +1072,8 @@ static int dma_buf_debug_show(struct seq_file *s, void *unused)
>                 return ret;
>
>         seq_puts(s, "\nDma-buf Objects:\n");
> -       seq_puts(s, "size\tflags\tmode\tcount\texp_name\n");
> +       seq_printf(s, "%-8s\t%-8s\t%-8s\t%-8s\texp_name\n",
> +                  "size", "flags", "mode", "count");
>
>         list_for_each_entry(buf_obj, &db_list.head, list_node) {
>                 ret = mutex_lock_interruptible(&buf_obj->lock);
> --
> 2.7.4
>

Best,
Sumit.
