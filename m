Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:45585 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab1GZNva (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jul 2011 09:51:30 -0400
Date: Tue, 26 Jul 2011 16:51:26 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: [RFC 2/3] v4l: events: Define frame start event
Message-ID: <20110726135125.GB32629@valkosipuli.localdomain>
References: <4E2588AD.4070106@maxwell.research.nokia.com>
 <1311082688-16185-2-git-send-email-sakari.ailus@iki.fi>
 <201107261352.44287.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201107261352.44287.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 26, 2011 at 01:52:44PM +0200, Hans Verkuil wrote:
> On Tuesday, July 19, 2011 15:38:07 Sakari Ailus wrote:
> > Define a frame start event to tell user space when the reception of a frame
> > starts.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > ---
> >  Documentation/DocBook/media/v4l/vidioc-dqevent.xml |   26 ++++++++++++++++++++
> >  .../DocBook/media/v4l/vidioc-subscribe-event.xml   |   18 +++++++++++++
> >  include/linux/videodev2.h                          |   12 +++++++--
> >  3 files changed, 53 insertions(+), 3 deletions(-)
> > 
> > diff --git a/Documentation/DocBook/media/v4l/vidioc-dqevent.xml b/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
> > index 5200b68..d2cb8db 100644
> > --- a/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
> > +++ b/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
> > @@ -88,6 +88,12 @@
> >  	  </row>
> >  	  <row>
> >  	    <entry></entry>
> > +	    <entry>&v4l2-event-frame-sync;</entry>
> > +            <entry><structfield>frame</structfield></entry>
> > +	    <entry>Event data for event V4L2_EVENT_FRAME_START.</entry>
> 
> The name of the struct and the event are not in sync (pardon the expression :-) ).
> 
> Both should either be named FRAME_SYNC or FRAME_START.

Should they be in sync? FRAME_START event is for frame start, not for other
purposes.

The buffer sequence number, however, could be used by other events, too.
This is directly related to the question of how to subscribe line-based
events. Albeit whether they are really ever needed is another question.

Getting _one_ event giving frame synchronisation timestamps is important,
however; that's also why I sent the RFC.

What I might do now is that we define a FRAME_SYNC (or FRAME_START) event
and specify the id == 0 always, and worry about the rest later on. It is
quite possible that line based events will never be needed.

If they are, then we must also specify how to subscribe them.

> > +	  </row>
> > +	  <row>
> > +	    <entry></entry>
> >  	    <entry>__u8</entry>
> >              <entry><structfield>data</structfield>[64]</entry>
> >  	    <entry>Event data. Defined by the event type. The union
> > @@ -220,6 +226,26 @@
> >        </tgroup>
> >      </table>
> >  
> > +    <table frame="none" pgwide="1" id="v4l2-event-frame-sync">
> > +      <title>struct <structname>v4l2_event_frame_sync</structname></title>
> > +      <tgroup cols="3">
> > +	&cs-str;
> > +	<tbody valign="top">
> > +	  <row>
> > +	    <entry>__u32</entry>
> > +	    <entry><structfield>buffer_sequence</structfield></entry>
> > +	    <entry>
> > +	      The sequence number of the buffer to be handled next or
> > +	      currently handled by the driver.
> 
> So this refers to the sequence field in struct v4l2_buffer? Assuming it is,
> then you definitely need to refer to that struct.

Yes, it does.

> And to answer question 2 in the RFC: buffer_sequence is specific to this
> event, and so belongs to a v4l2_event_frame_sync struct.

Agreed.

> BTW, using 'id' to specify a specific line in the future seems reasonable to me.
> Initially id is just set to 0, meaning the start of the frame.
> 
> Regards,
> 
> 	Hans
> 
> > +	    </entry>
> > +	  </row>
> > +	</tbody>
> > +      </tgroup>
> > +    </table>
> > +
> > +    <para>&v4l2-event-frame-sync; is associated with
> > +    <constant>V4L2_EVENT_FRAME_START</constant> event.</para>
> > +
> >      <table pgwide="1" frame="none" id="changes-flags">
> >        <title>Changes</title>
> >        <tgroup cols="3">
> > diff --git a/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml b/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
> > index 275be96..7ec42bb 100644
> > --- a/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
> > +++ b/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
> > @@ -139,6 +139,24 @@
> >  	    </entry>
> >  	  </row>
> >  	  <row>
> > +	    <entry><constant>V4L2_EVENT_FRAME_START</constant></entry>
> > +	    <entry>4</entry>
> > +	    <entry>
> > +	      <para>Triggered immediately when the reception of a
> > +	      frame has begun. This event has a
> > +	      &v4l2-event-frame-sync; associated with it.</para>
> > +
> > +	      <para>A driver will only generate this event when the
> > +	      hardware can generate it. This might not be the case
> > +	      e.g. when the hardware has no DMA buffer to write the
> > +	      image data to. In such cases the
> > +	      <structfield>buffer_sequence</structfield> field in
> > +	      &v4l2-event-frame-sync; will not be incremented either.
> > +	      This causes two consecutive buffer sequence numbers to
> > +	      have n times frame interval in between them.</para>
> > +	    </entry>
> > +	  </row>
> > +	  <row>
> >  	    <entry><constant>V4L2_EVENT_PRIVATE_START</constant></entry>
> >  	    <entry>0x08000000</entry>
> >  	    <entry>Base event number for driver-private events.</entry>
> > diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> > index fca24cc..4265102 100644
> > --- a/include/linux/videodev2.h
> > +++ b/include/linux/videodev2.h
> > @@ -2006,6 +2006,7 @@ struct v4l2_streamparm {
> >  #define V4L2_EVENT_VSYNC			1
> >  #define V4L2_EVENT_EOS				2
> >  #define V4L2_EVENT_CTRL				3
> > +#define V4L2_EVENT_FRAME_START			4
> >  #define V4L2_EVENT_PRIVATE_START		0x08000000
> >  
> >  /* Payload for V4L2_EVENT_VSYNC */
> > @@ -2032,12 +2033,17 @@ struct v4l2_event_ctrl {
> >  	__s32 default_value;
> >  };
> >  
> > +struct v4l2_event_frame_sync {
> > +	__u32 buffer_sequence;
> > +};
> > +
> >  struct v4l2_event {
> >  	__u32				type;
> >  	union {
> > -		struct v4l2_event_vsync vsync;
> > -		struct v4l2_event_ctrl	ctrl;
> > -		__u8			data[64];
> > +		struct v4l2_event_vsync		vsync;
> > +		struct v4l2_event_ctrl		ctrl;
> > +		struct v4l2_event_frame_sync	frame_sync;
> > +		__u8				data[64];
> >  	} u;
> >  	__u32				pending;
> >  	__u32				sequence;
> > 

-- 
Sakari Ailus
sakari.ailus@iki.fi
