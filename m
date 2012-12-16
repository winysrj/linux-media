Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:48860 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab2LPQ5S (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Dec 2012 11:57:18 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so2799839eek.19
        for <linux-media@vger.kernel.org>; Sun, 16 Dec 2012 08:57:17 -0800 (PST)
Message-ID: <50CDFD51.3030800@gmail.com>
Date: Sun, 16 Dec 2012 17:56:49 +0100
From: Francesco Lavra <francescolavra.fl@gmail.com>
MIME-Version: 1.0
To: sumit.semwal@ti.com
CC: sumit.semwal@linaro.org, linaro-mm-sig@lists.linaro.org,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Subject: Re: [Linaro-mm-sig] [PATCH] dma-buf: Add debugfs support
References: <1355477817-5750-1-git-send-email-sumit.semwal@ti.com>
In-Reply-To: <1355477817-5750-1-git-send-email-sumit.semwal@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 12/14/2012 10:36 AM, sumit.semwal@ti.com wrote:
> From: Sumit Semwal <sumit.semwal@linaro.org>
> 
> Add debugfs support to make it easier to print debug information
> about the dma-buf buffers.
> 
> Signed-off-by: Sumit Semwal <sumit.semwal@ti.com>
> ---
>  drivers/base/dma-buf.c  |  149 +++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/dma-buf.h |    6 +-
>  2 files changed, 154 insertions(+), 1 deletion(-)
[...]
> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
> index bd2e52c..160453f 100644
> --- a/include/linux/dma-buf.h
> +++ b/include/linux/dma-buf.h
> @@ -112,6 +112,7 @@ struct dma_buf_ops {
>   * @file: file pointer used for sharing buffers across, and for refcounting.
>   * @attachments: list of dma_buf_attachment that denotes all devices attached.
>   * @ops: dma_buf_ops associated with this buffer object.
> + * @list_node: node for dma_buf accounting and debugging.
>   * @priv: exporter specific private data for this buffer object.
>   */
>  struct dma_buf {
> @@ -121,6 +122,8 @@ struct dma_buf {
>  	const struct dma_buf_ops *ops;
>  	/* mutex to serialize list manipulation and attach/detach */
>  	struct mutex lock;
> +
> +	struct list_head list_node;
>  	void *priv;
>  };
>  
> @@ -183,5 +186,6 @@ int dma_buf_mmap(struct dma_buf *, struct vm_area_struct *,
>  		 unsigned long);
>  void *dma_buf_vmap(struct dma_buf *);
>  void dma_buf_vunmap(struct dma_buf *, void *vaddr);
> -
> +int dma_buf_debugfs_create_file(const char *name,
> +				int (*write)(struct seq_file *));

Why is this function declared in the public header file?

--
Francesco
