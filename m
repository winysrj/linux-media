Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n01Fc4oW000711
	for <video4linux-list@redhat.com>; Thu, 1 Jan 2009 10:38:04 -0500
Received: from mail-in-04.arcor-online.net (mail-in-04.arcor-online.net
	[151.189.21.44])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n01FbmcM025289
	for <video4linux-list@redhat.com>; Thu, 1 Jan 2009 10:37:48 -0500
From: hermann pitton <hermann-pitton@arcor.de>
To: Simon Hobson <linux@thehobsons.co.uk>
In-Reply-To: <a0624080bc58126e6561c@simon.thehobsons.co.uk>
References: <a06240804c580f44d7a48@simon.thehobsons.co.uk>
	<a0624080bc58126e6561c@simon.thehobsons.co.uk>
Content-Type: text/plain
Date: Thu, 01 Jan 2009 16:38:09 +0100
Message-Id: <1230824289.2669.2.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Problem setting up HVR-1110
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

Hi Simon,

Am Mittwoch, den 31.12.2008, 13:43 +0000 schrieb Simon Hobson:
> I wrote:
> >I've got MythTV installed and bought a Hauppage HVR-1110 card for 
> >it. The card is detected and the saa7134 driver loaded - but that 
> >seems to be it. Everything I can find suggests that the card should 
> >be identified automatically (and the TDA1004X driver & firmware 
> >loaded), but it isn't.
> 
> <snip>
> 
> >uname -a reports :
> >>Linux eddi 2.6.18-6-xen-amd64 #1 SMP Fri Dec 12 07:02:03 UTC 2008 
> >>x86_64 GNU/Linux
> >
> >
> >Yes, this is running in a Xen guest - but I've also tried booting 
> >the machine into a non-Xen mode (with non-Xen kernel) and it behaves 
> >exactly the same. In both cases, the OS is Debian Lenny.
> 
> Hmm, memory isn't what it used to be :-(
> 
> Went back and double checked, my Dom0 is Etch. Long story short - 
> upgraded guest to 2.6.26, upgraded Xen to run it, fixed all the 
> things the Xen upgrade changes, and it now is recognised and the 
> firmware loaded etc.
> 

yep, 2.6.18 was too old.

We fixed radio and external audio in recently too.

It is in 2.6.28 and was previously untested.

Cheers,
Hermann


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
