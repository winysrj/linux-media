Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39945 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab3FHG7l (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Jun 2013 02:59:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
	k.debski@samsung.com
Subject: Re: [PATCH v2 1/1] v4l: Document timestamp behaviour to correspond to reality
Date: Sat, 08 Jun 2013 08:59:43 +0200
Message-ID: <21759159.gaVOrBXtYV@avalon>
In-Reply-To: <201306071721.52331.hverkuil@xs4all.nl>
References: <1364076274-726-1-git-send-email-sakari.ailus@iki.fi> <201306071721.52331.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Friday 07 June 2013 17:21:52 Hans Verkuil wrote:
> On Sat March 23 2013 23:04:34 Sakari Ailus wrote:
> > Document that monotonic timestamps are taken after the corresponding frame
> > has been received, not when the reception has begun. This corresponds to
> > the reality of current drivers: the timestamp is naturally taken when the
> > hardware triggers an interrupt to tell the driver to handle the received
> > frame.
> > 
> > Remove the note on timestamp accurary as it is fairly subjective what is
> > actually an unstable timestamp.
> > 
> > Also remove explanation that output buffer timestamps can be used to delay
> > outputting a frame.
> > 
> > Remove the footnote saying we always use realtime clock.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> 
> Sorry for the delay, for some reason this patch wasn't picked up by
> patchwork.
> > ---
> > Hi all,
> > 
> > This is the second version of the patch fixing timestamp behaviour
> > documentation. I've tried to address the comments I've received albeit I
> > don't think there was a definitive conclusion on all the trails of
> > discussion. What has changed since v1 is:
> > 
> > - Removed discussion on timestamp stability.
> > 
> > - Removed notes that timestamps on output buffers define when frames will
> >   be displayed. It appears no driver has ever implemented this, or at
> >   least does not implement this now.
> > 
> > - Monotonic time is not affected by harms that the wall clock time is
> > 
> >   subjected to. Remove notes on that.
> >  
> >  Documentation/DocBook/media/v4l/io.xml |   47 +++++----------------------
> >  1 file changed, 8 insertions(+), 39 deletions(-)
> > 
> > diff --git a/Documentation/DocBook/media/v4l/io.xml
> > b/Documentation/DocBook/media/v4l/io.xml index e6c5855..46d5a41 100644
> > --- a/Documentation/DocBook/media/v4l/io.xml
> > +++ b/Documentation/DocBook/media/v4l/io.xml

[snip]

> > @@ -745,13 +718,9 @@ applications when an output stream.</entry>
> > 
> >  	    byte was captured, as returned by the
> >  	    <function>clock_gettime()</function> function for the relevant
> >  	    clock id; see <constant>V4L2_BUF_FLAG_TIMESTAMP_*</constant> in
> > 
> > -	    <xref linkend="buffer-flags" />. For output streams the data
> > -	    will not be displayed before this time, secondary to the nominal
> > -	    frame rate determined by the current video standard in enqueued
> > -	    order. Applications can for example zero this field to display
> > -	    frames as soon as possible. The driver stores the time at which
> > -	    the first data byte was actually sent out in the
> > -	    <structfield>timestamp</structfield> field. This permits
> > +	    <xref linkend="buffer-flags" />. For output streams he driver
> 
> 'he' -> 'the'
> 
> > +	   stores the time at which the first data byte was actually sent out
> > +	   in the  <structfield>timestamp</structfield> field. This permits
> 
> Not true: the timestamp is taken after the whole frame was transmitted.
> 
> Note that the 'timestamp' field documentation still says that it is the
> timestamp of the first data byte for capture as well, that's also wrong.

I know we've already discussed this, but what about devices, such as uvcvideo, 
that can provide the time stamp at which the image has been captured ? I don't 
think it would be worth it making this configurable, or even reporting the 
information to userspace, but shouldn't we give some degree of freedom to 
drivers here ?

> >  	    applications to monitor the drift between the video and system
> >  	    clock.</para></entry>
> >  	  
> >  	  </row>

-- 
Regards,

Laurent Pinchart

