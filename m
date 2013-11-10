Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42955 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061Ab3KJVqY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Nov 2013 16:46:24 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Pawel Osciak <posciak@chromium.org>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v1 06/19] uvcvideo: Recognize UVC 1.5 encoding units.
Date: Sun, 10 Nov 2013 22:46:56 +0100
Message-ID: <4825160.M0Y4h4LHcI@avalon>
In-Reply-To: <1377829038-4726-7-git-send-email-posciak@chromium.org>
References: <1377829038-4726-1-git-send-email-posciak@chromium.org> <1377829038-4726-7-git-send-email-posciak@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pawel,

Thank you for the patch.

On Friday 30 August 2013 11:17:05 Pawel Osciak wrote:
> Add encoding unit definitions and descriptor parsing code and allow them to
> be added to chains.
> 
> Signed-off-by: Pawel Osciak <posciak@chromium.org>
> ---
>  drivers/media/usb/uvc/uvc_ctrl.c   | 37 ++++++++++++++++++---
>  drivers/media/usb/uvc/uvc_driver.c | 67 ++++++++++++++++++++++++++++++-----
>  drivers/media/usb/uvc/uvcvideo.h   | 14 +++++++-
>  include/uapi/linux/usb/video.h     |  1 +
>  4 files changed, 105 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_ctrl.c
> b/drivers/media/usb/uvc/uvc_ctrl.c index ba159a4..72d6724 100644
> --- a/drivers/media/usb/uvc/uvc_ctrl.c
> +++ b/drivers/media/usb/uvc/uvc_ctrl.c
> @@ -777,6 +777,7 @@ static const __u8 uvc_processing_guid[16] =
> UVC_GUID_UVC_PROCESSING; static const __u8 uvc_camera_guid[16] =
> UVC_GUID_UVC_CAMERA;
>  static const __u8 uvc_media_transport_input_guid[16] =
>  	UVC_GUID_UVC_MEDIA_TRANSPORT_INPUT;
> +static const __u8 uvc_encoding_guid[16] = UVC_GUID_UVC_ENCODING;
> 
>  static int uvc_entity_match_guid(const struct uvc_entity *entity,
>  	const __u8 guid[16])
> @@ -795,6 +796,9 @@ static int uvc_entity_match_guid(const struct uvc_entity
> *entity, return memcmp(entity->extension.guidExtensionCode,
>  			      guid, 16) == 0;
> 
> +	case UVC_VC_ENCODING_UNIT:
> +		return memcmp(uvc_encoding_guid, guid, 16) == 0;
> +
>  	default:
>  		return 0;
>  	}
> @@ -2105,12 +2109,13 @@ int uvc_ctrl_init_device(struct uvc_device *dev)
>  {
>  	struct uvc_entity *entity;
>  	unsigned int i;
> +	int num_found;
> 
>  	/* Walk the entities list and instantiate controls */
>  	list_for_each_entry(entity, &dev->entities, list) {
>  		struct uvc_control *ctrl;
> -		unsigned int bControlSize = 0, ncontrols;
> -		__u8 *bmControls = NULL;
> +		unsigned int bControlSize = 0, ncontrols = 0;
> +		__u8 *bmControls = NULL, *bmControlsRuntime = NULL;
> 
>  		if (UVC_ENTITY_TYPE(entity) == UVC_VC_EXTENSION_UNIT) {
>  			bmControls = entity->extension.bmControls;
> @@ -2121,13 +2126,25 @@ int uvc_ctrl_init_device(struct uvc_device *dev)
>  		} else if (UVC_ENTITY_TYPE(entity) == UVC_ITT_CAMERA) {
>  			bmControls = entity->camera.bmControls;
>  			bControlSize = entity->camera.bControlSize;
> +		} else if (UVC_ENTITY_TYPE(entity) == UVC_VC_ENCODING_UNIT) {
> +			bmControls = entity->encoding.bmControls;
> +			bmControlsRuntime = entity->encoding.bmControlsRuntime;
> +			bControlSize = entity->encoding.bControlSize;
>  		}
> 
>  		/* Remove bogus/blacklisted controls */
>  		uvc_ctrl_prune_entity(dev, entity);
> 
>  		/* Count supported controls and allocate the controls array */
> -		ncontrols = memweight(bmControls, bControlSize);
> +		for (i = 0; i < bControlSize; ++i) {
> +			if (bmControlsRuntime) {
> +				ncontrols += hweight8(bmControls[i]
> +						      | bmControlsRuntime[i]);

Nitpicking, could you move the | to the end of the previous line to match the 
style of the rest of the code ?

> +			} else {
> +				ncontrols += hweight8(bmControls[i]);
> +			}

The { } are not needed.

> +		}
> +
>  		if (ncontrols == 0)
>  			continue;
> 
> @@ -2139,8 +2156,17 @@ int uvc_ctrl_init_device(struct uvc_device *dev)
> 
>  		/* Initialize all supported controls */
>  		ctrl = entity->controls;
> -		for (i = 0; i < bControlSize * 8; ++i) {
> -			if (uvc_test_bit(bmControls, i) == 0)
> +		for (i = 0, num_found = 0;
> +			i < bControlSize * 8 && num_found < ncontrols; ++i) {
> +			if (uvc_test_bit(bmControls, i) == 1)
> +				ctrl->on_init = 1;
> +			if (bmControlsRuntime &&
> +				uvc_test_bit(bmControlsRuntime, i) == 1)
> +				ctrl->in_runtime = 1;
> +			else if (!bmControlsRuntime)
> +				ctrl->in_runtime = ctrl->on_init;
> +
> +			if (ctrl->on_init == 0 && ctrl->in_runtime == 0)
>  				continue;

Wouldn't it simplify the code if you assigned bmControls to bmControlsRuntime 
when bmControlsRuntime is NULL before counting the controls above ? You could 
get rid of the if inside the count loop, and you could also simplify this 
construct.

> 
>  			ctrl->entity = entity;
> @@ -2148,6 +2174,7 @@ int uvc_ctrl_init_device(struct uvc_device *dev)
> 
>  			uvc_ctrl_init_ctrl(dev, ctrl);
>  			ctrl++;
> +			num_found++;
>  		}
>  	}
> 
> diff --git a/drivers/media/usb/uvc/uvc_driver.c
> b/drivers/media/usb/uvc/uvc_driver.c index d7ff707..d950b40 100644
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c
> @@ -1155,6 +1155,37 @@ static int uvc_parse_standard_control(struct
> uvc_device *dev, list_add_tail(&unit->list, &dev->entities);
>  		break;
> 
> +	case UVC_VC_ENCODING_UNIT:
> +		n = buflen >= 7 ? buffer[6] : 0;
> +
> +		if (buflen < 7 + 2 * n) {
> +			uvc_trace(UVC_TRACE_DESCR, "device %d videocontrol "
> +				"interface %d ENCODING_UNIT error\n",
> +				udev->devnum, alts->desc.bInterfaceNumber);
> +			return -EINVAL;
> +		}
> +
> +		unit = uvc_alloc_entity(buffer[2], buffer[3], 2, 2 * n);
> +		if (unit == NULL)
> +			return -ENOMEM;
> +
> +		memcpy(unit->baSourceID, &buffer[4], 1);
> +		unit->encoding.bControlSize = buffer[6];
> +		unit->encoding.bmControls = (__u8 *)unit + sizeof(*unit);
> +		memcpy(unit->encoding.bmControls, &buffer[7], n);
> +		unit->encoding.bmControlsRuntime = unit->encoding.bmControls
> +						 + n;
> +		memcpy(unit->encoding.bmControlsRuntime, &buffer[7 + n], n);
> +
> +		if (buffer[5] != 0)
> +			usb_string(udev, buffer[5], unit->name,
> +				   sizeof(unit->name));
> +		else
> +			sprintf(unit->name, "encoding %u", buffer[3]);

Could you s/encoding/Encoding/ to match the other unit names ?

> +
> +		list_add_tail(&unit->list, &dev->entities);
> +		break;
> +
>  	default:
>  		uvc_trace(UVC_TRACE_DESCR, "Found an unknown CS_INTERFACE "
>  			"descriptor (%u)\n", buffer[2]);
> @@ -1251,25 +1282,31 @@ static void uvc_delete_chain(struct uvc_video_chain
> *chain) *
>   * - one or more Output Terminals (USB Streaming or Display)
>   * - zero or one Processing Unit
> + * - zero or one Encoding Unit
>   * - zero, one or more single-input Selector Units
>   * - zero or one multiple-input Selector Units, provided all inputs are
>   *   connected to input terminals
> - * - zero, one or mode single-input Extension Units
> + * - zero, one or more single-input Extension Units
>   * - one or more Input Terminals (Camera, External or USB Streaming)
>   *
> - * The terminal and units must match on of the following structures:
> + * The terminal and units must match one of the following structures:

While we're at it, s/terminal/terminals/ ?

>   *
> - * ITT_*(0) -> +---------+    +---------+    +---------+ -> TT_STREAMING(0)
> - * ...         | SU{0,1} | -> | PU{0,1} | -> | XU{0,n} |    ...
> - * ITT_*(n) -> +---------+    +---------+    +---------+ -> TT_STREAMING(n)
> + * ITT_*(0) -> +---------+                        -> TT_STREAMING(0) + *
> ...         | SU{0,1} | ->        (...)           ...
> + * ITT_*(n) -> +---------+                        -> TT_STREAMING(n)
> + *
> + *    Where (...), in any order:
> + *             +---------+    +---------+    +---------+
> + *             | PU{0,1} | -> | XU{0,n} | -> | EU{0,1} |
> + *             +---------+    +---------+    +---------+
>   *
>   *                 +---------+    +---------+ -> OTT_*(0)
>   * TT_STREAMING -> | PU{0,1} | -> | XU{0,n} |    ...
>   *                 +---------+    +---------+ -> OTT_*(n)
>   *
> - * The Processing Unit and Extension Units can be in any order. Additional
> - * Extension Units connected to the main chain as single-unit branches are
> - * also supported. Single-input Selector Units are ignored.
> + * The Processing Unit, the Encoding Unit and Extension Units can be in any
> + * order. Additional Extension Units connected to the main chain as
> single-unit
> + * branches are also supported. Single-input Selector Units are ignored. */
>  static int uvc_scan_chain_entity(struct uvc_video_chain *chain,
>  	struct uvc_entity *entity)

-- 
Regards,

Laurent Pinchart

