Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38504 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371Ab1FTNtl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2011 09:49:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFCv1 PATCH 2/8] v4l2-ctrls/event: remove struct v4l2_ctrl_fh, instead use v4l2_subscribed_event
Date: Mon, 20 Jun 2011 15:50:03 +0200
Cc: linux-media@vger.kernel.org, sakari.ailus@iki.fi,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <1308064953-11156-1-git-send-email-hverkuil@xs4all.nl> <45c38fb3f55b993136692e1d900dacd6cd2d85ad.1308063857.git.hans.verkuil@cisco.com>
In-Reply-To: <45c38fb3f55b993136692e1d900dacd6cd2d85ad.1308063857.git.hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106201550.03764.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

Thanks for the patch.

On Tuesday 14 June 2011 17:22:27 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The v4l2_ctrl_fh struct connected v4l2_ctrl with v4l2_fh so the control
> would know which filehandles subscribed to it. However, it is much easier
> to use struct v4l2_subscribed_event directly for that and get rid of that
> intermediate struct.

[snip]

> diff --git a/include/media/v4l2-event.h b/include/media/v4l2-event.h
> index 042b893..eda17f8 100644
> --- a/include/media/v4l2-event.h
> +++ b/include/media/v4l2-event.h
> @@ -38,9 +38,18 @@ struct v4l2_kevent {
>  };
> 
>  struct v4l2_subscribed_event {
> +	/* list node for the v4l2_fh->subscribed list */
>  	struct list_head	list;
> +	/* event type */
>  	u32			type;
> +	/* associated object ID (e.g. control ID) */
>  	u32			id;
> +	/* copy of v4l2_event_subscription->flags */
> +	u32			flags;
> +	/* filehandle that subscribed to this event */
> +	struct v4l2_fh		*fh;
> +	/* list node that hooks into the object's event list (if there is one) */
> +	struct list_head	node;
>  };
> 
>  int v4l2_event_alloc(struct v4l2_fh *fh, unsigned int n);

What about using kerneldoc style and document the structure in a single 
comment block right above it ? I find it easier to read.

-- 
Regards,

Laurent Pinchart
