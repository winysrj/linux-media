Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:37178 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751911Ab0BIK0p (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Feb 2010 05:26:45 -0500
Date: Tue, 9 Feb 2010 11:27:20 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
cc: linux-pm@lists.linux-foundation.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Valentin Longchamp <valentin.longchamp@epfl.ch>
Subject: Re: [PATCH/RESEND] soc-camera: add runtime pm support for subdevices
In-Reply-To: <4B705216.7040907@redhat.com>
Message-ID: <Pine.LNX.4.64.1002091053470.4585@axis700.grange>
References: <Pine.LNX.4.64.1002081044150.4936@axis700.grange>
 <4B7012D1.40605@redhat.com> <Pine.LNX.4.64.1002081447020.4936@axis700.grange>
 <4B705216.7040907@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 8 Feb 2010, Mauro Carvalho Chehab wrote:

> In fact, on all drivers, there are devices that needs to be turn on only when
> streaming is happening: sensors, analog TV/audio demods, digital demods. Also,
> a few devices (for example: TV tuners) could eventually be on power off when
> no device is opened.
> 
> As the V4L core knows when this is happening (due to
> open/close/poll/streamon/reqbuf/qbuf/dqbuf hooks, I think the runtime management 
> can happen at V4L core level.

Well, we can move it up to v4l core. Should it get any more complicated 
than adding

	ret = pm_runtime_resume(&vdev->dev);
	if (ret < 0 && ret != -ENOSYS)
		return ret;

to v4l2_open() and

	pm_runtime_suspend(&vdev->dev);

to v4l2_release()? And to agree, that video drivers may set a device type 
to implement runtime PM, and that the v4l core shouldn't touch it? Then, 
for example, a bridge driver could implement such a device type instance 
and suspend or resume all related components?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
