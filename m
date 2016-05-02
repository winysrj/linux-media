Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:58216 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753208AbcEBIjZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 2 May 2016 04:39:25 -0400
Subject: Re: [PATCH v2] media: vb2-dma-contig: configure DMA max segment size
 properly
To: Sakari Ailus <sakari.ailus@iki.fi>,
	Marek Szyprowski <m.szyprowski@samsung.com>
References: <57220299.3000807@xs4all.nl>
 <1461849603-6313-1-git-send-email-m.szyprowski@samsung.com>
 <20160429112110.GI32125@valkosipuli.retiisi.org.uk>
 <2318434a-176b-82c6-c55a-115778354201@samsung.com>
 <20160429135601.GA26360@valkosipuli.retiisi.org.uk>
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <57271235.9030004@xs4all.nl>
Date: Mon, 2 May 2016 10:39:17 +0200
MIME-Version: 1.0
In-Reply-To: <20160429135601.GA26360@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/29/16 15:56, Sakari Ailus wrote:
> Hi Marek,
> 
> On Fri, Apr 29, 2016 at 01:39:43PM +0200, Marek Szyprowski wrote:
>> Hi Sakari,
>>
>>
>> On 2016-04-29 13:21, Sakari Ailus wrote:
>>> Hi Marek,
>>>
>>> Thanks for the patch!
>>>
>>> On Thu, Apr 28, 2016 at 03:20:03PM +0200, Marek Szyprowski wrote:
>>>> This patch lets vb2-dma-contig memory allocator to configure DMA max
>>>> segment size properly for the client device. Setting it is needed to let
>>>> DMA-mapping subsystem to create a single, contiguous mapping in DMA
>>>> address space. This is essential for all devices, which use dma-contig
>>>> videobuf2 memory allocator and shared buffers (in USERPTR or DMAbuf modes
>>>> of operations).
>>>>
>>>> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
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
>>>> v2:
>>>> - fixes typos and other language issues in the comments
>>>>
>>>> v1: http://article.gmane.org/gmane.linux.kernel.samsung-soc/53690
>>>> ---
>>>>  drivers/media/v4l2-core/videobuf2-dma-contig.c | 39 ++++++++++++++++++++++++++
>>>>  1 file changed, 39 insertions(+)
>>>>
>>>> diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
>>>> index 461ae55eaa98..d0382d62954d 100644
>>>> --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
>>>> +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
>>>> @@ -443,6 +443,36 @@ static void vb2_dc_put_userptr(void *buf_priv)
>>>>  }
>>>>  /*
>>>> + * To allow mapping the scatter-list into a single chunk in the DMA
>>>> + * address space, the device is required to have the DMA max segment
>>>> + * size parameter set to a value larger than the buffer size. Otherwise,
>>>> + * the DMA-mapping subsystem will split the mapping into max segment
>>>> + * size chunks. This function increases the DMA max segment size
>>>> + * parameter to let DMA-mapping map a buffer as a single chunk in DMA
>>>> + * address space.
>>>> + * This code assumes that the DMA-mapping subsystem will merge all
>>>> + * scatter-list segments if this is really possible (for example when
>>>> + * an IOMMU is available and enabled).
>>>> + * Ideally, this parameter should be set by the generic bus code, but it
>>>> + * is left with the default 64KiB value due to historical litmiations in
>>>> + * other subsystems (like limited USB host drivers) and there no good
>>>> + * place to set it to the proper value. It is done here to avoid fixing
>>>> + * all the vb2-dc client drivers.
>>>> + */
>>>> +static int vb2_dc_set_max_seg_size(struct device *dev, unsigned int size)
>>>> +{
>>>> +	if (!dev->dma_parms) {
>>>> +		dev->dma_parms = kzalloc(sizeof(dev->dma_parms), GFP_KERNEL);
>>> Doesn't this create a memory leak? Do consider that devices may be also
>>> removed from the system at runtime.
>>>
>>> Looks very nice otherwise.
>>
>> Yes it does, but there is completely no way to determine when to do that
>> (dma_params might have been already allocated by the bus code). The whole
>> dma_params idea and its handling is a bit messy. IMHO we can leave this
>> for now until dma_params gets cleaned up (I remember someone said that he
>> has this on his todo list, but I don't remember now who it was...).
> 
> You could fix this in a V4L2-specific way by storing the information whether
> you've allocated the dma-params e.g. in struct video_device. That's probably
> not worth the trouble, especially if someone's about to have a better
> solution.
> 
> I'd add a "FIXME: ..." comment so we won't forget about it.
> 
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> 

I agree with Sakari, please add a FIXME here explaining the issue.
I'll pick up the v3 patch for a pull request on Wednesday.

Regards,

	Hans
