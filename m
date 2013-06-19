Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2032 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756503Ab3FSF6s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jun 2013 01:58:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH v2 1/1] v4l: Document timestamp behaviour to correspond to reality
Date: Wed, 19 Jun 2013 07:58:05 +0200
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
	k.debski@samsung.com
References: <1364076274-726-1-git-send-email-sakari.ailus@iki.fi> <201306101329.53310.hverkuil@xs4all.nl> <8967022.1LtaRJeetE@avalon>
In-Reply-To: <8967022.1LtaRJeetE@avalon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306190758.05494.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue June 18 2013 21:55:26 Laurent Pinchart wrote:
> Hi Hans,
> 
> On Monday 10 June 2013 13:29:53 Hans Verkuil wrote:
> > On Mon June 10 2013 00:35:44 Sakari Ailus wrote:
> 
> [snip]
> 
> > > >>>> Note that the 'timestamp' field documentation still says that it is
> > > >>>> the timestamp of the first data byte for capture as well, that's also
> > > >>>> wrong.
> > > >>> 
> > > >>> I know we've already discussed this, but what about devices, such as
> > > >>> uvcvideo, that can provide the time stamp at which the image has been
> > > >>> captured ? I don't think it would be worth it making this
> > > >>> configurable, or even reporting the information to userspace, but
> > > >>> shouldn't we give some degree of freedom to drivers here ?
> > > >> 
> > > >> Hmm. That's a good question --- if we allow variation then we
> > > >> preferrably should also provide a way for applications to know which
> > > >> case is which.
> > > >> 
> > > >> Could the uvcvideo timestamps be meaningfully converted to the frame
> > > >> end time instead? I'd suppose that a frame rate dependent constant
> > > >> would suffice. However, how to calculate this I don't know.
> > > > 
> > > > I don't think that's a good idea. The time at which the last byte of the
> > > > image is received is meaningless to applications. What they care about,
> > > > for synchronization purpose, is the time at which the image has been
> > > > captured.
> > > > 
> > > > I'm wondering if we really need to care for now. I would be enclined to
> > > > leave it as-is until an application runs into a real issue related to
> > > > timestamps.
> > > 
> > > What do you mean by "image has been captured"? Which part of it?
> > > 
> > > What I was thinking was the possibility that we could change the
> > > definition so that it'd be applicable to both cases: the time the whole
> > > image is fully in the system memory is of secondary importance in both
> > > cases anyway. As on embedded systems the time between the last pixel of
> > > the image is fully captured to it being in the host system memory is
> > > very, very short the two can be considered the same in most situations.
> > > 
> > > I wonder if this change would have any undesirable consequences.
> > 
> > I really think we need to add a buffer flag that states whether the
> > timestamp is taken at the start or at the end of the frame.
> > 
> > For video receivers the timestamp at the end of the frame is the logical
> > choice and this is what almost all drivers do. Only for sensors can the
> > start of the frame be more suitable since the framerate can be variable.
> > 
> > /* Timestamp is taken at the start-of-frame, not the end-of-frame */
> > #define V4L2_BUF_FLAG_TIMESTAMP_SOF 0x0200
> > 
> > I think it is a safe bet that we won't see 'middle of frame' timestamps, so
> > let's just add this flag.
> 
> Given that the timestamp will very likely not vary during the stream, wouldn't 
> it make sense to put the flag somewhere else ? Otherwise applications won't be 
> able to know when the timestamp is taken beforehand.

Actually, they can. After calling REQBUFS they can call QUERYBUF and that should
have the flag set.

The only ioctls where adding such a flag makes sense are REQBUFS and CREATE_BUFS,
which means taking a reserved field just for this. But I actually think it is
much more logical to keep all the timestamp information in one place. And since
it can be queried before starting streaming using QUERYBUF...

Regards,

	Hans
