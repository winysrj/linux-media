Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:34049 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbcCIJD5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Mar 2016 04:03:57 -0500
Received: by mail-ob0-f178.google.com with SMTP id ts10so40472731obc.1
        for <linux-media@vger.kernel.org>; Wed, 09 Mar 2016 01:03:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1457513642-10859-1-git-send-email-benjamin.gaignard@linaro.org>
References: <1457513642-10859-1-git-send-email-benjamin.gaignard@linaro.org>
Date: Wed, 9 Mar 2016 10:03:56 +0100
Message-ID: <CAKMK7uEzCdaBcOFqmTsFCxKKaXbfxvmkSqEtaotj2F5Giba1pQ@mail.gmail.com>
Subject: Re: [PATCH] dmabuf: allow exporter to define customs ioctls
From: Daniel Vetter <daniel@ffwll.ch>
To: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Cc: dri-devel <dri-devel@lists.freedesktop.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	John Stultz <john.stultz@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 9, 2016 at 9:54 AM, Benjamin Gaignard
<benjamin.gaignard@linaro.org> wrote:
> In addition of the already existing operations allow exporter
> to use it own custom ioctls.
>
> Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>

First reaction: No way ever! More seriously, please start by
explaining why you need this.
-Daniel

> ---
>  drivers/dma-buf/dma-buf.c | 3 +++
>  include/linux/dma-buf.h   | 5 +++++
>  2 files changed, 8 insertions(+)
>
> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> index 9810d1d..6abd129 100644
> --- a/drivers/dma-buf/dma-buf.c
> +++ b/drivers/dma-buf/dma-buf.c
> @@ -291,6 +291,9 @@ static long dma_buf_ioctl(struct file *file,
>
>                 return 0;
>         default:
> +               if (dmabuf->ops->ioctl)
> +                       return dmabuf->ops->ioctl(dmabuf, cmd, arg);
> +
>                 return -ENOTTY;
>         }
>  }
> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
> index 532108e..b6f9837 100644
> --- a/include/linux/dma-buf.h
> +++ b/include/linux/dma-buf.h
> @@ -70,6 +70,9 @@ struct dma_buf_attachment;
>   * @vmap: [optional] creates a virtual mapping for the buffer into kernel
>   *       address space. Same restrictions as for vmap and friends apply.
>   * @vunmap: [optional] unmaps a vmap from the buffer
> + * @ioctl: [optional] ioctls supported by the exporter.
> + *        It is up to the exporter to do the proper copy_{from/to}_user
> + *        calls. Should return -EINVAL in case of error.
>   */
>  struct dma_buf_ops {
>         int (*attach)(struct dma_buf *, struct device *,
> @@ -104,6 +107,8 @@ struct dma_buf_ops {
>
>         void *(*vmap)(struct dma_buf *);
>         void (*vunmap)(struct dma_buf *, void *vaddr);
> +
> +       int (*ioctl)(struct dma_buf *, unsigned int cmd, unsigned long arg);
>  };
>
>  /**
> --
> 1.9.1
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel



-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
