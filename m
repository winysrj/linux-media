Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.emlix.com ([193.175.82.87]:59977 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932644Ab0COOhI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Mar 2010 10:37:08 -0400
Message-ID: <4B9E4084.8060906@emlix.com>
Date: Mon, 15 Mar 2010 15:13:24 +0100
From: =?ISO-8859-1?Q?Daniel_Gl=F6ckner?= <dg@emlix.com>
MIME-Version: 1.0
To: Martin van Es <mrvanes@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: dual TT C-1501 on a single PCI riser
References: <eccab77d1003140521v73b17897h76ce413d5dc59361@mail.gmail.com>	 <eccab77d1003140914p20debe7fka2fbd173a85b860f@mail.gmail.com>	 <20100314215202.GA229@daniel.bse> <eccab77d1003150550g2d1c03eapd45fd2daa6488fdf@mail.gmail.com>
In-Reply-To: <eccab77d1003150550g2d1c03eapd45fd2daa6488fdf@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/15/2010 01:50 PM, Martin van Es wrote:
> When I look at the pci layout, pci device 05 is connected to bridge 1e.0:

> -[0000:00]-+-00.0
>            +-1e.0-[05]--+-00.0  Philips Semiconductors SAA7146
>            |            \-0c.0  Philips Semiconductors SAA7146

No, this means bridge 1e.0 connects to bus number 05.

> So I started to suspect that the motherboard had no way to know what
> PCI int's were used behind the bridge if both cards were detected to serve
> INTA (i.e. 05.0x = INTA in lspci -v) and would thus (quite stupidly?)
> route any int for this slot to INTA?

I don't get that sentence..
Every slot has INTA/B/C/D and each PCI function announces which one of these it
uses. In most cases INTA is used. The board manufacturer for bus 05 only knows
how INTx maps to APIC inputs for slot 00. He knows there are people who use
riser cards, so he adds mappings for non-existent slots by permuting those
interrupts available to slot 00.

> Last change was to cut the original slot2 connection to INTD and gone were my
> extra interrupts!

It might be INTD isn't connected to the APIC. It is rarely used on cards.

> So now I have two correctly recognised cards, both using int 20 and PCI INTA.
> Now I wonder if this will harm the performance if both cards are recording
> streams, let alone if they work, because that's the next test I still have to
> do.

It should work. On interrupt the driver will be called once for each card to
check if the card in question caused the interrupt. As long as we are not
talking about thousands of interrupts per second, this shouldn't harm performance.

  Daniel


-- 
Dipl.-Math. Daniel Glöckner, emlix GmbH, http://www.emlix.com
Fon +49 551 30664-0, Fax -11, Bahnhofsallee 1b, 37081 Göttingen, Germany
Sitz der Gesellschaft: Göttingen, Amtsgericht Göttingen HR B 3160
Geschäftsführer: Dr. Uwe Kracke, Ust-IdNr.: DE 205 198 055

emlix - your embedded linux partner
