Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m37BHsnm006413
	for <video4linux-list@redhat.com>; Mon, 7 Apr 2008 07:17:54 -0400
Received: from rn-out-0910.google.com (rn-out-0910.google.com [64.233.170.186])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m37BHiwd006006
	for <video4linux-list@redhat.com>; Mon, 7 Apr 2008 07:17:44 -0400
Received: by rn-out-0910.google.com with SMTP id i50so10334381rne.11
	for <video4linux-list@redhat.com>; Mon, 07 Apr 2008 04:17:39 -0700 (PDT)
Message-ID: <998e4a820804070417w7cf71869h5f36c2ec18c8584c@mail.gmail.com>
Date: Mon, 7 Apr 2008 19:17:37 +0800
From: "=?GB2312?B?t+v2zg==?=" <fengxin215@gmail.com>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
In-Reply-To: <Pine.LNX.4.64.0804042027140.7761@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Disposition: inline
References: <998e4a820804040811l748bd5b7tedf7a50521ff449e@mail.gmail.com>
	<Pine.LNX.4.64.0804042027140.7761@axis700.grange>
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
My camera is mt9v022.It is Master parallel,Monochrome and 8bit data
bus width.I do not send output to X server and to framebuffer.
If i request 4 buffers,I can get the first frame.But the sencond frame
and the third frame is black.Others is wrong.
If i request 5 buffers,I can get the first frame.But the sencond
frame, the third frame and the forth frame is black.Others is
wrong,and so on.

2008/4/5 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
> Hi
>
>
>
>  On Fri, 4 Apr 2008, ¨i§¬§¨§ß wrote:
>
>  > Now soc-camera driver can work on my pxa270.I wrote a program to test
>  > the driver.Only the first frame is right,but others is wrong.The
>  > program that I wrote come from Video for Linux Two API
>  > Specification,and work well on other v4l2-driver.
>
>  With what camera are you using the driver? Is it one of mt9m001 / mt9v022
>  or another one? In what mode is it connected to the CPU? Master parallel?
>  Monochrome or colour? How many bits data bus width? Why are you writing
>  your own programme and not using an existing one like xawtv, mplayer or
>  gstreamer? It would be much easier to diagnose our problem if you took
>  mplayer and provided the exact command line and output.
>
>  How wrong are the frames? If they are shifted, you might have a problem
>  with buffer size calculation somewhere. If you get distorted images, you
>  might be getting FIFO overflows. Are you sending output over some library,
>  to the X server, or directly to the framebuffer?
>
>  See, you need to provide much more information so we could help you.
>
>  Thanks
>  Guennadi
>  ---
>  Guennadi Liakhovetski
>



-- 
ÖÂ
Àñ
·ëöÎ

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
