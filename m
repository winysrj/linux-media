Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:33895 "EHLO
	mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbbHMOWC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Aug 2015 10:22:02 -0400
Received: by iodb91 with SMTP id b91so53289065iod.1
        for <linux-media@vger.kernel.org>; Thu, 13 Aug 2015 07:22:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55CCA07A.2090904@samsung.com>
References: <1439373533-23299-1-git-send-email-m.szyprowski@samsung.com>
	<55CC904E.4040907@metafoo.de>
	<55CCA07A.2090904@samsung.com>
Date: Thu, 13 Aug 2015 08:22:01 -0600
Message-ID: <CAKocOOMptUUgn9WPFn_dOYYRrR3VerYaSMuvNCQ+TuE-shk=_A@mail.gmail.com>
Subject: Re: [PATCH v2] media: videobuf2-dc: set properly dma_max_segment_size
From: Shuah Khan <shuahkhan@gmail.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>, linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	shuahkh@osg.samsung.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 13, 2015 at 7:49 AM, Marek Szyprowski
<m.szyprowski@samsung.com> wrote:
> Hello,
>
>
> On 2015-08-13 14:40, Lars-Peter Clausen wrote:
>>
>> On 08/12/2015 11:58 AM, Marek Szyprowski wrote:
>>>
>>> If device has no DMA max_seg_size set, we assume that there is no limit
>>> and it is safe to force it to use DMA_BIT_MASK(32) as max_seg_size to
>>> let DMA-mapping API always create contiguous mappings in DMA address
>>> space. This is essential for all devices, which use dma-contig
>>> videobuf2 memory allocator.
>>>
>>> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
>>> ---
>>> Changelog:
>>> v2:
>>> - set max segment size only if a new dma params structure has been
>>>    allocated, as suggested by Laurent Pinchart
>>> ---
>>>   drivers/media/v4l2-core/videobuf2-dma-contig.c | 15 +++++++++++++++
>>>   1 file changed, 15 insertions(+)
>>>
>>> diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c
>>> b/drivers/media/v4l2-core/videobuf2-dma-contig.c
>>> index 94c1e64..455e925 100644
>>> --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
>>> +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
>>> @@ -862,6 +862,21 @@ EXPORT_SYMBOL_GPL(vb2_dma_contig_memops);
>>>   void *vb2_dma_contig_init_ctx(struct device *dev)
>>>   {
>>>         struct vb2_dc_conf *conf;
>>> +       int err;
>>> +
>>> +       /*
>>> +        * if device has no max_seg_size set, we assume that there is no
>>> limit
>>> +        * and force it to DMA_BIT_MASK(32) to always use contiguous
>>> mappings
>>> +        * in DMA address space
>>> +        */
>>> +       if (!dev->dma_parms) {
>>> +               dev->dma_parms = kzalloc(sizeof(*dev->dma_parms),
>>> GFP_KERNEL);
>>> +               if (!dev->dma_parms)
>>> +                       return ERR_PTR(-ENOMEM);
>>> +               err = dma_set_max_seg_size(dev, DMA_BIT_MASK(32));
>>> +               if (err)
>>> +                       return ERR_PTR(err);
>>> +       }
>>
>> I'm not sure if this is such a good idea. The DMA provider is responsible
>> for setting this up. We shouldn't be overwriting this here on the DMA
>> consumer side. This will just mask the bug that the provider didn't setup
>> this correctly and might cause bugs on its own if it is not correct. It
>> will
>> lead to conflicts with DMA providers that have multiple consumers (e.g.
>> shared DMA core). And also the current assumption is that if a driver
>> doesn't set this up explicitly the maximum segement size is 65536.
>
>
> The problem is that there is no good place for changing this extremely low
> default
> value. V4L2 media devices, which use videobuf2-dc expects to get buffers
> mapped
> contiguous in the DMA/IO address space. Initially I wanted to have a code
> for
> setting dma max segment size directly in the dma-mapping subsystem. This
> however
> causeed problems in the other places, as mentioned in the following mail:
> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-November/305913.html
>
> It looks that there are drivers or subsystems which rely on this strange 64k
> value,
> rending the whole concept rather useless.
>

Would this approach make the driver not work on some architectures? Very
few drives tweak this value. I found 19 calls to the dma_set_max_seg_size()
functions directly and a handful via pci_set_dma_max_seg_size().

Is this one those, "use if you absolutely have to" interfaces?

thanks,
-- Shuah
