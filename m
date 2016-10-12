Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:48425 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932213AbcJLR2Q (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Oct 2016 13:28:16 -0400
Subject: Re: [RFC 0/6] Module for tracking/accounting shared memory buffers
To: Ruchi Kandoi <kandoiruchi@google.com>, gregkh@linuxfoundation.org,
        arve@android.com, riandrews@android.com, sumit.semwal@linaro.org,
        arnd@arndb.de, labbott@redhat.com, viro@zeniv.linux.org.uk,
        jlayton@poochiereds.net, bfields@fieldses.org, mingo@redhat.com,
        peterz@infradead.org, akpm@linux-foundation.org,
        keescook@chromium.org, mhocko@suse.com, oleg@redhat.com,
        john.stultz@linaro.org, mguzik@redhat.com, jdanis@google.com,
        adobriyan@gmail.com, ghackmann@google.com,
        kirill.shutemov@linux.intel.com, vbabka@suse.cz,
        dan.j.williams@intel.com, hannes@cmpxchg.org,
        iamjoonsoo.kim@lge.com, luto@kernel.org, tj@kernel.org,
        vdavydov.dev@gmail.com, ebiederm@xmission.com,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
References: <1476229810-26570-1-git-send-email-kandoiruchi@google.com>
From: Dave Hansen <dave.hansen@linux.intel.com>
Message-ID: <57FE6FC6.70205@linux.intel.com>
Date: Wed, 12 Oct 2016 10:15:50 -0700
MIME-Version: 1.0
In-Reply-To: <1476229810-26570-1-git-send-email-kandoiruchi@google.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/11/2016 04:50 PM, Ruchi Kandoi wrote:
> Any process holding a reference to these buffers will keep the kernel from
> reclaiming its backing pages.  mm counters don't provide a complete picture of
> these allocations, since they only account for pages that are mapped into a
> process's address space.  This problem is especially bad for systems like
> Android that use dma-buf fds to share graphics and multimedia buffers between
> processes: these allocations are often large, have complex sharing patterns,
> and are rarely mapped into every process that holds a reference to them.

What do you end up _doing_ with all this new information that you have
here?  You know which processes have "pinned" these shared buffers, and
exported that information in /proc.  But, then what?
