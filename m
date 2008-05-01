Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m411Chqx022797
	for <video4linux-list@redhat.com>; Wed, 30 Apr 2008 21:12:43 -0400
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m411CWj8029796
	for <video4linux-list@redhat.com>; Wed, 30 Apr 2008 21:12:32 -0400
From: Andy Walls <awalls@radix.net>
To: Gavin Hamill <gdh@acentral.co.uk>
In-Reply-To: <1209575728.6125.5.camel@gdh-home>
References: <1209505252.6270.11.camel@gdh-home>
	<1209506151.5699.7.camel@palomino.walls.org>
	<1209575728.6125.5.camel@gdh-home>
Content-Type: text/plain
Date: Wed, 30 Apr 2008 21:12:29 -0400
Message-Id: <1209604349.3219.36.camel@palomino.walls.org>
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

On Wed, 2008-04-30 at 18:15 +0100, Gavin Hamill wrote:
> On Tue, 2008-04-29 at 17:55 -0400, Andy Walls wrote:
> > 
> > 109e is BrookTree's vendor id and 0350 is the id for the BT848.  Many
> > different BT848 based cards could have this vendor id:device id
> > combination.
> 
> I see. So at the moment although mine is detected as:
> 
> bttv0: Bt848 (rev 18) at 0000:03:03.0, irq: 22, latency: 64, mmio:
> 0xee000000
> bttv0: using:  *** UNKNOWN/GENERIC ***  [card=0,autodetected]
> bttv0: gpio: en=00000000, out=00000000 in=00ffffff [init]
> 
> .. setting this PCI ID to be a very cut down card would possibly kill
> support for the tuner/audio on other cheapo cards out there which are
> only working by way of probing by the driver?
> 
> > What does "lspci -nv" give as the subsystem ID for this card?  You may
> > find it matches up with with one of the entries in in bttv-cards.c.
> 
> It doesn't:
> 
> 03:03.0 0400: 109e:0350 (rev 12)
> 	Flags: bus master, medium devsel, latency 64, IRQ 22
> 	Memory at ee000000 (32-bit, prefetchable) [size=4K]
> 
> Almost every other device from lspci -vn has a Subsystem, but not this
> one. Sounds like I'm out of luck, then. Ah well :/

Not yet.

1.  Check the bttv-cards.c file for the description that best matches
your card based on what you can physically inspect on the card: chips
traces, input and antenna jacks, etc.

2. Look up the card # in bttv.h.  For example:
...
#define BTTV_BOARD_GRANDTEC                0x39  (== 57)
...
#define BTTV_BOARD_GRANDTEC_MULTI          0x4d  (== 77)


3. Try modprobing with the card option, for example:

# modprobe -r bttv
# modprobe bttv card=57


Regards,
Andy




--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
