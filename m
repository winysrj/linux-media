Return-path: <mchehab@pedra>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:4004 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963Ab1FORLF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jun 2011 13:11:05 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [RFCv1 PATCH 1/8] v4l2-events/fh: merge v4l2_events into v4l2_fh
Date: Wed, 15 Jun 2011 19:10:52 +0200
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <1308064953-11156-1-git-send-email-hverkuil@xs4all.nl> <201106151839.35935.hverkuil@xs4all.nl> <4DF8E4D9.1050604@iki.fi>
In-Reply-To: <4DF8E4D9.1050604@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106151910.52163.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wednesday, June 15, 2011 18:59:05 Sakari Ailus wrote:
> Hans Verkuil wrote:
> > On Wednesday, June 15, 2011 11:30:07 Sakari Ailus wrote:
> >> Hi Hans,
> >>
> >> Many thanks for the patch. I'm very happy to see this!
> >>
> >> I have just one comment below.
> >>
> >>> diff --git a/include/media/v4l2-event.h b/include/media/v4l2-event.h
> >>> index 45e9c1e..042b893 100644
> >>> --- a/include/media/v4l2-event.h
> >>> +++ b/include/media/v4l2-event.h
> >>> @@ -43,17 +43,6 @@ struct v4l2_subscribed_event {
> >>>   	u32			id;
> >>>   };
> >>>
> >>> -struct v4l2_events {
> >>> -	wait_queue_head_t	wait;
> >>> -	struct list_head	subscribed; /* Subscribed events */
> >>> -	struct list_head	free; /* Events ready for use */
> >>> -	struct list_head	available; /* Dequeueable event */
> >>> -	unsigned int		navailable;
> >>> -	unsigned int		nallocated; /* Number of allocated events */
> >>> -	u32			sequence;
> >>> -};
> >>> -
> >>> -int v4l2_event_init(struct v4l2_fh *fh);
> >>>   int v4l2_event_alloc(struct v4l2_fh *fh, unsigned int n);
> >>>   void v4l2_event_free(struct v4l2_fh *fh);
> >>>   int v4l2_event_dequeue(struct v4l2_fh *fh, struct v4l2_event *event,
> >>> diff --git a/include/media/v4l2-fh.h b/include/media/v4l2-fh.h
> >>> index d247111..bfc0457 100644
> >>> --- a/include/media/v4l2-fh.h
> >>> +++ b/include/media/v4l2-fh.h
> >>> @@ -29,15 +29,22 @@
> >>>   #include<linux/list.h>
> >>>
> >>>   struct video_device;
> >>> -struct v4l2_events;
> >>>   struct v4l2_ctrl_handler;
> >>>
> >>>   struct v4l2_fh {
> >>>   	struct list_head	list;
> >>>   	struct video_device	*vdev;
> >>> -	struct v4l2_events      *events; /* events, pending and subscribed */
> >>>   	struct v4l2_ctrl_handler *ctrl_handler;
> >>>   	enum v4l2_priority	prio;
> >>> +
> >>> +	/* Events */
> >>> +	wait_queue_head_t	wait;
> >>> +	struct list_head	subscribed; /* Subscribed events */
> >>> +	struct list_head	free; /* Events ready for use */
> >>> +	struct list_head	available; /* Dequeueable event */
> >>> +	unsigned int		navailable;
> >>> +	unsigned int		nallocated; /* Number of allocated events */
> >>> +	u32			sequence;
> >>
> >> A question: why to move the fields from v4l2_events to v4l2_fh? Events may
> >> be more important part of V4L2 than before but they're still not file
> >> handles. :-) The event related field names have no hing they'd be related to
> >> events --- "free", for example.
> >
> > The only reason that the v4l2_events struct existed was that there were so few
> > drivers that needed events. So why allocate memory that you don't need? That
> > all changes with the control event: almost all drivers will need that since
> > almost all drivers have events.
> >
> > Merging it makes the code easier and v4l2_fh_init can become a void function
> > (so no more error checking needed). And since these fields are always there, I
> > no longer need to check whether fh->events is NULL or not.
> >
> > I can add a patch renaming some of the event fields if you prefer, but I don't
> > think they are that bad. Note that 'free' and 'nallocated' are removed
> > completely in a later patch.
> 
> Thanks for the explanation. What I had in mind that what other fields 
> possibly would be added to v4l2_fh in the future? If there will be many, 
> in that case keeping event related fields in a separate structure might 
> make sense. I have none in mind right now, though, so perhaps this could 
> be given a second thought if we're adding more things to the v4l2_fh 
> structure?

I guess any future extensions will need to be considered on their own merits.
If it is a rarely used extension, then it can be allocated on demand, if it
is a commonly used extension, then it's easier to add it to this struct.

> I think this patchset is a significant improvement to the old behaviour.

Thank you, I have to say I'm very pleased with it. It gives the user certain
guarantees with respect to arrival of events that are hard to realize otherwise.

Regards,

	Hans
