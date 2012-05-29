Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:46875 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab2E2MWu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 May 2012 08:22:50 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Subject: Re: [RFC/PATCH] media: Add stk1160 new driver
Date: Tue, 29 May 2012 14:21:49 +0200
Cc: mchehab@redhat.com, linux-media@vger.kernel.org,
	hdegoede@redhat.com, snjw23@gmail.com
References: <1338050460-5902-1-git-send-email-elezegarcia@gmail.com> <201205281222.57917.hverkuil@xs4all.nl> <CALF0-+VHtPuHCzpAydFjaUnp+JkpJOXxJTJoQEURwvBkmA3vgA@mail.gmail.com>
In-Reply-To: <CALF0-+VHtPuHCzpAydFjaUnp+JkpJOXxJTJoQEURwvBkmA3vgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205291421.49703.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue 29 May 2012 14:05:08 Ezequiel Garcia wrote:
> On Mon, May 28, 2012 at 7:22 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >
> > In practice it seems that the easiest approach is not to clean up anything in the
> > disconnect, just take the lock, do the bare minimum necessary for the disconnect,
> > unregister the video nodes, unlock and end with v4l2_device_put(v4l2_dev).
> >
> > It's a suggestion only, but experience has shown that it works well. And as I said,
> > when you get multiple device nodes, then this is the only workable approach.
> 
> I'm convinced: it's both cleaner and more logical to use
> v4l2_release instead of video_device release to the final cleanup.
> 
> >
> > OK, the general rule is as follows (many drivers do not follow this correctly, BTW,
> > but this is what should happen):
> >
> > - the filehandle that calls REQBUFS owns the buffers and is the only one that can
> > start/stop streaming and queue/dequeue buffers.
> 
> and read, poll, etc right?

Read yes, but anyone can poll.

> 
> > This is until REQBUFS with count == 0
> > is called, or until the filehandle is closed.
> 
> Okey. But currently videobuf2 doesn't notify the driver
> when reqbufs with zero count has been called.
> 
> So, I have to "assume" it (aka trouble ahead) or "capture" the zero
> count case before/after calling vb2_reqbufs (aka ugly).

You just check the count after calling vb2_reqbufs. Nothing ugly about it.

> I humbly think that, if we wan't to enforce this behavior
> (as part of v4l2 driver semantics)
> then we should have videobuf2 tell the driver when reqbufs has been
> called with zero count.
> 
> You can take a look at pwc which only drops owner on filehandle close,

That's a bug. REQBUFS(0) must drop the owner: you've just released all
resources related to streaming, so there is no reason to prevent others
from using them. But I suspect 90% of all drivers do this wrong. Not to
mention that the old videobuf doesn't handle a count of 0 at all, which is
a complete violation of the spec. So an application never knows whether
a count of 0 will work. Lovely... The qv4l2 test tool has some really ugly
workaround for this :-)

At some point I'm going to add a test for this to v4l2-compliance...

> or uvc which captures this from vb2_reqbufs.
> 
> After looking at uvc, now I wonder is it really ugly? or perhaps
> it's just ok.

It would be nice if this was somehow integrated into videobuf2, but not everyone
liked the idea of vb2 using filehandle information from what I remember. But I
didn't push for it very hard.

> 
> 
> > v4l2_device is a top-level struct, video_device represents a single device node.
> > For cleanup purposes there isn't much difference between the two if you have
> > only one device node. When you have more, then those differences are much more
> > important.
> 
> Yes, it's cleaner now.
> 
> Thanks!
> Ezequiel.
> 

Your welcome!

	Hans
