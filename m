Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2EEGJ34010933
	for <video4linux-list@redhat.com>; Fri, 14 Mar 2008 10:16:19 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m2EEFlGL001839
	for <video4linux-list@redhat.com>; Fri, 14 Mar 2008 10:15:47 -0400
Date: Fri, 14 Mar 2008 11:15:06 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: hermann pitton <hermann-pitton@arcor.de>
Message-ID: <20080314111506.0c4cab80@gaivota>
In-Reply-To: <1205448483.6359.15.camel@pc08.localdom.local>
References: <47C40563.5000702@claranet.fr> <200803111839.01690.zzam@gentoo.org>
	<1205281560.5927.119.camel@pc08.localdom.local>
	<200803131655.46384.zzam@gentoo.org>
	<20080313145901.6e4247b6@gaivota>
	<1205448483.6359.15.camel@pc08.localdom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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

On Thu, 13 Mar 2008 23:48:03 +0100
hermann pitton <hermann-pitton@arcor.de> wrote:

> definitely I'm not enough into it to be of much help soon, especially
> not for cx88xx and to answer offhand if Guennadi has the bug already,
> starting obviously with errors in the irq handler there.
> 
> Thanks Matthias for your report, we seem to have the same. On my
> uniprocessor 32bit 2.6.25-rc5 stuff and saa7131e, running since lunch
> with DVB-T and analog video at once, all seems to be normal and still
> totally stable.

I did yesterday a quick test on an AMD dual core machine, with a Linux 64 bits
distro. I didn't got any errors with Pixelview 8000GT (cx88+xc3028). Yet, the
tests are not conclusive, since I left the application running for some seconds
only (*). I did some start/stop procedures. I intend to run Brandon's pthread
version of capture-example during the weekend.

(*) Yet, generally, just a couple of seconds is enough to cause big troubles
when videobuf is suffering troubles.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
