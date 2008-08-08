Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m788xggk027785
	for <video4linux-list@redhat.com>; Fri, 8 Aug 2008 04:59:42 -0400
Received: from mail-in-10.arcor-online.net (mail-in-10.arcor-online.net
	[151.189.21.50])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m788wx9g005978
	for <video4linux-list@redhat.com>; Fri, 8 Aug 2008 04:58:59 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Dmitri Belimov <d.belimov@gmail.com>
In-Reply-To: <20080808064029.67a42946@dimon-PC.ttk.local>
References: <20080804212204.GA3853@potty.ifup.org>
	<20080808064029.67a42946@dimon-PC.ttk.local>
Content-Type: text/plain
Date: Fri, 08 Aug 2008 10:51:54 +0200
Message-Id: <1218185514.2678.22.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: Igor Kuznetsov <igk72@yandex.ru>, v4l <video4linux-list@redhat.com>,
	"Andrey J. Melnikov" <temnota@kmv.ru>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: BeholdTV 505FM Input Causing Repeating Zeros
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

Am Freitag, den 08.08.2008, 06:40 +1000 schrieb Dmitri Belimov:
> Hello All.
> 
> The Beholder company don't support hacked tuners of other vendors.
> A 3 month a go I made complex patch and fix all Beholder's gpio mask to correct. Please look:
> 
> saa7134-input.c
> changeset 7677	50835af51a9d
> 
> http://linuxtv.org/hg/v4l-dvb/rev/50835af51a9d
> 
> As I see user who send this bug is russian readable. You can send him to
> 
> http://www.beholder.ru/bb/viewforum.php?f=11
> for reading and patching his kernel.

Dmitry,

Brandon already discovered, that we were victims of a false bug report,
caused by an user faking that Beholder card by manipulating the PCI
subsystem in the eeprom.

There is no need for any further action from your side, if the eeprom is
write protected by default.

Since I thought you might be in vacation, trying to help to look it up
remembered me, that we not even have the eeprom dumps for all Beholder
cards.

Maybe such could have helped to identify that sort of case earlier,
but can't say for sure.


> > I have received a bug report[1] from a user who's card used to work
> > as a SAA7134_BOARD_UNKNOWN before the patch[2] that added support for
> > SAA7134_BOARD_BEHOLD_505FM.
> > 
> > The IR input isn't setup properly and the driver is writing an
> > infinite number of zeros to the users terminal.
> > 
> > Is there a way to figure out the correct mask_keycode and mask_keyup
> > for this card?  Otherwise I recommend that we don't report has_remote
> > for this card.
> > 
> > Thanks,
> > 
> > 	Brandon
> > 
> > 
> > [1] https://bugzilla.novell.com/show_bug.cgi?id=403904
> > [2] http://linuxtv.org/hg/v4l-dvb/rev/8bdb58e63ea1
> 
> With my best regards, Dmitry.
> 

Cheers,
Hermann


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
