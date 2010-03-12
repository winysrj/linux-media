Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:40345 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932427Ab0CLW7S (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Mar 2010 17:59:18 -0500
Received: by bwz1 with SMTP id 1so1500267bwz.21
        for <linux-media@vger.kernel.org>; Fri, 12 Mar 2010 14:59:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B9AC590.3020408@redhat.com>
References: <829197381003121211l469c30bfjba077cea028bf680@mail.gmail.com>
	 <201003122242.06508.hverkuil@xs4all.nl> <4B9AC590.3020408@redhat.com>
Date: Fri, 12 Mar 2010 17:59:16 -0500
Message-ID: <829197381003121459oed85501wbe7870785e91893@mail.gmail.com>
Subject: Re: Remaining drivers that aren't V4L2?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <j.w.r.degoede@hhs.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 12, 2010 at 5:52 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> All the above are webcam drivers. I doubt that those drivers would work
> with tvtime: this software were meant to test the Vector's deinterlacing
> algorithms, so it requires some specific video formats/resolutions found on TV
> and require 25 or 30 fps, as far as I remember. For example, It doesn't support
> QCIF/QVGA cameras.

Yup, I was indeed aware that tvtime doesn't really work with webcams.
I wanted to see the list of remaining drivers, and now that I see the
list (and also came to the conclusion that they were all webcams), I
feel much more comfortable just dropping V4L1 support.

> If you want to extend tvtime to use webcams, some work is needed. Probably the easiest
> way would be to use libv4l, that also does the V4L1 conversion, if needed. This may
> actually make sense even for a few TV cards like em28xx, where you could use a bayer
> format with a lower color depth and/or lower resolution, in order to allow viewing two
> simultaneous streams.
>
> So, I suggest you to just drop V4L1 from tvtime and convert it to use libv4l (the conversion
> is trivial: just replace open/close/ioctl from the V4L2 driver to the libv4l ones). This will
> allow you to drop the old V4L1 driver from it, and, if you decide later to accept other
> resolutions and make it more webcam friendly, you'll just need to allow tvtime to accept
> other video resolutions and disable the de-interlacing setup if a webcam is detected.

I have actually been considering converting tvtime to using libv4l for
a while now, as I need it to support cards that use the HM12
pixelformat (such as the HVR-1600).  I wanted to rip out the V4L1
support first to make the conversion more straightforward.

It really isn't my goal to make tvtime support webcams, although they
might just start to work as an unintended side-effect.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
