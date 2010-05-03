Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:34972 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759026Ab0ECP4l (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 May 2010 11:56:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [PATCH 1/1] V4L: Events: Replace bad WARN_ON() with assert_spin_locked()
Date: Mon, 3 May 2010 17:57:07 +0200
Cc: linux-media@vger.kernel.org
References: <4BDEEEDF.7050905@maxwell.research.nokia.com> <1272901366-7127-1-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <1272901366-7127-1-git-send-email-sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201005031757.08090.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 03 May 2010 17:42:46 Sakari Ailus wrote:
> spin_is_locked() always returns zero when spinlock debugging is
> disabled on a single CPU machine. Replace WARN_ON() with
> assert_spin_locked().
> 
> Thanks to Laurent Pinchart for spotting this!
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/video/v4l2-event.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-event.c
> b/drivers/media/video/v4l2-event.c index 170e40f..91bb1c8 100644
> --- a/drivers/media/video/v4l2-event.c
> +++ b/drivers/media/video/v4l2-event.c
> @@ -152,7 +152,7 @@ static struct v4l2_subscribed_event
> *v4l2_event_subscribed( struct v4l2_events *events = fh->events;
>  	struct v4l2_subscribed_event *sev;
> 
> -	WARN_ON(!spin_is_locked(&fh->vdev->fh_lock));
> +	assert_spin_locked(&fh->vdev->fh_lock);
> 
>  	list_for_each_entry(sev, &events->subscribed, list) {
>  		if (sev->type == type)

-- 
Regards,

Laurent Pinchart
