Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.fireflyinternet.com ([109.228.58.192]:64076 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752739AbcKNJ4E (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Nov 2016 04:56:04 -0500
Date: Mon, 14 Nov 2016 09:55:48 +0000
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Tvrtko Ursulin <tursulin@ursulin.net>
Cc: Intel-gfx@lists.freedesktop.org,
        Tomasz Stanislawski <t.stanislaws@samsung.com>,
        Pawel Osciak <pawel@osciak.com>, linux-kernel@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        linux-media@vger.kernel.org,
        Alexandre Bounine <alexandre.bounine@idt.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [Intel-gfx] [PATCH 1/4] lib/scatterlist: Fix offset type in
 sg_alloc_table_from_pages
Message-ID: <20161114095548.GC32240@nuc-i3427.alporthouse.com>
References: <1478854220-3255-1-git-send-email-tvrtko.ursulin@linux.intel.com>
 <1478854220-3255-2-git-send-email-tvrtko.ursulin@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1478854220-3255-2-git-send-email-tvrtko.ursulin@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 11, 2016 at 08:50:17AM +0000, Tvrtko Ursulin wrote:
> From: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> 
> Scatterlist entries have an unsigned int for the offset so
> correct the sg_alloc_table_from_pages function accordingly.
> 
> Since these are offsets withing a page, unsigned int is
> wide enough.
> 
> Also converts callers which were using unsigned long locally
> with the lower_32_bits annotation to make it explicitly
> clear what is happening.
> 
> v2: Use offset_in_page. (Chris Wilson)
> 
> Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
> Cc: Pawel Osciak <pawel@osciak.com>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>
> Cc: Matt Porter <mporter@kernel.crashing.org>
> Cc: Alexandre Bounine <alexandre.bounine@idt.com>
> Cc: linux-media@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Acked-by: Marek Szyprowski <m.szyprowski@samsung.com> (v1)

If there were kerneldoc, it would nicely explain that having an offset
larger then a page is silly when passing in array of pages.

Changes elsewhere look ok (personally I'd be happy with just
offset_in_page(), 4GiB superpages are somebody else's problem :)

Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
