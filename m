Return-path: <video4linux-list-bounces@redhat.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Mon, 26 May 2008 18:46:35 +0200
References: <20080522223700.2f103a14@core>
	<20080523090919.GA31575@devserv.devel.redhat.com>
	<20080526133457.6f892af9@gaivota>
In-Reply-To: <20080526133457.6f892af9@gaivota>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805261846.35758.hverkuil@xs4all.nl>
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
	Alan Cox <alan@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
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

On Monday 26 May 2008 18:34:57 Mauro Carvalho Chehab wrote:
> On Fri, 23 May 2008 05:09:19 -0400
>
> Alan Cox <alan@redhat.com> wrote:
> > On Thu, May 22, 2008 at 10:08:04PM -0400, Andy Walls wrote:
> > > Could someone give me a brief education as to what elements of
> > > cx18/ivtv_v4l2_do_ioctl() would be forcing the use of the BKL for
> > > these drivers' ioctls?   I'm assuming it's not the
> > > mutex_un/lock(&....->serialize_lock) and that the answer's not in
> > > the diff.
> >
> > As it stood previous for historical reasons the kernel called the
> > driver ioctl method already holding the big kernel lock. That lock
> > effectively serialized a lot of ioctl processing and also
> > serializes against module loading and registration/open for the
> > most part. If all the resources you are working on within the ioctl
> > handler are driver owned as is likely with a video capture driver,
> > and you have sufficient locking of your own you can drop the lock.
> >
> > video_usercopy currently also uses the BKL so you might want to
> > copy a version to video_usercopy_unlocked() without that.
>
> In the specific case of ivtv and cx18, I think that the better would
> be to convert it first to video_ioctl2. Then, remove the BKL, with a
> video_ioctl2_unlocked version.
>
> Douglas already did an experimental patch converting ivtv to
> video_ioctl2 and sent to Hans. It needs testing, since he doesn't
> have any ivtv board. It should be trivial to port this to cx18, since
> both drivers have similar structures.
>
> Douglas,
>
> Could you send this patch to the ML for people to review and for Andy
> to port it to cx18?

Unless there is an objection, I would prefer to take Douglas' patch and 
merge it into the v4l-dvb ivtv driver myself. There were several things 
in the patch I didn't like, but I need to 'work' with it a bit to see 
how/if it can be done better.

I can work on it tonight and tomorrow. Hopefully it is finished by then. 
I can move the BKL down at the same time for ivtv. It is unlikely that 
I will have time to do cx18 as well as I'm abroad from Wednesday until 
Monday, but I think Andy can do that easily based on the ivtv changes.

Regards,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
