Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:45230 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751283AbaKQIlr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Nov 2014 03:41:47 -0500
Message-ID: <5469B4BB.2040208@xs4all.nl>
Date: Mon, 17 Nov 2014 09:41:31 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-media@vger.kernel.org, pawel@osciak.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 03/11] videodev2.h: rename reserved2 to config_store
 in v4l2_buffer.
References: <1411310909-32825-1-git-send-email-hverkuil@xs4all.nl> <1411310909-32825-4-git-send-email-hverkuil@xs4all.nl> <20141114144202.GD8907@valkosipuli.retiisi.org.uk>
In-Reply-To: <20141114144202.GD8907@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/14/2014 03:42 PM, Sakari Ailus wrote:
> Hi Hans,
> 
> On Sun, Sep 21, 2014 at 04:48:21PM +0200, Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> When queuing buffers allow for passing the configuration store ID that
>> should be associated with this buffer. Use the 'reserved2' field for this.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  drivers/media/usb/cpia2/cpia2_v4l.c           | 2 +-
>>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 4 ++--
>>  drivers/media/v4l2-core/videobuf2-core.c      | 4 +++-
>>  include/uapi/linux/videodev2.h                | 3 ++-
>>  4 files changed, 8 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/media/usb/cpia2/cpia2_v4l.c b/drivers/media/usb/cpia2/cpia2_v4l.c
>> index 9caea83..0f28d2b 100644
>> --- a/drivers/media/usb/cpia2/cpia2_v4l.c
>> +++ b/drivers/media/usb/cpia2/cpia2_v4l.c
>> @@ -952,7 +952,7 @@ static int cpia2_dqbuf(struct file *file, void *fh, struct v4l2_buffer *buf)
>>  	buf->sequence = cam->buffers[buf->index].seq;
>>  	buf->m.offset = cam->buffers[buf->index].data - cam->frame_buffer;
>>  	buf->length = cam->frame_size;
>> -	buf->reserved2 = 0;
>> +	buf->config_store = 0;
>>  	buf->reserved = 0;
>>  	memset(&buf->timecode, 0, sizeof(buf->timecode));
>>  
>> diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
>> index e502a5f..5afef3a 100644
>> --- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
>> +++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
>> @@ -324,7 +324,7 @@ struct v4l2_buffer32 {
>>  		__s32		fd;
>>  	} m;
>>  	__u32			length;
>> -	__u32			reserved2;
>> +	__u32			config_store;
>>  	__u32			reserved;
>>  };
>>  
>> @@ -489,7 +489,7 @@ static int put_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
>>  		put_user(kp->timestamp.tv_usec, &up->timestamp.tv_usec) ||
>>  		copy_to_user(&up->timecode, &kp->timecode, sizeof(struct v4l2_timecode)) ||
>>  		put_user(kp->sequence, &up->sequence) ||
>> -		put_user(kp->reserved2, &up->reserved2) ||
>> +		put_user(kp->config_store, &up->config_store) ||
>>  		put_user(kp->reserved, &up->reserved))
>>  			return -EFAULT;
>>  
>> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
>> index 7e6aff6..e3b6c50 100644
>> --- a/drivers/media/v4l2-core/videobuf2-core.c
>> +++ b/drivers/media/v4l2-core/videobuf2-core.c
>> @@ -655,7 +655,7 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
>>  
>>  	/* Copy back data such as timestamp, flags, etc. */
>>  	memcpy(b, &vb->v4l2_buf, offsetof(struct v4l2_buffer, m));
>> -	b->reserved2 = vb->v4l2_buf.reserved2;
>> +	b->config_store = vb->v4l2_buf.config_store;
>>  	b->reserved = vb->v4l2_buf.reserved;
>>  
>>  	if (V4L2_TYPE_IS_MULTIPLANAR(q->type)) {
>> @@ -680,6 +680,7 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
>>  		else if (q->memory == V4L2_MEMORY_DMABUF)
>>  			b->m.fd = vb->v4l2_planes[0].m.fd;
>>  	}
>> +	b->config_store = vb->v4l2_buf.config_store;
> 
> Either this chunk or the one above it is redundant. I'd keep the upper one.

Well spotted. I agree, I'll keep the upper one.

Regards,

	Hans
