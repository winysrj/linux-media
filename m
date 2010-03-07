Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:60371 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754678Ab0CGVkQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Mar 2010 16:40:16 -0500
Date: Sun, 7 Mar 2010 16:03:03 -0600 (CST)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: VDR User <user.vdr@gmail.com>
cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Randy Dunlap <rdunlap@xenotime.net>,
	linux-media@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
Subject: Re: "Invalid module format"
In-Reply-To: <a3ef07921003070955q7d7ce7e8j747c07d56a0ad98e@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1003071557020.23682@banach.math.auburn.edu>
References: <alpine.LNX.2.00.1003041737290.18039@banach.math.auburn.edu>  <alpine.LNX.2.00.1003051829210.21417@banach.math.auburn.edu>  <a3ef07921003051651j12fbae25r5a3d5276b7da43b7@mail.gmail.com>  <4B91AADD.4030300@xenotime.net> <4B91CE02.4090200@redhat.com>
 <a3ef07921003070955q7d7ce7e8j747c07d56a0ad98e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-863829203-743591034-1267999393=:23682"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---863829203-743591034-1267999393=:23682
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT



On Sun, 7 Mar 2010, VDR User wrote:

> On Fri, Mar 5, 2010 at 7:37 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> I suspect that it may be related to this:
>>
>> # Select 32 or 64 bit
>> config 64BIT
>>        bool "64-bit kernel" if ARCH = "x86"
>>        default ARCH = "x86_64"
>>        ---help---
>>          Say yes to build a 64-bit kernel - formerly known as x86_64
>>          Say no to build a 32-bit kernel - formerly known as i386
>>
>> With 2.6.33, it is now possible to compile a 32 bits kernel on a 64 bits
>> machine without needing to pass make ARCH=i386 or to use cross-compilation.
>>
>> Maybe you're running a 32bits kernel, and you've compiled the out-of-tree
>> modules with 64bits or vice-versa.
>>
>> My suggestion is that you should try to force the compilation wit the proper
>> ARCH with something like:
>>        make distclean
>>        make ARCH=`uname -i`
>>        make ARCH=`uname -i` install
>
> I had forgot to reply to this but while I do have a 64bit capable cpu,
> I compile & use only 32bit.
>

Hi,

It seems that the problem is solved by a local re-compile of the kernel 
plus its modules, using the original distro .config settings in order to 
do this. What I suspect has happened is that there was a simultaneous 
minor upgrade of gcc at the same time, and it is possible that this 
interfered. I would further speculate that a similar problem happened with 
you, in your Debian installation.

Hoping that we have finally tracked this down.

Theodore Kilgore
---863829203-743591034-1267999393=:23682--
