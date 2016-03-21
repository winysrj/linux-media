Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:49628 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755381AbcCUNNQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2016 09:13:16 -0400
Subject: Re: [PATCH] dma-buf,drm,ion: Propagate error code from
 dma_buf_start_cpu_access()
To: Chris Wilson <chris@chris-wilson.co.uk>,
	intel-gfx@lists.freedesktop.org
References: <1458331359-2634-1-git-send-email-chris@chris-wilson.co.uk>
Cc: =?UTF-8?Q?St=c3=a9phane_Marchesin?= <marcheu@chromium.org>,
	David Herrmann <dh.herrmann@gmail.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Daniel Vetter <daniel.vetter@intel.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, devel@driverdev.osuosl.org
From: Tiago Vignatti <tiago.vignatti@intel.com>
Message-ID: <56EFF366.3080908@intel.com>
Date: Mon, 21 Mar 2016 10:13:10 -0300
MIME-Version: 1.0
In-Reply-To: <1458331359-2634-1-git-send-email-chris@chris-wilson.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/18/2016 05:02 PM, Chris Wilson wrote:
> Drivers, especially i915.ko, can fail during the initial migration of a
> dma-buf for CPU access. However, the error code from the driver was not
> being propagated back to ioctl and so userspace was blissfully ignorant
> of the failure. Rendering corruption ensues.
>
> Whilst fixing the ioctl to return the error code from
> dma_buf_start_cpu_access(), also do the same for
> dma_buf_end_cpu_access().  For most drivers, dma_buf_end_cpu_access()
> cannot fail. i915.ko however, as most drivers would, wants to avoid being
> uninterruptible (as would be required to guarrantee no failure when
> flushing the buffer to the device). As userspace already has to handle
> errors from the SYNC_IOCTL, take advantage of this to be able to restart
> the syscall across signals.
>
> This fixes a coherency issue for i915.ko as well as reducing the
> uninterruptible hold upon its BKL, the struct_mutex.
>
> Fixes commit c11e391da2a8fe973c3c2398452000bed505851e
> Author: Daniel Vetter <daniel.vetter@ffwll.ch>
> Date:   Thu Feb 11 20:04:51 2016 -0200
>
>      dma-buf: Add ioctls to allow userspace to flush
>
> Testcase: igt/gem_concurrent_blit/*dmabuf*interruptible
> Testcase: igt/prime_mmap_coherency/ioctl-errors
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Tiago Vignatti <tiago.vignatti@intel.com>
> Cc: Stéphane Marchesin <marcheu@chromium.org>
> Cc: David Herrmann <dh.herrmann@gmail.com>
> Cc: Sumit Semwal <sumit.semwal@linaro.org>
> Cc: Daniel Vetter <daniel.vetter@intel.com>
> CC: linux-media@vger.kernel.org
> Cc: dri-devel@lists.freedesktop.org
> Cc: linaro-mm-sig@lists.linaro.org
> Cc: intel-gfx@lists.freedesktop.org
> Cc: devel@driverdev.osuosl.org

Reviewed-by: Tiago Vignatti <tiago.vignatti@intel.com>

Best regards,

Tiago

