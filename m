Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:46292 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758201Ab0EBRoZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 May 2010 13:44:25 -0400
Message-ID: <4BDDBA7B.3000907@maxwell.research.nokia.com>
Date: Sun, 02 May 2010 20:46:35 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH FOR 2.6.35] v4l: event: Export the v4l2_event_init and
 v4l2_event_dequeue functions
References: <1272821563-7946-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1272821563-7946-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart wrote:
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/video/v4l2-event.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
>  Sakari, this should go to 2.6.35 with the V4L2 events patch set. Could you ack
>  the patch so that Mauro can apply it to his linux-next tree ?

Thanks for the patch, Laurent!

I understand this should go in to allow drivers not using video_ioctl2()
to support events as well, right?

Thus,

Acked-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>

>  Regards,
> 
>  Laurent Pinchart
> 
> diff --git a/drivers/media/video/v4l2-event.c b/drivers/media/video/v4l2-event.c
> index 170e40f..2e673fb 100644
> --- a/drivers/media/video/v4l2-event.c
> +++ b/drivers/media/video/v4l2-event.c
> @@ -45,6 +45,7 @@ int v4l2_event_init(struct v4l2_fh *fh)
>  
>  	return 0;
>  }
> +EXPORT_SYMBOL_GPL(v4l2_event_init);
>  
>  int v4l2_event_alloc(struct v4l2_fh *fh, unsigned int n)
>  {
> @@ -144,6 +145,7 @@ int v4l2_event_dequeue(struct v4l2_fh *fh, struct v4l2_event *event,
>  
>  	return ret;
>  }
> +EXPORT_SYMBOL_GPL(v4l2_event_dequeue);
>  
>  /* Caller must hold fh->event->lock! */
>  static struct v4l2_subscribed_event *v4l2_event_subscribed(


-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
