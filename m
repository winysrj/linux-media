Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4QGdpt9025536
	for <video4linux-list@redhat.com>; Mon, 26 May 2008 12:39:51 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4QGdev5001147
	for <video4linux-list@redhat.com>; Mon, 26 May 2008 12:39:40 -0400
Date: Mon, 26 May 2008 13:39:22 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <20080526133922.4e75f633@gaivota>
In-Reply-To: <200805230816.05229.hverkuil@xs4all.nl>
References: <20080522223700.2f103a14@core>
	<1211508484.3273.86.camel@palomino.walls.org>
	<200805230816.05229.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
	Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] video4linux: Push down the BKL
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

On Fri, 23 May 2008 08:16:05 +0200
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> On Friday 23 May 2008 04:08:04 Andy Walls wrote:
> > On Thu, 2008-05-22 at 22:37 +0100, Alan Cox wrote:
> > > For most drivers the generic ioctl handler does the work and we
> > > update it and it becomes the unlocked_ioctl method. Older drivers
> > > use the usercopy method so we make it do the work. Finally there
> > > are a few special cases.
> > >
> > > Signed-off-by: Alan Cox <alan@redhat.com>
> >
> > I'd like to start planning out the changes to eliminate the BKL from
> > cx18.
> >
> > Could someone give me a brief education as to what elements of
> > cx18/ivtv_v4l2_do_ioctl() would be forcing the use of the BKL for
> > these drivers' ioctls?   I'm assuming it's not the
> > mutex_un/lock(&....->serialize_lock) and that the answer's not in the
> > diff.
> 
> To the best of my knowledge there is no need for a BKL in ivtv or cx18. 
> It was just laziness on my part that I hadn't switched to 
> unlocked_ioctl yet.

I suspect that this is true with almost all drivers. Yet, we may need to enable
BKL or add other locks on a few places. For example, the old tuner i2c probing
method relies on a global and unique static var to identify radio and tv
tuners. I can foresee a race condition there, if you have two boards probing
tuners at the same time.

Of course, we need to do several tests, since probably there are some issues
that we cannot foresee.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
