Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m51AGAbP006171
	for <video4linux-list@redhat.com>; Sun, 1 Jun 2008 06:16:10 -0400
Received: from smtp-vbr5.xs4all.nl (smtp-vbr5.xs4all.nl [194.109.24.25])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m51AFwQD008037
	for <video4linux-list@redhat.com>; Sun, 1 Jun 2008 06:15:58 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andy Walls <awalls@radix.net>
Date: Sun, 1 Jun 2008 12:15:11 +0200
References: <20080522223700.2f103a14@core>
	<200805261846.35758.hverkuil@xs4all.nl>
	<1212287646.20064.21.camel@palomino.walls.org>
In-Reply-To: <1212287646.20064.21.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806011215.11489.hverkuil@xs4all.nl>
Cc: video4linux-list@redhat.com, ivtv-devel@ivtvdriver.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] cx18: convert driver to video_ioctl2() (Re: [PATCH]
	video4linux: Push down the BKL)
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

On Sunday 01 June 2008 04:34, Andy Walls wrote:
> On Mon, 2008-05-26 at 18:46 +0200, Hans Verkuil wrote:
> > On Monday 26 May 2008 18:34:57 Mauro Carvalho Chehab wrote:
> > > In the specific case of ivtv and cx18, I think that the better
> > > would be to convert it first to video_ioctl2. Then, remove the
> > > BKL, with a video_ioctl2_unlocked version.
> > >
> > > Douglas already did an experimental patch converting ivtv to
> > > video_ioctl2 and sent to Hans. It needs testing, since he doesn't
> > > have any ivtv board. It should be trivial to port this to cx18,
> > > since both drivers have similar structures.
> > >
> > > Douglas,
> > >
> > > Could you send this patch to the ML for people to review and for
> > > Andy to port it to cx18?
> >
> > Unless there is an objection, I would prefer to take Douglas' patch
> > and merge it into the v4l-dvb ivtv driver myself. There were
> > several things in the patch I didn't like, but I need to 'work'
> > with it a bit to see how/if it can be done better.
> >
> > I can work on it tonight and tomorrow. Hopefully it is finished by
> > then. I can move the BKL down at the same time for ivtv. It is
> > unlikely that I will have time to do cx18 as well as I'm abroad
> > from Wednesday until Monday, but I think Andy can do that easily
> > based on the ivtv changes.
>
> I have attached a patch, made against Hans' v4l-dvb-ioctl2
> repository, to convert the cx18 driver to use video_ioctl2().  In the
> process I pushed down the priority checks and the debug messages into
> the individual functions.  I did not remove the serialization lock as
> I have not had the time to assess if that would be safe.  I "#if
> 0"'ed out some sliced VBI code that was being skipped in the original
> code.
>
> Comments are welcome.
>
> Many thanks to Hans, for without his changeset to ivtv for reference,
> this would have taken me much, much longer.
>
>
> Short term initial tests of this patch with MythTV, v4l-ctl, and
> v4l-dbg indicate things are OK.  I did notice once strange artifact
> with MythTV. When switching from one analog channel to another, for
> about a second, I see the two television video fields non-interlaced,
> stacked one atop of the other in the frame.  Weird, but not a big
> deal.

Thanks Andy!

I'll take a closer look on Tuesday or Wednesday, but I noticed one 
thing: you set unused callbacks to NULL in cx18_set_funcs(), however 
these can just be removed as they are NULL by default.

Regards,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
