Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:44875 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756754Ab1FUOfg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jun 2011 10:35:36 -0400
Message-ID: <4E00AC2A.8060500@redhat.com>
Date: Tue, 21 Jun 2011 11:35:22 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andreas Oberritter <obi@linuxtv.org>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	HoP <jpetrous@gmail.com>,
	=?ISO-8859-1?Q?=22S=E9bastien_RAILLARD_=28COEXSI=29=22?=
	<sr@coexsi.fr>,
	=?ISO-8859-1?Q?R=E9mi_Denis-Courmont?= <remi@remlab.net>,
	linux-media@vger.kernel.org
Subject: Re: [RFC] vtunerc - virtual DVB device driver
References: <BANLkTimtnbAzLTdFY2OiSddHTjmD_99CfA@mail.gmail.com>	<201106202037.19535.remi@remlab.net>	<BANLkTinn0uN3VwGfqCbYbxFoVf6aNo1VSA@mail.gmail.com>	<BANLkTin14LnwP+_K1m-RsEXza4M4CjqnEw@mail.gmail.com>	<BANLkTimR-zWnnLBcD2w8d8NpeFJi=eT9nQ@mail.gmail.com>	<005a01cc2f7d$a799be30$f6cd3a90$@coexsi.fr>	<BANLkTinbQ8oBJt7fScuT5vHGFktbaQNY5A@mail.gmail.com>	<BANLkTimTdMa_X1ygF8=B5gLdLXq1o-ER0g@mail.gmail.com>	<BANLkTimkZN9AtLanwvct+1p2DZOHSgF6Aw@mail.gmail.com>	<BANLkTimg0X5H5T8CsSR5Tr0CZbCZKiDEEA@mail.gmail.com>	<4DFFB1DA.5000602@redhat.com>	<BANLkTikZ++5dZssDRuxJzNUEG_TDkZPGRg@mail.gmail.com>	<4DFFF56D.5070602@redhat.com>	<4E007AA7.7070400@linuxtv.org> <BANLkTik3ACfDwkyKVU2eZtxBeLH_mGh7pg@mail.gmail.com> <4E00A78B.2020008@linuxtv.org>
In-Reply-To: <4E00A78B.2020008@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 21-06-2011 11:15, Andreas Oberritter escreveu:
> On 06/21/2011 03:44 PM, Devin Heitmueller wrote:
>> On Tue, Jun 21, 2011 at 7:04 AM, Andreas Oberritter <obi@linuxtv.org> wrote:
>>> Mauro and Devin, I think you're missing the point. This is not about
>>> creating drivers in userspace. This is not about open or closed source.
>>> The "vtuner" interface, as implemented for the Dreambox, is used to
>>> access remote tuners: Put x tuners into y boxes and access them from
>>> another box as if they were local. It's used in conjunction with further
>>> software to receive the transport stream over a network connection.
>>> Honza's code does the same thing.
>>
>> I'm not missing the point at all.  I realize exactly what Honza is
>> trying to accomplish (and from a purely technical standpoint, it's not
>> a bad approach) - but I'm talking about the effects of such a driver
>> being introduced which changes the kernel/userland licensing boundary
>> and has very real implications with how the in-kernel code is
>> accessed.
>>
>>> You don't need it in order to create closed source drivers. You can
>>> already create closed kernel drivers now. Also, you can create tuner
>>> drivers in userspace using the i2c-dev interface. If you like to connect
>>> a userspace driver to a DVB API device node, you can distribute a small
>>> (open or closed) wrapper with it. So what are you arguing about?
>>> Everything you're feared of can already be done since virtually forever.
>>
>> I disagree.  There is currently no API which allows applications to
>> issue tuning requests into the DVB core, and have those requests
>> proxied back out to userland where an application can then use i2c-dev
>> to tune the actual device.  Meaning if somebody wants to write a
>> closed source userland application which controls the tuner, he/she
>> can do that (while not conforming to the DVB API).  But if if he wants
>> to reuse the GPL licensed DVB core, he has to replace the entire DVB
>> core.
>>
>> The introduction of this patch makes it trivial for a third party to
>> provide closed-source userland support for tuners while reusing all
>> the existing GPL driver code that makes up the framework.
>>
>> I used to work for a vendor that makes tuners, and they do a bunch of
>> Linux work.  And that work has resulted in a bunch of open source
>> drivers.  I can tell you though that *every* conversation I've had
>> regarding a new driver goes something like this:
>>
>> ===
>> "Devin, we need to support tuner X under Linux."
>>
>> "Great!  I'll be happy to write a new GPL driver for the
>> tuner/demodulator/whatever for that device"
>>
>> "But to save time/money, we just want to reuse the Windows driver code
>> (or reference code from the vendor)."
>>
>> "Ok.  Well, what is the licensing for that code?  Is it GPL compatible?"
>>
>> "Not currently.  So can we just make our driver closed source?"
>>
>> "Well, you can't reuse any of the existing DVB core functionality or
>> any of the other GPL drivers (tuners, bridges, demods), so you would
>> have rewrite all that from scratch."
>>
>> "Oh, that would be a ton of work.   Can we maybe write some userland
>> stuff that controls the demodulator which we can keep closed source?
>> Since it's not in the kernel, the GPL won't apply".
>>
>> "Well, you can't really do that because there is no way for the DVB
>> core to call back out to userland when the application makes the
>> tuning request to the DVB core."
>>
>> "Oh, ok then.  I guess we'll have to talk to the vendor and get them
>> to give us the reference driver code under the GPL."
>> ===
>>
>> I can tell you without a doubt that if this driver were present in the
>> kernel, that going forward that vendor would have *zero* interest in
>> doing any GPL driver work.  Why would they?  Why give away the code
>> which could potentially help their competitors if they can keep it
>> safe and protected while still being able to reuse everybody else's
>> contributions?
>>
>> Companies don't contribute GPL code out of "good will".  They do it
>> because they are compelled to by licenses or because there is no
>> economically viable alternative.
>>
>> Mauro, ultimately it is your decision as the maintainer which drivers
>> get accepted in to the kernel.  I can tell you though that this will
>> be a very bad thing for the driver ecosystem as a whole - it will
>> essentially make it trivial for vendors (some of which who are doing
>> GPL work now) to provide solutions that reuse the GPL'd DVB core
>> without having to make any of their stuff open source.
>>
>> Anyway, I said in my last email that would be my last email on the
>> topic.  I guess I lied.
> 
> Yes, and you did lie to your vendor, too, as you did not mention the
> possibilities to create
> 1.) closed source modules derived from existing vendor drivers while
> still being able to use other drivers (c.f. EXPORT_SYMBOL vs.
> EXPORT_SYMBOL_GPL).

AFAIK, the legal issues on writing a closed source driver using EXPORT_SYMBOL
are not proofed legally in any court. While EXPORT_SYMBOL_GPL explicitly 
adds a restriction, not using it doesn't necessarily mean that the symbol
can be used by a closed source driver. 

If you take a look at Kernel's COPYING file, the only exception to GPL license
allowed there is:

	 NOTE! This copyright does *not* cover user programs that use kernel
	 services by normal system calls - this is merely considered normal use
	 of the kernel, and does *not* fall under the heading of "derived work".

IANAL, but, as EXPORT_SYMBOL is not a "normal system call", my understanding is that
it is also covered by GPL.

I was told that several lawyers defend the idea that all software inside the
kernel tree is covered by GPL, even the aggregated ones. That was the rationale 
used to split the firmware packages from the kernel itself.

> 2.) a simple wrapper that calls userspace, therefore not having to open
> up any "secrets" at all.

A wrapper for a closed source driver is illegal, as it is trying to circumvent
the GPL license.

Mauro.
