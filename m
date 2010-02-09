Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:44592 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754255Ab0BIPtq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Feb 2010 10:49:46 -0500
Date: Tue, 9 Feb 2010 16:50:26 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-pm@lists.linux-foundation.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Valentin Longchamp <valentin.longchamp@epfl.ch>
Subject: Re: [PATCH/RESEND] soc-camera: add runtime pm support for subdevices
In-Reply-To: <0c196b926b744e04a94850d4d3b1e029.squirrel@webmail.xs4all.nl>
Message-ID: <Pine.LNX.4.64.1002091609350.4585@axis700.grange>
References: <Pine.LNX.4.64.1002081044150.4936@axis700.grange>   
 <4B7012D1.40605@redhat.com>    <Pine.LNX.4.64.1002081447020.4936@axis700.grange>
    <4B705216.7040907@redhat.com>    <Pine.LNX.4.64.1002091053470.4585@axis700.grange>
    <26fe28e3dda70da4d133a9dbc3f2bc74.squirrel@webmail.xs4all.nl>   
 <Pine.LNX.4.64.1002091252530.4585@axis700.grange>   
 <2aa8130b9fd7fe9f9fb2cf626ff58831.squirrel@webmail.xs4all.nl>   
 <4B715CEB.1070602@redhat.com> <0c196b926b744e04a94850d4d3b1e029.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 9 Feb 2010, Hans Verkuil wrote:

> 1) is someone using the driver (i.e. is a device node open, which is not
> necessarily limited to v4l2-type device nodes)?
> 2) are we actively streaming from or to some particular input or output?
> 
> And we probably need some easy way to detect and set the powersaving state
> for each component (subdev or the main v4l2_device).
> 
> I really need to research the pm stuff...

That certainly wouldn't hurt, but I have to resolve a problem of a failing 
device now. And I have 3 options:

1. implement runtime_pm in soc-camera and down, using vdev->dev.type. Easy 
and relatively painless - we already have use-counts there, so, first open 
and last close are readily available.

2. add the same as above to v4l2-dev.c - wouldn't really want to do that, 
implications too large, no use-counting.

3. accept the patch from Val and just write registers, we are currently 
losing, on each s_fmt. Easy, but not very efficient - there can be other 
similar problems elsewhere...

Which of them shall I do for now? Besides, I realise, that decisions which 
devices and when to suspend and to wake up are difficult, so, PM requires 
careful implementation. But doesn't this also mean, that we anyway cannot 
implement any specifics in the top level, and can only implement hooks to 
call hardware-specific pm callbacks, so, probably, the bridge driver will 
have to implement specifics anyway?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
