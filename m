Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:53474 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416Ab1HPNPe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Aug 2011 09:15:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 8/9] ARM: integrate CMA with DMA-mapping subsystem
Date: Tue, 16 Aug 2011 15:14:52 +0200
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org,
	linaro-mm-sig@lists.linaro.org,
	"'Daniel Walker'" <dwalker@codeaurora.org>,
	"'Russell King'" <linux@arm.linux.org.uk>,
	"'Jonathan Corbet'" <corbet@lwn.net>,
	"'Mel Gorman'" <mel@csn.ul.ie>,
	"'Chunsang Jeong'" <chunsang.jeong@linaro.org>,
	"'Michal Nazarewicz'" <mina86@mina86.com>,
	"'Jesse Barker'" <jesse.barker@linaro.org>,
	"'Kyungmin Park'" <kyungmin.park@samsung.com>,
	"'Ankita Garg'" <ankita@in.ibm.com>,
	"'Shariq Hasnain'" <shariq.hasnain@linaro.org>,
	"'Andrew Morton'" <akpm@linux-foundation.org>,
	"'KAMEZAWA Hiroyuki'" <kamezawa.hiroyu@jp.fujitsu.com>
References: <1313146711-1767-1-git-send-email-m.szyprowski@samsung.com> <201108121700.30967.arnd@arndb.de> <002b01cc5bf7$0460e350$0d22a9f0$%szyprowski@samsung.com>
In-Reply-To: <002b01cc5bf7$0460e350$0d22a9f0$%szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108161514.52953.arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 16 August 2011, Marek Szyprowski wrote:
> On Friday, August 12, 2011 5:01 PM Arnd Bergmann wrote:

> > How about something like
> > 
> >       if (arch_is_coherent() || nommu())
> >               ret = alloc_simple_buffer();
> >       else if (arch_is_v4_v5())
> >               ret = alloc_remap();
> >       else if (gfp & GFP_ATOMIC)
> >               ret = alloc_from_pool();
> >       else
> >               ret = alloc_from_contiguous();
> > 
> > This also allows a natural conversion to dma_map_ops when we get there.
> 
> Ok. Is it ok to enable CMA permanently for ARMv6+? If CMA is left conditional
> the dma pool code will be much more complicated, because it will need to support
> both CMA and non-CMA cases.

I think that is ok, yes.

	Arnd
