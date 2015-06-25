Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51466 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751256AbbFYJMj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jun 2015 05:12:39 -0400
Date: Thu, 25 Jun 2015 12:12:36 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH] v4l2-event: v4l2_event_queue: do nothing if vdev == NULL
Message-ID: <20150625091236.GH5904@valkosipuli.retiisi.org.uk>
References: <558924D7.4010904@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <558924D7.4010904@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tue, Jun 23, 2015 at 11:20:23AM +0200, Hans Verkuil wrote:
> If the vdev pointer == NULL, then just return.
> 
> This makes it easier for subdev drivers to use this function without having to
> check if the sd->devnode pointer is NULL or not.

Do you have an example of when this would be useful? Isn't it a rather
fundamental question to a driver whether or not it exposes a device node,
i.e. why would a driver use v4l2_event_queue() in the first place if it does
not expose a device node, and so the event interface?

> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> diff --git a/drivers/media/v4l2-core/v4l2-event.c b/drivers/media/v4l2-core/v4l2-event.c
> index 8761aab..8d3171c 100644
> --- a/drivers/media/v4l2-core/v4l2-event.c
> +++ b/drivers/media/v4l2-core/v4l2-event.c
> @@ -172,6 +172,9 @@ void v4l2_event_queue(struct video_device *vdev, const struct v4l2_event *ev)
>  	unsigned long flags;
>  	struct timespec timestamp;
> 
> +	if (vdev == NULL)
> +		return;
> +
>  	ktime_get_ts(&timestamp);
> 
>  	spin_lock_irqsave(&vdev->fh_lock, flags);

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
