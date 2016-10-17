Return-path: <linux-media-owner@vger.kernel.org>
Received: from bes.se.axis.com ([195.60.68.10]:34773 "EHLO bes.se.axis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932745AbcJQJXY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Oct 2016 05:23:24 -0400
Date: Mon, 17 Oct 2016 11:22:46 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: linux-mm@kvack.org, linux-mips@linux-mips.org,
        linux-fbdev@vger.kernel.org, Jan Kara <jack@suse.cz>,
        kvm@vger.kernel.org, linux-sh@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        dri-devel@lists.freedesktop.org, netdev@vger.kernel.org,
        sparclinux@vger.kernel.org, linux-ia64@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org,
        x86@kernel.org, Hugh Dickins <hughd@google.com>,
        linux-media@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        intel-gfx@lists.freedesktop.org,
        adi-buildroot-devel@lists.sourceforge.net,
        ceph-devel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-cris-kernel@axis.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-alpha@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@techsingularity.net>
Subject: Re: [PATCH 06/10] mm: replace get_user_pages() write/force
 parameters with gup_flags
Message-ID: <20161017092246.GG30704@axis.com>
References: <20161013002020.3062-1-lstoakes@gmail.com>
 <20161013002020.3062-7-lstoakes@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161013002020.3062-7-lstoakes@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 13, 2016 at 01:20:16AM +0100, Lorenzo Stoakes wrote:
> This patch removes the write and force parameters from get_user_pages() and
> replaces them with a gup_flags parameter to make the use of FOLL_FORCE explicit
> in callers as use of this flag can result in surprising behaviour (and hence
> bugs) within the mm subsystem.
> 
> Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
> ---
>  arch/cris/arch-v32/drivers/cryptocop.c                 |  4 +---

For the CRIS part:

Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
