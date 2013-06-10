Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:48340 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452Ab3FJAXh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Jun 2013 20:23:37 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <51B51C97.9090006@samsung.com>
Date: Mon, 10 Jun 2013 09:23:51 +0900
From: =?UTF-8?B?6rmA7Iq57Jqw?= <sw0312.kim@samsung.com>
Reply-to: sw0312.kim@samsung.com
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: daniel.vetter@ffwll.ch, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	kyungmin.park@samsung.com, linux-media@vger.kernel.org,
	Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: Re: [RFC][PATCH 1/2] dma-buf: add importer private data to attachment
References: <1369990487-23510-1-git-send-email-sw0312.kim@samsung.com>
 <1369990487-23510-2-git-send-email-sw0312.kim@samsung.com>
 <51AF3BD7.5070001@canonical.com> <51B14644.9070706@samsung.com>
 <51B1C2E8.2030709@canonical.com>
In-reply-to: <51B1C2E8.2030709@canonical.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 2013년 06월 07일 20:24, Maarten Lankhorst wrote:
> Op 07-06-13 04:32, 김승우 schreef:
>> Hello Maarten,
>>
>> On 2013년 06월 05일 22:23, Maarten Lankhorst wrote:
>>> Op 31-05-13 10:54, Seung-Woo Kim schreef:
>>>> dma-buf attachment has only exporter private data, but importer private data
>>>> can be useful for importer especially to re-import the same dma-buf.
>>>> To use importer private data in attachment of the device, the function to
>>>> search attachment in the attachment list of dma-buf is also added.
>>>>
>>>> Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
>>>> ---
>>>>  drivers/base/dma-buf.c  |   31 +++++++++++++++++++++++++++++++
>>>>  include/linux/dma-buf.h |    4 ++++
>>>>  2 files changed, 35 insertions(+), 0 deletions(-)
>>>>
>>>> diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
>>>> index 08fe897..a1eaaf2 100644
>>>> --- a/drivers/base/dma-buf.c
>>>> +++ b/drivers/base/dma-buf.c
>>>> @@ -259,6 +259,37 @@ err_attach:
>>>>  EXPORT_SYMBOL_GPL(dma_buf_attach);
>>>>  
>>>>  /**
>>>> + * dma_buf_get_attachment - Get attachment with the device from dma_buf's
>>>> + * attachments list
>>>> + * @dmabuf:	[in]	buffer to find device from.
>>>> + * @dev:	[in]	device to be found.
>>>> + *
>>>> + * Returns struct dma_buf_attachment * attaching the device; may return
>>>> + * negative error codes.
>>>> + *
>>>> + */
>>>> +struct dma_buf_attachment *dma_buf_get_attachment(struct dma_buf *dmabuf,
>>>> +						  struct device *dev)
>>>> +{
>>>> +	struct dma_buf_attachment *attach;
>>>> +
>>>> +	if (WARN_ON(!dmabuf || !dev))
>>>> +		return ERR_PTR(-EINVAL);
>>>> +
>>>> +	mutex_lock(&dmabuf->lock);
>>>> +	list_for_each_entry(attach, &dmabuf->attachments, node) {
>>>> +		if (attach->dev == dev) {
>>>> +			mutex_unlock(&dmabuf->lock);
>>>> +			return attach;
>>>> +		}
>>>> +	}
>>>> +	mutex_unlock(&dmabuf->lock);
>>>> +
>>>> +	return ERR_PTR(-ENODEV);
>>>> +}
>>>> +EXPORT_SYMBOL_GPL(dma_buf_get_attachment);
>>> NAK in any form..
>>>
>>> Spot the race condition between dma_buf_get_attachment and dma_buf_attach....
>> Both dma_buf_get_attachment and dma_buf_attach has mutet with
>> dmabuf->lock, and dma_buf_get_attachment is used for get attachment from
>> same device before calling dma_buf_attach.
> 
> hint: what happens if 2 threads do this:
> 
> if (IS_ERR(attach = dma_buf_get_attachment(buf, dev)))
> attach = dma_buf_attach(buf, dev);
> 
> There really is no correct usecase for this kind of thing, so please don't do it.

Ok, dma_buf_get_attachment can not prevent attachments from one device.

Anyway, do you think that importer side private data, not to allow
re-import one dma-buf to a device, has some advantage?
If that, I'll add some check_and_attach function, otherwise, I'll find
other way.

Thanks and Regards,
- Seung-Woo Kim

> 
>> While, dma_buf_detach can removes attachment because it does not have
>> ref count. So importer should check ref count in its importer private
>> data before calling dma_buf_detach if the importer want to use
>> dma_buf_get_attachment.
>>
>> And dma_buf_get_attachment is for the importer, so exporter attach and
>> detach callback operation should not call it as like exporter detach
>> callback operation should not call dma_buf_attach if you mean this kind
>> of race.
>>
>> If you have other considerations here, please describe more specifically.
>>
>> Thanks and Best Regards,
>> - Seung-Woo Kim
>>
>>> ~Maarten
>>>
>>>
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
> 

-- 
Seung-Woo Kim
Samsung Software R&D Center
--

