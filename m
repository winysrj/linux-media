Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:40327 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750990AbdFPPvA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Jun 2017 11:51:00 -0400
Subject: Re: [RFC 2/2] docs-rst: v4l: Document V4L2_BUF_TYPE_META_OUTPUT
 interface
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: tfiga@chromium.org, yong.zhi@intel.com
References: <1497626061-2129-1-git-send-email-sakari.ailus@linux.intel.com>
 <1497626061-2129-3-git-send-email-sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <7ae2000b-2098-0ee6-616c-d4fddae9c0f9@xs4all.nl>
Date: Fri, 16 Jun 2017 17:50:55 +0200
MIME-Version: 1.0
In-Reply-To: <1497626061-2129-3-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/16/2017 05:14 PM, Sakari Ailus wrote:
> Document the interface for metadata output, including
> V4L2_BUF_TYPE_META_OUTPUT buffer type and V4L2_CAP_META_OUTPUT capability
> bits.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>   Documentation/media/uapi/v4l/buffer.rst          |  3 +++
>   Documentation/media/uapi/v4l/dev-meta.rst        | 32 ++++++++++++++----------
>   Documentation/media/uapi/v4l/vidioc-querycap.rst |  3 +++
>   3 files changed, 25 insertions(+), 13 deletions(-)
> 
> diff --git a/Documentation/media/uapi/v4l/buffer.rst b/Documentation/media/uapi/v4l/buffer.rst
> index ae6ee73..919ac1d 100644
> --- a/Documentation/media/uapi/v4l/buffer.rst
> +++ b/Documentation/media/uapi/v4l/buffer.rst
> @@ -452,6 +452,9 @@ enum v4l2_buf_type
>       * - ``V4L2_BUF_TYPE_META_CAPTURE``
>         - 13
>         - Buffer for metadata capture, see :ref:`metadata`.
> +    * - ``V4L2_BUF_TYPE_META_CAPTURE``

Should be OUTPUT of course.

> +      - 14
> +      - Buffer for metadata output, see :ref:`metadata`.
>   
>   
>   
> diff --git a/Documentation/media/uapi/v4l/dev-meta.rst b/Documentation/media/uapi/v4l/dev-meta.rst
> index 62518ad..cb007dd 100644
> --- a/Documentation/media/uapi/v4l/dev-meta.rst
> +++ b/Documentation/media/uapi/v4l/dev-meta.rst
> @@ -7,21 +7,26 @@ Metadata Interface
>   ******************
>   
>   Metadata refers to any non-image data that supplements video frames with
> -additional information. This may include statistics computed over the image
> -or frame capture parameters supplied by the image source. This interface is
> -intended for transfer of metadata to userspace and control of that operation.
> +additional information. This may include statistics computed over the image,
> +frame capture parameters supplied by the image source or device specific
> +parameters. This interface is intended for transfer of metadata between
> +the userspace and the hardware and control of that operation.
>   
> -The metadata interface is implemented on video capture device nodes. The device
> -can be dedicated to metadata or can implement both video and metadata capture
> -as specified in its reported capabilities.
> +The metadata interface is implemented on video device nodes. The device can be
> +dedicated to metadata or can support both video and metadata as specified in its
> +reported capabilities.
>   
>   Querying Capabilities
>   =====================
>   
> -Device nodes supporting the metadata interface set the ``V4L2_CAP_META_CAPTURE``
> -flag in the ``device_caps`` field of the
> +Device nodes supporting the metadata capture interface set the
> +``V4L2_CAP_META_CAPTURE`` flag in the ``device_caps`` field of the
>   :c:type:`v4l2_capability` structure returned by the :c:func:`VIDIOC_QUERYCAP`
> -ioctl. That flag means the device can capture metadata to memory.
> +ioctl. That flag means the device can capture metadata to memory. Similarly,
> +device nodes supporting metadata output interface set the
> +``V4L2_CAP_META_OUTPUT`` flag in the ``device_caps`` field of
> +:c:type:`v4l2_capability` structure. That flag means the device can read
> +metadata from memory.
>   
>   At least one of the read/write or streaming I/O methods must be supported.
>   
> @@ -35,10 +40,11 @@ to the basic :ref:`format` ioctls, the :c:func:`VIDIOC_ENUM_FMT` ioctl must be
>   supported as well.
>   
>   To use the :ref:`format` ioctls applications set the ``type`` field of the
> -:c:type:`v4l2_format` structure to ``V4L2_BUF_TYPE_META_CAPTURE`` and use the
> -:c:type:`v4l2_meta_format` ``meta`` member of the ``fmt`` union as needed per
> -the desired operation. Both drivers and applications must set the remainder of
> -the :c:type:`v4l2_format` structure to 0.
> +:c:type:`v4l2_format` structure to ``V4L2_BUF_TYPE_META_CAPTURE`` or to
> +``V4L2_BUF_TYPE_META_OUTPUT`` and use the :c:type:`v4l2_meta_format` ``meta``
> +member of the ``fmt`` union as needed per the desired operation. Both drivers
> +and applications must set the remainder of the :c:type:`v4l2_format` structure
> +to 0.
>   
>   .. _v4l2-meta-format:
>   
> diff --git a/Documentation/media/uapi/v4l/vidioc-querycap.rst b/Documentation/media/uapi/v4l/vidioc-querycap.rst
> index 12e0d9a..36bf879 100644
> --- a/Documentation/media/uapi/v4l/vidioc-querycap.rst
> +++ b/Documentation/media/uapi/v4l/vidioc-querycap.rst
> @@ -249,6 +249,9 @@ specification the ioctl returns an ``EINVAL`` error code.
>       * - ``V4L2_CAP_STREAMING``
>         - 0x04000000
>         - The device supports the :ref:`streaming <mmap>` I/O method.
> +    * - ``V4L2_CAP_META_OUTPUT``
> +      - 0x08000000
> +      - The device supports the :ref:`metadata` output interface.
>       * - ``V4L2_CAP_TOUCH``
>         - 0x10000000
>         - This is a touch device.
> 

With that fixed:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

	Hans
