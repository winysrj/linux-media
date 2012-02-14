Return-path: <linux-media-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38091 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab2BNIkA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Feb 2012 03:40:00 -0500
Date: Tue, 14 Feb 2012 17:38:21 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org,
	linaro-mm-sig@lists.linaro.org,
	Michal Nazarewicz <mina86@mina86.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Russell King <linux@arm.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Daniel Walker <dwalker@codeaurora.org>,
	Mel Gorman <mel@csn.ul.ie>, Arnd Bergmann <arnd@arndb.de>,
	Jesse Barker <jesse.barker@linaro.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shariq Hasnain <shariq.hasnain@linaro.org>,
	Chunsang Jeong <chunsang.jeong@linaro.org>,
	Dave Hansen <dave@linux.vnet.ibm.com>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Rob Clark <rob.clark@linaro.org>,
	Ohad Ben-Cohen <ohad@wizery.com>
Subject: Re: [PATCHv21 10/16] mm: Serialize access to min_free_kbytes
Message-Id: <20120214173821.8a214716.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1328895151-5196-11-git-send-email-m.szyprowski@samsung.com>
References: <1328895151-5196-1-git-send-email-m.szyprowski@samsung.com>
	<1328895151-5196-11-git-send-email-m.szyprowski@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 10 Feb 2012 18:32:25 +0100
Marek Szyprowski <m.szyprowski@samsung.com> wrote:

> From: Mel Gorman <mgorman@suse.de>
> 
> There is a race between the min_free_kbytes sysctl, memory hotplug
> and transparent hugepage support enablement.  Memory hotplug uses a
> zonelists_mutex to avoid a race when building zonelists. Reuse it to
> serialise watermark updates.
> 
> [a.p.zijlstra@chello.nl: Older patch fixed the race with spinlock]
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>

At linux-next, conflicted with "mm: add extra free kbytes tunable"

To the logic,
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

