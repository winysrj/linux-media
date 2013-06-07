Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:38225 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643Ab3FGCcZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Jun 2013 22:32:25 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <51B14644.9070706@samsung.com>
Date: Fri, 07 Jun 2013 11:32:36 +0900
From: =?UTF-8?B?6rmA7Iq57Jqw?= <sw0312.kim@samsung.com>
Reply-to: sw0312.kim@samsung.com
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, sumit.semwal@linaro.org,
	airlied@linux.ie, daniel.vetter@ffwll.ch,
	kyungmin.park@samsung.com, linux-kernel@vger.kernel.org,
	Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: Re: [RFC][PATCH 1/2] dma-buf: add importer private data to attachment
References: <1369990487-23510-1-git-send-email-sw0312.kim@samsung.com>
 <1369990487-23510-2-git-send-email-sw0312.kim@samsung.com>
 <51AF3BD7.5070001@canonical.com>
In-reply-to: <51AF3BD7.5070001@canonical.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Maarten,

On 2013년 06월 05일 22:23, Maarten Lankhorst wrote:
> Op 31-05-13 10:54, Seung-Woo Kim schreef:
>> dma-buf attachment has only exporter private data, but importer private data
>> can be useful for importer especially to re-import the same dma-buf.
>> To use importer private data in attachment of the device, the function to
>> search attachment in the attachment list of dma-buf is also added.
>>
>> Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
>> ---
>>  drivers/base/dma-buf.c  |   31 +++++++++++++++++++++++++++++++
>>  include/linux/dma-buf.h |    4 ++++
>>  2 files changed, 35 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
>> index 08fe897..a1eaaf2 100644
>> --- a/drivers/base/dma-buf.c
>> +++ b/drivers/base/dma-buf.c
>> @@ -259,6 +259,37 @@ err_attach:
>>  EXPORT_SYMBOL_GPL(dma_buf_attach);
>>  
>>  /**
>> + * dma_buf_get_attachment - Get attachment with the device from dma_buf's
>> + * attachments list
>> + * @dmabuf:	[in]	buffer to find device from.
>> + * @dev:	[in]	device to be found.
>> + *
>> + * Returns struct dma_buf_attachment * attaching the device; may return
>> + * negative error codes.
>> + *
>> + */
>> +struct dma_buf_attachment *dma_buf_get_attachment(struct dma_buf *dmabuf,
>> +						  struct device *dev)
>> +{
>> +	struct dma_buf_attachment *attach;
>> +
>> +	if (WARN_ON(!dmabuf || !dev))
>> +		return ERR_PTR(-EINVAL);
>> +
>> +	mutex_lock(&dmabuf->lock);
>> +	list_for_each_entry(attach, &dmabuf->attachments, node) {
>> +		if (attach->dev == dev) {
>> +			mutex_unlock(&dmabuf->lock);
>> +			return attach;
>> +		}
>> +	}
>> +	mutex_unlock(&dmabuf->lock);
>> +
>> +	return ERR_PTR(-ENODEV);
>> +}
>> +EXPORT_SYMBOL_GPL(dma_buf_get_attachment);
> NAK in any form..
> 
> Spot the race condition between dma_buf_get_attachment and dma_buf_attach....

Both dma_buf_get_attachment and dma_buf_attach has mutet with
dmabuf->lock, and dma_buf_get_attachment is used for get attachment from
same device before calling dma_buf_attach.

While, dma_buf_detach can removes attachment because it does not have
ref count. So importer should check ref count in its importer private
data before calling dma_buf_detach if the importer want to use
dma_buf_get_attachment.

And dma_buf_get_attachment is for the importer, so exporter attach and
detach callback operation should not call it as like exporter detach
callback operation should not call dma_buf_attach if you mean this kind
of race.

If you have other considerations here, please describe more specifically.

Thanks and Best Regards,
- Seung-Woo Kim

> 
> ~Maarten
> 
> 

-- 
Seung-Woo Kim
Samsung Software R&D Center
--

