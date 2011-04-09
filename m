Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54087 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754677Ab1DIQmp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Apr 2011 12:42:45 -0400
Received: by fxm17 with SMTP id 17so2865004fxm.19
        for <linux-media@vger.kernel.org>; Sat, 09 Apr 2011 09:42:43 -0700 (PDT)
Message-ID: <4DA08C80.5040205@suse.cz>
Date: Sat, 09 Apr 2011 18:42:40 +0200
From: Jiri Slaby <jslaby@suse.cz>
MIME-Version: 1.0
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: V4L/ARM: videobuf-dma-contig no longer works on my ARM machine
References: <201009301335.51643.jkrzyszt@tis.icnet.pl> <201104090333.52312.jkrzyszt@tis.icnet.pl> <20110409071624.GE5573@n2100.arm.linux.org.uk> <201104091711.00191.jkrzyszt@tis.icnet.pl>
In-Reply-To: <201104091711.00191.jkrzyszt@tis.icnet.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 04/09/2011 05:10 PM, Janusz Krzysztofik wrote:
> (CC: Jiri Slaby, the author of the problematic change; truncate subject)
> 
> On Sat, 09 Apr 2011, at 09:16:24, Russell King - ARM Linux wrote:
>> On Sat, Apr 09, 2011 at 03:33:39AM +0200, Janusz Krzysztofik wrote:
>>> Since there were no actual problems reported before, I suppose the
>>> old code, which was passing to remap_pfn_range() a physical page
>>> number calculated from dma_alloc_coherent() privided dma_handle,
>>> worked correctly on all platforms actually using
>>> videobud-dma-config.

No, it didn't when IOMMU was used. Because remap_pfn_range didn't get a
physical page address.

>>> Now, on my ARM machine, a completely
>>> different, then completely wrong physical address, calculated as
>>> virt_to_phys(dma_alloc_coherent()), is used instead of the
>>> dma_handle, which causes the machine to hang.
>>
>> virt_to_phys(dma_alloc_coherent()) is and always has been invalid,
>> and will break on several architectures apart from ARM.

Yes, the fix is broken for some archs. Feel free to revert it until it
is fixed properly.

Sound pcm mmap had a similar problem and solved that by a bit hackish
way (see snd_pcm_default_mmap).

I saw a discussion about how to sort it out in the sound subsystem and
do that in a clean manner. Maybe somebody else remembers where it was.

thanks,
-- 
js
suse labs
