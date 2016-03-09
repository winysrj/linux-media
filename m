Return-path: <linux-media-owner@vger.kernel.org>
Received: from pegasos-out.vodafone.de ([80.84.1.38]:44022 "EHLO
	pegasos-out.vodafone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbcCIJ0r (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Mar 2016 04:26:47 -0500
Subject: Re: [PATCH] dmabuf: allow exporter to define customs ioctls
To: Daniel Vetter <daniel@ffwll.ch>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>
References: <1457513642-10859-1-git-send-email-benjamin.gaignard@linaro.org>
 <CAKMK7uEzCdaBcOFqmTsFCxKKaXbfxvmkSqEtaotj2F5Giba1pQ@mail.gmail.com>
Cc: dri-devel <dri-devel@lists.freedesktop.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <deathsimple@vodafone.de>
Message-ID: <56DFEA5F.4000405@vodafone.de>
Date: Wed, 9 Mar 2016 10:18:23 +0100
MIME-Version: 1.0
In-Reply-To: <CAKMK7uEzCdaBcOFqmTsFCxKKaXbfxvmkSqEtaotj2F5Giba1pQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 09.03.2016 um 10:03 schrieb Daniel Vetter:
> On Wed, Mar 9, 2016 at 9:54 AM, Benjamin Gaignard
> <benjamin.gaignard@linaro.org> wrote:
>> In addition of the already existing operations allow exporter
>> to use it own custom ioctls.
>>
>> Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
> First reaction: No way ever! More seriously, please start by
> explaining why you need this.

I was about to complain as well. Device specific IOCTLs should probably 
better defined as operation on the device which takes the DMA-Buf file 
descriptor as a parameter.

If you really need this (which I doubt) then please define a range of 
IOCTL numbers for which it should apply.

Regards,
Christian.

> -Daniel
>
>> ---
>>   drivers/dma-buf/dma-buf.c | 3 +++
>>   include/linux/dma-buf.h   | 5 +++++
>>   2 files changed, 8 insertions(+)
>>
>> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
>> index 9810d1d..6abd129 100644
>> --- a/drivers/dma-buf/dma-buf.c
>> +++ b/drivers/dma-buf/dma-buf.c
>> @@ -291,6 +291,9 @@ static long dma_buf_ioctl(struct file *file,
>>
>>                  return 0;
>>          default:
>> +               if (dmabuf->ops->ioctl)
>> +                       return dmabuf->ops->ioctl(dmabuf, cmd, arg);
>> +
>>                  return -ENOTTY;
>>          }
>>   }
>> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
>> index 532108e..b6f9837 100644
>> --- a/include/linux/dma-buf.h
>> +++ b/include/linux/dma-buf.h
>> @@ -70,6 +70,9 @@ struct dma_buf_attachment;
>>    * @vmap: [optional] creates a virtual mapping for the buffer into kernel
>>    *       address space. Same restrictions as for vmap and friends apply.
>>    * @vunmap: [optional] unmaps a vmap from the buffer
>> + * @ioctl: [optional] ioctls supported by the exporter.
>> + *        It is up to the exporter to do the proper copy_{from/to}_user
>> + *        calls. Should return -EINVAL in case of error.
>>    */
>>   struct dma_buf_ops {
>>          int (*attach)(struct dma_buf *, struct device *,
>> @@ -104,6 +107,8 @@ struct dma_buf_ops {
>>
>>          void *(*vmap)(struct dma_buf *);
>>          void (*vunmap)(struct dma_buf *, void *vaddr);
>> +
>> +       int (*ioctl)(struct dma_buf *, unsigned int cmd, unsigned long arg);
>>   };
>>
>>   /**
>> --
>> 1.9.1
>>
>> _______________________________________________
>> dri-devel mailing list
>> dri-devel@lists.freedesktop.org
>> https://lists.freedesktop.org/mailman/listinfo/dri-devel
>
>

