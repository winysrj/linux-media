Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f47.google.com ([209.85.219.47]:50553 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863Ab3CYLZO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Mar 2013 07:25:14 -0400
Received: by mail-oa0-f47.google.com with SMTP id o17so6207449oag.6
        for <linux-media@vger.kernel.org>; Mon, 25 Mar 2013 04:25:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130318204948.6deeb166@redhat.com>
References: <1360195382-32317-1-git-send-email-sheu@google.com>
 <1360195382-32317-3-git-send-email-sheu@google.com> <511380F4.2070806@linaro.org>
 <20130318204948.6deeb166@redhat.com>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Mon, 25 Mar 2013 16:54:53 +0530
Message-ID: <CAO_48GFCWe+6JmYH4-t_HNXC-wwEdA6bCGMzbWH7ZCOmqS8R0Q@mail.gmail.com>
Subject: Re: [PATCH 3/3] dma-buf: restore args on failure of dma_buf_mmap
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: John Sheu <sheu@google.com>, linux-media@vger.kernel.org,
	John Sheu <sheu@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 19 March 2013 05:19, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> Em Thu, 07 Feb 2013 15:54:52 +0530
> Sumit Semwal <sumit.semwal@linaro.org> escreveu:
>
>> Hi John,
>>
>> On Thursday 07 February 2013 05:33 AM, John Sheu wrote:
>> > From: John Sheu <sheu@chromium.org>
>> >
>> > Callers to dma_buf_mmap expect to fput() the vma struct's vm_file
>> > themselves on failure.  Not restoring the struct's data on failure
>> > causes a double-decrement of the vm_file's refcount.
>> Thanks for your patch; could you please re-send it to the correct,
>> relevant lists and me (as the maintainer of dma-buf) rather than just to
>> linux-media ml?
>
> Yes, it doesn't make sense to apply this one via the media tree ;)
>
> I'm applying patches 1 and 2, as they should go through the media tree.
Sure, this patch is already in mainline as of 3.9-rc1 :)
>
> Thanks!
> Mauro
>>
>> I just chanced to see this patch, otherwise it could easily have slipped
>> past me (and other interested parties).
>>
>> You could run scripts/get_maintainer.pl on your patch to find out the
>> right lists / email IDs to CC.
>>
>> Thanks and best regards,
>> ~Sumit.
>> >
>> > Signed-off-by: John Sheu <sheu@google.com>
>> > ---
>> >   drivers/base/dma-buf.c | 18 ++++++++++++++----
>> >   1 file changed, 14 insertions(+), 4 deletions(-)
>> >
>> > diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
>> > index a3f79c4..01daf9c 100644
>> > --- a/drivers/base/dma-buf.c
>> > +++ b/drivers/base/dma-buf.c
>> > @@ -446,6 +446,9 @@ EXPORT_SYMBOL_GPL(dma_buf_kunmap);
>> >   int dma_buf_mmap(struct dma_buf *dmabuf, struct vm_area_struct *vma,
>> >              unsigned long pgoff)
>> >   {
>> > +   struct file *oldfile;
>> > +   int ret;
>> > +
>> >     if (WARN_ON(!dmabuf || !vma))
>> >             return -EINVAL;
>> >
>> > @@ -459,14 +462,21 @@ int dma_buf_mmap(struct dma_buf *dmabuf, struct vm_area_struct *vma,
>> >             return -EINVAL;
>> >
>> >     /* readjust the vma */
>> > -   if (vma->vm_file)
>> > -           fput(vma->vm_file);
>> > -
>> > +   oldfile = vma->vm_file;
>> >     vma->vm_file = get_file(dmabuf->file);
>> >
>> >     vma->vm_pgoff = pgoff;
>> >
>> > -   return dmabuf->ops->mmap(dmabuf, vma);
>> > +   ret = dmabuf->ops->mmap(dmabuf, vma);
>> > +   if (ret) {
>> > +           /* restore old parameters on failure */
>> > +           vma->vm_file = oldfile;
>> > +           fput(dmabuf->file);
>> > +   } else {
>> > +           if (oldfile)
>> > +                   fput(oldfile);
>> > +   }
>> > +   return ret;
>> >   }
>> >   EXPORT_SYMBOL_GPL(dma_buf_mmap);
>> >
>> >
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
> --
>
> Cheers,
> Mauro



--
Thanks and regards,

Sumit Semwal

Linaro Kernel Engineer - Graphics working group

Linaro.org │ Open source software for ARM SoCs

Follow Linaro: Facebook | Twitter | Blog
