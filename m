Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:40340 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728063AbeIJRgE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Sep 2018 13:36:04 -0400
Subject: Re: [PATCH v5 5/6] media: Add controls for JPEG quantization tables
To: Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-rockchip@lists.infradead.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Miouyouyou <myy@miouyouyou.fr>,
        Shunqian Zheng <zhengsq@rock-chips.com>
References: <20180905220011.16612-1-ezequiel@collabora.com>
 <20180905220011.16612-6-ezequiel@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <718d8a73-008a-a610-d090-91cc54a992ad@xs4all.nl>
Date: Mon, 10 Sep 2018 14:42:03 +0200
MIME-Version: 1.0
In-Reply-To: <20180905220011.16612-6-ezequiel@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/06/2018 12:00 AM, Ezequiel Garcia wrote:
> From: Shunqian Zheng <zhengsq@rock-chips.com>
> 
> Add V4L2_CID_JPEG_QUANTIZATION compound control to allow userspace
> configure the JPEG quantization tables.
> 
> Signed-off-by: Shunqian Zheng <zhengsq@rock-chips.com>
> Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> ---
>  .../media/uapi/v4l/extended-controls.rst      | 31 +++++++++++++++++++
>  .../media/videodev2.h.rst.exceptions          |  1 +
>  drivers/media/v4l2-core/v4l2-ctrls.c          | 10 ++++++
>  include/uapi/linux/v4l2-controls.h            | 12 +++++++
>  include/uapi/linux/videodev2.h                |  1 +
>  5 files changed, 55 insertions(+)
> 
> diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
> index 9f7312bf3365..1335d27d30f3 100644
> --- a/Documentation/media/uapi/v4l/extended-controls.rst
> +++ b/Documentation/media/uapi/v4l/extended-controls.rst
> @@ -3354,7 +3354,38 @@ JPEG Control IDs
>      Specify which JPEG markers are included in compressed stream. This
>      control is valid only for encoders.
>  
> +.. _jpeg-quant-tables-control:
>  
> +``V4L2_CID_JPEG_QUANTIZATION (struct)``
> +    Specifies the luma and chroma quantization matrices for encoding
> +    or decoding a V4L2_PIX_FMT_JPEG_RAW format buffer. The :ref:`itu-t81`
> +    specification allows 8-bit quantization coefficients for
> +    baseline profile images, and 8-bit or 16-bit for extended profile
> +    images. Supporting or not 16-bit precision coefficients is driver-specific.
> +    Coefficients must be set in JPEG zigzag scan order.
> +
> +
> +.. c:type:: struct v4l2_ctrl_jpeg_quantization
> +
> +.. cssclass:: longtable
> +
> +.. flat-table:: struct v4l2_ctrl_jpeg_quantization
> +    :header-rows:  0
> +    :stub-columns: 0
> +    :widths:       1 1 2
> +
> +    * - __u8
> +      - ``precision``
> +      - Specifies the coefficient precision. User shall set 0
> +        for 8-bit, and 1 for 16-bit.

So does specifying 1 here switch the HW encoder to use extended profile?
What if the HW only supports baseline? The rockchip driver doesn't appear
to check the precision field at all...

I think this needs a bit more thought.

I am not at all sure that this is the right place for the precision field.
This is really about JPEG profiles, so I would kind of expect a JPEG PROFILE
control (just like other codec profiles), or possibly a new pixelformat for
extended profiles.

And based on that the driver would interpret these matrix values as 8 or
16 bits.

Regards,

	Hans

> +
> +    * - __u16
> +      - ``luma_quantization_matrix[64]``
> +      - Sets the luma quantization table.
> +
> +    * - __u16
> +      - ``chroma_quantization_matrix[64]``
> +      - Sets the chroma quantization table.
>  
>  .. flat-table::
>      :header-rows:  0
> diff --git a/Documentation/media/videodev2.h.rst.exceptions b/Documentation/media/videodev2.h.rst.exceptions
> index ca9f0edc579e..a0a38e92bf38 100644
> --- a/Documentation/media/videodev2.h.rst.exceptions
> +++ b/Documentation/media/videodev2.h.rst.exceptions
> @@ -129,6 +129,7 @@ replace symbol V4L2_CTRL_TYPE_STRING :c:type:`v4l2_ctrl_type`
>  replace symbol V4L2_CTRL_TYPE_U16 :c:type:`v4l2_ctrl_type`
>  replace symbol V4L2_CTRL_TYPE_U32 :c:type:`v4l2_ctrl_type`
>  replace symbol V4L2_CTRL_TYPE_U8 :c:type:`v4l2_ctrl_type`
> +replace symbol V4L2_CTRL_TYPE_JPEG_QUANTIZATION :c:type:`v4l2_ctrl_type`
>  
>  # V4L2 capability defines
>  replace define V4L2_CAP_VIDEO_CAPTURE device-capabilities
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index 599c1cbff3b9..305bd7a9b7f1 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -999,6 +999,7 @@ const char *v4l2_ctrl_get_name(u32 id)
>  	case V4L2_CID_JPEG_RESTART_INTERVAL:	return "Restart Interval";
>  	case V4L2_CID_JPEG_COMPRESSION_QUALITY:	return "Compression Quality";
>  	case V4L2_CID_JPEG_ACTIVE_MARKER:	return "Active Markers";
> +	case V4L2_CID_JPEG_QUANTIZATION:	return "JPEG Quantization Tables";
>  
>  	/* Image source controls */
>  	/* Keep the order of the 'case's the same as in v4l2-controls.h! */
> @@ -1286,6 +1287,9 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
>  	case V4L2_CID_DETECT_MD_REGION_GRID:
>  		*type = V4L2_CTRL_TYPE_U8;
>  		break;
> +	case V4L2_CID_JPEG_QUANTIZATION:
> +		*type = V4L2_CTRL_TYPE_JPEG_QUANTIZATION;
> +		break;
>  	case V4L2_CID_DETECT_MD_THRESHOLD_GRID:
>  		*type = V4L2_CTRL_TYPE_U16;
>  		break;
> @@ -1612,6 +1616,9 @@ static int std_validate(const struct v4l2_ctrl *ctrl, u32 idx,
>  			return -ERANGE;
>  		return 0;
>  
> +	case V4L2_CTRL_TYPE_JPEG_QUANTIZATION:
> +		return 0;
> +
>  	default:
>  		return -EINVAL;
>  	}
> @@ -2133,6 +2140,9 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
>  	case V4L2_CTRL_TYPE_U32:
>  		elem_size = sizeof(u32);
>  		break;
> +	case V4L2_CTRL_TYPE_JPEG_QUANTIZATION:
> +		elem_size = sizeof(struct v4l2_ctrl_jpeg_quantization);
> +		break;
>  	default:
>  		if (type < V4L2_CTRL_COMPOUND_TYPES)
>  			elem_size = sizeof(s32);
> diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
> index e4ee10ee917d..856b3325052f 100644
> --- a/include/uapi/linux/v4l2-controls.h
> +++ b/include/uapi/linux/v4l2-controls.h
> @@ -987,6 +987,18 @@ enum v4l2_jpeg_chroma_subsampling {
>  #define	V4L2_JPEG_ACTIVE_MARKER_DQT		(1 << 17)
>  #define	V4L2_JPEG_ACTIVE_MARKER_DHT		(1 << 18)
>  
> +#define V4L2_CID_JPEG_QUANTIZATION		(V4L2_CID_JPEG_CLASS_BASE + 5)
> +struct v4l2_ctrl_jpeg_quantization {
> +	/* ITU-T.81 specifies two quantization coefficient precisions:
> +	 * 8-bit for baseline profile,
> +	 * 8-bit or 16-bit for extended profile.
> +	 *
> +	 * User shall set "precision" to 0 for 8-bit and 1 for 16-bit.
> +	 */
> +	__u8	precision;
> +	__u16	luma_quantization_matrix[64];
> +	__u16	chroma_quantization_matrix[64];
> +};
>  
>  /* Image source controls */
>  #define V4L2_CID_IMAGE_SOURCE_CLASS_BASE	(V4L2_CTRL_CLASS_IMAGE_SOURCE | 0x900)
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index f9f3ae5b489e..8ace47cb1003 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -1637,6 +1637,7 @@ enum v4l2_ctrl_type {
>  	V4L2_CTRL_TYPE_U8	     = 0x0100,
>  	V4L2_CTRL_TYPE_U16	     = 0x0101,
>  	V4L2_CTRL_TYPE_U32	     = 0x0102,
> +	V4L2_CTRL_TYPE_JPEG_QUANTIZATION = 0x0103,
>  };
>  
>  /*  Used in the VIDIOC_QUERYCTRL ioctl for querying controls */
> 
