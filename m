Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:38214 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308Ab2HTVkW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Aug 2012 17:40:22 -0400
Date: Mon, 20 Aug 2012 23:40:15 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Anton Blanchard <anton@samba.org>
Cc: mchehab@infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 3/3] [media] winbond-cir: Adjust sample frequency to
 improve reliability
Message-ID: <20120820214015.GD14636@hardeman.nu>
References: <20120702115800.1275f944@kryten>
 <20120702115937.623d3b41@kryten>
 <20120703202825.GC29839@hardeman.nu>
 <20120705203035.196e238e@kryten>
 <9c21e63d50aba0e550a69a691dd12860@hardeman.nu>
 <20120709120208.446f2bdf@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120709120208.446f2bdf@kryten>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jul 09, 2012 at 12:02:08PM +1000, Anton Blanchard wrote:
>
>Hi David,
>
>> Just to make sure something like that isn't happening, could you
>> correct the line in wbcir_irq_rx() which currently reads:
>> 
>> rawir.duration = US_TO_NS((irdata & 0x7F) * 10);
>> 
>> so that it reads
>> 
>> rawir.duration = US_TO_NS(((irdata & 0x7F) + 1) * 10);
>
>Sure, I have added the change. This is what my diff to mainline looks
>like right now:

Hmm, still no good theory here.

Could you try the suggestions Konstantin Dimitrov proposed (i.e. the
Harmony fixups) and see if that makes any difference? Perhaps the
harmony actually does manage to send some bogus data (of sufficiently
short duration not to show up in the captured RX data)...


-- 
David Härdeman
