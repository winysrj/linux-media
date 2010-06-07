Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55665 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752239Ab0FGNQz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Jun 2010 09:16:55 -0400
Message-ID: <4C0CF124.4010103@redhat.com>
Date: Mon, 07 Jun 2010 10:16:20 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: vdr@helmutauer.de
CC: linux-media@vger.kernel.org
Subject: Re: v4l-dvb - Is it still usable for a distribution ?
References: <20100607112744.7B3B010FC20F@dd16922.kasserver.com>
In-Reply-To: <20100607112744.7B3B010FC20F@dd16922.kasserver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 07-06-2010 08:27, vdr@helmutauer.de escreveu:
> Hello List,
> 
> I have a Gentoo based VDR Distribution named Gen2VDR.
> As the name said its main application is VDR.
> Until kernel 2.6.33 I bundled the v4l-dvb drivers emerged via the gentoo ebuild with my distribution.
> Now with kernel 2.6.34 this doesn't work anymore, because v4l-dvb doesn't compile.

Douglas returned from this 2 week trip abroad and he is backporting the upstream stuff. Yesterday, he
reported to me that the tree is now compiling with 2.6.34.

> Another problem (after fixing the compile issues) is the IR Part of v4l-dvb which includes an Imon module.
> This module doesn't provide any lirc devices, so how can this oe be used as an IR device ?

You don't need lirc to use imon, since it now provides a standard input/event interface. So, the driver 
currently can be used with lirc event interface, or alone.

> Til now I am using lirc_imon which fit all my needs.

Lirc-dev patches are currently being discussed. There are just a few adjustments on it, in order to get it
finally merged. The kernel-userspace interface will likely need a few changes, so you'll likely need to update
lirc after the merge. Better to follow the IR threads at linux-media ML, in order to be in-tune with the changes.

> The final question for me:
> Does it make any sense anymore to stay with v4l-dvb or do I have to change to the kernel drivers ?
> The major disadvantage of the kernel drivers is the fact that I cannot switch to newer dvb drivers, I am stuck to the ones included in the kernel.

Well, this is something that you need to answer by yourself ;)

I don't recommend using a random snapshot of the tree on a distro package, as regressions may
happen during the development period.

Also, the backports are done at best efforts. There are no warranties, no QA and generally no 
tests with real hardware when a backport is done. So, while we hope that the backport will work, 
you may have a bug introduced on the backport stuff that may affect your card, not present
upstream.

IMHO, the better is to just upgrade to the next stable kernel. 

Another alternative is to manually apply on your distro the patches that you need there.
All patches with c/c to stable@kernel.org are bug fixes that needs to be backported to older
(stable) kernels. So, a good hint is to check for those stable patches. Unfortunately, not all
developers remind to add a c/c to stable. I try to do my best to re-tag those emails when
sending the patches upstream, but I generally opt to trust on the developers, since a fix may
apply only at the latest upstream kernel.

Cheers,
Mauro.
