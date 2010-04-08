Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:53319 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755874Ab0DHMVV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Apr 2010 08:21:21 -0400
Message-ID: <4BBDCA3D.3000106@infradead.org>
Date: Thu, 08 Apr 2010 09:21:17 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>
CC: linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [RFC3] Teach drivers/media/IR/ir-raw-event.c to use durations
References: <20100408113910.GA17104@hardeman.nu>
In-Reply-To: <20100408113910.GA17104@hardeman.nu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

David Härdeman wrote:
> drivers/media/IR/ir-raw-event.c is currently written with the assumption 
> that all "raw" hardware will generate events only on state change (i.e.  
> when a pulse or space starts).
> 
> However, some hardware (like mceusb, probably the most popular IR receiver
> out there) only generates duration data (and that data is buffered so using
> any kind of timing on the data is futile).
> 
> Furthermore, using signed int's to represent pulse/space durations in ms
> is a well-known approach to anyone with experience in writing ir decoders.
> 
> This patch (which has been tested this time) is still a RFC on my proposed
> interface changes.
> 
> Changes since last version:
> 
> o s64's are used to represent pulse/space durations in ns.
> 
> o Lots of #defines are used in the decoders
> 
> o Refreshed to apply cleanly on top of Mauro's current git tree
> 
> o Jon's comments wrt. interrupt-context safe functions have been added
> 

Ok, tested it with a variety of NEC/NEC extended/RC-5 IR's I have, with the
saa7134 hardware. All worked.

There's just a few checkpatch.pl complains, and the most important thing:

It lacks your SOB ;)

Please fix the checkpatch.pl errors, add a kfifo size comment and your SOB
and resend it to me (or, if you prefer, just send your SOB. I can take care
of the rest, as they're just trivial things).

-- 

Cheers,
Mauro
