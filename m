Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:58253 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752595AbbFANC1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Jun 2015 09:02:27 -0400
Message-ID: <556C57D6.80908@xs4all.nl>
Date: Mon, 01 Jun 2015 15:02:14 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm@kvack.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, Pawel Osciak <pawel@osciak.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	mgorman@suse.de, Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH 2/9] mm: Provide new get_vaddr_frames() helper
References: <1431522495-4692-1-git-send-email-jack@suse.cz> <1431522495-4692-3-git-send-email-jack@suse.cz> <20150528162402.19a0a26a5b9eae36aa8050e5@linux-foundation.org> <20150601124017.GC20288@quack.suse.cz>
In-Reply-To: <20150601124017.GC20288@quack.suse.cz>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/01/2015 02:40 PM, Jan Kara wrote:
> On Thu 28-05-15 16:24:02, Andrew Morton wrote:
>> On Wed, 13 May 2015 15:08:08 +0200 Jan Kara <jack@suse.cz> wrote:
>>
>>> Provide new function get_vaddr_frames().  This function maps virtual
>>> addresses from given start and fills given array with page frame numbers of
>>> the corresponding pages. If given start belongs to a normal vma, the function
>>> grabs reference to each of the pages to pin them in memory. If start
>>> belongs to VM_IO | VM_PFNMAP vma, we don't touch page structures. Caller
>>> must make sure pfns aren't reused for anything else while he is using
>>> them.
>>>
>>> This function is created for various drivers to simplify handling of
>>> their buffers.
>>>
>>> Acked-by: Mel Gorman <mgorman@suse.de>
>>> Acked-by: Vlastimil Babka <vbabka@suse.cz>
>>> Signed-off-by: Jan Kara <jack@suse.cz>
>>> ---
>>>  include/linux/mm.h |  44 +++++++++++
>>>  mm/gup.c           | 226 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>>
>> That's a lump of new code which many kernels won't be needing.  Can we
>> put all this in a new .c file and select it within drivers/media
>> Kconfig?
>   Yeah, makes sense. I'll write a patch. Hans, is it OK with you if I
> just create a patch on top of the series you have in your tree?

No problem.

Regards,

	Hans
