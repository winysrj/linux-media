Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:58309 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751125AbbGIMNd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Jul 2015 08:13:33 -0400
Message-ID: <559E6538.9080100@xs4all.nl>
Date: Thu, 09 Jul 2015 14:12:40 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-samsung-soc@vger.kernel.org, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/10 v6] Helper to abstract vma handling in media layer
References: <1434636520-25116-1-git-send-email-jack@suse.cz> <20150709114848.GA9189@quack.suse.cz>
In-Reply-To: <20150709114848.GA9189@quack.suse.cz>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/09/2015 01:48 PM, Jan Kara wrote:
>   Hello,
> 
>   Hans, did you have a chance to look at these patches? I have tested them
> with the vivid driver but it would be good if you could run them through
> your standard testing procedure as well. Andrew has updated the patches in
> his tree but some ack from you would be welcome...

I've planned a 'patch day' for Monday. So hopefully you'll see a pull request
by then.

Regards,

	Hans

> 
> 								Honza
> On Thu 18-06-15 16:08:30, Jan Kara wrote:
>>   Hello,
>>
>> I'm sending the sixth version of my patch series to abstract vma handling from
>> the various media drivers. Since the previous version I have added a patch to
>> move mm helpers into a separate file and behind a config option. I also
>> changed patch pushing mmap_sem down in videobuf2 core to avoid lockdep warning
>> and NULL dereference Hans found in his testing. I've also included small
>> fixups Andrew was carrying.
>>
>> After this patch set drivers have to know much less details about vmas, their
>> types, and locking. Also quite some code is removed from them. As a bonus
>> drivers get automatically VM_FAULT_RETRY handling. The primary motivation for
>> this series is to remove knowledge about mmap_sem locking from as many places a
>> possible so that we can change it with reasonable effort.
>>
>> The core of the series is the new helper get_vaddr_frames() which is given a
>> virtual address and it fills in PFNs / struct page pointers (depending on VMA
>> type) into the provided array. If PFNs correspond to normal pages it also grabs
>> references to these pages. The difference from get_user_pages() is that this
>> function can also deal with pfnmap, and io mappings which is what the media
>> drivers need.
>>
>> I have tested the patches with vivid driver so at least vb2 code got some
>> exposure. Conversion of other drivers was just compile-tested (for x86 so e.g.
>> exynos driver which is only for Samsung platform is completely untested).
>>
>> Andrew, can you please update the patches in mm three? Thanks!
>>
>> 								Honza
>>
>> Changes since v5:
>> * Moved mm helper into a separate file and behind a config option
>> * Changed the first patch pushing mmap_sem down in videobuf2 core to avoid
>>   possible deadlock
>>
>> Changes since v4:
>> * Minor cleanups and fixes pointed out by Mel and Vlasta
>> * Added Acked-by tags
>>
>> Changes since v3:
>> * Added include <linux/vmalloc.h> into mm/gup.c as it's needed for some archs
>> * Fixed error path for exynos driver
>>
>> Changes since v2:
>> * Renamed functions and structures as Mel suggested
>> * Other minor changes suggested by Mel
>> * Rebased on top of 4.1-rc2
>> * Changed functions to get pointer to array of pages / pfns to perform
>>   conversion if necessary. This fixes possible issue in the omap I may have
>>   introduced in v2 and generally makes the API less errorprone.

