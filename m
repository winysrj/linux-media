Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4G74mFD015547
	for <video4linux-list@redhat.com>; Fri, 16 May 2008 03:04:48 -0400
Received: from ti-out-0910.google.com (ti-out-0910.google.com [209.85.142.185])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4G74Elv012268
	for <video4linux-list@redhat.com>; Fri, 16 May 2008 03:04:18 -0400
Received: by ti-out-0910.google.com with SMTP id 24so394548tim.7
	for <video4linux-list@redhat.com>; Fri, 16 May 2008 00:04:13 -0700 (PDT)
Message-ID: <998e4a820805160004v6cfd2dbbi2652c80a6d628371@mail.gmail.com>
Date: Fri, 16 May 2008 15:04:12 +0800
From: "=?GB2312?B?t+v2zg==?=" <fengxin215@gmail.com>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
In-Reply-To: <Pine.LNX.4.64.0805151432110.14292@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <998e4a820804040811l748bd5b7tedf7a50521ff449e@mail.gmail.com>
	<Pine.LNX.4.64.0804171824130.6716@axis700.grange>
	<998e4a820804172245i473cd822yf09c5cdb799e9cd5@mail.gmail.com>
	<Pine.LNX.4.64.0804181621560.5725@axis700.grange>
	<998e4a820804190643o1956fb6dxa90748fc6b6a8cbd@mail.gmail.com>
	<Pine.LNX.4.64.0804221618510.8132@axis700.grange>
	<998e4a820805150152p51f8f9fek5462aee7a6d3ba06@mail.gmail.com>
	<Pine.LNX.4.64.0805151105290.14292@axis700.grange>
	<998e4a820805150523v4af2a62am8f9b169bd4c368d@mail.gmail.com>
	<Pine.LNX.4.64.0805151432110.14292@axis700.grange>
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

Sorry,there is some modification for last letter.
Now I find that when I write Norflash, my grabber thread waits for the
writer thread.But when I write Nandflash, my grabber thread continue
processing video buffers and queuing new ones.In all case FIFO overrun
will occur.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
