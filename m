Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51211 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932115Ab3JQVXd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Oct 2013 17:23:33 -0400
Date: Thu, 17 Oct 2013 23:23:31 +0200
From: Jan Kara <jack@suse.cz>
To: linux-media@vger.kernel.org
Cc: Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Handling of user address in vb2_dc_get_userptr()
Message-ID: <20131017212331.GA14677@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  Hello,

  I'm auditing get_user_pages() users and when looking into
vb2_dc_get_userptr() I was wondering about the following: The address this
function works with is an arbitrary user-provided address. However the
function vb2_dc_get_user_pages() uses pfn_to_page() on the pfn obtained
from VM_IO | VM_PFNMAP vma. That isn't really safe for arbitrary vma of
this type (such vmas don't have to have struct page associated at all). I
expect this works because userspace always passes a pointer to either a
regular vma or VM_FIXMAP vma where struct page is associated with pfn. Am
I right? Or for on which vmas this code is supposed to work? Thanks in
advance for clarification.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
