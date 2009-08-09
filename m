Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n798R9nq001743
	for <video4linux-list@redhat.com>; Sun, 9 Aug 2009 04:27:09 -0400
Received: from mail-in-09.arcor-online.net (mail-in-09.arcor-online.net
	[151.189.21.49])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n798QoHc003792
	for <video4linux-list@redhat.com>; Sun, 9 Aug 2009 04:26:51 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: "Michael A. Fallavollita, Ph.D." <mikef@microtech.com>
In-Reply-To: <4A7E5B1D.5060102@microtech.com>
References: <4A7E5B1D.5060102@microtech.com>
Content-Type: text/plain
Date: Sun, 09 Aug 2009 10:22:56 +0200
Message-Id: <1249806176.3300.29.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Support for Items ITV-301
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

Hi Michael,

Am Samstag, den 08.08.2009, 22:14 -0700 schrieb Michael A. Fallavollita,
Ph.D.:
> Hello to the list.
> 
> I bought a generic SAA7130 based card from ebay a while back.  After
> much research I have determined that it is an ITV-301.  I noticed in
> searching the archives of this list that a patch was posted by Andre
> Auzi a while back  but it doesn't appear that this card made it into the
> current source.  I was wondering if anyone has a current build of the 
> module that includes support for this device or perhaps can point me to 
> a supported card in the list that works.
> 
> Thanks.
> 
>     -- Mike
> 
> 

http://article.gmane.org/gmane.comp.video.video4linux/38064

how can you ever know, it is a ITV-301?

saa7133[0]: Huh, no eeprom present (err=-5)?

It can be anything with any tuner.

Likely this is why that patch never made it in.

The interesting lines are:

+                * saa7133[0]: board init: gpio is 4c04c00
+                * tuner' 2-0043: chip found @ 0x86 (saa7133[0])

Any such the same?

Have a look at saa7134-cards.c.

Anything with vmux = 3 and amux = LINE2 for TV and forced tuner=38
should work then for TV. Well, we have already a lot of duplicate code.

Cheers,
Hermann






--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
