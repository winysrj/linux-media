Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33944 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755162AbbE1XYE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2015 19:24:04 -0400
Date: Thu, 28 May 2015 16:24:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-mm@kvack.org, linux-media@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>,
	dri-devel@lists.freedesktop.org, Pawel Osciak <pawel@osciak.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	mgorman@suse.de, Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH 2/9] mm: Provide new get_vaddr_frames() helper
Message-Id: <20150528162402.19a0a26a5b9eae36aa8050e5@linux-foundation.org>
In-Reply-To: <1431522495-4692-3-git-send-email-jack@suse.cz>
References: <1431522495-4692-1-git-send-email-jack@suse.cz>
	<1431522495-4692-3-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 13 May 2015 15:08:08 +0200 Jan Kara <jack@suse.cz> wrote:

> Provide new function get_vaddr_frames().  This function maps virtual
> addresses from given start and fills given array with page frame numbers of
> the corresponding pages. If given start belongs to a normal vma, the function
> grabs reference to each of the pages to pin them in memory. If start
> belongs to VM_IO | VM_PFNMAP vma, we don't touch page structures. Caller
> must make sure pfns aren't reused for anything else while he is using
> them.
> 
> This function is created for various drivers to simplify handling of
> their buffers.
> 
> Acked-by: Mel Gorman <mgorman@suse.de>
> Acked-by: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  include/linux/mm.h |  44 +++++++++++
>  mm/gup.c           | 226 +++++++++++++++++++++++++++++++++++++++++++++++++++++

That's a lump of new code which many kernels won't be needing.  Can we
put all this in a new .c file and select it within drivers/media
Kconfig?

