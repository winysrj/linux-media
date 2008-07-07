Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m67KmYJJ032412
	for <video4linux-list@redhat.com>; Mon, 7 Jul 2008 16:48:34 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m67KmHpP008836
	for <video4linux-list@redhat.com>; Mon, 7 Jul 2008 16:48:18 -0400
Date: Mon, 7 Jul 2008 17:47:59 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <20080707174759.39fc29aa@gaivota>
In-Reply-To: <200807072217.51487.hverkuil@xs4all.nl>
References: <200807072141.03344.hverkuil@xs4all.nl>
	<20080707220641.65f7bc08@hyperion.delvare>
	<20080707171444.10f0e7a5@gaivota>
	<200807072217.51487.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Jean Delvare <khali@linux-fr.org>, v4l <video4linux-list@redhat.com>,
	michael@mihu.de
Subject: Re: Proposed removal of the dpc7146 driver
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

On Mon, 7 Jul 2008 22:17:51 +0200
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> On Monday 07 July 2008 22:14:44 Mauro Carvalho Chehab wrote:
> > On Mon, 7 Jul 2008 22:06:41 +0200
> >
> > Jean Delvare <khali@linux-fr.org> wrote:
> > > On Mon, 7 Jul 2008 21:41:03 +0200, Hans Verkuil wrote:
> > > > Hi all,
> > > >
> > > > If no one objects, then I propose to remove this driver in kernel
> > > > 2.6.28 and announce its removal by adding the following notice to
> > > > the 2.6.27 feature-removal-schedule.txt document:
> > > >
> > > > What:   V4L2 dpc7146 driver
> > > > When:   September 2008
> > > > Why:    Old driver for the dpc7146 demonstration board that is no
> > > > longer relevant. The last time this was tested on actual hardware
> > > > was probably around 2002. Since this is a driver for a
> > > > demonstration board the decision was made to remove it rather
> > > > than spending a lot of effort continually updating this driver to
> > > > stay in sync with the latest internal V4L2 or I2C API.
> > > > Who:    Hans Verkuil <hverkuil@xs4all.nl>
> > > >
> > > >
> > > > Michael Hunold, the author of this driver, agrees with my
> > > > assessment that this driver is no longer relevant.
> > >
> > > +1
> > >
> > > (Less i2c-related drivers means less work for me.)
> >
> > Seems ok also to me.
> >
> >
> > Cheers,
> > Mauro
> 
> Hi Mauro,
> 
> Great. Can you take care of adding this notice to the feature removal 
> document? Perhaps it is a good idea to add it to the 2.6.26 kernel 
> before it is released.

Please send me the patches. I'll add it on my last queue for 2.6.26.
> 
> When the 2.6.27 window closes I'll prepare a patch to actually remove it 
> from the v4l-dvb repository.
> 
> Regards,
> 
> 	Hans




Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
