Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4G7TJk6028812
	for <video4linux-list@redhat.com>; Fri, 16 May 2008 03:29:20 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m4G7T60C025211
	for <video4linux-list@redhat.com>; Fri, 16 May 2008 03:29:06 -0400
Date: Fri, 16 May 2008 09:29:03 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: =?GB2312?B?t+v2zg==?= <fengxin215@gmail.com>
In-Reply-To: <998e4a820805160004v6cfd2dbbi2652c80a6d628371@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0805160926180.3714@axis700.grange>
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
	<998e4a820805160004v6cfd2dbbi2652c80a6d628371@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
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

On Fri, 16 May 2008, ·ëöÎ wrote:

> Sorry,there is some modification for last letter.
> Now I find that when I write Norflash, my grabber thread waits for the
> writer thread.But when I write Nandflash, my grabber thread continue
> processing video buffers and queuing new ones.In all case FIFO overrun
> will occur.

This is very weird. You mean your _algorithm_ depends on the path where 
you write your data?...

Please, if you want me to try to help you, reply to _all_ questions that I 
ask in my emails.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
