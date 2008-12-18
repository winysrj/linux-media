Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBINIriZ001338
	for <video4linux-list@redhat.com>; Thu, 18 Dec 2008 18:18:53 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBINIdMU008185
	for <video4linux-list@redhat.com>; Thu, 18 Dec 2008 18:18:39 -0500
Date: Thu, 18 Dec 2008 19:18:39 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Paul Mundt <lethal@linux-sh.org>
Message-ID: <20081218191839.78cb627d@caramujo.chehab.org>
In-Reply-To: <Pine.LNX.4.64.0812181730080.5510@axis700.grange>
References: <Pine.LNX.4.64.0812181613050.5510@axis700.grange>
	<20081218160841.GA13851@linux-sh.org>
	<Pine.LNX.4.64.0812181717320.5510@axis700.grange>
	<20081218162439.GA27151@linux-sh.org>
	<Pine.LNX.4.64.0812181730080.5510@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Magnus Damm <damm@igel.co.jp>, video4linux-list@redhat.com,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linux-sh@vger.kernel.org
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

Hi Paul,

> On Fri, 19 Dec 2008, Paul Mundt wrote:
> 
> > It should not cause extra work at all. The only time it may cause extra
> > work is if you are talking about splitting up the patch and pulling in
> > the v4l specific parts in to your v4l tree. My point is that this is
> > absolutely the wrong thing to do, since the changes are tied together for
> > a reason.

Not sure why, buy your replies didn't arrive at the ML. Anyway, from my side,
it is ok to tie the v4l and sh changes together and commit it via either sh or
v4l tree, provided that the patch won't break bisect.

Yet, it is nice if you can c/c us on such patches, in order to help to avoid
future merge conflicts (since, otherwise, development may be done using the
previous version). Otherwise, I'll backport the patch into the development tree
only after reaching Linus tree.

A side note: maybe the design of pxa_camera could be improved to avoid needing
to be touched as architecture changes. This is the only v4l driver that includes
asm/arch header files.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
