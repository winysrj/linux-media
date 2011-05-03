Return-path: <mchehab@pedra>
Received: from connie.slackware.com ([64.57.102.36]:57957 "EHLO
	connie.slackware.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725Ab1ECEH5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 May 2011 00:07:57 -0400
Date: Mon, 2 May 2011 21:07:31 -0700 (PDT)
From: Robby Workman <rworkman@slackware.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
cc: Andreas Oberritter <obi@linuxtv.org>, linux-media@vger.kernel.org,
	Patrick Volkerding <volkerdi@slackware.com>,
	Hans De Goede <hdegoede@redhat.com>,
	linux-hotplug@vger.kernel.org
Subject: Re: [PATCHES] Misc. trivial fixes
In-Reply-To: <4DBF79B4.5040000@redhat.com>
Message-ID: <alpine.LNX.2.00.1105022103090.26390@connie.slackware.com>
References: <alpine.LNX.2.00.1104111908050.32072@connie.slackware.com> <4DA441D9.2000601@linuxtv.org> <alpine.LNX.2.00.1104120729280.7359@connie.slackware.com> <4DA5E957.3020702@linuxtv.org> <4DBF126D.6060807@redhat.com> <alpine.LNX.2.00.1105021926220.25339@connie.slackware.com>
 <4DBF79B4.5040000@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, 3 May 2011, Mauro Carvalho Chehab wrote:

> Em 02-05-2011 23:48, Robby Workman escreveu:
>> On Mon, 2 May 2011, Mauro Carvalho Chehab wrote:
>>
>>> Not sure what happened, but I lost the original email, so let me quote
>>> it from patchwork ID#699151.
>>>
>>>> Subject: [PATCHES] Misc. trivial fixes
>>>> Date: Tue, 12 Apr 2011 02:10:36 -0000
>>>> From: Robby Workman <rworkman@slackware.com>
>>>> X-Patchwork-Id: 699151
>>>> Message-Id: <alpine.LNX.2.00.1104111908050.32072@connie.slackware.com>
>>>> To: linux-media@vger.kernel.org
>>>>
>>>> Patch #1 installs udev rules files to /lib/udev/rules.d/ instead
>>>> of /etc/udev/rules.d/ - see commit message for more info.
>>>>
>>>> Patch #2 allows override of manpage installation directory by
>>>> packagers - see commit message for more info
>>>
>>> Please send each patch in-lined, one patch per email.
>>
>>
>> Okay, noted.  Should I resend, or is this for future reference?
>
> If you don't mind, please re-send it. Please c/c me, as we're having some
> troubles with patchwork nowadays.


Sure, will do in just a bit.


>>> Not all distros use /lib for it. In fact, RHEL5/RHEL6/Fedora 15 and Fedora rawhide
>>> all use /etc/udev/rules.d.
>>
>> If so, it's only older distros that I wouldn't expect to be packaging newer
>> versions of v4l-utils (e.g. RHEL won't as I understand it), and for Fedora,
>> if "rawhide" is devel tree, then I'm pretty sure you're mistaken.
>
> We've packaged v4l-utils for RHEL, via epel[1]. I volunteered to maintain it for RHEL6,
> as I use it on my machine and I would be doing it anyway for me, so better to maintain
> it for the others also ;)
>
> [1] https://admin.fedoraproject.org/pkgdb/acls/name/v4l-utils
>
> I don't intend to maintain it for RHEL5, but I was told that lots of mythtv users run
> CentOS (based on RHEL5).  So, I won't doubt if someone from CentOS (or other rpm repos
> for .el5, like atrpms) would add v4l-utils there.


Okay, fair enough.


> Do you know, by any chance, what's the minimal udev version where /lib/udev exists?
>
> If it is too old, then I agree that pointing the default to /lib/udev is the better.


Here's a casual look into udev's git log:

   commit 05b9640022d25a75923cc7809409914491a5f9da
   Author: Kay Sievers <kay.sievers@vrfy.org>
   Date:   Fri Jul 18 16:26:55 2008 +0200

       release 125

   ...

   commit 282988c4f8a85c28468e6442e86efe51dc71cc93
   Author: Kay Sievers <kay.sievers@vrfy.org>
   Date:   Fri Jul 18 15:56:03 2008 +0200

       move default rules from /etc/udev/rules.d/ to /lib/udev/rules.d/

   ...

So that's almost three years ago...

-RW
