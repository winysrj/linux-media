Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:33796 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753871Ab0BIMCP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Feb 2010 07:02:15 -0500
Date: Tue, 9 Feb 2010 13:02:42 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-pm@lists.linux-foundation.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Valentin Longchamp <valentin.longchamp@epfl.ch>
Subject: Re: [PATCH/RESEND] soc-camera: add runtime pm support for  subdevices
In-Reply-To: <26fe28e3dda70da4d133a9dbc3f2bc74.squirrel@webmail.xs4all.nl>
Message-ID: <Pine.LNX.4.64.1002091252530.4585@axis700.grange>
References: <Pine.LNX.4.64.1002081044150.4936@axis700.grange>   
 <4B7012D1.40605@redhat.com>    <Pine.LNX.4.64.1002081447020.4936@axis700.grange>
    <4B705216.7040907@redhat.com>    <Pine.LNX.4.64.1002091053470.4585@axis700.grange>
 <26fe28e3dda70da4d133a9dbc3f2bc74.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 9 Feb 2010, Hans Verkuil wrote:

> 
> > On Mon, 8 Feb 2010, Mauro Carvalho Chehab wrote:
> >
> >> In fact, on all drivers, there are devices that needs to be turn on only
> >> when
> >> streaming is happening: sensors, analog TV/audio demods, digital demods.
> >> Also,
> >> a few devices (for example: TV tuners) could eventually be on power off
> >> when
> >> no device is opened.
> >>
> >> As the V4L core knows when this is happening (due to
> >> open/close/poll/streamon/reqbuf/qbuf/dqbuf hooks, I think the runtime
> >> management
> >> can happen at V4L core level.
> >
> > Well, we can move it up to v4l core. Should it get any more complicated
> > than adding
> >
> > 	ret = pm_runtime_resume(&vdev->dev);
> > 	if (ret < 0 && ret != -ENOSYS)
> > 		return ret;
> >
> > to v4l2_open() and
> >
> > 	pm_runtime_suspend(&vdev->dev);
> >
> > to v4l2_release()?
> 
> My apologies if I say something stupid as I know little about pm: are you
> assuming here that streaming only happens on one device node? That may be
> true for soc-camera, but other devices can have multiple streaming nodes
> (video, vbi, mpeg, etc). So the call to v4l2_release does not necessarily
> mean that streaming has stopped.

Of course you're right, and it concerns not only multiple streaming modes, 
but simple cases of multiple openings of one node. I was too fast to 
transfer the implementation from soc-camera to v4l2 - in soc-camera I'm 
counting opens and closes and only calling pm hooks on first open and last 
close. So, if we want to put it in v4l-core, we'd have to do something 
similar, I presume.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
