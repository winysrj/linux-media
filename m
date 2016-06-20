Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34045 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180AbcFTNa2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2016 09:30:28 -0400
Received: by mail-wm0-f66.google.com with SMTP id 187so14145652wmz.1
        for <linux-media@vger.kernel.org>; Mon, 20 Jun 2016 06:30:27 -0700 (PDT)
Date: Mon, 20 Jun 2016 15:30:18 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Mathias Krause <minipli@googlemail.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
	Brad Spengler <spender@grsecurity.net>,
	PaX Team <pageexec@freemail.hu>, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [PATCH 1/3] dma-buf: propagate errors from dma_buf_describe() on
 debugfs read
Message-ID: <20160620133018.GJ23520@phenom.ffwll.local>
References: <1466339491-12639-1-git-send-email-minipli@googlemail.com>
 <1466339491-12639-2-git-send-email-minipli@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1466339491-12639-2-git-send-email-minipli@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jun 19, 2016 at 02:31:29PM +0200, Mathias Krause wrote:
> The callback function dma_buf_describe() returns an int not void so the
> function pointer cast in dma_buf_show() is wrong. dma_buf_describe() can
> also fail when acquiring the mutex gets interrupted so always returning
> 0 in dma_buf_show() is wrong, too.
> 
> Fix both issues by avoiding the indirection via dma_buf_show() and call
> dma_buf_describe() directly. Rename it to dma_buf_debug_show() to get it
> in line with the other functions.
> 
> This type mismatch was caught by the PaX RAP plugin.
> 
> Signed-off-by: Mathias Krause <minipli@googlemail.com>
> Cc: Sumit Semwal <sumit.semwal@linaro.org>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Brad Spengler <spender@grsecurity.net>
> Cc: PaX Team <pageexec@freemail.hu>
> ---
>  drivers/dma-buf/dma-buf.c |   14 +++-----------
>  1 file changed, 3 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> index 6355ab38d630..7094b19bb495 100644
> --- a/drivers/dma-buf/dma-buf.c
> +++ b/drivers/dma-buf/dma-buf.c
> @@ -824,7 +824,7 @@ void dma_buf_vunmap(struct dma_buf *dmabuf, void *vaddr)
>  EXPORT_SYMBOL_GPL(dma_buf_vunmap);
>  
>  #ifdef CONFIG_DEBUG_FS
> -static int dma_buf_describe(struct seq_file *s)
> +static int dma_buf_debug_show(struct seq_file *s, void *unused)
>  {
>  	int ret;
>  	struct dma_buf *buf_obj;
> @@ -879,17 +879,9 @@ static int dma_buf_describe(struct seq_file *s)
>  	return 0;
>  }
>  
> -static int dma_buf_show(struct seq_file *s, void *unused)
> -{
> -	void (*func)(struct seq_file *) = s->private;
> -
> -	func(s);
> -	return 0;
> -}
> -
>  static int dma_buf_debug_open(struct inode *inode, struct file *file)
>  {
> -	return single_open(file, dma_buf_show, inode->i_private);
> +	return single_open(file, dma_buf_debug_show, NULL);
>  }
>  
>  static const struct file_operations dma_buf_debug_fops = {
> @@ -913,7 +905,7 @@ static int dma_buf_init_debugfs(void)
>  		return err;
>  	}
>  
> -	err = dma_buf_debugfs_create_file("bufinfo", dma_buf_describe);
> +	err = dma_buf_debugfs_create_file("bufinfo", NULL);

This indirection now doesn't make much sense I think. I think more
sensible to instead pass drm_buf_debug_show, since that's the
parametrization that matters. Or just inline that one too.
-Daniel

>  
>  	if (err)
>  		pr_debug("dma_buf: debugfs: failed to create node bufinfo\n");
> -- 
> 1.7.10.4
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
