Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:39357 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752979AbeC2Le2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Mar 2018 07:34:28 -0400
Reply-To: christian.koenig@amd.com
Subject: Re: [PATCH 4/8] dma-buf: add peer2peer flag
To: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
References: <20180325110000.2238-1-christian.koenig@amd.com>
 <20180325110000.2238-4-christian.koenig@amd.com>
 <20180329065753.GD3881@phenom.ffwll.local>
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>
Message-ID: <8b823458-8bdc-3217-572b-509a28aae742@gmail.com>
Date: Thu, 29 Mar 2018 13:34:24 +0200
MIME-Version: 1.0
In-Reply-To: <20180329065753.GD3881@phenom.ffwll.local>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 29.03.2018 um 08:57 schrieb Daniel Vetter:
> On Sun, Mar 25, 2018 at 12:59:56PM +0200, Christian König wrote:
>> Add a peer2peer flag noting that the importer can deal with device
>> resources which are not backed by pages.
>>
>> Signed-off-by: Christian König <christian.koenig@amd.com>
> Um strictly speaking they all should, but ttm never bothered to use the
> real interfaces but just hacked around the provided sg list, grabbing the
> underlying struct pages, then rebuilding&remapping the sg list again.

Actually that isn't correct. TTM converts them to a dma address array 
because drivers need it like this (at least nouveau, radeon and amdgpu).

I've fixed radeon and amdgpu to be able to deal without it and mailed 
with Ben about nouveau, but the outcome is they don't really know.

TTM itself doesn't have any need for the pages on imported BOs (you 
can't mmap them anyway), the real underlying problem is that sg tables 
doesn't provide what drivers need.

I think we could rather easily fix sg tables, but that is a totally 
separate task.

> The entire point of using sg lists was exactly to allow this use case of
> peer2peer dma (or well in general have special exporters which managed
> memory/IO ranges not backed by struct page). So essentially you're having
> a "I'm totally not broken flag" here.

No, independent of needed struct page pointers we need to note if the 
exporter can handle peer2peer stuff from the hardware side in general.

So what I've did is just to set peer2peer allowed on the importer 
because of the driver needs and clear it in the exporter if the hardware 
can't handle that.

> I think a better approach would be if we add a requires_struct_page or so,
> and annotate the current importers accordingly. Or we just fix them up (it
> is all in shared ttm code after all, I think everyone else got this
> right).

I would rather not bed on that.

Christian.

> -Daniel
>
>> ---
>>   drivers/dma-buf/dma-buf.c | 1 +
>>   include/linux/dma-buf.h   | 4 ++++
>>   2 files changed, 5 insertions(+)
>>
>> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
>> index ffaa2f9a9c2c..f420225f93c6 100644
>> --- a/drivers/dma-buf/dma-buf.c
>> +++ b/drivers/dma-buf/dma-buf.c
>> @@ -565,6 +565,7 @@ struct dma_buf_attachment *dma_buf_attach(const struct dma_buf_attach_info *info
>>   
>>   	attach->dev = info->dev;
>>   	attach->dmabuf = dmabuf;
>> +	attach->peer2peer = info->peer2peer;
>>   	attach->priv = info->priv;
>>   	attach->invalidate = info->invalidate;
>>   
>> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
>> index 15dd8598bff1..1ef50bd9bc5b 100644
>> --- a/include/linux/dma-buf.h
>> +++ b/include/linux/dma-buf.h
>> @@ -313,6 +313,7 @@ struct dma_buf {
>>    * @dmabuf: buffer for this attachment.
>>    * @dev: device attached to the buffer.
>>    * @node: list of dma_buf_attachment.
>> + * @peer2peer: true if the importer can handle peer resources without pages.
>>    * @priv: exporter specific attachment data.
>>    *
>>    * This structure holds the attachment information between the dma_buf buffer
>> @@ -328,6 +329,7 @@ struct dma_buf_attachment {
>>   	struct dma_buf *dmabuf;
>>   	struct device *dev;
>>   	struct list_head node;
>> +	bool peer2peer;
>>   	void *priv;
>>   
>>   	/**
>> @@ -392,6 +394,7 @@ struct dma_buf_export_info {
>>    * @dmabuf:	the exported dma_buf
>>    * @dev:	the device which wants to import the attachment
>>    * @priv:	private data of importer to this attachment
>> + * @peer2peer:	true if the importer can handle peer resources without pages
>>    * @invalidate:	callback to use for invalidating mappings
>>    *
>>    * This structure holds the information required to attach to a buffer. Used
>> @@ -401,6 +404,7 @@ struct dma_buf_attach_info {
>>   	struct dma_buf *dmabuf;
>>   	struct device *dev;
>>   	void *priv;
>> +	bool peer2peer;
>>   	void (*invalidate)(struct dma_buf_attachment *attach);
>>   };
>>   
>> -- 
>> 2.14.1
>>
>> _______________________________________________
>> dri-devel mailing list
>> dri-devel@lists.freedesktop.org
>> https://lists.freedesktop.org/mailman/listinfo/dri-devel
