Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:35776 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932797AbeALMFM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Jan 2018 07:05:12 -0500
Subject: Re: [PATCH v7 2/6] [media] v4l: add 'unordered' flag to format
 description ioctl
To: Gustavo Padovan <gustavo@padovan.org>, linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        Thierry Escande <thierry.escande@collabora.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
References: <20180110160732.7722-1-gustavo@padovan.org>
 <20180110160732.7722-3-gustavo@padovan.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <d53a9ec1-8e9c-c19f-768d-2783d7ea4a1c@xs4all.nl>
Date: Fri, 12 Jan 2018 13:05:06 +0100
MIME-Version: 1.0
In-Reply-To: <20180110160732.7722-3-gustavo@padovan.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/10/18 17:07, Gustavo Padovan wrote:
> From: Gustavo Padovan <gustavo.padovan@collabora.com>
> 
> For explicit synchronization it important for userspace to know if the
> format being used by the driver can deliver the buffers back to userspace
> in the same order they were queued with QBUF.
> 
> Ordered streams fits nicely in a pipeline with DRM for example, where
> ordered buffer are expected.
> 
> Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
> ---
>  Documentation/media/uapi/v4l/vidioc-enum-fmt.rst | 3 +++
>  include/uapi/linux/videodev2.h                   | 1 +
>  2 files changed, 4 insertions(+)
> 
> diff --git a/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst b/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
> index 019c513df217..368115f44fc0 100644
> --- a/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
> +++ b/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
> @@ -116,6 +116,9 @@ one until ``EINVAL`` is returned.
>        - This format is not native to the device but emulated through
>  	software (usually libv4l2), where possible try to use a native
>  	format instead for better performance.
> +    * - ``V4L2_FMT_FLAG_UNORDERED``
> +      - 0x0004
> +      - This is a format that doesn't guarantee timely order of frames.

I'd rephrase this:

"This format doesn't guarantee ordered buffer handling. I.e. the order in
which buffers are dequeued with VIDIOC_DQBUF may be different from the order
in which they were queued with VIDIOC_QBUF."

(Use proper links to VIDIOC_(D)QBUF)

I would also like to see an example of a driver that uses this. The cobalt
driver is a candidate for this.

Regards,

	Hans

>  
>  
>  Return Value
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 982718965180..58894cfe9479 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -716,6 +716,7 @@ struct v4l2_fmtdesc {
>  
>  #define V4L2_FMT_FLAG_COMPRESSED 0x0001
>  #define V4L2_FMT_FLAG_EMULATED   0x0002
> +#define V4L2_FMT_FLAG_UNORDERED  0x0004
>  
>  	/* Frame Size and frame rate enumeration */
>  /*
> 
