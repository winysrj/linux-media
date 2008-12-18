Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBIH9ElH012046
	for <video4linux-list@redhat.com>; Thu, 18 Dec 2008 12:09:14 -0500
Received: from smtp-vbr7.xs4all.nl (smtp-vbr7.xs4all.nl [194.109.24.27])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBIH90R2008039
	for <video4linux-list@redhat.com>; Thu, 18 Dec 2008 12:09:00 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: video4linux-list@redhat.com
Date: Thu, 18 Dec 2008 18:08:57 +0100
References: <20080711231113.13054808@hyperion.delvare>
	<20081014113031.739068f8@hyperion.delvare>
	<1224800838.4202.20.camel@pc10.localdom.local>
In-Reply-To: <1224800838.4202.20.camel@pc10.localdom.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812181808.57543.hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [v4l-dvb-maintainer] bt832 driver
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

On Friday 24 October 2008 00:27:18 hermann pitton wrote:
> Hi,
>
> Am Dienstag, den 14.10.2008, 11:30 +0200 schrieb Jean Delvare:
> > Hi Mauro,
> >
> > On Wed, 30 Jul 2008 10:49:55 -0300, Mauro Carvalho Chehab wrote:
> > > > I know there is nothing meant personal and the technical arguments
> > > > seem to be all correct.
> > > >
> > > > Just, if we have some last known email address, we try to inform
> > > > the author, reachable or not, directly too.
> > > >
> > > > This happened now and I think you can proceed.
> > > >
> > > > An answer from Gunther, who is not around on the lists since a
> > > > while, would of course be even better.
> > > >
> > > > I also would like to send him documentation about some new cards,
> > > > but also don't know if mails really come through currently.
> > >
> > > Ok. Let's wait some days to give him a chance to read this and send
> > > us an answer. It seems better to wait until the end of the next week,
> > > since we might be in vacations during July.
> >
> > It has been a long time now and apparently nobody cares about the
> > broken bt832 driver, so I think it's time to delete it?
> >
> > Thanks,
>
> Mauro, Jean, please proceed as announced.

While bt832 is no longer compiled the source is still around. Can I remove 
it completely? I personally hate dead sources like this, if you ever need 
it again you can get it from the repository, that's why we have a 
repository in the first place. I was already converting it to v4l2_subdev 
before I realized that it is no longer used :-(

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
