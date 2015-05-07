Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:33426 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755464AbbEGKrJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 May 2015 06:47:09 -0400
Received: by pdbnk13 with SMTP id nk13so38116265pdb.0
        for <linux-media@vger.kernel.org>; Thu, 07 May 2015 03:47:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150507081026.GA19773@kroah.com>
References: <1430983852-19267-1-git-send-email-sumit.semwal@linaro.org> <20150507081026.GA19773@kroah.com>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Thu, 7 May 2015 16:16:47 +0530
Message-ID: <CAO_48GGjgRP=ab1wjGABguP3BaWPriLou_C-Su2C0kSeMS3Y4Q@mail.gmail.com>
Subject: Re: [PATCH] dma-buf: add ref counting for module as exporter
To: Greg KH <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	Linaro MM SIG Mailman List <linaro-mm-sig@lists.linaro.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	rmk+kernel@arm.linux.org.uk, Dave Airlie <airlied@linux.ie>,
	kgene@kernel.org, Thierry Reding <thierry.reding@gmail.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linaro Kernel Mailman List <linaro-kernel@lists.linaro.org>,
	Rob Clark <robdclark@gmail.com>,
	Daniel Vetter <daniel@ffwll.ch>,
	intel-gfx@lists.freedesktop.org, linux-tegra@vger.kernel.org,
	inki.dae@samsung.com,
	Maarten Lankhorst <maarten.lankhorst@canonical.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 7 May 2015 at 13:40, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Thu, May 07, 2015 at 01:00:52PM +0530, Sumit Semwal wrote:
>> Add reference counting on a kernel module that exports dma-buf and
>> implements its operations. This prevents the module from being unloaded
>> while DMABUF file is in use.
>>
>> The original patch [1] was submitted by Tomasz, but he's since shifted
>> jobs and a ping didn't elicit any response.
>>
>>   [tomasz: Original author]
>> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
>> Acked-by: Daniel Vetter <daniel@ffwll.ch>
>>   [sumits: updated & rebased as per review comments]
>> Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
>>
>> [1]: https://lkml.org/lkml/2012/8/8/163
>> ---
>>  drivers/dma-buf/dma-buf.c                      | 9 ++++++++-
>>  drivers/gpu/drm/armada/armada_gem.c            | 1 +
>>  drivers/gpu/drm/drm_prime.c                    | 1 +
>>  drivers/gpu/drm/exynos/exynos_drm_dmabuf.c     | 1 +
>>  drivers/gpu/drm/i915/i915_gem_dmabuf.c         | 1 +
>>  drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c      | 1 +
>>  drivers/gpu/drm/tegra/gem.c                    | 1 +
>>  drivers/gpu/drm/udl/udl_dmabuf.c               | 1 +
>>  drivers/gpu/drm/vmwgfx/vmwgfx_prime.c          | 1 +
>>  drivers/media/v4l2-core/videobuf2-dma-contig.c | 1 +
>>  drivers/media/v4l2-core/videobuf2-dma-sg.c     | 1 +
>>  drivers/media/v4l2-core/videobuf2-vmalloc.c    | 1 +
>>  drivers/staging/android/ion/ion.c              | 1 +
>>  include/linux/dma-buf.h                        | 2 ++
>>  14 files changed, 22 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
>> index c5a9138a6a8d..9583eac0238f 100644
>> --- a/drivers/dma-buf/dma-buf.c
>> +++ b/drivers/dma-buf/dma-buf.c
>> @@ -29,6 +29,7 @@
>>  #include <linux/anon_inodes.h>
>>  #include <linux/export.h>
>>  #include <linux/debugfs.h>
>> +#include <linux/module.h>
>>  #include <linux/seq_file.h>
>>  #include <linux/poll.h>
>>  #include <linux/reservation.h>
>> @@ -64,6 +65,7 @@ static int dma_buf_release(struct inode *inode, struct file *file)
>>       BUG_ON(dmabuf->cb_shared.active || dmabuf->cb_excl.active);
>>
>>       dmabuf->ops->release(dmabuf);
>> +     module_put(dmabuf->ops->owner);
>>
>>       mutex_lock(&db_list.lock);
>>       list_del(&dmabuf->list_node);
>> @@ -302,9 +304,14 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
>>               return ERR_PTR(-EINVAL);
>>       }
>>
>> +     if (!try_module_get(exp_info->ops->owner))
>> +             return ERR_PTR(-ENOENT);
>> +
>>       dmabuf = kzalloc(alloc_size, GFP_KERNEL);
>> -     if (dmabuf == NULL)
>> +     if (!dmabuf) {
>> +             module_put(exp_info->ops->owner);
>>               return ERR_PTR(-ENOMEM);
>> +     }
>>
>>       dmabuf->priv = exp_info->priv;
>>       dmabuf->ops = exp_info->ops;
>> diff --git a/drivers/gpu/drm/armada/armada_gem.c b/drivers/gpu/drm/armada/armada_gem.c
>> index 580e10acaa3a..d2c5fc1269b7 100644
>> --- a/drivers/gpu/drm/armada/armada_gem.c
>> +++ b/drivers/gpu/drm/armada/armada_gem.c
>> @@ -524,6 +524,7 @@ armada_gem_dmabuf_mmap(struct dma_buf *buf, struct vm_area_struct *vma)
>>  }
>>
>>  static const struct dma_buf_ops armada_gem_prime_dmabuf_ops = {
>> +     .owner = THIS_MODULE,
>>       .map_dma_buf    = armada_gem_prime_map_dma_buf,
>>       .unmap_dma_buf  = armada_gem_prime_unmap_dma_buf,
>>       .release        = drm_gem_dmabuf_release,
>
> The "easier" way to do this is change the registration function to add
> the module owner automatically, which keeps you from having to modify
> all of the individual drivers.  Look at how pci and usb do this for
> their driver registration functions.  That should result in a much
> smaller patch, that always works properly for everyone (there's no way
> for driver to get it wrong.)
>
Thanks Greg; but of course, you're right! We already have a
DEFINE_DMA_BUF_EXPORT_INFO macro, so this is far easier incorporated
into that.

I will spin up the (much simpler) patch and repost!

> thanks,
>
> greg k-h


Best regards,
Sumit.
