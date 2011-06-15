Return-path: <mchehab@pedra>
Received: from smtp-68.nebula.fi ([83.145.220.68]:39508 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030Ab1FOJaO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jun 2011 05:30:14 -0400
Date: Wed, 15 Jun 2011 12:30:07 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv1 PATCH 1/8] v4l2-events/fh: merge v4l2_events into
 v4l2_fh
Message-ID: <20110615093007.GD9432@valkosipuli.localdomain>
References: <1308064953-11156-1-git-send-email-hverkuil@xs4all.nl>
 <3d92b242dcf5e7766d128d6c1f05c0bd837a2633.1308063857.git.hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d92b242dcf5e7766d128d6c1f05c0bd837a2633.1308063857.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

Many thanks for the patch. I'm very happy to see this!

I have just one comment below.

> diff --git a/include/media/v4l2-event.h b/include/media/v4l2-event.h
> index 45e9c1e..042b893 100644
> --- a/include/media/v4l2-event.h
> +++ b/include/media/v4l2-event.h
> @@ -43,17 +43,6 @@ struct v4l2_subscribed_event {
>  	u32			id;
>  };
>  
> -struct v4l2_events {
> -	wait_queue_head_t	wait;
> -	struct list_head	subscribed; /* Subscribed events */
> -	struct list_head	free; /* Events ready for use */
> -	struct list_head	available; /* Dequeueable event */
> -	unsigned int		navailable;
> -	unsigned int		nallocated; /* Number of allocated events */
> -	u32			sequence;
> -};
> -
> -int v4l2_event_init(struct v4l2_fh *fh);
>  int v4l2_event_alloc(struct v4l2_fh *fh, unsigned int n);
>  void v4l2_event_free(struct v4l2_fh *fh);
>  int v4l2_event_dequeue(struct v4l2_fh *fh, struct v4l2_event *event,
> diff --git a/include/media/v4l2-fh.h b/include/media/v4l2-fh.h
> index d247111..bfc0457 100644
> --- a/include/media/v4l2-fh.h
> +++ b/include/media/v4l2-fh.h
> @@ -29,15 +29,22 @@
>  #include <linux/list.h>
>  
>  struct video_device;
> -struct v4l2_events;
>  struct v4l2_ctrl_handler;
>  
>  struct v4l2_fh {
>  	struct list_head	list;
>  	struct video_device	*vdev;
> -	struct v4l2_events      *events; /* events, pending and subscribed */
>  	struct v4l2_ctrl_handler *ctrl_handler;
>  	enum v4l2_priority	prio;
> +
> +	/* Events */
> +	wait_queue_head_t	wait;
> +	struct list_head	subscribed; /* Subscribed events */
> +	struct list_head	free; /* Events ready for use */
> +	struct list_head	available; /* Dequeueable event */
> +	unsigned int		navailable;
> +	unsigned int		nallocated; /* Number of allocated events */
> +	u32			sequence;

A question: why to move the fields from v4l2_events to v4l2_fh? Events may
be more important part of V4L2 than before but they're still not file
handles. :-) The event related field names have no hing they'd be related to
events --- "free", for example.

Regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi
