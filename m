Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:47424 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751424AbbEYLiD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 May 2015 07:38:03 -0400
Message-ID: <55630994.7040006@xs4all.nl>
Date: Mon, 25 May 2015 13:37:56 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>, linux-mm@kvack.org
CC: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Pawel Osciak <pawel@osciak.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	mgorman@suse.de, Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH 0/9 v5] Helper to abstract vma handling in media layer
References: <1431522495-4692-1-git-send-email-jack@suse.cz>
In-Reply-To: <1431522495-4692-1-git-send-email-jack@suse.cz>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jan,

On 05/13/2015 03:08 PM, Jan Kara wrote:
>   Hello,
> 
> I'm sending the fifth version of my patch series to abstract vma handling
> from the various media drivers. The patches got some review from mm people and
> testing from device driver guys so unless someone objects, patches will be
> queued in media tree for the next merge window.

What is the current status? I saw one comment for patch 9, so I assume it is not
quite ready yet.

Let me know when you think it is time to merge.

Regards,

	Hans

> 
> After this patch set drivers have to know much less details about vmas, their
> types, and locking. Also quite some code is removed from them. As a bonus
> drivers get automatically VM_FAULT_RETRY handling. The primary motivation for
> this series is to remove knowledge about mmap_sem locking from as many places a
> possible so that we can change it with reasonable effort.
> 
> The core of the series is the new helper get_vaddr_frames() which is given a
> virtual address and it fills in PFNs / struct page pointers (depending on VMA
> type) into the provided array. If PFNs correspond to normal pages it also grabs
> references to these pages. The difference from get_user_pages() is that this
> function can also deal with pfnmap, and io mappings which is what the media
> drivers need.
> 
> I have tested the patches with vivid driver so at least vb2 code got some
> exposure. Conversion of other drivers was just compile-tested (for x86 so e.g.
> exynos driver which is only for Samsung platform is completely untested).
> 
> 								Honza
> Changes since v4:
> * Minor cleanups and fixes pointed out by Mel and Vlasta
> * Added Acked-by tags
> 
> Changes since v3:
> * Added include <linux/vmalloc.h> into mm/gup.c as it's needed for some archs
> * Fixed error path for exynos driver
> 
> Changes since v2:
> * Renamed functions and structures as Mel suggested
> * Other minor changes suggested by Mel
> * Rebased on top of 4.1-rc2
> * Changed functions to get pointer to array of pages / pfns to perform
>   conversion if necessary. This fixes possible issue in the omap I may have
>   introduced in v2 and generally makes the API less errorprone.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

