Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30371 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828Ab2FRLY3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jun 2012 07:24:29 -0400
Message-ID: <4FDF0FE6.3060301@redhat.com>
Date: Mon, 18 Jun 2012 08:24:22 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andrzej Hajda <a.hajda@samsung.com>
CC: linux-media@vger.kernel.org, hans.verkuil@cisco.com,
	m.szyprowski@samsung.com, k.debski@samsung.com
Subject: Re: [PATCH 1/2] v4l: added V4L2_BUF_FLAG_EOS flag indicating the
 last frame in the stream
References: <1337700835-13634-1-git-send-email-a.hajda@samsung.com> <1337700835-13634-2-git-send-email-a.hajda@samsung.com>
In-Reply-To: <1337700835-13634-2-git-send-email-a.hajda@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 22-05-2012 12:33, Andrzej Hajda escreveu:
> Some devices requires indicator if the buffer is the last one in the stream.
> Applications and drivers can use this flag in such case.
> 
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>   Documentation/DocBook/media/v4l/io.xml          |    7 +++++++
>   Documentation/DocBook/media/v4l/vidioc-qbuf.xml |    2 ++
>   include/linux/videodev2.h                       |    1 +
>   3 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
> index fd6aca2..dcbf1e0 100644
> --- a/Documentation/DocBook/media/v4l/io.xml
> +++ b/Documentation/DocBook/media/v4l/io.xml
> @@ -956,6 +956,13 @@ Typically applications shall use this flag for output buffers if the data
>   in this buffer has not been created by the CPU but by some DMA-capable unit,
>   in which case caches have not been used.</entry>
>   	  </row>
> +	  <row>
> +	    <entry><constant>V4L2_BUF_FLAG_EOS</constant></entry>
> +	    <entry>0x2000</entry>
> +	    <entry>Application should set this flag in the output buffer
> +in order to inform the driver about the last frame of the stream. Some
> +drivers may require it to properly finish processing the stream.</entry>

This breaks backward compatibility, as applications written before this change
won't set this flag.

> +	  </row>
>   	</tbody>
>         </tgroup>
>       </table>
> diff --git a/Documentation/DocBook/media/v4l/vidioc-qbuf.xml b/Documentation/DocBook/media/v4l/vidioc-qbuf.xml
> index 9caa49a..ad49f7d 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-qbuf.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-qbuf.xml
> @@ -76,6 +76,8 @@ supports capturing from specific video inputs and you want to specify a video
>   input, then <structfield>flags</structfield> should be set to
>   <constant>V4L2_BUF_FLAG_INPUT</constant> and the field
>   <structfield>input</structfield> must be initialized to the desired input.
> +Some drivers expects applications set <constant>V4L2_BUF_FLAG_EOS</constant>
> +flag on the last buffer of the stream.
>   The <structfield>reserved</structfield> field must be set to 0. When using
>   the <link linkend="planar-apis">multi-planar API</link>, the
>   <structfield>m.planes</structfield> field must contain a userspace pointer
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 370d111..e44a7cd 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -676,6 +676,7 @@ struct v4l2_buffer {
>   /* Cache handling flags */
>   #define V4L2_BUF_FLAG_NO_CACHE_INVALIDATE	0x0800
>   #define V4L2_BUF_FLAG_NO_CACHE_CLEAN		0x1000
> +#define V4L2_BUF_FLAG_EOS	0x2000	/* The last buffer in the stream */
>   
>   /*
>    *	O V E R L A Y   P R E V I E W
> 


