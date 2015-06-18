Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:34869 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454AbbFRNYq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jun 2015 09:24:46 -0400
Received: by lbbwc1 with SMTP id wc1so52329974lbb.2
        for <linux-media@vger.kernel.org>; Thu, 18 Jun 2015 06:24:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1433327783-29552-1-git-send-email-m.szyprowski@samsung.com>
References: <1433327783-29552-1-git-send-email-m.szyprowski@samsung.com>
Date: Thu, 18 Jun 2015 14:24:45 +0100
Message-ID: <CAP3TMiGB2qpz03vhOXKVy+fCPj-MBKJ03G94-0b97ORaCnVTFA@mail.gmail.com>
Subject: Re: [PATCH 1/2] media: s5p-mfc: add return value check in mfc_sys_init_cmd
From: Kamil Debski <kamil@wypas.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-media@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 3 June 2015 at 11:36, Marek Szyprowski <m.szyprowski@samsung.com> wrote:
> alloc_dev_context_buffer method might fail, so add proper return value
> check.
>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>

Acked-by: Kamil Debski <kamil@wypas.org>

> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c
> index f176096..b1b1491 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c
> @@ -37,8 +37,12 @@ static int s5p_mfc_sys_init_cmd_v6(struct s5p_mfc_dev *dev)
>  {
>         struct s5p_mfc_cmd_args h2r_args;
>         struct s5p_mfc_buf_size_v6 *buf_size = dev->variant->buf_size->priv;
> +       int ret;
> +
> +       ret = s5p_mfc_hw_call(dev->mfc_ops, alloc_dev_context_buffer, dev);
> +       if (ret)
> +               return ret;
>
> -       s5p_mfc_hw_call(dev->mfc_ops, alloc_dev_context_buffer, dev);
>         mfc_write(dev, dev->ctx_buf.dma, S5P_FIMV_CONTEXT_MEM_ADDR_V6);
>         mfc_write(dev, buf_size->dev_ctx, S5P_FIMV_CONTEXT_MEM_SIZE_V6);
>         return s5p_mfc_cmd_host2risc_v6(dev, S5P_FIMV_H2R_CMD_SYS_INIT_V6,
> --
> 1.9.2
>
