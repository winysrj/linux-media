Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:34268 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752590AbeENVEJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 May 2018 17:04:09 -0400
Message-ID: <484364ff89a20e55700eb8ff993c11e67b6f9c38.camel@collabora.com>
Subject: Re: [RFC PATCH 2/6] v4l2-core: push taking ioctl mutex down to
 ioctl handler.
From: Ezequiel Garcia <ezequiel@collabora.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Mike Isely <isely@pobox.com>, Hans Verkuil <hansverk@cisco.com>
Date: Mon, 14 May 2018 18:02:45 -0300
In-Reply-To: <20180514115602.9791-3-hverkuil@xs4all.nl>
References: <20180514115602.9791-1-hverkuil@xs4all.nl>
         <20180514115602.9791-3-hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2018-05-14 at 13:55 +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hansverk@cisco.com>
> 
> The ioctl serialization mutex (vdev->lock or q->lock for vb2 queues)
> was taken at the highest level in v4l2-dev.c. This prevents more
> fine-grained locking since at that level we cannot examine the ioctl
> arguments, we can only do that after video_usercopy is called.
> 
> So push the locking down to __video_do_ioctl() and subdev_do_ioctl_lock().
> 
> This also allows us to make a few functions in v4l2-ioctl.c static and
> video_usercopy() is no longer exported.
> 
> The locking scheme is not changed by this patch, just pushed down.
> 
> Signed-off-by: Hans Verkuil <hansverk@cisco.com>
> ---
>  drivers/media/v4l2-core/v4l2-dev.c    |  6 ------
>  drivers/media/v4l2-core/v4l2-ioctl.c  | 17 ++++++++++++++---
>  drivers/media/v4l2-core/v4l2-subdev.c | 17 ++++++++++++++++-
>  include/media/v4l2-dev.h              |  9 ---------
>  include/media/v4l2-ioctl.h            | 12 ------------
>  5 files changed, 30 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
> index c4f4357e9ca4..4ffd7d60a901 100644
> --- a/drivers/media/v4l2-core/v4l2-dev.c
> +++ b/drivers/media/v4l2-core/v4l2-dev.c
> @@ -360,14 +360,8 @@ static long v4l2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  	int ret = -ENODEV;
>  
>  	if (vdev->fops->unlocked_ioctl) {
> -		struct mutex *lock = v4l2_ioctl_get_lock(vdev, cmd);
> -
> -		if (lock && mutex_lock_interruptible(lock))
> -			return -ERESTARTSYS;
>  		if (video_is_registered(vdev))

This is_registered check looks spurious.

Other than that, it looks good.
