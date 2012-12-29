Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28103 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752945Ab2L2U0v (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Dec 2012 15:26:51 -0500
Date: Sat, 29 Dec 2012 18:00:00 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: ABI breakage due to "Unsupported formats in TRY_FMT/S_FMT"
 recommendation
Message-ID: <20121229180000.31db58e3@redhat.com>
In-Reply-To: <CAGoCfix-3AgrkBUtFwLYTQf3YYL9t-8D7Qrge1fvJg-Fd+aBLA@mail.gmail.com>
References: <CAGoCfiwzFFZ+hLOKT-5cHTJOiY8ZsRVXmDx+W7x+7uMXMKWk5g@mail.gmail.com>
	<20121228222744.6b567a9b@redhat.com>
	<201212291253.45189.hverkuil@xs4all.nl>
	<CAGoCfix-3AgrkBUtFwLYTQf3YYL9t-8D7Qrge1fvJg-Fd+aBLA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 29 Dec 2012 12:39:11 -0500
Devin Heitmueller <dheitmueller@kernellabs.com> escreveu:

> > I suspect that the behavior of returning an error if a pixelformat is not
> > supported is a leftover from the V4L1 API (VIDIOCSPICT). When drivers were
> > converted to S/TRY_FMT this method of handling unsupported pixelformats was
> > probably never changed. And quite a few newer drivers copy-and-pasted that
> > method. Drivers like cx18/ivtv that didn't copy-and-paste code looked at the
> > API and followed what the API said.
> >
> > At the moment most TV drivers seem to return an error, whereas for webcams
> > it is hit and miss: uvc returned an error (until it was fixed recently),
> > gspca didn't. So webcam applications probably do the right thing given the
> > behavior of gspca.
> 
> What if we returned an error but still changed the struct to specify
> the supported format?  That's not what the spec says, but it seems
> like that's what is implemented in many drivers today and what many
> applications expect to happen.

That sounds a very bad idea: when an error rises, applications should
not trust on any returned value, except for the returned error code
itself. All the other values can be on some random state.

This is perhaps the only behavior that are consistent on all ioctls of the
media subsystem (and likely on the other ioctl's of the Kernel).

> No doubt, this is a mess, and if we had tighter enforcement and better
> specs before this stuff went upstream years ago, we wouldn't be in
> this situation.  But that's not the world we live in, and we have to
> deal with where we stand today.

Well, something needs to be done at Kernel level, in order to make this ioctl
consistent among all drivers. I'm open to proposals.

In any case, applications aren't implementing the same logic to handle
this ioctl. This should be fixed there, in order to avoid unexpected
troubles with different hardware.

Cheers,
Mauro
