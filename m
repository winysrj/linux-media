Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m38NLIRm001250
	for <video4linux-list@redhat.com>; Tue, 8 Apr 2008 19:21:18 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m38NKoOl024114
	for <video4linux-list@redhat.com>; Tue, 8 Apr 2008 19:20:54 -0400
Date: Wed, 9 Apr 2008 01:20:50 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: =?GB2312?B?t+v2zg==?= <fengxin215@gmail.com>
In-Reply-To: <998e4a820804071849s60e883f9ne2d8ad6a2f48bd42@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0804090104190.4987@axis700.grange>
References: <998e4a820804040811l748bd5b7tedf7a50521ff449e@mail.gmail.com>
	<Pine.LNX.4.64.0804042027140.7761@axis700.grange>
	<998e4a820804070417w7cf71869h5f36c2ec18c8584c@mail.gmail.com>
	<Pine.LNX.4.64.0804071322490.5585@axis700.grange>
	<998e4a820804071849s60e883f9ne2d8ad6a2f48bd42@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=GB2312
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

On Tue, 8 Apr 2008, ·ëöÎ wrote:

> 2008/4/7 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
> >  Ok, then I'll have to request the source code of your application to test
> >  it here.
> 
> Thanks.My application come from
> http://linuxtv.org/hg/v4l-dvb/file/1abbd650fe07/v4l2-apps/test/capture_example.c.I
> modify a little.

Ok, that helped to understand and reproduce your problem, thanks! One 
reason is buffer overruns. The sample application you are using is not 
very smart, it is using only one thread, and with your modifications it 
writes a new file to the filesystem after retrieving each frame, which, of 
course, is not very easy for the PXA to handle. The data corruption I see 
here is, that the first few frames are practically unusable. For example, 
the first frame consists only of gray stripes, but soetimes it is correct 
too. Then there may be a couple of frames are of just one gray intensity, 
e.g., black, and then follow frames with wrongly positioned start of 
frame. So that the frame typically consists of four sectors.

MPlayer, for example, avoids overruns by using a separate thread for just 
data acquisition, haven't checked, maybe it is even scheduled with a 
real-time priority.

I added some FIFO overrun handling to the driver, now I seem to be able to 
re-synchronise, so that after the first corrupt frames the rest now are 
properly aligned.

Further, I had a frame sequence problem: I was getting frames like 1, 3, 
2, 5, 4, 7, 6, etc. No idea where this comes from. But limiting the number 
of buffers to 2 (like in mplayer) in the test app, "solved" this problem 
too. I'll clean up my resync patch tomorrow and will ask you to test it.

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
