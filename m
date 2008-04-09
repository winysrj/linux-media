Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m391Raue015007
	for <video4linux-list@redhat.com>; Tue, 8 Apr 2008 21:27:36 -0400
Received: from wr-out-0506.google.com (wr-out-0506.google.com [64.233.184.226])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m391RQ51021167
	for <video4linux-list@redhat.com>; Tue, 8 Apr 2008 21:27:26 -0400
Received: by wr-out-0506.google.com with SMTP id c57so1890453wra.9
	for <video4linux-list@redhat.com>; Tue, 08 Apr 2008 18:27:26 -0700 (PDT)
Message-ID: <998e4a820804081827j5379efdfw3a95dd1731e02e42@mail.gmail.com>
Date: Wed, 9 Apr 2008 09:27:25 +0800
From: "=?GB2312?B?t+v2zg==?=" <fengxin215@gmail.com>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
In-Reply-To: <Pine.LNX.4.64.0804090104190.4987@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <998e4a820804040811l748bd5b7tedf7a50521ff449e@mail.gmail.com>
	<Pine.LNX.4.64.0804042027140.7761@axis700.grange>
	<998e4a820804070417w7cf71869h5f36c2ec18c8584c@mail.gmail.com>
	<Pine.LNX.4.64.0804071322490.5585@axis700.grange>
	<998e4a820804071849s60e883f9ne2d8ad6a2f48bd42@mail.gmail.com>
	<Pine.LNX.4.64.0804090104190.4987@axis700.grange>
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

2008/4/9 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:

>  Ok, that helped to understand and reproduce your problem, thanks! One
>  reason is buffer overruns. The sample application you are using is not
>  very smart, it is using only one thread, and with your modifications it
>  writes a new file to the filesystem after retrieving each frame, which, of
>  course, is not very easy for the PXA to handle. The data corruption I see
>  here is, that the first few frames are practically unusable. For example,
>  the first frame consists only of gray stripes, but soetimes it is correct
>  too. Then there may be a couple of frames are of just one gray intensity,
>  e.g., black, and then follow frames with wrongly positioned start of
>  frame. So that the frame typically consists of four sectors.
>
>  MPlayer, for example, avoids overruns by using a separate thread for just
>  data acquisition, haven't checked, maybe it is even scheduled with a
>  real-time priority.
>
>  I added some FIFO overrun handling to the driver, now I seem to be able to
>  re-synchronise, so that after the first corrupt frames the rest now are
>  properly aligned.
>
>  Further, I had a frame sequence problem: I was getting frames like 1, 3,
>  2, 5, 4, 7, 6, etc. No idea where this comes from. But limiting the number
>  of buffers to 2 (like in mplayer) in the test app, "solved" this problem
>  too. I'll clean up my resync patch tomorrow and will ask you to test it.
>
>  Thanks
>  Guennadi
>  ---
>  Guennadi Liakhovetski
>

Thank you very much.I will wait for your patch and test it.

Thanks
fengxin

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
