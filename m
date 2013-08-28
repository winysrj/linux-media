Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:52467 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791Ab3H1MUG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Aug 2013 08:20:06 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH v4 3/3] v4l: Add V4L2_BUF_FLAG_TIMESTAMP_SOF and use it
Date: Wed, 28 Aug 2013 14:19:51 +0200
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	k.debski@samsung.com
References: <1377471723-22341-1-git-send-email-sakari.ailus@iki.fi> <1377471723-22341-4-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1377471723-22341-4-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201308281419.52009.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon 26 August 2013 01:02:03 Sakari Ailus wrote:
> Some devices such as the uvc produce timestamps at the beginning of the
> frame rather than at the end of it. Add a buffer flag
> (V4L2_BUF_FLAG_TIMESTAMP_SOF) to tell about this.
> 
> Also document timestamp_type in struct vb2_queue.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  Documentation/DocBook/media/v4l/io.xml |   17 ++++++++++++-----
>  drivers/media/usb/uvc/uvc_queue.c      |    3 ++-
>  include/media/videobuf2-core.h         |    1 +
>  include/uapi/linux/videodev2.h         |   10 ++++++++++
>  4 files changed, 25 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
> index b9a83bc..d3a725c 100644
> --- a/Documentation/DocBook/media/v4l/io.xml
> +++ b/Documentation/DocBook/media/v4l/io.xml
> @@ -654,11 +654,11 @@ plane, are stored in struct <structname>v4l2_plane</structname> instead.
>  In that case, struct <structname>v4l2_buffer</structname> contains an array of
>  plane structures.</para>
>  
> -      <para>On timestamp types that are sampled from the system clock
> -(V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC) it is guaranteed that the timestamp is
> -taken after the complete frame has been received (or transmitted in
> -case of video output devices). For other kinds of
> -timestamps this may vary depending on the driver.</para>
> +      <para>The timestamp is taken once the complete frame has been
> +received unless <constant>V4L2_BUF_FLAG_TIMESTAMP_SOF</constant>

received -> received (or transmitted for output devices)

> +buffer flag is set. If <constant>V4L2_BUF_FLAG_TIMESTAMP_SOF</constant>
> +is set, the timestamp is taken when the first pixel of the frame is
> +received.</para>

received -> received (or transmitted)

>  
>      <table frame="none" pgwide="1" id="v4l2-buffer">
>        <title>struct <structname>v4l2_buffer</structname></title>
> @@ -1120,6 +1120,13 @@ in which case caches have not been used.</entry>
>  	    <entry>The CAPTURE buffer timestamp has been taken from the
>  	    corresponding OUTPUT buffer. This flag applies only to mem2mem devices.</entry>
>  	  </row>
> +	  <row>
> +	    <entry><constant>V4L2_BUF_FLAG_TIMESTAMP_SOF</constant></entry>
> +	    <entry>0x00010000</entry>
> +	    <entry>The buffer timestamp has been taken when the first
> +	    pixel is received. If this flag is not set, the timestamp
> +	    is taken when the entire frame has been received.</entry>

Ditto: received -> received (or transmitted for output devices)

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
> index 6781258..6eb2d59 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -307,6 +307,7 @@ struct v4l2_fh;
>   * @buf_struct_size: size of the driver-specific buffer structure;
>   *		"0" indicates the driver doesn't want to use a custom buffer
>   *		structure type, so sizeof(struct vb2_buffer) will is used
> + * @timestamp_type: Type of the timestamp; V4L2_BUF_FLAGS_TIMESTAMP_*
>   * @gfp_flags:	additional gfp flags used when allocating the buffers.
>   *		Typically this is 0, but it may be e.g. GFP_DMA or __GFP_DMA32
>   *		to force the buffer allocation to a specific memory zone.
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 691077d..ca2b4fc 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -695,6 +695,16 @@ struct v4l2_buffer {
>  #define V4L2_BUF_FLAG_TIMESTAMP_UNKNOWN		0x00000000
>  #define V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC	0x00002000
>  #define V4L2_BUF_FLAG_TIMESTAMP_COPY		0x00004000
> +/*
> + * Timestamp taken once the first pixel is received. If the flag is

received -> received (or transmitted for output devices)

> + * not set the buffer timestamp is taken at the end of the frame. This
> + * is not a timestamp type.
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

Regards,

	Hans
