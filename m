Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:48785 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756115Ab1G2Key (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 06:34:54 -0400
Date: Fri, 29 Jul 2011 13:34:48 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, hans.verkuil@cisco.com,
	snjw23@gmail.com
Subject: Re: [PATCH 2/3] v4l: events: Define frame start event
Message-ID: <20110729103448.GP32629@valkosipuli.localdomain>
References: <4E2F0C53.10907@iki.fi>
 <201107291138.16958.laurent.pinchart@ideasonboard.com>
 <20110729095402.GO32629@valkosipuli.localdomain>
 <201107291157.17781.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201107291157.17781.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 29, 2011 at 11:57:17AM +0200, Laurent Pinchart wrote:
> On Friday 29 July 2011 11:54:03 Sakari Ailus wrote:
> > On Fri, Jul 29, 2011 at 11:38:16AM +0200, Laurent Pinchart wrote:
> > > On Friday 29 July 2011 09:44:46 Sakari Ailus wrote:
> > > > On Thu, Jul 28, 2011 at 10:36:57PM +0200, Laurent Pinchart wrote:
> > > > > On Thursday 28 July 2011 22:28:57 Sakari Ailus wrote:
> > > > > > On Thu, Jul 28, 2011 at 01:52:21PM +0200, Laurent Pinchart wrote:
> > > > > > > On Tuesday 26 July 2011 20:49:43 Sakari Ailus wrote:
> > > > > [snip]
> > > > > 
> > > > > > > > +    <table frame="none" pgwide="1" id="v4l2-event-frame-sync">
> > > > > > > > +      <title>struct
> > > > > > > > <structname>v4l2_event_frame_sync</structname></title> +
> > > > > > > > <tgroup cols="3">
> > > > > > > > +	&cs-str;
> > > > > > > > +	<tbody valign="top">
> > > > > > > > +	  <row>
> > > > > > > > +	    <entry>__u32</entry>
> > > > > > > > +	    <entry><structfield>buffer_sequence</structfield></entry>
> > > > > > > > +	    <entry>
> > > > > > > > +	      The sequence number of the buffer to be handled next or
> > > > > > > > +	      currently handled by the driver.
> > > > > > > 
> > > > > > > What happens if a particular piece of hardware can capture two
> > > > > > > (or more) simultaneous streams from the same video source (an
> > > > > > > unscaled compressed stream and a scaled down uncompressed stream
> > > > > > > for instance) ? Applications don't need to start both streams at
> > > > > > > the same time, what buffer sequence number should be reported in
> > > > > > > that case ?
> > > > > > 
> > > > > > I think that if the video data comes from the same source, the
> > > > > > sequence numbers should definitely be in sync. This would mean
> > > > > > that for the second stream the first sequence number wouldn't be
> > > > > > zero.
> > > > > 
> > > > > Then we should document this somewhere. Here is probably not the best
> > > > > place to document that, but the buffer_sequence documentation should
> > > > > still refer to the explanation.
> > > > > 
> > > > > I also find the wording a bit unclear. The "buffer to be handled
> > > > > next" could mean the buffer that will be given to an application at
> > > > > the next DQBUF call. Maybe we should refer to frame sequence numbers
> > > > > instead of buffer sequence numbers.
> > > > 
> > > > What's the difference? I would consider the two the same.
> > > 
> > > If we have multiple simultaneous streams from the same source, I think it
> > > would make sense to start thinking about frame sequence numbers instead
> > > of buffer sequence numbers. The buffer sequence number would then just
> > > store the frame sequence number of the frame stored in the buffer. This
> > > would (in my opinion) simplify the spec's understanding.
> > 
> > Another good point from you, I agree with this.
> > 
> > > > ..."buffer to be written next to by the hardware"?
> > > 
> > > What about ..."buffer that will store the image" ?
> > 
> > But which image? And if there is no buffer, no image is written to it
> > either.
> > 
> > "frame to be processed or being processed by the hardware"?
> 
> "frame being received" ? This is a *frame* sync event, it should contain the 
> sequence number of the frame that triggered it.

I'm fine with "frame being received".

-- 
Sakari Ailus
sakari.ailus@iki.fi
