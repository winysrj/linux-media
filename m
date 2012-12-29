Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60211 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752972Ab2L2Ucw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Dec 2012 15:32:52 -0500
Date: Sat, 29 Dec 2012 18:32:24 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: ABI breakage due to "Unsupported formats in TRY_FMT/S_FMT"
 recommendation
Message-ID: <20121229183224.349c9cf3@redhat.com>
In-Reply-To: <CAGoCfizjL=CozEwxPhvbHwBCHjYGS8VzNx1ewNHh2ebVzhVSVg@mail.gmail.com>
References: <CAGoCfiwzFFZ+hLOKT-5cHTJOiY8ZsRVXmDx+W7x+7uMXMKWk5g@mail.gmail.com>
	<20121228222744.6b567a9b@redhat.com>
	<201212291253.45189.hverkuil@xs4all.nl>
	<20121229122334.00ea0b8a@redhat.com>
	<CAGoCfizjL=CozEwxPhvbHwBCHjYGS8VzNx1ewNHh2ebVzhVSVg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 29 Dec 2012 14:52:14 -0500
Devin Heitmueller <dheitmueller@kernellabs.com> escreveu:

> On Sat, Dec 29, 2012 at 9:23 AM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
> > On a tvtime compiled without libv4l, the cx18 driver will fail with the
> > current logic, as it doesn't return an error when format doesn't
> > match. So, tvtime will fail anyway with 50% of the TV drivers that don't
> > support YUYV directly. It will also fail with most cameras, as they're
> > generally based on proprietary/bayer formats and/or may not have the
> > resolutions that tvtime requires.
> >
> > That's said, libv4l does format conversion. So, if the logic on libv4l
> > is working properly, and as tvtime does upport libv4l upstream,
> > no real bug should be seen with tvtime, even if the device doesn't
> > support neither UYVY or YUYV.
> 
> Tvtime doesn't use libv4l (and never has), unless you added support
> very recently and it's not in the linuxtv.org tree. 

No, I didn't add. Not sure why I was thinking that support for it was
added.

> I started to look
> into making it use libv4l some months back, but libv4l only supports
> providing the video to the app in a few select formats (e.g. RGB
> formats and YUV 4:2:0).  Tvtime specifically needs the video in YUYV
> or UYVY because it does all its overlays directly onto the video
> buffer, the deinterlacers expect YUYV, and the XVideo support in the
> app currently only does YUYV.
> 
> Changing the app to work with 4:2:0 would mean cleaning up the rats
> nest that does all of the above functions - certainly not impossible,
> but not trivial either.  In fact, it would probably be better to add
> the colorspace conversion code to libv4l to support providing YUYV to
> the app when it asks for it.

Agreed. Adding YUYV support at libv4l should be easy.

> > The above also applies to MythTV, except that I'm not sure if MythTV uses
> > libv4l.
> 
> It does not.
> 
> There's no doubt that both MythTV and Tvtime could use an overhaul of
> their V4L2 code (which became as nasty as it is primarily due to all
> the years of the kernel's lack of specified behavior and failure to
> enforce consistency across boards).  That's not really relevant to the
> discussion at hand though, which is about breaking existing
> applications (and possibly all the apps other than the two or three
> common open source apps I raised as examples).

Well, xawtv won't break, even without libv4l. Codes based on it won't
likely break either.

Applications that use libv4l will do whatever behavior libv4l does.

I suspect your couple examples are the most used applications that
don't fit into either case.

So, in order to make the kernel drivers consistent, we need to know 
what other applications that don't use libv4l and would behave bad
with driver changes at VIDIOC_S_FMT's way to return data to implement
what it is at the specs.

Then, work on a solution that will work everywhere.

We can only touch the drivers afer being sure that no regressions
will happen.

> I would love to take a half dozen tuner boards of various types and
> spend a week cleaning up Myth's code, but frankly I just don't have
> the time/energy to take on such a task.
> 
> Devin
> 


-- 

Cheers,
Mauro
