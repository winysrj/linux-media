Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2DI0T5J003671
	for <video4linux-list@redhat.com>; Thu, 13 Mar 2008 14:00:29 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2DHxbjP027447
	for <video4linux-list@redhat.com>; Thu, 13 Mar 2008 13:59:38 -0400
Date: Thu, 13 Mar 2008 14:59:01 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Matthias Schwarzott <zzam@gentoo.org>
Message-ID: <20080313145901.6e4247b6@gaivota>
In-Reply-To: <200803131655.46384.zzam@gentoo.org>
References: <47C40563.5000702@claranet.fr> <200803111839.01690.zzam@gentoo.org>
	<1205281560.5927.119.camel@pc08.localdom.local>
	<200803131655.46384.zzam@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com, g.liakhovetski@pengutronix.de,
	Brandon Philips <bphilips@suse.de>
Subject: Re: kernel oops since changeset e3b8fb8cc214
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

On Thu, 13 Mar 2008 16:55:45 +0100
Matthias Schwarzott <zzam@gentoo.org> wrote:

> On Mittwoch, 12. März 2008, hermann pitton wrote:
> >
> > Hi Matthias,
> >
> > since I know you are active also on saa713x devices,
> > have you seen it there, on 32 or 64bit ?
> >
> I do work on a driver for avermedia A700 based on saa7134 chip.
> There I did not notice this oops on my 32bit system.
> 
> > It seems to be restricted to cx88 and risc memory there for now?
> 
> No idea about internals of cx88, sorry.

cx88 videobuf IRQ handling is a bit different. However, most of the code is equal.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
