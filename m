Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47902 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751143AbdGOJbO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Jul 2017 05:31:14 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jacob Chen <jacob-chen@iotwrt.com>
Cc: linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        heiko@sntech.de, robh+dt@kernel.org, mchehab@kernel.org,
        linux-media@vger.kernel.org,
        laurent.pinchart+renesas@ideasonboard.com, hans.verkuil@cisco.com,
        s.nawrocki@samsung.com, tfiga@chromium.org, nicolas@ndufresne.ca
Subject: Re: [PATCH v2 1/6] [media] v4l: add blend modes controls
Date: Sat, 15 Jul 2017 12:31:19 +0300
Message-ID: <2943934.hXIk47oG5F@avalon>
In-Reply-To: <1500101920-24039-2-git-send-email-jacob-chen@iotwrt.com>
References: <1500101920-24039-1-git-send-email-jacob-chen@iotwrt.com> <1500101920-24039-2-git-send-email-jacob-chen@iotwrt.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacob,

Thank you for the patch.

On Saturday 15 Jul 2017 14:58:35 Jacob Chen wrote:
> At peresent, we don't have a control for Compositing and Blend.
> All drivers are just doing copies while actually many hardwares
> supports more functions.
> 
> So Adding V4L2 controls for Compositing and Blend, used for for
> composting streams.
> 
> The values are based on porter duff operations.
> Defined in below links.
> https://developer.xamarin.com/api/type/Android.Graphics.PorterDuff+Mode/

According to http://ssp.impulsetrain.com/porterduff.html,

"Despite being referred to as alpha blending and despite alpha often being 
used to model opacity, in concept Porter/Duff is not a way to blend the source 
and destination shapes. It is way to overlay, combine and trim them as if they 
were pieces of cardboard."

It then goes on defining blend modes that are a better match for the 
definition of blend. You might thus want to rename this control.

> Signed-off-by: Jacob Chen <jacob-chen@iotwrt.com>
> Suggested-by: Nicolas Dufresne <nicolas@ndufresne.ca>
> ---
>  drivers/media/v4l2-core/v4l2-ctrls.c | 19 +++++++++++++++++++
>  include/uapi/linux/v4l2-controls.h   | 18 +++++++++++++++++-

Controls need to be documented in Documentation/media/uapi/v4l/control.rst or 
Documentation/media/uapi/v4l/extended-controls.rst.

>  2 files changed, 36 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c
> b/drivers/media/v4l2-core/v4l2-ctrls.c index b9e08e3..8a235fd 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -216,6 +216,21 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
>  		"Private Packet, IVTV Format",
>  		NULL
>  	};
> +	static const char * const blend_modes[] = {
> +		"Source",
> +		"Source Top",
> +		"Source In",
> +		"Source Out",
> +		"Source Over",
> +		"Destination",
> +		"Destination Top",
> +		"Destination In",
> +		"Destination Out",
> +		"Destination Over",
> +		"Add",
> +		"Clear",
> +		NULL
> +	};
>  	static const char * const camera_power_line_frequency[] = {
>  		"Disabled",
>  		"50 Hz",
> @@ -522,6 +537,8 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
>  		return camera_exposure_metering;
>  	case V4L2_CID_AUTO_FOCUS_RANGE:
>  		return camera_auto_focus_range;
> +	case V4L2_CID_BLEND:
> +		return blend_modes;
>  	case V4L2_CID_COLORFX:
>  		return colorfx;
>  	case V4L2_CID_AUTO_N_PRESET_WHITE_BALANCE:
> @@ -655,6 +672,7 @@ const char *v4l2_ctrl_get_name(u32 id)
>  	case V4L2_CID_MIN_BUFFERS_FOR_OUTPUT:	return "Min Number of Output
> Buffers"; case V4L2_CID_ALPHA_COMPONENT:		return "Alpha 
Component";
>  	case V4L2_CID_COLORFX_CBCR:		return "Color Effects, CbCr";
> +	case V4L2_CID_BLEND:			return "Compositing and Blend 
Modes";
> 
>  	/* Codec controls */
>  	/* The MPEG controls are applicable to all codec controls
> @@ -1033,6 +1051,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum
> v4l2_ctrl_type *type, case V4L2_CID_MPEG_STREAM_VBI_FMT:
>  	case V4L2_CID_EXPOSURE_AUTO:
>  	case V4L2_CID_AUTO_FOCUS_RANGE:
> +	case V4L2_CID_BLEND:
>  	case V4L2_CID_COLORFX:
>  	case V4L2_CID_AUTO_N_PRESET_WHITE_BALANCE:
>  	case V4L2_CID_TUNE_PREEMPHASIS:
> diff --git a/include/uapi/linux/v4l2-controls.h
> b/include/uapi/linux/v4l2-controls.h index 0d2e1e0..019fdca 100644
> --- a/include/uapi/linux/v4l2-controls.h
> +++ b/include/uapi/linux/v4l2-controls.h
> @@ -140,8 +140,24 @@ enum v4l2_colorfx {
>  #define V4L2_CID_ALPHA_COMPONENT		(V4L2_CID_BASE+41)
>  #define V4L2_CID_COLORFX_CBCR			(V4L2_CID_BASE+42)
> 
> +#define V4L2_CID_BLEND				(V4L2_CID_BASE+43)

The image processing class (V4L2_CTRL_CLASS_IMAGE_PROC) would seem like a 
better fit than the base class for this control.

> +enum v4l2_blend_mode {
> +	V4L2_BLEND_SRC				= 0,
> +	V4L2_BLEND_SRCATOP			= 1,
> +	V4L2_BLEND_SRCIN			= 2,
> +	V4L2_BLEND_SRCOUT			= 3,
> +	V4L2_BLEND_SRCOVER			= 4,
> +	V4L2_BLEND_DST				= 5,
> +	V4L2_BLEND_DSTATOP			= 6,
> +	V4L2_BLEND_DSTIN			= 7,
> +	V4L2_BLEND_DSTOUT			= 8,
> +	V4L2_BLEND_DSTOVER			= 9,
> +	V4L2_BLEND_ADD				= 10,
> +	V4L2_BLEND_CLEAR			= 11,
> +};
> + 
>  /* last CID + 1 */
> -#define V4L2_CID_LASTP1                         (V4L2_CID_BASE+43)
> +#define V4L2_CID_LASTP1                         (V4L2_CID_BASE+44)
> 
>  /* USER-class private control IDs */

-- 
Regards,

Laurent Pinchart
