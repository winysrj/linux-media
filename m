Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.8]:56291 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372Ab1FVNjc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jun 2011 09:39:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [Linaro-mm-sig] [PATCH 08/10] mm: cma: Contiguous
 =?iso-8859-1?q?Memory=09Allocator?= added
Date: Wed, 22 Jun 2011 15:39:23 +0200
Cc: "'Hans Verkuil'" <hverkuil@xs4all.nl>,
	"'Daniel Walker'" <dwalker@codeaurora.org>,
	"'Jesse Barker'" <jesse.barker@linaro.org>,
	"'Mel Gorman'" <mel@csn.ul.ie>,
	"'KAMEZAWA Hiroyuki'" <kamezawa.hiroyu@jp.fujitsu.com>,
	linux-kernel@vger.kernel.org,
	"'Michal Nazarewicz'" <mina86@mina86.com>,
	linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org,
	"'Kyungmin Park'" <kyungmin.park@samsung.com>,
	"'Ankita Garg'" <ankita@in.ibm.com>,
	"'Andrew Morton'" <akpm@linux-foundation.org>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
References: <1307699698-29369-1-git-send-email-m.szyprowski@samsung.com> <201106221442.20848.arnd@arndb.de> <003701cc30de$7a159710$6e40c530$%szyprowski@samsung.com>
In-Reply-To: <003701cc30de$7a159710$6e40c530$%szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106221539.24044.arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wednesday 22 June 2011, Marek Szyprowski wrote:
> Sounds really good, but it might be really hard to implemnt, at least for
> CMA, because it needs to tweak parameters of memory management internal 
> structures very early, when buddy allocator has not been activated yet.

Why that? I would expect you can do the same that hugepages (used to) do
and just attempt high-order allocations. If they succeed, you can add them
as a CMA region and free them again, into the movable set of pages, otherwise
you just fail the  request from user space when the memory is already
fragmented.
 
> > These essentially fight over the same memory (though things are slightly
> > different with dynamic hugepages), and they all face the same basic problem
> > of getting as much for themselves without starving the other three.
> 
> I'm not sure we can solve all such issues in the first version. Maybe we should
> first have each of the above fully working in mainline separately and then
> start the integration works.

Yes, makes sense. We just need to be careful not to introduce user-visible
interfaces that we cannot change any more in the process.

	Arnd
