Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m37BOYVn009397
	for <video4linux-list@redhat.com>; Mon, 7 Apr 2008 07:24:34 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m37BONXY009565
	for <video4linux-list@redhat.com>; Mon, 7 Apr 2008 07:24:23 -0400
Date: Mon, 7 Apr 2008 13:24:30 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: =?GB2312?B?t+v2zg==?= <fengxin215@gmail.com>
In-Reply-To: <998e4a820804070417w7cf71869h5f36c2ec18c8584c@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0804071322490.5585@axis700.grange>
References: <998e4a820804040811l748bd5b7tedf7a50521ff449e@mail.gmail.com>
	<Pine.LNX.4.64.0804042027140.7761@axis700.grange>
	<998e4a820804070417w7cf71869h5f36c2ec18c8584c@mail.gmail.com>
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

On Mon, 7 Apr 2008, ·ëöÎ wrote:

> Hi
> My camera is mt9v022.It is Master parallel,Monochrome and 8bit data
> bus width.I do not send output to X server and to framebuffer.
> If i request 4 buffers,I can get the first frame.But the sencond frame
> and the third frame is black.Others is wrong.
> If i request 5 buffers,I can get the first frame.But the sencond
> frame, the third frame and the forth frame is black.Others is
> wrong,and so on.

Ok, then I'll have to request the source code of your application to test 
it here.

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
