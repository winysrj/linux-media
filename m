Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:57867 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215Ab0CGQwy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Mar 2010 11:52:54 -0500
Date: Sun, 7 Mar 2010 11:15:55 -0600 (CST)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Randy Dunlap <rdunlap@xenotime.net>
cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	VDR User <user.vdr@gmail.com>, linux-media@vger.kernel.org,
	Hans de Goede <hdegoede@redhat.com>
Subject: Re: "Invalid module format"
In-Reply-To: <4B93D7EB.4080405@xenotime.net>
Message-ID: <alpine.LNX.2.00.1003071112350.23253@banach.math.auburn.edu>
References: <alpine.LNX.2.00.1003041737290.18039@banach.math.auburn.edu>  <alpine.LNX.2.00.1003051829210.21417@banach.math.auburn.edu> <a3ef07921003051651j12fbae25r5a3d5276b7da43b7@mail.gmail.com> <4B91AADD.4030300@xenotime.net> <4B91CE02.4090200@redhat.com>
 <alpine.LNX.2.00.1003052254200.21642@banach.math.auburn.edu> <4B93D7EB.4080405@xenotime.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Sun, 7 Mar 2010, Randy Dunlap wrote:

> On 03/05/10 22:48, Theodore Kilgore wrote:
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
>>
>> Mauro,
>>
>> After I did a re-compile of the kernel and modules, all the gspca stuff
>> (at least, what I tested which is two or three cameras) all worked just
>> fine. All I needed to do was make distclean and then make menuconfig
>> again and the gspca setup "saw" my new kernel. I made sure to know this
>> by putting up a slightly different name for it, using
>> CONFIG_LOCALVERSION= option. So I guess to this extent I used force, but
>> I did not need to do more than that.
>>
>>
>> Now, seeing if I can help further in tracking this thing down, here are
>> some more details.
>>
>> 1. As I said, the problem is fixed now, by a local re-compile of the
>> kernel (I did change a few things in the configuration and also cleared
>> out a lot of junk which has nothing to do with my hardware, of course).
>> So there might be some things of interest in the two config files.
>> Naturally, I can send them to anyone who would like to see them. But I
>> think that I cover the important differences below.
>>
>>
>> Additional comment: I probably could have taken the option of running
>> Slackware64 if I wanted to do that, because I suspect that my hardware
>> would support it. But I used regular Slackware. So the kernel, the
>> modules, and everything else are 32-bit, or supposed to be, though the
>> machine could run 64-bit.
>>
>> 2. According to what you are saying, here from my current config file is
>> what might be relevant
>>
>> # CONFIG_64BIT is not set
>> CONFIG_X86_32=y
>> # CONFIG_X86_64 is not set
>> CONFIG_X86=y
>> CONFIG_OUTPUT_FORMAT="elf32-i386"
>> CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
>>
>> and also it might possibly be important, too, that the processor type I
>> chose was
>>
>> CONFIG_MK8=y
>>
>> for the very good reason that this is what is in the machine. Also I cut
>> the choice for support of parallel CPUs down to 2 CPUs from 8 CPUs,
>> again because that is what is actually present.
>>
>> And furthermore my kernel config says
>>
>> CONFIG_LOCALVERSION="-my"
>>
>> and the original one says
>>
>> CONFIG_LOCALVERSION="-smp"
>>
>> so that I have two distinct sets of modules, 2.6.33-my and 2.6.33-smp
>> and I can go back and boot from the Slackware kernel to a functioning
>> machine, too.
>>
>> The kernel which I used from Slackware-current is one of the standard
>> ones, the one called vmlinuz-huge-smp-2.6.33-smp which comes in the
>> Slackware package called kernel-huge-smp-2.6.33_smp-i686-1.txz. Its
>> config file is in the package, too, so here are the similar parts of it:
>>
>> # CONFIG_64BIT is not set
>> CONFIG_X86_32=y
>> # CONFIG_X86_64 is not set
>> CONFIG_X86=y
>> CONFIG_OUTPUT_FORMAT="elf32-i386"
>> CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
>>
>> The above looks the same to me as my choices. But the CPU type was quite
>> different, of course, because it was a distro kernel.
>>
>> CONFIG_M686=y
>>
>> And the Slackware kernel also chose
>>
>> CONFIG_X86_GENERIC=y
>>
>> but when re-compiling I turned that off.
>
> Hey,
> How are these kconfig symbols set?
>
> CONFIG_MODULES
> CONFIG_MODULE_FORCE_LOAD
> CONFIG_MODULE_UNLOAD
> CONFIG_MODULE_FORCE_UNLOAD
> CONFIG_MODVERSIONS
> CONFIG_MODULE_SRCVERSION_ALL
>
> in both a working (distro?) kernel and in the failing kernel, please.

In the failing kernel,

CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set

In my locally compiled working kernel,

CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set

In other words, I did not touch those settings. They looked just fine to 
me. So I would guess the problem is somewhere else.

Theodore Kilgore
