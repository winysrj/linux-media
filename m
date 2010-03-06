Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54634 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754400Ab0CFDhs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Mar 2010 22:37:48 -0500
Message-ID: <4B91CE02.4090200@redhat.com>
Date: Sat, 06 Mar 2010 00:37:38 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: VDR User <user.vdr@gmail.com>,
	Theodore Kilgore <kilgota@banach.math.auburn.edu>,
	linux-media@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
Subject: Re: "Invalid module format"
References: <alpine.LNX.2.00.1003041737290.18039@banach.math.auburn.edu>	 <alpine.LNX.2.00.1003051829210.21417@banach.math.auburn.edu> <a3ef07921003051651j12fbae25r5a3d5276b7da43b7@mail.gmail.com> <4B91AADD.4030300@xenotime.net>
In-Reply-To: <4B91AADD.4030300@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Randy Dunlap wrote:
> On 03/05/10 16:51, VDR User wrote:
>> On Fri, Mar 5, 2010 at 4:39 PM, Theodore Kilgore
>> <kilgota@banach.math.auburn.edu> wrote:
>>> This is to report the good news that none of the above suspicions have
>>> panned out. I still do not know the exact cause of the problem, but a local
>>> compile and install of the 2.6.33 kernel did solve the problem. Hence, it
>>> does seem that the most likely origin of the problem is somewhere in the
>>> Slackware-current tree and the solution does not otherwise concern anyone on
>>> this list and does not need to be pursued here.
>> I experienced the same problem and posted a new thread about it with
>> the subject "Problem with v4l tree and kernel 2.6.33".  I'm a debian
>> user as well so apparently whatever is causing this is not specific to
>> debian or slackware.  Even though you've got it working now, the
>> source of the problem should be investigated.
>> --
> 
> It's been several years since I last saw this error and I don't recall
> what caused it then.
> 
> The message "Invalid module format" comes from either of modprobe and/or
> insmod when the kernel returns ENOEXEC to a module (load) syscall.
> Sometimes the kernel produces more explanatory messages  & sometimes not.
> 
> If there are no more explanatory messages, then kernel/module.c can be
> built with DEBUGP producing more output (and then that new kernel would
> have to be loaded).
> 
> Can one of you provide a kernel config file for a kernel/modprobe combination
> that produces this message?  Some of the CONFIG_MODULE* config symbols could
> have relevance here also.
> 


I suspect that it may be related to this:

# Select 32 or 64 bit
config 64BIT
        bool "64-bit kernel" if ARCH = "x86"
        default ARCH = "x86_64"
        ---help---
          Say yes to build a 64-bit kernel - formerly known as x86_64
          Say no to build a 32-bit kernel - formerly known as i386

With 2.6.33, it is now possible to compile a 32 bits kernel on a 64 bits
machine without needing to pass make ARCH=i386 or to use cross-compilation.

Maybe you're running a 32bits kernel, and you've compiled the out-of-tree
modules with 64bits or vice-versa.

My suggestion is that you should try to force the compilation wit the proper
ARCH with something like:
	make distclean
	make ARCH=`uname -i`
	make ARCH=`uname -i` install

-- 

Cheers,
Mauro
