Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:57814 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743Ab2IYOl4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Sep 2012 10:41:56 -0400
Received: from eusync2.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MAW009EQU6F8VB0@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 25 Sep 2012 15:42:15 +0100 (BST)
Received: from [106.116.147.108] by eusync2.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MAW00IA0U5T9V00@eusync2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 25 Sep 2012 15:41:54 +0100 (BST)
Message-id: <5061C2AF.60904@samsung.com>
Date: Tue, 25 Sep 2012 16:41:51 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com,
	sumit.semwal@ti.com, daeinki@gmail.com, daniel.vetter@ffwll.ch,
	robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, remi@remlab.net,
	subashrp@gmail.com, mchehab@redhat.com, g.liakhovetski@gmx.de,
	dmitriyz@google.com, s.nawrocki@samsung.com, k.debski@samsung.com
Subject: Re: [PATCHv8 13/26] v4l: vivi: support for dmabuf importing
References: <1344958496-9373-1-git-send-email-t.stanislaws@samsung.com>
 <1344958496-9373-14-git-send-email-t.stanislaws@samsung.com>
 <201208221256.30179.hverkuil@xs4all.nl> <201208221347.56879.hverkuil@xs4all.nl>
In-reply-to: <201208221347.56879.hverkuil@xs4all.nl>
Content-type: text/plain; charset=ISO-8859-15
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/22/2012 01:47 PM, Hans Verkuil wrote:
> On Wed August 22 2012 12:56:30 Hans Verkuil wrote:
>> On Tue August 14 2012 17:34:43 Tomasz Stanislawski wrote:
>>> This patch enhances VIVI driver with a support for importing a buffer
>>> from DMABUF file descriptors.
>>
>> Thanks for adding DMABUF support to vivi.
>>
>> What would be great is if DMABUF support is also added to mem2mem_testdev.
>> It would make an excellent test case to take the vivi output, pass it
>> through mem2mem_testdev, and finally output the image using the gpu, all
>> using dmabuf.
>>
>> It's also very useful for application developers to test dmabuf support
>> without requiring special hardware (other than a dmabuf-enabled gpu
>> driver).
> 
> Adding VIDIOC_EXPBUF support to vivi and mem2mem_testdev would be
> welcome as well for the same reasons.
> 
> Regards,
> 
> 	Hans
> 

Hi Hans,

Adding DMABUF exporting to vmalloc is not easy as it seams.
Exporting introduces a new level of complexity and code bloat to a framework.
I mean support for:
- NULL devices as DMABUF exporters
- vmalloc to sglist conversions
- calling dma_map_sg for importers
- cache management

I admit that most of the work should be delegated to dmabuf framework.
I propose to postpone support for dmabuf exporting in vmalloc until
vb2-dmabuf gets merged.

Regards,
Tomasz Stanislawski


>>
>> Regards,
>>
>> 	Hans
>>
>>>
>>> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
>>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>>> ---
>>>  drivers/media/video/Kconfig |    1 +
>>>  drivers/media/video/vivi.c  |    2 +-
>>>  2 files changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
>>> index 966954d..8fa81be 100644
>>> --- a/drivers/media/video/Kconfig
>>> +++ b/drivers/media/video/Kconfig
>>> @@ -653,6 +653,7 @@ config VIDEO_VIVI
>>>  	depends on FRAMEBUFFER_CONSOLE || STI_CONSOLE
>>>  	select FONT_8x16
>>>  	select VIDEOBUF2_VMALLOC
>>> +	select DMA_SHARED_BUFFER
>>>  	default n
>>>  	---help---
>>>  	  Enables a virtual video driver. This device shows a color bar
>>> diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
>>> index a6351c4..37d8fd4 100644
>>> --- a/drivers/media/video/vivi.c
>>> +++ b/drivers/media/video/vivi.c
>>> @@ -1308,7 +1308,7 @@ static int __init vivi_create_instance(int inst)
>>>  	q = &dev->vb_vidq;
>>>  	memset(q, 0, sizeof(dev->vb_vidq));
>>>  	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>>> -	q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_READ;
>>> +	q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF | VB2_READ;
>>>  	q->drv_priv = dev;
>>>  	q->buf_struct_size = sizeof(struct vivi_buffer);
>>>  	q->ops = &vivi_video_qops;
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>

