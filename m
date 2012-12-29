Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f177.google.com ([209.85.216.177]:45854 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472Ab2L2TwP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Dec 2012 14:52:15 -0500
Received: by mail-qc0-f177.google.com with SMTP id u28so5939680qcs.36
        for <linux-media@vger.kernel.org>; Sat, 29 Dec 2012 11:52:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20121229122334.00ea0b8a@redhat.com>
References: <CAGoCfiwzFFZ+hLOKT-5cHTJOiY8ZsRVXmDx+W7x+7uMXMKWk5g@mail.gmail.com>
	<20121228222744.6b567a9b@redhat.com>
	<201212291253.45189.hverkuil@xs4all.nl>
	<20121229122334.00ea0b8a@redhat.com>
Date: Sat, 29 Dec 2012 14:52:14 -0500
Message-ID: <CAGoCfizjL=CozEwxPhvbHwBCHjYGS8VzNx1ewNHh2ebVzhVSVg@mail.gmail.com>
Subject: Re: ABI breakage due to "Unsupported formats in TRY_FMT/S_FMT" recommendation
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Dec 29, 2012 at 9:23 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> On a tvtime compiled without libv4l, the cx18 driver will fail with the
> current logic, as it doesn't return an error when format doesn't
> match. So, tvtime will fail anyway with 50% of the TV drivers that don't
> support YUYV directly. It will also fail with most cameras, as they're
> generally based on proprietary/bayer formats and/or may not have the
> resolutions that tvtime requires.
>
> That's said, libv4l does format conversion. So, if the logic on libv4l
> is working properly, and as tvtime does upport libv4l upstream,
> no real bug should be seen with tvtime, even if the device doesn't
> support neither UYVY or YUYV.

Tvtime doesn't use libv4l (and never has), unless you added support
very recently and it's not in the linuxtv.org tree.  I started to look
into making it use libv4l some months back, but libv4l only supports
providing the video to the app in a few select formats (e.g. RGB
formats and YUV 4:2:0).  Tvtime specifically needs the video in YUYV
or UYVY because it does all its overlays directly onto the video
buffer, the deinterlacers expect YUYV, and the XVideo support in the
app currently only does YUYV.

Changing the app to work with 4:2:0 would mean cleaning up the rats
nest that does all of the above functions - certainly not impossible,
but not trivial either.  In fact, it would probably be better to add
the colorspace conversion code to libv4l to support providing YUYV to
the app when it asks for it.

> The above also applies to MythTV, except that I'm not sure if MythTV uses
> libv4l.

It does not.

There's no doubt that both MythTV and Tvtime could use an overhaul of
their V4L2 code (which became as nasty as it is primarily due to all
the years of the kernel's lack of specified behavior and failure to
enforce consistency across boards).  That's not really relevant to the
discussion at hand though, which is about breaking existing
applications (and possibly all the apps other than the two or three
common open source apps I raised as examples).

I would love to take a half dozen tuner boards of various types and
spend a week cleaning up Myth's code, but frankly I just don't have
the time/energy to take on such a task.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
