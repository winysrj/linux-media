Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:46639 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbZLYKi2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Dec 2009 05:38:28 -0500
Message-ID: <4B34961D.6060207@a-city.de>
Date: Fri, 25 Dec 2009 11:38:21 +0100
From: TAXI <taxi@a-city.de>
MIME-Version: 1.0
To: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Bad image/sound quality with Medion MD 95700
References: <4B33F4CA.7060607@a-city.de> <alpine.DEB.2.01.0912251021210.5481@ybpnyubfg.ybpnyqbznva>
In-Reply-To: <alpine.DEB.2.01.0912251021210.5481@ybpnyubfg.ybpnyqbznva>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

BOUWSMA Barry schrieb:
> The other thing to note is that this device delivers a full
> unfiltered Transport Stream, which with the 13,27Mbit/sec typical
> bandwidth per channel used in your country (apart from some local
> exceptions of greater values), will require a USB2 interface.
it is a USB2 interface:
[    3.965425] usb 1-3.1: new high speed USB device using ehci_hcd and
address 6 (it's the USB hub in the box)

I also thought the USB chipset could be the problem and testet it with
an extra USB2 card.

> around line 620 in my reference code, there is a line that sets
> the alternate interface to 6.  This is expected to be bulk, but
> on my boxes is isoc.
> 
> You can change this to interface 0, on which my boxes delivers
> bulk data flawlessly.
I think isoc would be okay on 2.6.32, so no need to change that, right?

> but when
> I have my machine operating fully again (yeahright), I can send
> you some of these alternative patches to try -- running 
> successfully on 2.6.14 and 2.6.27-rc4.
That would be nice.

P.S. my english is not the best so I don't understand all you wrote but
why don't you put the patches upstream?
