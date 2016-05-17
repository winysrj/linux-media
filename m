Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:38330 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbcEQH3Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 May 2016 03:29:25 -0400
Subject: Re: [PATCH v4] media: vb2-dma-contig: configure DMA max segment size
 properly
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <5729B396.1020706@xs4all.nl>
 <1462352403-27418-1-git-send-email-m.szyprowski@samsung.com>
 <20160506155216.60dc910c@recife.lan>
 <a8ad2b35-862f-5236-fe16-72b91656ac3a@samsung.com>
 <20160509070920.6a09f915@recife.lan>
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
From: Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <722be2ab-17fa-cece-dd47-0550e20f989e@samsung.com>
Date: Tue, 17 May 2016 09:29:20 +0200
MIME-version: 1.0
In-reply-to: <20160509070920.6a09f915@recife.lan>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear Mauro,


On 2016-05-09 12:09, Mauro Carvalho Chehab wrote:
> Em Mon, 09 May 2016 08:13:06 +0200
> Marek Szyprowski <m.szyprowski@samsung.com> escreveu:
>
>> Hi Mauro
>>
>>
>> On 2016-05-06 20:52, Mauro Carvalho Chehab wrote:
>>> Em Wed, 04 May 2016 11:00:03 +0200
>>> Marek Szyprowski <m.szyprowski@samsung.com> escreveu:
>>>   
>>>> This patch lets vb2-dma-contig memory allocator to configure DMA max
>>>> segment size properly for the client device. Setting it is needed to let
>>>> DMA-mapping subsystem to create a single, contiguous mapping in DMA
>>>> address space. This is essential for all devices, which use dma-contig
>>>> videobuf2 memory allocator and shared buffers (in USERPTR or DMAbuf modes
>>>> of operations).
>>>>
>>>> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
>>>> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>>>> ---
>>>> Hello,
>>>>
>>>> This patch is a follow-up of my previous attempts to let Exynos
>>>> multimedia devices to work properly with shared buffers when IOMMU is
>>>> enabled:
>>>> 1. https://www.mail-archive.com/linux-media@vger.kernel.org/msg96946.html
>>>> 2. http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/97316
>>>> 3. https://patchwork.linuxtv.org/patch/30870/
>>>>
>>>> As sugested by Hans, configuring DMA max segment size should be done by
>>>> videobuf2-dma-contig module instead of requiring all device drivers to
>>>> do it on their own.
>>>>
>>>> Here is some backgroud why this is done in videobuf2-dc not in the
>>>> respective generic bus code:
>>>> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-November/305913.html
>>>>
>>>> Best regards,
>>>> Marek Szyprowski
>>>>
>>>> changelog:
>>>> v4:
>>>> - rebased onto media master tree
>>>> - call vb2_dc_set_max_seg_size after allocating vb2 buf object
>>>>
>>>> v3:
>>>> - added FIXME note about possible memory leak
>>>>
>>>> v2:
>>>> - fixes typos and other language issues in the comments
>>>>
>>>> v1: http://article.gmane.org/gmane.linux.kernel.samsung-soc/53690
>>>> ---
>>>>    drivers/media/v4l2-core/videobuf2-dma-contig.c | 53 +++++++++++++++++++++++++-
>>>>    1 file changed, 51 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
>>>> index 5361197f3e57..6291842a889f 100644
>>>> --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
>>>> +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
>>>> @@ -448,6 +448,42 @@ static void vb2_dc_put_userptr(void *buf_priv)
>>>>    }
>>>>    
>>>>    /*
>>>> + * To allow mapping the scatter-list into a single chunk in the DMA
>>>> + * address space, the device is required to have the DMA max segment
>>>> + * size parameter set to a value larger than the buffer size. Otherwise,
>>>> + * the DMA-mapping subsystem will split the mapping into max segment
>>>> + * size chunks. This function increases the DMA max segment size
>>>> + * parameter to let DMA-mapping map a buffer as a single chunk in DMA
>>>> + * address space.
>>>> + * This code assumes that the DMA-mapping subsystem will merge all
>>>> + * scatterlist segments if this is really possible (for example when
>>>> + * an IOMMU is available and enabled).
>>>> + * Ideally, this parameter should be set by the generic bus code, but it
>>>> + * is left with the default 64KiB value due to historical litmiations in
>>>> + * other subsystems (like limited USB host drivers) and there no good
>>>> + * place to set it to the proper value. It is done here to avoid fixing
>>>> + * all the vb2-dc client drivers.
>>>> + *
>>>> + * FIXME: the allocated dma_params structure is leaked because there
>>>> + * is completely no way to determine when to free it (dma_params might have
>>>> + * been also already allocated by the bus code). However in typical
>>>> + * use cases this function will be called for platform devices, which are
>>>> + * not hot-plugged and exist all the time in the target system.
>>>> + */
>>>> +static int vb2_dc_set_max_seg_size(struct device *dev, unsigned int size)
>>>> +{
>>>> +	if (!dev->dma_parms) {
>>>> +		dev->dma_parms = kzalloc(sizeof(dev->dma_parms), GFP_KERNEL);
>>> Why don't you use devm_kzalloc() here? dma_parms will then be freed
>>> if the device gets hot-unplugged/unbind.
>> Although the structure will be freed, but the pointer in the struct device
>> will still point to the freed resource.
> Then you'll need some other logic (maybe a kref?) both free it and zero
> the pointer when it is safe.
>
> Btw, the only two drivers that seem to dynamically allocate it are
> using devm_*:
>
> drivers/gpu/drm/exynos/exynos_drm_iommu.c:      subdrv_dev->dma_parms = devm_kzalloc(subdrv_dev,
> drivers/gpu/drm/exynos/exynos_drm_iommu.c:                                      sizeof(*subdrv_dev->dma_parms),
> drivers/gpu/drm/exynos/exynos_drm_iommu.c:      if (!subdrv_dev->dma_parms)
> drivers/gpu/drm/rockchip/rockchip_drm_drv.c:    dev->dma_parms = devm_kzalloc(dev, sizeof(*dev->dma_parms),
> drivers/gpu/drm/rockchip/rockchip_drm_drv.c:    if (!dev->dma_parms) {
>
> On the other drivers, the struct is embed on some other struct
> that is freed only after the need of dma_parms.
>
>> Please note that devm_ allocations
>> are freed on driver removal/unbind not on device removal.
> Yes, I know. Personally, I don't like devm_ allocations due to that.
> Yet, it is better to free it later than to keep it leaking.
>
>> That's why I
>> decided
>> to leak memory instead of allowing to access resource that has been freed.
> The problem is that, if a non-platform driver needs to use DMA-CONTIG,
> the leak can be harmful, as things like qemu can unbind the host
> driver in order to use the device by the guest.
>
> Btw, currently, 3 non-platform drivers already use it:
>
> 	drivers/media/pci/dt3155/Kconfig:	select VIDEOBUF2_DMA_CONTIG
> 	drivers/media/pci/solo6x10/Kconfig:	select VIDEOBUF2_DMA_CONTIG
> 	drivers/media/pci/sta2x11/Kconfig:	select VIDEOBUF2_DMA_CONTIG
>
> (and ideally ivtv and cx18 should be converted to VB2 dma-contig some day)
>
> Btw, as the above PCI drivers are not for ARM, I'm wandering if the
> assumptions you took on your patch are also valid on x86 and other
> architectures that support the PCI bus. In any case, if you want to
> do it generic, for all drivers, all bus controllers, you'll need to
> do lots of tests with non-ARM devices, to be 100% sure that it won't
> cause regressions.

Well, the only case when vb2-dma-contig really 'works' is a hacked solution
where userspace provides USERPTR buffer, which is in fact mmaped contig
buffer from the other device. Also DMABUF made of contig buffer should work,
assuming that its exporter won't split it into several chunks. Anything else
will fail, regardless of the arch/platform and the presence of the IOMMU.
Especially the PCI drivers will not support USERPTR/DMABUF modes properly
due to limited dma_max_seg_size property. This is a historical mess related
to scatterlist code, which we cannot do much to improve.

On the other side there are DRM drivers which 'creatively' use scatterlists
by ignoring dma_params limits. In case of vb2-dma-contig this approach 
cannot
be applied, because it relies on dma-mapping subsystem, which always obeys
the limits.

Probably the best would be to leave existing scatterlist API with its
limitations for storage/network drivers and develop something more suitable
for mapping a whole buffer to DMA address space and it for media and drm
(something like dma_map_page_array() or dma_map_pfn_array() will be much
more suitable that using scatter list, which is designed for describing
a 'buffer' with sub-page resolution, typical in case of storage and network
devices).

> On a quick inspection, though, I suspect it will be doing the wrong
> thing for the above drivers, as drivers/pci/probe.c already sets
> dma_parms during pci_device_add(), and enforces a max segment size of
> 64K, by calling	
> 	pci_set_dma_max_seg_size(dev, 65536);
> 	(with is a wrapper to dma_set_max_seg_size)
>
>>> And yes: it is possible to hot-unplug (actually, hot-unbind) a platform
>>> device via sysfs.
>>>
>>> Just assuming that only platform drivers will use dma-contig and adding
>>> a memory leak here seems really ugly!
>> The whole handling of dma_params structure is really ugly and right now
>> there
>> is no good way of ensuring proper dma parameters.
> Yeah, agreed.
>
> Well, there are some alternatives (ordered from the better to the
> worse):
>
> 1) Fix the dma_parms core support;
> 2) Add a pair of functions to register/unregister dma_parms at
>     include/media/videobuf2-dma-contig.h. The driver needing to set
>     it should call the unregister function if it gets unbind/removed;
> 3) Add kref somewhere to do the dma_parms de-allocation in a sane
>     way.
> 4) do any dma_parms-related code inside the drivers, and not at
>     the core (probably not the best idea, but at least we confine
>     the troubles);
>
> I think I would go for (2) for now, and try to do (1) for long
> run.

I've tried with (2) approach, but I was instructed by Hans to do it in the
vb2-core. I can get back to such approach if you want.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

