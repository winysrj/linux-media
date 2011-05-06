Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43767 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603Ab1EFIVd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 May 2011 04:21:33 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: lliubbo@gmail.com
Subject: Re: [PATCH 1/2] V4L/DVB: v4l2-dev: revert commit c29fcff3daafbf46d64a543c1950bbd206ad8c1c
Date: Fri, 6 May 2011 10:22:06 +0200
Cc: linux-media@vger.kernel.org, dhowells@redhat.com,
	linux-uvc-devel@lists.berlios.de, mchehab@redhat.com,
	hverkuil@xs4all.nl, sakari.ailus@maxwell.research.nokia.com,
	martin_rubli@logitech.com, jarod@redhat.com, tj@kernel.org,
	arnd@arndb.de, fweisbec@gmail.com, agust@denx.de, gregkh@suse.de,
	daniel-gl@gmx.net, vapier@gentoo.org
References: <1304071895-27898-1-git-send-email-lliubbo@gmail.com>
In-Reply-To: <1304071895-27898-1-git-send-email-lliubbo@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201105061022.06994.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Bob,

On Friday 29 April 2011 12:11:34 Bob Liu wrote:
> Revert commit:
> V4L/DVB: v4l2-dev: remove get_unmapped_area(c29fcff3daafbf46d64a543c1950bb)
> to restore NOMMU arch supporting.
> 
> Signed-off-by: Bob Liu <lliubbo@gmail.com>

git provides a 'git revert' command to revert patches. It formats the commit 
message in a standard way. I'll use it instead of applying this patch to my 
tree and I'll keep your SoB line (unless you object to that).

> ---
>  drivers/media/video/v4l2-dev.c |   18 ++++++++++++++++++
>  include/media/v4l2-dev.h       |    2 ++
>  2 files changed, 20 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-dev.c
> b/drivers/media/video/v4l2-dev.c index 6dc7196..19d5ae2 100644
> --- a/drivers/media/video/v4l2-dev.c
> +++ b/drivers/media/video/v4l2-dev.c
> @@ -352,6 +352,23 @@ static long v4l2_ioctl(struct file *filp, unsigned int
> cmd, unsigned long arg) return ret;
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
>  static int v4l2_mmap(struct file *filp, struct vm_area_struct *vm)
>  {
>  	struct video_device *vdev = video_devdata(filp);
> @@ -454,6 +471,7 @@ static const struct file_operations v4l2_fops = {
>  	.read = v4l2_read,
>  	.write = v4l2_write,
>  	.open = v4l2_open,
> +	.get_unmapped_area = v4l2_get_unmapped_area,
>  	.mmap = v4l2_mmap,
>  	.unlocked_ioctl = v4l2_ioctl,
>  #ifdef CONFIG_COMPAT
> diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
> index 8266d5a..93e96fb 100644
> --- a/include/media/v4l2-dev.h
> +++ b/include/media/v4l2-dev.h
> @@ -62,6 +62,8 @@ struct v4l2_file_operations {
>  	unsigned int (*poll) (struct file *, struct poll_table_struct *);
>  	long (*ioctl) (struct file *, unsigned int, unsigned long);
>  	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
> +	unsigned long (*get_unmapped_area) (struct file *, unsigned long,
> +				unsigned long, unsigned long, unsigned long);
>  	int (*mmap) (struct file *, struct vm_area_struct *);
>  	int (*open) (struct file *);
>  	int (*release) (struct file *);

-- 
Regards,

Laurent Pinchart
