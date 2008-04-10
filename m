Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3A5x6rv006894
	for <video4linux-list@redhat.com>; Thu, 10 Apr 2008 01:59:06 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m3A5wr2c002887
	for <video4linux-list@redhat.com>; Thu, 10 Apr 2008 01:58:53 -0400
Date: Thu, 10 Apr 2008 07:58:52 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: =?GB2312?B?t+v2zg==?= <fengxin215@gmail.com>
In-Reply-To: <998e4a820804092242i8ead476nf7e4db3712bc881@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0804100749310.3693@axis700.grange>
References: <998e4a820804040811l748bd5b7tedf7a50521ff449e@mail.gmail.com>
	<Pine.LNX.4.64.0804042027140.7761@axis700.grange>
	<998e4a820804070417w7cf71869h5f36c2ec18c8584c@mail.gmail.com>
	<Pine.LNX.4.64.0804071322490.5585@axis700.grange>
	<998e4a820804071849s60e883f9ne2d8ad6a2f48bd42@mail.gmail.com>
	<Pine.LNX.4.64.0804090104190.4987@axis700.grange>
	<998e4a820804081827j5379efdfw3a95dd1731e02e42@mail.gmail.com>
	<Pine.LNX.4.64.0804091616470.5671@axis700.grange>
	<998e4a820804092242i8ead476nf7e4db3712bc881@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
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

On Thu, 10 Apr 2008, ·ëöÎ wrote:

> 2008/4/9 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:.
> 
> >  Please test the patch below. It should apply on the top of v4l-dvb plus,
> >  if this patch is yet not there, the patch from
> >  http://marc.info/?l=linux-video&m=120771921814753&w=2
> >
> >  Please test with your test application, see if the frame origin iw now
> >  correct, and if you too get the partially inverted frame sequence, i.e.,
> >  like 1, 3, 2, 5, 4,... If yes, try reducing the number of buffers to 2 and
> >  see if this problem disappears then.
> 
> Thanks,I test it already. if I request 4 buffers,wrong frames will
> appear sometimes and get the partially inverted frame sequence too.If

can you describe more precisely what you mean by "wrong frames?" Is it the 
same problem as what I'm seeing here: misplaced start of frame, i.e., your 
frame looks divided into four rectangles?

> I request 2 buffers,there is not wrong frames.But some frames will be
> lost,like 1,2,3,4,7,8,9,10,14,...

This is good. This means those frames had buffer overruns and have been 
dropped. Above you mean, that frames 5, 6, 11, 12, and 13 have been 
dropped, not that all frames you listed have been dropped?

I will see if I can further improve the algorithm and identify why the 
frame sequence gets inverted with 4 buffers, but I don't know when I will 
get time for this.

In general, for your real application, you should really consider doing 
something like what mplayer is doing - an own thread for video data 
read-out, preferably with a real-time priority.

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
