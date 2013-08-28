Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1770 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829Ab3H1Pa1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Aug 2013 11:30:27 -0400
Message-ID: <521E1779.9030905@xs4all.nl>
Date: Wed, 28 Aug 2013 17:30:01 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	k.debski@samsung.com
Subject: Re: [PATCH v4.1 3/3] v4l: Add V4L2_BUF_FLAG_TIMESTAMP_SOF and use
 it
References: <201308281419.52009.hverkuil@xs4all.nl> <1377703495-21112-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1377703495-21112-1-git-send-email-sakari.ailus@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/28/2013 05:24 PM, Sakari Ailus wrote:
> Some devices such as the uvc produce timestamps at the beginning of the
> frame rather than at the end of it. Add a buffer flag
> (V4L2_BUF_FLAG_TIMESTAMP_SOF) to tell about this.
> 
> Also document timestamp_type in struct vb2_queue, and make the uvc set the
> buffer flag.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
> since v4:
> - Fixes according to Hans's comments.
> 
> - Note in comment the uvc driver will set the SOF flag from now on.
> 
> - Change comment of vb2_queue timestamp_type field: this is timestamp flags
>   rather than just type. I stopped short of renaming the field.
> 
>  Documentation/DocBook/media/v4l/io.xml |   19 ++++++++++++++-----
>  drivers/media/usb/uvc/uvc_queue.c      |    3 ++-
>  include/media/videobuf2-core.h         |    1 +
>  include/uapi/linux/videodev2.h         |   10 ++++++++++
>  4 files changed, 27 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
> index 2c155cc..3aee210 100644
> --- a/Documentation/DocBook/media/v4l/io.xml
> +++ b/Documentation/DocBook/media/v4l/io.xml
> @@ -654,11 +654,12 @@ plane, are stored in struct <structname>v4l2_plane</structname> instead.
>  In that case, struct <structname>v4l2_buffer</structname> contains an array of
>  plane structures.</para>
>  
> -      <para>For timestamp types that are sampled from the system clock
> -(V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC) it is guaranteed that the timestamp is
> -taken after the complete frame has been received (or transmitted in
> -case of video output devices). For other kinds of
> -timestamps this may vary depending on the driver.</para>
> +      <para>The timestamp is taken once the complete frame has been
> +received (or transmitted for output devices) unless

unless -> unless the

> +<constant>V4L2_BUF_FLAG_TIMESTAMP_SOF</constant> buffer flag is set.
> +If <constant>V4L2_BUF_FLAG_TIMESTAMP_SOF</constant> is set, the

the -> then the

> +timestamp is taken when the first pixel of the frame is received
> +(or transmitted).</para>
>  
>      <table frame="none" pgwide="1" id="v4l2-buffer">
>        <title>struct <structname>v4l2_buffer</structname></title>
> @@ -1120,6 +1121,14 @@ in which case caches have not been used.</entry>
>  	    <entry>The CAPTURE buffer timestamp has been taken from the
>  	    corresponding OUTPUT buffer. This flag applies only to mem2mem devices.</entry>
>  	  </row>
> +	  <row>
> +	    <entry><constant>V4L2_BUF_FLAG_TIMESTAMP_SOF</constant></entry>
> +	    <entry>0x00010000</entry>
> +	    <entry>The buffer timestamp has been taken when the first

I think 'has been' should be 'was' in this context.

> +	    pixel is received (or transmitted for output devices). If
> +	    this flag is not set, the timestamp is taken when the
> +	    entire frame has been received (or transmitted).</entry>

Ditto.

> +	  </row>
>  	</tbody>
>        </tgroup>
>      </table>
> diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
> index cd962be..0d80512 100644
> --- a/drivers/media/usb/uvc/uvc_queue.c
> +++ b/drivers/media/usb/uvc/uvc_queue.c
> @@ -149,7 +149,8 @@ int uvc_queue_init(struct uvc_video_queue *queue, enum v4l2_buf_type type,
>  	queue->queue.buf_struct_size = sizeof(struct uvc_buffer);
>  	queue->queue.ops = &uvc_queue_qops;
>  	queue->queue.mem_ops = &vb2_vmalloc_memops;
> -	queue->queue.timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	queue->queue.timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC
> +		| V4L2_BUF_FLAG_TIMESTAMP_SOF;
>  	ret = vb2_queue_init(&queue->queue);
>  	if (ret)
>  		return ret;
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index 6781258..033efc7 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -307,6 +307,7 @@ struct v4l2_fh;
>   * @buf_struct_size: size of the driver-specific buffer structure;
>   *		"0" indicates the driver doesn't want to use a custom buffer
>   *		structure type, so sizeof(struct vb2_buffer) will is used
> + * @timestamp_type: Timestamp flags; V4L2_BUF_FLAGS_TIMESTAMP_*
>   * @gfp_flags:	additional gfp flags used when allocating the buffers.
>   *		Typically this is 0, but it may be e.g. GFP_DMA or __GFP_DMA32
>   *		to force the buffer allocation to a specific memory zone.
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 691077d..c57765e 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -695,6 +695,16 @@ struct v4l2_buffer {
>  #define V4L2_BUF_FLAG_TIMESTAMP_UNKNOWN		0x00000000
>  #define V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC	0x00002000
>  #define V4L2_BUF_FLAG_TIMESTAMP_COPY		0x00004000
> +/*
> + * Timestamp taken once the first pixel is received (or transmitted). 
> + * If the flag is not set the buffer timestamp is taken at the end of
> + * the frame. This is not a timestamp type.
> + *
> + * In general drivers should not use this flag if the end-of-frame
> + * timestamps is as good quality as the start-of-frame one; the
> + * V4L2_EVENT_FRAME_SYNC event should be used in that case instead.
> + */
> +#define V4L2_BUF_FLAG_TIMESTAMP_SOF		0x00010000
>  
>  /**
>   * struct v4l2_exportbuffer - export of video buffer as DMABUF file descriptor
> 

After making the changes suggested above:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans
