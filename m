Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f181.google.com ([209.85.216.181]:34335 "EHLO
        mail-qt0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941618AbcJSOUp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Oct 2016 10:20:45 -0400
Date: Wed, 19 Oct 2016 09:58:15 +0100
From: Lorenzo Stoakes <lstoakes@gmail.com>
To: Michal Hocko <mhocko@kernel.org>
Cc: linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, Hugh Dickins <hughd@google.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        adi-buildroot-devel@lists.sourceforge.net,
        ceph-devel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-cris-kernel@axis.com, linux-fbdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mips@linux-mips.org, linux-rdma@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-sh@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, sparclinux@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 00/10] mm: adjust get_user_pages* functions to explicitly
 pass FOLL_* flags
Message-ID: <20161019085815.GA22239@lucifer>
References: <20161013002020.3062-1-lstoakes@gmail.com>
 <20161018153050.GC13117@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161018153050.GC13117@dhcp22.suse.cz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 18, 2016 at 05:30:50PM +0200, Michal Hocko wrote:
> I am wondering whether we can go further. E.g. it is not really clear to
> me whether we need an explicit FOLL_REMOTE when we can in fact check
> mm != current->mm and imply that. Maybe there are some contexts which
> wouldn't work, I haven't checked.

This flag is set even when /proc/self/mem is used. I've not looked deeply into
this flag but perhaps accessing your own memory this way can be considered
'remote' since you're not accessing it directly. On the other hand, perhaps this
is just mistaken in this case?

> I guess there is more work in that area and I do not want to impose all
> that work on you, but I couldn't resist once I saw you playing in that
> area ;) Definitely a good start!

Thanks, I am more than happy to go as far down this rabbit hole as is helpful,
no imposition at all :)
