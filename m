Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:45321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751234Ab1FUMFp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jun 2011 08:05:45 -0400
Message-ID: <4E008909.1060909@redhat.com>
Date: Tue, 21 Jun 2011 09:05:29 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andreas Oberritter <obi@linuxtv.org>
CC: HoP <jpetrous@gmail.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	=?ISO-8859-1?Q?=22S=E9bastien_RAILLARD_=28COEXSI=29=22?=
	<sr@coexsi.fr>,
	=?ISO-8859-1?Q?R=E9mi_Denis-Courmont?= <remi@remlab.net>,
	linux-media@vger.kernel.org
Subject: Re: [RFC] vtunerc - virtual DVB device driver
References: <BANLkTimtnbAzLTdFY2OiSddHTjmD_99CfA@mail.gmail.com>	<201106202037.19535.remi@remlab.net>	<BANLkTinn0uN3VwGfqCbYbxFoVf6aNo1VSA@mail.gmail.com>	<BANLkTin14LnwP+_K1m-RsEXza4M4CjqnEw@mail.gmail.com>	<BANLkTimR-zWnnLBcD2w8d8NpeFJi=eT9nQ@mail.gmail.com>	<005a01cc2f7d$a799be30$f6cd3a90$@coexsi.fr>	<BANLkTinbQ8oBJt7fScuT5vHGFktbaQNY5A@mail.gmail.com>	<BANLkTimTdMa_X1ygF8=B5gLdLXq1o-ER0g@mail.gmail.com>	<BANLkTimkZN9AtLanwvct+1p2DZOHSgF6Aw@mail.gmail.com>	<BANLkTimg0X5H5T8CsSR5Tr0CZbCZKiDEEA@mail.gmail.com>	<4DFFB1DA.5000602@redhat.com> <BANLkTikZ++5dZssDRuxJzNUEG_TDkZPGRg@mail.gmail.com> <4DFFF56D.5070602@redhat.com> <4E007AA7.7070400@linuxtv.org>
In-Reply-To: <4E007AA7.7070400@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 21-06-2011 08:04, Andreas Oberritter escreveu:
> On 06/21/2011 03:35 AM, Mauro Carvalho Chehab wrote:
>> Em 20-06-2011 18:31, HoP escreveu:
>>> 2011/6/20 Mauro Carvalho Chehab <mchehab@redhat.com>:
>>>> Em 20-06-2011 17:24, HoP escreveu:
>>>>> 2011/6/20 Devin Heitmueller <dheitmueller@kernellabs.com>:
>>>>>> On Mon, Jun 20, 2011 at 3:56 PM, HoP <jpetrous@gmail.com> wrote:
>>>>>>> Do you think it is really serious enough reason to prevent of having
>>>>>>> such virtualization driver in the kernel?
>>>>>>>
>>>>>>> Let check my situation and tell me how I should continue (TBH, I already
>>>>>>> thought that driver can be accepted, but my dumb brain thought because
>>>>>>> of non quality code/design or so. It was really big "surprise" which
>>>>>>> reason was used aginst it):
>>>>>>
>>>>>> Yes, this is entirely a political issue and not a technical one.
>>>>>
>>>>> Political? So we can declare that politics win (again) technicians. Sad.
>>>>
>>>> This is not a political issue. It is a licensing issue. If you want to use
>>>> someone's else code, you need to accept the licensing terms that the developers
>>>> are giving you, by either paying the price for the code usage (on closed source
>>>> licensing models), or by accepting the license when using an open-sourced code.
>>>>
>>>> Preserving the open-source eco-system is something that everyone
>>>> developing open source expect: basically, you're free to do whatever
>>>> you want, but if you're using a code written by an open-source developer,
>>>> the expected behaviour that GPL asks (and that the developer wants, when he
>>>> opted for GPL) is that you should return back to the community with any
>>>> changes you did, including derivative work. This is an essential rule of working
>>>> with GPL.
>>>>
>>>> If you're not happy with that, that's fine. You can implement another stack
>>>> that is not GPL-licensed.
>>>
>>> Mauro, you totally misunderstood me. If you see on my first post in that thread
>>> I was sending full GPL-ed driver to the mailinglist.
>>
>> You misunderstood me. Something that exposes the kernel interface to for an
>> userspace client driver to implement DVB is not a driver, it is a wrapper.
>>
>> The real driver will be in userspace, using the DVB stack, and can even be
>> closed source. Some developers already tried to do things like that and sell
>> the userspace code. Such code submission were nacked. There is even one case
>> where the kernelspace code were dropped due to that (and later, replaced by an
>> opensource driver).
>>
>> We don't want to go on this way again.
> 
> Mauro and Devin, I think you're missing the point. This is not about
> creating drivers in userspace. This is not about open or closed source.
> The "vtuner" interface, as implemented for the Dreambox, is used to
> access remote tuners: Put x tuners into y boxes and access them from
> another box as if they were local. It's used in conjunction with further
> software to receive the transport stream over a network connection.
> Honza's code does the same thing.
> 
> You don't need it in order to create closed source drivers. You can
> already create closed kernel drivers now. Also, you can create tuner
> drivers in userspace using the i2c-dev interface. If you like to connect
> a userspace driver to a DVB API device node, you can distribute a small
> (open or closed) wrapper with it. So what are you arguing about?
> Everything you're feared of can already be done since virtually forever.

Yes, but we don't need to review/maintain a kernel driver meant to be
used by closed source applications, and, if they're using a GPL'd code
inside a closed source application, they can be sued.

I didn't review the patchset, but, from the description, I understood that
it were developed to use some Dreambox-specific closed source applications.
With such requirement, for me it is just a wrapper to some closed source
application.

That's said, I'm not against a driver that allows using a DVB kernel
driver by a DVB open source application either inside a virtual machine
or on a remote machine. This seems useful for me. So, if the code could
be turned into it, I'll review and consider for its inclusion upstream.

For that to happen, it should not try to use any Dreambox specific application
or protocol, but to just use the standard DVBv5 API, as you've pointed.

> If you're feared of exposing kernel interfaces to userspace, then I
> think your only option is to remove the whole userspace. You might want
> to remove i2c-dev and the loadable module interface first.
> 
> Regarding the code, Honza, I think the interface is neither clean nor
> generic enough to be included in the kernel. It doesn't make much sense
> to stay compatible to the interface used by the Dreambox. This interface
> evolved from very old versions of the DVB API and therefore carries way
> too much cruft and hacks for a shiny new interface. As a side note: Your
> ioctl constants already differ from the original vtuner code.
> 
> IMO, at least these steps need to be taken:
> - Remove unused code. You already mentioned it, but it really should be
> removed before submitting code, because it makes review much harder.
> - Remove redefined structs and constants.
> - Drop support for anything older than S2API.
> - Define a way to use an existing demux instead of registering a new
> software demux. On hardware that supports it, an input channel should be
> allocated for each vtuner, in order to use the hardware's filtering and
> decoding capabilities.
> - Drop VTUNER_SET_NAME, VTUNER_SET_HAS_OUTPUTS, VTUNER_SET_MODES,
> VTUNER_SET_TYPE and VTUNER_SET_NUM_MODES. They are all either specific
> to the Dreambox or already obsoleted by S2API commands or should be
> implemented as new S2API commands.
> 
> Regards,
> Andreas

