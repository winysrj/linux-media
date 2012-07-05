Return-path: <linux-media-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:33821 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932449Ab2GEKag (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Jul 2012 06:30:36 -0400
Date: Thu, 5 Jul 2012 20:30:35 +1000
From: Anton Blanchard <anton@samba.org>
To: David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: mchehab@infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 3/3] [media] winbond-cir: Adjust sample frequency to
 improve reliability
Message-ID: <20120705203035.196e238e@kryten>
In-Reply-To: <20120703202825.GC29839@hardeman.nu>
References: <20120702115800.1275f944@kryten>
	<20120702115937.623d3b41@kryten>
	<20120703202825.GC29839@hardeman.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi David,

> The in-kernel RC6 decoder already has margins of around 50% for most
> pulse/spaces (i.e. 444us +/- 222us). Changing the sample resolution
> from 10 to 6 us should have little to no effect on the RC6 decoding
> (also, the Windows driver uses a 50us resolution IIRC).
> 
> Do you have a log of a successful and unsuccesful event (the timings
> that is)?

I had a closer look. I dumped the RC6 debug, but I also printed the raw
data in the interrupt handler:

    printk("%x %d %d\n", irdata, rawir.pulse, rawir.duration);

A successful event begins with:

7f 1 1270000
7f 1 1270000
 8 1 80000
db 0 910000
27 1 390000
b3 0 510000
26 1 380000
b0 0 480000
ir_rc6_decode: RC6 decode started at state 0 (2620us pulse)
ir_rc6_decode: RC6 decode started at state 1 (910us space)
ir_rc6_decode: RC6 decode started at state 2 (390us pulse)
ir_rc6_decode: RC6 decode started at state 3 (510us space)
ir_rc6_decode: RC6 decode started at state 2 (66us space)
ir_rc6_decode: RC6 decode started at state 2 (380us pulse)
26 1 380000
db 0 910000
26 1 380000
dd 0 930000
7d 1 1250000    <---------------
dd 0 930000
25 1 370000
b4 0 520000
ir_rc6_decode: RC6 decode started at state 3 (480us space)
ir_rc6_decode: RC6 decode started at state 2 (36us space)
ir_rc6_decode: RC6 decode started at state 2 (380us pulse)
ir_rc6_decode: RC6 decode started at state 3 (910us space)
ir_rc6_decode: RC6 decode started at state 2 (466us space)
ir_rc6_decode: RC6 decode started at state 3 (380us pulse)
ir_rc6_decode: RC6 decode started at state 4 (0us pulse)
ir_rc6_decode: RC6 decode started at state 4 (930us space)
ir_rc6_decode: RC6 decode started at state 5 (1250us pulse)
ir_rc6_decode: RC6 decode started at state 6 (361us pulse)
ir_rc6_decode: RC6 decode started at state 7 (930us space)

Now compare to an unsuccesful event, in particular the byte
I have tagged in both traces:

7f 1 1270000
7f 1 1270000
 2 1 20000
df 0 950000
26 1 380000
b0 0 480000
26 1 380000
b0 0 480000
26 1 380000
dc 0 920000
26 1 380000
ir_rc6_decode: RC6 decode started at state 0 (2560us pulse)
ir_rc6_decode: RC6 decode started at state 1 (950us space)
ir_rc6_decode: RC6 decode started at state 2 (380us pulse)
ir_rc6_decode: RC6 decode started at state 3 (480us space)
ir_rc6_decode: RC6 decode started at state 2 (36us space)
ir_rc6_decode: RC6 decode started at state 2 (380us pulse)
ir_rc6_decode: RC6 decode started at state 3 (480us space)
ir_rc6_decode: RC6 decode started at state 2 (36us space)
ir_rc6_decode: RC6 decode started at state 2 (380us pulse)
ir_rc6_decode: RC6 decode started at state 3 (920us space)
ir_rc6_decode: RC6 decode started at state 2 (476us space)
dc 0 920000
ff 0 1270000 <----------------
de 0 940000
25 1 370000
b1 0 490000
26 1 380000
b0 0 480000
26 1 380000
ir_rc6_decode: RC6 decode started at state 3 (380us pulse)
ir_rc6_decode: RC6 decode started at state 4 (0us pulse)
ir_rc6_decode: RC6 decode started at state 4 (3130us space)
ir_rc6_decode: RC6 decode failed at state 4 (3130us space)

That should have been a pulse but it came out as a space. This makes me
wonder if there is an issue with the run length encoding, perhaps when
a pulse is the right size to just saturate it. It does seem like we
set the top bit even though we should not have.

If true we could choose any sample rate that avoids it.

Anton
