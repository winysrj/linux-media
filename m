Return-path: <linux-media-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:34373 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753788AbdLDLpJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Dec 2017 06:45:09 -0500
Date: Mon, 4 Dec 2017 12:45:17 +0100
From: Greg KH <greg@kroah.com>
To: Lyude Paul <lyude@redhat.com>
Cc: stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Sinclair Yeh <syeh@vmware.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
        Nicolai =?iso-8859-1?Q?H=E4hnle?= <nicolai.haehnle@amd.com>,
        dri-devel@lists.freedesktop.org,
        Peter Zijlstra <peterz@infradead.org>,
        Chunming Zhou <david1.zhou@amd.com>,
        Michel =?iso-8859-1?Q?D=E4nzer?= <michel.daenzer@amd.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
        Harish Kasiviswanathan <harish.kasiviswanathan@amd.com>,
        Alex Xie <alexbin.xie@amd.com>,
        "Zhang, Jerry" <jerry.zhang@amd.com>,
        Felix Kuehling <felix.kuehling@amd.com>,
        amd-gfx@lists.freedesktop.org
Subject: Re: [PATCH 0/4] Backported amdgpu ttm deadlock fixes for 4.14
Message-ID: <20171204114517.GA28068@kroah.com>
References: <20171201002311.28098-1-lyude@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20171201002311.28098-1-lyude@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 30, 2017 at 07:23:02PM -0500, Lyude Paul wrote:
> I haven't gone to see where it started, but as of late a good number of
> pretty nasty deadlock issues have appeared with the kernel. Easy
> reproduction recipe on a laptop with i915/amdgpu prime with lockdep enabled:
> 
> DRI_PRIME=1 glxinfo
> 
> Additionally, some more race conditions exist that I've managed to
> trigger with piglit and lockdep enabled after applying these patches:
> 
>     =============================
>     WARNING: suspicious RCU usage
>     4.14.3Lyude-Test+ #2 Not tainted
>     -----------------------------
>     ./include/linux/reservation.h:216 suspicious rcu_dereference_protected() usage!
> 
>     other info that might help us debug this:
> 
>     rcu_scheduler_active = 2, debug_locks = 1
>     1 lock held by ext_image_dma_b/27451:
>      #0:  (reservation_ww_class_mutex){+.+.}, at: [<ffffffffa034f2ff>] ttm_bo_unref+0x9f/0x3c0 [ttm]
> 
>     stack backtrace:
>     CPU: 0 PID: 27451 Comm: ext_image_dma_b Not tainted 4.14.3Lyude-Test+ #2
>     Hardware name: HP HP ZBook 15 G4/8275, BIOS P70 Ver. 01.02 06/09/2017
>     Call Trace:
>      dump_stack+0x8e/0xce
>      lockdep_rcu_suspicious+0xc5/0x100
>      reservation_object_copy_fences+0x292/0x2b0
>      ? ttm_bo_unref+0x9f/0x3c0 [ttm]
>      ttm_bo_unref+0xbd/0x3c0 [ttm]
>      amdgpu_bo_unref+0x2a/0x50 [amdgpu]
>      amdgpu_gem_object_free+0x4b/0x50 [amdgpu]
>      drm_gem_object_free+0x1f/0x40 [drm]
>      drm_gem_object_put_unlocked+0x40/0xb0 [drm]
>      drm_gem_object_handle_put_unlocked+0x6c/0xb0 [drm]
>      drm_gem_object_release_handle+0x51/0x90 [drm]
>      drm_gem_handle_delete+0x5e/0x90 [drm]
>      ? drm_gem_handle_create+0x40/0x40 [drm]
>      drm_gem_close_ioctl+0x20/0x30 [drm]
>      drm_ioctl_kernel+0x5d/0xb0 [drm]
>      drm_ioctl+0x2f7/0x3b0 [drm]
>      ? drm_gem_handle_create+0x40/0x40 [drm]
>      ? trace_hardirqs_on_caller+0xf4/0x190
>      ? trace_hardirqs_on+0xd/0x10
>      amdgpu_drm_ioctl+0x4f/0x90 [amdgpu]
>      do_vfs_ioctl+0x93/0x670
>      ? __fget+0x108/0x1f0
>      SyS_ioctl+0x79/0x90
>      entry_SYSCALL_64_fastpath+0x23/0xc2
> 
> I've also added the relevant fixes for the issue mentioned above.
> 
> Christian König (3):
>   drm/ttm: fix ttm_bo_cleanup_refs_or_queue once more
>   dma-buf: make reservation_object_copy_fences rcu save
>   drm/amdgpu: reserve root PD while releasing it
> 
> Michel Dänzer (1):
>   drm/ttm: Always and only destroy bo->ttm_resv in ttm_bo_release_list

All now queued up, thanks.

greg k-h
