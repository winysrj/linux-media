Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:53350 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933735AbZKYWdY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Nov 2009 17:33:24 -0500
Date: 25 Nov 2009 23:31:00 +0100
From: lirc@bartelmus.de (Christoph Bartelmus)
To: kraxel@redhat.com
Cc: awalls@radix.net
Cc: dheitmueller@kernellabs.com
Cc: dmitry.torokhov@gmail.com
Cc: j@jannau.net
Cc: jarod@redhat.com
Cc: jarod@wilsonet.com
Cc: khc@pm.waw.pl
Cc: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: mchehab@redhat.com
Cc: superm1@ubuntu.com
Message-ID: <BDZbPXRZjFB@christoph>
In-Reply-To: <4B0DA885.7010601@redhat.com>
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was: Re: [PATCH 1/3 v2] lirc core device driver infrastructure
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gerd,

on 25 Nov 09 at 22:58, Gerd Hoffmann wrote:
[...]
> (1) ir code (say rc5) -> keycode conversion looses information.
>
> I think this can easily be addressed by adding a IR event type to the
> input layer, which could look like this:
>
>    input_event->type  = EV_IR
>    input_event->code  = IR_RC5
>    input_event->value = <rc5 value>
>
> In case the 32bit value is too small we might want send two events
> instead, with ->code being set to IR_<code>_1 and IR_<code>_2
>
> Advantages:
>    * Applications (including lircd) can get access to the unmodified
>      rc5/rc6/... codes.

Unfortunately with most hardware decoders the code that you get is only  
remotely related to the actual code sent. Most RC-5 decoders strip off  
start bits. Toggle-bits are thrown away. NEC decoders usually don't pass  
through the address part. Some even generate some pseudo-random code  
(Irman). There is no common standard which bit is sent first, LSB or MSB.  
Checksums are thrown away.
To sum it up: I don't think this information will be useful at all for  
lircd or anyone else. Actually lircd does not even know anything about  
actual protocols. We only distinguish between certain protocol types, like  
Manchester encoded, space encoded, pulse encoded etc. Everything else like  
the actual timing is fully configurable.

[...]
> If we keep the lirc interface for raw samples anyway, then we can keep
> it for sending too, problem solved ;)  How does sending hardware work
> btw?  Do they all accept just raw samples?  Or does some hardware also
> accept ir-codes?

Usually raw samples in some form. I've never seen any device that would  
accept just ir-codes. UIRT2 devices have some more advanced modes but also  
accept raw samples.

Christoph
