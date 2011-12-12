Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:62135 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190Ab1LLQXO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Dec 2011 11:23:14 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 04/11] mm: compaction: export some of the functions
Date: Mon, 12 Dec 2011 16:22:04 +0000
Cc: Michal Nazarewicz <mina86@mina86.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org,
	linaro-mm-sig@lists.linaro.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Russell King <linux@arm.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	Ankita Garg <ankita@in.ibm.com>,
	Daniel Walker <dwalker@codeaurora.org>,
	Jesse Barker <jesse.barker@linaro.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shariq Hasnain <shariq.hasnain@linaro.org>,
	Chunsang Jeong <chunsang.jeong@linaro.org>,
	Dave Hansen <dave@linux.vnet.ibm.com>
References: <1321634598-16859-1-git-send-email-m.szyprowski@samsung.com> <op.v6dseqji3l0zgt@mpn-glaptop> <20111212154015.GI3277@csn.ul.ie>
In-Reply-To: <20111212154015.GI3277@csn.ul.ie>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201112121622.04236.arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 12 December 2011, Mel Gorman wrote:
> The bloat exists either way. I don't believe the linker strips it out so
> overall it would make more sense to depend on compaction to keep the
> vmstat counters for debugging reasons if nothing else. It's not
> something I feel very strongly about though.

There were some previous attempts to use -fgc-sections to strip out
unused functions from the kernel, but I think they were never merged
because of regressions.

	Arnd
