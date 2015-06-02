Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48368 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152AbbFBCqq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Jun 2015 22:46:46 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
	j.anaszewski@samsung.com, cooloney@gmail.com,
	s.nawrocki@samsung.com, mchehab@osg.samsung.com,
	g.liakhovetski@gmx.de
Subject: Re: [PATCH v1.1 1/5] v4l: async: Add a pointer to of_node to struct v4l2_subdev, match it
Date: Tue, 02 Jun 2015 05:47:12 +0300
Message-ID: <1668366.2mMvbSMUnT@avalon>
In-Reply-To: <1433111079-22457-1-git-send-email-sakari.ailus@iki.fi>
References: <4071589.mUaJIGvIJX@avalon> <1433111079-22457-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch. Please see below for one small comment.

On Monday 01 June 2015 01:24:39 Sakari Ailus wrote:
> V4L2 async sub-devices are currently matched (OF case) based on the struct
> device_node pointer in struct device. LED devices may have more than one
> LED, and in that case the OF node to match is not directly the device's
> node, but a LED's node.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
> since v1:
> 
> - Move conditional setting of struct v4l2_subdev.of_node from
>   v4l2_device_register_subdev() to v4l2_async_register_subdev.
> 
> - Remove the check for NULL struct v4l2_subdev.of_node from match_of() as
>   it's no longer needed.
> 
> - Unconditionally state in the struct v4l2_subdev.of_node field comment that
> the field contains (a pointer to) the sub-device's of_node.
> 
>  drivers/media/v4l2-core/v4l2-async.c | 34 +++++++++++++++++++++------------
>  include/media/v4l2-subdev.h          |  2 ++
>  2 files changed, 24 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-async.c
> b/drivers/media/v4l2-core/v4l2-async.c index 85a6a34..b0badac 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c

[snip]

> @@ -266,6 +273,9 @@ int v4l2_async_register_subdev(struct v4l2_subdev *sd)
>  {
>  	struct v4l2_async_notifier *notifier;
> 
> +	if (!sd->of_node && sd->dev)
> +		sd->of_node = sd->dev->of_node;
> +

I think we don't need to take a reference to of_node here, as we assume 
there's a reference to dev through the whole life of the subdev, and dev 
should have a reference to of_node, but could you double-check ?

If that's indeed not a problem,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

(and maybe a small comment in the source code would be useful)

>  	mutex_lock(&list_lock);
> 
>  	INIT_LIST_HEAD(&sd->async_list);
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index 8f5da73..8a17c24 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -603,6 +603,8 @@ struct v4l2_subdev {
>  	struct video_device *devnode;
>  	/* pointer to the physical device, if any */
>  	struct device *dev;
> +	/* A device_node of the subdev, usually the same as dev->of_node. */
> +	struct device_node *of_node;
>  	/* Links this subdev to a global subdev_list or @notifier->done list. */
>  	struct list_head async_list;
>  	/* Pointer to respective struct v4l2_async_subdev. */

-- 
Regards,

Laurent Pinchart

