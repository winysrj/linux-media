Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m34JDa2x022529
	for <video4linux-list@redhat.com>; Fri, 4 Apr 2008 15:13:36 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m34JDOJg025096
	for <video4linux-list@redhat.com>; Fri, 4 Apr 2008 15:13:25 -0400
Date: Fri, 4 Apr 2008 21:13:39 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: =?GB2312?B?t+v2zg==?= <fengxin215@gmail.com>
In-Reply-To: <998e4a820804040811l748bd5b7tedf7a50521ff449e@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0804042027140.7761@axis700.grange>
References: <998e4a820804040811l748bd5b7tedf7a50521ff449e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=KOI8-R
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: question for soc-camera driver
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

Hi

On Fri, 4 Apr 2008, ·ëöÎ wrote:

> Now soc-camera driver can work on my pxa270.I wrote a program to test
> the driver.Only the first frame is right,but others is wrong.The
> program that I wrote come from Video for Linux Two API
> Specification,and work well on other v4l2-driver.

With what camera are you using the driver? Is it one of mt9m001 / mt9v022 
or another one? In what mode is it connected to the CPU? Master parallel? 
Monochrome or colour? How many bits data bus width? Why are you writing 
your own programme and not using an existing one like xawtv, mplayer or 
gstreamer? It would be much easier to diagnose our problem if you took 
mplayer and provided the exact command line and output.

How wrong are the frames? If they are shifted, you might have a problem 
with buffer size calculation somewhere. If you get distorted images, you 
might be getting FIFO overflows. Are you sending output over some library, 
to the X server, or directly to the framebuffer?

See, you need to provide much more information so we could help you.

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
