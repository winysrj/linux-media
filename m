Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6R07sQ3023333
	for <video4linux-list@redhat.com>; Sat, 26 Jul 2008 20:07:54 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m6R07g1C013877
	for <video4linux-list@redhat.com>; Sat, 26 Jul 2008 20:07:42 -0400
Date: Sun, 27 Jul 2008 02:07:39 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
In-Reply-To: <1217113647-20638-1-git-send-email-robert.jarzmik@free.fr>
Message-ID: <Pine.LNX.4.64.0807270155020.29126@axis700.grange>
References: <1217113647-20638-1-git-send-email-robert.jarzmik@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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

On Sun, 27 Jul 2008, Robert Jarzmik wrote:

> PXA suspend switches off DMA core, which looses all context
> of previously assigned descriptors. As pxa_camera driver
> relies on DMA transfers, setup the lost descriptors on
> resume.

Hm, is this really enough? How have you tested it - with a complete STR 
with powering the CPU and all peripherals down and only keeping the SDRAM 
in self-refresh or with some sort of a low-power "standby" mode? I think, 
when the CPU is really powered off, and this is what the suspend / resume 
callbacks should support, something like calling pxa_camera_deactivate() / 
pxa_camera_activate() should be done, i.e., disabling / enabling of 
clocks, configuring clock modes on the camera interface, resetting and 
powering down and up the camera. Please also notice, there're patches in 
work (ping?) to move ->power and ->reset callbacks from per camera host to 
per camera sensor. But you probably just can ignore those plans, even if 
you do conflict with them we'll resolve the conflict later.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
