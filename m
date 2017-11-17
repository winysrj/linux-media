Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:63017 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754945AbdKQL5j (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Nov 2017 06:57:39 -0500
Date: Fri, 17 Nov 2017 09:57:31 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Gustavo Padovan <gustavo@padovan.org>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        Thierry Escande <thierry.escande@collabora.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: Re: [RFC v5 01/11] [media] v4l: add V4L2_CAP_ORDERED to the uapi
Message-ID: <20171117095731.2172c3c2@vento.lan>
In-Reply-To: <20171115171057.17340-2-gustavo@padovan.org>
References: <20171115171057.17340-1-gustavo@padovan.org>
        <20171115171057.17340-2-gustavo@padovan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 15 Nov 2017 15:10:47 -0200
Gustavo Padovan <gustavo@padovan.org> escreveu:

> From: Gustavo Padovan <gustavo.padovan@collabora.com>
> 
> When using explicit synchronization userspace needs to know if
> the queue can deliver everything back in the same order, so we added
> a new capability that drivers can use to report that they are capable
> of keeping ordering.
> 
> In videobuf2 core when using fences we also make sure to keep the ordering
> of buffers, so if the driver guarantees it too the whole pipeline inside
> V4L2 will be ordered and the V4L2_CAP_ORDERED should be used.
> 
> Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
> ---
>  Documentation/media/uapi/v4l/vidioc-querycap.rst | 3 +++
>  include/uapi/linux/videodev2.h                   | 1 +
>  2 files changed, 4 insertions(+)
> 
> diff --git a/Documentation/media/uapi/v4l/vidioc-querycap.rst b/Documentation/media/uapi/v4l/vidioc-querycap.rst
> index 66fb1b3d6e6e..ed3daa814da9 100644
> --- a/Documentation/media/uapi/v4l/vidioc-querycap.rst
> +++ b/Documentation/media/uapi/v4l/vidioc-querycap.rst
> @@ -254,6 +254,9 @@ specification the ioctl returns an ``EINVAL`` error code.
>      * - ``V4L2_CAP_TOUCH``
>        - 0x10000000
>        - This is a touch device.
> +    * - ``V4L2_CAP_ORDERED``
> +      - 0x20000000
> +      - The device queue is ordered.
>      * - ``V4L2_CAP_DEVICE_CAPS``
>        - 0x80000000
>        - The driver fills the ``device_caps`` field. This capability can
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 185d6a0acc06..cd6fc1387f47 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -459,6 +459,7 @@ struct v4l2_capability {
>  #define V4L2_CAP_STREAMING              0x04000000  /* streaming I/O ioctls */
>  
>  #define V4L2_CAP_TOUCH                  0x10000000  /* Is a touch device */
> +#define V4L2_CAP_ORDERED                0x20000000  /* Is the device queue ordered */

I guess we discussed that at the Linux Media summit.
The problem of making it a global flag is that drivers may support
ordered formats only for some of the formats. E. g., a driver that
delivers both MPEG and RGB output formats may deliver ordered
buffers for RGB, and unordered ones for MPEG.

So, instead of doing a global format at v4l2_capability, it is probably
better to use the flags field at struct v4l2_fmtdesc.

That would allow userspace to know in advance what formats support
it, by calling VIDIOC_ENUM_FMT.

Regards,
Mauro
