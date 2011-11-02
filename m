Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:28579 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655Ab1KBKZ7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Nov 2011 06:25:59 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH 3/5] v4l2-event: Don't set sev->fh to NULL on unsubscribe
Date: Wed, 2 Nov 2011 11:25:13 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1320228805-9097-1-git-send-email-hdegoede@redhat.com> <1320228805-9097-4-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1320228805-9097-4-git-send-email-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201111021125.13781.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 02 November 2011 11:13:23 Hans de Goede wrote:
> Setting sev->fh to NULL causes problems for the del op added in the next
> patch of this series, since this op needs a way to get to its own data
> structures, and typically this will be done by using container_of on an
> embedded v4l2_fh struct.
> 
> The reason the original code is setting sev->fh to NULL is to signal
> to users of the event framework that the unsubscription has happened,
> but since their is no shared lock between the event framework and users
> of it, this is inherently racy, and it also turns out to be unnecessary
> as long as both the event framework and the user of the framework do their
> own locking properly and the user guarantees that it holds no references
> to the subcribed_event structure after its del operation has been called.
> 
> This is best explained by looking at the only code currently checking for
> sev->fh being set to NULL on unsubscribe, which is the v4l2-ctrls.c
> send_event function. Here is the relevant code from v4l2-ctrls:
> send_event():
> 
> 	if (sev->fh && (sev->fh != fh ||
> 			(sev->flags & V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK)))
> 		v4l2_event_queue_fh(sev->fh, &ev);
> 
> Now lets say that v4l2_event_unsubscribe and v4l2-ctrls: send_event() race
> on the same sev, then the following could happens:
> 
> 1) send_event checks sev->fh, finds it is not NULL
> <thread switch>
> 2) v4l2_event_unsubscribe sets sev->fh NULL
> 3) v4l2_event_unsubscribe calls v4l2_ctrls del_event function, this blocks
>    as the thread calling send_event holds the ctrl_lock
> <thread switch>
> 4) send_event calls v4l2_event_queue_fh(sev->fh, &ev) which not is
> equivalent to calling: v4l2_event_queue_fh(NULL, &ev)
> 5) oops, NULL pointer deref.
> 
> Now again without setting sev->fh to NULL in v4l2_event_unsubscribe and
> without the (now senseless since always true) sev->fh != NULL check in
> send_event:
> 
> 1) send_event is about to call v4l2_event_queue_fh(sev->fh, &ev)
> <thread switch>
> 2) v4l2_event_unsubscribe removes sev->list from the fh->subscribed list
> <thread switch>
> 3) send_event calls v4l2_event_queue_fh(sev->fh, &ev)
> 4) v4l2_event_queue_fh blocks on the fh_lock spinlock
> <thread switch>
> 5) v4l2_event_unsubscribe unlocks the fh_lock spinlock
> 6) v4l2_event_unsubscribe calls v4l2_ctrls del_event function, this blocks
>    as the thread calling send_event holds the ctrl_lock
> <thread switch>
> 8) v4l2_event_queue_fh takes the fh_lock
> 7) v4l2_event_queue_fh calls v4l2_event_subscribed, does not find it since
>    sev->list has been removed from fh->subscribed already -> does nothing
> 9) v4l2_event_queue_fh releases the fh_lock
> 10) the caller of send_event releases the ctrl lock (mutex)
> <thread switch>
> 11) v4l2_ctrls del_event takes the ctrl lock
> 12) v4l2_ctrls del_event removes sev->node from the ev_subs list
> 13) v4l2_ctrls del_event releases the ctrl lock
> 14) v4l2_event_unsubscribe frees the sev, to which no references are being
>     held anymore
> 
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> ---
>  drivers/media/video/v4l2-ctrls.c |    4 ++--
>  drivers/media/video/v4l2-event.c |    1 -
>  2 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-ctrls.c
> b/drivers/media/video/v4l2-ctrls.c index 69e24f4..1832a87 100644
> --- a/drivers/media/video/v4l2-ctrls.c
> +++ b/drivers/media/video/v4l2-ctrls.c
> @@ -819,8 +819,8 @@ static void send_event(struct v4l2_fh *fh, struct
> v4l2_ctrl *ctrl, u32 changes) fill_event(&ev, ctrl, changes);
> 
>  	list_for_each_entry(sev, &ctrl->ev_subs, node)
> -		if (sev->fh && (sev->fh != fh ||
> -				(sev->flags & 
V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK)))
> +		if (sev->fh != fh ||
> +		    (sev->flags & V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK))
>  			v4l2_event_queue_fh(sev->fh, &ev);
>  }
> 
> diff --git a/drivers/media/video/v4l2-event.c
> b/drivers/media/video/v4l2-event.c index 4d01f17..3d93251 100644
> --- a/drivers/media/video/v4l2-event.c
> +++ b/drivers/media/video/v4l2-event.c
> @@ -302,7 +302,6 @@ int v4l2_event_unsubscribe(struct v4l2_fh *fh,
>  			fh->navailable--;
>  		}
>  		list_del(&sev->list);
> -		sev->fh = NULL;
>  	}
> 
>  	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
