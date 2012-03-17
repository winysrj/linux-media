Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:50417 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab2CQEL0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Mar 2012 00:11:26 -0400
Received: by qcqw6 with SMTP id w6so365742qcq.19
        for <linux-media@vger.kernel.org>; Fri, 16 Mar 2012 21:11:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1331928144-30628-1-git-send-email-rob.clark@linaro.org>
References: <1331928144-30628-1-git-send-email-rob.clark@linaro.org>
Date: Sat, 17 Mar 2012 13:11:26 +0900
Message-ID: <CAH9JG2WKuxTxjwuN+vnXXcjn0EtZQEC5vnD6o5PQv9Lx95ydzw@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [PATCH] dma-buf: add get_dma_buf()
From: Kyungmin Park <kmpark@infradead.org>
To: Rob Clark <rob.clark@linaro.org>
Cc: linaro-mm-sig@lists.linaro.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, airlied@redhat.com, daniel@ffwll.ch,
	patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>

On 3/17/12, Rob Clark <rob.clark@linaro.org> wrote:
> From: Rob Clark <rob@ti.com>
>
> Works in a similar way to get_file(), and is needed in cases such as
> when the exporter needs to also keep a reference to the dmabuf (that
> is later released with a dma_buf_put()), and possibly other similar
> cases.
>
> Signed-off-by: Rob Clark <rob@ti.com>
> ---
> Minor update on original to add a missing #include
>
>  include/linux/dma-buf.h |   15 +++++++++++++++
>  1 files changed, 15 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
> index 891457a..bc4203dc 100644
> --- a/include/linux/dma-buf.h
> +++ b/include/linux/dma-buf.h
> @@ -30,6 +30,7 @@
>  #include <linux/scatterlist.h>
>  #include <linux/list.h>
>  #include <linux/dma-mapping.h>
> +#include <linux/fs.h>
>
>  struct dma_buf;
>  struct dma_buf_attachment;
> @@ -110,6 +111,20 @@ struct dma_buf_attachment {
>  	void *priv;
>  };
>
> +/**
> + * get_dma_buf - convenience wrapper for get_file.
> + * @dmabuf:	[in]	pointer to dma_buf
> + *
> + * Increments the reference count on the dma-buf, needed in case of drivers
> + * that either need to create additional references to the dmabuf on the
> + * kernel side.  For example, an exporter that needs to keep a dmabuf ptr
> + * so that subsequent exports don't create a new dmabuf.
> + */
> +static inline void get_dma_buf(struct dma_buf *dmabuf)
> +{
> +	get_file(dmabuf->file);
> +}
> +
>  #ifdef CONFIG_DMA_SHARED_BUFFER
>  struct dma_buf_attachment *dma_buf_attach(struct dma_buf *dmabuf,
>  							struct device *dev);
> --
> 1.7.5.4
>
>
> _______________________________________________
> Linaro-mm-sig mailing list
> Linaro-mm-sig@lists.linaro.org
> http://lists.linaro.org/mailman/listinfo/linaro-mm-sig
>
