Return-path: <linux-media-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:32778 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750976AbcJLApB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Oct 2016 20:45:01 -0400
Date: Wed, 12 Oct 2016 01:26:34 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Ruchi Kandoi <kandoiruchi@google.com>
Cc: gregkh@linuxfoundation.org, arve@android.com,
        riandrews@android.com, sumit.semwal@linaro.org, arnd@arndb.de,
        labbott@redhat.com, jlayton@poochiereds.net, bfields@fieldses.org,
        mingo@redhat.com, peterz@infradead.org, akpm@linux-foundation.org,
        keescook@chromium.org, mhocko@suse.com, oleg@redhat.com,
        john.stultz@linaro.org, mguzik@redhat.com, jdanis@google.com,
        adobriyan@gmail.com, ghackmann@google.com,
        kirill.shutemov@linux.intel.com, vbabka@suse.cz,
        dave.hansen@linux.intel.com, dan.j.williams@intel.com,
        hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, luto@kernel.org,
        tj@kernel.org, vdavydov.dev@gmail.com, ebiederm@xmission.com,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC 0/6] Module for tracking/accounting shared memory buffers
Message-ID: <20161012002634.GN19539@ZenIV.linux.org.uk>
References: <1476229810-26570-1-git-send-email-kandoiruchi@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1476229810-26570-1-git-send-email-kandoiruchi@google.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 11, 2016 at 04:50:04PM -0700, Ruchi Kandoi wrote:

> memtrack maintains a per-process list of shared buffer references, which is
> exported to userspace as /proc/[pid]/memtrack.  Buffers can be optionally
> "tagged" with a short string: for example, Android userspace would use this
> tag to identify whether buffers were allocated on behalf of the camera stack,
> GL, etc.  memtrack also exports the VMAs associated with these buffers so
> that pages already included in the process's mm counters aren't double-counted.
> 
> Shared-buffer allocators can hook into memtrack by embedding
> struct memtrack_buffer in their buffer metadata, calling
> memtrack_buffer_{init,remove} at buffer allocation and free time, and
> memtrack_buffer_{install,uninstall} when a userspace process takes or
> drops a reference to the buffer.  For fd-backed buffers like dma-bufs, hooks in
> fdtable.c and fork.c automatically notify memtrack when references are added or
> removed from a process's fd table.
> 
> This patchstack adds memtrack hooks into dma-buf and ion.  If there's upstream
> interest in memtrack, it can be extended to other memory allocators as well,
> such as GEM implementations.

No, with a side of Hell, No.  Not to mention anything else,
	* descriptor tables do not belong to any specific task_struct and
actions done by one show up in all who share that thing.
	* shared descriptor table does not imply belonging to the same
group.
	* shared descriptor table can become unshared at any point, invisibly
for that Fine Piece Of Software.
	* while we are at it, blocking allocation under several spinlocks
(and with interrupts disabled, for good measure) is generally considered
a bloody bad idea.

That - just from the quick look through that patchset.  Bringing task_struct
into the API is already sufficient for a NAK.
