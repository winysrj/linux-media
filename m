Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6FKiWkL023667
	for <video4linux-list@redhat.com>; Tue, 15 Jul 2008 16:44:32 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m6FKi03X023735
	for <video4linux-list@redhat.com>; Tue, 15 Jul 2008 16:44:14 -0400
Date: Tue, 15 Jul 2008 22:43:53 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
In-Reply-To: <20080715140141.GG6739@pengutronix.de>
Message-ID: <Pine.LNX.4.64.0807152224040.6361@axis700.grange>
References: <20080715135618.GE6739@pengutronix.de>
	<20080715140141.GG6739@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: PATCH: soc-camera: use flag for colour / bw camera instead of
 module parameter
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

On Tue, 15 Jul 2008, Sascha Hauer wrote:

> Use a flag in struct soc_camera_link for differentiation between
> a black/white and a colour camera rather than a module parameter.
> This allows for having colour and black/white cameras in the same
> system.
> Note that this one breaks the phytec pcm027 pxa board as it makes it
> impossible to switch between cameras on the command line. I will send
> an updated version of this patch once I know this patch is acceptable
> this way.

Yes, we did discuss this on IRC and I did agree to use a platform-provided 
parameter to specify camera properties like colour / monochrome, but now 
as I see it, I think, it might not be a very good idea. Having it as a 
parameter you can just reload the driver with a different parameter to 
test your colour camera in b/w mode. With this change you would need a new 
kernel. What about an array of module parameters? Specifying flags on the 
command line is too weird, so, maybe colo(u)r=0,2 where numbers are 
camera-IDs? Or even 0:0 with bus-IDs. Yes, you would have to add optional 
camera-ID to the link struct.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
