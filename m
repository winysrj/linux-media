Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBJ7FUYC019810
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 02:15:30 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mBJ7FGZu029593
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 02:15:16 -0500
Date: Fri, 19 Dec 2008 08:15:19 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <20081218205706.60bf1526@caramujo.chehab.org>
Message-ID: <Pine.LNX.4.64.0812190808390.3922@axis700.grange>
References: <Pine.LNX.4.64.0812181613050.5510@axis700.grange>
	<20081218160841.GA13851@linux-sh.org>
	<Pine.LNX.4.64.0812181717320.5510@axis700.grange>
	<20081218162439.GA27151@linux-sh.org>
	<Pine.LNX.4.64.0812181730080.5510@axis700.grange>
	<20081218191839.78cb627d@caramujo.chehab.org>
	<Pine.LNX.4.64.0812190026180.8046@axis700.grange>
	<20081218205706.60bf1526@caramujo.chehab.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Magnus Damm <damm@igel.co.jp>, video4linux-list@redhat.com,
	Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org
Subject: Re: A patch got applied to v4l bypassing v4l lists
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

On Thu, 18 Dec 2008, Mauro Carvalho Chehab wrote:

> On Fri, 19 Dec 2008 00:30:05 +0100 (CET)
> Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> 
> > > A side note: maybe the design of pxa_camera could be improved to avoid needing
> > > to be touched as architecture changes. This is the only v4l driver that includes
> > > asm/arch header files.
> > 
> > The patch in question was for sh_mobile_ceu_camera.c - not for pxa, and 
> > even though that one doesn't include any asm headers, as you see, it is 
> > also tied pretty closely with respective platform code.
> 
> > As for including asm headers in pxa_camera.c - it wouldn't be easy to get 
> > rid of them, one of the main obstacles is the use of the pxa-specific 
> > dma-channel handling API.
> 
> Ok. I dunno the specific details of the sh and pxa bindings, but it would be
> better to have it more independent from architecture specific implementation
> details.

...that's what I'm saying - we have to work with the complete kernel tree. 
Working with a part of it is no fun. Just think about one thing - changing 
platform data struct layout. It will still compile as long as you preserve 
the name, because that's just a void * you get from platform, but you 
better don't try to run that... Or take this clock change now to the 
sh_mobile_ceu_camera.c. It will still compile with older kernels, but it 
won't run.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
