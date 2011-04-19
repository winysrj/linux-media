Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55661 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771Ab1DSGI3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Apr 2011 02:08:29 -0400
Received: by bwz15 with SMTP id 15so4269180bwz.19
        for <linux-media@vger.kernel.org>; Mon, 18 Apr 2011 23:08:28 -0700 (PDT)
Message-ID: <4DAD26D9.6060906@suse.cz>
Date: Tue, 19 Apr 2011 08:08:25 +0200
From: Jiri Slaby <jslaby@suse.cz>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jiri Slaby <jirislaby@gmail.com>
Subject: [REVERT] Re: V4L: videobuf-dma-contig: fix mmap_mapper	broken on
 ARM
References: <201104122306.34909.jkrzyszt@tis.icnet.pl> <201104131252.32011.jkrzyszt@tis.icnet.pl> <20110413183231.GA23631@n2100.arm.linux.org.uk> <201104132256.40325.jkrzyszt@tis.icnet.pl> <20110413220008.GA23901@n2100.arm.linux.org.uk>
In-Reply-To: <20110413220008.GA23901@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 04/14/2011 12:00 AM, Russell King - ARM Linux wrote:
> On Wed, Apr 13, 2011 at 10:56:39PM +0200, Janusz Krzysztofik wrote:
>> Dnia środa 13 kwiecień 2011 o 20:32:31 Russell King - ARM Linux 
>> napisał(a):
>>> On Wed, Apr 13, 2011 at 12:52:31PM +0200, Janusz Krzysztofik wrote:
>>>> Taking into account that I'm just trying to fix a regression, and
>>>> not invent a new, long term solution: are you able to name an ARM
>>>> based board which a) is already supported in 2.6.39, b) is (or can
>>>> be) equipped with a device supported by a V4L driver which uses
>>>> videobuf- dma-config susbsystem, c) has a bus structure with which
>>>> virt_to_phys(bus_to_virt(dma_handle)) is not equal dma_handle?
>>>
>>> I have no idea - and why should whether someone can name something
>>> that may break be a justification to allow something which is
>>> technically wrong?
>>>
>>> Surely it should be the other way around - if its technically wrong
>>> and _may_ break something then it shouldn't be allowed.
>>
>> In theory - of course. In practice - couldn't we now, close to -rc3, 
>> relax the rules a little bit and stop bothering with something that may 
>> break in the future if it doesn't break on any board supported so far (I 
>> hope)?
> 
> If we are worried about closeness to -final, then what should happen is
> that the original commit is reverted; the "fix" for IOMMUs resulted in
> a regression for existing users which isn't trivial to resolve without
> risking possible breakage of other users.

Hi, as -rc4 is out, I think it's time to revert that commit and rethink
the mmap behaviour for some of next -rc1s.

Linus, please revert
commit 35d9f510b67b10338161aba6229d4f55b4000f5b
Author: Jiri Slaby <jslaby@suse.cz>
Date:   Mon Feb 28 06:37:02 2011 -0300

    [media] V4L: videobuf, don't use dma addr as physical
===

It fixes mmap when IOMMU is used on x86 only, but breaks architectures
like ARM or PPC where virt_to_phys(dma_alloc_coherent) doesn't work. We
need there dma_mmap_coherent or similar (the trickery what
snd_pcm_default_mmap does but in some saner way). But this cannot be
done at this phase.

thanks,
-- 
js
suse labs
