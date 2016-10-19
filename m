Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:33557 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941312AbcJSOZE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Oct 2016 10:25:04 -0400
Date: Wed, 19 Oct 2016 09:40:45 +0100
From: Lorenzo Stoakes <lstoakes@gmail.com>
To: Michal Hocko <mhocko@kernel.org>
Cc: Jan Kara <jack@suse.cz>, linux-mm@kvack.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
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
Subject: Re: [PATCH 08/10] mm: replace __access_remote_vm() write parameter
 with gup_flags
Message-ID: <20161019084045.GA19441@lucifer>
References: <20161013002020.3062-1-lstoakes@gmail.com>
 <20161013002020.3062-9-lstoakes@gmail.com>
 <20161019075903.GP29967@quack2.suse.cz>
 <20161019081352.GB7562@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161019081352.GB7562@dhcp22.suse.cz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 19, 2016 at 10:13:52AM +0200, Michal Hocko wrote:
> On Wed 19-10-16 09:59:03, Jan Kara wrote:
> > On Thu 13-10-16 01:20:18, Lorenzo Stoakes wrote:
> > > This patch removes the write parameter from __access_remote_vm() and replaces it
> > > with a gup_flags parameter as use of this function previously _implied_
> > > FOLL_FORCE, whereas after this patch callers explicitly pass this flag.
> > >
> > > We make this explicit as use of FOLL_FORCE can result in surprising behaviour
> > > (and hence bugs) within the mm subsystem.
> > >
> > > Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
> >
> > So I'm not convinced this (and the following two patches) is actually
> > helping much. By grepping for FOLL_FORCE we will easily see that any caller
> > of access_remote_vm() gets that semantics and can thus continue search
>
> I am really wondering. Is there anything inherent that would require
> FOLL_FORCE for access_remote_vm? I mean FOLL_FORCE is a really
> non-trivial thing. It doesn't obey vma permissions so we should really
> minimize its usage. Do all of those users really need FOLL_FORCE?

I wonder about this also, for example by accessing /proc/self/mem you trigger
access_remote_vm() and consequently get_user_pages_remote() meaning FOLL_FORCE
is implied and you can use /proc/self/mem to override any VMA permissions. I
wonder if this is desirable behaviour or whether this ought to be limited to
ptrace system calls. Regardless, by making the flag more visible it makes it
easier to see that this is happening.

Note that this /proc/self/mem behaviour is what triggered the bug that brought
about this discussion in the first place -
https://marc.info/?l=linux-mm&m=147363447105059 - as using /proc/self/mem this
way on PROT_NONE memory broke some assumptions.

On the other hand I see your point Jan in that you know any caller of these
functions will have FOLL_FORCE implied, and you have to decide to stop passing
the flag at _some_ point in the stack, however it seems fairly sane to have that
stopping point exist outside of exported gup functions so the gup interface
forces explicitness but callers can wrap things as they need.
