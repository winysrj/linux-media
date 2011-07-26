Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:53559 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab1GZOPu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jul 2011 10:15:50 -0400
Date: Tue, 26 Jul 2011 17:15:46 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: [RFC 2/3] v4l: events: Define frame start event
Message-ID: <20110726141546.GC32629@valkosipuli.localdomain>
References: <4E2588AD.4070106@maxwell.research.nokia.com>
 <201107261352.44287.hverkuil@xs4all.nl>
 <20110726135125.GB32629@valkosipuli.localdomain>
 <201107261559.38397.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201107261559.38397.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks for your comments, Hans!

On Tue, Jul 26, 2011 at 03:59:38PM +0200, Hans Verkuil wrote:
> On Tuesday, July 26, 2011 15:51:26 Sakari Ailus wrote:
> > On Tue, Jul 26, 2011 at 01:52:44PM +0200, Hans Verkuil wrote:
> > > On Tuesday, July 19, 2011 15:38:07 Sakari Ailus wrote:
> > > > Define a frame start event to tell user space when the reception of a frame
> > > > starts.
> > > > 
> > > > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > > > ---
> > > >  Documentation/DocBook/media/v4l/vidioc-dqevent.xml |   26 ++++++++++++++++++++
> > > >  .../DocBook/media/v4l/vidioc-subscribe-event.xml   |   18 +++++++++++++
> > > >  include/linux/videodev2.h                          |   12 +++++++--
> > > >  3 files changed, 53 insertions(+), 3 deletions(-)
> > > > 
> > > > diff --git a/Documentation/DocBook/media/v4l/vidioc-dqevent.xml b/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
> > > > index 5200b68..d2cb8db 100644
> > > > --- a/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
> > > > +++ b/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
> > > > @@ -88,6 +88,12 @@
> > > >  	  </row>
> > > >  	  <row>
> > > >  	    <entry></entry>
> > > > +	    <entry>&v4l2-event-frame-sync;</entry>
> > > > +            <entry><structfield>frame</structfield></entry>
> > > > +	    <entry>Event data for event V4L2_EVENT_FRAME_START.</entry>
> > > 
> > > The name of the struct and the event are not in sync (pardon the expression :-) ).
> > > 
> > > Both should either be named FRAME_SYNC or FRAME_START.
> > 
> > Should they be in sync? FRAME_START event is for frame start, not for other
> > purposes.
> 
> Ah, you expect other events to reuse the same payload struct. I missed
> that part.
>  
> > The buffer sequence number, however, could be used by other events, too.
> > This is directly related to the question of how to subscribe line-based
> > events. Albeit whether they are really ever needed is another question.
> > 
> > Getting _one_ event giving frame synchronisation timestamps is important,
> > however; that's also why I sent the RFC.
> > 
> > What I might do now is that we define a FRAME_SYNC (or FRAME_START) event
> > and specify the id == 0 always, and worry about the rest later on. It is
> > quite possible that line based events will never be needed.
> 
> I would go for that.

Ack.

> > If they are, then we must also specify how to subscribe them.
> 
> Using 'id' as the line number seems sensible to me, but I would definitely
> leave that part out for now. I am not convinced it is possible to use that
> reliably in any case due to the difficult timing requirements.

Ah, I momentarily forgot how this works on controls. :-)

I think FRAME_SYNC is better name since it's reusable in the future as well
so I choose that one and resend the set.

Cheers,

-- 
Sakari Ailus
sakari.ailus@iki.fi
