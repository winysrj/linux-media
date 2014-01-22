Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:53849 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755750AbaAVNuj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jan 2014 08:50:39 -0500
Received: from minime.bse ([77.20.120.199]) by mail.gmx.com (mrgmx101) with
 ESMTPSA (Nemesis) id 0MAloF-1WBm102MBv-00Bw28 for
 <linux-media@vger.kernel.org>; Wed, 22 Jan 2014 14:50:37 +0100
Date: Wed, 22 Jan 2014 14:50:36 +0100
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Robert Longbottom <rongblor@googlemail.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Conexant PCI-8604PW 4 channel BNC Video capture card (bttv)
Message-ID: <20140122135036.GA14871@minime.bse>
References: <52DD977E.3000907@googlemail.com>
 <1c25db0a-f11f-4bc0-b544-692140799b2a@email.android.com>
 <7D00B0B1-8873-4CB2-903F-8B98749C75FF@googlemail.com>
 <20140121101950.GA13818@minime.bse>
 <52DECF44.1070609@googlemail.com>
 <52DEDFCB.6010802@googlemail.com>
 <20140122115334.GA14710@minime.bse>
 <52DFC300.8010508@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52DFC300.8010508@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jan 22, 2014 at 01:09:20PM +0000, Robert Longbottom wrote:
> >  - The unlabled chip is probably a CPLD/FGPA. It filters the PCI REQ#
> >    lines from the 878As and has access to the GNT# and INT# lines,
> >    as well as to the GPIOs you mentioned. The bypass caps have a layout
> >    that fits to the Lattice ispMACH 4A.
> 
> Ah, ok, so this is something to do with interfacing to the PCI bus?

Yes, they probably try to improve the scheduling between those four
chips.

> I've just had a go at this, modprobe bttv pll=35,35,35,35, and using
> the composite0 input in xawtv (first in the list) and still no joy.
> I just get the same timeout errors repeating in dmesg:
> 
> [63204.009013] bttv: 3: timeout: drop=0 irq=46/26548, risc=3085d000,
> bits: HSYNC OFLOW

D'oh, I should have checked what this message means.
It says we did not receive an interrupt.
The unlabled chip can't prevent an interrupt from being delivered.
It can only request additional interrupts.

> 02:0c.0 Multimedia video controller [0400]: Brooktree Corporation
>         Flags: bus master, medium devsel, latency 32, IRQ 16
 
> 02:0c.1 Multimedia controller [0480]: Brooktree Corporation Bt878
>         Flags: bus master, medium devsel, latency 32, IRQ 5

> 02:0d.0 Multimedia video controller [0400]: Brooktree Corporation
>         Flags: bus master, medium devsel, latency 32, IRQ 17

> 02:0d.1 Multimedia controller [0480]: Brooktree Corporation Bt878
>         Flags: bus master, medium devsel, latency 32, IRQ 10

> 02:0e.0 Multimedia video controller [0400]: Brooktree Corporation
>         Flags: bus master, medium devsel, latency 32, IRQ 18

> 02:0e.1 Multimedia controller [0480]: Brooktree Corporation Bt878
>         Flags: bus master, medium devsel, latency 32, IRQ 10

> 02:0f.0 Multimedia video controller [0400]: Brooktree Corporation
>         Flags: bus master, medium devsel, latency 32, IRQ 19

> 02:0f.1 Multimedia controller [0480]: Brooktree Corporation Bt878
>         Flags: bus master, medium devsel, latency 32, IRQ 11

This is strange. There are 7 different IRQs assigned to that card but
PCI slots only have 4. According to the pictures each 878A gets one of
these. The .0 and .1 functions of a 878A must always share the same IRQ.

Does your system print information on the PCI IRQ routing when Linux
starts?

  Daniel

