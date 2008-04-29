Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3TLu7hp005111
	for <video4linux-list@redhat.com>; Tue, 29 Apr 2008 17:56:07 -0400
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3TLtsBr012687
	for <video4linux-list@redhat.com>; Tue, 29 Apr 2008 17:55:54 -0400
From: Andy Walls <awalls@radix.net>
To: Gavin Hamill <gdh@acentral.co.uk>
In-Reply-To: <1209505252.6270.11.camel@gdh-home>
References: <1209505252.6270.11.camel@gdh-home>
Content-Type: text/plain
Date: Tue, 29 Apr 2008 17:55:51 -0400
Message-Id: <1209506151.5699.7.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Ident for Bt848 card
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

On Tue, 2008-04-29 at 22:40 +0100, Gavin Hamill wrote:
> Hi, the old Bt848 card (no tuner, no audio - just composite + s-video)
> I'm using isn't picked up by kernel 2.6.24 properly causing a 30 second
> delay at bootup to find audio chips and EEPROMS that aren't there.
> 
> I've been trying to put together a patch against hg to fix it, but am a
> little confused.
> 
> The card is definitely a BTTV_BOARD_GRANDTEC since the structure is
> correct and this comment [1] is right on the money:
> 
>                 /* This is the ultimate cheapo capture card
>                 * just a BT848A on a small PCB!
>                 * Steve Hosgood <steve@equiinet.com> */
> 
> However there seems to be a confusion because the PCI ID of my card is
> 109e:0350 (which is not defined anywhere in hg) yet BTTV_BOARD_GRANDTEC
> is defined as 
> 

109e is BrookTree's vendor id and 0350 is the id for the BT848.  Many
different BT848 based cards could have this vendor id:device id
combination.

What does "lspci -nv" give as the subsystem ID for this card?  You may
find it matches up with with one of the entries in in bttv-cards.c.


>  { 0x41424344, BTTV_BOARD_GRANDTEC, "GrandTec Multi Capture" },
> 
> This appears to be bogus, and that PCI ID should instead be pointing at
> BTTV_BOARD_GRANDTEC_MULTI (which does indeed define 4 composite inputs
> correct for a 'multi' card). The _MULTI one is currently not associated
> with any PCI ID.
> 
> I believe the correct definitions should therefore be:
> 
>  { 0x109e0350, BTTV_BOARD_GRANDTEC, "GrandTec Grand Video Capture" },
>  { 0x41424344, BTTV_BOARD_GRANDTEC_MULTI, "GrandTec Multi Capture" },
> 
> Could someone take a quick look over this and tell me if I've made some
> awful assumption?

A PCI Device ID is not a Subsystem ID.

Regards,
Andy

> Cheers,
> Gavin.
> 
> [1] Line 1346 bttv-cards.c
> 
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
> 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
