Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.8]:56347 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756109Ab1GEMH0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Jul 2011 08:07:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCHv11 0/8] Contiguous Memory Allocator
Date: Tue, 5 Jul 2011 14:07:17 +0200
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org,
	linaro-mm-sig@lists.linaro.org,
	Michal Nazarewicz <mina86@mina86.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	Ankita Garg <ankita@in.ibm.com>,
	Daniel Walker <dwalker@codeaurora.org>,
	Mel Gorman <mel@csn.ul.ie>,
	Jesse Barker <jesse.barker@linaro.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Chunsang Jeong <chunsang.jeong@linaro.org>
References: <1309851710-3828-1-git-send-email-m.szyprowski@samsung.com>
In-Reply-To: <1309851710-3828-1-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201107051407.17249.arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday 05 July 2011, Marek Szyprowski wrote:
> This is yet another round of Contiguous Memory Allocator patches. I hope
> that I've managed to resolve all the items discussed during the Memory
> Management summit at Linaro Meeting in Budapest and pointed later on
> mailing lists. The goal is to integrate it as tight as possible with
> other kernel subsystems (like memory management and dma-mapping) and
> finally merge to mainline.

You have certainly addressed all of my concerns, this looks really good now!

Andrew, can you add this to your -mm tree? What's your opinion on the
current state, do you think this is ready for merging in 3.1 or would
you want to have more reviews from core memory management people?

My reviews were mostly on the driver and platform API side, and I think
we're fine there now, but I don't really understand the impacts this has
in mm.

	Arnd
