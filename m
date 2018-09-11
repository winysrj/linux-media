Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:34218 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726554AbeIKOhf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Sep 2018 10:37:35 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: dri-devel@lists.freedesktop.org,
        Sumit Semwal <sumit.semwal@linaro.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK"
        <linaro-mm-sig@lists.linaro.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/10] udmabuf: constify udmabuf_create args
Date: Tue, 11 Sep 2018 12:39:16 +0300
Message-ID: <3273517.JkZe1mtvyu@avalon>
In-Reply-To: <20180911065921.23818-6-kraxel@redhat.com>
References: <20180911065921.23818-1-kraxel@redhat.com> <20180911065921.23818-6-kraxel@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gerd,

Thank you for the patch.

On Tuesday, 11 September 2018 09:59:16 EEST Gerd Hoffmann wrote:
> Reported-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
> ---
>  drivers/dma-buf/udmabuf.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dma-buf/udmabuf.c b/drivers/dma-buf/udmabuf.c
> index 44c3c1bf20..0cf7e85585 100644
> --- a/drivers/dma-buf/udmabuf.c
> +++ b/drivers/dma-buf/udmabuf.c
> @@ -116,8 +116,8 @@ static const struct dma_buf_ops udmabuf_ops = {
>  #define SEALS_WANTED (F_SEAL_SHRINK)
>  #define SEALS_DENIED (F_SEAL_WRITE)
> 
> -static long udmabuf_create(struct udmabuf_create_list *head,
> -			   struct udmabuf_create_item *list)
> +static long udmabuf_create(struct const udmabuf_create_list *head,
> +			   struct const udmabuf_create_item *list)

Shouldn't it be const struct, not struct const ?

With that fixed,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

>  {
>  	DEFINE_DMA_BUF_EXPORT_INFO(exp_info);
>  	struct file *memfd = NULL;

-- 
Regards,

Laurent Pinchart
