Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58061 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753125Ab2E1McR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 May 2012 08:32:17 -0400
Message-ID: <4FC37042.4090903@redhat.com>
Date: Mon, 28 May 2012 09:32:02 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <snjw23@gmail.com>
Subject: Re: [RFC PATCH 0/3] Improve Kconfig selection for media devices
References: <4FC24E34.3000406@redhat.com> <1338137803-12231-1-git-send-email-mchehab@redhat.com> <20120528114803.0d1a4881@stein> <4FC363A5.1010802@redhat.com> <20120528141752.7e4c530e@stein>
In-Reply-To: <20120528141752.7e4c530e@stein>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 28-05-2012 09:17, Stefan Richter escreveu:
> On May 28 Mauro Carvalho Chehab wrote:
>> Em 28-05-2012 06:48, Stefan Richter escreveu:
>>> c) The RC_CORE_SUPP help text gives the impression that RC core is
>>> always needed if there is hardware with an IR feature.  But the firedtv
>>> driver is a case where the driver directly works on top of the input
>>> subsystem rather than on RC core.  Maybe there are more such cases.
>>
>> All other drivers use RC_CORE, as we've replaced the existing implementations
>> to use it, removing bad/inconsistent IR code implementations everywhere.
>> The only driver left is firedtv.
> [...]
>> The right thing to do is to convert drivers/media/dvb/firewire/firedtv-rc.c
>> to use rc-core. There are several issues with the current implementation:
>>
>> 	- IR keycode tables are hardcoded;
>> 	- There is a "magic" to convert a 16 bits scancode (NEC protocol?)
>> 	  into a key;
>> 	- There's no way to replace the existing table to an user-provided
>> 	  one;
> 
> There are two tables:  An old mapping and a new mapping.  The new mapping
> is copied into a newly allocated writable array.  It should be possible to
> overwrite this array by means of EVIOCSKEYCODE ioctls.

You can replace, but only if the keycode is inside the 0x0300-0x031f or 0x45xx
range:

void fdtv_handle_rc(struct firedtv *fdtv, unsigned int code)
{
...
	if (code >= 0x0300 && code <= 0x031f)
		code = keycode[code - 0x0300];
	else if (code >= 0x0340 && code <= 0x0354)
		code = keycode[code - 0x0320];
	else if (code >= 0x4501 && code <= 0x451f)
		code = oldtable[code - 0x4501];
	else if (code >= 0x4540 && code <= 0x4542)
		code = oldtable[code - 0x4521];
	else {
		printk(KERN_DEBUG "firedtv: invalid key code 0x%04x "
		       "from remote control\n", code);
		return;
	}

So, you can't, for example, get some other NEC remote controller and
use it there.

Also, the userspace IR tool won't recognize it as an IR, so the existing
tables at userspace can't be loaded.

> If I remember correctly, the firedtv driver sources came only with the old
> mapping table when they were submitted for upstream merge.  When I helped
> to clean up the driver, I noticed that the two FireDTV C/CI and T/CI (which
> I newly purchased at the time as test devices) emitted entirely different
> scan codes than what the sources suggested.  I suppose the original driver
> sources were written against older firmware or maybe older hardware
> revisions, possibly even prototype hardware.  We would have to get hold of
> the original authors if we wanted to find out.

It is very common to the vendors to replace the remote controllers that
are shipped together with the device.

Also, several advanced users prefer to not use the IR provided by the
vendor, but to use other IR's, assigning other keys to the driver to allow
them to control more things on their systems.

> Anyway, I implemented the new scancode->keycode mapping in a way that
> followed Dimitry's (?) review advice at that time, but left the old
> immutable mapping in there as fallback if an old scancode was received.

The newer way you used only works fine if the scancode table is not
sparsed. That's why you needed to remove the higher bits on your RC
handling code, generating a table with 34 elements.

The RC core dynamically allocates the scancode table in runtime, allowing
users to use very big or very short scan tables. It also doesn't waste
space with sparsed keycodes.

Users can even merge several different keytables together, in order to
allow the device to be used by different remote controllers, at the
same time.

> If it is a burden, we could rip out the old table and see if anybody
> complains.
> 
>> 	- The IR userspace tools won't work, as it doesn't export the
>> 	  needed sysfs nodes to report an IR.
> 
> But at least keypad/ keyboard related userspace should work.
> 
>> If you want, I can write a patch doing that, but I can't test it here, as
>> I don't have a firedtv device.
> 
> I can test such a patch as spare time permits if you point me to particular
> tools that I should test.

Ok, I'll write a patch for you to test.

Regards,
Mauro
