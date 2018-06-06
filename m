Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:57032 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751978AbeFFVow (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Jun 2018 17:44:52 -0400
Subject: Re: [PATCH v2 7/9] xen/gntdev: Implement dma-buf export functionality
To: Oleksandr Andrushchenko <andr2000@gmail.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
References: <20180601114132.22596-1-andr2000@gmail.com>
 <20180601114132.22596-8-andr2000@gmail.com>
 <96dd30f5-6ac6-498f-06e7-352e46994576@oracle.com>
 <117e05b3-69f6-b879-50d9-0cddd8e4c313@gmail.com>
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Message-ID: <4b37bbe1-6c5c-1941-bac0-2c7ba88af3e3@oracle.com>
Date: Wed, 6 Jun 2018 17:48:28 -0400
MIME-Version: 1.0
In-Reply-To: <117e05b3-69f6-b879-50d9-0cddd8e4c313@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/06/2018 08:10 AM, Oleksandr Andrushchenko wrote:
> On 06/05/2018 01:07 AM, Boris Ostrovsky wrote:
>> On 06/01/2018 07:41 AM, Oleksandr Andrushchenko wrote:


>> +
>> +static struct sg_table *
>> +dmabuf_exp_ops_map_dma_buf(struct dma_buf_attachment *attach,
>> +               enum dma_data_direction dir)
>> +{
>> +    struct gntdev_dmabuf_attachment *gntdev_dmabuf_attach =
>> attach->priv;
>> +    struct gntdev_dmabuf *gntdev_dmabuf = attach->dmabuf->priv;
>> +    struct sg_table *sgt;
>> +
>> +    pr_debug("Mapping %d pages for dev %p\n", gntdev_dmabuf->nr_pages,
>> +         attach->dev);
>> +
>> +    if (WARN_ON(dir == DMA_NONE || !gntdev_dmabuf_attach))
>>
>> WARN_ON_ONCE. Here and elsewhere.
> Why? The UAPI may be used by different applications, thus we might
> lose warnings for some of them. Having WARN_ON will show problems
> for multiple users, not for the first one.
> Does this make sense to still use WARN_ON?


Just as with pr_err call somewhere else the concern here is that
userland (which I think is where this is eventually called from?) may
intentionally trigger the error, flooding the log.

And even this is not directly called from userland there is still a
possibility of triggering this error multiple times.


>>
>>> +
>>> +    if (use_ptemod) {
>>> +        pr_err("Cannot provide dma-buf: use_ptemode %d\n",
>>> +               use_ptemod);
>> No pr_err here please. This can potentially become a DoS vector as it
>> comes directly from ioctl.
>>
>> I would, in fact, revisit other uses of pr_err in this file.
> Sure, all of pr_err can actually be pr_debug...

I'd check even further and see if any prink is needed. I think I saw a
couple that were not especially useful.


>>> +        return -EINVAL;
>>> +    }
>>> +
>>> +    map = dmabuf_exp_alloc_backing_storage(priv, flags, count);
>>
>> @count comes from userspace. dmabuf_exp_alloc_backing_storage only
>> checks for it to be >0. Should it be checked for some sane max value?
> This is not easy as it is hard to tell what could be that
> max value. For DMA buffers if count is too big then allocation
> will fail, so need to check for max here  (dma_alloc_{xxx} will
> filter out too big allocations).

OK, that may be sufficient. BTW, I believe there were other loops with
@count being the control variable. Please see if a user can pass a bogus
value.

> For Xen balloon allocations I cannot tell what could be that
> max value neither. Tough question how to limit.

I think in balloon there is also a guarantee (of sorts) that something
prior to a loop will fail.


-boris
