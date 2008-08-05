Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m751TRuL022532
	for <video4linux-list@redhat.com>; Mon, 4 Aug 2008 21:29:27 -0400
Received: from mail-in-16.arcor-online.net (mail-in-16.arcor-online.net
	[151.189.21.56])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m751TOvj032253
	for <video4linux-list@redhat.com>; Mon, 4 Aug 2008 21:29:25 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Brandon Philips <brandon@ifup.org>
In-Reply-To: <20080804212204.GA3853@potty.ifup.org>
References: <20080804212204.GA3853@potty.ifup.org>
Content-Type: text/plain
Date: Tue, 05 Aug 2008 03:22:41 +0200
Message-Id: <1217899361.4980.20.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: "Andrey J. Melnikov" <temnota@kmv.ru>, Igor Kuznetsov <igk72@yandex.ru>,
	v4l <video4linux-list@redhat.com>,
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

Am Montag, den 04.08.2008, 14:22 -0700 schrieb Brandon Philips:
> Hello All-
> 
> I have received a bug report[1] from a user who's card used to work as a
> SAA7134_BOARD_UNKNOWN before the patch[2] that added support for
> SAA7134_BOARD_BEHOLD_505FM.

how far something detected as SAA7134_BOARD_UNKNOWN can "work" is
another issue and not related.

> The IR input isn't setup properly and the driver is writing an infinite
> number of zeros to the users terminal.
> 
> Is there a way to figure out the correct mask_keycode and mask_keyup for
> this card?  Otherwise I recommend that we don't report has_remote for
> this card.

We should of course wait for a response for a short while, seems Dmitri
has such board, but maybe is in vacation and the bug seems to be really
annoying.

Don't hesitate to take out the IR support until someone with such a
board has time to look at it.

To put it in again after review should not be a problem at all.

The card identification per PCI subsystem seems to be very safe in this
case, I did took out some ambiguous stuff previously and subvendor
0x0000 on other cards is still not that great, but for this one just GO.

If you don't mind, since you pointed first again to known Compro auto
detection flaws and since calls to the lists had no results and the
initial contributor does not have the card anymore, also that time only
with an eeprom dump for some first bytes, not sufficient to come closer
to the tuner encoding, which might eventually allow detection from
eeprom, please take this out too for now too.

We have already another report about the obvious on LKML,
but no patch came back ;)

Cheers,
Hermann



--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
