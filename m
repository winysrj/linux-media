Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2DN4tC4001088
	for <video4linux-list@redhat.com>; Thu, 13 Mar 2008 19:04:55 -0400
Received: from mail-in-14.arcor-online.net (mail-in-14.arcor-online.net
	[151.189.21.54])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2DN4LYH017595
	for <video4linux-list@redhat.com>; Thu, 13 Mar 2008 19:04:22 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <1205448483.6359.15.camel@pc08.localdom.local>
References: <47C40563.5000702@claranet.fr> <200803111839.01690.zzam@gentoo.org>
	<1205281560.5927.119.camel@pc08.localdom.local>
	<200803131655.46384.zzam@gentoo.org> <20080313145901.6e4247b6@gaivota>
	<1205448483.6359.15.camel@pc08.localdom.local>
Content-Type: text/plain; charset=utf-8
Date: Thu, 13 Mar 2008 23:56:27 +0100
Message-Id: <1205448987.6359.19.camel@pc08.localdom.local>
Mime-Version: 1.0
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

Am Donnerstag, den 13.03.2008, 23:48 +0100 schrieb hermann pitton:
> Hi,
> 
> Am Donnerstag, den 13.03.2008, 14:59 -0300 schrieb Mauro Carvalho
> Chehab:
> > On Thu, 13 Mar 2008 16:55:45 +0100
> > Matthias Schwarzott <zzam@gentoo.org> wrote:
> > 
> > > On Mittwoch, 12. März 2008, hermann pitton wrote:
> > > >
> > > > Hi Matthias,
> > > >
> > > > since I know you are active also on saa713x devices,
> > > > have you seen it there, on 32 or 64bit ?
> > > >
> > > I do work on a driver for avermedia A700 based on saa7134 chip.
> > > There I did not notice this oops on my 32bit system.
> > > 
> > > > It seems to be restricted to cx88 and risc memory there for now?
> > > 
> > > No idea about internals of cx88, sorry.
> > 
> > cx88 videobuf IRQ handling is a bit different. However, most of the code is equal.
> > 
> > Cheers,
> > Mauro
> 
> definitely I'm not enough into it to be of much help soon, especially
> not for cx88xx and to answer offhand if Guennadi has the bug already,
> starting obviously with errors in the irq handler there.
> 
> Thanks Matthias for your report, we seem to have the same. On my
> uniprocessor 32bit 2.6.25-rc5 stuff and saa7131e, running since lunch
> with DVB-T and analog video at once, all seems to be normal and still
> totally stable.

Sorry, more precise, head is

changeset:   7361:d1654ab5f056
tag:         tip
parent:      7345:26f5691b7548
parent:      7360:3fa8325a8359
user:        Mauro Carvalho Chehab <mchehab@infradead.org>
date:        Mon Mar 10 11:27:26 2008 -0300
summary:     merge: http://linuxtv.org/hg/~mkrufky/tuner

Hermann




--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
