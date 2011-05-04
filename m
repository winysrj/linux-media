Return-path: <mchehab@pedra>
Received: from ffm.saftware.de ([83.141.3.46]:40991 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752969Ab1EDNvI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 May 2011 09:51:08 -0400
Message-ID: <4DC159C7.1070201@linuxtv.org>
Date: Wed, 04 May 2011 15:51:03 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Issa Gorissen <flop.m@usa.net>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] Ngene cam device name
References: <889PeDLgF4624S03.1304507225@web03.cms.usa.net>
In-Reply-To: <889PeDLgF4624S03.1304507225@web03.cms.usa.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 05/04/2011 01:07 PM, Issa Gorissen wrote:
> From: Andreas Oberritter <obi@linuxtv.org>
>>
>> Of course I'm referring to devices connected to the same physical
>> adapter. Otherwise they would all be called ca0. Device enumeration
>> always starts at 0, for each adapter. What you're describing just
>> doesn't make sense.
> 
> 
> Yes indeed you're right, I answered too quickly.
> 
> 
>> Last but not least, using a different adapter number wouldn't fit
>> either, because a DVB adapter is supposed to
>> - be one independent piece of hardware
>> - provide at least a frontend and a demux device
> 
> 
> How would you support device like the Hauppauge WinTV-CI ? This one comes on a
> USB port and does not provide any frontend and demux device.

Yes, as an exception, this device indeed wouldn't have a frontend,
because it doesn't exist physycally.

It wouldn't have multiple adapters numbers either.

>> At least on embedded devices, it simply isn't feasible to copy a TS to
>> userspace from a demux, just to copy it back to the kernel and again
>> back to userspace through a caio device, when live streaming. But you
>> may want to provide a way to use the caio device for
>> offline-descrambling. Unless you want to force users to buy multiple
>> modules and multiple subscriptions for a single receiver, which in turn
>> would need multiple CI slots, you need a way to make sure caio can not
>> be used during live streaming. If this dependency is between different
>> adapters, then something is really, really wrong.
> 
> 
> With the transmitted keys changed frequently (at least for viaccess), what's
> the point in supporting offline descrambling when it will not work reliably
> for all ?

The reliability of offline descrambling depends on the network operators
policy. So while it won't be useful for everybody in the world, it might
well be useful to all customers of certain operators.

> As for descrambling multiple tv channels from different transponders with only
> one cam, this is already possible. An example is what Digital Devices calls
> MTD (Multi Transponder Decrypting). But this is CAM dependent, some do not
> support it.

What's the point if it doesn't work reliably for everybody? ;-)

> Question is, where does this belong ? kernel or userspace ?

I guess it depends on whether the remultiplexing takes place in hardware
or software (remapping of PIDs and generation of the joined SI data).

>> Why don't you just create a new device, e.g. ciX, deprecate the use of
>> caX for CI devices, inherit CI-related existing ioctls from the CA API,
>> translate the existing read and write funtions to ioctls and then use
>> read and write for TS I/O? IIRC, Ralph suggested something similar. I'm
>> pretty sure this can be done without too much code and in a backwards
>> compatible way.
> 
> 
> I'm open to this idea, but is there a consensus on this big API change ?
> (deprecating ca device) If yes, I will try to prepare something.

The existing API could be copied to linux/dvb/ci.h and then simplified
and reviewed.

- There's no need for a slot number. Just assign a device node to every
CI slot.
- CA_CI_PHYS is unused.
- ci.h doesn't need CA_DESCR, CA_SC, ca_descr_info_t, ca_caps_t,
ca_descr_t, ca_pid_t and accompanying ioctls.
- ca_slot_info.type should be an enum instead of a bitmask.
- ca_msg.index and ca_msg.type are probably unused
- Instead of a fixed length array, ca_msg.msg might as well just be a
pointer to a user allocated buffer
- Then, CA_GET_MSG should use _IOWR, because the maximum length must be
read inside the kernel.

Btw., does the av7110 really support two distinct CI slots?

Regards,
Andreas
