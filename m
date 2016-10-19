Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:42885 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751790AbcJSQtr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Oct 2016 12:49:47 -0400
Subject: Re: [PATCH 00/10] mm: adjust get_user_pages* functions to explicitly
 pass FOLL_* flags
To: Michal Hocko <mhocko@kernel.org>,
        Lorenzo Stoakes <lstoakes@gmail.com>
References: <20161013002020.3062-1-lstoakes@gmail.com>
 <20161018153050.GC13117@dhcp22.suse.cz> <20161019085815.GA22239@lucifer>
 <20161019090727.GE7517@dhcp22.suse.cz>
Cc: linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, Hugh Dickins <hughd@google.com>,
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
From: Dave Hansen <dave.hansen@linux.intel.com>
Message-ID: <5807A427.7010200@linux.intel.com>
Date: Wed, 19 Oct 2016 09:49:43 -0700
MIME-Version: 1.0
In-Reply-To: <20161019090727.GE7517@dhcp22.suse.cz>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/19/2016 02:07 AM, Michal Hocko wrote:
> On Wed 19-10-16 09:58:15, Lorenzo Stoakes wrote:
>> On Tue, Oct 18, 2016 at 05:30:50PM +0200, Michal Hocko wrote:
>>> I am wondering whether we can go further. E.g. it is not really clear to
>>> me whether we need an explicit FOLL_REMOTE when we can in fact check
>>> mm != current->mm and imply that. Maybe there are some contexts which
>>> wouldn't work, I haven't checked.
>>
>> This flag is set even when /proc/self/mem is used. I've not looked deeply into
>> this flag but perhaps accessing your own memory this way can be considered
>> 'remote' since you're not accessing it directly. On the other hand, perhaps this
>> is just mistaken in this case?
> 
> My understanding of the flag is quite limited as well. All I know it is
> related to protection keys and it is needed to bypass protection check.
> See arch_vma_access_permitted. See also 1b2ee1266ea6 ("mm/core: Do not
> enforce PKEY permissions on remote mm access").

Yeah, we need the flag to tell us when PKEYs should be applied or not.
The current task's PKRU (pkey rights register) should really only be
used to impact access to the task's memory, but has no bearing on how a
given task should access remote memory.

