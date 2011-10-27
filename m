Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38790 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754315Ab1J0MTZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Oct 2011 08:19:25 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH 4/6] v4l2-event: Don't set sev->fh to NULL on unsubcribe
Date: Thu, 27 Oct 2011 14:20:04 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	hverkuil@xs4all.nl
References: <1319714283-3991-1-git-send-email-hdegoede@redhat.com> <1319714283-3991-5-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1319714283-3991-5-git-send-email-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201110271420.04488.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thursday 27 October 2011 13:18:01 Hans de Goede wrote:
> 1: There is no reason for this after v4l2_event_unsubscribe releases the
> spinlock nothing is holding a reference to the sev anymore except for the
> local reference in the v4l2_event_unsubscribe function.
> 
> 2: Setting sev->fh to NULL causes problems for the del op added in the next
> patch of this series, since this op needs a way to get to its own data
> structures, and typically this will be done by using container_of on an
> embedded v4l2_fh struct.
> 
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

While reviewing the patch I noticed that v4l2_event_unsubscribe_all() calls 
v4l2_event_unsubscribe(), which performs control lookup again. Is there a 
reason for that, instead of handling event unsubscription directly in 
v4l2_event_unsubscribe_all() ?

> ---
>  drivers/media/video/v4l2-event.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-event.c
> b/drivers/media/video/v4l2-event.c index 01cbb7f..3d27300 100644
> --- a/drivers/media/video/v4l2-event.c
> +++ b/drivers/media/video/v4l2-event.c
> @@ -304,7 +304,6 @@ int v4l2_event_unsubscribe(struct v4l2_fh *fh,
>  			}
>  		}
>  		list_del(&sev->list);
> -		sev->fh = NULL;
>  	}
> 
>  	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);

-- 
Regards,

Laurent Pinchart
