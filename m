Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBINUIcq006804
	for <video4linux-list@redhat.com>; Thu, 18 Dec 2008 18:30:18 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mBINU3Pe012608
	for <video4linux-list@redhat.com>; Thu, 18 Dec 2008 18:30:04 -0500
Date: Fri, 19 Dec 2008 00:30:05 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <20081218191839.78cb627d@caramujo.chehab.org>
Message-ID: <Pine.LNX.4.64.0812190026180.8046@axis700.grange>
References: <Pine.LNX.4.64.0812181613050.5510@axis700.grange>
	<20081218160841.GA13851@linux-sh.org>
	<Pine.LNX.4.64.0812181717320.5510@axis700.grange>
	<20081218162439.GA27151@linux-sh.org>
	<Pine.LNX.4.64.0812181730080.5510@axis700.grange>
	<20081218191839.78cb627d@caramujo.chehab.org>
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

> Hi Paul,
> 
> > On Fri, 19 Dec 2008, Paul Mundt wrote:
> > 
> > > It should not cause extra work at all. The only time it may cause extra
> > > work is if you are talking about splitting up the patch and pulling in
> > > the v4l specific parts in to your v4l tree. My point is that this is
> > > absolutely the wrong thing to do, since the changes are tied together for
> > > a reason.
> 
> Not sure why, buy your replies didn't arrive at the ML. Anyway, from my side,
> it is ok to tie the v4l and sh changes together and commit it via either sh or
> v4l tree, provided that the patch won't break bisect.
> 
> Yet, it is nice if you can c/c us on such patches, in order to help to avoid
> future merge conflicts (since, otherwise, development may be done using the
> previous version). Otherwise, I'll backport the patch into the development tree
> only after reaching Linus tree.
> 
> A side note: maybe the design of pxa_camera could be improved to avoid needing
> to be touched as architecture changes. This is the only v4l driver that includes
> asm/arch header files.

The patch in question was for sh_mobile_ceu_camera.c - not for pxa, and 
even though that one doesn't include any asm headers, as you see, it is 
also tied pretty closely with respective platform code.

As for including asm headers in pxa_camera.c - it wouldn't be easy to get 
rid of them, one of the main obstacles is the use of the pxa-specific 
dma-channel handling API.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
