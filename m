Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52611 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757974Ab3JQWQJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Oct 2013 18:16:09 -0400
Date: Fri, 18 Oct 2013 00:16:06 +0200
From: Jan Kara <jack@suse.cz>
To: linux-media@vger.kernel.org
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Handling of VM_IO vma in omap_vout_uservirt_to_phys()
Message-ID: <20131017221606.GA20365@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  Hello,

  I was auditing get_user_pages() users and I've noticed that
omap_vout_uservirt_to_phys() is apparently called for arbitrary address
passed from userspace. If this address is in VM_IO vma, we use
vma->vm_pgoff for mapping the virtual address to a physical address.
However I don't think this is a generally valid computation for arbitrary
VM_IO vma. So do we expect vma to come from a particular source where this
is true? If yes, where do we expect vma comes from? Thanks for
clarification.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
