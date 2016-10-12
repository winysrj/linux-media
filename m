Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:35500 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752343AbcJLBOy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Oct 2016 21:14:54 -0400
MIME-Version: 1.0
In-Reply-To: <1476229810-26570-1-git-send-email-kandoiruchi@google.com>
References: <1476229810-26570-1-git-send-email-kandoiruchi@google.com>
From: Rob Clark <robdclark@gmail.com>
Date: Tue, 11 Oct 2016 21:14:20 -0400
Message-ID: <CAF6AEGvAqpxY4pguzGL9ztQvTCG-tOZhF093Odt0-gt1MM49iQ@mail.gmail.com>
Subject: Re: [RFC 0/6] Module for tracking/accounting shared memory buffers
To: Ruchi Kandoi <kandoiruchi@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        Riley Andrews <riandrews@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, labbott@redhat.com,
        Al Viro <viro@zeniv.linux.org.uk>, jlayton@poochiereds.net,
        bfields@fieldses.org, mingo@redhat.com,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        keescook@chromium.org, mhocko@suse.com, oleg@redhat.com,
        John Stultz <john.stultz@linaro.org>, mguzik@redhat.com,
        jdanis@google.com, adobriyan@gmail.com,
        Greg Hackmann <ghackmann@google.com>,
        kirill.shutemov@linux.intel.com, vbabka@suse.cz,
        dave.hansen@linux.intel.com,
        Dan Williams <dan.j.williams@intel.com>, hannes@cmpxchg.org,
        iamjoonsoo.kim@lge.com, luto@kernel.org, tj@kernel.org,
        vdavydov.dev@gmail.com, ebiederm@xmission.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        linux-fsdevel@vger.kernel.org, linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 11, 2016 at 7:50 PM, Ruchi Kandoi <kandoiruchi@google.com> wrote:
> This patchstack introduces a new "memtrack" module for tracking and accounting
> memory exported to userspace as shared buffers, like dma-buf fds or GEM handles.

btw, I wouldn't care much about the non-dmabuf case.. dri2/flink is
kind of legacy and the sharing patterns there are not so complex that
we have found the need for any more elaborate debug infrastructure
than what we already have.

Between existing dmabuf debugfs, and /proc/*/maps (and /proc/*/fd?), I
wonder what is missing?  Maybe there is a less intrusive way to get at
the debugging info you want?

BR,
-R

> Any process holding a reference to these buffers will keep the kernel from
> reclaiming its backing pages.  mm counters don't provide a complete picture of
> these allocations, since they only account for pages that are mapped into a
> process's address space.  This problem is especially bad for systems like
> Android that use dma-buf fds to share graphics and multimedia buffers between
> processes: these allocations are often large, have complex sharing patterns,
> and are rarely mapped into every process that holds a reference to them.
>
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
>
> Greg Hackmann (1):
>   drivers: staging: ion: add ION_IOC_TAG ioctl
>
> Ruchi Kandoi (5):
>   fs: add installed and uninstalled file_operations
>   drivers: misc: add memtrack
>   dma-buf: add memtrack support
>   memtrack: Adds the accounting to keep track of all mmaped/unmapped
>     pages.
>   memtrack: Add memtrack accounting for forked processes.
>
>  drivers/android/binder.c                |   4 +-
>  drivers/dma-buf/dma-buf.c               |  37 +++
>  drivers/misc/Kconfig                    |  16 +
>  drivers/misc/Makefile                   |   1 +
>  drivers/misc/memtrack.c                 | 516 ++++++++++++++++++++++++++++++++
>  drivers/staging/android/ion/ion-ioctl.c |  17 ++
>  drivers/staging/android/ion/ion.c       |  60 +++-
>  drivers/staging/android/ion/ion_priv.h  |   2 +
>  drivers/staging/android/uapi/ion.h      |  25 ++
>  fs/file.c                               |  38 ++-
>  fs/open.c                               |   2 +-
>  fs/proc/base.c                          |   4 +
>  include/linux/dma-buf.h                 |   5 +
>  include/linux/fdtable.h                 |   4 +-
>  include/linux/fs.h                      |   2 +
>  include/linux/memtrack.h                | 130 ++++++++
>  include/linux/mm.h                      |   3 +
>  include/linux/sched.h                   |   3 +
>  kernel/fork.c                           |  23 +-
>  19 files changed, 875 insertions(+), 17 deletions(-)
>  create mode 100644 drivers/misc/memtrack.c
>  create mode 100644 include/linux/memtrack.h
>
> --
> 2.8.0.rc3.226.g39d4020
>
