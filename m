Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:49105 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752794AbdAIPtN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Jan 2017 10:49:13 -0500
From: Vincent ABRIOU <vincent.abriou@st.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "Benjamin Gaignard" <benjamin.gaignard@linaro.org>,
        Hugues FRUCHET <hugues.fruchet@st.com>,
        Jean Christophe TROTIN <jean-christophe.trotin@st.com>
Subject: Re: [media] uvcvideo: support for contiguous DMA buffers
Date: Mon, 9 Jan 2017 15:49:00 +0000
Message-ID: <c86650e5-7106-d36b-b716-6247fb2fa8ed@st.com>
References: <1475494036-18208-1-git-send-email-vincent.abriou@st.com>
 <5308977.1AOWxa0Moe@avalon>
In-Reply-To: <5308977.1AOWxa0Moe@avalon>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <0C9B566C5F7BAB4EA53BDC092D5F2D47@st.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 01/09/2017 04:37 PM, Laurent Pinchart wrote:
> Hi Vincent,
>
> Thank you for the patch.
>
> On Monday 03 Oct 2016 13:27:16 Vincent Abriou wrote:
>> Allow uvcvideo compatible devices to allocate their output buffers using
>> contiguous DMA buffers.
>
> Why do you need this ? If it's for buffer sharing with a device that requires
> dma-contig, can't you allocate the buffers on the other device and import them
> on the UVC side ?
>

Hi Laurent,

I need this using Gstreamer simple pipeline to connect an usb webcam 
(v4l2src) with a display (waylandsink) activating the zero copy path.

The waylandsink plugin does not have any contiguous memory pool to 
allocate contiguous buffer. So it is up to the upstream element, here 
v4l2src, to provide such contiguous buffers.

Vincent

>> Add the "allocators" module parameter option to let uvcvideo use the
>> dma-contig instead of vmalloc.
>>
>> Signed-off-by: Vincent Abriou <vincent.abriou@st.com>
>> ---
>>  Documentation/media/v4l-drivers/uvcvideo.rst | 12 ++++++++++++
>>  drivers/media/usb/uvc/Kconfig                |  2 ++
>>  drivers/media/usb/uvc/uvc_driver.c           |  3 ++-
>>  drivers/media/usb/uvc/uvc_queue.c            | 23 ++++++++++++++++++++---
>>  drivers/media/usb/uvc/uvcvideo.h             |  4 ++--
>>  5 files changed, 38 insertions(+), 6 deletions(-)
>>
>> diff --git a/Documentation/media/v4l-drivers/uvcvideo.rst
>> b/Documentation/media/v4l-drivers/uvcvideo.rst index d68b3d5..786cff5
>> 100644
>> --- a/Documentation/media/v4l-drivers/uvcvideo.rst
>> +++ b/Documentation/media/v4l-drivers/uvcvideo.rst
>> @@ -7,6 +7,18 @@ driver-specific ioctls and implementation notes.
>>  Questions and remarks can be sent to the Linux UVC development mailing list
>> at linux-uvc-devel@lists.berlios.de.
>>
>> +Configuring the driver
>> +----------------------
>> +
>> +The driver is configurable using the following module option:
>> +
>> +- allocators:
>> +
>> +	memory allocator selection, default is 0. It specifies the way buffers
>> +	will be allocated.
>> +
>> +		- 0: vmalloc
>> +		- 1: dma-contig
>>
>>  Extension Unit (XU) support
>>  ---------------------------
>> diff --git a/drivers/media/usb/uvc/Kconfig b/drivers/media/usb/uvc/Kconfig
>> index 6ed85efa..71e4d7e 100644
>> --- a/drivers/media/usb/uvc/Kconfig
>> +++ b/drivers/media/usb/uvc/Kconfig
>> @@ -1,7 +1,9 @@
>>  config USB_VIDEO_CLASS
>>  	tristate "USB Video Class (UVC)"
>>  	depends on VIDEO_V4L2
>> +	depends on HAS_DMA
>
> This will prevent using the uvcvideo driver on platforms that don't set
> HAS_DMA, which would be a regression compared to the current situation.
>
>>  	select VIDEOBUF2_VMALLOC
>> +	select VIDEOBUF2_DMA_CONTIG
>
> Shouldn't you make this configurable ? I don't think we want to hardcode the
> dependency on VIDEOBUF2_DMA_CONTIG, it should be possible to compile a kernel
> with USB_VIDEO_CLASS and without VIDEOBUF2_DMA_CONTIG when the user isn't
> interested in the dma-contig allocator.
>
>>  	---help---
>>  	  Support for the USB Video Class (UVC).  Currently only video
>>  	  input devices, such as webcams, are supported.
>> diff --git a/drivers/media/usb/uvc/uvc_driver.c
>> b/drivers/media/usb/uvc/uvc_driver.c index 302e284..1c20aa0 100644
>> --- a/drivers/media/usb/uvc/uvc_driver.c
>> +++ b/drivers/media/usb/uvc/uvc_driver.c
>> @@ -1757,7 +1757,8 @@ static int uvc_register_video(struct uvc_device *dev,
>>  	int ret;
>>
>>  	/* Initialize the video buffers queue. */
>> -	ret = uvc_queue_init(&stream->queue, stream->type,
> !uvc_no_drop_param);
>> +	ret = uvc_queue_init(dev, &stream->queue, stream->type,
>> +			     !uvc_no_drop_param);
>>  	if (ret)
>>  		return ret;
>>
>> diff --git a/drivers/media/usb/uvc/uvc_queue.c
>> b/drivers/media/usb/uvc/uvc_queue.c index 77edd20..5eab146 100644
>> --- a/drivers/media/usb/uvc/uvc_queue.c
>> +++ b/drivers/media/usb/uvc/uvc_queue.c
>> @@ -22,6 +22,7 @@
>>  #include <linux/wait.h>
>>  #include <media/videobuf2-v4l2.h>
>>  #include <media/videobuf2-vmalloc.h>
>> +#include <media/videobuf2-dma-contig.h>
>
> Alphabetically sorted please.
>
>>  #include "uvcvideo.h"
>>
>> @@ -37,6 +38,12 @@
>>   * the driver.
>>   */
>>
>> +static unsigned int allocators;
>> +module_param(allocators, uint, 0444);
>> +MODULE_PARM_DESC(allocators, " memory allocator selection, default is 0.\n"
>> +			     "\t\t    0 == vmalloc\n"
>> +			     "\t\t    1 == dma-contig");
>> +
>>  static inline struct uvc_streaming *
>>  uvc_queue_to_stream(struct uvc_video_queue *queue)
>>  {
>> @@ -188,20 +195,30 @@ static const struct vb2_ops uvc_queue_qops = {
>>  	.stop_streaming = uvc_stop_streaming,
>>  };
>>
>> -int uvc_queue_init(struct uvc_video_queue *queue, enum v4l2_buf_type type,
>> -		    int drop_corrupted)
>> +int uvc_queue_init(struct uvc_device *dev, struct uvc_video_queue *queue,
>
> You don't need the new argument, you can call uvc_queue_to_stream() to get the
> struct uvc_streaming pointer for the queue, from which you can retrieve the
> device pointer you're interested in.
>
>> +		   enum v4l2_buf_type type, int drop_corrupted)
>>  {
>>  	int ret;
>> +	static const struct vb2_mem_ops * const uvc_mem_ops[2] = {
>> +		&vb2_vmalloc_memops,
>> +		&vb2_dma_contig_memops,
>> +	};
>> +
>> +	if (allocators == 1)
>
> Please define macros instead of hardcoding values.
>
>> +		dma_coerce_mask_and_coherent(dev->vdev.dev, DMA_BIT_MASK(32));
>
> This is completely artificial, why 32 bits and not 24 or 64 ?
>
>> +	else if (allocators >= ARRAY_SIZE(uvc_mem_ops))
>> +		allocators = 0;
>>
>>  	queue->queue.type = type;
>>  	queue->queue.io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
>>  	queue->queue.drv_priv = queue;
>>  	queue->queue.buf_struct_size = sizeof(struct uvc_buffer);
>>  	queue->queue.ops = &uvc_queue_qops;
>> -	queue->queue.mem_ops = &vb2_vmalloc_memops;
>> +	queue->queue.mem_ops = uvc_mem_ops[allocators];
>>  	queue->queue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC
>>  		| V4L2_BUF_FLAG_TSTAMP_SRC_SOE;
>>  	queue->queue.lock = &queue->mutex;
>> +	queue->queue.dev = dev->vdev.dev;
>
> You should use the physical device here, not the device corresponding to the
> device node.
>
>>  	ret = vb2_queue_init(&queue->queue);
>>  	if (ret)
>>  		return ret;
>> diff --git a/drivers/media/usb/uvc/uvcvideo.h
>> b/drivers/media/usb/uvc/uvcvideo.h index 7e4d3ee..330ba64 100644
>> --- a/drivers/media/usb/uvc/uvcvideo.h
>> +++ b/drivers/media/usb/uvc/uvcvideo.h
>> @@ -632,8 +632,8 @@ extern struct uvc_driver uvc_driver;
>>  extern struct uvc_entity *uvc_entity_by_id(struct uvc_device *dev, int id);
>>
>>  /* Video buffers queue management. */
>> -extern int uvc_queue_init(struct uvc_video_queue *queue,
>> -		enum v4l2_buf_type type, int drop_corrupted);
>> +extern int uvc_queue_init(struct uvc_device *dev, struct uvc_video_queue
>> *queue,
>> +			  enum v4l2_buf_type type, int drop_corrupted);
>>  extern void uvc_queue_release(struct uvc_video_queue *queue);
>>  extern int uvc_request_buffers(struct uvc_video_queue *queue,
>>  		struct v4l2_requestbuffers *rb);
>