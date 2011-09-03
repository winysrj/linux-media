Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52744 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625Ab1ICNwA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 3 Sep 2011 09:52:00 -0400
Message-ID: <4E6230F9.6000803@redhat.com>
Date: Sat, 03 Sep 2011 10:51:53 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org, "'Pawel Osciak'" <pawel@osciak.com>
Subject: Re: [PATCH 1/2] videobuf2: Add a non-coherent contiguous DMA mode
References: <1310675711-39744-1-git-send-email-corbet@lwn.net> <1310675711-39744-2-git-send-email-corbet@lwn.net> <000001cc42b5$40c025f0$c24071d0$%szyprowski@samsung.com> <20110715083003.79802a49@bike.lwn.net> <00cb01cc4518$55c0c490$01424db0$%szyprowski@samsung.com> <20110722135547.5a0b38db@bike.lwn.net>
In-Reply-To: <20110722135547.5a0b38db@bike.lwn.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 22-07-2011 16:55, Jonathan Corbet escreveu:
>>> The problem is that there's no convenient callback into the allocators
>>> where the mapping and unmapping can be done now.  So I'd have had to add a
>>> couple of memops to do that.
>>
>> I think that some additional callbacks for allocators for synchronization
>> buffer state will be required sooner or later anyway, so imho it is better
>> to add them now to avoid massive fixing the drivers in the future.
> 
> OK, I can certainly do a version of the patch along those lines.  I'd
> envision some sort of give_buffer_to_device() and give_buffer_to_cpu()
> calls (with better names).  It'll take me a little while to get it done,
> though - travel and such are upon me.

Hi Jon,

I'm understanding that I can just mark those two patches as RFC at patchwork
and wait for your version two of those patchsets.

So, I'll just remove those two from my pending queue and move on ;)

Thanks,
mauro
