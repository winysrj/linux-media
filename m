Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60426 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327Ab2KEKdR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Nov 2012 05:33:17 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Subject: Re: [RFC 1/4] v4l: Define video buffer flags for timestamp types
Date: Sun, 04 Nov 2012 13:05:35 +0100
Message-ID: <5808999.EXgvlF9x5r@avalon>
In-Reply-To: <1351102583-682-1-git-send-email-sakari.ailus@iki.fi>
References: <20121024181602.GD23933@valkosipuli.retiisi.org.uk> <1351102583-682-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Wednesday 24 October 2012 21:16:20 Sakari Ailus wrote:
> Define video buffer flags for different timestamp types. Everything up to
> now have used either realtime clock or monotonic clock, without a way to
> tell which clock the timestamp was taken from.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  Documentation/DocBook/media/v4l/io.xml |   25 +++++++++++++++++++++++++
>  include/uapi/linux/videodev2.h         |    4 ++++
>  2 files changed, 29 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/io.xml
> b/Documentation/DocBook/media/v4l/io.xml index 7e2f3d7..d598f2c 100644
> --- a/Documentation/DocBook/media/v4l/io.xml
> +++ b/Documentation/DocBook/media/v4l/io.xml
> @@ -938,6 +938,31 @@ Typically applications shall use this flag for output
> buffers if the data in this buffer has not been created by the CPU but by
> some DMA-capable unit, in which case caches have not been used.</entry>
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
> +	  </row>
> +	  <row>
> +	    <entry><constant>V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC</constant></entry>
> +	    <entry>0x2000</entry>
> +	    <entry>The buffer timestamp has been taken from the
> +	    <constant>CLOCK_MONOTONIC</constant> clock. To access the
> +	    same clock outside V4L2, use <tt>clock_gettime(2)</tt>
> +	    .</entry>
> +	  </row>
>  	</tbody>
>        </tgroup>
>      </table>
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 57bfa59..5cd8823 100644
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
-- 
Regards,

Laurent Pinchart

