Return-path: <linux-media-owner@vger.kernel.org>
Received: from dd16922.kasserver.com ([85.13.137.202]:56856 "EHLO
	dd16922.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083Ab0FGVdU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jun 2010 17:33:20 -0400
Message-ID: <4C0D65A6.5050502@helmutauer.de>
Date: Mon, 07 Jun 2010 23:33:26 +0200
From: Helmut Auer <vdr@helmutauer.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: v4l-dvb - Is it still usable for a distribution ?
References: <20100607112744.7B3B010FC20F@dd16922.kasserver.com> <4C0CF124.4010103@redhat.com>
In-Reply-To: <4C0CF124.4010103@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello

>> Now with kernel 2.6.34 this doesn't work anymore, because v4l-dvb doesn't compile.
> 
> Douglas returned from this 2 week trip abroad and he is backporting the upstream stuff. Yesterday, he
> reported to me that the tree is now compiling with 2.6.34.
> 
Ok - I also got it compiling, but budget-ci is causing kernel oops (see other ML thread)
> 
>> The final question for me:
>> Does it make any sense anymore to stay with v4l-dvb or do I have to change to the kernel drivers ?
>> The major disadvantage of the kernel drivers is the fact that I cannot switch to newer dvb drivers, I am stuck to the ones included in the kernel.
> 
> Well, this is something that you need to answer by yourself ;)
> 
Thats not what I wanted to hear ;)

> I don't recommend using a random snapshot of the tree on a distro package, as regressions may
> happen during the development period.
> 
> Also, the backports are done at best efforts. There are no warranties, no QA and generally no 
> tests with real hardware when a backport is done. So, while we hope that the backport will work, 
> you may have a bug introduced on the backport stuff that may affect your card, not present
> upstream.
> 
> IMHO, the better is to just upgrade to the next stable kernel. 
> 
Ok -  that what I also thought
formerly v4l-dvb was the bleeding edge and the kernel draivers were about 2 Versions behind.
Now the kernel drivers are often the newer ones, so I have to switch.

> Another alternative is to manually apply on your distro the patches that you need there.
> All patches with c/c to stable@kernel.org are bug fixes that needs to be backported to older
> (stable) kernels. So, a good hint is to check for those stable patches. Unfortunately, not all
> developers remind to add a c/c to stable. I try to do my best to re-tag those emails when
> sending the patches upstream, but I generally opt to trust on the developers, since a fix may
> apply only at the latest upstream kernel.
> 
Thats surely an option, but an average user of my distri can't compile a kernel ;)
Emerging v4l-dvb is much easier ;)

-- 
Helmut Auer, helmut@helmutauer.de
