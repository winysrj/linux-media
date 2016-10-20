Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:37841 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751905AbcJTLGo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Oct 2016 07:06:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Re: [PATCH v2 48/58] uvc: don't break long lines
Date: Thu, 20 Oct 2016 14:06:39 +0300
Message-ID: <13552516.PS8MEv7nnO@avalon>
In-Reply-To: <74854af1c3eaafda607285d55f98b4520ce3d21e.1476822925.git.mchehab@s-opensource.com>
References: <cover.1476822924.git.mchehab@s-opensource.com> <74854af1c3eaafda607285d55f98b4520ce3d21e.1476822925.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thank you for the patch.

On Tuesday 18 Oct 2016 18:46:00 Mauro Carvalho Chehab wrote:
> Due to the 80-cols restrictions, and latter due to checkpatch
> warnings, several strings were broken into multiple lines. This
> is not considered a good practice anymore, as it makes harder
> to grep for strings at the source code.
> 
> As we're right now fixing other drivers due to KERN_CONT, we need
> to be able to identify what printk strings don't end with a "\n".
> It is a way easier to detect those if we don't break long lines.
> 
> So, join those continuation lines.
> 
> The patch was generated via the script below, and manually
> adjusted if needed.
> 
> </script>
> use Text::Tabs;
> while (<>) {
> 	if ($next ne "") {
> 		$c=$_;
> 		if ($c =~ /^\s+\"(.*)/) {
> 			$c2=$1;
> 			$next =~ s/\"\n$//;
> 			$n = expand($next);
> 			$funpos = index($n, '(');
> 			$pos = index($c2, '",');
> 			if ($funpos && $pos > 0) {
> 				$s1 = substr $c2, 0, $pos + 2;
> 				$s2 = ' ' x ($funpos + 1) . substr $c2, 
$pos + 2;
> 				$s2 =~ s/^\s+//;
> 
> 				$s2 = ' ' x ($funpos + 1) . $s2 if ($s2 ne 
"");
> 
> 				print unexpand("$next$s1\n");
> 				print unexpand("$s2\n") if ($s2 ne "");
> 			} else {
> 				print "$next$c2\n";
> 			}
> 			$next="";
> 			next;
> 		} else {
> 			print $next;
> 		}
> 		$next="";
> 	} else {
> 		if (m/\"$/) {
> 			if (!m/\\n\"$/) {
> 				$next=$_;
> 				next;
> 			}
> 		}
> 	}
> 	print $_;
> }
> </script>
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/usb/uvc/uvc_ctrl.c    |  36 ++---
>  drivers/media/usb/uvc/uvc_debugfs.c |   5 +-
>  drivers/media/usb/uvc/uvc_driver.c  | 278 ++++++++++++++++-----------------
>  drivers/media/usb/uvc/uvc_entity.c  |  10 +-
>  drivers/media/usb/uvc/uvc_isight.c  |  12 +-
>  drivers/media/usb/uvc/uvc_status.c  |  23 +--
>  drivers/media/usb/uvc/uvc_v4l2.c    |  11 +-
>  drivers/media/usb/uvc/uvc_video.c   | 103 ++++++-------
>  8 files changed, 256 insertions(+), 222 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_ctrl.c
> b/drivers/media/usb/uvc/uvc_ctrl.c index c2ee6e39fd0c..747415d4fa60 100644
> --- a/drivers/media/usb/uvc/uvc_ctrl.c
> +++ b/drivers/media/usb/uvc/uvc_ctrl.c

[snip]

> @@ -1710,8 +1709,9 @@ static int uvc_ctrl_init_xu_ctrl(struct uvc_device
> *dev,
> 
>  	ret = uvc_ctrl_add_info(dev, ctrl, &info);
>  	if (ret < 0)
> -		uvc_trace(UVC_TRACE_CONTROL, "Failed to initialize control "
> -			  "%pUl/%u on device %s entity %u\n", info.entity,
> +		uvc_trace(UVC_TRACE_CONTROL,
> +			  "Failed to initialize control %pUl/%u on device 
%s entity %u\n",
> +			  info.entity,
>  			  info.selector, dev->udev->devpath, ctrl->entity-
>id);

The split looks weird, the following would be better.

			  info.entity, info.selector, dev->udev->devpath,
 			  ctrl->entity->id);

> 
>  	return ret;
> @@ -1904,8 +1904,9 @@ static int uvc_ctrl_add_info(struct uvc_device *dev,
> struct uvc_control *ctrl,
> 
>  	ctrl->initialized = 1;
> 
> -	uvc_trace(UVC_TRACE_CONTROL, "Added control %pUl/%u to device %s "
> -		"entity %u\n", ctrl->info.entity, ctrl->info.selector,
> +	uvc_trace(UVC_TRACE_CONTROL,
> +		  "Added control %pUl/%u to device %s entity %u\n",
> +		  ctrl->info.entity, ctrl->info.selector,
>  		dev->udev->devpath, ctrl->entity->id);

The last line isn't indented correctly.

> 
>  done:
> @@ -1964,8 +1965,9 @@ int uvc_ctrl_add_mapping(struct uvc_video_chain
> *chain, int ret;
> 
>  	if (mapping->id & ~V4L2_CTRL_ID_MASK) {
> -		uvc_trace(UVC_TRACE_CONTROL, "Can't add mapping '%s', 
control "
> -			"id 0x%08x is invalid.\n", mapping->name,
> +		uvc_trace(UVC_TRACE_CONTROL,
> +			  "Can't add mapping '%s', control id 0x%08x is 
invalid.\n",
> +			  mapping->name,
>  			mapping->id);

The last two arguments can fit on a single line.

>  		return -EINVAL;
>  	}
> @@ -2004,8 +2006,8 @@ int uvc_ctrl_add_mapping(struct uvc_video_chain
> *chain,
> 
>  	list_for_each_entry(map, &ctrl->info.mappings, list) {
>  		if (mapping->id == map->id) {
> -			uvc_trace(UVC_TRACE_CONTROL, "Can't add mapping 
'%s', "
> -				"control id 0x%08x already exists.\n",
> +			uvc_trace(UVC_TRACE_CONTROL,
> +				  "Can't add mapping '%s', control id 
0x%08x already exists.\n",
>  				mapping->name, mapping->id);

The last line isn't indented correctly.

>  			ret = -EEXIST;
>  			goto done;
> @@ -2015,8 +2017,9 @@ int uvc_ctrl_add_mapping(struct uvc_video_chain
> *chain, /* Prevent excess memory consumption */
>  	if (atomic_inc_return(&dev->nmappings) > UVC_MAX_CONTROL_MAPPINGS) {
>  		atomic_dec(&dev->nmappings);
> -		uvc_trace(UVC_TRACE_CONTROL, "Can't add mapping '%s', 
maximum "
> -			"mappings count (%u) exceeded.\n", mapping->name,
> +		uvc_trace(UVC_TRACE_CONTROL,
> +			  "Can't add mapping '%s', maximum mappings count 
(%u) exceeded.\n",
> +			  mapping->name,
>  			UVC_MAX_CONTROL_MAPPINGS);

Same here.

>  		ret = -ENOMEM;
>  		goto done;

[snip]

> diff --git a/drivers/media/usb/uvc/uvc_driver.c
> b/drivers/media/usb/uvc/uvc_driver.c index 9c4b56b4a9c6..7502569752f6
> 100644
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c

[snip]

> @@ -623,15 +624,17 @@ static int uvc_parse_streaming(struct uvc_device *dev,
> 
>  	if (intf->cur_altsetting->desc.bInterfaceSubClass
>  		!= UVC_SC_VIDEOSTREAMING) {
> -		uvc_trace(UVC_TRACE_DESCR, "device %d interface %d isn't a "
> -			"video streaming interface\n", dev->udev->devnum,
> -			intf->altsetting[0].desc.bInterfaceNumber);
> +		uvc_trace(UVC_TRACE_DESCR,
> +			  "device %d interface %d isn't a video streaming 
interface\n",
> +			  dev->udev->devnum,
> +			  intf->altsetting[0].desc.bInterfaceNumber);
>  		return -EINVAL;
>  	}
> 
>  	if (usb_driver_claim_interface(&uvc_driver.driver, intf, dev)) {
> -		uvc_trace(UVC_TRACE_DESCR, "device %d interface %d is 
already "
> -			"claimed\n", dev->udev->devnum,
> +		uvc_trace(UVC_TRACE_DESCR,
> +			  "device %d interface %d is already claimed\n",
> +			  dev->udev->devnum,
>  			intf->altsetting[0].desc.bInterfaceNumber);

The last line isn't indented correctly.

>  		return -EINVAL;
>  	}

[snip]

> @@ -693,9 +697,10 @@ static int uvc_parse_streaming(struct uvc_device *dev,
>  		break;
> 
>  	default:
> -		uvc_trace(UVC_TRACE_DESCR, "device %d videostreaming 
interface "
> -			"%d HEADER descriptor not found.\n", dev->udev-
>devnum,
> -			alts->desc.bInterfaceNumber);
> +		uvc_trace(UVC_TRACE_DESCR,
> +			  "device %d videostreaming interface %d HEADER 
descriptor not
> found.\n",
> +			  dev->udev->devnum,
> +			  alts->desc.bInterfaceNumber);

The last two arguments fit on a single line.

>  		goto error;
>  	}
> 

[snip]

> @@ -988,9 +994,10 @@ static int uvc_parse_standard_control(struct uvc_device
> *dev, n = buflen >= 12 ? buffer[11] : 0;
> 
>  		if (buflen < 12 + n) {
> -			uvc_trace(UVC_TRACE_DESCR, "device %d videocontrol 
"
> -				"interface %d HEADER error\n", udev-
>devnum,
> -				alts->desc.bInterfaceNumber);
> +			uvc_trace(UVC_TRACE_DESCR,
> +				  "device %d videocontrol interface %d 
HEADER error\n",
> +				  udev->devnum,
> +				  alts->desc.bInterfaceNumber);

Same here.

>  			return -EINVAL;
>  		}
> 
> @@ -1001,8 +1008,8 @@ static int uvc_parse_standard_control(struct
> uvc_device *dev, for (i = 0; i < n; ++i) {
>  			intf = usb_ifnum_to_if(udev, buffer[12+i]);
>  			if (intf == NULL) {
> -				uvc_trace(UVC_TRACE_DESCR, "device %d "
> -					"interface %d doesn't exists\n",
> +				uvc_trace(UVC_TRACE_DESCR,
> +					  "device %d interface %d doesn't 
exists\n",
>  					udev->devnum, i);

The last line isn't indented correctly.

>  				continue;
>  			}
> @@ -1013,8 +1020,8 @@ static int uvc_parse_standard_control(struct
> uvc_device *dev,
> 
>  	case UVC_VC_INPUT_TERMINAL:
>  		if (buflen < 8) {
> -			uvc_trace(UVC_TRACE_DESCR, "device %d videocontrol 
"
> -				"interface %d INPUT_TERMINAL error\n",
> +			uvc_trace(UVC_TRACE_DESCR,
> +				  "device %d videocontrol interface %d 
INPUT_TERMINAL error\n",
>  				udev->devnum, alts-
>desc.bInterfaceNumber);

Same here.

>  			return -EINVAL;
>  		}
> @@ -1024,11 +1031,11 @@ static int uvc_parse_standard_control(struct
> uvc_device *dev, */
>  		type = get_unaligned_le16(&buffer[4]);
>  		if ((type & 0xff00) == 0) {
> -			uvc_trace(UVC_TRACE_DESCR, "device %d videocontrol 
"
> -				"interface %d INPUT_TERMINAL %d has 
invalid "
> -				"type 0x%04x, skipping\n", udev->devnum,
> -				alts->desc.bInterfaceNumber,
> -				buffer[3], type);
> +			uvc_trace(UVC_TRACE_DESCR,
> +				  "device %d videocontrol interface %d 
INPUT_TERMINAL %d has invalid
> type 0x%04x, skipping\n",
> +				  udev->devnum,
> +				  alts->desc.bInterfaceNumber,

The above two arguments fit on a single line.

> +				  buffer[3], type);
>  			return 0;
>  		}
> 
> @@ -1047,8 +1054,8 @@ static int uvc_parse_standard_control(struct
> uvc_device *dev, }
> 
>  		if (buflen < len + n + p) {
> -			uvc_trace(UVC_TRACE_DESCR, "device %d videocontrol 
"
> -				"interface %d INPUT_TERMINAL error\n",
> +			uvc_trace(UVC_TRACE_DESCR,
> +				  "device %d videocontrol interface %d 
INPUT_TERMINAL error\n",
>  				udev->devnum, alts-
>desc.bInterfaceNumber);

The last line isn't indented correctly.

>  			return -EINVAL;
>  		}

[snip]

> @@ -1105,10 +1112,10 @@ static int uvc_parse_standard_control(struct
> uvc_device *dev, */
>  		type = get_unaligned_le16(&buffer[4]);
>  		if ((type & 0xff00) == 0) {
> -			uvc_trace(UVC_TRACE_DESCR, "device %d videocontrol 
"
> -				"interface %d OUTPUT_TERMINAL %d has 
invalid "
> -				"type 0x%04x, skipping\n", udev->devnum,
> -				alts->desc.bInterfaceNumber, buffer[3], 
type);
> +			uvc_trace(UVC_TRACE_DESCR,
> +				  "device %d videocontrol interface %d 
OUTPUT_TERMINAL %d has invalid
> type 0x%04x, skipping\n",
> +				  udev->devnum,
> +				  alts->desc.bInterfaceNumber, buffer[3], 
type);

It would be more logical two group udev->devnum and alts-
>desc.bInterfaceNumber on one line and buffer[3] and type on a second line.

>  			return 0;
>  		}
> 
> @@ -1132,9 +1139,9 @@ static int uvc_parse_standard_control(struct
> uvc_device *dev, p = buflen >= 5 ? buffer[4] : 0;
> 
>  		if (buflen < 5 || buflen < 6 + p) {
> -			uvc_trace(UVC_TRACE_DESCR, "device %d videocontrol 
"
> -				"interface %d SELECTOR_UNIT error\n",
> -				udev->devnum, alts-
>desc.bInterfaceNumber);
> +			uvc_trace(UVC_TRACE_DESCR,
> +				  "device %d videocontrol interface %d 
SELECTOR_UNIT error\n",
> +				  udev->devnum, alts-
>desc.bInterfaceNumber);

The last line isn't indented correctly.

>  			return -EINVAL;
>  		}
> 

[snip]

> @@ -1515,8 +1527,9 @@ static int uvc_scan_chain_backward(struct
> uvc_video_chain *chain,
> 
>  	entity = uvc_entity_by_id(chain->dev, id);
>  	if (entity == NULL) {
> -		uvc_trace(UVC_TRACE_DESCR, "Found reference to "
> -			"unknown entity %d.\n", id);
> +		uvc_trace(UVC_TRACE_DESCR,
> +			  "Found reference to unknown entity %d.\n",
> +			  id);

id can fit on the same line as the format string.

>  		return -EINVAL;
>  	}
> 

[snip]

> @@ -1854,8 +1869,9 @@ static int uvc_register_chains(struct uvc_device *dev)
> #ifdef CONFIG_MEDIA_CONTROLLER
>  		ret = uvc_mc_register_entities(chain);
>  		if (ret < 0) {
> -			uvc_printk(KERN_INFO, "Failed to register entites "
> -				"(%d).\n", ret);
> +			uvc_printk(KERN_INFO,
> +				   "Failed to register entites (%d).\n",
> +				   ret);

ret can fit on the same line as the format string.

>  		}
>  #endif
>  	}
> @@ -1875,9 +1891,10 @@ static int uvc_probe(struct usb_interface *intf,
>  	int ret;
> 
>  	if (id->idVendor && id->idProduct)
> -		uvc_trace(UVC_TRACE_PROBE, "Probing known UVC device %s "
> -				"(%04x:%04x)\n", udev->devpath, id-
>idVendor,
> -				id->idProduct);
> +		uvc_trace(UVC_TRACE_PROBE,
> +			  "Probing known UVC device %s (%04x:%04x)\n",
> +			  udev->devpath, id->idVendor,
> +			  id->idProduct);

The three arguments can fit in a single line.

>  	else
>  		uvc_trace(UVC_TRACE_PROBE, "Probing generic UVC device 
%s\n",
>  				udev->devpath);

[snip]

> diff --git a/drivers/media/usb/uvc/uvc_video.c
> b/drivers/media/usb/uvc/uvc_video.c index b5589d5f5da4..9202469af85d 100644
> --- a/drivers/media/usb/uvc/uvc_video.c
> +++ b/drivers/media/usb/uvc/uvc_video.c
> @@ -77,8 +77,9 @@ int uvc_query_ctrl(struct uvc_device *dev, __u8 query,
> __u8 unit, ret = __uvc_query_ctrl(dev, query, unit, intfnum, cs, data,
> size, UVC_CTRL_CONTROL_TIMEOUT);
>  	if (ret != size) {
> -		uvc_printk(KERN_ERR, "Failed to query (%s) UVC control %u on 
"
> -			"unit %u: %d (exp. %u).\n", uvc_query_name(query), 
cs,
> +		uvc_printk(KERN_ERR,
> +			   "Failed to query (%s) UVC control %u on unit %u: 
%d (exp. %u).\n",
> +			   uvc_query_name(query), cs,
>  			unit, ret, size);

All the arguments after the format string can fit on a single line.

>  		return -EIO;
>  	}

[snip]

> @@ -200,15 +200,15 @@ static int uvc_get_video_ctrl(struct uvc_streaming
> *stream, * video probe control. Warn once and return, the caller will
>  		 * fall back to GET_CUR.
>  		 */
> -		uvc_warn_once(stream->dev, UVC_WARN_PROBE_DEF, "UVC non "
> -			"compliance - GET_DEF(PROBE) not supported. "
> -			"Enabling workaround.\n");
> +		uvc_warn_once(stream->dev, UVC_WARN_PROBE_DEF,
> +			      "UVC non compliance - GET_DEF(PROBE) not 
supported. Enabling
> workaround.\n"); ret = -EIO;
>  		goto out;
>  	} else if (ret != size) {
> -		uvc_printk(KERN_ERR, "Failed to query (%u) UVC %s control : 
"
> -			"%d (exp. %u).\n", query, probe ? "probe" : 
"commit",
> -			ret, size);
> +		uvc_printk(KERN_ERR,
> +			   "Failed to query (%u) UVC %s control : %d (exp. 
%u).\n",
> +			   query, probe ? "probe" : "commit",
> +			   ret, size);

All the arguments after the format string can fit on a single line.

>  		ret = -EIO;
>  		goto out;
>  	}
> @@ -287,8 +287,9 @@ static int uvc_set_video_ctrl(struct uvc_streaming
> *stream, probe ? UVC_VS_PROBE_CONTROL : UVC_VS_COMMIT_CONTROL, data,
>  		size, uvc_timeout_param);
>  	if (ret != size) {
> -		uvc_printk(KERN_ERR, "Failed to set UVC %s control : "
> -			"%d (exp. %u).\n", probe ? "probe" : "commit",
> +		uvc_printk(KERN_ERR,
> +			   "Failed to set UVC %s control : %d (exp. %u).
\n",
> +			   probe ? "probe" : "commit",
>  			ret, size);

Same here.

>  		ret = -EIO;
>  	}

[snip]

-- 
Regards,

Laurent Pinchart

