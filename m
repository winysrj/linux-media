Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:46173 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753533Ab1DUH7y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Apr 2011 03:59:54 -0400
Date: Thu, 21 Apr 2011 09:59:47 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Bob Liu <lliubbo@gmail.com>
Cc: linux-media@vger.kernel.org, dhowells@redhat.com,
	linux-uvc-devel@lists.berlios.de, mchehab@redhat.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	sakari.ailus@maxwell.research.nokia.com, martin_rubli@logitech.com,
	jarod@redhat.com, tj@kernel.org, arnd@arndb.de, fweisbec@gmail.com,
	agust@denx.de, gregkh@suse.de, vapier@gentoo.org
Subject: Re: [PATCH v3] media:uvc_driver: add uvc support on no-mmu arch
Message-ID: <20110421075947.GA8178@minime.bse>
References: <1303355862-17507-1-git-send-email-lliubbo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303355862-17507-1-git-send-email-lliubbo@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Bob,

On Thu, Apr 21, 2011 at 11:17:42AM +0800, Bob Liu wrote:
> +#ifdef CONFIG_MMU
>  	if (i == queue->count || size != queue->buf_size) {
> +#else
> +	if (i == queue->count || PAGE_ALIGN(size) != queue->buf_size) {
> +#endif

on mmu systems do_mmap_pgoff contains a len = PAGE_ALIGN(len); line.
If we depend on this behavior, why not do it here as well and get rid
of the #ifdef?

> +unsigned long uvc_queue_get_unmapped_area(struct uvc_video_queue *queue,
> +		unsigned long addr, unsigned long len, unsigned long pgoff)
> +{
> +	struct uvc_buffer *buffer;
> +	unsigned int i;
> +	int ret = 0;

You still didn't change ret to unsigned long.

> +	addr = (unsigned long)queue->mem + buffer->buf.m.offset;
> +	ret = addr;

Why the intermediate step using addr?

> diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
> index 498e674..221e73f 100644
> --- a/drivers/media/video/v4l2-dev.c
> +++ b/drivers/media/video/v4l2-dev.c
> @@ -368,6 +368,23 @@ static int v4l2_mmap(struct file *filp, struct vm_area_struct *vm)
>  	return ret;
>  }
>  
> +#ifdef CONFIG_MMU
> +#define v4l2_get_unmapped_area NULL
> +#else
> +static unsigned long v4l2_get_unmapped_area(struct file *filp,
> +		unsigned long addr, unsigned long len, unsigned long pgoff,
> +		unsigned long flags)
> +{
> +	struct video_device *vdev = video_devdata(filp);
> +
> +	if (!vdev->fops->get_unmapped_area)
> +		return -ENOSYS;
> +	if (!video_is_registered(vdev))
> +		return -ENODEV;
> +	return vdev->fops->get_unmapped_area(filp, addr, len, pgoff, flags);
> +}
> +#endif
> +
>  /* Override for the open function */
>  static int v4l2_open(struct inode *inode, struct file *filp)
>  {
> @@ -452,6 +469,7 @@ static const struct file_operations v4l2_fops = {
>  	.write = v4l2_write,
>  	.open = v4l2_open,
>  	.mmap = v4l2_mmap,
> +	.get_unmapped_area = v4l2_get_unmapped_area,
>  	.unlocked_ioctl = v4l2_ioctl,
>  #ifdef CONFIG_COMPAT
>  	.compat_ioctl = v4l2_compat_ioctl32,
> diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
> index 8266d5a..0616a43 100644
> --- a/include/media/v4l2-dev.h
> +++ b/include/media/v4l2-dev.h
> @@ -63,6 +63,8 @@ struct v4l2_file_operations {
>  	long (*ioctl) (struct file *, unsigned int, unsigned long);
>  	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
>  	int (*mmap) (struct file *, struct vm_area_struct *);
> +	unsigned long (*get_unmapped_area) (struct file *, unsigned long,
> +			unsigned long, unsigned long, unsigned long);
>  	int (*open) (struct file *);
>  	int (*release) (struct file *);
>  };

I'd prefer a git revert c29fcff3daafbf46d64a543c1950bbd206ad8c1c for
this block instead of reverting it together with the UVC changes.

  Daniel
