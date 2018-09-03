Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40618 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbeICRtS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Sep 2018 13:49:18 -0400
Subject: Re: [PATCH v4 5/6] media: Add controls for JPEG quantization tables
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>,
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
References: <20180831155245.19235-1-ezequiel@collabora.com>
 <ec1dab04-1890-5555-44cf-2cdadc79c1a6@xs4all.nl>
From: Ian Arkver <ian.arkver.dev@gmail.com>
Message-ID: <b5715198-eff0-30d2-6f84-cd1441d3f7ba@gmail.com>
Date: Mon, 3 Sep 2018 14:29:03 +0100
MIME-Version: 1.0
In-Reply-To: <ec1dab04-1890-5555-44cf-2cdadc79c1a6@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 03/09/2018 10:50, Hans Verkuil wrote:
> On 08/31/2018 05:52 PM, Ezequiel Garcia wrote:
>> From: Shunqian Zheng <zhengsq@rock-chips.com>
>>
>> Add V4L2_CID_JPEG_QUANTIZATION compound control to allow userspace
>> configure the JPEG quantization tables.
>>
>> Signed-off-by: Shunqian Zheng <zhengsq@rock-chips.com>
>> Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
>> ---
>>   .../media/uapi/v4l/extended-controls.rst      | 23 +++++++++++++++++++
>>   .../media/videodev2.h.rst.exceptions          |  1 +
>>   drivers/media/v4l2-core/v4l2-ctrls.c          | 10 ++++++++
>>   include/uapi/linux/v4l2-controls.h            |  5 ++++
>>   include/uapi/linux/videodev2.h                |  1 +
>>   5 files changed, 40 insertions(+)
>>
>> diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
>> index 9f7312bf3365..e0dd03e452de 100644
>> --- a/Documentation/media/uapi/v4l/extended-controls.rst
>> +++ b/Documentation/media/uapi/v4l/extended-controls.rst
>> @@ -3354,7 +3354,30 @@ JPEG Control IDs
>>       Specify which JPEG markers are included in compressed stream. This
>>       control is valid only for encoders.
>>   
>> +.. _jpeg-quant-tables-control:
>>   
>> +``V4L2_CID_JPEG_QUANTIZATION (struct)``
>> +    Specifies the luma and chroma quantization matrices for encoding
>> +    or decoding a V4L2_PIX_FMT_JPEG_RAW format buffer. The two matrices
>> +    must be set in JPEG zigzag order, as per the JPEG specification.
> 
> Can you change "JPEG specification" to a reference to the JPEG spec entry
> in bibio.rst?
> 
>> +
>> +
>> +.. c:type:: struct v4l2_ctrl_jpeg_quantization
>> +
>> +.. cssclass:: longtable
>> +
>> +.. flat-table:: struct v4l2_ctrl_jpeg_quantization
>> +    :header-rows:  0
>> +    :stub-columns: 0
>> +    :widths:       1 1 2
>> +
>> +    * - __u8
>> +      - ``luma_quantization_matrix[64]``
>> +      - Sets the luma quantization table.
>> +
>> +    * - __u8
>> +      - ``chroma_quantization_matrix[64]``
>> +      - Sets the chroma quantization table.
> 
> Just checking: the JPEG standard specifies this as unsigned 8-bit values as well?

As far as I can see ISO/IEC 10918-1 does not specify the precision or 
signedness of the quantisation value Qvu. The default tables for 8-bit 
baseline JPEG all fit into __u8 though.

However there can be four sets of tables in non-baseline JPEG and it's 
not clear (to me) whether 12-bit JPEG would need more precision (I'd 
guess it would). Since this patch is defining UAPI I think it might be 
good to build in some additional information, eg. number of tables, 
element size. Maybe this can all be inferred from the selected pixel 
format? If so then it would need documented that the above structure 
only applies to baseline.

Regards,
Ian

> 
>>   
>>   .. flat-table::
>>       :header-rows:  0
>> diff --git a/Documentation/media/videodev2.h.rst.exceptions b/Documentation/media/videodev2.h.rst.exceptions
>> index ca9f0edc579e..a0a38e92bf38 100644
>> --- a/Documentation/media/videodev2.h.rst.exceptions
>> +++ b/Documentation/media/videodev2.h.rst.exceptions
>> @@ -129,6 +129,7 @@ replace symbol V4L2_CTRL_TYPE_STRING :c:type:`v4l2_ctrl_type`
>>   replace symbol V4L2_CTRL_TYPE_U16 :c:type:`v4l2_ctrl_type`
>>   replace symbol V4L2_CTRL_TYPE_U32 :c:type:`v4l2_ctrl_type`
>>   replace symbol V4L2_CTRL_TYPE_U8 :c:type:`v4l2_ctrl_type`
>> +replace symbol V4L2_CTRL_TYPE_JPEG_QUANTIZATION :c:type:`v4l2_ctrl_type`
>>   
>>   # V4L2 capability defines
>>   replace define V4L2_CAP_VIDEO_CAPTURE device-capabilities
>> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
>> index 599c1cbff3b9..305bd7a9b7f1 100644
>> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
>> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
>> @@ -999,6 +999,7 @@ const char *v4l2_ctrl_get_name(u32 id)
>>   	case V4L2_CID_JPEG_RESTART_INTERVAL:	return "Restart Interval";
>>   	case V4L2_CID_JPEG_COMPRESSION_QUALITY:	return "Compression Quality";
>>   	case V4L2_CID_JPEG_ACTIVE_MARKER:	return "Active Markers";
>> +	case V4L2_CID_JPEG_QUANTIZATION:	return "JPEG Quantization Tables";
>>   
>>   	/* Image source controls */
>>   	/* Keep the order of the 'case's the same as in v4l2-controls.h! */
>> @@ -1286,6 +1287,9 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
>>   	case V4L2_CID_DETECT_MD_REGION_GRID:
>>   		*type = V4L2_CTRL_TYPE_U8;
>>   		break;
>> +	case V4L2_CID_JPEG_QUANTIZATION:
>> +		*type = V4L2_CTRL_TYPE_JPEG_QUANTIZATION;
>> +		break;
>>   	case V4L2_CID_DETECT_MD_THRESHOLD_GRID:
>>   		*type = V4L2_CTRL_TYPE_U16;
>>   		break;
>> @@ -1612,6 +1616,9 @@ static int std_validate(const struct v4l2_ctrl *ctrl, u32 idx,
>>   			return -ERANGE;
>>   		return 0;
>>   
>> +	case V4L2_CTRL_TYPE_JPEG_QUANTIZATION:
>> +		return 0;
>> +
>>   	default:
>>   		return -EINVAL;
>>   	}
>> @@ -2133,6 +2140,9 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
>>   	case V4L2_CTRL_TYPE_U32:
>>   		elem_size = sizeof(u32);
>>   		break;
>> +	case V4L2_CTRL_TYPE_JPEG_QUANTIZATION:
>> +		elem_size = sizeof(struct v4l2_ctrl_jpeg_quantization);
>> +		break;
>>   	default:
>>   		if (type < V4L2_CTRL_COMPOUND_TYPES)
>>   			elem_size = sizeof(s32);
>> diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
>> index e4ee10ee917d..fcb288bb05c7 100644
>> --- a/include/uapi/linux/v4l2-controls.h
>> +++ b/include/uapi/linux/v4l2-controls.h
>> @@ -987,6 +987,11 @@ enum v4l2_jpeg_chroma_subsampling {
>>   #define	V4L2_JPEG_ACTIVE_MARKER_DQT		(1 << 17)
>>   #define	V4L2_JPEG_ACTIVE_MARKER_DHT		(1 << 18)
>>   
>> +#define V4L2_CID_JPEG_QUANTIZATION		(V4L2_CID_JPEG_CLASS_BASE + 5)
>> +struct v4l2_ctrl_jpeg_quantization {
>> +	__u8	luma_quantization_matrix[64];
>> +	__u8	chroma_quantization_matrix[64];
>> +};
>>   
>>   /* Image source controls */
>>   #define V4L2_CID_IMAGE_SOURCE_CLASS_BASE	(V4L2_CTRL_CLASS_IMAGE_SOURCE | 0x900)
>> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
>> index f271048c89c4..e998d07464cb 100644
>> --- a/include/uapi/linux/videodev2.h
>> +++ b/include/uapi/linux/videodev2.h
>> @@ -1630,6 +1630,7 @@ enum v4l2_ctrl_type {
>>   	V4L2_CTRL_TYPE_U8	     = 0x0100,
>>   	V4L2_CTRL_TYPE_U16	     = 0x0101,
>>   	V4L2_CTRL_TYPE_U32	     = 0x0102,
>> +	V4L2_CTRL_TYPE_JPEG_QUANTIZATION = 0x0103,
>>   };
>>   
>>   /*  Used in the VIDIOC_QUERYCTRL ioctl for querying controls */
>>
> 
> Regards,
> 
> 	Hans
> 
