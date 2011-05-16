Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.1.48]:62071 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755248Ab1EPN3x (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 May 2011 09:29:53 -0400
Message-ID: <4DD12784.2000100@maxwell.research.nokia.com>
Date: Mon, 16 May 2011 16:32:52 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH/RFC 1/4] V4L: add three new ioctl()s for multi-size videobuffer
 management
References: <Pine.LNX.4.64.1104010959470.9530@axis700.grange> <Pine.LNX.4.64.1104011010530.9530@axis700.grange> <Pine.LNX.4.64.1105121835370.24486@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1105121835370.24486@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Guennadi,

Thanks for the patch!

Guennadi Liakhovetski wrote:
> I've found some more time to get back to this. Let me try to recap, what 
> has been discussed. I've looked through all replies again (thanks to 
> all!), so, I'll present a summary. Any mistakes and misinterpretations are 
> mine;) If I misunderstand someone or forget anything - please, shout!
> 
> On Fri, 1 Apr 2011, Guennadi Liakhovetski wrote:
> 
>> A possibility to preallocate and initialise buffers of different sizes
>> in V4L2 is required for an efficient implementation of asnapshot mode.
>> This patch adds three new ioctl()s: VIDIOC_CREATE_BUFS,
>> VIDIOC_DESTROY_BUFS, and VIDIOC_SUBMIT_BUF and defines respective data
>> structures.
>>
>> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>> ---
>>  drivers/media/video/v4l2-compat-ioctl32.c |    3 ++
>>  drivers/media/video/v4l2-ioctl.c          |   43 +++++++++++++++++++++++++++++
>>  include/linux/videodev2.h                 |   24 ++++++++++++++++
>>  include/media/v4l2-ioctl.h                |    3 ++
>>  4 files changed, 73 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/media/video/v4l2-compat-ioctl32.c b/drivers/media/video/v4l2-compat-ioctl32.c
>> index 7c26947..d71b289 100644
>> --- a/drivers/media/video/v4l2-compat-ioctl32.c
>> +++ b/drivers/media/video/v4l2-compat-ioctl32.c
>> @@ -922,6 +922,9 @@ long v4l2_compat_ioctl32(struct file *file, unsigned int cmd, unsigned long arg)
>>  	case VIDIOC_DQEVENT:
>>  	case VIDIOC_SUBSCRIBE_EVENT:
>>  	case VIDIOC_UNSUBSCRIBE_EVENT:
>> +	case VIDIOC_CREATE_BUFS:
>> +	case VIDIOC_DESTROY_BUFS:
>> +	case VIDIOC_SUBMIT_BUF:
>>  		ret = do_video_ioctl(file, cmd, arg);
>>  		break;
>>  
>> diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
>> index a01ed39..b80a211 100644
>> --- a/drivers/media/video/v4l2-ioctl.c
>> +++ b/drivers/media/video/v4l2-ioctl.c
>> @@ -259,6 +259,9 @@ static const char *v4l2_ioctls[] = {
>>  	[_IOC_NR(VIDIOC_DQEVENT)]	   = "VIDIOC_DQEVENT",
>>  	[_IOC_NR(VIDIOC_SUBSCRIBE_EVENT)]  = "VIDIOC_SUBSCRIBE_EVENT",
>>  	[_IOC_NR(VIDIOC_UNSUBSCRIBE_EVENT)] = "VIDIOC_UNSUBSCRIBE_EVENT",
>> +	[_IOC_NR(VIDIOC_CREATE_BUFS)]      = "VIDIOC_CREATE_BUFS",
>> +	[_IOC_NR(VIDIOC_DESTROY_BUFS)]     = "VIDIOC_DESTROY_BUFS",
>> +	[_IOC_NR(VIDIOC_SUBMIT_BUF)]       = "VIDIOC_SUBMIT_BUF",
>>  };
>>  #define V4L2_IOCTLS ARRAY_SIZE(v4l2_ioctls)
>>  
>> @@ -2184,6 +2187,46 @@ static long __video_do_ioctl(struct file *file,
>>  		dbgarg(cmd, "type=0x%8.8x", sub->type);
>>  		break;
>>  	}
>> +	case VIDIOC_CREATE_BUFS:
>> +	{
>> +		struct v4l2_create_buffers *create = arg;
>> +
>> +		if (!ops->vidioc_create_bufs)
>> +			break;
>> +		ret = check_fmt(ops, create->format.type);
>> +		if (ret)
>> +			break;
>> +
>> +		if (create->size)
>> +			CLEAR_AFTER_FIELD(create, count);
>> +
>> +		ret = ops->vidioc_create_bufs(file, fh, create);
>> +
>> +		dbgarg(cmd, "count=%d\n", create->count);
>> +		break;
>> +	}
>> +	case VIDIOC_DESTROY_BUFS:
>> +	{
>> +		struct v4l2_buffer_span *span = arg;
>> +
>> +		if (!ops->vidioc_destroy_bufs)
>> +			break;
>> +
>> +		ret = ops->vidioc_destroy_bufs(file, fh, span);
>> +
>> +		dbgarg(cmd, "count=%d", span->count);
>> +		break;
>> +	}
>> +	case VIDIOC_SUBMIT_BUF:
>> +	{
>> +		unsigned int *i = arg;
>> +
>> +		if (!ops->vidioc_submit_buf)
>> +			break;
>> +		ret = ops->vidioc_submit_buf(file, fh, *i);
>> +		dbgarg(cmd, "index=%d", *i);
>> +		break;
>> +	}
>>  	default:
>>  	{
>>  		bool valid_prio = true;
>> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
>> index aa6c393..b6ef46e 100644
>> --- a/include/linux/videodev2.h
>> +++ b/include/linux/videodev2.h
>> @@ -1847,6 +1847,26 @@ struct v4l2_dbg_chip_ident {
>>  	__u32 revision;    /* chip revision, chip specific */
>>  } __attribute__ ((packed));
>>  
>> +/* VIDIOC_DESTROY_BUFS */
>> +struct v4l2_buffer_span {
>> +	__u32			index;	/* output: buffers index...index + count - 1 have been created */
>> +	__u32			count;
>> +	__u32			reserved[2];
>> +};
>> +
>> +/* struct v4l2_createbuffers::flags */
>> +#define V4L2_BUFFER_FLAG_NO_CACHE_INVALIDATE	(1 << 0)
> 
> 1. An additional flag FLAG_NO_CACHE_FLUSH is needed for output devices.

Should this be called FLAG_NO_CACHE_CLEAN?

Invalidate == Make contents of the cache invalid

Clean == Make sure no dirty stuff resides in the cache

Flush == invalidate + clean

It occurred to me to wonder if two flags are needed for this, but I
think the answer is yes, since there can be memory-to-memory devices
which are both OUTPUT and CAPTURE.

> 2. Both these flags should not be passed with CREATE, but with SUBMIT 
> (which will be renamed to PREPARE or something similar). It should be 
> possible to prepare the same buffer with different cacheing attributes 
> during a running operation. Shall these flags be added to values, taken by 
> struct v4l2_buffer::flags, since that is the struct, that will be used as 
> the argument for the new version of the SUBMIT ioctl()?
> 
>> +
>> +/* VIDIOC_CREATE_BUFS */
>> +struct v4l2_create_buffers {
>> +	__u32			index;		/* output: buffers index...index + count - 1 have been created */
>> +	__u32			count;
>> +	__u32			flags;		/* V4L2_BUFFER_FLAG_* */
>> +	enum v4l2_memory        memory;
>> +	__u32			size;		/* Explicit size, e.g., for compressed streams */
>> +	struct v4l2_format	format;		/* "type" is used always, the rest if size == 0 */
>> +};
> 
> 1. Care must be taken to keep index <= V4L2_MAX_FRAME

This will make allocating new ranges of buffers impossible if the
existing buffer indices are scattered within the range.

What about making it possible to pass an array of buffer indices to the
user, just like VIDIOC_S_EXT_CTRLS does? I'm not sure if this would be
perfect, but it would avoid the problem of requiring continuous ranges
of buffer ids.

struct v4l2_create_buffers {
	__u32			*index;
	__u32			count;
	__u32			flags;
	enum v4l2_memory        memory;
	__u32			size;
	struct v4l2_format	format;
};

Index would be a pointer to an array of buffer indices and its length
would be count.

[clip]

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
