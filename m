Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f51.google.com ([209.85.219.51]:37206 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758327Ab3BLIt0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Feb 2013 03:49:26 -0500
Received: by mail-oa0-f51.google.com with SMTP id h2so7363525oag.24
        for <linux-media@vger.kernel.org>; Tue, 12 Feb 2013 00:49:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAO_48GFp=L-xT4MxBRGAzjM5M4wP-=ra6Qzp7kA4yoD=Vds6CQ@mail.gmail.com>
References: <1360633824-2563-1-git-send-email-sheu@google.com> <CAO_48GFp=L-xT4MxBRGAzjM5M4wP-=ra6Qzp7kA4yoD=Vds6CQ@mail.gmail.com>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Tue, 12 Feb 2013 14:19:06 +0530
Message-ID: <CAO_48GFTULwiA1TeUeDLU-CJ5VUjhBdW8Jh+7rArB_k-yegukA@mail.gmail.com>
Subject: Re: [PATCH] CHROMIUM: dma-buf: restore args on failure of dma_buf_mmap
To: sheu <sheu@google.com>
Cc: linux-media@vger.kernel.org,
	Linaro MM SIG <linaro-mm-sig@lists.linaro.org>,
	DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

+dri-devel ML
>
>
> On 12 February 2013 07:20, <sheu@google.com> wrote:
>>
>> From: John Sheu <sheu@google.com>
>>
>> Callers to dma_buf_mmap expect to fput() the vma struct's vm_file
>> themselves on failure.  Not restoring the struct's data on failure
>> causes a double-decrement of the vm_file's refcount.
>>
>> Signed-off-by: John Sheu <sheu@google.com>
>>
>> ---
>>  drivers/base/dma-buf.c |   21 +++++++++++++++------
>>  1 files changed, 15 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
>> index 09e6878..06c6225 100644
>> --- a/drivers/base/dma-buf.c
>> +++ b/drivers/base/dma-buf.c
>> @@ -536,6 +536,9 @@ EXPORT_SYMBOL_GPL(dma_buf_kunmap);
>>  int dma_buf_mmap(struct dma_buf *dmabuf, struct vm_area_struct *vma,
>>                  unsigned long pgoff)
>>  {
>> +       struct file *oldfile;
>> +       int ret;
>> +
>>         if (WARN_ON(!dmabuf || !vma))
>>                 return -EINVAL;
>>
>> @@ -549,15 +552,21 @@ int dma_buf_mmap(struct dma_buf *dmabuf, struct
>> vm_area_struct *vma,
>>                 return -EINVAL;
>>
>>         /* readjust the vma */
>> -       if (vma->vm_file)
>> -               fput(vma->vm_file);
>> -
>> +       get_file(dmabuf->file);
>> +       oldfile = vma->vm_file;
>>         vma->vm_file = dmabuf->file;
>> -       get_file(vma->vm_file);
>> -
>>         vma->vm_pgoff = pgoff;
>>
>> -       return dmabuf->ops->mmap(dmabuf, vma);
>> +       ret = dmabuf->ops->mmap(dmabuf, vma);
>> +       if (ret) {
>> +               /* restore old parameters on failure */
>> +               vma->vm_file = oldfile;
>> +               fput(dmabuf->file);
>> +       } else {
>> +               if (oldfile)
>> +                       fput(oldfile);
>> +       }
>> +       return ret;
>>  }
>>  EXPORT_SYMBOL_GPL(dma_buf_mmap);
>>
>> --
>> 1.7.8.6
>>
>
>
>
> --
>
> Thanks and regards,
>
> Sumit Semwal
>
> Linaro Kernel Engineer - Graphics working group
>
> Linaro.org │ Open source software for ARM SoCs
>
> Follow Linaro: Facebook | Twitter | Blog



-- 
Thanks and regards,

Sumit Semwal

Linaro Kernel Engineer - Graphics working group

Linaro.org │ Open source software for ARM SoCs

Follow Linaro: Facebook | Twitter | Blog
