Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2453 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbaAaInW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Jan 2014 03:43:22 -0500
Message-ID: <52EB6214.9030806@xs4all.nl>
Date: Fri, 31 Jan 2014 09:43:00 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Philipp Zabel <p.zabel@pengutronix.de>,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	kernel@pengutronix.de
Subject: Re: [PATCH] [media] uvcvideo: Enable VIDIOC_CREATE_BUFS
References: <1391012032-19600-1-git-send-email-p.zabel@pengutronix.de> <1474634.xnVfC2yuQa@avalon>
In-Reply-To: <1474634.xnVfC2yuQa@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I think you might want to add a check in uvc_queue_setup to verify the
fmt that create_bufs passes. The spec says that: "Unsupported formats
will result in an error". In this case I guess that the format basically
should match the current selected format.

I'm unhappy with the current implementations of create_bufs (see also this
patch: http://www.mail-archive.com/linux-media@vger.kernel.org/msg70796.html).

Nobody is actually checking the format today, which isn't good.

The fact that the spec says that the fmt field isn't changed by the driver
isn't helping as it invalidated my patch from above, although that can be fixed.

I need to think about this some more, but for this particular case you can
just do a memcmp of the v4l2_pix_format against the currently selected
format and return an error if they differ. Unless you want to support
different buffer sizes as well?

Regards,

	Hans

On 01/31/2014 01:51 AM, Laurent Pinchart wrote:
> Hi Philipp,
> 
> Thank you for the patch.
> 
> On Wednesday 29 January 2014 17:13:52 Philipp Zabel wrote:
>> This patch enables the ioctl to create additional buffers
>> on the videobuf2 capture queue.
>>
>> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> 
> This looks good to me. I've applied the patch to my tree and will send a pull 
> request for v3.15.
> 
>> ---
>>  drivers/media/usb/uvc/uvc_queue.c | 11 +++++++++++
>>  drivers/media/usb/uvc/uvc_v4l2.c  | 10 ++++++++++
>>  drivers/media/usb/uvc/uvcvideo.h  |  2 ++
>>  3 files changed, 23 insertions(+)
>>
>> diff --git a/drivers/media/usb/uvc/uvc_queue.c
>> b/drivers/media/usb/uvc/uvc_queue.c index cd962be..7efb157 100644
>> --- a/drivers/media/usb/uvc/uvc_queue.c
>> +++ b/drivers/media/usb/uvc/uvc_queue.c
>> @@ -196,6 +196,17 @@ int uvc_query_buffer(struct uvc_video_queue *queue,
>> struct v4l2_buffer *buf) return ret;
>>  }
>>
>> +int uvc_create_buffers(struct uvc_video_queue *queue, struct
>> v4l2_create_buffers *cb) +{
>> +	int ret;
>> +
>> +	mutex_lock(&queue->mutex);
>> +	ret = vb2_create_bufs(&queue->queue, cb);
>> +	mutex_unlock(&queue->mutex);
>> +
>> +	return ret;
>> +}
>> +
>>  int uvc_queue_buffer(struct uvc_video_queue *queue, struct v4l2_buffer
>> *buf) {
>>  	int ret;
>> diff --git a/drivers/media/usb/uvc/uvc_v4l2.c
>> b/drivers/media/usb/uvc/uvc_v4l2.c index 3afff92..fa58131 100644
>> --- a/drivers/media/usb/uvc/uvc_v4l2.c
>> +++ b/drivers/media/usb/uvc/uvc_v4l2.c
>> @@ -1000,6 +1000,16 @@ static long uvc_v4l2_do_ioctl(struct file *file,
>> unsigned int cmd, void *arg) return uvc_query_buffer(&stream->queue, buf);
>>  	}
>>
>> +	case VIDIOC_CREATE_BUFS:
>> +	{
>> +		struct v4l2_create_buffers *cb = arg;
>> +
>> +		if (!uvc_has_privileges(handle))
>> +			return -EBUSY;
>> +
>> +		return uvc_create_buffers(&stream->queue, cb);
>> +	}
>> +
>>  	case VIDIOC_QBUF:
>>  		if (!uvc_has_privileges(handle))
>>  			return -EBUSY;
>> diff --git a/drivers/media/usb/uvc/uvcvideo.h
>> b/drivers/media/usb/uvc/uvcvideo.h index 9e35982..a28da0f 100644
>> --- a/drivers/media/usb/uvc/uvcvideo.h
>> +++ b/drivers/media/usb/uvc/uvcvideo.h
>> @@ -616,6 +616,8 @@ extern int uvc_alloc_buffers(struct uvc_video_queue
>> *queue, extern void uvc_free_buffers(struct uvc_video_queue *queue);
>>  extern int uvc_query_buffer(struct uvc_video_queue *queue,
>>  		struct v4l2_buffer *v4l2_buf);
>> +extern int uvc_create_buffers(struct uvc_video_queue *queue,
>> +		struct v4l2_create_buffers *v4l2_cb);
>>  extern int uvc_queue_buffer(struct uvc_video_queue *queue,
>>  		struct v4l2_buffer *v4l2_buf);
>>  extern int uvc_dequeue_buffer(struct uvc_video_queue *queue,
> 
