Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m861NUVx003271
	for <video4linux-list@redhat.com>; Fri, 5 Sep 2008 21:23:30 -0400
Received: from mail-in-03.arcor-online.net (mail-in-03.arcor-online.net
	[151.189.21.43])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m861NG5f024942
	for <video4linux-list@redhat.com>; Fri, 5 Sep 2008 21:23:17 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: ian.davidson@bigfoot.com
In-Reply-To: <48C1874B.5080502@blueyonder.co.uk>
References: <488C9266.7010108@blueyonder.co.uk>
	<1217364178.2699.17.camel@pc10.localdom.local>
	<4890BBE8.8000901@blueyonder.co.uk>
	<1217457895.4433.52.camel@pc10.localdom.local>
	<48921FF9.8040504@blueyonder.co.uk>
	<1217542190.3272.106.camel@pc10.localdom.local>
	<48942E42.5040207@blueyonder.co.uk>
	<1217679767.3304.30.camel@pc10.localdom.local>
	<4895D741.1020906@blueyonder.co.uk>
	<1217798899.2676.148.camel@pc10.localdom.local>
	<4898C258.4040004@blueyonder.co.uk> <489A0B01.8020901@blueyonder.co.uk>
	<1218059636.4157.21.camel@pc10.localdom.local>
	<489B6E1B.301@blueyonder.co.uk>
	<1218153337.8481.30.camel@pc10.localdom.local>
	<489D7781.8030007@blueyonder.co.uk>
	<1218474259.2676.42.camel@pc10.localdom.local>
	<48A8892F.1010900@blueyonder.co.uk>
	<1219024648.2677.20.camel@pc10.localdom.local>
	<48B44CDF.60903@blueyonder.co.uk>
	<1219792546.2669.17.camel@pc10.localdom.local>
	<1220236507.2669.117.camel@pc10.localdom.local>
	<48C1874B.5080502@blueyonder.co.uk>
Content-Type: text/plain
Date: Sat, 06 Sep 2008 03:20:47 +0200
Message-Id: <1220664047.6339.53.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: KWorld DVB-T 210SE - Capture only in Black/White
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

Hi Ian,

Am Freitag, den 05.09.2008, 20:23 +0100 schrieb Ian Davidson:
> I am about to give up with this KWorld card as I do not have the time - 
> I need to get something that works.  So 2 questions - one for a 'last 
> try' and one for 'Plan B'.
> 
> Q1. Initially, the card was not recognised automatically, but under 
> guidance form Hermann, forcing Linux to treat it as card=114, I was able 
> to capture video.  Unfortunately, normally Black and White rather than 
> colour.  I understand that  normally Linux would sniff the eeprom and 
> determine the type of card from information found in there.  I have the 
> .inf files that describe the various KWorld cards to that other 
> operating system and I can see that the first 4 bytes of the eeprom, 
> albeit swapped about (Big Endian/Little Endian) are used in that .inf to 
> identify the card.  Various parameters are apparently put into the 
> Registry, depending on the card type and I thought I would compare the 
> parameters for my card with the parameters for the 'Real 114'.  I assume 
> that there is a file somewhere which says "If the eeprom says 'xxxx' 
> then the card is type 'n'".  Where can I see that file which identifies 
> the card type?

the manufacturers always need to improve their products to stay
competitive.

So we continuously see new card revisions with some small changes.
That likely is the same for your card, the 210SE.

>From what I'm aware of, I'm for sure not of all, we can neither gather
from the .inf files nor from the eeprom dump additional information.

Admittedly the previous 210RF had already previously reports of some
instability for DVB-T usage and reasons are unknown and since no more
users came in, the base is a singular report.

Your report to have sometimes color on the composite input and sometimes
only black and white is very unusual, since this also should not be
related to an additional external LNA, but I asked you to try with
tuner_config = 2 for the card in saa7134-cards.c, since it hangs around
in saa7134-dvb.c for it, and if possible, also on the some other OS.

> 
> Q2. Assuming that I am unable to make any difference, I will need to use 
> a different card - and hopefully, one that is supported.  In order to 
> make the current card do anything, I had to issue a couple of commands
> 
> "modprobe -vr saa7134-dvb saa7134-alsa saa7134 tuner"
> 
> "modprobe -v saa7134 card=114 i2c_scan=1"
> 
> so presumably, I would need to 'undo' the effect of those lines to let Linux auto-detect.  What do I need to do?
> 
> Ian

Your card is a new revision, the manufacturer changed the PCI subsystem
ID in the eeprom for it. That might have a reason.

At least that is the reason why it is not auto detected yet and why you
have to use "modprobe -v" for loading the likely most matching card,
that should be its previous revision.

Anyway, someone must go through all details, not only external inputs,
but also radio, analog TV and DVB-T before we can add that card to auto
detection.

Depending of the results of that work, we have to decide if it can use
the same entry as the previous card has or if it needs a new one,
because something substantial has changed.

You find the auto detection in saa7134-cards.c, the card enumeration in
saa7134.h and all is mirrored in Documentation/CARDLIST.saa7134.

As already explained, there is nothing to "undo" after "modprobe",
except you like to unload and try with different options again.

The -v option can be helpful, since it can find settings some system
setup helper tool might have written for you overriding your command
line for module options, but there is no indication in that direction.

Sorry, we have a very poor result here, but thanks for all your efforts
so far.

It becomes obvious, that manufacturers actively supporting GNU/Linux on
the more complex devices we have these days, but which are in most cases
still easy to set up within the framework we have, but not for every
single first customer, are clearly winners.

And that is fully OK.

Cheers,
Hermann






--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
