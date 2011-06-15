Return-path: <mchehab@pedra>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3102 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab1FOQjp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jun 2011 12:39:45 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [RFCv1 PATCH 1/8] v4l2-events/fh: merge v4l2_events into v4l2_fh
Date: Wed, 15 Jun 2011 18:39:35 +0200
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <1308064953-11156-1-git-send-email-hverkuil@xs4all.nl> <3d92b242dcf5e7766d128d6c1f05c0bd837a2633.1308063857.git.hans.verkuil@cisco.com> <20110615093007.GD9432@valkosipuli.localdomain>
In-Reply-To: <20110615093007.GD9432@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106151839.35935.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wednesday, June 15, 2011 11:30:07 Sakari Ailus wrote:
> Hi Hans,
> 
> Many thanks for the patch. I'm very happy to see this!
> 
> I have just one comment below.
> 
> > diff --git a/include/media/v4l2-event.h b/include/media/v4l2-event.h
> > index 45e9c1e..042b893 100644
> > --- a/include/media/v4l2-event.h
> > +++ b/include/media/v4l2-event.h
> > @@ -43,17 +43,6 @@ struct v4l2_subscribed_event {
> >  	u32			id;
> >  };
> >  
> > -struct v4l2_events {
> > -	wait_queue_head_t	wait;
> > -	struct list_head	subscribed; /* Subscribed events */
> > -	struct list_head	free; /* Events ready for use */
> > -	struct list_head	available; /* Dequeueable event */
> > -	unsigned int		navailable;
> > -	unsigned int		nallocated; /* Number of allocated events */
> > -	u32			sequence;
> > -};
> > -
> > -int v4l2_event_init(struct v4l2_fh *fh);
> >  int v4l2_event_alloc(struct v4l2_fh *fh, unsigned int n);
> >  void v4l2_event_free(struct v4l2_fh *fh);
> >  int v4l2_event_dequeue(struct v4l2_fh *fh, struct v4l2_event *event,
> > diff --git a/include/media/v4l2-fh.h b/include/media/v4l2-fh.h
> > index d247111..bfc0457 100644
> > --- a/include/media/v4l2-fh.h
> > +++ b/include/media/v4l2-fh.h
> > @@ -29,15 +29,22 @@
> >  #include <linux/list.h>
> >  
> >  struct video_device;
> > -struct v4l2_events;
> >  struct v4l2_ctrl_handler;
> >  
> >  struct v4l2_fh {
> >  	struct list_head	list;
> >  	struct video_device	*vdev;
> > -	struct v4l2_events      *events; /* events, pending and subscribed */
> >  	struct v4l2_ctrl_handler *ctrl_handler;
> >  	enum v4l2_priority	prio;
> > +
> > +	/* Events */
> > +	wait_queue_head_t	wait;
> > +	struct list_head	subscribed; /* Subscribed events */
> > +	struct list_head	free; /* Events ready for use */
> > +	struct list_head	available; /* Dequeueable event */
> > +	unsigned int		navailable;
> > +	unsigned int		nallocated; /* Number of allocated events */
> > +	u32			sequence;
> 
> A question: why to move the fields from v4l2_events to v4l2_fh? Events may
> be more important part of V4L2 than before but they're still not file
> handles. :-) The event related field names have no hing they'd be related to
> events --- "free", for example.

The only reason that the v4l2_events struct existed was that there were so few
drivers that needed events. So why allocate memory that you don't need? That
all changes with the control event: almost all drivers will need that since
almost all drivers have events.

Merging it makes the code easier and v4l2_fh_init can become a void function
(so no more error checking needed). And since these fields are always there, I
no longer need to check whether fh->events is NULL or not.

I can add a patch renaming some of the event fields if you prefer, but I don't
think they are that bad. Note that 'free' and 'nallocated' are removed
completely in a later patch.

Regards,

	Hans
