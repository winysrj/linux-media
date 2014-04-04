Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:37441 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492AbaDDOxz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Apr 2014 10:53:55 -0400
Received: by mail-pa0-f52.google.com with SMTP id rd3so3589357pab.11
        for <linux-media@vger.kernel.org>; Fri, 04 Apr 2014 07:53:55 -0700 (PDT)
Date: Fri, 4 Apr 2014 07:52:47 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
cc: Hugh Dickins <hughd@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kara <jack@suse.cz>, Roland Dreier <roland@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Konstantin Khlebnikov <koct9i@gmail.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Omar Ramirez Luna <omar.ramirez@copitl.com>,
	Inki Dae <inki.dae@samsung.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-rdma@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] mm: get_user_pages(write,force) refuse to COW in shared
 areas
In-Reply-To: <20140404123242.GA22320@node.dhcp.inet.fi>
Message-ID: <alpine.LSU.2.11.1404040733490.7442@eggly.anvils>
References: <alpine.LSU.2.11.1404040120110.6880@eggly.anvils> <20140404123242.GA22320@node.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 4 Apr 2014, Kirill A. Shutemov wrote:
> 
> There's comment in do_wp_page() which is not true anymore with patch
> applied. It should be fixed.

The * Only catch write-faults on shared writable pages,
    * read-only shared pages can get COWed by
    * get_user_pages(.write=1, .force=1).

Yes, I went back and forth on that: I found it difficult to remove that
comment without also simplifying the VM_WRITE|VM_SHARED test immediately
above it, possibly even looking again at the ordering of those tests.

In the end I decided to leave changing it to when we do the other
little cleanups outside get_user_pages(), after it's become clear
whether the new EFAULT is troublesome or not.  Most of my testing
had been without any change in do_wp_page(), so I left that out.

> 
> Otherwise, looks good to me:
> 
> Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

Thanks,
Hugh
