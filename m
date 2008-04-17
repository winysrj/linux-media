Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3HEY37p004269
	for <video4linux-list@redhat.com>; Thu, 17 Apr 2008 10:34:03 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m3HEXixa024951
	for <video4linux-list@redhat.com>; Thu, 17 Apr 2008 10:33:44 -0400
Date: Thu, 17 Apr 2008 16:33:52 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Mike Rapoport <mike@compulab.co.il>
In-Reply-To: <4806E637.9030906@compulab.co.il>
Message-ID: <Pine.LNX.4.64.0804171616020.6716@axis700.grange>
References: <47F21593.7080507@compulab.co.il>
	<Pine.LNX.4.64.0804031708470.18539@axis700.grange>
	<47F872DE.60004@compulab.co.il>
	<Pine.LNX.4.64.0804091626140.5671@axis700.grange>
	<4806E637.9030906@compulab.co.il>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] pxa_camera: Add support for YUV modes
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

On Thu, 17 Apr 2008, Mike Rapoport wrote:

> Sorry for the delay, and as far as I can see you've already have a fix. :)

I hope so:-)

> If you'd like I can test it with YUV setup. I'll apreciate if you can send me
> the entire updated pxa_camera.c, to save time on merge conflicts.

Well, let's try it this way: I've uploaded the current patch set on

http://home.arcor.de/g.liakhovetski/v4l/2.6.25/

where patches under v4l-dvb:devel/ are already in the current 
v4l-dvb/devel. The patch under gpio/ is needed for mt9*.c, but you won't 
probably need it either. Let me know if you get any problems.

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
