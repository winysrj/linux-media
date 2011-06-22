Return-path: <mchehab@pedra>
Received: from ffm.saftware.de ([83.141.3.46]:43879 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757987Ab1FVOYG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jun 2011 10:24:06 -0400
Message-ID: <4E01FB01.8010708@linuxtv.org>
Date: Wed, 22 Jun 2011 16:24:01 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: HoP <jpetrous@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC] vtunerc - virtual DVB device driver
References: <BANLkTimtnbAzLTdFY2OiSddHTjmD_99CfA@mail.gmail.com>	<BANLkTin14LnwP+_K1m-RsEXza4M4CjqnEw@mail.gmail.com>	<BANLkTimR-zWnnLBcD2w8d8NpeFJi=eT9nQ@mail.gmail.com>	<005a01cc2f7d$a799be30$f6cd3a90$@coexsi.fr>	<BANLkTinbQ8oBJt7fScuT5vHGFktbaQNY5A@mail.gmail.com>	<BANLkTimTdMa_X1ygF8=B5gLdLXq1o-ER0g@mail.gmail.com>	<BANLkTimkZN9AtLanwvct+1p2DZOHSgF6Aw@mail.gmail.com>	<BANLkTimg0X5H5T8CsSR5Tr0CZbCZKiDEEA@mail.gmail.com>	<4DFFB1DA.5000602@redhat.com>	<BANLkTikZ++5dZssDRuxJzNUEG_TDkZPGRg@mail.gmail.com>	<4DFFF56D.5070602@redhat.com>	<4E007AA7.7070400@linuxtv.org>	<BANLkTik3ACfDwkyKVU2eZtxBeLH_mGh7pg@mail.gmail.com>	<4E00A78B.2020008@linuxtv.org>	<4E00AC2A.8060500@redhat.com>	<4E00B41B.50303@linuxtv.org>	<4E00D07B.5030202@redhat.com>	<BANLkTikmbVj1t7w3XmHXW58Kpvv0M_jbnQ@mail.gmail.com>	<4E01DD57.3080508@redhat.com> <BANLkTimpVu+Hz0j+WUmSAsyON4u=W3cr+g@mail.gmail.com> <4E01E81A.5030709@redhat.com> <4E01EA6E.1080002@linuxtv.! org> <4E01F1DE.2040609@redhat.com>
In-Reply-To: <4E01F1DE.2040609@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 06/22/2011 03:45 PM, Mauro Carvalho Chehab wrote:
> Em 22-06-2011 10:13, Andreas Oberritter escreveu:
>> On 06/22/2011 03:03 PM, Mauro Carvalho Chehab wrote:
>>> Em 22-06-2011 09:37, HoP escreveu:
>>>> 2011/6/22 Mauro Carvalho Chehab <mchehab@redhat.com>:
>>>>> Em 21-06-2011 14:38, HoP escreveu:
>>>>>> 2011/6/21 Mauro Carvalho Chehab <mchehab@redhat.com>:
[...]
>>>>>>> If people have different understandings, then we'll likely need to ask some
>>>>>>> support from Open source lawyers about this subject.
>>>>>>
>>>>>> My very little opinion is that waving GPL is way to the hell. Nobody told me
>>>>>> why similar technologies, in different kernel parts are acceptable,
>>>>>> but not here.
>>>>>
>>>>> If you want to do the networking code at userspace, why do you need a kernel
>>>>> driver after all? The proper solution is to write an userspace library for that,
>>>>> and either enclose such library inside the applications, or use LD_PRELOAD to
>>>>> bind the library to handle the open/close/ioctl glibc calls. libv4l does that.
>>>>> As it proofed to be a good library, now almost all V4L applications are using
>>>>> it.
>>>>
>>>> LD_PELOAD is out of bussiness for normal work. It is technique for development
>>>> and/or debugging.
>>>
>>> Well, libv4l successfully uses LD_PRELOAD in order to support all applications 
>>> that weren't ported to it yet. It offers two ways:
>>> 	1) you can use it as a normal library;
>>> 	2) you can use it with LD_PRELOAD.
>>>
>>>
>>>> Library would be possible, but then you kill main advantage
>>>> - totally independece of changes inside userland DVB applications.
>>>
>>> Why? if you write a "dvb_open", "dvb_ioctl", ... methods with the same syntax of
>>> glibc open, ioctl, ..., the efforts to migrate an userspace application to use it
>>> is to just run:
>>> 	sed s,open,dvb_open,g
>>> 	sed s,ioctl,dvb_ioctl,g
>>>
>>>
>>> The library and the application will be completely independent.
>>
>> How do you transparently set up the network parameters? By using
>> environment variables? How do you pass existing sockets to the library?
>> How do you intercept an open() that won't ever happen, because no
>> virtual device to be opened exists?
> 
> Sorry, but I failed to see at the vtunerc driver anything network-related.

Of course it doesn't. You're the one who proposed to put networking into
the driver. I however fail to see how you imagined to add remote tuner
support to any existing application by using LD_PRELOAD.

> Also, the picture shows that it is just acting as a proxy to an userspace code
> that it is actually handling the network conversion. The complete solution
> seems to have a kernel driver and an userspace client/daemon.

Right.

> Technically, doing such proxy in kernel is not a good idea, due to several
> reasons:
> 
> 1) The proxy code and the userspace network client will need to be tightly coupled:
> if you add a new feature at the proxy, the same feature will need to be supported by
> the userspace daemon;

Just like anything else DVB related inside the kernel.

Adding a new feature to the proxy would mean that a new feature got
added to the frontend API, so a new kernel would be required anyway.

> 2) Data will need to be using copy_from_user/copy_to_user for every data access;

Also, just like anything else DVB related inside the kernel.

No one would notice some frontend ioctl parameters being copied twice.
We're talking about a few bytes.

Passing the remote TS to the kernel is completely *optional*, and only
required if you want to use the kernel's demux or the underlying
hardware's filtering and decoding features. However, the TS even gets
filtered before being transferred over the network. So again, even if
used though being optional, this is not a big data rate.

> 3) There's no good reason to write such code inside kernelspace.
> 
> On a library based approach, what you'll have, instead is a library. The same
> userspace client/daemon will be needed. However, as both can be shipped together
> (the library proxy code and the userspace client/daemon), there are several
> advantages, like:
> 
> 1) The library and the userspace client will be in sync: there's no need to check
> for version differences at the api, or providing any sort of backport support;

Breaking the ABI of libraries isn't much better than breaking the ABI of
kernel interfaces. A library may have many users, more than "the
userspace client" you're talking about.

> 2) There's no need to recompile the kernel when someone wants to use the proxy;

You could of course build it as a module, without the need to recompile
the kernel.

> 3) The userspace won't be bound to the Kernel release schedule: When the code is
> stable enough, both libraries and userspace can be released at the same time.

For the same reason one could argue that putting device drivers into
userspace would have the same benefits.

Well, the original proposal was to add a driver with supporting programs
which enables every existing DVB application to *transparently* work
with remote tuners.

What you're proposing now is to write a library, which works with remote
tuners, too, but which requires manual integration into each and every
application.

By the way, if we had such a library, supported by every major
application, then it would be very easy to implement closed source
frontend drivers on top of it. ;-)

Regards,
Andreas
