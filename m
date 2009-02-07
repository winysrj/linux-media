Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n172ke5n022962
	for <video4linux-list@redhat.com>; Fri, 6 Feb 2009 21:46:47 -0500
Received: from mail-in-06.arcor-online.net (mail-in-06.arcor-online.net
	[151.189.21.46])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n172Nlpp008443
	for <video4linux-list@redhat.com>; Fri, 6 Feb 2009 21:23:55 -0500
From: hermann pitton <hermann-pitton@arcor.de>
To: Dmitri Belimov <d.belimov@gmail.com>
In-Reply-To: <20090207104354.55581cdf@glory.loctelecom.ru>
References: <163227.41578.qm@web35306.mail.mud.yahoo.com>
	<498CDCD9.1010305@eng.wayne.edu>
	<20090207104354.55581cdf@glory.loctelecom.ru>
Content-Type: text/plain
Date: Sat, 07 Feb 2009 03:24:27 +0100
Message-Id: <1233973467.3933.10.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Philips saa6752hs mpeg encoder recommendation
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

Hi,

Am Samstag, den 07.02.2009, 10:43 +0900 schrieb Dmitri Belimov:
> Hi Brian
> 
> > Hello all,
> > 
> > I'd like to do some mpeg encoder testing on linux with the Philips
> > saa6752hs mpeg encoder but I'm having a difficult time finding
> > PCI cards that use the chip.
> > 
> > If anyone has any recommendations on cards that make use of
> > the Philips saa6752hs chip and associated linux driver, I'd really
> > appreciate the info. Especially cards that are still available new
> > or readily available used.
> 
> Our TV tuners has hardware MPEG encoder saa6752hs:
> BeholdTV M6
> BeholdTV M63
> BeholdTV M6 Extra

I was just about to point to you.

> We made support this cards in Linux with Hans Verkuil (big thanks). 
> See saa7134-empress.c and saa6752hs.c source code (in media/video/saa7134 folder).
> 
> And bad news. You can't buy our card outside of Russia.

Hmm, assuming you have still some amount of chips, why you don't try to
sell global like all others do after all the work you had to get the
mess sorted?

Given that nvidia and others have GPU hardware acceleration for HDTV
more or less ready, even with GNU/Linux on current cheap supermarket
PCs, what to wait for?

The remaining market is _now_ and not in any future. 

> With my best regards, Dmitry.

Best as well, get them out.

Cheers,
Hermann


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
