Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:54369 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870Ab1HLMxq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Aug 2011 08:53:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 7/9] ARM: DMA: steal memory for DMA coherent mappings
Date: Fri, 12 Aug 2011 14:53:05 +0200
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org,
	linaro-mm-sig@lists.linaro.org,
	Michal Nazarewicz <mina86@mina86.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Russell King <linux@arm.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	Ankita Garg <ankita@in.ibm.com>,
	Daniel Walker <dwalker@codeaurora.org>,
	Mel Gorman <mel@csn.ul.ie>,
	Jesse Barker <jesse.barker@linaro.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shariq Hasnain <shariq.hasnain@linaro.org>,
	Chunsang Jeong <chunsang.jeong@linaro.org>
References: <1313146711-1767-1-git-send-email-m.szyprowski@samsung.com> <1313146711-1767-8-git-send-email-m.szyprowski@samsung.com>
In-Reply-To: <1313146711-1767-8-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201108121453.05898.arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 12 August 2011, Marek Szyprowski wrote:
> 
> From: Russell King <rmk+kernel@arm.linux.org.uk>
> 
> Steal memory from the kernel to provide coherent DMA memory to drivers.
> This avoids the problem with multiple mappings with differing attributes
> on later CPUs.
> 
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> [m.szyprowski: rebased onto 3.1-rc1]
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>

Hi Marek,

Is this the same patch that Russell had to revert because it didn't
work on some of the older machines, in particular those using
dmabounce?

I thought that our discussion ended with the plan to use this only
for ARMv6+ (which has a problem with double mapping) but not on ARMv5
and below (which don't have this problem but might need dmabounce).

	Arnd
