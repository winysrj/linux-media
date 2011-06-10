Return-path: <mchehab@pedra>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56100 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755559Ab1FJLYo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2011 07:24:44 -0400
Date: Fri, 10 Jun 2011 12:24:51 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org,
	linaro-mm-sig@lists.linaro.org,
	Michal Nazarewicz <mina86@mina86.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	Ankita Garg <ankita@in.ibm.com>,
	Daniel Walker <dwalker@codeaurora.org>,
	Johan MOSSBERG <johan.xx.mossberg@stericsson.com>,
	Mel Gorman <mel@csn.ul.ie>, Arnd Bergmann <arnd@arndb.de>,
	Jesse Barker <jesse.barker@linaro.org>
Subject: Re: [PATCH 02/10] lib: genalloc: Generic allocator improvements
Message-ID: <20110610122451.15af86d1@lxorguk.ukuu.org.uk>
In-Reply-To: <1307699698-29369-3-git-send-email-m.szyprowski@samsung.com>
References: <1307699698-29369-1-git-send-email-m.szyprowski@samsung.com>
	<1307699698-29369-3-git-send-email-m.szyprowski@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I am curious about one thing

Why do we need this allocator. Why not use allocate_resource and friends.
The kernel generic resource handler already handles object alignment and
subranges. It just seems to be a surplus allocator that could perhaps be
mostly removed by using the kernel resource allocator we already have ?

Alan
