Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:39017 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752683AbdKWKqR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Nov 2017 05:46:17 -0500
Received: by mail-ot0-f193.google.com with SMTP id v15so15981455ote.6
        for <linux-media@vger.kernel.org>; Thu, 23 Nov 2017 02:46:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1511364161-6074-1-git-send-email-gomonovych@gmail.com>
References: <1511364161-6074-1-git-send-email-gomonovych@gmail.com>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Thu, 23 Nov 2017 16:15:56 +0530
Message-ID: <CAO_48GE5BRcGxjGC601FKwoXbMy_HZhMyUR=c3zZxCXhAmGKrg@mail.gmail.com>
Subject: Re: [PATCH] dma-buf: Fix ifnullfree.cocci warnings
To: Vasyl Gomonovych <gomonovych@gmail.com>
Cc: linux-media@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Linaro MM SIG <linaro-mm-sig@lists.linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Vasyl,

On 22 November 2017 at 20:52, Vasyl Gomonovych <gomonovych@gmail.com> wrote=
:
> NULL check before some freeing functions is not needed.
> drivers/dma-buf/dma-buf.c:1183:2-26: WARNING: NULL check before freeing d=
ebugfs_remove_recursive
> Generated by: scripts/coccinelle/free/ifnullfree.cocci

Thank you for your patch; applied to drm-misc-next.
>
> Signed-off-by: Vasyl Gomonovych <gomonovych@gmail.com>
> ---
>  drivers/dma-buf/dma-buf.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> index 4a038dcf5361..048827b06c03 100644
> --- a/drivers/dma-buf/dma-buf.c
> +++ b/drivers/dma-buf/dma-buf.c
> @@ -1179,8 +1179,7 @@ static int dma_buf_init_debugfs(void)
>
>  static void dma_buf_uninit_debugfs(void)
>  {
> -       if (dma_buf_debugfs_dir)
> -               debugfs_remove_recursive(dma_buf_debugfs_dir);
> +       debugfs_remove_recursive(dma_buf_debugfs_dir);
>  }
>  #else
>  static inline int dma_buf_init_debugfs(void)
> --
> 1.9.1
>



--=20
Thanks and regards,

Sumit Semwal
Linaro Mobile Group - Kernel Team Lead
Linaro.org =E2=94=82 Open source software for ARM SoCs
