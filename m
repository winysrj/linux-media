Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59441 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965040AbbEFH2Z (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 May 2015 03:28:25 -0400
From: Jan Kara <jack@suse.cz>
To: linux-mm@kvack.org
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	dri-devel@lists.freedesktop.org, Pawel Osciak <pawel@osciak.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	mgorman@suse.de, Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-samsung-soc@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: [PATCH 0/9 v4] Helper to abstract vma handling in media layer
Date: Wed,  6 May 2015 09:28:07 +0200
Message-Id: <1430897296-5469-1-git-send-email-jack@suse.cz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  Hello,

  Sorry for a quick resend but the missing vmalloc include in mm/gup.c is
annoying for archs that need it and I was also told to extend CC list a bit.

I'm sending the fourth version of my patch series to abstract vma handling
from the various media drivers. After this patch set drivers have to know much
less details about vmas, their types, and locking. Also quite some code is
removed from them. As a bonus drivers get automatically VM_FAULT_RETRY
handling. The primary motivation for this series is to remove knowledge about
mmap_sem locking from as many places a possible so that we can change it with
reasonable effort.

The core of the series is the new helper get_vaddr_frames() which is given a
virtual address and it fills in PFNs / struct page pointers (depending on VMA
type) into the provided array. If PFNs correspond to normal pages it also grabs
references to these pages. The difference from get_user_pages() is that this
function can also deal with pfnmap, and io mappings which is what the media
drivers need.

I have tested the patches with vivid driver so at least vb2 code got some
exposure. Conversion of other drivers was just compile-tested (for x86 so e.g.
exynos driver which is only for Samsung platform is completely untested) so I'd
like to ask respective maintainers if they could have a look.  Also I'd like to
ask mm folks to check patch 2/9 implementing the helper. Thanks!

								Honza
Changes since v3:
* Added include <linux/vmalloc.h> into mm/gup.c as it's needed for some archs
* Fixed error path for exynos driver

Changes since v2:
* Renamed functions and structures as Mel suggested
* Other minor changes suggested by Mel
* Rebased on top of 4.1-rc2
* Changed functions to get pointer to array of pages / pfns to perform
  conversion if necessary. This fixes possible issue in the omap I may have
  introduced in v2 and generally makes the API less errorprone.
