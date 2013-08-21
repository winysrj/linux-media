Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54304 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751475Ab3HULeh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Aug 2013 07:34:37 -0400
Date: Wed, 21 Aug 2013 14:34:33 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, k.debski@samsung.com
Subject: Re: [PATCH v2 1/1] v4l: Document timestamp behaviour to correspond
 to reality
Message-ID: <20130821113432.GC20717@valkosipuli.retiisi.org.uk>
References: <1364076274-726-1-git-send-email-sakari.ailus@iki.fi>
 <1732074.vUfkmKHbt9@avalon>
 <51B50340.4020509@iki.fi>
 <201306101329.53310.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201306101329.53310.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Apologies for the much delayed answer.

On Mon, Jun 10, 2013 at 01:29:53PM +0200, Hans Verkuil wrote:
> On Mon June 10 2013 00:35:44 Sakari Ailus wrote:
> > Hi Laurent,
> > 
> > Laurent Pinchart wrote:
> > ...
> > >>>>> @@ -745,13 +718,9 @@ applications when an output stream.</entry>
> > >>>>>
> > >>>>>   	    byte was captured, as returned by the
> > >>>>>   	    <function>clock_gettime()</function> function for the relevant
> > >>>>>   	    clock id; see <constant>V4L2_BUF_FLAG_TIMESTAMP_*</constant> in
> > >>>>>
> > >>>>> -	    <xref linkend="buffer-flags" />. For output streams the data
> > >>>>> -	    will not be displayed before this time, secondary to the nominal
> > >>>>> -	    frame rate determined by the current video standard in enqueued
> > >>>>> -	    order. Applications can for example zero this field to display
> > >>>>> -	    frames as soon as possible. The driver stores the time at which
> > >>>>> -	    the first data byte was actually sent out in the
> > >>>>> -	    <structfield>timestamp</structfield> field. This permits
> > >>>>> +	    <xref linkend="buffer-flags" />. For output streams he driver
> > >>>>
> > >>>> 'he' -> 'the'
> > >>>>
> > >>>>> +	   stores the time at which the first data byte was actually sent
> > >>>>> out
> > >>>>> +	   in the  <structfield>timestamp</structfield> field. This permits
> > >>>>
> > >>>> Not true: the timestamp is taken after the whole frame was transmitted.
> > >>>>
> > >>>> Note that the 'timestamp' field documentation still says that it is the
> > >>>> timestamp of the first data byte for capture as well, that's also wrong.
> > >>>
> > >>> I know we've already discussed this, but what about devices, such as
> > >>> uvcvideo, that can provide the time stamp at which the image has been
> > >>> captured ? I don't think it would be worth it making this configurable,
> > >>> or even reporting the information to userspace, but shouldn't we give
> > >>> some degree of freedom to drivers here ?
> > >>
> > >> Hmm. That's a good question --- if we allow variation then we preferrably
> > >> should also provide a way for applications to know which case is which.
> > >>
> > >> Could the uvcvideo timestamps be meaningfully converted to the frame end
> > >> time instead? I'd suppose that a frame rate dependent constant would
> > >> suffice. However, how to calculate this I don't know.
> > >
> > > I don't think that's a good idea. The time at which the last byte of the image
> > > is received is meaningless to applications. What they care about, for
> > > synchronization purpose, is the time at which the image has been captured.
> > >
> > > I'm wondering if we really need to care for now. I would be enclined to leave
> > > it as-is until an application runs into a real issue related to timestamps.
> > 
> > What do you mean by "image has been captured"? Which part of it?
> > 
> > What I was thinking was the possibility that we could change the 
> > definition so that it'd be applicable to both cases: the time the whole 
> > image is fully in the system memory is of secondary importance in both 
> > cases anyway. As on embedded systems the time between the last pixel of 
> > the image is fully captured to it being in the host system memory is 
> > very, very short the two can be considered the same in most situations.
> > 
> > I wonder if this change would have any undesirable consequences.
> 
> I really think we need to add a buffer flag that states whether the timestamp
> is taken at the start or at the end of the frame.
> 
> For video receivers the timestamp at the end of the frame is the logical
> choice and this is what almost all drivers do. Only for sensors can the start
> of the frame be more suitable since the framerate can be variable.

Do you have a use case in mind?

The start-of-frame (frame sync) event is can be subscribed for that purpose.
Most of the time the start-of-frame event is also generated by a different
hardware sub-block (and thus sub-device) than the one that finally writes
the image to the system memory. In the future there could be cases where
it's a different driver altogeter, albeit we don't have one now. Besides
possibly requiring at least a tiny hack to implement in a driver I could
hardly argue that kind of an implementation would be more beautiful: the
buffer timestamp is better associated with end-of-frame if possible. Systems
that need the start-of-frame event generally need both (at least the ones
I'm aware of).

> /* Timestamp is taken at the start-of-frame, not the end-of-frame */
> #define V4L2_BUF_FLAG_TIMESTAMP_SOF 0x0200
> 
> I think it is a safe bet that we won't see 'middle of frame' timestamps, so
> let's just add this flag.

Agreed. I'll add the flag and resend.

-- 
Cheers,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
