Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:48481 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751823AbbIWGe7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Sep 2015 02:34:59 -0400
Subject: Re: [RFC PATCH v5 7/8] media: videobuf2: Prepare to divide videobuf2
To: Junghak Sung <jh1009.sung@samsung.com>,
	linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	pawel@osciak.com
References: <1442928636-3589-1-git-send-email-jh1009.sung@samsung.com>
 <1442928636-3589-8-git-send-email-jh1009.sung@samsung.com>
 <56016A4E.50804@xs4all.nl> <56020243.8090602@samsung.com>
Cc: inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	rany.kwon@samsung.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5602480A.9000306@xs4all.nl>
Date: Wed, 23 Sep 2015 08:34:50 +0200
MIME-Version: 1.0
In-Reply-To: <56020243.8090602@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 23-09-15 03:37, Junghak Sung wrote:
> 
> 
> On 09/22/2015 11:48 PM, Hans Verkuil wrote:
>> Hi Junghak,
>>
>> This looks pretty good!
>>
>> I have a few small comments below, but overall it is much improved.
>>
>> On 22-09-15 15:30, Junghak Sung wrote:
>>> Prepare to divide videobuf2
>>> - Separate vb2 trace events from v4l2 trace event.
>>> - Make wrapper functions that will move to v4l2-side
>>> - Make vb2_core_* functions that remain in vb2 core side
>>> - Rename internal functions as vb2_*
>>>
>>> Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
>>> Signed-off-by: Geunyoung Kim <nenggun.kim@samsung.com>
>>> Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>
>>> Acked-by: Inki Dae <inki.dae@samsung.com>
>>> ---
>>>   drivers/media/v4l2-core/Makefile         |    2 +-
>>>   drivers/media/v4l2-core/v4l2-trace.c     |    8 +-
>>>   drivers/media/v4l2-core/vb2-trace.c      |    9 +
>>>   drivers/media/v4l2-core/videobuf2-core.c |  556 ++++++++++++++++++++----------
>>>   include/trace/events/v4l2.h              |   28 +-
>>>   include/trace/events/vb2.h               |   65 ++++
>>>   6 files changed, 457 insertions(+), 211 deletions(-)
>>>   create mode 100644 drivers/media/v4l2-core/vb2-trace.c
>>>   create mode 100644 include/trace/events/vb2.h
>>>
>>> diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
>>> index ad07401..1dc8bba 100644
>>> --- a/drivers/media/v4l2-core/Makefile
>>> +++ b/drivers/media/v4l2-core/Makefile
>>> @@ -14,7 +14,7 @@ ifeq ($(CONFIG_OF),y)
>>>     videodev-objs += v4l2-of.o
>>>   endif
>>>   ifeq ($(CONFIG_TRACEPOINTS),y)
>>> -  videodev-objs += v4l2-trace.o
>>> +  videodev-objs += vb2-trace.o v4l2-trace.o
>>>   endif
>>>
>>>   obj-$(CONFIG_VIDEO_V4L2) += videodev.o
>>> diff --git a/drivers/media/v4l2-core/v4l2-trace.c b/drivers/media/v4l2-core/v4l2-trace.c
>>> index 4004814..7416010 100644
>>> --- a/drivers/media/v4l2-core/v4l2-trace.c
>>> +++ b/drivers/media/v4l2-core/v4l2-trace.c
>>> @@ -5,7 +5,7 @@
>>>   #define CREATE_TRACE_POINTS
>>>   #include <trace/events/v4l2.h>
>>>
>>> -EXPORT_TRACEPOINT_SYMBOL_GPL(vb2_buf_done);
>>> -EXPORT_TRACEPOINT_SYMBOL_GPL(vb2_buf_queue);
>>> -EXPORT_TRACEPOINT_SYMBOL_GPL(vb2_dqbuf);
>>> -EXPORT_TRACEPOINT_SYMBOL_GPL(vb2_qbuf);
>>> +EXPORT_TRACEPOINT_SYMBOL_GPL(vb2_v4l2_buf_done);
>>> +EXPORT_TRACEPOINT_SYMBOL_GPL(vb2_v4l2_buf_queue);
>>> +EXPORT_TRACEPOINT_SYMBOL_GPL(vb2_v4l2_dqbuf);
>>> +EXPORT_TRACEPOINT_SYMBOL_GPL(vb2_v4l2_qbuf);
>>> diff --git a/drivers/media/v4l2-core/vb2-trace.c b/drivers/media/v4l2-core/vb2-trace.c
>>> new file mode 100644
>>> index 0000000..61e74f5
>>> --- /dev/null
>>> +++ b/drivers/media/v4l2-core/vb2-trace.c
>>> @@ -0,0 +1,9 @@
>>> +#include <media/videobuf2-core.h>
>>> +
>>> +#define CREATE_TRACE_POINTS
>>> +#include <trace/events/vb2.h>
>>> +
>>> +EXPORT_TRACEPOINT_SYMBOL_GPL(vb2_buf_done);
>>> +EXPORT_TRACEPOINT_SYMBOL_GPL(vb2_buf_queue);
>>> +EXPORT_TRACEPOINT_SYMBOL_GPL(vb2_dqbuf);
>>> +EXPORT_TRACEPOINT_SYMBOL_GPL(vb2_qbuf);
>>> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
>>> index 32fa425..380536d 100644
>>> --- a/drivers/media/v4l2-core/videobuf2-core.c
>>> +++ b/drivers/media/v4l2-core/videobuf2-core.c
>>> @@ -30,7 +30,7 @@
>>>   #include <media/v4l2-common.h>
>>>   #include <media/videobuf2-v4l2.h>
>>>
>>> -#include <trace/events/v4l2.h>
>>> +#include <trace/events/vb2.h>
>>>
>>>   static int debug;
>>>   module_param(debug, int, 0644);
>>> @@ -612,10 +612,10 @@ static int __verify_length(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>>>   }
>>>
>>>   /**
>>> - * __buffer_in_use() - return true if the buffer is in use and
>>> + * vb2_buffer_in_use() - return true if the buffer is in use and
>>>    * the queue cannot be freed (by the means of REQBUFS(0)) call
>>>    */
>>> -static bool __buffer_in_use(struct vb2_queue *q, struct vb2_buffer *vb)
>>> +static bool vb2_buffer_in_use(struct vb2_queue *q, struct vb2_buffer *vb)
>>>   {
>>>   	unsigned int plane;
>>>   	for (plane = 0; plane < vb->num_planes; ++plane) {
>>> @@ -640,7 +640,7 @@ static bool __buffers_in_use(struct vb2_queue *q)
>>>   {
>>>   	unsigned int buffer;
>>>   	for (buffer = 0; buffer < q->num_buffers; ++buffer) {
>>> -		if (__buffer_in_use(q, q->bufs[buffer]))
>>> +		if (vb2_buffer_in_use(q, q->bufs[buffer]))
>>>   			return true;
>>>   	}
>>>   	return false;
>>> @@ -650,8 +650,9 @@ static bool __buffers_in_use(struct vb2_queue *q)
>>>    * __fill_v4l2_buffer() - fill in a struct v4l2_buffer with information to be
>>>    * returned to userspace
>>>    */
>>> -static void __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
>>> +static int __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
>>
>> Why use a void * here? Wouldn't a struct vb2_buffer pointer be better? That way it all
>> remains type-safe. Ditto elsewhere in this patch, of course.
> 
> I disagree with this idea, IMHO.
> This function is for filling struct v4l2_buffer with information to be
> returned to userspace. So, if the void pointer are replaced with
> struct vb2_buffer pointer, a additional function will be needed in order
> to translate the vb2_buffer to v4l2_buffer and the function should be
> duplicated with __fill_v4l2_buffer() by meaning of functionality.

Oops, my fault. Disregard my comment, I confused v4l2_buffer with vb2_v4l2_buffer.
What can I say? It was late in the day when I did the review :-)

Regards,

	Hans
