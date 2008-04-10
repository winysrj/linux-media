Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3A5geaf000615
	for <video4linux-list@redhat.com>; Thu, 10 Apr 2008 01:42:40 -0400
Received: from py-out-1112.google.com (py-out-1112.google.com [64.233.166.180])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3A5gPQN025742
	for <video4linux-list@redhat.com>; Thu, 10 Apr 2008 01:42:25 -0400
Received: by py-out-1112.google.com with SMTP id a29so3120587pyi.0
	for <video4linux-list@redhat.com>; Wed, 09 Apr 2008 22:42:25 -0700 (PDT)
Message-ID: <998e4a820804092242i8ead476nf7e4db3712bc881@mail.gmail.com>
Date: Thu, 10 Apr 2008 13:42:24 +0800
From: "=?GB2312?B?t+v2zg==?=" <fengxin215@gmail.com>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
In-Reply-To: <Pine.LNX.4.64.0804091616470.5671@axis700.grange>
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
	<998e4a820804081827j5379efdfw3a95dd1731e02e42@mail.gmail.com>
	<Pine.LNX.4.64.0804091616470.5671@axis700.grange>
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

2008/4/9 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:.

>  Please test the patch below. It should apply on the top of v4l-dvb plus,
>  if this patch is yet not there, the patch from
>  http://marc.info/?l=linux-video&m=120771921814753&w=2
>
>  Please test with your test application, see if the frame origin iw now
>  correct, and if you too get the partially inverted frame sequence, i.e.,
>  like 1, 3, 2, 5, 4,... If yes, try reducing the number of buffers to 2 and
>  see if this problem disappears then.

Thanks,I test it already. if I request 4 buffers,wrong frames will
appear sometimes and get the partially inverted frame sequence too.If
I request 2 buffers,there is not wrong frames.But some frames will be
lost,like 1,2,3,4,7,8,9,10,14,...

Thanks
fengxin

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
