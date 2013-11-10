Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43296 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306Ab3KJW5X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Nov 2013 17:57:23 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Pawel Osciak <posciak@chromium.org>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v1 11/19] uvcvideo: Support V4L2_CTRL_TYPE_BITMASK controls.
Date: Sun, 10 Nov 2013 23:57:57 +0100
Message-ID: <1898503.DaKE7Ou2As@avalon>
In-Reply-To: <1377829038-4726-12-git-send-email-posciak@chromium.org>
References: <1377829038-4726-1-git-send-email-posciak@chromium.org> <1377829038-4726-12-git-send-email-posciak@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pawel,

Thank you for the patcj.

On Friday 30 August 2013 11:17:10 Pawel Osciak wrote:

Maybe a commit message here too ?

> Signed-off-by: Pawel Osciak <posciak@chromium.org>
> ---
>  drivers/media/usb/uvc/uvc_ctrl.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/drivers/media/usb/uvc/uvc_ctrl.c
> b/drivers/media/usb/uvc/uvc_ctrl.c index b0a19b9..a0493d6 100644
> --- a/drivers/media/usb/uvc/uvc_ctrl.c
> +++ b/drivers/media/usb/uvc/uvc_ctrl.c
> @@ -1550,6 +1550,24 @@ int uvc_ctrl_set(struct uvc_video_chain *chain,
> struct v4l2_ext_control *xctrl,
> 
>  		break;
> 
> +	case V4L2_CTRL_TYPE_BITMASK:
> +		value = xctrl->value;
> +
> +		/* If GET_RES is supported, it will return a bitmask of bits
> +		 * that can be set. If it isn't, allow any value.
> +		 */
> +		if (ctrl->info.flags & UVC_CTRL_FLAG_GET_RES) {
> +			if (!ctrl->cached) {
> +				ret = uvc_ctrl_populate_cache(chain, ctrl);
> +				if (ret < 0)
> +					return ret;
> +			}
> +			step = mapping->get(mapping, UVC_GET_RES,
> +					uvc_ctrl_data(ctrl, UVC_CTRL_DATA_RES));
> +			if (value & ~step)
> +				return -ERANGE;
> +		}

Missing break ?

> +
>  	default:
>  		value = xctrl->value;
>  		break;
-- 
Regards,

Laurent Pinchart

