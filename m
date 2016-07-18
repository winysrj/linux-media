Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:37220 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbcGRNEM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2016 09:04:12 -0400
Received: by mail-wm0-f52.google.com with SMTP id i5so115793500wmg.0
        for <linux-media@vger.kernel.org>; Mon, 18 Jul 2016 06:04:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160718121025.GY17101@phenom.ffwll.local>
References: <1468840582-21469-1-git-send-email-chris@chris-wilson.co.uk> <20160718121025.GY17101@phenom.ffwll.local>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Mon, 18 Jul 2016 18:33:51 +0530
Message-ID: <CAO_48GFSJwZhN2-Z6Wn4tJ7oOL-szz0gJcePS32RTPpKm4w=9Q@mail.gmail.com>
Subject: Re: [PATCH] dma-buf: Release module reference on creation failure
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	intel-gfx@lists.freedesktop.org,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Linaro MM SIG Mailman List <linaro-mm-sig@lists.linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Chris,

On 18 July 2016 at 17:40, Daniel Vetter <daniel@ffwll.ch> wrote:
> On Mon, Jul 18, 2016 at 12:16:22PM +0100, Chris Wilson wrote:
>> If we fail to create the anon file, we need to remember to release the
>> module reference on the owner.
>>
Thanks for the patch.

>> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
>> Reviewed-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
>> Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
>> Cc: Sumit Semwal <sumit.semwal@linaro.org>
>> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
>> Cc: linux-media@vger.kernel.org
>> Cc: dri-devel@lists.freedesktop.org
>> Cc: linaro-mm-sig@lists.linaro.org
>> ---
>>  drivers/dma-buf/dma-buf.c | 15 +++++++++++----
>>  1 file changed, 11 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
>> index 20ce0687b111..ddaee60ae52a 100644
>> --- a/drivers/dma-buf/dma-buf.c
>> +++ b/drivers/dma-buf/dma-buf.c
>> @@ -334,6 +334,7 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
>>       struct reservation_object *resv = exp_info->resv;
>>       struct file *file;
>>       size_t alloc_size = sizeof(struct dma_buf);
>> +     int ret;
>
> Not sure this really helps readability, but meh. Will apply to drm-misc,
> with a cc: stable.
Daniel, fwiw, please feel free to add
Acked-by: Sumit Semwal <sumit.semwal@linaro.org>

> -Daniel

BR,
~Sumit.
>
>>
>>       if (!exp_info->resv)
>>               alloc_size += sizeof(struct reservation_object);
>> @@ -357,8 +358,8 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
>>
>>       dmabuf = kzalloc(alloc_size, GFP_KERNEL);
>>       if (!dmabuf) {
>> -             module_put(exp_info->owner);
>> -             return ERR_PTR(-ENOMEM);
>> +             ret = -ENOMEM;
>> +             goto err_module;
>>       }
>>
>>       dmabuf->priv = exp_info->priv;
>> @@ -379,8 +380,8 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
>>       file = anon_inode_getfile("dmabuf", &dma_buf_fops, dmabuf,
>>                                       exp_info->flags);
>>       if (IS_ERR(file)) {
>> -             kfree(dmabuf);
>> -             return ERR_CAST(file);
>> +             ret = PTR_ERR(file);
>> +             goto err_dmabuf;
>>       }
>>
>>       file->f_mode |= FMODE_LSEEK;
>> @@ -394,6 +395,12 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
>>       mutex_unlock(&db_list.lock);
>>
>>       return dmabuf;
>> +
>> +err_dmabuf:
>> +     kfree(dmabuf);
>> +err_module:
>> +     module_put(exp_info->owner);
>> +     return ERR_PTR(ret);
>>  }
>>  EXPORT_SYMBOL_GPL(dma_buf_export);
>>
>> --
>> 2.8.1
>>
>
> --
> Daniel Vetter
> Software Engineer, Intel Corporation
> http://blog.ffwll.ch



-- 
Thanks and regards,

Sumit Semwal
Linaro Mobile Group - Kernel Team Lead
Linaro.org │ Open source software for ARM SoCs
