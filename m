Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:62419 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777Ab1KBKXZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Nov 2011 06:23:25 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH 2/5] v4l2-event: Remove pending events from fh event queue when unsubscribing
Date: Wed, 2 Nov 2011 11:22:38 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1320228805-9097-1-git-send-email-hdegoede@redhat.com> <1320228805-9097-3-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1320228805-9097-3-git-send-email-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201111021122.38973.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 02 November 2011 11:13:22 Hans de Goede wrote:
> The kev pointers inside the pending events queue (the available queue) of
> the fh point to data inside the sev, unsubscribing frees the sev, thus
> making these pointers point to freed memory!
> 
> This patch fixes these dangling pointers in the available queue by removing
> all matching pending events on unsubscription.
> 
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> ---
>  drivers/media/video/v4l2-event.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-event.c
> b/drivers/media/video/v4l2-event.c index 9f56f18..4d01f17 100644
> --- a/drivers/media/video/v4l2-event.c
> +++ b/drivers/media/video/v4l2-event.c
> @@ -285,6 +285,7 @@ int v4l2_event_unsubscribe(struct v4l2_fh *fh,
>  {
>  	struct v4l2_subscribed_event *sev;
>  	unsigned long flags;
> +	int i;
> 
>  	if (sub->type == V4L2_EVENT_ALL) {
>  		v4l2_event_unsubscribe_all(fh);
> @@ -295,6 +296,11 @@ int v4l2_event_unsubscribe(struct v4l2_fh *fh,
> 
>  	sev = v4l2_event_subscribed(fh, sub->type, sub->id);
>  	if (sev != NULL) {
> +		/* Remove any pending events for this subscription */
> +		for (i = 0; i < sev->in_use; i++) {
> +			list_del(&sev->events[sev_pos(sev, i)].list);
> +			fh->navailable--;
> +		}
>  		list_del(&sev->list);
>  		sev->fh = NULL;
>  	}
