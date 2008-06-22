Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5M1Gx8R003442
	for <video4linux-list@redhat.com>; Sat, 21 Jun 2008 21:16:59 -0400
Received: from mail-in-03.arcor-online.net (mail-in-03.arcor-online.net
	[151.189.21.43])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5M1GkdK008450
	for <video4linux-list@redhat.com>; Sat, 21 Jun 2008 21:16:46 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Ian.Davidson@bigfoot.com
In-Reply-To: <485CC2FE.6040005@blueyonder.co.uk>
References: <485CC2FE.6040005@blueyonder.co.uk>
Content-Type: text/plain
Date: Sun, 22 Jun 2008 03:14:51 +0200
Message-Id: <1214097291.4776.22.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: Video 4 Linux <video4linux-list@redhat.com>
Subject: Re: Will this work?
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

Am Samstag, den 21.06.2008, 09:59 +0100 schrieb Ian Davidson:
> I am planning to buy a new system and want to be able to record video 
> (from a camera, using a composite signal).
> 
> I am considering a Intel Core 2 Duo E8200 processor running Fedora 9 and 
> a KWorld PVR_TV 7131 TV Tuner card.
> 
> The card has many features that I don't need - (Remote Control, 
> Scheduled recording in the Power off mode, Sleep timer etc.) - but does 
> include Composite Input.   Where can I look to verify that I will (or 
> won't) be able to use this card as I wish.  Is it supported?

all manufacturers do some changes to their products during lifetime of
the major chips involved.

So, without further details, you can't say for sure what will happen
with some latest product revision available, if not in details.

Since composite support is the simplest to add and most often stays
unchanged during several hardware revisions, _most_ likely it will work
or is easy to add.

On recent Kworld and other cards, a change from a gpio IR remote chip to
an i2c one with KS chips is the highest known risk for full support up
to 2.6.24. On later stuff you might discover some tuner to saa713x audio
decoding problems, caused by not to be able to set the PAL_I subnorm
currently and auto detection is not always reliable then.

Cheers,
Hermann



--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
