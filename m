Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35650 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993498AbbEEQBY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 May 2015 12:01:24 -0400
From: Jan Kara <jack@suse.cz>
To: linux-mm@kvack.org
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	dri-devel@lists.freedesktop.org, Pawel Osciak <pawel@osciak.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	mgorman@suse.de, Marek Szyprowski <m.szyprowski@samsung.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 0/9 v3] Helper to abstract vma handling in media layer
Date: Tue,  5 May 2015 18:01:09 +0200
Message-Id: <1430841678-11117-1-git-send-email-jack@suse.cz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  Hello,

  I'm sending the third version of my patch series to abstract vma handling
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
exposure. Conversion of other drivers was just compile-tested so I'd like to
ask respective maintainers if they could have a look.  Also I'd like to ask mm
folks to check patch 2/9 implementing the helper. Thanks!

								Honza

Changes since v2:
* Renamed functions and structures as Mel suggested
* Other minor changes suggested by Mel
* Rebased on top of 4.1-rc2
* Changed functions to get pointer to array of pages / pfns to perform
  conversion if necessary. This fixes possible issue in the omap I may have
  introduced in v2 and generally makes the API less errorprone.
