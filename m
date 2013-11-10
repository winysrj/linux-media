Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43185 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223Ab3KJWds (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Nov 2013 17:33:48 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Pawel Osciak <posciak@chromium.org>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v1 09/19] uvcvideo: Reorganize uvc_{get,set}_le_value.
Date: Sun, 10 Nov 2013 23:34:23 +0100
Message-ID: <7484188.u3foHPPnsB@avalon>
In-Reply-To: <1377829038-4726-10-git-send-email-posciak@chromium.org>
References: <1377829038-4726-1-git-send-email-posciak@chromium.org> <1377829038-4726-10-git-send-email-posciak@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pawel,

Thank you for the patch.

On Friday 30 August 2013 11:17:08 Pawel Osciak wrote:

Could you add commit message to explain why this patch is needed ?

> Signed-off-by: Pawel Osciak <posciak@chromium.org>
> ---
>  drivers/media/usb/uvc/uvc_ctrl.c | 62 ++++++++++++++++++++++---------------
>  1 file changed, 37 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_ctrl.c
> b/drivers/media/usb/uvc/uvc_ctrl.c index 72d6724..d735c88 100644
> --- a/drivers/media/usb/uvc/uvc_ctrl.c
> +++ b/drivers/media/usb/uvc/uvc_ctrl.c
> @@ -707,18 +707,12 @@ static inline void uvc_clear_bit(__u8 *data, int bit)
>  	data[bit >> 3] &= ~(1 << (bit & 7));
>  }
> 
> -/* Extract the bit string specified by mapping->offset and mapping->size
> - * from the little-endian data stored at 'data' and return the result as
> - * a signed 32bit integer. Sign extension will be performed if the mapping
> - * references a signed data type.
> - */
> -static __s32 uvc_get_le_value(struct uvc_control_mapping *mapping,
> -	__u8 query, const __u8 *data)
> +static int __uvc_get_le_value(int bits, int offset, const __u8 *data,
> +				__u32 data_type)
>  {
> -	int bits = mapping->size;
> -	int offset = mapping->offset;
>  	__s32 value = 0;
>  	__u8 mask;
> +	int size = bits;
> 
>  	data += offset / 8;
>  	offset &= 7;
> @@ -733,22 +727,49 @@ static __s32 uvc_get_le_value(struct
> uvc_control_mapping *mapping, }
> 
>  	/* Sign-extend the value if needed. */
> -	if (mapping->data_type == UVC_CTRL_DATA_TYPE_SIGNED)
> -		value |= -(value & (1 << (mapping->size - 1)));
> +	if (data_type == UVC_CTRL_DATA_TYPE_SIGNED)
> +		value |= -(value & (1 << (size - 1)));
> 
>  	return value;
>  }
> 
> +/* Extract the bit string specified by mapping->offset and mapping->size
> + * from the little-endian data stored at 'data' and return the result as
> + * a signed 32bit integer. Sign extension will be performed if the mapping
> + * references a signed data type.
> + */
> +static __s32 uvc_get_le_value(struct uvc_control_mapping *mapping,
> +	__u8 query, const __u8 *data)
> +{
> +	return __uvc_get_le_value(mapping->size, mapping->offset, data,
> +					mapping->data_type);
> +}
> +
> +static void __uvc_set_le_value(int bits, int offset, __s32 value, __u8
> *data, +				bool keep_existing)
> +{
> +	__u8 mask;
> +
> +	data += offset / 8;
> +	offset &= 7;
> +
> +	for (; bits > 0; data++) {
> +		mask = ((1LL << bits) - 1) << offset;
> +		if (!keep_existing)

keep_existing is not used by this patch, I'd remove it from here and add it to 
the patch that makes use of the feature.

> +			*data = (*data & ~mask);
> +		*data |= ((value << offset) & mask);
> +		value >>= (8 - offset);
> +		bits -= 8 - offset;
> +		offset = 0;
> +	}
> +}
> +
>  /* Set the bit string specified by mapping->offset and mapping->size
>   * in the little-endian data stored at 'data' to the value 'value'.
>   */
>  static void uvc_set_le_value(struct uvc_control_mapping *mapping,
>  	__s32 value, __u8 *data)
>  {
> -	int bits = mapping->size;
> -	int offset = mapping->offset;
> -	__u8 mask;
> -
>  	/* According to the v4l2 spec, writing any value to a button control
>  	 * should result in the action belonging to the button control being
>  	 * triggered. UVC devices however want to see a 1 written -> override
> @@ -757,16 +778,7 @@ static void uvc_set_le_value(struct uvc_control_mapping
> *mapping, if (mapping->v4l2_type == V4L2_CTRL_TYPE_BUTTON)
>  		value = -1;
> 
> -	data += offset / 8;
> -	offset &= 7;
> -
> -	for (; bits > 0; data++) {
> -		mask = ((1LL << bits) - 1) << offset;
> -		*data = (*data & ~mask) | ((value << offset) & mask);
> -		value >>= offset ? offset : 8;
> -		bits -= 8 - offset;
> -		offset = 0;
> -	}
> +	__uvc_set_le_value(mapping->size, mapping->offset, value, data, false);
>  }
> 
>  /* ------------------------------------------------------------------------
-- 
Regards,

Laurent Pinchart

