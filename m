Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4N6TFuS013002
	for <video4linux-list@redhat.com>; Fri, 23 May 2008 02:29:15 -0400
Received: from smtp-vbr9.xs4all.nl (smtp-vbr9.xs4all.nl [194.109.24.29])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4N6T3AM020501
	for <video4linux-list@redhat.com>; Fri, 23 May 2008 02:29:04 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: video4linux-list@redhat.com
Date: Fri, 23 May 2008 08:28:49 +0200
References: <20080522223700.2f103a14@core>
	<1211508484.3273.86.camel@palomino.walls.org>
	<200805230816.05229.hverkuil@xs4all.nl>
In-Reply-To: <200805230816.05229.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805230828.49525.hverkuil@xs4all.nl>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
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

On Friday 23 May 2008 08:16:05 Hans Verkuil wrote:
> On Friday 23 May 2008 04:08:04 Andy Walls wrote:
> > On Thu, 2008-05-22 at 22:37 +0100, Alan Cox wrote:
> > > For most drivers the generic ioctl handler does the work and we
> > > update it and it becomes the unlocked_ioctl method. Older drivers
> > > use the usercopy method so we make it do the work. Finally there
> > > are a few special cases.
> > >
> > > Signed-off-by: Alan Cox <alan@redhat.com>
> >
> > I'd like to start planning out the changes to eliminate the BKL
> > from cx18.
> >
> > Could someone give me a brief education as to what elements of
> > cx18/ivtv_v4l2_do_ioctl() would be forcing the use of the BKL for
> > these drivers' ioctls?   I'm assuming it's not the
> > mutex_un/lock(&....->serialize_lock) and that the answer's not in
> > the diff.
>
> To the best of my knowledge there is no need for a BKL in ivtv or
> cx18. It was just laziness on my part that I hadn't switched to
> unlocked_ioctl yet. If you know of a reason why it should be kept for
> now, then I'd like to know, otherwise the BKL can be removed
> altogether for ivtv/cx18. I suspect you just pushed the lock down
> into the driver and in that case you can just remove it for
> ivtv/cx18.

Hmm, of course you just pushed down the lock, the subject said so. 
Sorry, it's early morning here and I'm apparently not yet fully 
awake :-)

Regards,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
