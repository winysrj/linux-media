Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753547Ab1LBLO4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Dec 2011 06:14:56 -0500
Message-ID: <4ED8B327.9090505@redhat.com>
Date: Fri, 02 Dec 2011 09:14:47 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andreas Oberritter <obi@linuxtv.org>
CC: HoP <jpetrous@gmail.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC] vtunerc: virtual DVB device - is it ok to NACK driver because
 of worrying about possible misusage?
References: <CAJbz7-2T33c+2uTciEEnzRTaHF7yMW9aYKNiiLniH8dPUYKw_w@mail.gmail.com> <4ED6C5B8.8040803@linuxtv.org> <4ED75F53.30709@redhat.com> <CAJbz7-0td1FaDkuAkSGQRdgG5pkxjYMUGLDi0Y5BrBF2=6aVCw@mail.gmail.com> <4ED7BBA3.5020002@redhat.com> <CAJbz7-1_Nb8d427bOMzCDbRcvwQ3QjD=2KhdPQS_h_jaYY5J3w@mail.gmail.com> <4ED7E5D7.8070909@redhat.com> <4ED805CB.5020302@linuxtv.org>
In-Reply-To: <4ED805CB.5020302@linuxtv.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01-12-2011 20:55, Andreas Oberritter wrote:
> On 01.12.2011 21:38, Mauro Carvalho Chehab wrote:
>> I fail to see where do you need to duplicate dvb-core. An userspace
>> LD_PRELOAD handler that would do:
>>
>> int socket;
>>
>> int dvb_ioctl(int fd, unsigned long int request, ...)
>> {
>>          void *arg;
>>          va_list ap;
>>
>>          va_start(ap, request);
>>          arg = va_arg(ap, void *);
>>          va_end(ap);
>>
>>      send_net_ioctl_packet(socket, request, arg);
>> }
>>
>> Is probably all you need to send _any_ ioctl's to a remote machine
>> (plus client's machine that would decode the ioctl packet and send
>> the ioctl to the actual driver).
>>
>> Of course, you'll need hooks for all syscalls used (likely open, close,
>> ioctl, read, poll).
>>
>> So, there's not much duplication, even if, for whatever reason, you
>> might need to hook some specific ioctls in order to optimize the
>> network performance.
>
> Mauro, we've already had that discussion last time. In order to
> intercept ioctls of a device, the device needs to exist to begin with,
> right? That's where vtuner comes in: It creates the virtual device.

Yes.

> For that reason your suggested approach using LD_PRELOAD won't work.

If you're referring to the device name under /dev, a daemon emulating
a physical device could create Unix sockets under /dev/dvb.

Or (with is the right solution) bind such library into the applications
that will be used.

> Besides that, suggesting LD_PRELOAD for something other than a hack
> can't be taken seriously.

A Kernel pigback plugin is also a hack.

> I think you didn't even understand what vtuner does, after all the
> discussion that took place.
>
>>>>> Of course
>>>>> I can be wrong, I'm no big kernel hacker. So please show me the
>>>>> way for it. BTW, even if you can find the way, then data copying
>>>>> from userspace to the kernel and back is also necessery.
>>>>
>>>> See libv4l, at v4l2-utils.git (at linuxtv.org).
>>>>
>>>>> I really
>>>>> don't see any advantage of you solution.
>>>>
>>>> And I can't see any advantage on yours ;) Putting something that belongs
>>>> to userspace into kernelspace just because it is easier to re-use the
>>>> existing code inside the kernel is not a good argument.
>>>
>>> It is only your POV that it should be in userspace.
>>>
>>> Creating additional code which not only enlarge code size by 2
>>> but I think by 10 is really not good idea.  And it get no advantage
>>> only disadvantages.
>>>
>>>>
>>>> Don't get me wrong but if you want to submit a code to be merged
>>>> on any existing software (being open source or not), you should be
>>>> prepared to defend your code and justify the need for it to the
>>>> other developers.
>>>
>>> Sure. I was prepared for technical disscussion, but was fully suprised
>>> that it was not happend (ok, to be correct, few guys are exception, like
>>> Andreas and few others. I really appreciate it).
>>>
>>> So, my question was still not answered: "Can be driver NACKed only
>>> because of worrying about possible misuse?"
>>
>> To answer your question: your driver were nacked because of several
>> reasons:
>> it is not a driver for an unsupported hardware,
>
> It's not a driver for supported hardware either. You named it before:
> It's not a driver in your definition at all. It's a way to remotely
> access digital TV tuners over a network.

Yes, this is not a driver. It is just a hack to avoid adding network
support at the userspace applications.

>> you failed to convince
>> people
>> why this can't be implemented on userspace,
>
> Wrong. You failed to convince people why this must be implemented in
> userspace. Even Michael Krufky, who's "only" against merging it, likes
> the idea, because it's useful.

Sometimes, when I'm debugging a driver, I use to add several hacks inside
the kernelspace, in order to do things that are useful on my development
(debug printk's, dirty hacks, etc). I even have my own set of patches that
I apply on kvm, in order to sniff PCI traffic. This doesn't mean that
I should send all those crap upstream.

> Just because something can be implemented in userspace doesn't mean that
> it's technically superior.

True, but I didn't see anything at the submitted code or at the discussions
showing that implementing it in kernelspace is technically superior.

What I'm seeing is what is coded there:

	http://code.google.com/p/vtuner/

The kernelspace part is just a piggyback driver, that just copies data from/to
the dvb calls into another device, that sends the request back to userspace.

A separate userspace daemon will get such results and send to the network stack:
	http://code.google.com/p/vtuner/source/browse/vtuner-network.c?repo=apps

This is technically inferior of letting the application just talk to vtuner
directly via some library call.

Btw, applications like vdr, vlc, kaffeine and others already implement their
own ways to remotelly access the DVB devices without requiring any
kernelspace piggyback driver.

>> the driver adds hooks at
>> kernelspace
>> that would open internal API's that several developers don't agree on
>> exposing
>> at userspace, as would allow non GPL license compatible drivers to re-use
>> their work in a way they are against.
>
> What's left is your unreasonable GPL blah blah. So the answer to Honza's
> question is: Yes, Mauro is nacking the driver because he's worrying
> about possible misuse.
>
> Regards,
> Andreas

