Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:34967 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbcCIJke convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Mar 2016 04:40:34 -0500
Received: by mail-lb0-f174.google.com with SMTP id bc4so56814592lbc.2
        for <linux-media@vger.kernel.org>; Wed, 09 Mar 2016 01:40:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56DFEA5F.4000405@vodafone.de>
References: <1457513642-10859-1-git-send-email-benjamin.gaignard@linaro.org>
	<CAKMK7uEzCdaBcOFqmTsFCxKKaXbfxvmkSqEtaotj2F5Giba1pQ@mail.gmail.com>
	<56DFEA5F.4000405@vodafone.de>
Date: Wed, 9 Mar 2016 10:40:31 +0100
Message-ID: <CA+M3ks7V8wdKJP1PqH4hFcUJqXesAYhTDQo7oVDotgTavhw9Sg@mail.gmail.com>
Subject: Re: [PATCH] dmabuf: allow exporter to define customs ioctls
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: =?UTF-8?Q?Christian_K=C3=B6nig?= <deathsimple@vodafone.de>
Cc: Daniel Vetter <daniel@ffwll.ch>,
	dri-devel <dri-devel@lists.freedesktop.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

dmabuf have just accept one ioctl for cache management but I think
that some exporter may need also need custom iotcl.

For example I'm working since a while on a way to secure buffer (SMAF)
[1] which is a central allocator + 2 ioctl for set/get secure status
of the buffer.
This not depend on one device but on the buffer itself and so need to
be handled by the exporter.
To implement this I see 3 solutions:
- create an allocator with ioctl like SMAF but until now I don't get
lot of feedback on this so I guess it is a wrong way.
- add ioctl and ops in dmabuf but if we do that for buffer securing
how many ioctls will have to be handled by dmabuf for other feature?
- let exporters define their own ioctl (like done in ION), it could
allow to create per features helpers for the exporters.

What is the best option when you have to do something relative to the
buffer and to the device ?

Regards,
Benjamin

[1] https://lwn.net/Articles/676270/

2016-03-09 10:18 GMT+01:00 Christian König <deathsimple@vodafone.de>:
> Am 09.03.2016 um 10:03 schrieb Daniel Vetter:
>>
>> On Wed, Mar 9, 2016 at 9:54 AM, Benjamin Gaignard
>> <benjamin.gaignard@linaro.org> wrote:
>>>
>>> In addition of the already existing operations allow exporter
>>> to use it own custom ioctls.
>>>
>>> Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
>>
>> First reaction: No way ever! More seriously, please start by
>> explaining why you need this.
>
>
> I was about to complain as well. Device specific IOCTLs should probably
> better defined as operation on the device which takes the DMA-Buf file
> descriptor as a parameter.
>
> If you really need this (which I doubt) then please define a range of IOCTL
> numbers for which it should apply.
>
> Regards,
> Christian.
>
>
>> -Daniel
>>
>>> ---
>>>   drivers/dma-buf/dma-buf.c | 3 +++
>>>   include/linux/dma-buf.h   | 5 +++++
>>>   2 files changed, 8 insertions(+)
>>>
>>> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
>>> index 9810d1d..6abd129 100644
>>> --- a/drivers/dma-buf/dma-buf.c
>>> +++ b/drivers/dma-buf/dma-buf.c
>>> @@ -291,6 +291,9 @@ static long dma_buf_ioctl(struct file *file,
>>>
>>>                  return 0;
>>>          default:
>>> +               if (dmabuf->ops->ioctl)
>>> +                       return dmabuf->ops->ioctl(dmabuf, cmd, arg);
>>> +
>>>                  return -ENOTTY;
>>>          }
>>>   }
>>> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
>>> index 532108e..b6f9837 100644
>>> --- a/include/linux/dma-buf.h
>>> +++ b/include/linux/dma-buf.h
>>> @@ -70,6 +70,9 @@ struct dma_buf_attachment;
>>>    * @vmap: [optional] creates a virtual mapping for the buffer into
>>> kernel
>>>    *       address space. Same restrictions as for vmap and friends
>>> apply.
>>>    * @vunmap: [optional] unmaps a vmap from the buffer
>>> + * @ioctl: [optional] ioctls supported by the exporter.
>>> + *        It is up to the exporter to do the proper copy_{from/to}_user
>>> + *        calls. Should return -EINVAL in case of error.
>>>    */
>>>   struct dma_buf_ops {
>>>          int (*attach)(struct dma_buf *, struct device *,
>>> @@ -104,6 +107,8 @@ struct dma_buf_ops {
>>>
>>>          void *(*vmap)(struct dma_buf *);
>>>          void (*vunmap)(struct dma_buf *, void *vaddr);
>>> +
>>> +       int (*ioctl)(struct dma_buf *, unsigned int cmd, unsigned long
>>> arg);
>>>   };
>>>
>>>   /**
>>> --
>>> 1.9.1
>>>
>>> _______________________________________________
>>> dri-devel mailing list
>>> dri-devel@lists.freedesktop.org
>>> https://lists.freedesktop.org/mailman/listinfo/dri-devel
>>
>>
>>
>



-- 
Benjamin Gaignard

Graphic Working Group

Linaro.org │ Open source software for ARM SoCs

Follow Linaro: Facebook | Twitter | Blog
