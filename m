Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2BM4lNe007890
	for <video4linux-list@redhat.com>; Tue, 11 Mar 2008 18:04:47 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m2BM4FfV029228
	for <video4linux-list@redhat.com>; Tue, 11 Mar 2008 18:04:15 -0400
Date: Tue, 11 Mar 2008 23:04:12 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <Pine.LNX.4.64.0803091204060.3408@axis700.grange>
Message-ID: <Pine.LNX.4.64.0803112257260.9070@axis700.grange>
References: <47C40563.5000702@claranet.fr> <47D24404.9050708@claranet.fr>
	<Pine.LNX.4.64.0803081026230.3639@axis700.grange>
	<47D3A2AA.7040608@claranet.fr>
	<Pine.LNX.4.64.0803091204060.3408@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux <video4linux-list@redhat.com>
Subject: Re: kernel oops since changeset e3b8fb8cc214
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

Hi Mauro,

On Sun, 9 Mar 2008, Guennadi Liakhovetski wrote:

> caused by a race with the interrupt handler? Can the problem be, that 
> cx88/cx88-video.c::buffer_release() is called from multiple places: as 
> cx8800_video_qops.buf_release(), and from video_release(), which is the 
> release method in video_fops and radio_fops. In the Oops above it is 
> called from cx8800_video_qops.buf_release().
> 
> Hm, video_release calls buffer_release() first directly, then it calls 
> videobuf_stop -> __videobuf_streamoff -> videobuf_queue_cancel -> 
> q->ops->buf_release... Is it good?...

as you see, more and more people are getting problems with the cx88 driver 
after my patch. Is my above suspicion correct? I could not directly 
propose a fix for that, firstly, due to the lack of time, secondly, of the 
hardware, and thirdly, experience with this kind of drivers. I haven't 
found a separate record in MAINTAINERS for this driver. Could you or 
someone else have a look at these few functions? I definitely will not 
have time for this tomorrow, I might have some time in the next couple of 
days, but unfortunately I cannot promise anything.

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
