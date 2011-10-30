Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2251 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933907Ab1J3Kas (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Oct 2011 06:30:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH 4/6] v4l2-event: Don't set sev->fh to NULL on unsubcribe
Date: Sun, 30 Oct 2011 11:30:37 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1319714283-3991-1-git-send-email-hdegoede@redhat.com> <1319714283-3991-5-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1319714283-3991-5-git-send-email-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201110301130.37195.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday, October 27, 2011 13:18:01 Hans de Goede wrote:
> 1: There is no reason for this after v4l2_event_unsubscribe releases the
> spinlock nothing is holding a reference to the sev anymore except for the
> local reference in the v4l2_event_unsubscribe function.

Not true. v4l2-ctrls.c may still have a reference to the sev through the
ev_subs list in struct v4l2_ctrl. The send_event() function checks for a
non-zero fh.

All that is needed is to find some different way of letting send_event()
know that this sev is no longer used. Perhaps by making sev->list empty?

Regards,

	Hans

> 2: Setting sev->fh to NULL causes problems for the del op added in the next
> patch of this series, since this op needs a way to get to its own data
> structures, and typically this will be done by using container_of on an
> embedded v4l2_fh struct.
> 
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  drivers/media/video/v4l2-event.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-event.c b/drivers/media/video/v4l2-event.c
> index 01cbb7f..3d27300 100644
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
> 
