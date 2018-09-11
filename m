Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:34238 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726554AbeIKOi3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Sep 2018 10:38:29 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: dri-devel@lists.freedesktop.org,
        Sumit Semwal <sumit.semwal@linaro.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK"
        <linaro-mm-sig@lists.linaro.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/10] udmabuf: add MEMFD_CREATE dependency
Date: Tue, 11 Sep 2018 12:40:10 +0300
Message-ID: <9324055.sTKbuWCmpk@avalon>
In-Reply-To: <20180911065921.23818-7-kraxel@redhat.com>
References: <20180911065921.23818-1-kraxel@redhat.com> <20180911065921.23818-7-kraxel@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gerd,

Thank you for the patch.

On Tuesday, 11 September 2018 09:59:17 EEST Gerd Hoffmann wrote:
> udmabuf builds without it, but if userspace can not create memfd
> handles in the first place it is rather pointless to include it.

Except perhaps for compile test coverage ? How about

	depends on MEMFD_CREATE || COMPILE_TEST

?

> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
> ---
>  drivers/dma-buf/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/dma-buf/Kconfig b/drivers/dma-buf/Kconfig
> index 338129eb12..fc3fe3f04e 100644
> --- a/drivers/dma-buf/Kconfig
> +++ b/drivers/dma-buf/Kconfig
> @@ -34,6 +34,7 @@ config UDMABUF
>  	bool "userspace dmabuf misc driver"
>  	default n
>  	depends on DMA_SHARED_BUFFER
> +	depends on MEMFD_CREATE
>  	help
>  	  A driver to let userspace turn memfd regions into dma-bufs.
>  	  Qemu can use this to create host dmabufs for guest framebuffers.


-- 
Regards,

Laurent Pinchart
