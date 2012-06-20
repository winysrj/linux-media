Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:8747 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756779Ab2FTPl5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jun 2012 11:41:57 -0400
Message-id: <4FE1EF42.1000403@samsung.com>
Date: Wed, 20 Jun 2012 17:41:54 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
MIME-version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-fbdev@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	linux-media@vger.kernel.org
Subject: Re: [Linaro-mm-sig] [RFC/PATCH] fb: Add dma-buf support
References: <1340201368-20751-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-reply-to: <1340201368-20751-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,
Thank you for the patch.

On 06/20/2012 04:09 PM, Laurent Pinchart wrote:
> Add support for the dma-buf exporter role to the frame buffer API. The
> importer role isn't meaningful for frame buffer devices, as the frame
> buffer device model doesn't allow using externally allocated memory.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  Documentation/fb/api.txt |   36 ++++++++++++++++++++++++++++++++++++
>  drivers/video/fbmem.c    |   36 ++++++++++++++++++++++++++++++++++++
>  include/linux/fb.h       |   12 ++++++++++++
>  3 files changed, 84 insertions(+), 0 deletions(-)
> 

[snip]

> +The export a frame buffer as a dma-buf file descriptors, applications call the
> +FBIOGET_DMABUF ioctl. The ioctl takes a pointer to a fb_dmabuf_export
> +structure.
> +
> +struct fb_dmabuf_export {
> +	__u32 fd;
> +	__u32 flags;
> +};

What do you think about adding some reserved fields to
struct fb_dmabuf_export to make it future-proof for
DMABUF extensions?

> +
> +The flag field specifies the flags to be used when creating the dma-buf file
> +descriptor. The only supported flag is O_CLOEXEC. If the call is successful,
> +the driver will set the fd field to a file descriptor corresponding to the
> +dma-buf object.
> +
> +Applications can then pass the file descriptors to another application or
> +another device driver. The dma-buf object is automatically reference-counted,
> +applications can and should close the file descriptor as soon as they don't
> +need it anymore. The underlying dma-buf object will not be freed before the
> +last device that uses the dma-buf object releases it.
> diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
> index 0dff12a..400e449 100644
> --- a/drivers/video/fbmem.c
> +++ b/drivers/video/fbmem.c
> @@ -15,6 +15,7 @@
>  
>  #include <linux/compat.h>
>  #include <linux/types.h>
> +#include <linux/dma-buf.h>
>  #include <linux/errno.h>
>  #include <linux/kernel.h>
>  #include <linux/major.h>
> @@ -1074,6 +1075,23 @@ fb_blank(struct fb_info *info, int blank)
>   	return ret;
>  }
>  
> +#ifdef CONFIG_DMA_SHARED_BUFFER
> +int
> +fb_get_dmabuf(struct fb_info *info, int flags)
> +{
> +	struct dma_buf *dmabuf;
> +
> +	if (info->fbops->fb_dmabuf_export == NULL)
> +		return -ENOTTY;
> +
> +	dmabuf = info->fbops->fb_dmabuf_export(info);

IMO, it is not a good idea to delegate an implementation of
DMABUF ops to the driver. Maybe exporting could be handled
inside FB stack. As I understand, the FB stack needs only
'get-scatterlist' ops from an FB driver. All other
DMABUF magic does not need driver involvement, does it?

> +	if (IS_ERR(dmabuf))
> +		return PTR_ERR(dmabuf);
> +
> +	return dma_buf_fd(dmabuf, flags);
> +}
> +#endif
> +
>

[snip]

> diff --git a/include/linux/fb.h b/include/linux/fb.h
> index ac3f1c6..c9fee75 100644
> --- a/include/linux/fb.h
> +++ b/include/linux/fb.h
> @@ -701,6 +708,11 @@ struct fb_ops {
>  	/* called at KDB enter and leave time to prepare the console */
>  	int (*fb_debug_enter)(struct fb_info *info);
>  	int (*fb_debug_leave)(struct fb_info *info);
> +
> +#ifdef CONFIG_DMA_SHARED_BUFFER
> +	/* Export the frame buffer as a dmabuf object */
> +	struct dma_buf *(*fb_dmabuf_export)(struct fb_info *info);
> +#endif

Memory trashing or even kernel crash may happen if a module compiled
with CONFIG_DMA_SHARED_BUFFER enabled is loaded into kernel with
CONFIG_DMA_SHARED_BUFFER disabled.

>  };
>  
>  #ifdef CONFIG_FB_TILEBLITTING

