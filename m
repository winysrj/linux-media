Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:15705 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054Ab3AXMvn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Jan 2013 07:51:43 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Kamil Debski <k.debski@samsung.com>
Subject: Re: [PATCH 1/3 v2] v4l: Define video buffer flag for the COPY timestamp type
Date: Thu, 24 Jan 2013 13:51:14 +0100
Cc: linux-media@vger.kernel.org, jtp.park@samsung.com,
	arun.kk@samsung.com, s.nawrocki@samsung.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	verkuil@xs4all.nl, m.szyprowski@samsung.com, pawel@osciak.com,
	Kyungmin Park <kyungmin.park@samsung.com>
References: <1359030907-9883-1-git-send-email-k.debski@samsung.com> <1359030907-9883-2-git-send-email-k.debski@samsung.com>
In-Reply-To: <1359030907-9883-2-git-send-email-k.debski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201301241351.14213.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu 24 January 2013 13:35:05 Kamil Debski wrote:
> Define video buffer flag for the COPY timestamp. In this case the timestamp
> value is copied from the OUTPUT to the corresponding CAPTURE buffer.
> 
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  Documentation/DocBook/media/v4l/io.xml |    6 ++++++
>  include/uapi/linux/videodev2.h         |    1 +
>  2 files changed, 7 insertions(+)
> 
> diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
> index 73f202f..fdd1822 100644
> --- a/Documentation/DocBook/media/v4l/io.xml
> +++ b/Documentation/DocBook/media/v4l/io.xml
> @@ -1145,6 +1145,12 @@ in which case caches have not been used.</entry>
>  	    same clock outside V4L2, use
>  	    <function>clock_gettime(2)</function> .</entry>
>  	  </row>
> +	  <row>
> +	    <entry><constant>V4L2_BUF_FLAG_TIMESTAMP_COPY</constant></entry>
> +	    <entry>0x4000</entry>
> +	    <entry>The CAPTURE buffer timestamp has been taken from the
> +	    corresponding OUTPUT buffer.</entry>
> +	  </row>

I think I mentioned it before somewhere, but it is helpful if it is mentioned
here that this only applies to mem2mem devices.

Regards,

	Hans

>  	</tbody>
>        </tgroup>
>      </table>
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 72e9921..d5a59af 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -697,6 +697,7 @@ struct v4l2_buffer {
>  #define V4L2_BUF_FLAG_TIMESTAMP_MASK		0xe000
>  #define V4L2_BUF_FLAG_TIMESTAMP_UNKNOWN		0x0000
>  #define V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC	0x2000
> +#define V4L2_BUF_FLAG_TIMESTAMP_COPY		0x4000
>  
>  /**
>   * struct v4l2_exportbuffer - export of video buffer as DMABUF file descriptor
> 
