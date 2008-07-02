Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m62Bp6NG003995
	for <video4linux-list@redhat.com>; Wed, 2 Jul 2008 07:51:07 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m62BotGL008495
	for <video4linux-list@redhat.com>; Wed, 2 Jul 2008 07:50:55 -0400
Date: Wed, 2 Jul 2008 08:50:44 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Laurent Pinchart <laurent.pinchart@skynet.be>
Message-ID: <20080702085044.7c740bf8@gaivota>
In-Reply-To: <200807021230.12171.laurent.pinchart@skynet.be>
References: <14440.62.70.2.252.1214993763.squirrel@webmail.xs4all.nl>
	<200807021230.12171.laurent.pinchart@skynet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: v4l <video4linux-list@redhat.com>
Subject: Re: uvc_driver.c compile error on 2.6.18
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

On Wed, 2 Jul 2008 12:30:11 +0200
Laurent Pinchart <laurent.pinchart@skynet.be> wrote:

> > > Mauro committed the uvcvideo driver to the v4l-dvb tree two days ago. The
> > > patch he based his commit on was intended for submission to the main Linux
> > > tree, and as such didn't contain any support for older kernels.

To help testing, I always keep all stuff at my -git, under /drivers/media
replicated at v4l-dvb.

> > > Fixing the driver in the hg tree to build with 2.6.18 would be duplicating
> > > work. As I explained in a mail to Mauro, I don't want to drop the SVN
> > > repository before the driver hits the main kernel tree, as it would
> > > confuse users.

It is up to you to keep your own tree. It is generally easier if you have a
mercurial copy of v4l-dvb, since all you need to do to send us new patches is
to ask me to pull from your tree.

If you prefer to migrate to Mercurial, we may host it at Linuxtv if you want.

> > > What would be the best way to solve this issue ?
> > 
> > I think the easiest short term solution is to figure out what the first
> > kernel is that allows uvcvideo to build and then adjust v4l/versions.txt
> > accordingly.
> 
> If compiled in the v4l-dvb tree, the driver requires 2.6.22. Otherwise it will need 2.6.26, as it depends on the latest V4L2 API enhancements.

Ok, I've added 2.6.22 to versions.txt.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
