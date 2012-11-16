Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:4402 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925Ab2KPNvq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Nov 2012 08:51:46 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH 1/4] v4l: Define video buffer flags for timestamp types
Date: Fri, 16 Nov 2012 14:51:29 +0100
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
References: <20121115220627.GB29863@valkosipuli.retiisi.org.uk> <1353017207-370-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1353017207-370-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201211161451.29922.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu November 15 2012 23:06:44 Sakari Ailus wrote:
> Define video buffer flags for different timestamp types. Everything up to
> now have used either realtime clock or monotonic clock, without a way to
> tell which clock the timestamp was taken from.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  Documentation/DocBook/media/v4l/io.xml |   25 +++++++++++++++++++++++++
>  include/uapi/linux/videodev2.h         |    4 ++++
>  2 files changed, 29 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
> index 7e2f3d7..d598f2c 100644
> --- a/Documentation/DocBook/media/v4l/io.xml
> +++ b/Documentation/DocBook/media/v4l/io.xml
> @@ -938,6 +938,31 @@ Typically applications shall use this flag for output buffers if the data
>  in this buffer has not been created by the CPU but by some DMA-capable unit,
>  in which case caches have not been used.</entry>
>  	  </row>
> +	  <row>
> +	    <entry><constant>V4L2_BUF_FLAG_TIMESTAMP_MASK</constant></entry>
> +	    <entry>0xe000</entry>
> +	    <entry>Mask for timestamp types below. To test the
> +	    timestamp type, mask out bits not belonging to timestamp
> +	    type by performing a logical and operation with buffer
> +	    flags and timestamp mask.</tt> </entry>
> +	  </row>
> +	  <row>
> +	    <entry><constant>V4L2_BUF_FLAG_TIMESTAMP_UNKNOWN</constant></entry>
> +	    <entry>0x0000</entry>
> +	    <entry>Unknown timestamp type. This type is used by
> +	    drivers before Linux 3.8 and may be either monotonic (see
> +	    below) or realtime. Monotonic clock has been favoured in
> +	    embedded systems whereas most of the drivers use the
> +	    realtime clock.</entry>

Isn't 'wallclock time' a better expression? It is probably a good idea as well
to add the userspace call that gives the same clock: gettimeofday or
clock_gettime(CLOCK_REALTIME) for the wallclock time and clock_gettime(CLOCK_MONOTONIC)
for the monotonic time. That way apps can do the same call and compare it to the
timestamp received.

> +	  </row>
> +	  <row>
> +	    <entry><constant>V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC</constant></entry>
> +	    <entry>0x2000</entry>
> +	    <entry>The buffer timestamp has been taken from the
> +	    <constant>CLOCK_MONOTONIC</constant> clock. To access the
> +	    same clock outside V4L2, use <tt>clock_gettime(2)</tt>

Ah, you mentioned it here already for the monotonic clock :-)

> +	    .</entry>
> +	  </row>
>  	</tbody>
>        </tgroup>
>      </table>
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 2fff7ff..410ea9f 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -686,6 +686,10 @@ struct v4l2_buffer {
>  /* Cache handling flags */
>  #define V4L2_BUF_FLAG_NO_CACHE_INVALIDATE	0x0800
>  #define V4L2_BUF_FLAG_NO_CACHE_CLEAN		0x1000
> +/* Timestamp type */
> +#define V4L2_BUF_FLAG_TIMESTAMP_MASK		0xe000
> +#define V4L2_BUF_FLAG_TIMESTAMP_UNKNOWN		0x0000
> +#define V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC	0x2000
>  
>  /*
>   *	O V E R L A Y   P R E V I E W
> 

Regards,

	Hans
