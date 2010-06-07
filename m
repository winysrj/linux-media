Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61562 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752797Ab0FGWJH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Jun 2010 18:09:07 -0400
Message-ID: <4C0D6DE4.9090208@redhat.com>
Date: Mon, 07 Jun 2010 19:08:36 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Helmut Auer <vdr@helmutauer.de>
CC: linux-media@vger.kernel.org
Subject: Re: v4l-dvb - Is it still usable for a distribution ?
References: <20100607112744.7B3B010FC20F@dd16922.kasserver.com> <4C0CF124.4010103@redhat.com> <4C0D65A6.5050502@helmutauer.de>
In-Reply-To: <4C0D65A6.5050502@helmutauer.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 07-06-2010 18:33, Helmut Auer escreveu:
> Hello
> 
>>> Now with kernel 2.6.34 this doesn't work anymore, because v4l-dvb doesn't compile.
>>
>> Douglas returned from this 2 week trip abroad and he is backporting the upstream stuff. Yesterday, he
>> reported to me that the tree is now compiling with 2.6.34.
>>
> Ok - I also got it compiling, but budget-ci is causing kernel oops (see other ML thread)

There's already a patch for it at -git, but I suspect that Douglas didn't have time to backport the newer
87 patches that were committed there.

>>> The final question for me:
>>> Does it make any sense anymore to stay with v4l-dvb or do I have to change to the kernel drivers ?
>>> The major disadvantage of the kernel drivers is the fact that I cannot switch to newer dvb drivers, I am stuck to the ones included in the kernel.
>>
>> Well, this is something that you need to answer by yourself ;)
>>
> Thats not what I wanted to hear ;)

:)

>> I don't recommend using a random snapshot of the tree on a distro package, as regressions may
>> happen during the development period.
>>
>> Also, the backports are done at best efforts. There are no warranties, no QA and generally no 
>> tests with real hardware when a backport is done. So, while we hope that the backport will work, 
>> you may have a bug introduced on the backport stuff that may affect your card, not present
>> upstream.
>>
>> IMHO, the better is to just upgrade to the next stable kernel. 
>>
> Ok -  that what I also thought
> formerly v4l-dvb was the bleeding edge and the kernel draivers were about 2 Versions behind.
> Now the kernel drivers are often the newer ones, so I have to switch.

There's still a delay if you're getting the latest stable kernel, that ranges from 1 to 2 versions
for improvements, and a few weeks, for bug fixes. Eventually, you may provide -rc kernels as an 
alternative for those that needs the bleeding edge kernels and are brave enough ;)

>> Another alternative is to manually apply on your distro the patches that you need there.
>> All patches with c/c to stable@kernel.org are bug fixes that needs to be backported to older
>> (stable) kernels. So, a good hint is to check for those stable patches. Unfortunately, not all
>> developers remind to add a c/c to stable. I try to do my best to re-tag those emails when
>> sending the patches upstream, but I generally opt to trust on the developers, since a fix may
>> apply only at the latest upstream kernel.
>>
> Thats surely an option, but an average user of my distri can't compile a kernel ;)
> Emerging v4l-dvb is much easier ;)

Yes, but you may manually apply those patches from my git tree on your distro kernels. User will need to
emerge the kernel package. It will require you a little more work, or some magic script.

You may also keep using the -hg backport tree, but the delay is higher than before, since the
patches go first to -git.

Cheers,
Mauro. 

