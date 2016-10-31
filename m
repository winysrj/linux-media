Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:32831 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S943171AbcJaNsx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 31 Oct 2016 09:48:53 -0400
Date: Mon, 31 Oct 2016 13:48:49 +0000
From: Lorenzo Stoakes <lstoakes@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
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
Subject: Re: [PATCH 2/2] mm: remove get_user_pages_locked()
Message-ID: <20161031134849.GA13609@lucifer>
References: <20161031100228.17917-1-lstoakes@gmail.com>
 <20161031100228.17917-3-lstoakes@gmail.com>
 <cc508436-156e-eb4b-ae01-b44f33c2d692@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc508436-156e-eb4b-ae01-b44f33c2d692@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 31, 2016 at 12:45:36PM +0100, Paolo Bonzini wrote:
>
>
> On 31/10/2016 11:02, Lorenzo Stoakes wrote:
> > - *
> > - * get_user_pages should be phased out in favor of
> > - * get_user_pages_locked|unlocked or get_user_pages_fast. Nothing
> > - * should use get_user_pages because it cannot pass
> > - * FAULT_FLAG_ALLOW_RETRY to handle_mm_fault.
>
> This comment should be preserved in some way.  In addition, removing

Could you clarify what you think should be retained?

The comment seems to me to be largely rendered redundant by this change -
get_user_pages() now offers identical behaviour, and of course the latter part
of the comment ('because it cannot pass FAULT_FLAG_ALLOW_RETRY') is rendered
incorrect by this change.

It could be replaced with a recommendation to make use of VM_FAULT_RETRY logic
if possible. Note that the line above retains the reference to
'get_user_pages_fast()' - 'See also get_user_pages_fast, for performance
critical applications.'

One important thing to note here is this is a comment on get_user_pages_remote()
for which it was already incorrect syntactically (I'm guessing once
get_user_pages_remote() was added it 'stole' get_user_pages()'s comment :)

> get_user_pages_locked() makes it harder (compared to a simple "git grep
> -w") to identify callers that lack allow-retry functionality).  So I'm
> not sure about the benefits of these patches.
>

That's a fair point, and certainly this cleanup series is less obviously helpful
than previous ones.

However, there are a few points in its favour:

1. get_user_pages_remote() was the mirror of get_user_pages() prior to adding an
   int *locked parameter to the former (necessary to allow for the unexport of
   __get_user_pages_unlocked()), differing only in task/mm being specified and
   FOLL_REMOTE being set. This patch series keeps these functions 'synchronised'
   in this respect.

2. There is currently only one caller of get_user_pages_locked() in
   mm/frame_vector.c which seems to suggest this function isn't widely
   used/known.

3. This change results in all slow-path get_user_pages*() functions having the
   ability to use VM_FAULT_RETRY logic rather than 'defaulting' to using
   get_user_pages() that doesn't let you do this even if you wanted to.

4. It's somewhat confusing/redundant having both get_user_pages_locked() and
   get_user_pages() functions which both require mmap_sem to be held (i.e. both
   are 'locked' versions.)

> If all callers were changed, then sure removing the _locked suffix would
> be a good idea.

It seems many callers cannot release mmap_sem so VM_FAULT_RETRY logic couldn't
happen anyway in this cases and in these cases we couldn't change the caller.


Overall, an alternative here might be to remove get_user_pages() and update
get_user_pages_locked() to add a 'vmas' parameter, however doing this renders
get_user_pages_unlocked() asymmetric as it would lack an vmas parameter (adding
one there would make no sense as VM_FAULT_RETRY logic invalidates VMAs) though
perhaps not such a big issue as it makes sense as to why this is the case.

get_user_pages_unlocked() definitely seems to be a useful helper and therefore
makes sense to retain.

Of course another alternative is to leave things be :)
