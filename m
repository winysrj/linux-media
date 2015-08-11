Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:38176 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932670AbbHKCTy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Aug 2015 22:19:54 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NSW0101NBT4ZS00@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 11 Aug 2015 11:19:52 +0900 (KST)
Message-id: <55C95BC7.4020107@samsung.com>
Date: Tue, 11 Aug 2015 11:19:51 +0900
From: Junghak Sung <jh1009.sung@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	mchehab@osg.samsung.com, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, pawel@osciak.com
Cc: inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	rany.kwon@samsung.com
Subject: Re: [RFC PATCH v2 4/5] media: videobuf2: Define vb2_buf_type and
 vb2_memory
References: <1438332277-6542-1-git-send-email-jh1009.sung@samsung.com>
 <1438332277-6542-5-git-send-email-jh1009.sung@samsung.com>
 <55C85F34.7040603@xs4all.nl>
In-reply-to: <55C85F34.7040603@xs4all.nl>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Hans,

On 08/10/2015 05:22 PM, Hans Verkuil wrote:
> On 07/31/2015 10:44 AM, Junghak Sung wrote:
>> Define enum vb2_buf_type and enum vb2_memory for videobuf2-core. This
>> change requires translation functions that could covert v4l2-core stuffs
>> to videobuf2-core stuffs in videobuf2-v4l2.c file.
>> The v4l2-specific member variables(e.g. type, memory) remains in
>> struct vb2_queue for backward compatibility and performance of type translation.
>>
>> Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
>> Signed-off-by: Geunyoung Kim <nenggun.kim@samsung.com>
>> Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>
>> Acked-by: Inki Dae <inki.dae@samsung.com>
>> ---
>>   drivers/media/v4l2-core/videobuf2-core.c |  139 +++++++++++---------
>>   drivers/media/v4l2-core/videobuf2-v4l2.c |  209 ++++++++++++++++++++----------
>>   include/media/videobuf2-core.h           |   99 +++++++++++---
>>   include/media/videobuf2-v4l2.h           |   12 +-
>>   4 files changed, 299 insertions(+), 160 deletions(-)
>>
>
> <snip>
>
>> diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
>> index 85527e9..22dd19c 100644
>> --- a/drivers/media/v4l2-core/videobuf2-v4l2.c
>> +++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
>> @@ -30,8 +30,46 @@
>>   #include <media/v4l2-common.h>
>>   #include <media/videobuf2-v4l2.h>
>>
>> +#define CREATE_TRACE_POINTS
>>   #include <trace/events/v4l2.h>
>>
>> +static const enum vb2_buf_type _tbl_buf_type[] = {
>> +	[V4L2_BUF_TYPE_VIDEO_CAPTURE]		= VB2_BUF_TYPE_VIDEO_CAPTURE,
>> +	[V4L2_BUF_TYPE_VIDEO_OUTPUT]		= VB2_BUF_TYPE_VIDEO_OUTPUT,
>> +	[V4L2_BUF_TYPE_VIDEO_OVERLAY]		= VB2_BUF_TYPE_VIDEO_OVERLAY,
>> +	[V4L2_BUF_TYPE_VBI_CAPTURE]		= VB2_BUF_TYPE_VBI_CAPTURE,
>> +	[V4L2_BUF_TYPE_VBI_OUTPUT]		= VB2_BUF_TYPE_VBI_OUTPUT,
>> +	[V4L2_BUF_TYPE_SLICED_VBI_CAPTURE]	= VB2_BUF_TYPE_SLICED_VBI_CAPTURE,
>> +	[V4L2_BUF_TYPE_SLICED_VBI_OUTPUT]	= VB2_BUF_TYPE_SLICED_VBI_OUTPUT,
>> +	[V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY]	= VB2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY,
>> +	[V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE]	= VB2_BUF_TYPE_VIDEO_CAPTURE_MPLANE,
>> +	[V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE]	= VB2_BUF_TYPE_VIDEO_OUTPUT_MPLANE,
>> +	[V4L2_BUF_TYPE_SDR_CAPTURE]		= VB2_BUF_TYPE_SDR_CAPTURE,
>> +	[V4L2_BUF_TYPE_PRIVATE]			= VB2_BUF_TYPE_PRIVATE,
>> +};
>> +
>> +static const enum vb2_memory _tbl_memory[] = {
>> +	[V4L2_MEMORY_MMAP]	= VB2_MEMORY_MMAP,
>> +	[V4L2_MEMORY_USERPTR]	= VB2_MEMORY_USERPTR,
>> +	[V4L2_MEMORY_DMABUF]	= VB2_MEMORY_DMABUF,
>> +};
>> +
>> +#define to_vb2_buf_type(type)					\
>> +({								\
>> +	enum vb2_buf_type ret = 0;				\
>> +	if( type > 0 && type < ARRAY_SIZE(_tbl_buf_type) )	\
>> +		ret = (_tbl_buf_type[type]);			\
>> +	ret;							\
>> +})
>> +
>> +#define to_vb2_memory(memory)					\
>> +({								\
>> +	enum vb2_memory ret = 0;				\
>> +	if( memory > 0 && memory < ARRAY_SIZE(_tbl_memory) )	\
>> +		ret = (_tbl_memory[memory]);			\
>> +	ret;							\
>> +})
>> +
>
> <snip>
>
>> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
>> index dc405da..871fcc6 100644
>> --- a/include/media/videobuf2-core.h
>> +++ b/include/media/videobuf2-core.h
>> @@ -15,9 +15,47 @@
>>   #include <linux/mm_types.h>
>>   #include <linux/mutex.h>
>>   #include <linux/poll.h>
>> -#include <linux/videodev2.h>
>>   #include <linux/dma-buf.h>
>>
>> +#define VB2_MAX_FRAME               32
>> +#define VB2_MAX_PLANES               8
>> +
>> +enum vb2_buf_type {
>> +	VB2_BUF_TYPE_UNKNOWN			= 0,
>> +	VB2_BUF_TYPE_VIDEO_CAPTURE		= 1,
>> +	VB2_BUF_TYPE_VIDEO_OUTPUT		= 2,
>> +	VB2_BUF_TYPE_VIDEO_OVERLAY		= 3,
>> +	VB2_BUF_TYPE_VBI_CAPTURE		= 4,
>> +	VB2_BUF_TYPE_VBI_OUTPUT			= 5,
>> +	VB2_BUF_TYPE_SLICED_VBI_CAPTURE		= 6,
>> +	VB2_BUF_TYPE_SLICED_VBI_OUTPUT		= 7,
>> +	VB2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY	= 8,
>> +	VB2_BUF_TYPE_VIDEO_CAPTURE_MPLANE	= 9,
>> +	VB2_BUF_TYPE_VIDEO_OUTPUT_MPLANE	= 10,
>> +	VB2_BUF_TYPE_SDR_CAPTURE		= 11,
>> +	VB2_BUF_TYPE_DVB_CAPTURE		= 12,
>> +	VB2_BUF_TYPE_PRIVATE			= 0x80,
>> +};
>> +
>> +enum vb2_memory {
>> +	VB2_MEMORY_UNKNOWN	= 0,
>> +	VB2_MEMORY_MMAP		= 1,
>> +	VB2_MEMORY_USERPTR	= 2,
>> +	VB2_MEMORY_DMABUF	= 4,
>> +};
>> +
>> +#define VB2_TYPE_IS_MULTIPLANAR(type)			\
>> +	((type) == VB2_BUF_TYPE_VIDEO_CAPTURE_MPLANE	\
>> +	 || (type) == VB2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
>> +
>> +#define VB2_TYPE_IS_OUTPUT(type)				\
>> +	((type) == VB2_BUF_TYPE_VIDEO_OUTPUT			\
>> +	 || (type) == VB2_BUF_TYPE_VIDEO_OUTPUT_MPLANE		\
>> +	 || (type) == VB2_BUF_TYPE_VIDEO_OVERLAY		\
>> +	 || (type) == VB2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY		\
>> +	 || (type) == VB2_BUF_TYPE_VBI_OUTPUT			\
>> +	 || (type) == VB2_BUF_TYPE_SLICED_VBI_OUTPUT)
>
> You don't actually need to create vb2_buf_type: unless I am mistaken, all that the
> vb2 core needs to know is if it is a capture or output queue and possibly (not
> sure about that) if it is single or multiplanar. So add fields to the vb2_queue struct
> for that information and leave the buf_type to the v4l2 specific header and code.
>
Good idea. As your comment, the vb2_buf_type is used only for checking 
if the buffer is a capture or output type in the videobuf2-core.c.
But, I think it is better to add .is_output() to vb2_buf_ops in struct
vb2_queue rather than add a fields.

> You also don't need the _tbl_memory[] array. All you need to do is to check in
> videobuf2-v4l2.c that VB2_MEMORY* equals the V4L2_MEMORY_* defines and generate
> a #error if not:
>
> #if VB2_MEMORY_MMAP != V4L2_MEMORY_MMAP || VB2_MEMORY_....
> #error VB2_MEMORY_* != V4L2_MEMORY_*!
> #endif

Good idea, too. For v3, I will rework as your guide.

>
> Regards,
>
> 	Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
