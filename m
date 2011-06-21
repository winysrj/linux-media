Return-path: <mchehab@pedra>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65025 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269Ab1FUMel (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jun 2011 08:34:41 -0400
Received: by iyb12 with SMTP id 12so2799519iyb.19
        for <linux-media@vger.kernel.org>; Tue, 21 Jun 2011 05:34:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E008909.1060909@redhat.com>
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
	<4E008909.1060909@redhat.com>
Date: Tue, 21 Jun 2011 14:34:40 +0200
Message-ID: <BANLkTi=gLfspK1b8WnoLVj6KfwRnm2qcBg@mail.gmail.com>
Subject: Re: [RFC] vtunerc - virtual DVB device driver
From: HoP <jpetrous@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Andreas Oberritter <obi@linuxtv.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	=?ISO-8859-1?Q?S=E9bastien_RAILLARD_=28COEXSI=29?= <sr@coexsi.fr>,
	=?ISO-8859-1?Q?R=E9mi_Denis=2DCourmont?= <remi@remlab.net>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

2011/6/21 Mauro Carvalho Chehab <mchehab@redhat.com>:
> Em 21-06-2011 08:04, Andreas Oberritter escreveu:
>> On 06/21/2011 03:35 AM, Mauro Carvalho Chehab wrote:
>>> Em 20-06-2011 18:31, HoP escreveu:
>>>> 2011/6/20 Mauro Carvalho Chehab <mchehab@redhat.com>:
>>>>> Em 20-06-2011 17:24, HoP escreveu:
>>>>>> 2011/6/20 Devin Heitmueller <dheitmueller@kernellabs.com>:
>>>>>>> On Mon, Jun 20, 2011 at 3:56 PM, HoP <jpetrous@gmail.com> wrote:
>>>>>>>> Do you think it is really serious enough reason to prevent of having
>>>>>>>> such virtualization driver in the kernel?
>>>>>>>>
>>>>>>>> Let check my situation and tell me how I should continue (TBH, I already
>>>>>>>> thought that driver can be accepted, but my dumb brain thought because
>>>>>>>> of non quality code/design or so. It was really big "surprise" which
>>>>>>>> reason was used aginst it):
>>>>>>>
>>>>>>> Yes, this is entirely a political issue and not a technical one.
>>>>>>
>>>>>> Political? So we can declare that politics win (again) technicians. Sad.
>>>>>
>>>>> This is not a political issue. It is a licensing issue. If you want to use
>>>>> someone's else code, you need to accept the licensing terms that the developers
>>>>> are giving you, by either paying the price for the code usage (on closed source
>>>>> licensing models), or by accepting the license when using an open-sourced code.
>>>>>
>>>>> Preserving the open-source eco-system is something that everyone
>>>>> developing open source expect: basically, you're free to do whatever
>>>>> you want, but if you're using a code written by an open-source developer,
>>>>> the expected behaviour that GPL asks (and that the developer wants, when he
>>>>> opted for GPL) is that you should return back to the community with any
>>>>> changes you did, including derivative work. This is an essential rule of working
>>>>> with GPL.
>>>>>
>>>>> If you're not happy with that, that's fine. You can implement another stack
>>>>> that is not GPL-licensed.
>>>>
>>>> Mauro, you totally misunderstood me. If you see on my first post in that thread
>>>> I was sending full GPL-ed driver to the mailinglist.
>>>
>>> You misunderstood me. Something that exposes the kernel interface to for an
>>> userspace client driver to implement DVB is not a driver, it is a wrapper.
>>>
>>> The real driver will be in userspace, using the DVB stack, and can even be
>>> closed source. Some developers already tried to do things like that and sell
>>> the userspace code. Such code submission were nacked. There is even one case
>>> where the kernelspace code were dropped due to that (and later, replaced by an
>>> opensource driver).
>>>
>>> We don't want to go on this way again.
>>
>> Mauro and Devin, I think you're missing the point. This is not about
>> creating drivers in userspace. This is not about open or closed source.
>> The "vtuner" interface, as implemented for the Dreambox, is used to
>> access remote tuners: Put x tuners into y boxes and access them from
>> another box as if they were local. It's used in conjunction with further
>> software to receive the transport stream over a network connection.
>> Honza's code does the same thing.
>>
>> You don't need it in order to create closed source drivers. You can
>> already create closed kernel drivers now. Also, you can create tuner
>> drivers in userspace using the i2c-dev interface. If you like to connect
>> a userspace driver to a DVB API device node, you can distribute a small
>> (open or closed) wrapper with it. So what are you arguing about?
>> Everything you're feared of can already be done since virtually forever.
>
> Yes, but we don't need to review/maintain a kernel driver meant to be
> used by closed source applications, and, if they're using a GPL'd code
> inside a closed source application, they can be sued.

Well, seems you are trying to argue using wrong arguments.
One more again: If you follow my picture - all on the path,
INCLUDING userland application, is GPL code. If you think
about Enigma, it is GPLed also, at least version 1. But my driver
is not for dreamboxes! They have similar implementation already
included there. My intention was different: to allow same thing
like is possible with dreamboxes, on "normal" linux PC desktop.
Using any other userland DVB application, like VDR or MythTV or vlc.
Got my point? I have nothing to do with any closed source or even
binary blobs! I want DVB adapter distribution across network,
nothing more. Everything is clear, from GPL point of view.

>
> I didn't review the patchset, but, from the description, I understood that
> it were developed to use some Dreambox-specific closed source applications.
> With such requirement, for me it is just a wrapper to some closed source
> application.

I understand that my English can be not crystal clear, so you missed
inside my description. But I must say it again - my code has zero
connection with dreamboxes. Of course other then borrowing theirs
sharing possibility and reusing same network daemons (again fully GPLed!)
for it.

>
> That's said, I'm not against a driver that allows using a DVB kernel
> driver by a DVB open source application either inside a virtual machine
> or on a remote machine. This seems useful for me. So, if the code could
> be turned into it, I'll review and consider for its inclusion upstream.

Then we should stop fighting and find some way for usual dialog.
My driver was born exactly wat that purpose - to virtualize remote
DVB adapter.

>
> For that to happen, it should not try to use any Dreambox specific application
> or protocol, but to just use the standard DVBv5 API, as you've pointed.

OK, If there is some change to not totally refuse such driver, then I will
be happy to refactor code this way.

/Honza
