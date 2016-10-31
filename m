Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33740 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935873AbcJaLpn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 31 Oct 2016 07:45:43 -0400
Subject: Re: [PATCH 2/2] mm: remove get_user_pages_locked()
To: Lorenzo Stoakes <lstoakes@gmail.com>, linux-mm@kvack.org
References: <20161031100228.17917-1-lstoakes@gmail.com>
 <20161031100228.17917-3-lstoakes@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>, Jan Kara <jack@suse.cz>,
        Hugh Dickins <hughd@google.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-cris-kernel@axis.com,
        linux-ia64@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-rdma@vger.kernel.org, kvm@vger.kernel.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <cc508436-156e-eb4b-ae01-b44f33c2d692@redhat.com>
Date: Mon, 31 Oct 2016 12:45:36 +0100
MIME-Version: 1.0
In-Reply-To: <20161031100228.17917-3-lstoakes@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 31/10/2016 11:02, Lorenzo Stoakes wrote:
> - *
> - * get_user_pages should be phased out in favor of
> - * get_user_pages_locked|unlocked or get_user_pages_fast. Nothing
> - * should use get_user_pages because it cannot pass
> - * FAULT_FLAG_ALLOW_RETRY to handle_mm_fault.

This comment should be preserved in some way.  In addition, removing
get_user_pages_locked() makes it harder (compared to a simple "git grep
-w") to identify callers that lack allow-retry functionality).  So I'm
not sure about the benefits of these patches.

If all callers were changed, then sure removing the _locked suffix would
be a good idea.

Paolo
