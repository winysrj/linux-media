Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:45956 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751622AbbGQMJ6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jul 2015 08:09:58 -0400
Message-ID: <55A8F058.7030503@xs4all.nl>
Date: Fri, 17 Jul 2015 14:08:56 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Jan Kara <jack@suse.com>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-samsung-soc@vger.kernel.org, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/9 v7] Helper to abstract vma handling in media layer
References: <1436799351-21975-1-git-send-email-jack@suse.com>
In-Reply-To: <1436799351-21975-1-git-send-email-jack@suse.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jan,

On 07/13/2015 04:55 PM, Jan Kara wrote:
> From: Jan Kara <jack@suse.cz>
> 
>   Hello,
> 
> I'm sending the seventh version of my patch series to abstract vma handling
> from the various media drivers. Since the previous version there are just
> minor cleanups and fixes (see detailed changelog at the end of the email).
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
> Hans, can you please pull the changes? Thanks!

I've done some testing myself and it all looks fine to me. All I need is an
additional Ack for the mm patch from Andrew or other mm maintainers.

Regards,

	Hans

> 
> 								Honza
> 
> Changes since v6:
> * Fixed compilation error introduced into exynos driver
> * Folded patch allowing get_vaddr_pfn() code to be selected by a config option
>   into previous patches
> * Rebased on top of linux-media tree
> 
> Changes since v5:
> * Moved mm helper into a separate file and behind a config option
> * Changed the first patch pushing mmap_sem down in videobuf2 core to avoid
>   possible deadlock
> 
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

