Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2EEYETC024818
	for <video4linux-list@redhat.com>; Fri, 14 Mar 2008 10:34:14 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m2EEXe0V014254
	for <video4linux-list@redhat.com>; Fri, 14 Mar 2008 10:33:43 -0400
Date: Fri, 14 Mar 2008 15:33:49 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <20080314111506.0c4cab80@gaivota>
Message-ID: <Pine.LNX.4.64.0803141533110.5362@axis700.grange>
References: <47C40563.5000702@claranet.fr> <200803111839.01690.zzam@gentoo.org>
	<1205281560.5927.119.camel@pc08.localdom.local>
	<200803131655.46384.zzam@gentoo.org>
	<20080313145901.6e4247b6@gaivota>
	<1205448483.6359.15.camel@pc08.localdom.local>
	<20080314111506.0c4cab80@gaivota>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com, Brandon Philips <bphilips@suse.de>
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

On Fri, 14 Mar 2008, Mauro Carvalho Chehab wrote:

> On Thu, 13 Mar 2008 23:48:03 +0100
> hermann pitton <hermann-pitton@arcor.de> wrote:
> 
> > definitely I'm not enough into it to be of much help soon, especially
> > not for cx88xx and to answer offhand if Guennadi has the bug already,
> > starting obviously with errors in the irq handler there.
> > 
> > Thanks Matthias for your report, we seem to have the same. On my
> > uniprocessor 32bit 2.6.25-rc5 stuff and saa7131e, running since lunch
> > with DVB-T and analog video at once, all seems to be normal and still
> > totally stable.
> 
> I did yesterday a quick test on an AMD dual core machine, with a Linux 64 bits
> distro. I didn't got any errors with Pixelview 8000GT (cx88+xc3028). Yet, the
> tests are not conclusive, since I left the application running for some seconds
> only (*). I did some start/stop procedures. I intend to run Brandon's pthread
> version of capture-example during the weekend.

You don't need to any more. See my patch from 1 minute ago.

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
