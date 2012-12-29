Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13151 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752916Ab2L2O7F (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Dec 2012 09:59:05 -0500
Date: Sat, 29 Dec 2012 12:58:38 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: ABI breakage due to "Unsupported formats in TRY_FMT/S_FMT"
 recommendation
Message-ID: <20121229125838.4cabb5a0@redhat.com>
In-Reply-To: <20121229122334.00ea0b8a@redhat.com>
References: <CAGoCfiwzFFZ+hLOKT-5cHTJOiY8ZsRVXmDx+W7x+7uMXMKWk5g@mail.gmail.com>
	<20121228222744.6b567a9b@redhat.com>
	<201212291253.45189.hverkuil@xs4all.nl>
	<20121229122334.00ea0b8a@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 29 Dec 2012 12:23:34 -0200
Mauro Carvalho Chehab <mchehab@redhat.com> escreveu:

> Em Sat, 29 Dec 2012 12:53:45 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
> > On Sat December 29 2012 01:27:44 Mauro Carvalho Chehab wrote:
> > > Em Fri, 28 Dec 2012 14:52:24 -0500
> > > Devin Heitmueller <dheitmueller@kernellabs.com> escreveu:
> > > 
> > > > Hi there,
> > > > 
> > > > So I noticed that one of the "V4L2 ambiguities" discussed at the Media
> > > > Workshop relates to expected behavior with TRY_FMT/S_FMT.
> ...
> > > Well, if applications will break with this change, then we need to revisit
> > > the question, and decide otherwise, as it shouldn't break userspace.
> > > 
> > > It should be noticed, however, that currently, some drivers won't
> > > return errors when S_FMT/TRY_FMT requests invalid parameters.
> > > 
> > > So, IMHO, what should be done is:
> > > 	1) to not break userspace;
> > > 	2) userspace apps should be improved to handle those drivers
> > > that have a potential of breaking them;
> > > 	3) clearly state at the API, and enforce via compliance tool,
> > > that all drivers will behave the same.
> > 
> > In my opinion these are application bugs, and not ABI breakages. As Mauro
> > mentioned, some drivers don't return an error and so would always have failed
> > with these apps (examples: cx18/ivtv, gspca).
> 
> It is both an application bug and a potential ABI breakage.
> 
> Hmm... as MythTv and tvtime are meant to be used to watch TV, maybe we can
> look on it using a different angle.
> 
...
> The drivers that only support V4L2_PIX_FMT_UYVY seems to be
> cx18, sta2x11_vip, au0828 and gspca (kinect, w996xcf). From those,
> only cx18 and au0828 are TV drivers.
> 
> On a tvtime compiled without libv4l, the cx18 driver will fail with the
> current logic, as it doesn't return an error when format doesn't
> match. So, tvtime will fail anyway with 50% of the TV drivers that don't
> support YUYV directly. It will also fail with most cameras, as they're
> generally based on proprietary/bayer formats and/or may not have the
> resolutions that tvtime requires.

Not sure if I was clear enough. In summary, what I'm saying is that:

1) userspace apps should be fixed, as they're currently broken for cx18,
when libv4l support is disabled;

2) from kernelspace's perspective, it seems that the changes for the above
affected drivers need to be postponed. If this bug happens only on
tvtime and MythTV, then changes on drivers that don't support UYVY
could be done anytime, but a yellow flag rised: we should be sure that
other userspace applications and libv4l won't be affected before changing
an existing kernel driver, as no regressions are accepted.

Cheers,
Mauro
