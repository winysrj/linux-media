Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2252 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933436Ab1J3KYX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Oct 2011 06:24:23 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH 3/6] v4l2-event: Remove pending events from fh event queue when unsubscribing
Date: Sun, 30 Oct 2011 11:24:11 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1319714283-3991-1-git-send-email-hdegoede@redhat.com> <1319714283-3991-4-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1319714283-3991-4-git-send-email-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201110301124.11047.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday, October 27, 2011 13:18:00 Hans de Goede wrote:
> The kev pointers inside the pending events queue (the available queue) of the
> fh point to data inside the sev, unsubscribing frees the sev, thus making these
> pointers point to freed memory!
> 
> This patch fixes these dangling pointers in the available queue by removing
> all matching pending events on unsubscription.

The idea is fine, but the implementation is inefficient.

Instead of the list_for_each_entry_safe you can just do:

	for (i = 0; i < sev->in_use; i++) {
		list_del(&sev->events[sev_pos(sev, i)].list);
		fh->navailable--;
	}

It's untested, but this should do the trick.

Regards,

	Hans

> 
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  drivers/media/video/v4l2-event.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-event.c b/drivers/media/video/v4l2-event.c
> index 9f56f18..01cbb7f 100644
> --- a/drivers/media/video/v4l2-event.c
> +++ b/drivers/media/video/v4l2-event.c
> @@ -284,6 +284,7 @@ int v4l2_event_unsubscribe(struct v4l2_fh *fh,
>  			   struct v4l2_event_subscription *sub)
>  {
>  	struct v4l2_subscribed_event *sev;
> +	struct v4l2_kevent *kev, *next;
>  	unsigned long flags;
>  
>  	if (sub->type == V4L2_EVENT_ALL) {
> @@ -295,6 +296,13 @@ int v4l2_event_unsubscribe(struct v4l2_fh *fh,
>  
>  	sev = v4l2_event_subscribed(fh, sub->type, sub->id);
>  	if (sev != NULL) {
> +		/* Remove any pending events for this subscription */
> +		list_for_each_entry_safe(kev, next, &fh->available, list) {
> +			if (kev->sev == sev) {
> +				list_del(&kev->list);
> +				fh->navailable--;
> +			}
> +		}
>  		list_del(&sev->list);
>  		sev->fh = NULL;
>  	}
> 
