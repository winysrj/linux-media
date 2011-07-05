Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.8]:56450 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755659Ab1GELqY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Jul 2011 07:46:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 5/8] mm: MIGRATE_CMA isolation functions added
Date: Tue, 5 Jul 2011 13:45:14 +0200
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
References: <1309851710-3828-1-git-send-email-m.szyprowski@samsung.com> <1309851710-3828-6-git-send-email-m.szyprowski@samsung.com>
In-Reply-To: <1309851710-3828-6-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201107051345.14502.arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday 05 July 2011, Marek Szyprowski wrote:
> From: Michal Nazarewicz <m.nazarewicz@samsung.com>
> 
> This commit changes various functions that change pages and
> pageblocks migrate type between MIGRATE_ISOLATE and
> MIGRATE_MOVABLE in such a way as to allow to work with
> MIGRATE_CMA migrate type.
> 
> Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> CC: Michal Nazarewicz <mina86@mina86.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
