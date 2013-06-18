Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58520 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933011Ab3FRTzN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Jun 2013 15:55:13 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
	k.debski@samsung.com
Subject: Re: [PATCH v2 1/1] v4l: Document timestamp behaviour to correspond to reality
Date: Tue, 18 Jun 2013 21:55:26 +0200
Message-ID: <8967022.1LtaRJeetE@avalon>
In-Reply-To: <201306101329.53310.hverkuil@xs4all.nl>
References: <1364076274-726-1-git-send-email-sakari.ailus@iki.fi> <51B50340.4020509@iki.fi> <201306101329.53310.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Monday 10 June 2013 13:29:53 Hans Verkuil wrote:
> On Mon June 10 2013 00:35:44 Sakari Ailus wrote:

[snip]

> > >>>> Note that the 'timestamp' field documentation still says that it is
> > >>>> the timestamp of the first data byte for capture as well, that's also
> > >>>> wrong.
> > >>> 
> > >>> I know we've already discussed this, but what about devices, such as
> > >>> uvcvideo, that can provide the time stamp at which the image has been
> > >>> captured ? I don't think it would be worth it making this
> > >>> configurable, or even reporting the information to userspace, but
> > >>> shouldn't we give some degree of freedom to drivers here ?
> > >> 
> > >> Hmm. That's a good question --- if we allow variation then we
> > >> preferrably should also provide a way for applications to know which
> > >> case is which.
> > >> 
> > >> Could the uvcvideo timestamps be meaningfully converted to the frame
> > >> end time instead? I'd suppose that a frame rate dependent constant
> > >> would suffice. However, how to calculate this I don't know.
> > > 
> > > I don't think that's a good idea. The time at which the last byte of the
> > > image is received is meaningless to applications. What they care about,
> > > for synchronization purpose, is the time at which the image has been
> > > captured.
> > > 
> > > I'm wondering if we really need to care for now. I would be enclined to
> > > leave it as-is until an application runs into a real issue related to
> > > timestamps.
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
> I really think we need to add a buffer flag that states whether the
> timestamp is taken at the start or at the end of the frame.
> 
> For video receivers the timestamp at the end of the frame is the logical
> choice and this is what almost all drivers do. Only for sensors can the
> start of the frame be more suitable since the framerate can be variable.
> 
> /* Timestamp is taken at the start-of-frame, not the end-of-frame */
> #define V4L2_BUF_FLAG_TIMESTAMP_SOF 0x0200
> 
> I think it is a safe bet that we won't see 'middle of frame' timestamps, so
> let's just add this flag.

Given that the timestamp will very likely not vary during the stream, wouldn't 
it make sense to put the flag somewhere else ? Otherwise applications won't be 
able to know when the timestamp is taken beforehand.

-- 
Regards,

Laurent Pinchart

