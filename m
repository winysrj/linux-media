Return-path: <mchehab@pedra>
Received: from ffm.saftware.de ([83.141.3.46]:51761 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752406Ab1EDJ7N (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 May 2011 05:59:13 -0400
Message-ID: <4DC1236C.3000006@linuxtv.org>
Date: Wed, 04 May 2011 11:59:08 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Issa Gorissen <flop.m@usa.net>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] Ngene cam device name
References: <148PeDiAM3760S04.1304497658@web04.cms.usa.net>
In-Reply-To: <148PeDiAM3760S04.1304497658@web04.cms.usa.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 05/04/2011 10:27 AM, Issa Gorissen wrote:
> From: Andreas Oberritter <obi@linuxtv.org>
>> Also, there's still no mapping between ca and caio devices. Imagine a
>> built-in descrambler ca0 and two CI slots ca1 and ca2.
>>
>> ca0 won't get a caio device, at least for now.
>> ca1 and ca2 might or might not have a caio device.
>>
>> If there is caio0, how am I supposed to know that it's related to ca1 or
>> ca2 (or ca0, if someone implements a caio device to bypass the software
>> demux to use a built-in descrambler)? You must not assume that there are
>> either none or two (or three) caio interfaces. You need to be able to
>> detect (or set up) the connection between the interfaces. Otherwise this
>> "API" will be a mess.
>>
>> Regards,
>> Andreas
> 
> 
> To my understanding, in such a described case, 
> 
> - ca0 would be reached from /dev/dvb/adapter0/ca0
> - ca[12], depending on if they are connected to the same physical adapter
> (PCI, USB, ...), would be reached from /dev/dvb/adapter1/ca[12] or
> /dev/dvb/adapter1/ca1 and /dev/dvb/adapter2/ca2 and there respective caio
> devices.

Of course I'm referring to devices connected to the same physical
adapter. Otherwise they would all be called ca0. Device enumeration
always starts at 0, for each adapter. What you're describing just
doesn't make sense.

> - If the 3 ca devices are on the same adapter, then the driver writer should
> take care of the order of the mapping so that ca1 always map caio1 and
> ca2/caio2, ...; and if this is not feasable, then the driver writer should
> span the ca/caio devices on different /dev/dvb/adapter folders.

You can't create caio1 without creating caio0 first. Of course, you
could require driver writers to register those ca devices first that
have caio devices. But that conflicts with other policies the driver
author might already have chosen, e.g. to map the ca (descrambler)
device numbers to demux and dvr numbers, which seems way more intuitive
to me, because demux hardware usually comes with built-in descramblers.

It's ugly to force random policies on drivers. Please create a proper
interface instead!

Last but not least, using a different adapter number wouldn't fit
either, because a DVB adapter is supposed to
- be one independent piece of hardware
- provide at least a frontend and a demux device

At least on embedded devices, it simply isn't feasible to copy a TS to
userspace from a demux, just to copy it back to the kernel and again
back to userspace through a caio device, when live streaming. But you
may want to provide a way to use the caio device for
offline-descrambling. Unless you want to force users to buy multiple
modules and multiple subscriptions for a single receiver, which in turn
would need multiple CI slots, you need a way to make sure caio can not
be used during live streaming. If this dependency is between different
adapters, then something is really, really wrong.

Why don't you just create a new device, e.g. ciX, deprecate the use of
caX for CI devices, inherit CI-related existing ioctls from the CA API,
translate the existing read and write funtions to ioctls and then use
read and write for TS I/O? IIRC, Ralph suggested something similar. I'm
pretty sure this can be done without too much code and in a backwards
compatible way.

Regards,
Andreas
