Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve1eur01on0085.outbound.protection.outlook.com ([104.47.1.85]:10304
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752761AbeFNGjm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Jun 2018 02:39:42 -0400
Subject: Re: [PATCH v3 9/9] xen/gntdev: Implement dma-buf import functionality
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Oleksandr Andrushchenko <andr2000@gmail.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com
References: <20180612134200.17456-1-andr2000@gmail.com>
 <20180612134200.17456-10-andr2000@gmail.com>
 <b08fdccf-2f1b-a902-f00b-a4cecf44a1b1@oracle.com>
 <cca7b9dd-a0c6-8052-c294-9e6c5d65e9eb@epam.com>
 <0f1d87e5-823e-8b51-4ee5-029cc94eff99@oracle.com>
From: Oleksandr Andrushchenko <Oleksandr_Andrushchenko@epam.com>
Message-ID: <987f26ca-b1a7-9175-ffd7-23d247402b41@epam.com>
Date: Thu, 14 Jun 2018 09:39:34 +0300
MIME-Version: 1.0
In-Reply-To: <0f1d87e5-823e-8b51-4ee5-029cc94eff99@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/14/2018 01:03 AM, Boris Ostrovsky wrote:
> On 06/13/2018 05:04 AM, Oleksandr Andrushchenko wrote:
>> On 06/13/2018 06:14 AM, Boris Ostrovsky wrote:
>>>
>>> On 06/12/2018 09:42 AM, Oleksandr Andrushchenko wrote:
>>>
>>>>    int gntdev_dmabuf_imp_release(struct gntdev_dmabuf_priv *priv, u32
>>>> fd)
>>>>    {
>>>> -    return -EINVAL;
>>>> +    struct gntdev_dmabuf *gntdev_dmabuf;
>>>> +    struct dma_buf_attachment *attach;
>>>> +    struct dma_buf *dma_buf;
>>>> +
>>>> +    gntdev_dmabuf = dmabuf_imp_find_unlink(priv, fd);
>>>> +    if (IS_ERR(gntdev_dmabuf))
>>>> +        return PTR_ERR(gntdev_dmabuf);
>>>> +
>>>> +    pr_debug("Releasing DMA buffer with fd %d\n", fd);
>>>> +
>>>> +    attach = gntdev_dmabuf->u.imp.attach;
>>>> +
>>>> +    if (gntdev_dmabuf->u.imp.sgt)
>>>> +        dma_buf_unmap_attachment(attach, gntdev_dmabuf->u.imp.sgt,
>>>> +                     DMA_BIDIRECTIONAL);
>>>> +    dma_buf = attach->dmabuf;
>>>> +    dma_buf_detach(attach->dmabuf, attach);
>>>> +    dma_buf_put(dma_buf);
>>>> +
>>>> +    dmabuf_imp_end_foreign_access(gntdev_dmabuf->u.imp.refs,
>>>> +                      gntdev_dmabuf->nr_pages);
>>>
>>>
>>> Should you first end foreign access, before doing anything?
>>>
>> I am rolling back in reverse order here, so I think we first need
>> to finish local activities with the buffer and then end foreign
>> access.
> Looking at gntdev_dmabuf_imp_to_refs(), the order is
>      dmabuf_imp_alloc_storage()
>      dma_buf_attach()
>      dma_buf_map_attachment()
>      dmabuf_imp_grant_foreign_access()
>
> Or was I looking at wrong place?
Agree, will move as you suggest
> -boris
