Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7TIoaHI002541
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 14:50:36 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m7TIoS2N001227
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 14:50:28 -0400
Date: Fri, 29 Aug 2008 20:55:51 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
In-Reply-To: <200808292016.48647.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.0808292047560.3521@axis700.grange>
References: <Pine.LNX.4.64.0808201138070.7589@axis700.grange>
	<200808282058.26623.hverkuil@xs4all.nl>
	<Pine.LNX.4.64.0808292013120.3521@axis700.grange>
	<200808292016.48647.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v3] soc-camera: add API documentation
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

On Fri, 29 Aug 2008, Hans Verkuil wrote:

> On Friday 29 August 2008 20:16:31 Guennadi Liakhovetski wrote:
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> >
> > ---
> >
> > Ok, more comments addressed, thanks to all again, we might even get
> > it in for 2.6.27? It certainly will not cause any regressions:-)
> 
> Acked-by: Hans Verkuil <hverkuil@xs4all.nl>
> 
> And apologies for hijacking your post for me rant :-)

No problem at all. I am glad it served the purpose. It is clear we need an 
API for the SoC camera interface, or a USB dongle, or a PCI card on one 
side and a CMOS sensor, or a frame-grabber, or you-name-them on the other 
side. I might well imagine, that the current soc-camera API is not a final 
solution, i.e., it will not suit all these purposes, so, I am all for a 
better more generic interface. I only hope the transition will not be too 
painful... And I suspect, we will get a couple more soc-camera drivers by 
the time the new API gets implemented, so, I very much hope we will not 
have to largely re-write them all:-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
