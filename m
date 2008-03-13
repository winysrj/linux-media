Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2DG7eZk015171
	for <video4linux-list@redhat.com>; Thu, 13 Mar 2008 12:07:40 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m2DG71vj026132
	for <video4linux-list@redhat.com>; Thu, 13 Mar 2008 12:07:07 -0400
Date: Thu, 13 Mar 2008 17:07:08 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
To: hermann pitton <hermann-pitton@arcor.de>
In-Reply-To: <1205360935.5924.9.camel@pc08.localdom.local>
Message-ID: <Pine.LNX.4.64.0803131703580.4625@axis700.grange>
References: <47C40563.5000702@claranet.fr> <47D24404.9050708@claranet.fr>
	<Pine.LNX.4.64.0803081026230.3639@axis700.grange>
	<47D3A2AA.7040608@claranet.fr>
	<Pine.LNX.4.64.0803091204060.3408@axis700.grange>
	<Pine.LNX.4.64.0803112257260.9070@axis700.grange>
	<1205281392.5927.117.camel@pc08.localdom.local>
	<Pine.LNX.4.64.0803120831380.3804@axis700.grange>
	<1205360935.5924.9.camel@pc08.localdom.local>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux <video4linux-list@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
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

On Wed, 12 Mar 2008, hermann pitton wrote:

> Hi Guennadi,
> 
> Am Mittwoch, den 12.03.2008, 08:34 +0100 schrieb Guennadi Liakhovetski:
> > Hi Hermann,
> > 
> > On Wed, 12 Mar 2008, hermann pitton wrote:
> > 
> > > you are definitely going into the right direction, as it was meant
> > > already years back and also like Mauro did pick it up.
> > 
> > You mean this has already been discussed before? Have you got links to 
> > ML-archive threads?
> 
> it came up over the time that video-buf can be utilized for more then
> only bttv and saa7134. It changed somehow from Gerd's early comment here

Oh, no, sorry. I thought you meant, that the bug I am suspecting in the 
cx88-video.c has already been discussed. Here's again a quote from my 
earlier mail:

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

Am I right and it is a bug, or is it not?

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
