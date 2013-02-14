Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ia0-f171.google.com ([209.85.210.171]:60194 "EHLO
	mail-ia0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757Ab3BNKqh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Feb 2013 05:46:37 -0500
Received: by mail-ia0-f171.google.com with SMTP id z13so2148318iaz.16
        for <linux-media@vger.kernel.org>; Thu, 14 Feb 2013 02:46:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1360633824-2563-1-git-send-email-sheu@google.com>
References: <1360633824-2563-1-git-send-email-sheu@google.com>
Date: Thu, 14 Feb 2013 11:46:36 +0100
Message-ID: <CAKMK7uEEKwQDFTzv_nM8p6hXY2DiwTYpjPhQXFb2EKuR=o8=Ag@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [PATCH] CHROMIUM: dma-buf: restore args on
 failure of dma_buf_mmap
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: sheu@google.com
Cc: sumit.semwal@linaro.org, linaro-mm-sig@lists.linaro.org,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 12, 2013 at 2:50 AM,  <sheu@google.com> wrote:
> From: John Sheu <sheu@google.com>
>
> Callers to dma_buf_mmap expect to fput() the vma struct's vm_file
> themselves on failure.  Not restoring the struct's data on failure
> causes a double-decrement of the vm_file's refcount.
>
> Signed-off-by: John Sheu <sheu@google.com>

Yeah, makes sense that this little helper here cleans up any damage it
caused when the callback fails.

Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
>
> ---
>  drivers/base/dma-buf.c |   21 +++++++++++++++------
>  1 files changed, 15 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
> index 09e6878..06c6225 100644
> --- a/drivers/base/dma-buf.c
> +++ b/drivers/base/dma-buf.c
> @@ -536,6 +536,9 @@ EXPORT_SYMBOL_GPL(dma_buf_kunmap);
>  int dma_buf_mmap(struct dma_buf *dmabuf, struct vm_area_struct *vma,
>                  unsigned long pgoff)
>  {
> +       struct file *oldfile;
> +       int ret;
> +
>         if (WARN_ON(!dmabuf || !vma))
>                 return -EINVAL;
>
> @@ -549,15 +552,21 @@ int dma_buf_mmap(struct dma_buf *dmabuf, struct vm_area_struct *vma,
>                 return -EINVAL;
>
>         /* readjust the vma */
> -       if (vma->vm_file)
> -               fput(vma->vm_file);
> -
> +       get_file(dmabuf->file);
> +       oldfile = vma->vm_file;
>         vma->vm_file = dmabuf->file;
> -       get_file(vma->vm_file);
> -
>         vma->vm_pgoff = pgoff;
>
> -       return dmabuf->ops->mmap(dmabuf, vma);
> +       ret = dmabuf->ops->mmap(dmabuf, vma);
> +       if (ret) {
> +               /* restore old parameters on failure */
> +               vma->vm_file = oldfile;
> +               fput(dmabuf->file);
> +       } else {
> +               if (oldfile)
> +                       fput(oldfile);
> +       }
> +       return ret;
>  }
>  EXPORT_SYMBOL_GPL(dma_buf_mmap);
>
> --
> 1.7.8.6
>
>
> _______________________________________________
> Linaro-mm-sig mailing list
> Linaro-mm-sig@lists.linaro.org
> http://lists.linaro.org/mailman/listinfo/linaro-mm-sig



-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
