Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:43841 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751089AbdFSHfr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Jun 2017 03:35:47 -0400
Subject: Re: [RFC PATCH 2/2] media/uapi/v4l: clarify cropcap/crop/selection
 behavior
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Sylwester Nawrocki <snawrocki@kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>
References: <20170508143506.16448-1-hverkuil@xs4all.nl>
 <20170508143506.16448-2-hverkuil@xs4all.nl>
Message-ID: <752af6b7-cbc4-6286-e7dd-45f0377d85b0@xs4all.nl>
Date: Mon, 19 Jun 2017 09:35:41 +0200
MIME-Version: 1.0
In-Reply-To: <20170508143506.16448-2-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On 05/08/2017 04:35 PM, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Unfortunately the use of 'type' was inconsistent for multiplanar
> buffer types. Starting with 4.12 both the normal and _MPLANE variants
> are allowed, thus making it possible to write sensible code.
> 
> Yes, we messed up :-(
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>   Documentation/media/uapi/v4l/vidioc-cropcap.rst    | 21 ++++++++++++---------
>   Documentation/media/uapi/v4l/vidioc-g-crop.rst     | 22 +++++++++++++---------
>   .../media/uapi/v4l/vidioc-g-selection.rst          | 22 ++++++++++++----------
>   3 files changed, 37 insertions(+), 28 deletions(-)
> 
> diff --git a/Documentation/media/uapi/v4l/vidioc-cropcap.rst b/Documentation/media/uapi/v4l/vidioc-cropcap.rst
> index f21a69b554e1..d354216846e6 100644
> --- a/Documentation/media/uapi/v4l/vidioc-cropcap.rst
> +++ b/Documentation/media/uapi/v4l/vidioc-cropcap.rst
> @@ -39,16 +39,19 @@ structure. Drivers fill the rest of the structure. The results are
>   constant except when switching the video standard. Remember this switch
>   can occur implicit when switching the video input or output.
>   
> -Do not use the multiplanar buffer types. Use
> -``V4L2_BUF_TYPE_VIDEO_CAPTURE`` instead of
> -``V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE`` and use
> -``V4L2_BUF_TYPE_VIDEO_OUTPUT`` instead of
> -``V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE``.
> -
>   This ioctl must be implemented for video capture or output devices that
>   support cropping and/or scaling and/or have non-square pixels, and for
>   overlay devices.
>   
> +.. note::
> +   Unfortunately in the case of multiplanar buffer types
> +   (``V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE`` and ``V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE``)
> +   this API was messed up with regards to how the :c:type:`v4l2_cropcap` ``type`` field
> +   should be filled in. The Samsung Exynos drivers only accepted the

I propose I change this to "Some drivers only..." here and at the other places I
refer to Exynos.

Do you agree?

	Hans

> +   ``_MPLANE`` buffer type while other drivers only accepted a non-multiplanar
> +   buffer type (i.e. without the ``_MPLANE`` at the end).
> +
> +   Starting with kernel 4.12 both variations are allowed.
>   
>   .. c:type:: v4l2_cropcap
>   
> @@ -62,9 +65,9 @@ overlay devices.
>       * - __u32
>         - ``type``
>         - Type of the data stream, set by the application. Only these types
> -	are valid here: ``V4L2_BUF_TYPE_VIDEO_CAPTURE``,
> -	``V4L2_BUF_TYPE_VIDEO_OUTPUT`` and
> -	``V4L2_BUF_TYPE_VIDEO_OVERLAY``. See :c:type:`v4l2_buf_type`.
> +	are valid here: ``V4L2_BUF_TYPE_VIDEO_CAPTURE``, ``V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE``,
> +	``V4L2_BUF_TYPE_VIDEO_OUTPUT``, ``V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE`` and
> +	``V4L2_BUF_TYPE_VIDEO_OVERLAY``. See :c:type:`v4l2_buf_type` and the note above.
>       * - struct :ref:`v4l2_rect <v4l2-rect-crop>`
>         - ``bounds``
>         - Defines the window within capturing or output is possible, this
> diff --git a/Documentation/media/uapi/v4l/vidioc-g-crop.rst b/Documentation/media/uapi/v4l/vidioc-g-crop.rst
> index 56a36340f565..8aabe33c8da7 100644
> --- a/Documentation/media/uapi/v4l/vidioc-g-crop.rst
> +++ b/Documentation/media/uapi/v4l/vidioc-g-crop.rst
> @@ -45,12 +45,6 @@ and struct :c:type:`v4l2_rect` substructure named ``c`` of a
>   v4l2_crop structure and call the :ref:`VIDIOC_S_CROP <VIDIOC_G_CROP>` ioctl with a pointer
>   to this structure.
>   
> -Do not use the multiplanar buffer types. Use
> -``V4L2_BUF_TYPE_VIDEO_CAPTURE`` instead of
> -``V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE`` and use
> -``V4L2_BUF_TYPE_VIDEO_OUTPUT`` instead of
> -``V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE``.
> -
>   The driver first adjusts the requested dimensions against hardware
>   limits, i. e. the bounds given by the capture/output window, and it
>   rounds to the closest possible values of horizontal and vertical offset,
> @@ -74,6 +68,16 @@ been negotiated.
>   When cropping is not supported then no parameters are changed and
>   :ref:`VIDIOC_S_CROP <VIDIOC_G_CROP>` returns the ``EINVAL`` error code.
>   
> +.. note::
> +   Unfortunately in the case of multiplanar buffer types
> +   (``V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE`` and ``V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE``)
> +   this API was messed up with regards to how the :c:type:`v4l2_crop` ``type`` field
> +   should be filled in. The Samsung Exynos drivers only accepted the
> +   ``_MPLANE`` buffer type while other drivers only accepted a non-multiplanar
> +   buffer type (i.e. without the ``_MPLANE`` at the end).
> +
> +   Starting with kernel 4.12 both variations are allowed.
> +
>   
>   .. c:type:: v4l2_crop
>   
> @@ -87,9 +91,9 @@ When cropping is not supported then no parameters are changed and
>       * - __u32
>         - ``type``
>         - Type of the data stream, set by the application. Only these types
> -	are valid here: ``V4L2_BUF_TYPE_VIDEO_CAPTURE``,
> -	``V4L2_BUF_TYPE_VIDEO_OUTPUT`` and
> -	``V4L2_BUF_TYPE_VIDEO_OVERLAY``. See :c:type:`v4l2_buf_type`.
> +	are valid here: ``V4L2_BUF_TYPE_VIDEO_CAPTURE``, ``V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE``,
> +	``V4L2_BUF_TYPE_VIDEO_OUTPUT``, ``V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE`` and
> +	``V4L2_BUF_TYPE_VIDEO_OVERLAY``. See :c:type:`v4l2_buf_type` and the note above.
>       * - struct :c:type:`v4l2_rect`
>         - ``c``
>         - Cropping rectangle. The same co-ordinate system as for struct
> diff --git a/Documentation/media/uapi/v4l/vidioc-g-selection.rst b/Documentation/media/uapi/v4l/vidioc-g-selection.rst
> index deb1f6fb473b..8d4e7bf49eab 100644
> --- a/Documentation/media/uapi/v4l/vidioc-g-selection.rst
> +++ b/Documentation/media/uapi/v4l/vidioc-g-selection.rst
> @@ -40,13 +40,19 @@ Description
>   
>   The ioctls are used to query and configure selection rectangles.
>   
> +.. note::
> +   Unfortunately in the case of multiplanar buffer types
> +   (``V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE`` and ``V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE``)
> +   this API was messed up with regards to how the :c:type:`v4l2_selection` ``type`` field
> +   should be filled in. The Samsung Exynos drivers only accepted the
> +   ``_MPLANE`` buffer type while other drivers only accepted a non-multiplanar
> +   buffer type (i.e. without the ``_MPLANE`` at the end).
> +
> +   Starting with kernel 4.12 both variations are allowed.
> +
>   To query the cropping (composing) rectangle set struct
>   :c:type:`v4l2_selection` ``type`` field to the
> -respective buffer type. Do not use the multiplanar buffer types. Use
> -``V4L2_BUF_TYPE_VIDEO_CAPTURE`` instead of
> -``V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE`` and use
> -``V4L2_BUF_TYPE_VIDEO_OUTPUT`` instead of
> -``V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE``. The next step is setting the
> +respective buffer type. The next step is setting the
>   value of struct :c:type:`v4l2_selection` ``target``
>   field to ``V4L2_SEL_TGT_CROP`` (``V4L2_SEL_TGT_COMPOSE``). Please refer
>   to table :ref:`v4l2-selections-common` or :ref:`selection-api` for
> @@ -64,11 +70,7 @@ pixels.
>   
>   To change the cropping (composing) rectangle set the struct
>   :c:type:`v4l2_selection` ``type`` field to the
> -respective buffer type. Do not use multiplanar buffers. Use
> -``V4L2_BUF_TYPE_VIDEO_CAPTURE`` instead of
> -``V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE``. Use
> -``V4L2_BUF_TYPE_VIDEO_OUTPUT`` instead of
> -``V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE``. The next step is setting the
> +respective buffer type. The next step is setting the
>   value of struct :c:type:`v4l2_selection` ``target`` to
>   ``V4L2_SEL_TGT_CROP`` (``V4L2_SEL_TGT_COMPOSE``). Please refer to table
>   :ref:`v4l2-selections-common` or :ref:`selection-api` for additional
> 
