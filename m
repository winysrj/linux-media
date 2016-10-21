Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:55132
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932247AbcJUKNv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Oct 2016 06:13:51 -0400
Date: Fri, 21 Oct 2016 08:13:42 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Re: [PATCH v2 48/58] uvc: don't break long lines
Message-ID: <20161021081342.61bb11c8@vento.lan>
In-Reply-To: <13552516.PS8MEv7nnO@avalon>
References: <cover.1476822924.git.mchehab@s-opensource.com>
        <74854af1c3eaafda607285d55f98b4520ce3d21e.1476822925.git.mchehab@s-opensource.com>
        <13552516.PS8MEv7nnO@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 20 Oct 2016 14:06:39 +0300
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> Thank you for the patch.

Thanks for review.

> > +		uvc_warn_once(stream->dev, UVC_WARN_PROBE_DEF,
> > +			      "UVC non compliance - GET_DEF(PROBE) not   
> supported. Enabling
> > workaround.\n"); ret = -EIO;


Please fix your emailer, as it is word-wrapping long lines, making
really difficult to distinguish your comments from the patch itself.

It follows the patch with your comments addressed.

Thanks,
Mauro

-

[PATCH] uvc: don't break long lines

Due to the 80-cols restrictions, and latter due to checkpatch
warnings, several strings were broken into multiple lines. This
is not considered a good practice anymore, as it makes harder
to grep for strings at the source code.

As we're right now fixing other drivers due to KERN_CONT, we need
to be able to identify what printk strings don't end with a "\n".
It is a way easier to detect those if we don't break long lines.

So, join those continuation lines.

The patch was generated via the script below, and manually
adjusted if needed.

</script>
use Text::Tabs;
while (<>) {
	if ($next ne "") {
		$c=$_;
		if ($c =~ /^\s+\"(.*)/) {
			$c2=$1;
			$next =~ s/\"\n$//;
			$n = expand($next);
			$funpos = index($n, '(');
			$pos = index($c2, '",');
			if ($funpos && $pos > 0) {
				$s1 = substr $c2, 0, $pos + 2;
				$s2 = ' ' x ($funpos + 1) . substr $c2, $pos + 2;
				$s2 =~ s/^\s+//;

				$s2 = ' ' x ($funpos + 1) . $s2 if ($s2 ne "");

				print unexpand("$next$s1\n");
				print unexpand("$s2\n") if ($s2 ne "");
			} else {
				print "$next$c2\n";
			}
			$next="";
			next;
		} else {
			print $next;
		}
		$next="";
	} else {
		if (m/\"$/) {
			if (!m/\\n\"$/) {
				$next=$_;
				next;
			}
		}
	}
	print $_;
}
</script>

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index c2ee6e39fd0c..f3c7acfed635 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -960,8 +960,7 @@ static int uvc_ctrl_populate_cache(struct uvc_video_chain *chain,
 			 * resolution value to zero.
 			 */
 			uvc_warn_once(chain->dev, UVC_WARN_XU_GET_RES,
-				      "UVC non compliance - GET_RES failed on "
-				      "an XU control. Enabling workaround.\n");
+				      "UVC non compliance - GET_RES failed on an XU control. Enabling workaround.\n");
 			memset(uvc_ctrl_data(ctrl, UVC_CTRL_DATA_RES), 0,
 			       ctrl->info.size);
 		}
@@ -1680,8 +1679,8 @@ static int uvc_ctrl_fill_xu_info(struct uvc_device *dev,
 
 	uvc_ctrl_fixup_xu_info(dev, ctrl, info);
 
-	uvc_trace(UVC_TRACE_CONTROL, "XU control %pUl/%u queried: len %u, "
-		  "flags { get %u set %u auto %u }.\n",
+	uvc_trace(UVC_TRACE_CONTROL,
+		  "XU control %pUl/%u queried: len %u, flags { get %u set %u auto %u }.\n",
 		  info->entity, info->selector, info->size,
 		  (info->flags & UVC_CTRL_FLAG_GET_CUR) ? 1 : 0,
 		  (info->flags & UVC_CTRL_FLAG_SET_CUR) ? 1 : 0,
@@ -1710,9 +1709,10 @@ static int uvc_ctrl_init_xu_ctrl(struct uvc_device *dev,
 
 	ret = uvc_ctrl_add_info(dev, ctrl, &info);
 	if (ret < 0)
-		uvc_trace(UVC_TRACE_CONTROL, "Failed to initialize control "
-			  "%pUl/%u on device %s entity %u\n", info.entity,
-			  info.selector, dev->udev->devpath, ctrl->entity->id);
+		uvc_trace(UVC_TRACE_CONTROL,
+			  "Failed to initialize control %pUl/%u on device %s entity %u\n",
+			  info.entity, info.selector, dev->udev->devpath,
+			  ctrl->entity->id);
 
 	return ret;
 }
@@ -1904,9 +1904,10 @@ static int uvc_ctrl_add_info(struct uvc_device *dev, struct uvc_control *ctrl,
 
 	ctrl->initialized = 1;
 
-	uvc_trace(UVC_TRACE_CONTROL, "Added control %pUl/%u to device %s "
-		"entity %u\n", ctrl->info.entity, ctrl->info.selector,
-		dev->udev->devpath, ctrl->entity->id);
+	uvc_trace(UVC_TRACE_CONTROL,
+		  "Added control %pUl/%u to device %s entity %u\n",
+		  ctrl->info.entity, ctrl->info.selector,
+		  dev->udev->devpath, ctrl->entity->id);
 
 done:
 	if (ret < 0)
@@ -1964,9 +1965,9 @@ int uvc_ctrl_add_mapping(struct uvc_video_chain *chain,
 	int ret;
 
 	if (mapping->id & ~V4L2_CTRL_ID_MASK) {
-		uvc_trace(UVC_TRACE_CONTROL, "Can't add mapping '%s', control "
-			"id 0x%08x is invalid.\n", mapping->name,
-			mapping->id);
+		uvc_trace(UVC_TRACE_CONTROL,
+			  "Can't add mapping '%s', control id 0x%08x is invalid.\n",
+			  mapping->name, mapping->id);
 		return -EINVAL;
 	}
 
@@ -2004,9 +2005,9 @@ int uvc_ctrl_add_mapping(struct uvc_video_chain *chain,
 
 	list_for_each_entry(map, &ctrl->info.mappings, list) {
 		if (mapping->id == map->id) {
-			uvc_trace(UVC_TRACE_CONTROL, "Can't add mapping '%s', "
-				"control id 0x%08x already exists.\n",
-				mapping->name, mapping->id);
+			uvc_trace(UVC_TRACE_CONTROL,
+				  "Can't add mapping '%s', control id 0x%08x already exists.\n",
+				  mapping->name, mapping->id);
 			ret = -EEXIST;
 			goto done;
 		}
@@ -2015,9 +2016,9 @@ int uvc_ctrl_add_mapping(struct uvc_video_chain *chain,
 	/* Prevent excess memory consumption */
 	if (atomic_inc_return(&dev->nmappings) > UVC_MAX_CONTROL_MAPPINGS) {
 		atomic_dec(&dev->nmappings);
-		uvc_trace(UVC_TRACE_CONTROL, "Can't add mapping '%s', maximum "
-			"mappings count (%u) exceeded.\n", mapping->name,
-			UVC_MAX_CONTROL_MAPPINGS);
+		uvc_trace(UVC_TRACE_CONTROL,
+			  "Can't add mapping '%s', maximum mappings count (%u) exceeded.\n",
+			  mapping->name, UVC_MAX_CONTROL_MAPPINGS);
 		ret = -ENOMEM;
 		goto done;
 	}
@@ -2086,8 +2087,9 @@ static void uvc_ctrl_prune_entity(struct uvc_device *dev,
 		    !uvc_test_bit(controls, blacklist[i].index))
 			continue;
 
-		uvc_trace(UVC_TRACE_CONTROL, "%u/%u control is black listed, "
-			"removing it.\n", entity->id, blacklist[i].index);
+		uvc_trace(UVC_TRACE_CONTROL,
+			  "%u/%u control is black listed, removing it.\n",
+			  entity->id, blacklist[i].index);
 
 		uvc_clear_bit(controls, blacklist[i].index);
 	}
diff --git a/drivers/media/usb/uvc/uvc_debugfs.c b/drivers/media/usb/uvc/uvc_debugfs.c
index 14561a5abb79..b3e54df4302d 100644
--- a/drivers/media/usb/uvc/uvc_debugfs.c
+++ b/drivers/media/usb/uvc/uvc_debugfs.c
@@ -88,8 +88,9 @@ int uvc_debugfs_init_stream(struct uvc_streaming *stream)
 
 	dent = debugfs_create_dir(dir_name, uvc_debugfs_root_dir);
 	if (IS_ERR_OR_NULL(dent)) {
-		uvc_printk(KERN_INFO, "Unable to create debugfs %s "
-			   "directory.\n", dir_name);
+		uvc_printk(KERN_INFO,
+			   "Unable to create debugfs %s directory.\n",
+			   dir_name);
 		return -ENODEV;
 	}
 
diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 9c4b56b4a9c6..62240f66a2bc 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -370,10 +370,10 @@ static int uvc_parse_format(struct uvc_device *dev,
 	case UVC_VS_FORMAT_FRAME_BASED:
 		n = buffer[2] == UVC_VS_FORMAT_UNCOMPRESSED ? 27 : 28;
 		if (buflen < n) {
-			uvc_trace(UVC_TRACE_DESCR, "device %d videostreaming "
-			       "interface %d FORMAT error\n",
-			       dev->udev->devnum,
-			       alts->desc.bInterfaceNumber);
+			uvc_trace(UVC_TRACE_DESCR,
+				  "device %d videostreaming interface %d FORMAT error\n",
+				  dev->udev->devnum,
+				  alts->desc.bInterfaceNumber);
 			return -EINVAL;
 		}
 
@@ -418,10 +418,10 @@ static int uvc_parse_format(struct uvc_device *dev,
 
 	case UVC_VS_FORMAT_MJPEG:
 		if (buflen < 11) {
-			uvc_trace(UVC_TRACE_DESCR, "device %d videostreaming "
-			       "interface %d FORMAT error\n",
-			       dev->udev->devnum,
-			       alts->desc.bInterfaceNumber);
+			uvc_trace(UVC_TRACE_DESCR,
+				  "device %d videostreaming interface %d FORMAT error\n",
+				  dev->udev->devnum,
+				  alts->desc.bInterfaceNumber);
 			return -EINVAL;
 		}
 
@@ -434,10 +434,10 @@ static int uvc_parse_format(struct uvc_device *dev,
 
 	case UVC_VS_FORMAT_DV:
 		if (buflen < 9) {
-			uvc_trace(UVC_TRACE_DESCR, "device %d videostreaming "
-			       "interface %d FORMAT error\n",
-			       dev->udev->devnum,
-			       alts->desc.bInterfaceNumber);
+			uvc_trace(UVC_TRACE_DESCR,
+				  "device %d videostreaming interface %d FORMAT error\n",
+				  dev->udev->devnum,
+				  alts->desc.bInterfaceNumber);
 			return -EINVAL;
 		}
 
@@ -452,10 +452,10 @@ static int uvc_parse_format(struct uvc_device *dev,
 			strlcpy(format->name, "HD-DV", sizeof format->name);
 			break;
 		default:
-			uvc_trace(UVC_TRACE_DESCR, "device %d videostreaming "
-			       "interface %d: unknown DV format %u\n",
-			       dev->udev->devnum,
-			       alts->desc.bInterfaceNumber, buffer[8]);
+			uvc_trace(UVC_TRACE_DESCR,
+				  "device %d videostreaming interface %d: unknown DV format %u\n",
+				  dev->udev->devnum,
+				  alts->desc.bInterfaceNumber, buffer[8]);
 			return -EINVAL;
 		}
 
@@ -481,10 +481,10 @@ static int uvc_parse_format(struct uvc_device *dev,
 	case UVC_VS_FORMAT_STREAM_BASED:
 		/* Not supported yet. */
 	default:
-		uvc_trace(UVC_TRACE_DESCR, "device %d videostreaming "
-		       "interface %d unsupported format %u\n",
-		       dev->udev->devnum, alts->desc.bInterfaceNumber,
-		       buffer[2]);
+		uvc_trace(UVC_TRACE_DESCR,
+			  "device %d videostreaming interface %d unsupported format %u\n",
+			  dev->udev->devnum, alts->desc.bInterfaceNumber,
+			  buffer[2]);
 		return -EINVAL;
 	}
 
@@ -507,9 +507,10 @@ static int uvc_parse_format(struct uvc_device *dev,
 		n = n ? n : 3;
 
 		if (buflen < 26 + 4*n) {
-			uvc_trace(UVC_TRACE_DESCR, "device %d videostreaming "
-			       "interface %d FRAME error\n", dev->udev->devnum,
-			       alts->desc.bInterfaceNumber);
+			uvc_trace(UVC_TRACE_DESCR,
+				  "device %d videostreaming interface %d FRAME error\n",
+				  dev->udev->devnum,
+				  alts->desc.bInterfaceNumber);
 			return -EINVAL;
 		}
 
@@ -590,10 +591,10 @@ static int uvc_parse_format(struct uvc_device *dev,
 	if (buflen > 2 && buffer[1] == USB_DT_CS_INTERFACE &&
 	    buffer[2] == UVC_VS_COLORFORMAT) {
 		if (buflen < 6) {
-			uvc_trace(UVC_TRACE_DESCR, "device %d videostreaming "
-			       "interface %d COLORFORMAT error\n",
-			       dev->udev->devnum,
-			       alts->desc.bInterfaceNumber);
+			uvc_trace(UVC_TRACE_DESCR,
+				  "device %d videostreaming interface %d COLORFORMAT error\n",
+				  dev->udev->devnum,
+				  alts->desc.bInterfaceNumber);
 			return -EINVAL;
 		}
 
@@ -623,16 +624,18 @@ static int uvc_parse_streaming(struct uvc_device *dev,
 
 	if (intf->cur_altsetting->desc.bInterfaceSubClass
 		!= UVC_SC_VIDEOSTREAMING) {
-		uvc_trace(UVC_TRACE_DESCR, "device %d interface %d isn't a "
-			"video streaming interface\n", dev->udev->devnum,
-			intf->altsetting[0].desc.bInterfaceNumber);
+		uvc_trace(UVC_TRACE_DESCR,
+			  "device %d interface %d isn't a video streaming interface\n",
+			  dev->udev->devnum,
+			  intf->altsetting[0].desc.bInterfaceNumber);
 		return -EINVAL;
 	}
 
 	if (usb_driver_claim_interface(&uvc_driver.driver, intf, dev)) {
-		uvc_trace(UVC_TRACE_DESCR, "device %d interface %d is already "
-			"claimed\n", dev->udev->devnum,
-			intf->altsetting[0].desc.bInterfaceNumber);
+		uvc_trace(UVC_TRACE_DESCR,
+			  "device %d interface %d is already claimed\n",
+			  dev->udev->devnum,
+			  intf->altsetting[0].desc.bInterfaceNumber);
 		return -EINVAL;
 	}
 
@@ -659,8 +662,9 @@ static int uvc_parse_streaming(struct uvc_device *dev,
 
 			if (ep->extralen > 2 &&
 			    ep->extra[1] == USB_DT_CS_INTERFACE) {
-				uvc_trace(UVC_TRACE_DESCR, "trying extra data "
-					"from endpoint %u.\n", i);
+				uvc_trace(UVC_TRACE_DESCR,
+					  "trying extra data from endpoint %u.\n",
+					  i);
 				buffer = alts->endpoint[i].extra;
 				buflen = alts->endpoint[i].extralen;
 				break;
@@ -675,8 +679,8 @@ static int uvc_parse_streaming(struct uvc_device *dev,
 	}
 
 	if (buflen <= 2) {
-		uvc_trace(UVC_TRACE_DESCR, "no class-specific streaming "
-			"interface descriptors found.\n");
+		uvc_trace(UVC_TRACE_DESCR,
+			  "no class-specific streaming interface descriptors found.\n");
 		goto error;
 	}
 
@@ -693,9 +697,9 @@ static int uvc_parse_streaming(struct uvc_device *dev,
 		break;
 
 	default:
-		uvc_trace(UVC_TRACE_DESCR, "device %d videostreaming interface "
-			"%d HEADER descriptor not found.\n", dev->udev->devnum,
-			alts->desc.bInterfaceNumber);
+		uvc_trace(UVC_TRACE_DESCR,
+			  "device %d videostreaming interface %d HEADER descriptor not found.\n",
+			  dev->udev->devnum, alts->desc.bInterfaceNumber);
 		goto error;
 	}
 
@@ -703,9 +707,9 @@ static int uvc_parse_streaming(struct uvc_device *dev,
 	n = buflen >= size ? buffer[size-1] : 0;
 
 	if (buflen < size + p*n) {
-		uvc_trace(UVC_TRACE_DESCR, "device %d videostreaming "
-			"interface %d HEADER descriptor is invalid.\n",
-			dev->udev->devnum, alts->desc.bInterfaceNumber);
+		uvc_trace(UVC_TRACE_DESCR,
+			  "device %d videostreaming interface %d HEADER descriptor is invalid.\n",
+			  dev->udev->devnum, alts->desc.bInterfaceNumber);
 		goto error;
 	}
 
@@ -755,10 +759,10 @@ static int uvc_parse_streaming(struct uvc_device *dev,
 
 		case UVC_VS_FORMAT_MPEG2TS:
 		case UVC_VS_FORMAT_STREAM_BASED:
-			uvc_trace(UVC_TRACE_DESCR, "device %d videostreaming "
-				"interface %d FORMAT %u is not supported.\n",
-				dev->udev->devnum,
-				alts->desc.bInterfaceNumber, _buffer[2]);
+			uvc_trace(UVC_TRACE_DESCR,
+				  "device %d videostreaming interface %d FORMAT %u is not supported.\n",
+				  dev->udev->devnum,
+				  alts->desc.bInterfaceNumber, _buffer[2]);
 			break;
 
 		case UVC_VS_FRAME_UNCOMPRESSED:
@@ -780,9 +784,9 @@ static int uvc_parse_streaming(struct uvc_device *dev,
 	}
 
 	if (nformats == 0) {
-		uvc_trace(UVC_TRACE_DESCR, "device %d videostreaming interface "
-			"%d has no supported formats defined.\n",
-			dev->udev->devnum, alts->desc.bInterfaceNumber);
+		uvc_trace(UVC_TRACE_DESCR,
+			  "device %d videostreaming interface %d has no supported formats defined.\n",
+			  dev->udev->devnum, alts->desc.bInterfaceNumber);
 		goto error;
 	}
 
@@ -829,9 +833,10 @@ static int uvc_parse_streaming(struct uvc_device *dev,
 	}
 
 	if (buflen)
-		uvc_trace(UVC_TRACE_DESCR, "device %d videostreaming interface "
-			"%d has %u bytes of trailing descriptor garbage.\n",
-			dev->udev->devnum, alts->desc.bInterfaceNumber, buflen);
+		uvc_trace(UVC_TRACE_DESCR,
+			  "device %d videostreaming interface %d has %u bytes of trailing descriptor garbage.\n",
+			  dev->udev->devnum, alts->desc.bInterfaceNumber,
+			  buflen);
 
 	/* Parse the alternate settings to find the maximum bandwidth. */
 	for (i = 0; i < intf->num_altsetting; ++i) {
@@ -939,9 +944,9 @@ static int uvc_parse_vendor_control(struct uvc_device *dev,
 		n = buflen >= 25 + p ? buffer[22+p] : 0;
 
 		if (buflen < 25 + p + 2*n) {
-			uvc_trace(UVC_TRACE_DESCR, "device %d videocontrol "
-				"interface %d EXTENSION_UNIT error\n",
-				udev->devnum, alts->desc.bInterfaceNumber);
+			uvc_trace(UVC_TRACE_DESCR,
+				  "device %d videocontrol interface %d EXTENSION_UNIT error\n",
+				  udev->devnum, alts->desc.bInterfaceNumber);
 			break;
 		}
 
@@ -988,9 +993,9 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 		n = buflen >= 12 ? buffer[11] : 0;
 
 		if (buflen < 12 + n) {
-			uvc_trace(UVC_TRACE_DESCR, "device %d videocontrol "
-				"interface %d HEADER error\n", udev->devnum,
-				alts->desc.bInterfaceNumber);
+			uvc_trace(UVC_TRACE_DESCR,
+				  "device %d videocontrol interface %d HEADER error\n",
+				  udev->devnum, alts->desc.bInterfaceNumber);
 			return -EINVAL;
 		}
 
@@ -1001,9 +1006,9 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 		for (i = 0; i < n; ++i) {
 			intf = usb_ifnum_to_if(udev, buffer[12+i]);
 			if (intf == NULL) {
-				uvc_trace(UVC_TRACE_DESCR, "device %d "
-					"interface %d doesn't exists\n",
-					udev->devnum, i);
+				uvc_trace(UVC_TRACE_DESCR,
+					  "device %d interface %d doesn't exists\n",
+					  udev->devnum, i);
 				continue;
 			}
 
@@ -1013,9 +1018,9 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 
 	case UVC_VC_INPUT_TERMINAL:
 		if (buflen < 8) {
-			uvc_trace(UVC_TRACE_DESCR, "device %d videocontrol "
-				"interface %d INPUT_TERMINAL error\n",
-				udev->devnum, alts->desc.bInterfaceNumber);
+			uvc_trace(UVC_TRACE_DESCR,
+				  "device %d videocontrol interface %d INPUT_TERMINAL error\n",
+				  udev->devnum, alts->desc.bInterfaceNumber);
 			return -EINVAL;
 		}
 
@@ -1024,11 +1029,10 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 		 */
 		type = get_unaligned_le16(&buffer[4]);
 		if ((type & 0xff00) == 0) {
-			uvc_trace(UVC_TRACE_DESCR, "device %d videocontrol "
-				"interface %d INPUT_TERMINAL %d has invalid "
-				"type 0x%04x, skipping\n", udev->devnum,
-				alts->desc.bInterfaceNumber,
-				buffer[3], type);
+			uvc_trace(UVC_TRACE_DESCR,
+				  "device %d videocontrol interface %d INPUT_TERMINAL %d has invalid type 0x%04x, skipping\n",
+				  udev->devnum, alts->desc.bInterfaceNumber,
+				  buffer[3], type);
 			return 0;
 		}
 
@@ -1047,9 +1051,9 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 		}
 
 		if (buflen < len + n + p) {
-			uvc_trace(UVC_TRACE_DESCR, "device %d videocontrol "
-				"interface %d INPUT_TERMINAL error\n",
-				udev->devnum, alts->desc.bInterfaceNumber);
+			uvc_trace(UVC_TRACE_DESCR,
+				  "device %d videocontrol interface %d INPUT_TERMINAL error\n",
+				  udev->devnum, alts->desc.bInterfaceNumber);
 			return -EINVAL;
 		}
 
@@ -1094,9 +1098,9 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 
 	case UVC_VC_OUTPUT_TERMINAL:
 		if (buflen < 9) {
-			uvc_trace(UVC_TRACE_DESCR, "device %d videocontrol "
-				"interface %d OUTPUT_TERMINAL error\n",
-				udev->devnum, alts->desc.bInterfaceNumber);
+			uvc_trace(UVC_TRACE_DESCR,
+				  "device %d videocontrol interface %d OUTPUT_TERMINAL error\n",
+				  udev->devnum, alts->desc.bInterfaceNumber);
 			return -EINVAL;
 		}
 
@@ -1105,10 +1109,10 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 		 */
 		type = get_unaligned_le16(&buffer[4]);
 		if ((type & 0xff00) == 0) {
-			uvc_trace(UVC_TRACE_DESCR, "device %d videocontrol "
-				"interface %d OUTPUT_TERMINAL %d has invalid "
-				"type 0x%04x, skipping\n", udev->devnum,
-				alts->desc.bInterfaceNumber, buffer[3], type);
+			uvc_trace(UVC_TRACE_DESCR,
+				  "device %d videocontrol interface %d OUTPUT_TERMINAL %d has invalid type 0x%04x, skipping\n",
+				  udev->devnum, alts->desc.bInterfaceNumber,
+				  buffer[3], type);
 			return 0;
 		}
 
@@ -1132,9 +1136,9 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 		p = buflen >= 5 ? buffer[4] : 0;
 
 		if (buflen < 5 || buflen < 6 + p) {
-			uvc_trace(UVC_TRACE_DESCR, "device %d videocontrol "
-				"interface %d SELECTOR_UNIT error\n",
-				udev->devnum, alts->desc.bInterfaceNumber);
+			uvc_trace(UVC_TRACE_DESCR,
+				  "device %d videocontrol interface %d SELECTOR_UNIT error\n",
+				  udev->devnum, alts->desc.bInterfaceNumber);
 			return -EINVAL;
 		}
 
@@ -1158,9 +1162,9 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 		p = dev->uvc_version >= 0x0110 ? 10 : 9;
 
 		if (buflen < p + n) {
-			uvc_trace(UVC_TRACE_DESCR, "device %d videocontrol "
-				"interface %d PROCESSING_UNIT error\n",
-				udev->devnum, alts->desc.bInterfaceNumber);
+			uvc_trace(UVC_TRACE_DESCR,
+				  "device %d videocontrol interface %d PROCESSING_UNIT error\n",
+				  udev->devnum, alts->desc.bInterfaceNumber);
 			return -EINVAL;
 		}
 
@@ -1191,9 +1195,9 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 		n = buflen >= 24 + p ? buffer[22+p] : 0;
 
 		if (buflen < 24 + p + n) {
-			uvc_trace(UVC_TRACE_DESCR, "device %d videocontrol "
-				"interface %d EXTENSION_UNIT error\n",
-				udev->devnum, alts->desc.bInterfaceNumber);
+			uvc_trace(UVC_TRACE_DESCR,
+				  "device %d videocontrol interface %d EXTENSION_UNIT error\n",
+				  udev->devnum, alts->desc.bInterfaceNumber);
 			return -EINVAL;
 		}
 
@@ -1218,8 +1222,9 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 		break;
 
 	default:
-		uvc_trace(UVC_TRACE_DESCR, "Found an unknown CS_INTERFACE "
-			"descriptor (%u)\n", buffer[2]);
+		uvc_trace(UVC_TRACE_DESCR,
+			  "Found an unknown CS_INTERFACE descriptor (%u)\n",
+			  buffer[2]);
 		break;
 	}
 
@@ -1264,8 +1269,9 @@ static int uvc_parse_control(struct uvc_device *dev)
 		if (usb_endpoint_is_int_in(desc) &&
 		    le16_to_cpu(desc->wMaxPacketSize) >= 8 &&
 		    desc->bInterval != 0) {
-			uvc_trace(UVC_TRACE_DESCR, "Found a Status endpoint "
-				"(addr %02x).\n", desc->bEndpointAddress);
+			uvc_trace(UVC_TRACE_DESCR,
+				  "Found a Status endpoint (addr %02x).\n",
+				  desc->bEndpointAddress);
 			dev->int_ep = ep;
 		}
 	}
@@ -1312,8 +1318,9 @@ static int uvc_scan_chain_entity(struct uvc_video_chain *chain,
 			printk(KERN_CONT " <- XU %d", entity->id);
 
 		if (entity->bNrInPins != 1) {
-			uvc_trace(UVC_TRACE_DESCR, "Extension unit %d has more "
-				"than 1 input pin.\n", entity->id);
+			uvc_trace(UVC_TRACE_DESCR,
+				  "Extension unit %d has more than 1 input pin.\n",
+				  entity->id);
 			return -1;
 		}
 
@@ -1324,8 +1331,8 @@ static int uvc_scan_chain_entity(struct uvc_video_chain *chain,
 			printk(KERN_CONT " <- PU %d", entity->id);
 
 		if (chain->processing != NULL) {
-			uvc_trace(UVC_TRACE_DESCR, "Found multiple "
-				"Processing Units in chain.\n");
+			uvc_trace(UVC_TRACE_DESCR,
+				  "Found multiple Processing Units in chain.\n");
 			return -1;
 		}
 
@@ -1341,8 +1348,8 @@ static int uvc_scan_chain_entity(struct uvc_video_chain *chain,
 			break;
 
 		if (chain->selector != NULL) {
-			uvc_trace(UVC_TRACE_DESCR, "Found multiple Selector "
-				"Units in chain.\n");
+			uvc_trace(UVC_TRACE_DESCR,
+				  "Found multiple Selector Units in chain.\n");
 			return -1;
 		}
 
@@ -1377,8 +1384,9 @@ static int uvc_scan_chain_entity(struct uvc_video_chain *chain,
 		break;
 
 	default:
-		uvc_trace(UVC_TRACE_DESCR, "Unsupported entity type "
-			"0x%04x found in chain.\n", UVC_ENTITY_TYPE(entity));
+		uvc_trace(UVC_TRACE_DESCR,
+			  "Unsupported entity type 0x%04x found in chain.\n",
+			  UVC_ENTITY_TYPE(entity));
 		return -1;
 	}
 
@@ -1407,8 +1415,8 @@ static int uvc_scan_chain_forward(struct uvc_video_chain *chain,
 		switch (UVC_ENTITY_TYPE(forward)) {
 		case UVC_VC_EXTENSION_UNIT:
 			if (forward->bNrInPins != 1) {
-				uvc_trace(UVC_TRACE_DESCR, "Extension unit %d "
-					  "has more than 1 input pin.\n",
+				uvc_trace(UVC_TRACE_DESCR,
+					  "Extension unit %d has more than 1 input pin.\n",
 					  entity->id);
 				return -EINVAL;
 			}
@@ -1428,8 +1436,9 @@ static int uvc_scan_chain_forward(struct uvc_video_chain *chain,
 		case UVC_OTT_MEDIA_TRANSPORT_OUTPUT:
 		case UVC_TT_STREAMING:
 			if (UVC_ENTITY_IS_ITERM(forward)) {
-				uvc_trace(UVC_TRACE_DESCR, "Unsupported input "
-					"terminal %u.\n", forward->id);
+				uvc_trace(UVC_TRACE_DESCR,
+					  "Unsupported input terminal %u.\n",
+					  forward->id);
 				return -EINVAL;
 			}
 
@@ -1478,9 +1487,9 @@ static int uvc_scan_chain_backward(struct uvc_video_chain *chain,
 			id = entity->baSourceID[i];
 			term = uvc_entity_by_id(chain->dev, id);
 			if (term == NULL || !UVC_ENTITY_IS_ITERM(term)) {
-				uvc_trace(UVC_TRACE_DESCR, "Selector unit %d "
-					"input %d isn't connected to an "
-					"input terminal\n", entity->id, i);
+				uvc_trace(UVC_TRACE_DESCR,
+					  "Selector unit %d input %d isn't connected to an input terminal\n",
+					  entity->id, i);
 				return -1;
 			}
 
@@ -1515,8 +1524,8 @@ static int uvc_scan_chain_backward(struct uvc_video_chain *chain,
 
 	entity = uvc_entity_by_id(chain->dev, id);
 	if (entity == NULL) {
-		uvc_trace(UVC_TRACE_DESCR, "Found reference to "
-			"unknown entity %d.\n", id);
+		uvc_trace(UVC_TRACE_DESCR,
+			  "Found reference to unknown entity %d.\n", id);
 		return -EINVAL;
 	}
 
@@ -1537,8 +1546,9 @@ static int uvc_scan_chain(struct uvc_video_chain *chain,
 	while (entity != NULL) {
 		/* Entity must not be part of an existing chain */
 		if (entity->chain.next || entity->chain.prev) {
-			uvc_trace(UVC_TRACE_DESCR, "Found reference to "
-				"entity %d already in chain.\n", entity->id);
+			uvc_trace(UVC_TRACE_DESCR,
+				  "Found reference to entity %d already in chain.\n",
+				  entity->id);
 			return -EINVAL;
 		}
 
@@ -1766,8 +1776,8 @@ static int uvc_register_video(struct uvc_device *dev,
 	 */
 	ret = uvc_video_init(stream);
 	if (ret < 0) {
-		uvc_printk(KERN_ERR, "Failed to initialize the device "
-			"(%d).\n", ret);
+		uvc_printk(KERN_ERR, "Failed to initialize the device (%d).\n",
+			   ret);
 		return ret;
 	}
 
@@ -1825,8 +1835,9 @@ static int uvc_register_terms(struct uvc_device *dev,
 
 		stream = uvc_stream_by_id(dev, term->id);
 		if (stream == NULL) {
-			uvc_printk(KERN_INFO, "No streaming interface found "
-				   "for terminal %u.", term->id);
+			uvc_printk(KERN_INFO,
+				   "No streaming interface found for terminal %u.",
+				   term->id);
 			continue;
 		}
 
@@ -1854,8 +1865,8 @@ static int uvc_register_chains(struct uvc_device *dev)
 #ifdef CONFIG_MEDIA_CONTROLLER
 		ret = uvc_mc_register_entities(chain);
 		if (ret < 0) {
-			uvc_printk(KERN_INFO, "Failed to register entites "
-				"(%d).\n", ret);
+			uvc_printk(KERN_INFO,
+				   "Failed to register entites (%d).\n", ret);
 		}
 #endif
 	}
@@ -1875,9 +1886,9 @@ static int uvc_probe(struct usb_interface *intf,
 	int ret;
 
 	if (id->idVendor && id->idProduct)
-		uvc_trace(UVC_TRACE_PROBE, "Probing known UVC device %s "
-				"(%04x:%04x)\n", udev->devpath, id->idVendor,
-				id->idProduct);
+		uvc_trace(UVC_TRACE_PROBE,
+			  "Probing known UVC device %s (%04x:%04x)\n",
+			  udev->devpath, id->idVendor, id->idProduct);
 	else
 		uvc_trace(UVC_TRACE_PROBE, "Probing generic UVC device %s\n",
 				udev->devpath);
@@ -1909,8 +1920,8 @@ static int uvc_probe(struct usb_interface *intf,
 
 	/* Parse the Video Class control descriptor. */
 	if (uvc_parse_control(dev) < 0) {
-		uvc_trace(UVC_TRACE_PROBE, "Unable to parse UVC "
-			"descriptors.\n");
+		uvc_trace(UVC_TRACE_PROBE,
+			  "Unable to parse UVC descriptors.\n");
 		goto error;
 	}
 
@@ -1921,10 +1932,11 @@ static int uvc_probe(struct usb_interface *intf,
 		le16_to_cpu(udev->descriptor.idProduct));
 
 	if (dev->quirks != id->driver_info) {
-		uvc_printk(KERN_INFO, "Forcing device quirks to 0x%x by module "
-			"parameter for testing purpose.\n", dev->quirks);
-		uvc_printk(KERN_INFO, "Please report required quirks to the "
-			"linux-uvc-devel mailing list.\n");
+		uvc_printk(KERN_INFO,
+			   "Forcing device quirks to 0x%x by module parameter for testing purpose.\n",
+			   dev->quirks);
+		uvc_printk(KERN_INFO,
+			   "Please report required quirks to the linux-uvc-devel mailing list.\n");
 	}
 
 	/* Initialize the media device and register the V4L2 device. */
@@ -1966,9 +1978,9 @@ static int uvc_probe(struct usb_interface *intf,
 
 	/* Initialize the interrupt URB. */
 	if ((ret = uvc_status_init(dev)) < 0) {
-		uvc_printk(KERN_INFO, "Unable to initialize the status "
-			"endpoint (%d), status interrupt will not be "
-			"supported.\n", ret);
+		uvc_printk(KERN_INFO,
+			   "Unable to initialize the status endpoint (%d), status interrupt will not be supported.\n",
+			   ret);
 	}
 
 	uvc_trace(UVC_TRACE_PROBE, "UVC device initialized.\n");
@@ -2019,8 +2031,8 @@ static int uvc_suspend(struct usb_interface *intf, pm_message_t message)
 			return uvc_video_suspend(stream);
 	}
 
-	uvc_trace(UVC_TRACE_SUSPEND, "Suspend: video streaming USB interface "
-			"mismatch.\n");
+	uvc_trace(UVC_TRACE_SUSPEND,
+		  "Suspend: video streaming USB interface mismatch.\n");
 	return -EINVAL;
 }
 
@@ -2059,8 +2071,8 @@ static int __uvc_resume(struct usb_interface *intf, int reset)
 		}
 	}
 
-	uvc_trace(UVC_TRACE_SUSPEND, "Resume: video streaming USB interface "
-			"mismatch.\n");
+	uvc_trace(UVC_TRACE_SUSPEND,
+		  "Resume: video streaming USB interface mismatch.\n");
 	return -EINVAL;
 }
 
diff --git a/drivers/media/usb/uvc/uvc_entity.c b/drivers/media/usb/uvc/uvc_entity.c
index ac386bb547e6..aa9f97f0da7e 100644
--- a/drivers/media/usb/uvc/uvc_entity.c
+++ b/drivers/media/usb/uvc/uvc_entity.c
@@ -109,8 +109,9 @@ int uvc_mc_register_entities(struct uvc_video_chain *chain)
 	list_for_each_entry(entity, &chain->entities, chain) {
 		ret = uvc_mc_init_entity(chain, entity);
 		if (ret < 0) {
-			uvc_printk(KERN_INFO, "Failed to initialize entity for "
-				   "entity %u\n", entity->id);
+			uvc_printk(KERN_INFO,
+				   "Failed to initialize entity for entity %u\n",
+				   entity->id);
 			return ret;
 		}
 	}
@@ -118,8 +119,9 @@ int uvc_mc_register_entities(struct uvc_video_chain *chain)
 	list_for_each_entry(entity, &chain->entities, chain) {
 		ret = uvc_mc_create_links(chain, entity);
 		if (ret < 0) {
-			uvc_printk(KERN_INFO, "Failed to create links for "
-				   "entity %u\n", entity->id);
+			uvc_printk(KERN_INFO,
+				   "Failed to create links for entity %u\n",
+				   entity->id);
 			return ret;
 		}
 	}
diff --git a/drivers/media/usb/uvc/uvc_isight.c b/drivers/media/usb/uvc/uvc_isight.c
index 8510e7259e76..cd0c0abf279b 100644
--- a/drivers/media/usb/uvc/uvc_isight.c
+++ b/drivers/media/usb/uvc/uvc_isight.c
@@ -61,8 +61,8 @@ static int isight_decode(struct uvc_video_queue *queue, struct uvc_buffer *buf,
 	/* Synchronize to the input stream by waiting for a header packet. */
 	if (buf->state != UVC_BUF_STATE_ACTIVE) {
 		if (!is_header) {
-			uvc_trace(UVC_TRACE_FRAME, "Dropping packet (out of "
-				  "sync).\n");
+			uvc_trace(UVC_TRACE_FRAME,
+				  "Dropping packet (out of sync).\n");
 			return 0;
 		}
 
@@ -90,8 +90,8 @@ static int isight_decode(struct uvc_video_queue *queue, struct uvc_buffer *buf,
 		buf->bytesused += nbytes;
 
 		if (len > maxlen || buf->bytesused == buf->length) {
-			uvc_trace(UVC_TRACE_FRAME, "Frame complete "
-				  "(overflow).\n");
+			uvc_trace(UVC_TRACE_FRAME,
+				  "Frame complete (overflow).\n");
 			buf->state = UVC_BUF_STATE_DONE;
 		}
 	}
@@ -106,8 +106,8 @@ void uvc_video_decode_isight(struct urb *urb, struct uvc_streaming *stream,
 
 	for (i = 0; i < urb->number_of_packets; ++i) {
 		if (urb->iso_frame_desc[i].status < 0) {
-			uvc_trace(UVC_TRACE_FRAME, "USB isochronous frame "
-				  "lost (%d).\n",
+			uvc_trace(UVC_TRACE_FRAME,
+				  "USB isochronous frame lost (%d).\n",
 				  urb->iso_frame_desc[i].status);
 		}
 
diff --git a/drivers/media/usb/uvc/uvc_status.c b/drivers/media/usb/uvc/uvc_status.c
index f552ab997956..855d95071d7a 100644
--- a/drivers/media/usb/uvc/uvc_status.c
+++ b/drivers/media/usb/uvc/uvc_status.c
@@ -81,8 +81,8 @@ static void uvc_input_report_key(struct uvc_device *dev, unsigned int code,
 static void uvc_event_streaming(struct uvc_device *dev, __u8 *data, int len)
 {
 	if (len < 3) {
-		uvc_trace(UVC_TRACE_STATUS, "Invalid streaming status event "
-				"received.\n");
+		uvc_trace(UVC_TRACE_STATUS,
+			  "Invalid streaming status event received.\n");
 		return;
 	}
 
@@ -93,8 +93,9 @@ static void uvc_event_streaming(struct uvc_device *dev, __u8 *data, int len)
 			data[1], data[3] ? "pressed" : "released", len);
 		uvc_input_report_key(dev, KEY_CAMERA, data[3]);
 	} else {
-		uvc_trace(UVC_TRACE_STATUS, "Stream %u error event %02x %02x "
-			"len %d.\n", data[1], data[2], data[3], len);
+		uvc_trace(UVC_TRACE_STATUS,
+			  "Stream %u error event %02x %02x len %d.\n",
+			  data[1], data[2], data[3], len);
 	}
 }
 
@@ -103,8 +104,8 @@ static void uvc_event_control(struct uvc_device *dev, __u8 *data, int len)
 	char *attrs[3] = { "value", "info", "failure" };
 
 	if (len < 6 || data[2] != 0 || data[4] > 2) {
-		uvc_trace(UVC_TRACE_STATUS, "Invalid control status event "
-				"received.\n");
+		uvc_trace(UVC_TRACE_STATUS,
+			  "Invalid control status event received.\n");
 		return;
 	}
 
@@ -129,8 +130,9 @@ static void uvc_status_complete(struct urb *urb)
 		return;
 
 	default:
-		uvc_printk(KERN_WARNING, "Non-zero status (%d) in status "
-			"completion handler.\n", urb->status);
+		uvc_printk(KERN_WARNING,
+			   "Non-zero status (%d) in status completion handler.\n",
+			   urb->status);
 		return;
 	}
 
@@ -146,8 +148,9 @@ static void uvc_status_complete(struct urb *urb)
 			break;
 
 		default:
-			uvc_trace(UVC_TRACE_STATUS, "Unknown status event "
-				"type %u.\n", dev->status[0]);
+			uvc_trace(UVC_TRACE_STATUS,
+				  "Unknown status event type %u.\n",
+				  dev->status[0]);
 			break;
 		}
 	}
diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index 05eed4be25df..9bda8e287dab 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -85,8 +85,8 @@ static int uvc_ioctl_ctrl_map(struct uvc_video_chain *chain,
 		break;
 
 	default:
-		uvc_trace(UVC_TRACE_CONTROL, "Unsupported V4L2 control type "
-			  "%u.\n", xmap->v4l2_type);
+		uvc_trace(UVC_TRACE_CONTROL, "Unsupported V4L2 control type %u.\n",
+			  xmap->v4l2_type);
 		ret = -ENOTTY;
 		goto done;
 	}
@@ -224,9 +224,10 @@ static int uvc_v4l2_try_format(struct uvc_streaming *stream,
 
 	/* Use the default frame interval. */
 	interval = frame->dwDefaultFrameInterval;
-	uvc_trace(UVC_TRACE_FORMAT, "Using default frame interval %u.%u us "
-		"(%u.%u fps).\n", interval/10, interval%10, 10000000/interval,
-		(100000000/interval)%10);
+	uvc_trace(UVC_TRACE_FORMAT,
+		  "Using default frame interval %u.%u us (%u.%u fps).\n",
+		  interval/10, interval%10, 10000000/interval,
+		  (100000000/interval)%10);
 
 	/* Set the format index, frame index and frame interval. */
 	memset(probe, 0, sizeof *probe);
diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index b5589d5f5da4..c3894d164d62 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -77,9 +77,9 @@ int uvc_query_ctrl(struct uvc_device *dev, __u8 query, __u8 unit,
 	ret = __uvc_query_ctrl(dev, query, unit, intfnum, cs, data, size,
 				UVC_CTRL_CONTROL_TIMEOUT);
 	if (ret != size) {
-		uvc_printk(KERN_ERR, "Failed to query (%s) UVC control %u on "
-			"unit %u: %d (exp. %u).\n", uvc_query_name(query), cs,
-			unit, ret, size);
+		uvc_printk(KERN_ERR,
+			   "Failed to query (%s) UVC control %u on unit %u: %d (exp. %u).\n",
+			   uvc_query_name(query), cs, unit, ret, size);
 		return -EIO;
 	}
 
@@ -188,9 +188,8 @@ static int uvc_get_video_ctrl(struct uvc_streaming *stream,
 		 * answer a GET_MIN or GET_MAX request with the wCompQuality
 		 * field only.
 		 */
-		uvc_warn_once(stream->dev, UVC_WARN_MINMAX, "UVC non "
-			"compliance - GET_MIN/MAX(PROBE) incorrectly "
-			"supported. Enabling workaround.\n");
+		uvc_warn_once(stream->dev, UVC_WARN_MINMAX,
+			      "UVC non compliance - GET_MIN/MAX(PROBE) incorrectly supported. Enabling workaround.\n");
 		memset(ctrl, 0, sizeof *ctrl);
 		ctrl->wCompQuality = le16_to_cpup((__le16 *)data);
 		ret = 0;
@@ -200,15 +199,14 @@ static int uvc_get_video_ctrl(struct uvc_streaming *stream,
 		 * video probe control. Warn once and return, the caller will
 		 * fall back to GET_CUR.
 		 */
-		uvc_warn_once(stream->dev, UVC_WARN_PROBE_DEF, "UVC non "
-			"compliance - GET_DEF(PROBE) not supported. "
-			"Enabling workaround.\n");
+		uvc_warn_once(stream->dev, UVC_WARN_PROBE_DEF,
+			      "UVC non compliance - GET_DEF(PROBE) not supported. Enabling workaround.\n");
 		ret = -EIO;
 		goto out;
 	} else if (ret != size) {
-		uvc_printk(KERN_ERR, "Failed to query (%u) UVC %s control : "
-			"%d (exp. %u).\n", query, probe ? "probe" : "commit",
-			ret, size);
+		uvc_printk(KERN_ERR,
+			   "Failed to query (%u) UVC %s control : %d (exp. %u).\n",
+			   query, probe ? "probe" : "commit", ret, size);
 		ret = -EIO;
 		goto out;
 	}
@@ -287,9 +285,9 @@ static int uvc_set_video_ctrl(struct uvc_streaming *stream,
 		probe ? UVC_VS_PROBE_CONTROL : UVC_VS_COMMIT_CONTROL, data,
 		size, uvc_timeout_param);
 	if (ret != size) {
-		uvc_printk(KERN_ERR, "Failed to set UVC %s control : "
-			"%d (exp. %u).\n", probe ? "probe" : "commit",
-			ret, size);
+		uvc_printk(KERN_ERR,
+			   "Failed to set UVC %s control : %d (exp. %u).\n",
+			   probe ? "probe" : "commit", ret, size);
 		ret = -EIO;
 	}
 
@@ -652,8 +650,8 @@ void uvc_video_clock_update(struct uvc_streaming *stream,
 
 	sof = y;
 
-	uvc_trace(UVC_TRACE_CLOCK, "%s: PTS %u y %llu.%06llu SOF %u.%06llu "
-		  "(x1 %u x2 %u y1 %u y2 %u SOF offset %u)\n",
+	uvc_trace(UVC_TRACE_CLOCK,
+		  "%s: PTS %u y %llu.%06llu SOF %u.%06llu (x1 %u x2 %u y1 %u y2 %u SOF offset %u)\n",
 		  stream->dev->name, buf->pts,
 		  y >> 16, div_u64((y & 0xffff) * 1000000, 65536),
 		  sof >> 16, div_u64(((u64)sof & 0xffff) * 1000000LLU, 65536),
@@ -694,8 +692,8 @@ void uvc_video_clock_update(struct uvc_streaming *stream,
 		ts.tv_nsec -= NSEC_PER_SEC;
 	}
 
-	uvc_trace(UVC_TRACE_CLOCK, "%s: SOF %u.%06llu y %llu ts %llu "
-		  "buf ts %llu (x1 %u/%u/%u x2 %u/%u/%u y1 %u y2 %u)\n",
+	uvc_trace(UVC_TRACE_CLOCK,
+		  "%s: SOF %u.%06llu y %llu ts %llu buf ts %llu (x1 %u/%u/%u x2 %u/%u/%u y1 %u y2 %u)\n",
 		  stream->dev->name,
 		  sof >> 16, div_u64(((u64)sof & 0xffff) * 1000000LLU, 65536),
 		  y, timespec_to_ns(&ts), vbuf->vb2_buf.timestamp,
@@ -829,9 +827,8 @@ static void uvc_video_stats_update(struct uvc_streaming *stream)
 {
 	struct uvc_stats_frame *frame = &stream->stats.frame;
 
-	uvc_trace(UVC_TRACE_STATS, "frame %u stats: %u/%u/%u packets, "
-		  "%u/%u/%u pts (%searly %sinitial), %u/%u scr, "
-		  "last pts/stc/sof %u/%u/%u\n",
+	uvc_trace(UVC_TRACE_STATS,
+		  "frame %u stats: %u/%u/%u packets, %u/%u/%u pts (%searly %sinitial), %u/%u scr, last pts/stc/sof %u/%u/%u\n",
 		  stream->sequence, frame->first_data,
 		  frame->nb_packets - frame->nb_empty, frame->nb_packets,
 		  frame->nb_pts_diffs, frame->last_pts_diff, frame->nb_pts,
@@ -1002,8 +999,8 @@ static int uvc_video_decode_start(struct uvc_streaming *stream,
 
 	/* Mark the buffer as bad if the error bit is set. */
 	if (data[1] & UVC_STREAM_ERR) {
-		uvc_trace(UVC_TRACE_FRAME, "Marking buffer as bad (error bit "
-			  "set).\n");
+		uvc_trace(UVC_TRACE_FRAME,
+			  "Marking buffer as bad (error bit set).\n");
 		buf->error = 1;
 	}
 
@@ -1019,8 +1016,8 @@ static int uvc_video_decode_start(struct uvc_streaming *stream,
 		struct timespec ts;
 
 		if (fid == stream->last_fid) {
-			uvc_trace(UVC_TRACE_FRAME, "Dropping payload (out of "
-				"sync).\n");
+			uvc_trace(UVC_TRACE_FRAME,
+				  "Dropping payload (out of sync).\n");
 			if ((stream->dev->quirks & UVC_QUIRK_STREAM_NO_FID) &&
 			    (data[1] & UVC_STREAM_EOF))
 				stream->last_fid ^= UVC_STREAM_FID;
@@ -1053,8 +1050,8 @@ static int uvc_video_decode_start(struct uvc_streaming *stream,
 	 * previous payload had the EOF bit set.
 	 */
 	if (fid != stream->last_fid && buf->bytesused != 0) {
-		uvc_trace(UVC_TRACE_FRAME, "Frame complete (FID bit "
-				"toggled).\n");
+		uvc_trace(UVC_TRACE_FRAME,
+			  "Frame complete (FID bit toggled).\n");
 		buf->state = UVC_BUF_STATE_READY;
 		return -EAGAIN;
 	}
@@ -1166,8 +1163,9 @@ static void uvc_video_decode_isoc(struct urb *urb, struct uvc_streaming *stream,
 
 	for (i = 0; i < urb->number_of_packets; ++i) {
 		if (urb->iso_frame_desc[i].status < 0) {
-			uvc_trace(UVC_TRACE_FRAME, "USB isochronous frame "
-				"lost (%d).\n", urb->iso_frame_desc[i].status);
+			uvc_trace(UVC_TRACE_FRAME,
+				  "USB isochronous frame lost (%d).\n",
+				  urb->iso_frame_desc[i].status);
 			/* Mark the buffer as faulty. */
 			if (buf != NULL)
 				buf->error = 1;
@@ -1328,8 +1326,9 @@ static void uvc_video_complete(struct urb *urb)
 		break;
 
 	default:
-		uvc_printk(KERN_WARNING, "Non-zero status (%d) in video "
-			"completion handler.\n", urb->status);
+		uvc_printk(KERN_WARNING,
+			   "Non-zero status (%d) in video completion handler.\n",
+			   urb->status);
 
 	case -ENOENT:		/* usb_kill_urb() called. */
 		if (stream->frozen)
@@ -1424,15 +1423,16 @@ static int uvc_alloc_urb_buffers(struct uvc_streaming *stream,
 		}
 
 		if (i == UVC_URBS) {
-			uvc_trace(UVC_TRACE_VIDEO, "Allocated %u URB buffers "
-				"of %ux%u bytes each.\n", UVC_URBS, npackets,
-				psize);
+			uvc_trace(UVC_TRACE_VIDEO,
+				  "Allocated %u URB buffers of %ux%u bytes each.\n",
+				  UVC_URBS, npackets, psize);
 			return npackets;
 		}
 	}
 
-	uvc_trace(UVC_TRACE_VIDEO, "Failed to allocate URB buffers (%u bytes "
-		"per packet).\n", psize);
+	uvc_trace(UVC_TRACE_VIDEO,
+		  "Failed to allocate URB buffers (%u bytes per packet).\n",
+		  psize);
 	return 0;
 }
 
@@ -1621,12 +1621,13 @@ static int uvc_init_video(struct uvc_streaming *stream, gfp_t gfp_flags)
 		bandwidth = stream->ctrl.dwMaxPayloadTransferSize;
 
 		if (bandwidth == 0) {
-			uvc_trace(UVC_TRACE_VIDEO, "Device requested null "
-				"bandwidth, defaulting to lowest.\n");
+			uvc_trace(UVC_TRACE_VIDEO,
+				  "Device requested null bandwidth, defaulting to lowest.\n");
 			bandwidth = 1;
 		} else {
-			uvc_trace(UVC_TRACE_VIDEO, "Device requested %u "
-				"B/frame bandwidth.\n", bandwidth);
+			uvc_trace(UVC_TRACE_VIDEO,
+				  "Device requested %u B/frame bandwidth.\n",
+				  bandwidth);
 		}
 
 		for (i = 0; i < intf->num_altsetting; ++i) {
@@ -1649,13 +1650,14 @@ static int uvc_init_video(struct uvc_streaming *stream, gfp_t gfp_flags)
 		}
 
 		if (best_ep == NULL) {
-			uvc_trace(UVC_TRACE_VIDEO, "No fast enough alt setting "
-				"for requested bandwidth.\n");
+			uvc_trace(UVC_TRACE_VIDEO,
+				  "No fast enough alt setting for requested bandwidth.\n");
 			return -EIO;
 		}
 
-		uvc_trace(UVC_TRACE_VIDEO, "Selecting alternate setting %u "
-			"(%u B/frame bandwidth).\n", altsetting, best_psize);
+		uvc_trace(UVC_TRACE_VIDEO,
+			  "Selecting alternate setting %u (%u B/frame bandwidth).\n",
+			  altsetting, best_psize);
 
 		ret = usb_set_interface(stream->dev->udev, intfnum, altsetting);
 		if (ret < 0)
@@ -1679,8 +1681,8 @@ static int uvc_init_video(struct uvc_streaming *stream, gfp_t gfp_flags)
 	for (i = 0; i < UVC_URBS; ++i) {
 		ret = usb_submit_urb(stream->urb[i], gfp_flags);
 		if (ret < 0) {
-			uvc_printk(KERN_ERR, "Failed to submit URB %u "
-					"(%d).\n", i, ret);
+			uvc_printk(KERN_ERR, "Failed to submit URB %u (%d).\n",
+				   i, ret);
 			uvc_uninit_video(stream, 1);
 			return ret;
 		}
@@ -1814,8 +1816,8 @@ int uvc_video_init(struct uvc_streaming *stream)
 	}
 
 	if (format->nframes == 0) {
-		uvc_printk(KERN_INFO, "No frame descriptor found for the "
-			"default format.\n");
+		uvc_printk(KERN_INFO,
+			   "No frame descriptor found for the default format.\n");
 		return -EINVAL;
 	}
 
@@ -1849,8 +1851,8 @@ int uvc_video_init(struct uvc_streaming *stream)
 		if (stream->intf->num_altsetting == 1)
 			stream->decode = uvc_video_encode_bulk;
 		else {
-			uvc_printk(KERN_INFO, "Isochronous endpoints are not "
-				"supported for video output devices.\n");
+			uvc_printk(KERN_INFO,
+				   "Isochronous endpoints are not supported for video output devices.\n");
 			return -EINVAL;
 		}
 	}


