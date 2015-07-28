Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:47564 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932383AbbG1KFU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jul 2015 06:05:20 -0400
Message-ID: <55B753D4.2080008@xs4all.nl>
Date: Tue, 28 Jul 2015 12:05:08 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org
CC: j.anaszewski@samsung.com
Subject: Re: [PATCH 1/1] v4l: subdev: Serialise open and release internal
 ops
References: <1437581650-1422-1-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1437581650-1422-1-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/22/2015 06:14 PM, Sakari Ailus wrote:
> By default, serialise open and release internal ops using a mutex.
> 
> The underlying problem is that a large proportion of the drivers do use

Well, the only one I found that does this is the flash-led-class :-)

But you are correct in your reply to my comments that the lock has to be
taken in v4l2-subdev.c and not in the driver.

<snip>

> +static void subdev_open_lock(struct v4l2_subdev *sd)
> +{
> +	if (sd->flags & V4L2_SUBDEV_FL_SERIALISE_OPEN)
> +		mutex_lock(&sd->open_lock);
> +}
> +
> +static void subdev_open_unlock(struct v4l2_subdev *sd)
> +{
> +	if (sd->flags & V4L2_SUBDEV_FL_SERIALISE_OPEN)
> +		mutex_unlock(&sd->open_lock);
> +}

I really dislike this flag. Also, I think there are more problems here since
none of the ioctls are serialized so you depend on the driver to get that
right.

My suggestion would be to add a struct mutex *lock pointer to struct v4l2_subdev,
and, if non-NULL, then take that lock for both open/close and ioctls (you take
the lock in subdev_ioctl()).

This is similar to struct video_device and you don't need a flag. In addition,
drivers can provide their own lock.

Regards,

	Hans
