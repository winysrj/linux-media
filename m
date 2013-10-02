Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39700 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406Ab3JBSMN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Oct 2013 14:12:13 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	teemux.tuominen@intel.com
Subject: Re: [RFC v2 4/4] v4l: events: Don't sleep in dequeue if none are subscribed
Date: Wed, 02 Oct 2013 20:12:17 +0200
Message-ID: <2284638.0TjbNMnX7g@avalon>
In-Reply-To: <1380721516-488-5-git-send-email-sakari.ailus@linux.intel.com>
References: <1380721516-488-1-git-send-email-sakari.ailus@linux.intel.com> <1380721516-488-5-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Wednesday 02 October 2013 16:45:16 Sakari Ailus wrote:
> Dequeueing events was is entirely possible even if none are subscribed,

was or is ? :-)

> leading to sleeping indefinitely. Fix this by returning -ENOENT when no
> events are subscribed.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/v4l2-core/v4l2-event.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-event.c
> b/drivers/media/v4l2-core/v4l2-event.c index b53897e..553a800 100644
> --- a/drivers/media/v4l2-core/v4l2-event.c
> +++ b/drivers/media/v4l2-core/v4l2-event.c
> @@ -77,10 +77,17 @@ int v4l2_event_dequeue(struct v4l2_fh *fh, struct
> v4l2_event *event, mutex_unlock(fh->vdev->lock);
> 
>  	do {
> -		ret = wait_event_interruptible(fh->wait,
> -					       fh->navailable != 0);
> +		bool subscribed;
> +		ret = wait_event_interruptible(
> +			fh->wait,
> +			fh->navailable != 0 ||
> +			!(subscribed = v4l2_event_has_subscribed(fh)));
>  		if (ret < 0)
>  			break;
> +		if (!subscribed) {
> +			ret = -EIO;
> +			break;
> +		}
> 
>  		ret = __v4l2_event_dequeue(fh, event);
>  	} while (ret == -ENOENT);
-- 
Regards,

Laurent Pinchart

