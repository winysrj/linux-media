Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:44968 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757595Ab1FVNVE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jun 2011 09:21:04 -0400
Received: by iwn6 with SMTP id 6so669069iwn.19
        for <linux-media@vger.kernel.org>; Wed, 22 Jun 2011 06:21:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E01E63E.5030208@redhat.com>
References: <BANLkTimtnbAzLTdFY2OiSddHTjmD_99CfA@mail.gmail.com>
	<201106202037.19535.remi@remlab.net>
	<BANLkTinn0uN3VwGfqCbYbxFoVf6aNo1VSA@mail.gmail.com>
	<BANLkTin14LnwP+_K1m-RsEXza4M4CjqnEw@mail.gmail.com>
	<BANLkTimR-zWnnLBcD2w8d8NpeFJi=eT9nQ@mail.gmail.com>
	<005a01cc2f7d$a799be30$f6cd3a90$@coexsi.fr>
	<BANLkTinbQ8oBJt7fScuT5vHGFktbaQNY5A@mail.gmail.com>
	<BANLkTimTdMa_X1ygF8=B5gLdLXq1o-ER0g@mail.gmail.com>
	<BANLkTimkZN9AtLanwvct+1p2DZOHSgF6Aw@mail.gmail.com>
	<BANLkTimg0X5H5T8CsSR5Tr0CZbCZKiDEEA@mail.gmail.com>
	<4DFFB1DA.5000602@redhat.com>
	<BANLkTikZ++5dZssDRuxJzNUEG_TDkZPGRg@mail.gmail.com>
	<4DFFF56D.5070602@redhat.com>
	<4E007AA7.7070400@linuxtv.org>
	<BANLkTik3ACfDwkyKVU2eZtxBeLH_mGh7pg@mail.gmail.com>
	<4E00A78B.2020008@linuxtv.org>
	<4E00AC2A.8060500@redhat.com>
	<4E00B41B.50303@linuxtv.org>
	<4E00D07B.5030202@redhat.com>
	<BANLkTikmbVj1t7w3XmHXW58Kpvv0M_jbnQ@mail.gmail.com>
	<4E01DD57.3080508@redhat.com>
	<4E01E05C.5000809@linuxtv.org>
	<4E01E63E.5030208@redhat.com>
Date: Wed, 22 Jun 2011 15:21:03 +0200
Message-ID: <BANLkTinkp1=p2u7vj+=2pDXT6OjOEF9-KQ@mail.gmail.com>
Subject: Re: [RFC] vtunerc - virtual DVB device driver
From: HoP <jpetrous@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Andreas Oberritter <obi@linuxtv.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

2011/6/22 Mauro Carvalho Chehab <mchehab@redhat.com>:
> Em 22-06-2011 09:30, Andreas Oberritter escreveu:
>> On 06/22/2011 02:17 PM, Mauro Carvalho Chehab wrote:
>>> Em 21-06-2011 14:38, HoP escreveu:
>>>> 2011/6/21 Mauro Carvalho Chehab <mchehab@redhat.com>:
>>>>> Em 21-06-2011 12:09, Andreas Oberritter escreveu:
>>>>>> On 06/21/2011 04:35 PM, Mauro Carvalho Chehab wrote:
>>>>>>> Em 21-06-2011 11:15, Andreas Oberritter escreveu:
>>>>>>>> On 06/21/2011 03:44 PM, Devin Heitmueller wrote:
>>>>>>>>> On Tue, Jun 21, 2011 at 7:04 AM, Andreas Oberritter <obi@linuxtv.org> wrote:
>>>>>>>>>> Mauro and Devin, I think you're missing the point. This is not about
>>>>>>>>>> creating drivers in userspace. This is not about open or closed source.
>>>>>>>>>> The "vtuner" interface, as implemented for the Dreambox, is used to
>>>>>>>>>> access remote tuners: Put x tuners into y boxes and access them from
>>>>>>>>>> another box as if they were local. It's used in conjunction with further
>>>>>>>>>> software to receive the transport stream over a network connection.
>>>>>>>>>> Honza's code does the same thing.
>>>>>>>>>
>>>>>>>>> I'm not missing the point at all.  I realize exactly what Honza is
>>>>>>>>> trying to accomplish (and from a purely technical standpoint, it's not
>>>>>>>>> a bad approach) - but I'm talking about the effects of such a driver
>>>>>>>>> being introduced which changes the kernel/userland licensing boundary
>>>>>>>>> and has very real implications with how the in-kernel code is
>>>>>>>>> accessed.
>>>>>>>>>
>>>>>>>>>> You don't need it in order to create closed source drivers. You can
>>>>>>>>>> already create closed kernel drivers now. Also, you can create tuner
>>>>>>>>>> drivers in userspace using the i2c-dev interface. If you like to connect
>>>>>>>>>> a userspace driver to a DVB API device node, you can distribute a small
>>>>>>>>>> (open or closed) wrapper with it. So what are you arguing about?
>>>>>>>>>> Everything you're feared of can already be done since virtually forever.
>>>>>>>>>
>>>>>>>>> I disagree.  There is currently no API which allows applications to
>>>>>>>>> issue tuning requests into the DVB core, and have those requests
>>>>>>>>> proxied back out to userland where an application can then use i2c-dev
>>>>>>>>> to tune the actual device.  Meaning if somebody wants to write a
>>>>>>>>> closed source userland application which controls the tuner, he/she
>>>>>>>>> can do that (while not conforming to the DVB API).  But if if he wants
>>>>>>>>> to reuse the GPL licensed DVB core, he has to replace the entire DVB
>>>>>>>>> core.
>>>>>>>>>
>>>>>>>>> The introduction of this patch makes it trivial for a third party to
>>>>>>>>> provide closed-source userland support for tuners while reusing all
>>>>>>>>> the existing GPL driver code that makes up the framework.
>>>>>>>>>
>>>>>>>>> I used to work for a vendor that makes tuners, and they do a bunch of
>>>>>>>>> Linux work.  And that work has resulted in a bunch of open source
>>>>>>>>> drivers.  I can tell you though that *every* conversation I've had
>>>>>>>>> regarding a new driver goes something like this:
>>>>>>>>>
>>>>>>>>> ===
>>>>>>>>> "Devin, we need to support tuner X under Linux."
>>>>>>>>>
>>>>>>>>> "Great!  I'll be happy to write a new GPL driver for the
>>>>>>>>> tuner/demodulator/whatever for that device"
>>>>>>>>>
>>>>>>>>> "But to save time/money, we just want to reuse the Windows driver code
>>>>>>>>> (or reference code from the vendor)."
>>>>>>>>>
>>>>>>>>> "Ok.  Well, what is the licensing for that code?  Is it GPL compatible?"
>>>>>>>>>
>>>>>>>>> "Not currently.  So can we just make our driver closed source?"
>>>>>>>>>
>>>>>>>>> "Well, you can't reuse any of the existing DVB core functionality or
>>>>>>>>> any of the other GPL drivers (tuners, bridges, demods), so you would
>>>>>>>>> have rewrite all that from scratch."
>>>>>>>>>
>>>>>>>>> "Oh, that would be a ton of work.   Can we maybe write some userland
>>>>>>>>> stuff that controls the demodulator which we can keep closed source?
>>>>>>>>> Since it's not in the kernel, the GPL won't apply".
>>>>>>>>>
>>>>>>>>> "Well, you can't really do that because there is no way for the DVB
>>>>>>>>> core to call back out to userland when the application makes the
>>>>>>>>> tuning request to the DVB core."
>>>>>>>>>
>>>>>>>>> "Oh, ok then.  I guess we'll have to talk to the vendor and get them
>>>>>>>>> to give us the reference driver code under the GPL."
>>>>>>>>> ===
>>>>>>>>>
>>>>>>>>> I can tell you without a doubt that if this driver were present in the
>>>>>>>>> kernel, that going forward that vendor would have *zero* interest in
>>>>>>>>> doing any GPL driver work.  Why would they?  Why give away the code
>>>>>>>>> which could potentially help their competitors if they can keep it
>>>>>>>>> safe and protected while still being able to reuse everybody else's
>>>>>>>>> contributions?
>>>>>>>>>
>>>>>>>>> Companies don't contribute GPL code out of "good will".  They do it
>>>>>>>>> because they are compelled to by licenses or because there is no
>>>>>>>>> economically viable alternative.
>>>>>>>>>
>>>>>>>>> Mauro, ultimately it is your decision as the maintainer which drivers
>>>>>>>>> get accepted in to the kernel.  I can tell you though that this will
>>>>>>>>> be a very bad thing for the driver ecosystem as a whole - it will
>>>>>>>>> essentially make it trivial for vendors (some of which who are doing
>>>>>>>>> GPL work now) to provide solutions that reuse the GPL'd DVB core
>>>>>>>>> without having to make any of their stuff open source.
>>>>>>>>>
>>>>>>>>> Anyway, I said in my last email that would be my last email on the
>>>>>>>>> topic.  I guess I lied.
>>>>>>>>
>>>>>>>> Yes, and you did lie to your vendor, too, as you did not mention the
>>>>>>>> possibilities to create
>>>>>>>> 1.) closed source modules derived from existing vendor drivers while
>>>>>>>> still being able to use other drivers (c.f. EXPORT_SYMBOL vs.
>>>>>>>> EXPORT_SYMBOL_GPL).
>>>>>>>
>>>>>>> AFAIK, the legal issues on writing a closed source driver using EXPORT_SYMBOL
>>>>>>> are not proofed legally in any court. While EXPORT_SYMBOL_GPL explicitly
>>>>>>> adds a restriction, not using it doesn't necessarily mean that the symbol
>>>>>>> can be used by a closed source driver.
>>>>>>>
>>>>>>> If you take a look at Kernel's COPYING file, the only exception to GPL license
>>>>>>> allowed there is:
>>>>>>>
>>>>>>>       NOTE! This copyright does *not* cover user programs that use kernel
>>>>>>>       services by normal system calls - this is merely considered normal use
>>>>>>>       of the kernel, and does *not* fall under the heading of "derived work".
>>>>>>>
>>>>>>> IANAL, but, as EXPORT_SYMBOL is not a "normal system call", my understanding is that
>>>>>>> it is also covered by GPL.
>>>>>>
>>>>>> Of course. But as you should know, the GPL only covers derived work.
>>>>>> Whether or not a driver is a derived work of the kernel can only be
>>>>>> decided individually. It is my understanding that a Windows driver
>>>>>> ported to Linux is unlikely to be a derived work of Linux.
>>>>>>
>>>>>>> I was told that several lawyers defend the idea that all software inside the
>>>>>>> kernel tree is covered by GPL, even the aggregated ones. That was the rationale
>>>>>>> used to split the firmware packages from the kernel itself.
>>>>>>
>>>>>> However, I wasn't referring to the kernel tree at all.
>>>>>>
>>>>>>>> 2.) a simple wrapper that calls userspace, therefore not having to open
>>>>>>>> up any "secrets" at all.
>>>>>>>
>>>>>>> A wrapper for a closed source driver is illegal, as it is trying to circumvent
>>>>>>> the GPL license.
>>>>>>
>>>>>> Is it? First, you are not a lawyer. Second, a wrapper is unlikely to be
>>>>>> illegal by its pure existence and a wrapper does usually not try to do
>>>>>> anything by itself. Third, you can implement a wrapper using normal
>>>>>> system calls (read, write, mmap, ioctl ...). That's what vtuner does,
>>>>>> too, to accomplish a totally different goal. Do you think vtuner is
>>>>>> illegal? I would be very surprised if it was. It perfectly matches the
>>>>>> license exception cited above. And even without the exception, a closed
>>>>>> driver in userspace would only very unlikely be a derived work of the
>>>>>> kernel.
>>>>>
>>>>> I think we're diverging from the subject. Most of those discussions are
>>>>> interesting on some lawyers forum, not here.
>>>>>
>>>>> My view about this subject is that vtuner can't give any additional permissions
>>>>> to the kernel GPL'd code, as vtuner were not made by the Kernel Copyright owners,
>>>>> nor were approved by them. So, the extra permission at the COPYING clause
>>>>> from kernel doesn't apply here, while the code is not merged into the Kernel.
>>>>>
>>>>> So, while it should be legal to use vtuner with a GPL'd client application,
>>>>> using it by a closed source application violates GPL.
>>>>>
>>>>> My understanding is that an addition of a code that exposes the internal
>>>>> DVB core API to userspace like that will require that all dvb developers
>>>>> that have copyright rights at the dvb core should explicitly ack with such
>>>>> change, otherwise adding such code will violate the original license.
>>>>>
>>>>> On the other hand, if vtunerc won't act as a proxy to userspace, it should
>>>>> probably be ok.
>>>>
>>>> Are you serious? Why there is not same violation on NFS? Or even beter
>>>> example NBD (network block device)? It sits in kernel for ages and nobody
>>>> cares. It looks for me like you should send some patch for removal such
>>>> "weak" places in kernel which allow to violate GPL.
>>>>
>>>> Do you really think that it is possible (in real, no in threory) to create
>>>> any networked subsystem for sharing anything over net the way
>>>> when it is not exposed (somehow) to the userspace? How will be
>>>> such system managable? Why there is usually companion daemon
>>>> there, which is responsible for managing connections etc?
>>>>
>>>> I think it is very evident you want find the way how to get yours word
>>>> back and return to your original position = such code is not acceptable.
>>>> Even if you still are not able to give anything clear.
>>>>
>>>> If I understand your last few mails, you won't accept such driver, isn't it?
>>>
>>> You got wrong. You can't change someone's else license without their acks.
>>> It is as simple as that. Getting everybody's ack is not that hard, if they
>>> accept that what you're doing is the right thing. We've got everybody's
>>> ack in the past to change the licensing for videodev2.h for example, to allow
>>> using the V4L2 API under BSD license (just the license API was changed, not the
>>> code itself).
>>
>> Is there anybode else who thinks that adding GPL'd code to the GPL'd
>> kernel would require any change in licensing? This is insane. What
>> change to whose license are you referring to, please?
>
> Kernel licensing is not a pure GPL license. If it were a pure GPL license, all software
> that would run on the top of it would need to also be released under GPL.
>
> Kernel license is GPLv2 + additional rights to allow binary code to run on the top
> of it, for the system calls that are introduced in order to allow the usage of
> the hardware resources managed by the Kernel (drivers, network, memory, CPU's, etc).
>
> There are no doubts that dvb developers wanted their drivers to be controlled from
> userspace, but, from previous discussions about this subject, several developers
> explicitly said that they didn't want to allow any kind of wrapper module to be added.

OK, if I even accede to your (rather strange) argument, then, staying strongly
on licencing rules - can you answer me if such "discussions" has any lawyer
base? I didn't see anything like "code is released under GPL2 with one exception
- no wrappers, please" in any commit. My really weak knowledge of GPL
make me wonder
if it is possible.

And of course - you wording about wrapper. Then every other
virtualization driver
can be named wrapper. But it is still driver, if you like it or nope.

/Honza
