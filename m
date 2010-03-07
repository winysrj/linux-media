Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:37195 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215Ab0CGQcd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Mar 2010 11:32:33 -0500
Date: Sun, 7 Mar 2010 10:55:34 -0600 (CST)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
cc: Randy Dunlap <rdunlap@xenotime.net>, VDR User <user.vdr@gmail.com>,
	linux-media@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
Subject: Re: "Invalid module format"
In-Reply-To: <4B93AA91.3000706@redhat.com>
Message-ID: <alpine.LNX.2.00.1003071039100.23253@banach.math.auburn.edu>
References: <alpine.LNX.2.00.1003041737290.18039@banach.math.auburn.edu>  <alpine.LNX.2.00.1003051829210.21417@banach.math.auburn.edu> <a3ef07921003051651j12fbae25r5a3d5276b7da43b7@mail.gmail.com> <4B91AADD.4030300@xenotime.net> <4B91CE02.4090200@redhat.com>
 <alpine.LNX.2.00.1003061542170.22433@banach.math.auburn.edu> <4B93AA91.3000706@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Sun, 7 Mar 2010, Mauro Carvalho Chehab wrote:

> Theodore Kilgore wrote:
>>
>>
>> On Sat, 6 Mar 2010, Mauro Carvalho Chehab wrote:
>>
>>> Randy Dunlap wrote:
>>>> On 03/05/10 16:51, VDR User wrote:
>>>>> On Fri, Mar 5, 2010 at 4:39 PM, Theodore Kilgore
>>>>> <kilgota@banach.math.auburn.edu> wrote:
>>>>>> This is to report the good news that none of the above suspicions have
>>>>>> panned out. I still do not know the exact cause of the problem, but
>>>>>> a local
>>>>>> compile and install of the 2.6.33 kernel did solve the problem.
>>>>>> Hence, it
>>>>>> does seem that the most likely origin of the problem is somewhere
>>>>>> in the
>>>>>> Slackware-current tree and the solution does not otherwise concern
>>>>>> anyone on
>>>>>> this list and does not need to be pursued here.
>>>>> I experienced the same problem and posted a new thread about it with
>>>>> the subject "Problem with v4l tree and kernel 2.6.33".  I'm a debian
>>>>> user as well so apparently whatever is causing this is not specific to
>>>>> debian or slackware.  Even though you've got it working now, the
>>>>> source of the problem should be investigated.
>>>>> --
>>>>
>>>> It's been several years since I last saw this error and I don't recall
>>>> what caused it then.
>>>>
>>>> The message "Invalid module format" comes from either of modprobe and/or
>>>> insmod when the kernel returns ENOEXEC to a module (load) syscall.
>>>> Sometimes the kernel produces more explanatory messages  & sometimes
>>>> not.
>>>>
>>>> If there are no more explanatory messages, then kernel/module.c can be
>>>> built with DEBUGP producing more output (and then that new kernel would
>>>> have to be loaded).
>>>>
>>>> Can one of you provide a kernel config file for a kernel/modprobe
>>>> combination
>>>> that produces this message?  Some of the CONFIG_MODULE* config
>>>> symbols could
>>>> have relevance here also.
>>>>
>>>
>>>
>>> I suspect that it may be related to this:
>>>
>>> # Select 32 or 64 bit
>>> config 64BIT
>>>        bool "64-bit kernel" if ARCH = "x86"
>>>        default ARCH = "x86_64"
>>>        ---help---
>>>          Say yes to build a 64-bit kernel - formerly known as x86_64
>>>          Say no to build a 32-bit kernel - formerly known as i386
>>>
>>> With 2.6.33, it is now possible to compile a 32 bits kernel on a 64 bits
>>> machine without needing to pass make ARCH=i386 or to use
>>> cross-compilation.
>>>
>>> Maybe you're running a 32bits kernel, and you've compiled the out-of-tree
>>> modules with 64bits or vice-versa.
>>>
>>> My suggestion is that you should try to force the compilation wit the
>>> proper
>>> ARCH with something like:
>>>     make distclean
>>>     make ARCH=`uname -i`
>>>     make ARCH=`uname -i` install
>>>
>>> --
>>>
>>> Cheers,
>>> Mauro
>>>
>>
>> Mauro,
>>
>> I do not know where this leads, but here is a second answer with another
>> piece of information.
>>
>> I mentioned yesterday that I have at this point two kernels, called
>> 2.6.33-smp and 2.6.33-my. The 2.6.33-smp is the stock Slackware-current
>> kernel, and the 2.6.33-my is locally compiled, with somewhat different
>> config parameters. Each of these has its module tree, independent of the
>> other. By which I mean that I have a module tree
>>
>> lib/modules/2.6.33-smp associated with kernel 2.6.33-smp
>>
>> and another module tree
>>
>> lib/modules/2/6/33-my associated with kernel 2.6.33-my
>>
>> I started out, of course, by installing the gspca modules in
>> lib/modules/2.6.33-smp and thereby I presumably over-wrote things in
>> lib/modules/2.6.33-smp/kernel/drivers/media which were present in the
>> 2.6.33-smp module package from the distro.
>>
>> Now, today I did a reinstallation of the 2.6.33-smp modules tree and
>> booted with 2.6.33-smp. I did *not* do anything to change the what was
>> there. For example, I did not install anything from any gspca mercurial
>> tree. No, only what comes with the distro kernel's modules is there.
>>
>> Now, here is what happens under these circumstances:
>>
>> root@khayyam:/lib/modules/2.6.33-smp/kernel# modprobe gspca_main
>> WARNING: Error inserting v4l1_compat
>> (/lib/modules/2.6.33-smp/kernel/drivers/media/video/v4l1-compat.ko):
>> Invalid module format
>> WARNING: Error inserting videodev
>> (/lib/modules/2.6.33-smp/kernel/drivers/media/video/videodev.ko):
>> Invalid module format
>> FATAL: Error inserting gspca_main
>> (/lib/modules/2.6.33-smp/kernel/drivers/media/video/gspca/gspca_main.ko):
>> Invalid module format
>> root@khayyam:/lib/modules/2.6.33-smp/kernel#
>>
>> In other words, the same error message as yesterday. But this time the
>> module I was trying to load up was not created by me, but instead it was
>> the one obtained from the distro kernel's modules.
>>
>> Strangely, though, some of the other modules which came with the distro
>> kernel _do_ work. Some of them are essential for running the machine,
>> and they are doing just fine.
>
> Interesting. Are you sure you didn't mixed distro kernels with the ones you've compiled
> on your re-installation?

Yes.

In other words, had you removed the old /lib/modules/2.6.33-smp/
> directory before re-installing it from your distro?

Yes.

If so, then it seems that distro is
> providing some broken modules.

It appears so. Yes.

However, in fairness to the distro, which I am not about to quit using, I 
am running the "-current" version, which is distributed with the explicit 
warning that stuff might occasionally be broken. And even with this 
warning this is the first time that I have any serious problem in several 
years. One does need to take things like this in perspective.

For two reasons I continue to pursue the problem here, though.

First, it is exactly the case that there are "some" broken modules and not 
others. And those which appear to be broken are exactly those connected 
with drivers/media, no matter whether these modules came from the distro 
kernel or came from a local compile off of a gspca development tree.

Second, it is reported here a couple of days ago, in response to my 
original message, that someone else has had the same or similar problem 
with 2.6.33 on Debian.

Because of the above two reasons, it appears to me that there might 
possibly be some deeper problem which needs to be looked into. I do not 
claim to know exactly which way to look, but it seems that there might be 
something to look for.

Theodore Kilgore

