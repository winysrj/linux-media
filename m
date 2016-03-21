Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:38216 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbcCUGNu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2016 02:13:50 -0400
Received: by mail-wm0-f45.google.com with SMTP id l68so108704127wml.1
        for <linux-media@vger.kernel.org>; Sun, 20 Mar 2016 23:13:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160319100936.GQ14170@phenom.ffwll.local>
References: <1458331359-2634-1-git-send-email-chris@chris-wilson.co.uk> <20160319100936.GQ14170@phenom.ffwll.local>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Mon, 21 Mar 2016 11:43:29 +0530
Message-ID: <CAO_48GGT48RZaLjg9C+51JyPKzYkkDCFCTrMgfUB+PxQyV8d+Q@mail.gmail.com>
Subject: Re: [PATCH] dma-buf, drm, ion: Propagate error code from dma_buf_start_cpu_access()
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
	devel@driverdev.osuosl.org, intel-gfx@lists.freedesktop.org,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	Linaro MM SIG Mailman List <linaro-mm-sig@lists.linaro.org>,
	Daniel Vetter <daniel.vetter@intel.com>,
	=?UTF-8?Q?St=C3=A9phane_Marchesin?= <marcheu@chromium.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 19 March 2016 at 15:39, Daniel Vetter <daniel@ffwll.ch> wrote:
> On Fri, Mar 18, 2016 at 08:02:39PM +0000, Chris Wilson wrote:
>> Drivers, especially i915.ko, can fail during the initial migration of a
>> dma-buf for CPU access. However, the error code from the driver was not
>> being propagated back to ioctl and so userspace was blissfully ignorant
>> of the failure. Rendering corruption ensues.
>>
>> Whilst fixing the ioctl to return the error code from
>> dma_buf_start_cpu_access(), also do the same for
>> dma_buf_end_cpu_access().  For most drivers, dma_buf_end_cpu_access()
>> cannot fail. i915.ko however, as most drivers would, wants to avoid being
>> uninterruptible (as would be required to guarrantee no failure when
>> flushing the buffer to the device). As userspace already has to handle
>> errors from the SYNC_IOCTL, take advantage of this to be able to restart
>> the syscall across signals.
>>
>> This fixes a coherency issue for i915.ko as well as reducing the
>> uninterruptible hold upon its BKL, the struct_mutex.
>>
>> Fixes commit c11e391da2a8fe973c3c2398452000bed505851e
>> Author: Daniel Vetter <daniel.vetter@ffwll.ch>
>> Date:   Thu Feb 11 20:04:51 2016 -0200
>>
>>     dma-buf: Add ioctls to allow userspace to flush
>>
>> Testcase: igt/gem_concurrent_blit/*dmabuf*interruptible
>> Testcase: igt/prime_mmap_coherency/ioctl-errors
>> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
>> Cc: Tiago Vignatti <tiago.vignatti@intel.com>
>> Cc: Stéphane Marchesin <marcheu@chromium.org>
>> Cc: David Herrmann <dh.herrmann@gmail.com>
>> Cc: Sumit Semwal <sumit.semwal@linaro.org>
>> Cc: Daniel Vetter <daniel.vetter@intel.com>
>> CC: linux-media@vger.kernel.org
>> Cc: dri-devel@lists.freedesktop.org
>> Cc: linaro-mm-sig@lists.linaro.org
>> Cc: intel-gfx@lists.freedesktop.org
>> Cc: devel@driverdev.osuosl.org
>
> Applied to drm-misc, I'll send a pull to Dave the next few days if no one
> screams.
> -Daniel
Thanks for pulling it via drm-misc, Daniel.
Chris, I feel since this is an API change, it also needs an update to
the Documentation file.
With that, and a minor nit below, please feel free to add
Acked-by: Sumit Semwal <sumit.semwal@linaro.org>

>
>> ---
>>  drivers/dma-buf/dma-buf.c                 | 17 +++++++++++------
>>  drivers/gpu/drm/i915/i915_gem_dmabuf.c    | 15 +++++----------
>>  drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c |  5 +++--
>>  drivers/gpu/drm/udl/udl_fb.c              |  4 ++--
>>  drivers/staging/android/ion/ion.c         |  6 ++++--
>>  include/linux/dma-buf.h                   |  6 +++---
>>  6 files changed, 28 insertions(+), 25 deletions(-)
>>
>> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
>> index 9810d1df0691..774a60f4309a 100644
>> --- a/drivers/dma-buf/dma-buf.c
>> +++ b/drivers/dma-buf/dma-buf.c
>> @@ -259,6 +259,7 @@ static long dma_buf_ioctl(struct file *file,
>>       struct dma_buf *dmabuf;
>>       struct dma_buf_sync sync;
>>       enum dma_data_direction direction;
>> +     int ret;
>>
>>       dmabuf = file->private_data;
>>
>> @@ -285,11 +286,11 @@ static long dma_buf_ioctl(struct file *file,
>>               }
>>
>>               if (sync.flags & DMA_BUF_SYNC_END)
>> -                     dma_buf_end_cpu_access(dmabuf, direction);
>> +                     ret = dma_buf_end_cpu_access(dmabuf, direction);
>>               else
>> -                     dma_buf_begin_cpu_access(dmabuf, direction);
>> +                     ret = dma_buf_begin_cpu_access(dmabuf, direction);
>>
>> -             return 0;
>> +             return ret;
>>       default:
>>               return -ENOTTY;
>>       }
>> @@ -613,13 +614,17 @@ EXPORT_SYMBOL_GPL(dma_buf_begin_cpu_access);
>>   *
>>   * This call must always succeed.
>>   */
Perhaps update the above comment to reflect the change as well?

>> -void dma_buf_end_cpu_access(struct dma_buf *dmabuf,
>> -                         enum dma_data_direction direction)
>> +int dma_buf_end_cpu_access(struct dma_buf *dmabuf,
>> +                        enum dma_data_direction direction)
>>  {
>> +     int ret = 0;
>> +
>>       WARN_ON(!dmabuf);
>>
>>       if (dmabuf->ops->end_cpu_access)
>> -             dmabuf->ops->end_cpu_access(dmabuf, direction);
>> +             ret = dmabuf->ops->end_cpu_access(dmabuf, direction);
>> +
>> +     return ret;
>>  }
<< snip>>

Best regards,
Sumit.
