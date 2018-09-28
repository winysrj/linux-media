Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:56586 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726603AbeI1UMz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Sep 2018 16:12:55 -0400
Subject: Re: [PATCH 1/5] videodev2.h: Use 8 hexadecimals (32 bits) for control
 flags
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: tfiga@chromium.org, bingbu.cao@intel.com, jian.xu.zheng@intel.com,
        rajmohan.mani@intel.com, tian.shu.qiu@intel.com,
        ricardo.ribalda@gmail.com, grundler@chromium.org,
        ping-chung.chen@intel.com, andy.yeh@intel.com, jim.lai@intel.com,
        helmut.grohne@intenta.de, laurent.pinchart@ideasonboard.com,
        snawrocki@kernel.org
References: <20180925101434.20327-1-sakari.ailus@linux.intel.com>
 <20180925101434.20327-2-sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <9972464e-d88c-74b5-be9e-68104c867c00@xs4all.nl>
Date: Fri, 28 Sep 2018 15:48:58 +0200
MIME-Version: 1.0
In-Reply-To: <20180925101434.20327-2-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/25/2018 12:14 PM, Sakari Ailus wrote:
> The V4L2 control flags are a 32-bit bitmask. Use 32-bit hexadecimal
> numbers to specify the flags (was 16).
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  Documentation/media/uapi/v4l/vidioc-queryctrl.rst | 22 +++++++++++-----------
>  include/uapi/linux/videodev2.h                    | 22 +++++++++++-----------
>  2 files changed, 22 insertions(+), 22 deletions(-)
> 
> diff --git a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
> index 5bd26e8c9a1a0..ff2d131223b84 100644
> --- a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
> +++ b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
> @@ -439,37 +439,37 @@ See also the examples in :ref:`control`.
>      :widths:       3 1 4
>  
>      * - ``V4L2_CTRL_FLAG_DISABLED``
> -      - 0x0001
> +      - 0x00000001
>        - This control is permanently disabled and should be ignored by the
>  	application. Any attempt to change the control will result in an
>  	``EINVAL`` error code.
>      * - ``V4L2_CTRL_FLAG_GRABBED``
> -      - 0x0002
> +      - 0x00000002
>        - This control is temporarily unchangeable, for example because
>  	another application took over control of the respective resource.
>  	Such controls may be displayed specially in a user interface.
>  	Attempts to change the control may result in an ``EBUSY`` error code.
>      * - ``V4L2_CTRL_FLAG_READ_ONLY``
> -      - 0x0004
> +      - 0x00000004
>        - This control is permanently readable only. Any attempt to change
>  	the control will result in an ``EINVAL`` error code.
>      * - ``V4L2_CTRL_FLAG_UPDATE``
> -      - 0x0008
> +      - 0x00000008
>        - A hint that changing this control may affect the value of other
>  	controls within the same control class. Applications should update
>  	their user interface accordingly.
>      * - ``V4L2_CTRL_FLAG_INACTIVE``
> -      - 0x0010
> +      - 0x00000010
>        - This control is not applicable to the current configuration and
>  	should be displayed accordingly in a user interface. For example
>  	the flag may be set on a MPEG audio level 2 bitrate control when
>  	MPEG audio encoding level 1 was selected with another control.
>      * - ``V4L2_CTRL_FLAG_SLIDER``
> -      - 0x0020
> +      - 0x00000020
>        - A hint that this control is best represented as a slider-like
>  	element in a user interface.
>      * - ``V4L2_CTRL_FLAG_WRITE_ONLY``
> -      - 0x0040
> +      - 0x00000040
>        - This control is permanently writable only. Any attempt to read the
>  	control will result in an ``EACCES`` error code error code. This flag
>  	is typically present for relative controls or action controls
> @@ -477,7 +477,7 @@ See also the examples in :ref:`control`.
>  	action (e. g. motor control) but no meaningful value can be
>  	returned.
>      * - ``V4L2_CTRL_FLAG_VOLATILE``
> -      - 0x0080
> +      - 0x00000080
>        - This control is volatile, which means that the value of the
>  	control changes continuously. A typical example would be the
>  	current gain value if the device is in auto-gain mode. In such a
> @@ -493,7 +493,7 @@ See also the examples in :ref:`control`.
>  	   Setting a new value for a volatile control will *never* trigger a
>  	   :ref:`V4L2_EVENT_CTRL_CH_VALUE <ctrl-changes-flags>` event.
>      * - ``V4L2_CTRL_FLAG_HAS_PAYLOAD``
> -      - 0x0100
> +      - 0x00000100
>        - This control has a pointer type, so its value has to be accessed
>  	using one of the pointer fields of struct
>  	:c:type:`v4l2_ext_control`. This flag is set
> @@ -503,7 +503,7 @@ See also the examples in :ref:`control`.
>      * .. _FLAG_EXECUTE_ON_WRITE:
>  
>        - ``V4L2_CTRL_FLAG_EXECUTE_ON_WRITE``
> -      - 0x0200
> +      - 0x00000200
>        - The value provided to the control will be propagated to the driver
>  	even if it remains constant. This is required when the control
>  	represents an action on the hardware. For example: clearing an
> @@ -512,7 +512,7 @@ See also the examples in :ref:`control`.
>      * .. _FLAG_MODIFY_LAYOUT:
>  
>        - ``V4L2_CTRL_FLAG_MODIFY_LAYOUT``
> -      - 0x0400
> +      - 0x00000400
>        - Changing this control value may modify the layout of the
>          buffer (for video devices) or the media bus format (for sub-devices).
>  
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 184e4dbe8f9c0..ae083978988f1 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -1681,17 +1681,17 @@ struct v4l2_querymenu {
>  } __attribute__ ((packed));
>  
>  /*  Control flags  */
> -#define V4L2_CTRL_FLAG_DISABLED		0x0001
> -#define V4L2_CTRL_FLAG_GRABBED		0x0002
> -#define V4L2_CTRL_FLAG_READ_ONLY	0x0004
> -#define V4L2_CTRL_FLAG_UPDATE		0x0008
> -#define V4L2_CTRL_FLAG_INACTIVE		0x0010
> -#define V4L2_CTRL_FLAG_SLIDER		0x0020
> -#define V4L2_CTRL_FLAG_WRITE_ONLY	0x0040
> -#define V4L2_CTRL_FLAG_VOLATILE		0x0080
> -#define V4L2_CTRL_FLAG_HAS_PAYLOAD	0x0100
> -#define V4L2_CTRL_FLAG_EXECUTE_ON_WRITE	0x0200
> -#define V4L2_CTRL_FLAG_MODIFY_LAYOUT	0x0400
> +#define V4L2_CTRL_FLAG_DISABLED		0x00000001
> +#define V4L2_CTRL_FLAG_GRABBED		0x00000002
> +#define V4L2_CTRL_FLAG_READ_ONLY	0x00000004
> +#define V4L2_CTRL_FLAG_UPDATE		0x00000008
> +#define V4L2_CTRL_FLAG_INACTIVE		0x00000010
> +#define V4L2_CTRL_FLAG_SLIDER		0x00000020
> +#define V4L2_CTRL_FLAG_WRITE_ONLY	0x00000040
> +#define V4L2_CTRL_FLAG_VOLATILE		0x00000080
> +#define V4L2_CTRL_FLAG_HAS_PAYLOAD	0x00000100
> +#define V4L2_CTRL_FLAG_EXECUTE_ON_WRITE	0x00000200
> +#define V4L2_CTRL_FLAG_MODIFY_LAYOUT	0x00000400
>  
>  /*  Query flags, to be ORed with the control ID */
>  #define V4L2_CTRL_FLAG_NEXT_CTRL	0x80000000
> 
