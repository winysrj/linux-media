Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:28750 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754444AbaCLOpB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Mar 2014 10:45:01 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N2B00LP4VN0CI10@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Wed, 12 Mar 2014 10:45:00 -0400 (EDT)
Date: Wed, 12 Mar 2014 11:44:53 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, ismael.luceno@corp.bluecherry.net,
	pete@sensoray.com, sakari.ailus@iki.fi,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEWv3 PATCH 24/35] v4l2-ctrls/videodev2.h: add u8 and u16
 types.
Message-id: <20140312114453.06236492@samsung.com>
In-reply-to: <1392631070-41868-25-git-send-email-hverkuil@xs4all.nl>
References: <1392631070-41868-1-git-send-email-hverkuil@xs4all.nl>
 <1392631070-41868-25-git-send-email-hverkuil@xs4all.nl>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 17 Feb 2014 10:57:39 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> These are needed by the upcoming patches for the motion detection
> matrices.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/v4l2-core/v4l2-ctrls.c | 45 ++++++++++++++++++++++++++++++++----
>  include/media/v4l2-ctrls.h           |  4 ++++
>  include/uapi/linux/videodev2.h       |  4 ++++
>  3 files changed, 49 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index 1886b79..ca4271b 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -1145,6 +1145,10 @@ static bool std_equal(const struct v4l2_ctrl *ctrl, u32 idx,
>  		return !strcmp(ptr1.p_char + idx, ptr2.p_char + idx);
>  	case V4L2_CTRL_TYPE_INTEGER64:
>  		return ptr1.p_s64[idx] == ptr2.p_s64[idx];
> +	case V4L2_CTRL_TYPE_U8:
> +		return ptr1.p_u8[idx] == ptr2.p_u8[idx];
> +	case V4L2_CTRL_TYPE_U16:
> +		return ptr1.p_u16[idx] == ptr2.p_u16[idx];

Please replace V4L2_CTRL_TYPE_INTEGER64 and V4L2_CTRL_TYPE_INTEGER to
V4L2_CTRL_TYPE_S64 and V4L2_CTRL_TYPE_S32 and add an alias for those previous
names at videodev2.h:

#define V4L2_CTRL_TYPE_INTEGER64	V4L2_CTRL_TYPE_S64
#define V4L2_CTRL_TYPE_INTEGER		V4L2_CTRL_TYPE_S32

Please notice that there's no reason at all to deprecate the old names,
so we'll keep the above defines forever.

Yet, now that we're using U<bitsize> for some types, let's standardize this to
the other types too, as it makes the API more consistent.

Also, I won't doubt that we'll eventually need S8, S16, U32, U64 types in
the future.

>  	default:
>  		if (ctrl->is_int)
>  			return ptr1.p_s32[idx] == ptr2.p_s32[idx];
> @@ -1172,6 +1176,12 @@ static void std_init(const struct v4l2_ctrl *ctrl, u32 idx,
>  	case V4L2_CTRL_TYPE_BOOLEAN:
>  		ptr.p_s32[idx] = ctrl->default_value;
>  		break;
> +	case V4L2_CTRL_TYPE_U8:
> +		ptr.p_u8[idx] = ctrl->default_value;
> +		break;
> +	case V4L2_CTRL_TYPE_U16:
> +		ptr.p_u16[idx] = ctrl->default_value;
> +		break;
>  	default:
>  		idx *= ctrl->elem_size;
>  		memset(ptr.p + idx, 0, ctrl->elem_size);
> @@ -1208,6 +1218,12 @@ static void std_log(const struct v4l2_ctrl *ctrl)
>  	case V4L2_CTRL_TYPE_STRING:
>  		pr_cont("%s", ptr.p_char);
>  		break;
> +	case V4L2_CTRL_TYPE_U8:
> +		pr_cont("%u", (unsigned)*ptr.p_u8);
> +		break;
> +	case V4L2_CTRL_TYPE_U16:
> +		pr_cont("%u", (unsigned)*ptr.p_u16);
> +		break;
>  	default:
>  		pr_cont("unknown type %d", ctrl->type);
>  		break;
> @@ -1238,6 +1254,10 @@ static int std_validate(const struct v4l2_ctrl *ctrl, u32 idx,
>  		return ROUND_TO_RANGE(ptr.p_s32[idx], u32, ctrl);
>  	case V4L2_CTRL_TYPE_INTEGER64:
>  		return ROUND_TO_RANGE(ptr.p_s64[idx], u64, ctrl);
> +	case V4L2_CTRL_TYPE_U8:
> +		return ROUND_TO_RANGE(ptr.p_u8[idx], u8, ctrl);
> +	case V4L2_CTRL_TYPE_U16:
> +		return ROUND_TO_RANGE(ptr.p_u16[idx], u16, ctrl);
>  
>  	case V4L2_CTRL_TYPE_BOOLEAN:
>  		ptr.p_s32[idx] = !!ptr.p_s32[idx];
> @@ -1470,6 +1490,8 @@ static int check_range(enum v4l2_ctrl_type type,
>  		if (step != 1 || max > 1 || min < 0)
>  			return -ERANGE;
>  		/* fall through */
> +	case V4L2_CTRL_TYPE_U8:
> +	case V4L2_CTRL_TYPE_U16:
>  	case V4L2_CTRL_TYPE_INTEGER:
>  	case V4L2_CTRL_TYPE_INTEGER64:
>  		if (step == 0 || min > max || def < min || def > max)
> @@ -1768,12 +1790,25 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
>  		rows = 1;
>  	is_matrix = cols > 1 || rows > 1;
>  
> -	if (type == V4L2_CTRL_TYPE_INTEGER64)
> +	/* Prefill elem_size for all types handled by std_type_ops */
> +	switch (type) {
> +	case V4L2_CTRL_TYPE_INTEGER64:
>  		elem_size = sizeof(s64);
> -	else if (type == V4L2_CTRL_TYPE_STRING)
> +		break;
> +	case V4L2_CTRL_TYPE_STRING:
>  		elem_size = max + 1;
> -	else if (type < V4L2_CTRL_COMPLEX_TYPES)
> -		elem_size = sizeof(s32);
> +		break;
> +	case V4L2_CTRL_TYPE_U8:
> +		elem_size = sizeof(u8);
> +		break;
> +	case V4L2_CTRL_TYPE_U16:
> +		elem_size = sizeof(u16);
> +		break;
> +	default:
> +		if (type < V4L2_CTRL_COMPLEX_TYPES)
> +			elem_size = sizeof(s32);
> +		break;
> +	}
>  	tot_ctrl_size = elem_size * cols * rows;
>  
>  	/* Sanity checks */
> @@ -3114,6 +3149,8 @@ int v4l2_ctrl_modify_range(struct v4l2_ctrl *ctrl,
>  	case V4L2_CTRL_TYPE_MENU:
>  	case V4L2_CTRL_TYPE_INTEGER_MENU:
>  	case V4L2_CTRL_TYPE_BITMASK:
> +	case V4L2_CTRL_TYPE_U8:
> +	case V4L2_CTRL_TYPE_U16:
>  		if (ctrl->is_matrix)
>  			return -EINVAL;
>  		ret = check_range(ctrl->type, min, max, step, def);
> diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
> index 7d72328..2ccad5f 100644
> --- a/include/media/v4l2-ctrls.h
> +++ b/include/media/v4l2-ctrls.h
> @@ -39,12 +39,16 @@ struct poll_table_struct;
>  /** union v4l2_ctrl_ptr - A pointer to a control value.
>   * @p_s32:	Pointer to a 32-bit signed value.
>   * @p_s64:	Pointer to a 64-bit signed value.
> + * @p_u8:	Pointer to a 8-bit unsigned value.
> + * @p_u16:	Pointer to a 16-bit unsigned value.
>   * @p_char:	Pointer to a string.
>   * @p:		Pointer to a complex value.
>   */
>  union v4l2_ctrl_ptr {
>  	s32 *p_s32;
>  	s64 *p_s64;
> +	u8 *p_u8;
> +	u16 *p_u16;
>  	char *p_char;
>  	void *p;
>  };
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 858a6f3..8b70f51 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -1228,6 +1228,8 @@ struct v4l2_ext_control {
>  		__s32 value;
>  		__s64 value64;
>  		char *string;
> +		__u8 *p_u8;
> +		__u16 *p_u16;
>  		void *p;
>  	};
>  } __attribute__ ((packed));
> @@ -1257,6 +1259,8 @@ enum v4l2_ctrl_type {
>  
>  	/* Complex types are >= 0x0100 */
>  	V4L2_CTRL_COMPLEX_TYPES	     = 0x0100,
> +	V4L2_CTRL_TYPE_U8	     = 0x0100,
> +	V4L2_CTRL_TYPE_U16	     = 0x0101,

Huh? Why are those two compound types?

If all you want is to have a "matrix" set of types, IMO, the
best would be to do, instead

enum v4l2_ctrl_type {
	/* Basic types */
	V4L2_CTRL_TYPE_S32	     = 1,
	V4L2_CTRL_TYPE_BOOLEAN	     = 2,
	V4L2_CTRL_TYPE_MENU	     = 3,
	V4L2_CTRL_TYPE_BUTTON	     = 4,
	V4L2_CTRL_TYPE_S64           = 5,
	V4L2_CTRL_TYPE_CTRL_CLASS    = 6,
	V4L2_CTRL_TYPE_STRING        = 7,
	V4L2_CTRL_TYPE_BITMASK       = 8,
	V4L2_CTRL_TYPE_INTEGER_MENU  = 9,
	V4L2_CTRL_TYPE_U8	     = 10,
	V4L2_CTRL_TYPE_U16	     = 11,

	/* Modifiers */
	V4L2_CTRL_TYPE_MATRIX	     = 0x100
};

That way, a matrix of S32 would have type = V4L2_CTRL_TYPE_S32 | V4L2_CTRL_TYPE_MATRIX.

A matrix of U16 would be V4L2_CTRL_TYPE_U16 | V4L2_CTRL_TYPE_MATRIX, and so on.


>  };
>  
>  /*  Used in the VIDIOC_QUERYCTRL ioctl for querying controls */


-- 

Regards,
Mauro
