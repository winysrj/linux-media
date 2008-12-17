Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBHB6bmN011108
	for <video4linux-list@redhat.com>; Wed, 17 Dec 2008 06:06:42 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mBHB3l2h007728
	for <video4linux-list@redhat.com>; Wed, 17 Dec 2008 06:03:47 -0500
Date: Wed, 17 Dec 2008 12:03:54 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <20081217084505.654dabd5@caramujo.chehab.org>
Message-ID: <Pine.LNX.4.64.0812171151050.5465@axis700.grange>
References: <uk5a0hna0.wl%morimoto.kuninori@renesas.com>
	<Pine.LNX.4.64.0812160904131.4630@axis700.grange>
	<uej08h569.wl%morimoto.kuninori@renesas.com>
	<Pine.LNX.4.64.0812161001000.4630@axis700.grange>
	<ud4fsh3h6.wl%morimoto.kuninori@renesas.com>
	<Pine.LNX.4.64.0812161051240.5450@axis700.grange>
	<20081217084505.654dabd5@caramujo.chehab.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: V4L-Linux <video4linux-list@redhat.com>
Subject: S_FMT error handling (was Re: [PATCH v3] Add tw9910 driver)
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

(discussed shortly on IRC with Hans yesterday, so, added to cc:)

On Wed, 17 Dec 2008, Mauro Carvalho Chehab wrote:

> On Tue, 16 Dec 2008 11:09:21 +0100 (CET)
> Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> 
> > so, here it is trying ANY... OTOH, the comment above says the driver 
> > shouldn't fail this call, and http://v4l2spec.bytesex.org/spec/r10944.htm 
> > confirms that. Which also means, that vivi.c does it wrongly. Mauro, you 
> > are listed as one of the authors of vivi.c, and it looks like calling 
> > S_FMT on it with field != ANY && field != INTERLACED will produce -EINVAL, 
> > which seems to contradict the API. What is the correct behavious? Is this 
> > a bug in vivi.c?
> 
> Yes, it is a bug at vivi. Could you please provide us a patch for it?

I looked at several other drivers, all I have seen act in S_FMT a bit more 
creatively than the API requires. Do we really want to fix them all? TBH, 
I like the implementations better than the standard: we do provide TRY_FMT 
exactly for this purpose - for applications to figure out what is 
supported. And if they still don't obey, returning an error seems like a 
sane thing to do to me. Besides, modifying all drivers that behave wrongly 
with this respect seems not quite trivial - you have to select some 
supported format possibly close to the requested one... May we not just 
interpret such requests as "ambiguous," following [1]?

I could probably make a reasonable patch for vivi.c, but I don't think I 
would be able to fix this misbehaviour in all drivers.

[1] http://v4l2spec.bytesex.org/spec/r10944.htm

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
