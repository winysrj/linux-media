Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:34670 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750994AbdLAI1E (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Dec 2017 03:27:04 -0500
Reply-To: christian.koenig@amd.com
Subject: Re: [PATCH 0/4] Backported amdgpu ttm deadlock fixes for 4.14
To: Lyude Paul <lyude@redhat.com>, stable@vger.kernel.org
Cc: Chunming Zhou <david1.zhou@amd.com>,
        =?UTF-8?Q?Nicolai_H=c3=a4hnle?= <nicolai.haehnle@amd.com>,
        Sinclair Yeh <syeh@vmware.com>,
        David Airlie <airlied@linux.ie>,
        Harish Kasiviswanathan <harish.kasiviswanathan@amd.com>,
        Felix Kuehling <felix.kuehling@amd.com>,
        "Zhang, Jerry" <jerry.zhang@amd.com>,
        =?UTF-8?Q?Michel_D=c3=a4nzer?= <michel.daenzer@amd.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Sumit Semwal <sumit.semwal@linaro.org>,
        linaro-mm-sig@lists.linaro.org,
        Peter Zijlstra <peterz@infradead.org>,
        amd-gfx@lists.freedesktop.org,
        Alex Deucher <alexander.deucher@amd.com>,
        Alex Xie <alexbin.xie@amd.com>,
        =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
        linux-media@vger.kernel.org
References: <20171201002311.28098-1-lyude@redhat.com>
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>
Message-ID: <34b0eca7-1206-d610-3d8b-fd85200a20b1@gmail.com>
Date: Fri, 1 Dec 2017 09:27:00 +0100
MIME-Version: 1.0
In-Reply-To: <20171201002311.28098-1-lyude@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 01.12.2017 um 01:23 schrieb Lyude Paul:
> I haven't gone to see where it started, but as of late a good number of
> pretty nasty deadlock issues have appeared with the kernel. Easy
> reproduction recipe on a laptop with i915/amdgpu prime with lockdep enabled:
>
> DRI_PRIME=1 glxinfo

Acked-by: Christian König <christian.koenig@amd.com>

Thanks for taking care of this,
Christian.

>
> Additionally, some more race conditions exist that I've managed to
> trigger with piglit and lockdep enabled after applying these patches:
>
>      =============================
>      WARNING: suspicious RCU usage
>      4.14.3Lyude-Test+ #2 Not tainted
>      -----------------------------
>      ./include/linux/reservation.h:216 suspicious rcu_dereference_protected() usage!
>
>      other info that might help us debug this:
>
>      rcu_scheduler_active = 2, debug_locks = 1
>      1 lock held by ext_image_dma_b/27451:
>       #0:  (reservation_ww_class_mutex){+.+.}, at: [<ffffffffa034f2ff>] ttm_bo_unref+0x9f/0x3c0 [ttm]
>
>      stack backtrace:
>      CPU: 0 PID: 27451 Comm: ext_image_dma_b Not tainted 4.14.3Lyude-Test+ #2
>      Hardware name: HP HP ZBook 15 G4/8275, BIOS P70 Ver. 01.02 06/09/2017
>      Call Trace:
>       dump_stack+0x8e/0xce
>       lockdep_rcu_suspicious+0xc5/0x100
>       reservation_object_copy_fences+0x292/0x2b0
>       ? ttm_bo_unref+0x9f/0x3c0 [ttm]
>       ttm_bo_unref+0xbd/0x3c0 [ttm]
>       amdgpu_bo_unref+0x2a/0x50 [amdgpu]
>       amdgpu_gem_object_free+0x4b/0x50 [amdgpu]
>       drm_gem_object_free+0x1f/0x40 [drm]
>       drm_gem_object_put_unlocked+0x40/0xb0 [drm]
>       drm_gem_object_handle_put_unlocked+0x6c/0xb0 [drm]
>       drm_gem_object_release_handle+0x51/0x90 [drm]
>       drm_gem_handle_delete+0x5e/0x90 [drm]
>       ? drm_gem_handle_create+0x40/0x40 [drm]
>       drm_gem_close_ioctl+0x20/0x30 [drm]
>       drm_ioctl_kernel+0x5d/0xb0 [drm]
>       drm_ioctl+0x2f7/0x3b0 [drm]
>       ? drm_gem_handle_create+0x40/0x40 [drm]
>       ? trace_hardirqs_on_caller+0xf4/0x190
>       ? trace_hardirqs_on+0xd/0x10
>       amdgpu_drm_ioctl+0x4f/0x90 [amdgpu]
>       do_vfs_ioctl+0x93/0x670
>       ? __fget+0x108/0x1f0
>       SyS_ioctl+0x79/0x90
>       entry_SYSCALL_64_fastpath+0x23/0xc2
>
> I've also added the relevant fixes for the issue mentioned above.
>
> Christian König (3):
>    drm/ttm: fix ttm_bo_cleanup_refs_or_queue once more
>    dma-buf: make reservation_object_copy_fences rcu save
>    drm/amdgpu: reserve root PD while releasing it
>
> Michel Dänzer (1):
>    drm/ttm: Always and only destroy bo->ttm_resv in ttm_bo_release_list
>
>   drivers/dma-buf/reservation.c          | 56 +++++++++++++++++++++++++---------
>   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c | 13 ++++++--
>   drivers/gpu/drm/ttm/ttm_bo.c           | 43 +++++++++++++-------------
>   3 files changed, 74 insertions(+), 38 deletions(-)
>
> --
> 2.14.3
>
> _______________________________________________
> amd-gfx mailing list
> amd-gfx@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/amd-gfx
