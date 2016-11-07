Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:35866 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751372AbcKGLAy (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 Nov 2016 06:00:54 -0500
Date: Mon, 7 Nov 2016 11:00:50 +0000
From: Lorenzo Stoakes <lstoakes@gmail.com>
To: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: linux-mm@kvack.org, devel@driverdev.osuosl.org,
        linux-ia64@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Jan Kara <jack@suse.cz>, kvm@vger.kernel.org,
        linux-cris-kernel@axis.com, linux-rdma@vger.kernel.org,
        Mel Gorman <mgorman@techsingularity.net>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Michal Hocko <mhocko@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: add locked parameter to get_user_pages()
Message-ID: <20161107110050.GA25313@lucifer>
References: <20161031100228.17917-1-lstoakes@gmail.com>
 <20161031100228.17917-2-lstoakes@gmail.com>
 <20161107104918.GQ30704@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161107104918.GQ30704@axis.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 07, 2016 at 11:49:18AM +0100, Jesper Nilsson wrote:
> For the cris-part:
> Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>

Thanks very much for that, however just to avoid any confusion, I realised this
series was not not the right way forward after discussion with Paolo and rather
it makes more sense to keep the API as it is and to update callers where it
makes sense to.
