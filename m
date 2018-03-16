Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f170.google.com ([209.85.128.170]:46172 "EHLO
        mail-wr0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753210AbeCPOWf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Mar 2018 10:22:35 -0400
Received: by mail-wr0-f170.google.com with SMTP id m12so11830653wrm.13
        for <linux-media@vger.kernel.org>; Fri, 16 Mar 2018 07:22:34 -0700 (PDT)
Reply-To: christian.koenig@amd.com
Subject: Re: [PATCH 1/5] dma-buf: add optional invalidate_mappings callback v2
To: Chris Wilson <chris@chris-wilson.co.uk>,
        linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org
References: <20180316132049.1748-1-christian.koenig@amd.com>
 <20180316132049.1748-2-christian.koenig@amd.com>
 <152120831102.25315.4326885184264378830@mail.alporthouse.com>
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>
Message-ID: <21879456-db47-589c-b5e2-dfe8333d9e4c@gmail.com>
Date: Fri, 16 Mar 2018 15:22:32 +0100
MIME-Version: 1.0
In-Reply-To: <152120831102.25315.4326885184264378830@mail.alporthouse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 16.03.2018 um 14:51 schrieb Chris Wilson:
> Quoting Christian König (2018-03-16 13:20:45)
>> @@ -326,6 +338,29 @@ struct dma_buf_attachment {
>>          struct device *dev;
>>          struct list_head node;
>>          void *priv;
>> +
>> +       /**
>> +        * @invalidate_mappings:
>> +        *
>> +        * Optional callback provided by the importer of the attachment which
>> +        * must be set before mappings are created.
>> +        *
>> +        * If provided the exporter can avoid pinning the backing store while
>> +        * mappings exists.
> Hmm, no I don't think it avoids the pinning issue entirely. As it stands,
> the importer doesn't have a page refcount and so they all rely on the
> exporter keeping the dmabuf pages pinned while attached. What can happen
> is that given the invalidate cb, the importers can revoke their
> attachments, letting the exporter recover the pages/sg, and then start
> again from scratch.

Yes, exactly. The wording is just not 100% precise and I haven't found 
something better so far.

> That also neatly answers what happens if not all importers provide an
> invalidate cb, or fail, the dmabuf remains pinned and the exporter must
> retreat.

Yes, exactly as well. As soon as at least one importer says "I can't do 
this", we must fallback to the old behavior.

>> +        *
>> +        * The function is called with the lock of the reservation object
>> +        * associated with the dma_buf held and the mapping function must be
>> +        * called with this lock held as well. This makes sure that no mapping
>> +        * is created concurrently with an ongoing invalidation.
>> +        *
>> +        * After the callback all existing mappings are still valid until all
>> +        * fences in the dma_bufs reservation object are signaled, but should be
>> +        * destroyed by the importer as soon as possible.
>> +        *
>> +        * New mappings can be created immediately, but can't be used before the
>> +        * exclusive fence in the dma_bufs reservation object is signaled.
>> +        */
>> +       void (*invalidate_mappings)(struct dma_buf_attachment *attach);
> The intent is that the invalidate is synchronous and immediate, while
> locked? We are looking at recursing back into the dma_buf functions to
> remove each attachment from the invalidate cb (as well as waiting for
> dma), won't that cause some nasty issues?

No, with this idea invalidation is asynchronous. Already discussed that 
with Daniel as well and YES Daniel also already pointed out that I need 
to better document this.

When the exporter calls invalidate_mappings() it just means that all 
importers can no longer use their sg tables for new submissions, old 
ones stay active.

The existing sg tables are guaranteed to stay valid until all fences in 
the reservation object have signaled and the importer should also delay 
it's call to call dma_buf_unmap_attachment() until all the fences have 
signaled.

When the importer has new work to do, e.g. wants to attach a new fence 
to the reservation object, it must grab a new sg table for that. The 
importer also needs to make sure that all new work touching the dma-buf 
doesn't start before the exclusive fence in the reservation object signals.

This allows for full grown pipelining, e.g. the exporter can say I need 
to move the buffer for some operation. Then let the move operation wait 
for all existing fences in the reservation object and install the fence 
of the move operation as exclusive fence.

The importer can then immediately grab a new sg table for the new 
location of the buffer and use it to prepare the next operation.

Regards,
Christian.

> -Chris
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel
