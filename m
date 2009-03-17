Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:36281 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755369AbZCQKik (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Mar 2009 06:38:40 -0400
Subject: Re: Strange card
From: Andy Walls <awalls@radix.net>
To: Eduardo Kaftanski <ekaftan@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <d6a802e70903161940t2ce9d20aw46360de23d987d29@mail.gmail.com>
References: <d6a802e70903161940t2ce9d20aw46360de23d987d29@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 17 Mar 2009 06:37:07 -0400
Message-Id: <1237286227.3296.5.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2009-03-16 at 22:40 -0400, Eduardo Kaftanski wrote:
> I bought today a card that was packaged as a PICO2000-compatible but I
> can't get it to work... I read all the archives and wikis I could find
> but the only one thread with the same card description but the recipe
> won't work for me.
> 
> Here is the lspci... is this card supported?
> 
> 01:0a.0 Multimedia video controller: Brooktree Corporation Unknown
> device 016e (    rev 11)

That looks wrong - 016e is not valid for a BrookTree device according to
the PCI ID database.   A value of 036e would be correct for some Bt878
Video Capture devices.

Pull out your PCI cards, blow the dust out of all the slots, reseat the
cards, and try again.

Regards,
Andy


>         Flags: bus master, fast devsel, latency 32, IRQ 11
>         Memory at d9fff000 (32-bit, prefetchable) [size=4K]
>         Capabilities: [44] Vital Product Data
>         Capabilities: [4c] Power Management version 2
> 
> 01:0a.1 Multimedia controller: Brooktree Corporation Bt878 Audio
> Capture (rev 11    )
>         Flags: bus master, fast devsel, latency 32, IRQ 11
>         Memory at d9ffe000 (32-bit, prefetchable) [size=4K]
>         Capabilities: [44] Vital Product Data
>         Capabilities: [4c] Power Management version 2
> 
> 
> THanks.
> 
> 
> 

