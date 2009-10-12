Return-path: <linux-media-owner@vger.kernel.org>
Received: from ppsw-6.csi.cam.ac.uk ([131.111.8.136]:37876 "EHLO
	ppsw-6.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757427AbZJLSBc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Oct 2009 14:01:32 -0400
Message-ID: <4AD36EE5.1060807@cam.ac.uk>
Date: Mon, 12 Oct 2009 19:01:09 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: pxa-camera: build error 2.6.32-rc4
References: <4AD36D2D.2000202@cam.ac.uk>
In-Reply-To: <4AD36D2D.2000202@cam.ac.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jonathan Cameron wrote:
> Error was 
> 
> drivers/media/video/pxa_camera.c: In function 'pxa_camera_wakeup':
> drivers/media/video/pxa_camera.c:683: error: 'TASK_NORMAL' undeclared (first use in this function)
> drivers/media/video/pxa_camera.c:683: error: (Each undeclared identifier is reported only once
> drivers/media/video/pxa_camera.c:683: error: for each function it appears in.)
>   CC [M]  drivers/pcmcia/soc_common.o
> 
> Line in question is
> 
>         wake_up(&vb->done);
> in pxa_camera_wakeup.
> 
> Looks like issue is lack of inclusion of sched.h.
> 
> Right now I'm having trouble tracking down why this became and issue since 2.6.32-rc3.
> 
> Might be related to
> Staging: comedi: Add include of <linux/sched.h> to fix build
> which is down to removal of sched.h from poll.h
> commmit a99bbaf5ee6bad1aca0c88ea65ec6e5373e86184
> Looks like media/v4l2-dev.h and others include poll.h so I'm guessing
> we were original getting it from there.
> 
> I'm happy to post a patch but was wondering if anyone else has seen this or has tracked down
> exactly what changed, not to mention if this is a more general problem? (or for that matter
> already fixed and I just missed it.)

Just read lkml, Ingo Molnar has posted a whole set of patches (in reply to Linus' 2.6.32-rc4 thread)
dealing with this issue in a number of other places.  This one isn't there however.

Jonathan
