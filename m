Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4801 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab0HALOc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Aug 2010 07:14:32 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC/PATCH v3 01/10] media: Media device node support
Date: Sun, 1 Aug 2010 13:14:18 +0200
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1280419616-7658-1-git-send-email-laurent.pinchart@ideasonboard.com> <1280419616-7658-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1280419616-7658-2-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201008011314.18882.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 29 July 2010 18:06:34 Laurent Pinchart wrote:
> The media_devnode structure provides support for registering and
> unregistering character devices using a dynamic major number. Reference
> counting is handled internally, making device drivers easier to write
> without having to solve the open/disconnect race condition issue over
> and over again.
> 
> The code is based on video/v4l2-dev.c.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/Makefile        |    8 +-
>  drivers/media/media-devnode.c |  326 +++++++++++++++++++++++++++++++++++++++++
>  include/media/media-devnode.h |   84 +++++++++++
>  3 files changed, 416 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/media/media-devnode.c
>  create mode 100644 include/media/media-devnode.h
> 

<snip>

> diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
> new file mode 100644
> index 0000000..6f5558c
> --- /dev/null
> +++ b/drivers/media/media-devnode.c

<snip>

> +/* Override for the open function */
> +static int media_open(struct inode *inode, struct file *filp)
> +{
> +	struct media_devnode *mdev;
> +	int ret;
> +
> +	/* Check if the media device is available. This needs to be done with
> +	 * the media_devnode_lock held to prevent an open/unregister race:
> +	 * without the lock, the device could be unregistered and freed between
> +	 * the media_devnode_is_registered() and get_device() calls, leading to
> +	 * a crash.
> +	 */
> +	mutex_lock(&media_devnode_lock);
> +	mdev = container_of(inode->i_cdev, struct media_devnode, cdev);
> +	/* return ENODEV if the media device has been removed
> +	   already or if it is not registered anymore. */
> +	if (!media_devnode_is_registered(mdev)) {
> +		mutex_unlock(&media_devnode_lock);
> +		return -ENODEV;
> +	}
> +	/* and increase the device refcount */
> +	get_device(&mdev->dev);
> +	mutex_unlock(&media_devnode_lock);
> +	if (mdev->fops->open) {
> +		ret = mdev->fops->open(filp);
> +		if (ret) {
> +			put_device(&mdev->dev);
> +			return ret;
> +		}
> +	}
> +
> +	filp->private_data = mdev;

This line should be moved up to before the if: that way the open op can rely
on private_data being setup correctly.

> +	return 0;
> +}

<snip>

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
