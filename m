Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:10514 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbaBYNJo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Feb 2014 08:09:44 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N1J00EM7Z87PH60@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 25 Feb 2014 13:09:43 +0000 (GMT)
From: Kamil Debski <k.debski@samsung.com>
To: 'Sakari Ailus' <sakari.ailus@iki.fi>, linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
References: <1392497585-5084-1-git-send-email-sakari.ailus@iki.fi>
 <1392497585-5084-4-git-send-email-sakari.ailus@iki.fi>
In-reply-to: <1392497585-5084-4-git-send-email-sakari.ailus@iki.fi>
Subject: RE: [PATCH v5 3/7] v4l: Add timestamp source flags,
 mask and document them
Date: Tue, 25 Feb 2014 14:09:41 +0100
Message-id: <12fa01cf322a$d8c35950$8a4a0bf0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

> From: Sakari Ailus [mailto:sakari.ailus@iki.fi]
> Sent: Saturday, February 15, 2014 9:53 PM
> 
> Some devices do not produce timestamps that correspond to the end of
> the frame. The user space should be informed on the matter. This patch
> achieves that by adding buffer flags (and a mask) for timestamp sources
> since more possible timestamping points are expected than just two.
> 
> A three-bit mask is defined (V4L2_BUF_FLAG_TSTAMP_SRC_MASK) and two of
> the eight possible values is are defined V4L2_BUF_FLAG_TSTAMP_SRC_EOF
> for end of frame (value zero) V4L2_BUF_FLAG_TSTAMP_SRC_SOE for start of
> exposure (next value).
> 

Changes in videobuf2-core.c look good.

> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>

Acked-by: Kamil Debski <k.debski@samsung.com>

> ---
>  Documentation/DocBook/media/v4l/io.xml   |   31
> ++++++++++++++++++++++++------
>  drivers/media/v4l2-core/videobuf2-core.c |    4 +++-
>  include/media/videobuf2-core.h           |    2 ++
>  include/uapi/linux/videodev2.h           |    4 ++++
>  4 files changed, 34 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/io.xml
> b/Documentation/DocBook/media/v4l/io.xml
> index 46d24b3..fbd0c6e 100644
> --- a/Documentation/DocBook/media/v4l/io.xml
> +++ b/Documentation/DocBook/media/v4l/io.xml
> @@ -653,12 +653,6 @@ plane, are stored in struct
> <structname>v4l2_plane</structname> instead.
>  In that case, struct <structname>v4l2_buffer</structname> contains an
> array of  plane structures.</para>
> 
> -      <para>For timestamp types that are sampled from the system clock
> -(V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC) it is guaranteed that the
> timestamp is -taken after the complete frame has been received (or
> transmitted in -case of video output devices). For other kinds of -
> timestamps this may vary depending on the driver.</para>
> -
>      <table frame="none" pgwide="1" id="v4l2-buffer">
>        <title>struct <structname>v4l2_buffer</structname></title>
>        <tgroup cols="4">
> @@ -1119,6 +1113,31 @@ in which case caches have not been used.</entry>
>  	    <entry>The CAPTURE buffer timestamp has been taken from the
>  	    corresponding OUTPUT buffer. This flag applies only to
> mem2mem devices.</entry>
>  	  </row>
> +	  <row>
> +
> <entry><constant>V4L2_BUF_FLAG_TSTAMP_SRC_MASK</constant></entry>
> +	    <entry>0x00070000</entry>
> +	    <entry>Mask for timestamp sources below. The timestamp source
> +	    defines the point of time the timestamp is taken in relation
> to
> +	    the frame. Logical and operation between the
> +	    <structfield>flags</structfield> field and
> +	    <constant>V4L2_BUF_FLAG_TSTAMP_SRC_MASK</constant> produces
> the
> +	    value of the timestamp source.</entry>
> +	  </row>
> +	  <row>
> +
> <entry><constant>V4L2_BUF_FLAG_TSTAMP_SRC_EOF</constant></entry>
> +	    <entry>0x00000000</entry>
> +	    <entry>"End of frame." The buffer timestamp has been taken
> +	    when the last pixel of the frame has been received or the
> +	    last pixel of the frame has been transmitted.</entry>
> +	  </row>
> +	  <row>
> +
> <entry><constant>V4L2_BUF_FLAG_TSTAMP_SRC_SOE</constant></entry>
> +	    <entry>0x00010000</entry>
> +	    <entry>"Start of exposure." The buffer timestamp has been
> taken
> +	    when the exposure of the frame has begun. This is only
> +	    valid for buffer type
> +	    <constant>V4L2_BUF_TYPE_VIDEO_CAPTURE</constant>.</entry>
> +	  </row>
>  	</tbody>
>        </tgroup>
>      </table>
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c
> b/drivers/media/v4l2-core/videobuf2-core.c
> index 5a5fb7f..6e314b0 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -2195,7 +2195,9 @@ int vb2_queue_init(struct vb2_queue *q)
>  	    WARN_ON(!q->io_modes)	  ||
>  	    WARN_ON(!q->ops->queue_setup) ||
>  	    WARN_ON(!q->ops->buf_queue)   ||
> -	    WARN_ON(q->timestamp_type & ~V4L2_BUF_FLAG_TIMESTAMP_MASK))
> +	    WARN_ON(q->timestamp_type &
> +		    ~(V4L2_BUF_FLAG_TIMESTAMP_MASK |
> +		      V4L2_BUF_FLAG_TSTAMP_SRC_MASK)))
>  		return -EINVAL;

Looks good.

> 
>  	/* Warn that the driver should choose an appropriate timestamp
> type */ diff --git a/include/media/videobuf2-core.h
> b/include/media/videobuf2-core.h index bef53ce..b6b992d 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -312,6 +312,8 @@ struct v4l2_fh;
>   * @buf_struct_size: size of the driver-specific buffer structure;
>   *		"0" indicates the driver doesn't want to use a custom
> buffer
>   *		structure type, so sizeof(struct vb2_buffer) will is used
> + * @timestamp_type: Timestamp flags; V4L2_BUF_FLAGS_TIMESTAMP_* and
> + *		V4L2_BUF_FLAGS_TSTAMP_SRC_*
>   * @gfp_flags:	additional gfp flags used when allocating the
> buffers.
>   *		Typically this is 0, but it may be e.g. GFP_DMA or
> __GFP_DMA32
>   *		to force the buffer allocation to a specific memory zone.
> diff --git a/include/uapi/linux/videodev2.h
> b/include/uapi/linux/videodev2.h index e9ee444..82e8661 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -695,6 +695,10 @@ struct v4l2_buffer {
>  #define V4L2_BUF_FLAG_TIMESTAMP_UNKNOWN		0x00000000
>  #define V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC	0x00002000
>  #define V4L2_BUF_FLAG_TIMESTAMP_COPY		0x00004000
> +/* Timestamp sources. */
> +#define V4L2_BUF_FLAG_TSTAMP_SRC_MASK		0x00070000
> +#define V4L2_BUF_FLAG_TSTAMP_SRC_EOF		0x00000000
> +#define V4L2_BUF_FLAG_TSTAMP_SRC_SOE		0x00010000
> 
>  /**
>   * struct v4l2_exportbuffer - export of video buffer as DMABUF file
> descriptor
> --
> 1.7.10.4

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland

