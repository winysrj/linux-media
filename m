Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3FBOeNn026294
	for <video4linux-list@redhat.com>; Tue, 15 Apr 2008 07:24:40 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m3FBONq0022608
	for <video4linux-list@redhat.com>; Tue, 15 Apr 2008 07:24:24 -0400
Date: Tue, 15 Apr 2008 12:57:49 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
In-Reply-To: <48047FD4.7010602@hni.uni-paderborn.de>
Message-ID: <Pine.LNX.4.64.0804151245230.5159@axis700.grange>
References: <48047FD4.7010602@hni.uni-paderborn.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: Image grabbing from pxa_camera driver via console
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

You've forgotten to cc the list. Re-added.

On Tue, 15 Apr 2008, Stefan Herbrechtsmeier wrote:

> what do you use for testing the pxa_camera driver. I'm searching for a console
> image grabbing tool to test my ov9655 driver. Can you recommend some tool?

I found the test application from the v4l2-apps suite with fengxin's 
modification http://marc.info/?l=linux-video&m=120762092820785&w=2 useful. 
I also used (a locally modified version of) the programme quoted in
http://linux.omap.com/pipermail/linux-omap-open-source/2006-March/006653.html
Otherwise I also use mplayer, which is not a console application, but you 
can use it or mencoder to capture the stream.

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
