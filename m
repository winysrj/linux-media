Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6RJBZZJ019849
	for <video4linux-list@redhat.com>; Sun, 27 Jul 2008 15:11:35 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m6RJBNmr030257
	for <video4linux-list@redhat.com>; Sun, 27 Jul 2008 15:11:23 -0400
Date: Sun, 27 Jul 2008 21:11:43 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
In-Reply-To: <878wvnkd8n.fsf@free.fr>
Message-ID: <Pine.LNX.4.64.0807271337270.1604@axis700.grange>
References: <1217113647-20638-1-git-send-email-robert.jarzmik@free.fr>
	<Pine.LNX.4.64.0807270155020.29126@axis700.grange>
	<878wvnkd8n.fsf@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com, linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH] Fix suspend/resume of pxa_camera driver
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Sun, 27 Jul 2008, Robert Jarzmik wrote:

> Yes, I have tested, with a complete suspend/resume cycle on a Mitac Mio A701
> smartphone. And yes, the PXA suspend is based on SDRAM being in self refresh
> state. I'm speaking of suspend, not standby, there's no confusion here.
> 
> Notice I always go into suspend while _not_ in active capturing. That could
> change things.

Yes, this is the difference. The sensor is attached to the camera host 
only on open. In fact, I am not sure, how video applications should behave 
during a suspend / resume cycle. If you suspend, while, say, recording 
from your camera, should you directly continue recording after a wake up? 
How do currect drivers implement this? Or, in general, for example with 
audio - if you suspend while listening to a stream over the net, or to a 
CD, or to a mp3-file on your local disk, should the sound resume after a 
wake up? I added linux-pm for some authoritative answers:-)

If you know how a v4l2 device should handle suspend/resume, or when we get 
some answers, let's try to do it completely-

> Have you previously tested the pxa_camera driver in suspend ?

No, I have not. I didn't have power-management enabled on my board, and I 
don't know how easy such tests would be on my hardware. That's why I just 
removed all suspend/resume code from the pxa270 driver completely.

> For history, my setup is :
>  - a pxa272 on a Mio A701 board
>  - a Micron MT9M111 chip (driver under construction)
> 
> For the camera part, by now, I'm using standard suspend/resume functions of the
> platform driver (mt9m111.c). It does work, but it's not clean ATM. The chaining
> between the driver resume function and the availability of the I2C bus are not
> properly chained. I'm still working on it.

Yes, we have to clarify this too.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
