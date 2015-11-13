Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:34332 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754193AbbKMJNt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Nov 2015 04:13:49 -0500
Subject: Re: [Patch v2 1/2] media: v4l: ti-vpe: Add CAL v4l2 camera capture
 driver
To: Benoit Parrot <bparrot@ti.com>
References: <1442865848-19280-1-git-send-email-bparrot@ti.com>
 <1442865848-19280-2-git-send-email-bparrot@ti.com>
 <562112B7.7090103@xs4all.nl> <56269C34.3000306@xs4all.nl>
Cc: linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5645A9C8.5000008@xs4all.nl>
Date: Fri, 13 Nov 2015 10:13:44 +0100
MIME-Version: 1.0
In-Reply-To: <56269C34.3000306@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/20/2015 09:55 PM, Hans Verkuil wrote:
> On 10/16/2015 05:07 PM, Hans Verkuil wrote:
>> On 09/21/2015 10:04 PM, Benoit Parrot wrote:
>>> The Camera Adaptation Layer (CAL) is a block which consists of a dual
>>> port CSI2/MIPI camera capture engine.
>>> Port #0 can handle CSI2 camera connected to up to 4 data lanes.
>>> Port #1 can handle CSI2 camera connected to up to 2 data lanes.
>>> The driver implements the required API/ioctls to be V4L2 compliant.
>>> Driver supports the following:
>>>     - V4L2 API using DMABUF/MMAP buffer access based on videobuf2 api
>>>     - Asynchronous sensor sub device registration
>>>     - DT support
>>>
>>> Signed-off-by: Benoit Parrot <bparrot@ti.com>
>>> ---
>>>  drivers/media/platform/Kconfig           |   12 +
>>>  drivers/media/platform/Makefile          |    2 +
>>>  drivers/media/platform/ti-vpe/Makefile   |    4 +
>>>  drivers/media/platform/ti-vpe/cal.c      | 2161 ++++++++++++++++++++++++++++++
>>>  drivers/media/platform/ti-vpe/cal_regs.h |  779 +++++++++++
>>>  5 files changed, 2958 insertions(+)
>>>  create mode 100644 drivers/media/platform/ti-vpe/cal.c
>>>  create mode 100644 drivers/media/platform/ti-vpe/cal_regs.h
>>>
>>> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
>>> index dc75694ac12d..c7f5704c56a2 100644
>>> --- a/drivers/media/platform/Kconfig
>>> +++ b/drivers/media/platform/Kconfig
>>> @@ -120,6 +120,18 @@ source "drivers/media/platform/s5p-tv/Kconfig"
>>>  source "drivers/media/platform/am437x/Kconfig"
>>>  source "drivers/media/platform/xilinx/Kconfig"
>>>  
>>> +config VIDEO_TI_CAL
>>> +	tristate "TI CAL (Camera Adaptation Layer) driver"
>>> +	depends on VIDEO_DEV && VIDEO_V4L2 && SOC_DRA7XX
>>> +	depends on VIDEO_V4L2_SUBDEV_API
>>> +	depends on VIDEOBUF2_DMA_CONTIG
>>
>> This should be:
>>
>>        depends on VIDEO_DEV && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
>>        depends on SOC_DRA7XX || COMPILE_TEST
>>        select VIDEOBUF2_DMA_CONTIG
>>
>>> +	default n
>>> +	---help---
>>> +	  Support for the TI CAL (Camera Adaptation Layer) block
>>> +	  found on DRA72X SoC.
>>> +	  In TI Technical Reference Manual this module is referred as
>>> +	  Camera Interface Subsystem (CAMSS).
>>> +
>>>  endif # V4L_PLATFORM_DRIVERS
>>>  
>>>  menuconfig V4L_MEM2MEM_DRIVERS
>>
>> By compiling with COMPILE_TEST I found a number of compile warnings and it also no
>> longer compiled due to vb2 changes. Both are fixed in the patch below.
>>
>> SoB for the patch: Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> That said, I'll postpone merging this until the remainder of the vb2 split patches
>> have been merged. When that's done this driver will have to be changed some more.
> 
> OK, the vb2 split patches were just merged. Can you rebase and repost?

Ping!

I'd like to merge this driver, so if you can rebase and take care of the trivial comments
I made in my review?

Thanks,

	Hans

