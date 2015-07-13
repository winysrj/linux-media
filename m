Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46683 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750856AbbGMOz7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jul 2015 10:55:59 -0400
From: Jan Kara <jack@suse.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-samsung-soc@vger.kernel.org, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 0/9 v7] Helper to abstract vma handling in media layer
Date: Mon, 13 Jul 2015 16:55:42 +0200
Message-Id: <1436799351-21975-1-git-send-email-jack@suse.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jan Kara <jack@suse.cz>

  Hello,

I'm sending the seventh version of my patch series to abstract vma handling
from the various media drivers. Since the previous version there are just
minor cleanups and fixes (see detailed changelog at the end of the email).

After this patch set drivers have to know much less details about vmas, their
types, and locking. Also quite some code is removed from them. As a bonus
drivers get automatically VM_FAULT_RETRY handling. The primary motivation for
this series is to remove knowledge about mmap_sem locking from as many places a
possible so that we can change it with reasonable effort.

The core of the series is the new helper get_vaddr_frames() which is given a
virtual address and it fills in PFNs / struct page pointers (depending on VMA
type) into the provided array. If PFNs correspond to normal pages it also grabs
references to these pages. The difference from get_user_pages() is that this
function can also deal with pfnmap, and io mappings which is what the media
drivers need.

I have tested the patches with vivid driver so at least vb2 code got some
exposure. Conversion of other drivers was just compile-tested (for x86 so e.g.
exynos driver which is only for Samsung platform is completely untested).

Hans, can you please pull the changes? Thanks!

								Honza

Changes since v6:
* Fixed compilation error introduced into exynos driver
* Folded patch allowing get_vaddr_pfn() code to be selected by a config option
  into previous patches
* Rebased on top of linux-media tree

Changes since v5:
* Moved mm helper into a separate file and behind a config option
* Changed the first patch pushing mmap_sem down in videobuf2 core to avoid
  possible deadlock

Changes since v4:
* Minor cleanups and fixes pointed out by Mel and Vlasta
* Added Acked-by tags

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
