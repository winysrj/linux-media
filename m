Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3UHFwLC024423
	for <video4linux-list@redhat.com>; Wed, 30 Apr 2008 13:15:58 -0400
Received: from pat.laterooms.com (fon.laterooms.com [194.24.251.1])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3UHFU9s009192
	for <video4linux-list@redhat.com>; Wed, 30 Apr 2008 13:15:30 -0400
Received: from pat.laterooms.com (localhost.localdomain [127.0.0.1])
	by pat.laterooms.com (Postfix) with ESMTP id F3D6DC28B
	for <video4linux-list@redhat.com>; Wed, 30 Apr 2008 18:15:28 +0100 (BST)
Received: from eddie.acentral.co.uk
	(80-192-159-113.cable.ubr04.pres.blueyonder.co.uk [80.192.159.113])
	by pat.laterooms.com (Postfix) with ESMTP id D60C2C25F
	for <video4linux-list@redhat.com>; Wed, 30 Apr 2008 18:15:28 +0100 (BST)
Received: from eddie.acentral.co.uk (eddie.acentral.co.uk [127.0.0.1])
	by eddie.acentral.co.uk (Postfix) with ESMTP id F07F075DB8
	for <video4linux-list@redhat.com>; Wed, 30 Apr 2008 18:15:26 +0100 (BST)
Received: from [10.0.0.23] (unknown [10.0.0.23])
	by eddie.acentral.co.uk (Postfix) with ESMTP id D948775D07
	for <video4linux-list@redhat.com>; Wed, 30 Apr 2008 18:15:26 +0100 (BST)
From: Gavin Hamill <gdh@acentral.co.uk>
To: video4linux-list@redhat.com
In-Reply-To: <1209506151.5699.7.camel@palomino.walls.org>
References: <1209505252.6270.11.camel@gdh-home>
	<1209506151.5699.7.camel@palomino.walls.org>
Content-Type: text/plain
Date: Wed, 30 Apr 2008 18:15:28 +0100
Message-Id: <1209575728.6125.5.camel@gdh-home>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
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

On Tue, 2008-04-29 at 17:55 -0400, Andy Walls wrote:
> 
> 109e is BrookTree's vendor id and 0350 is the id for the BT848.  Many
> different BT848 based cards could have this vendor id:device id
> combination.

I see. So at the moment although mine is detected as:

bttv0: Bt848 (rev 18) at 0000:03:03.0, irq: 22, latency: 64, mmio:
0xee000000
bttv0: using:  *** UNKNOWN/GENERIC ***  [card=0,autodetected]
bttv0: gpio: en=00000000, out=00000000 in=00ffffff [init]

.. setting this PCI ID to be a very cut down card would possibly kill
support for the tuner/audio on other cheapo cards out there which are
only working by way of probing by the driver?

> What does "lspci -nv" give as the subsystem ID for this card?  You may
> find it matches up with with one of the entries in in bttv-cards.c.

It doesn't:

03:03.0 0400: 109e:0350 (rev 12)
	Flags: bus master, medium devsel, latency 64, IRQ 22
	Memory at ee000000 (32-bit, prefetchable) [size=4K]

Almost every other device from lspci -vn has a Subsystem, but not this
one. Sounds like I'm out of luck, then. Ah well :/

Cheers,
Gavin.


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
