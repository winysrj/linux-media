Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:49218 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755162Ab1G2Hov (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 03:44:51 -0400
Date: Fri, 29 Jul 2011 10:44:46 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, hans.verkuil@cisco.com,
	snjw23@gmail.com
Subject: Re: [PATCH 2/3] v4l: events: Define frame start event
Message-ID: <20110729074446.GL32629@valkosipuli.localdomain>
References: <4E2F0C53.10907@iki.fi>
 <201107281352.21742.laurent.pinchart@ideasonboard.com>
 <20110728202857.GK32629@valkosipuli.localdomain>
 <201107282236.57896.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201107282236.57896.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 28, 2011 at 10:36:57PM +0200, Laurent Pinchart wrote:
> Hi Sakari,

Hi, Laurent!

> On Thursday 28 July 2011 22:28:57 Sakari Ailus wrote:
> > On Thu, Jul 28, 2011 at 01:52:21PM +0200, Laurent Pinchart wrote:
> > > On Tuesday 26 July 2011 20:49:43 Sakari Ailus wrote:
> 
> [snip]
> 
> > > > +    <table frame="none" pgwide="1" id="v4l2-event-frame-sync">
> > > > +      <title>struct
> > > > <structname>v4l2_event_frame_sync</structname></title> +      <tgroup
> > > > cols="3">
> > > > +	&cs-str;
> > > > +	<tbody valign="top">
> > > > +	  <row>
> > > > +	    <entry>__u32</entry>
> > > > +	    <entry><structfield>buffer_sequence</structfield></entry>
> > > > +	    <entry>
> > > > +	      The sequence number of the buffer to be handled next or
> > > > +	      currently handled by the driver.
> > > 
> > > What happens if a particular piece of hardware can capture two (or more)
> > > simultaneous streams from the same video source (an unscaled compressed
> > > stream and a scaled down uncompressed stream for instance) ?
> > > Applications don't need to start both streams at the same time, what
> > > buffer sequence number should be reported in that case ?
> > 
> > I think that if the video data comes from the same source, the sequence
> > numbers should definitely be in sync. This would mean that for the second
> > stream the first sequence number wouldn't be zero.
> 
> Then we should document this somewhere. Here is probably not the best place to 
> document that, but the buffer_sequence documentation should still refer to the 
> explanation.
> 
> I also find the wording a bit unclear. The "buffer to be handled next" could 
> mean the buffer that will be given to an application at the next DQBUF call. 
> Maybe we should refer to frame sequence numbers instead of buffer sequence 
> numbers.

What's the difference? I would consider the two the same.

..."buffer to be written next to by the hardware"?

> > > > +	    </entry>
> > > > +	  </row>
> > > > +	</tbody>
> > > > +      </tgroup>
> > > > +    </table>
> > > > +
> > > > 
> > > >      <table pgwide="1" frame="none" id="changes-flags">
> > > >      
> > > >        <title>Changes</title>
> > > >        <tgroup cols="3">
> > > > 
> > > > diff --git a/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
> > > > b/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml index
> > > > 275be96..812b63c 100644
> > > > --- a/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
> > > > +++ b/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
> > > > @@ -139,6 +139,24 @@
> > > > 
> > > >  	    </entry>
> > > >  	  
> > > >  	  </row>
> > > >  	  <row>
> > > > 
> > > > +	    <entry><constant>V4L2_EVENT_FRAME_SYNC</constant></entry>
> > > > +	    <entry>4</entry>
> > > > +	    <entry>
> > > > +	      <para>Triggered immediately when the reception of a
> > > > +	      frame has begun. This event has a
> > > > +	      &v4l2-event-frame-sync; associated with it.</para>
> > > > +
> > > > +	      <para>A driver will only generate this event when the
> > > > +	      hardware can generate it. This might not be the case
> > > > +	      e.g. when the hardware has no DMA buffer to write the
> > > > +	      image data to. In such cases the
> > > > +	      <structfield>buffer_sequence</structfield> field in
> > > > +	      &v4l2-event-frame-sync; will not be incremented either.
> > > > +	      This causes two consecutive buffer sequence numbers to
> > > > +	      have n times frame interval in between them.</para>
> > > 
> > > I don't think that's correct. Don't many drivers still increment the
> > > sequence number in that case, to make it possible for applications to
> > > detect frame loss ?
> > 
> > I think I understood once that the OMAP 3 ISP driver didn't do this in all
> > cases but I later learned that this isn't the case. I still would be
> > actually a bit surprised if there was not hardware that could not do this.
> > 
> > Do you think the text is relevant in this context, or should it be removed?
> 
> I think you should just mention that the event *might* not be generated if the 
> hardware needs to be stopped in case of buffer underrun for instance.

Ack.

-- 
Sakari Ailus
sakari.ailus@iki.fi
