Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48025 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227AbaCQTtn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Mar 2014 15:49:43 -0400
From: Jan Kara <jack@suse.cz>
To: linux-mm@kvack.org
Cc: linux-media@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: [RFC] Helper to abstract vma handling in media layer
Date: Mon, 17 Mar 2014 20:49:27 +0100
Message-Id: <1395085776-8626-1-git-send-email-jack@suse.cz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  Hello,

  The following patch series is my first stab at abstracting vma handling
from the various media drivers. After this patch set drivers have to know
much less details about vmas, their types, and locking. My motivation for
the series is that I want to change get_user_pages() locking and I want
to handle subtle locking details in as few places as possible.

The core of the series is the new helper get_vaddr_pfns() which is given a
virtual address and it fills in PFNs into provided array. If PFNs correspond to
normal pages it also grabs references to these pages. The difference from
get_user_pages() is that this function can also deal with pfnmap, mixed, and io
mappings which is what the media drivers need.

The patches are just compile tested (since I don't have any of the hardware
I'm afraid I won't be able to do any more testing anyway) so please handle
with care. I'm grateful for any comments.

								Honza
