Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:53633 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032437Ab2CPKvN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Mar 2012 06:51:13 -0400
Message-ID: <4F631B05.6090601@stericsson.com>
Date: Fri, 16 Mar 2012 11:50:45 +0100
From: Marcus Lorentzon <marcus.xm.lorentzon@stericsson.com>
MIME-Version: 1.0
To: Rob Clark <rob.clark@linaro.org>
Cc: "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"rschultz@google.com" <rschultz@google.com>,
	"daniel@ffwll.ch" <daniel@ffwll.ch>,
	"patches@linaro.org" <patches@linaro.org>
Subject: Re: [Linaro-mm-sig] [PATCH] RFC: dma-buf: userspace mmap support
References: <1331775148-5001-1-git-send-email-rob.clark@linaro.org>
In-Reply-To: <1331775148-5001-1-git-send-email-rob.clark@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/15/2012 02:32 AM, Rob Clark wrote:
> From: Rob Clark<rob@ti.com>
> [snip]
> In all cases, the mmap() call is allowed to fail, and the associated
> dma_buf_ops are optional (mmap() will fail if at least the mmap()
> op is not implemented by the exporter, but in either case the
> {prepare,finish}_access() ops are optional).
I sort of understand this approach. It allowes some implementations 
(ARM/Android) to move forward. But how would an application act if mmap 
fails? What is the option? How can the application detect if mmap is 
possible or not? Or is this mmap only supposed to be used from device 
specific libs like libdrm-xx/libv4l2-xx/libgralloc?

Can mmap fail for one buffer, but not another? Can it fail for a buffer 
that have successfully been mmapped once before (except for the usual 
ENOMEM/EAGAIN etc)?
> For now the prepare/finish access ioctls are kept simple with no
> argument, although there is possibility to add additional ioctls
> (or simply change the existing ioctls from _IO() to _IOW()) later
> to provide optimization to allow userspace to specify a region of
> interest.
I like the idea of simple, assume the worst, no args, versions of 
begin/end access. But once we move forward, I don't just like the 
region, but also access type (R/W). R/W info allows the driver to make 
cache management optimizations otherwise impossible. Like if CPU with no 
alloc-on-write just write, a write buffer flush is enough to switch to a 
HW read. And (at least on ARM) cache clean can be done for all cache for 
large areas, but invalidate has to be done line by line. Eliminating the 
need to do invalidate, especially if region is small, compared to 
invalidate entire buffer line by line can make a huge difference.
But I would like these in a separate ioctl to keep the normal case 
simple. Maybe as a separate patch even.
>
> For a final patch, dma-buf.h would need to be split into what is
> exported to userspace, and what is kernel private, but I wanted to
> get feedback on the idea of requiring userspace to bracket access
> first (vs. limiting this to coherent mappings or exporters who play
> page faltings plus PTE shoot-down games) before I split the header
> which would cause conflicts with other pending dma-buf patches.  So
> flame-on!
Why not just guard the kernel parts with __KERNEL__ or something? Or 
there are guidelines preventing this?

> [snip]
>
> +
> +static long dma_buf_ioctl(struct file *file, unsigned int cmd,
> +		unsigned long arg)
> +{
> +	struct dma_buf *dmabuf;
> +
> +	if (!is_dma_buf_file(file))
> +		return -EINVAL;
> +
> +	dmabuf = file->private_data;
> +
> +	switch (_IOC_NR(cmd)) {
> +	case _IOC_NR(DMA_BUF_IOCTL_PREPARE_ACCESS):
> +		if (dmabuf->ops->prepare_access)
> +			return dmabuf->ops->prepare_access(dmabuf);
> +		return 0;
> +	case _IOC_NR(DMA_BUF_IOCTL_FINISH_ACCESS):
> +		if (dmabuf->ops->finish_access)
> +			return dmabuf->ops->finish_access(dmabuf);
> +		return 0;
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
> +
Multiple empty lines
>   static int dma_buf_release(struct inode *inode, struct file *file)
>   {
>   	struct dma_buf *dmabuf;
> @@ -45,6 +85,8 @@ static int dma_buf_release(struct inode *inode, struct file *file)
>   }
>
>   static const struct file_operations dma_buf_fops = {
> +	.mmap 		= dma_buf_mmap,
> +	.unlocked_ioctl = dma_buf_ioctl,
>   	.release	= dma_buf_release,
>   };
>
> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
> index a885b26..cbdff81 100644
> --- a/include/linux/dma-buf.h
> +++ b/include/linux/dma-buf.h
> @@ -34,6 +34,17 @@
>   struct dma_buf;
>   struct dma_buf_attachment;
>
> +/* TODO: dma-buf.h should be the userspace visible header, and dma-buf-priv.h (?)
> + * the kernel internal header.. for now just stuff these here to avoid conflicting
> + * with other patches..
> + *
> + * For now, no arg to keep things simple, but we could consider adding an
> + * optional region of interest later.
> + */
> +#define DMA_BUF_IOCTL_PREPARE_ACCESS   _IO('Z', 0)
> +#define DMA_BUF_IOCTL_FINISH_ACCESS    _IO('Z', 1)
> +
> +
Multiple empty lines
>   /**
>    * struct dma_buf_ops - operations possible on struct dma_buf
>    * @attach: [optional] allows different devices to 'attach' themselves to the
> @@ -49,6 +60,13 @@ struct dma_buf_attachment;
>    * @unmap_dma_buf: decreases usecount of buffer, might deallocate scatter
>    *		   pages.
>    * @release: release this buffer; to be called after the last dma_buf_put.
> + * @mmap: [optional, allowed to fail] operation called if userspace calls
> + *		 mmap() on the dmabuf fd.  Note that userspace should use the
> + *		 DMA_BUF_PREPARE_ACCESS / DMA_BUF_FINISH_ACCESS ioctls before/after
> + *		 sw access to the buffer, to give the exporter an opportunity to
> + *		 deal with cache maintenance.
> + * @prepare_access: [optional] handler for PREPARE_ACCESS ioctl.
> + * @finish_access: [optional] handler for FINISH_ACCESS ioctl.
xx_access should only be optional if you don't implement mmap. Otherwise 
it will be very hard to implement cache sync in dma_buf (the cpu2dev and 
dev2cpu parts). Introducing cache sync in dma_buf should be a way to 
remove it from dma_buf clients. An option would be for the cache sync 
code to assume the worst for each cpu2dev sync. Even if the CPU has not 
touched anything.

In short, very welcome patch ...

/BR
/Marcus

