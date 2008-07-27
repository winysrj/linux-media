Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6R7HPaT025982
	for <video4linux-list@redhat.com>; Sun, 27 Jul 2008 03:17:25 -0400
Received: from smtp7-g19.free.fr (smtp7-g19.free.fr [212.27.42.64])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6R7HE7b027203
	for <video4linux-list@redhat.com>; Sun, 27 Jul 2008 03:17:14 -0400
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <1217113647-20638-1-git-send-email-robert.jarzmik@free.fr>
	<Pine.LNX.4.64.0807270155020.29126@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Sun, 27 Jul 2008 09:17:12 +0200
In-Reply-To: <Pine.LNX.4.64.0807270155020.29126@axis700.grange> (Guennadi
	Liakhovetski's message of "Sun\,
	27 Jul 2008 02\:07\:39 +0200 \(CEST\)")
Message-ID: <878wvnkd8n.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: video4linux-list@redhat.com
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

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

> On Sun, 27 Jul 2008, Robert Jarzmik wrote:
>
>> PXA suspend switches off DMA core, which looses all context
>> of previously assigned descriptors. As pxa_camera driver
>> relies on DMA transfers, setup the lost descriptors on
>> resume.
>
> Hm, is this really enough? How have you tested it - with a complete STR 
> with powering the CPU and all peripherals down and only keeping the SDRAM 
> in self-refresh or with some sort of a low-power "standby" mode? I think, 
> when the CPU is really powered off, and this is what the suspend / resume 
> callbacks should support, something like calling pxa_camera_deactivate() / 
> pxa_camera_activate() should be done, i.e., disabling / enabling of 
> clocks, configuring clock modes on the camera interface, resetting and 
> powering down and up the camera. Please also notice, there're patches in 
> work (ping?) to move ->power and ->reset callbacks from per camera host to 
> per camera sensor. But you probably just can ignore those plans, even if 
> you do conflict with them we'll resolve the conflict later.

Yes, I have tested, with a complete suspend/resume cycle on a Mitac Mio A701
smartphone. And yes, the PXA suspend is based on SDRAM being in self refresh
state. I'm speaking of suspend, not standby, there's no confusion here.

Notice I always go into suspend while _not_ in active capturing. That could
change things.

Have you previously tested the pxa_camera driver in suspend ?

For history, my setup is :
 - a pxa272 on a Mio A701 board
 - a Micron MT9M111 chip (driver under construction)

For the camera part, by now, I'm using standard suspend/resume functions of the
platform driver (mt9m111.c). It does work, but it's not clean ATM. The chaining
between the driver resume function and the availability of the I2C bus are not
properly chained. I'm still working on it.

--
Robert

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
