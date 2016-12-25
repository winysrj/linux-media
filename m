Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:51047 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932244AbcLYSbT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Dec 2016 13:31:19 -0500
Subject: [PATCH 02/19] [media] uvc_driver: Combine substrings for 48 messages
To: linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <47aa4314-74ec-b2bf-ee3b-aad4d6e9f0a2@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <3f421a86-ff69-ee9a-3529-a437e8999264@users.sourceforge.net>
Date: Sun, 25 Dec 2016 19:31:06 +0100
MIME-Version: 1.0
In-Reply-To: <47aa4314-74ec-b2bf-ee3b-aad4d6e9f0a2@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 25 Dec 2016 07:41:29 +0100

The script "checkpatch.pl" pointed information out like the following.

WARNING: quoted string split across lines

* Thus fix the affected source code places.

* Improve indentation for passed parameters.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/uvc/uvc_driver.c | 290 ++++++++++++++++++++-----------------
 1 file changed, 156 insertions(+), 134 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index a64b5029f262..7c42be2414ea 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -390,10 +390,10 @@ static int uvc_parse_format(struct uvc_device *dev,
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
 
@@ -438,10 +438,10 @@ static int uvc_parse_format(struct uvc_device *dev,
 
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
 
@@ -454,10 +454,10 @@ static int uvc_parse_format(struct uvc_device *dev,
 
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
 
@@ -472,10 +472,10 @@ static int uvc_parse_format(struct uvc_device *dev,
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
 
@@ -501,10 +501,11 @@ static int uvc_parse_format(struct uvc_device *dev,
 	case UVC_VS_FORMAT_STREAM_BASED:
 		/* Not supported yet. */
 	default:
-		uvc_trace(UVC_TRACE_DESCR, "device %d videostreaming "
-		       "interface %d unsupported format %u\n",
-		       dev->udev->devnum, alts->desc.bInterfaceNumber,
-		       buffer[2]);
+		uvc_trace(UVC_TRACE_DESCR,
+			  "device %d videostreaming interface %d unsupported format %u\n",
+			  dev->udev->devnum,
+			  alts->desc.bInterfaceNumber,
+			  buffer[2]);
 		return -EINVAL;
 	}
 
@@ -527,9 +528,10 @@ static int uvc_parse_format(struct uvc_device *dev,
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
 
@@ -610,10 +612,10 @@ static int uvc_parse_format(struct uvc_device *dev,
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
 
@@ -643,16 +645,18 @@ static int uvc_parse_streaming(struct uvc_device *dev,
 
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
 
@@ -679,8 +683,9 @@ static int uvc_parse_streaming(struct uvc_device *dev,
 
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
@@ -695,8 +700,8 @@ static int uvc_parse_streaming(struct uvc_device *dev,
 	}
 
 	if (buflen <= 2) {
-		uvc_trace(UVC_TRACE_DESCR, "no class-specific streaming "
-			"interface descriptors found.\n");
+		uvc_trace(UVC_TRACE_DESCR,
+			  "no class-specific streaming interface descriptors found.\n");
 		goto error;
 	}
 
@@ -713,9 +718,9 @@ static int uvc_parse_streaming(struct uvc_device *dev,
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
 
@@ -723,9 +728,9 @@ static int uvc_parse_streaming(struct uvc_device *dev,
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
 
@@ -775,10 +780,11 @@ static int uvc_parse_streaming(struct uvc_device *dev,
 
 		case UVC_VS_FORMAT_MPEG2TS:
 		case UVC_VS_FORMAT_STREAM_BASED:
-			uvc_trace(UVC_TRACE_DESCR, "device %d videostreaming "
-				"interface %d FORMAT %u is not supported.\n",
-				dev->udev->devnum,
-				alts->desc.bInterfaceNumber, _buffer[2]);
+			uvc_trace(UVC_TRACE_DESCR,
+				  "device %d videostreaming interface %d FORMAT %u is not supported.\n",
+				  dev->udev->devnum,
+				  alts->desc.bInterfaceNumber,
+				  _buffer[2]);
 			break;
 
 		case UVC_VS_FRAME_UNCOMPRESSED:
@@ -800,9 +806,9 @@ static int uvc_parse_streaming(struct uvc_device *dev,
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
 
@@ -849,9 +855,11 @@ static int uvc_parse_streaming(struct uvc_device *dev,
 	}
 
 	if (buflen)
-		uvc_trace(UVC_TRACE_DESCR, "device %d videostreaming interface "
-			"%d has %u bytes of trailing descriptor garbage.\n",
-			dev->udev->devnum, alts->desc.bInterfaceNumber, buflen);
+		uvc_trace(UVC_TRACE_DESCR,
+			  "device %d videostreaming interface %d has %u bytes of trailing descriptor garbage.\n",
+			  dev->udev->devnum,
+			  alts->desc.bInterfaceNumber,
+			  buflen);
 
 	/* Parse the alternate settings to find the maximum bandwidth. */
 	for (i = 0; i < intf->num_altsetting; ++i) {
@@ -959,9 +967,9 @@ static int uvc_parse_vendor_control(struct uvc_device *dev,
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
 
@@ -1008,9 +1016,9 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
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
 
@@ -1021,9 +1029,9 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
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
 
@@ -1033,9 +1041,9 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 
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
 
@@ -1044,11 +1052,12 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
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
+				  udev->devnum,
+				  alts->desc.bInterfaceNumber,
+				  buffer[3],
+				  type);
 			return 0;
 		}
 
@@ -1067,9 +1076,9 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
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
 
@@ -1114,9 +1123,9 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 
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
 
@@ -1125,10 +1134,12 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 		 */
 		type = get_unaligned_le16(&buffer[4]);
 		if ((type & 0xff00) == 0) {
-			uvc_trace(UVC_TRACE_DESCR, "device %d videocontrol "
-				"interface %d OUTPUT_TERMINAL %d has invalid "
-				"type 0x%04x, skipping\n", udev->devnum,
-				alts->desc.bInterfaceNumber, buffer[3], type);
+			uvc_trace(UVC_TRACE_DESCR,
+				  "device %d videocontrol interface %d OUTPUT_TERMINAL %d has invalid type 0x%04x, skipping\n",
+				  udev->devnum,
+				  alts->desc.bInterfaceNumber,
+				  buffer[3],
+				  type);
 			return 0;
 		}
 
@@ -1152,9 +1163,9 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
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
 
@@ -1178,9 +1189,9 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
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
 
@@ -1211,9 +1222,9 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
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
 
@@ -1238,8 +1249,9 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 		break;
 
 	default:
-		uvc_trace(UVC_TRACE_DESCR, "Found an unknown CS_INTERFACE "
-			"descriptor (%u)\n", buffer[2]);
+		uvc_trace(UVC_TRACE_DESCR,
+			  "Found an unknown CS_INTERFACE descriptor (%u)\n",
+			  buffer[2]);
 		break;
 	}
 
@@ -1284,8 +1296,9 @@ static int uvc_parse_control(struct uvc_device *dev)
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
@@ -1332,8 +1345,9 @@ static int uvc_scan_chain_entity(struct uvc_video_chain *chain,
 			printk(KERN_CONT " <- XU %d", entity->id);
 
 		if (entity->bNrInPins != 1) {
-			uvc_trace(UVC_TRACE_DESCR, "Extension unit %d has more "
-				"than 1 input pin.\n", entity->id);
+			uvc_trace(UVC_TRACE_DESCR,
+				  "Extension unit %d has more than 1 input pin.\n",
+				  entity->id);
 			return -1;
 		}
 
@@ -1344,8 +1358,8 @@ static int uvc_scan_chain_entity(struct uvc_video_chain *chain,
 			printk(KERN_CONT " <- PU %d", entity->id);
 
 		if (chain->processing != NULL) {
-			uvc_trace(UVC_TRACE_DESCR, "Found multiple "
-				"Processing Units in chain.\n");
+			uvc_trace(UVC_TRACE_DESCR,
+				  "Found multiple Processing Units in chain.\n");
 			return -1;
 		}
 
@@ -1361,8 +1375,8 @@ static int uvc_scan_chain_entity(struct uvc_video_chain *chain,
 			break;
 
 		if (chain->selector != NULL) {
-			uvc_trace(UVC_TRACE_DESCR, "Found multiple Selector "
-				"Units in chain.\n");
+			uvc_trace(UVC_TRACE_DESCR,
+				  "Found multiple Selector Units in chain.\n");
 			return -1;
 		}
 
@@ -1397,8 +1411,9 @@ static int uvc_scan_chain_entity(struct uvc_video_chain *chain,
 		break;
 
 	default:
-		uvc_trace(UVC_TRACE_DESCR, "Unsupported entity type "
-			"0x%04x found in chain.\n", UVC_ENTITY_TYPE(entity));
+		uvc_trace(UVC_TRACE_DESCR,
+			  "Unsupported entity type 0x%04x found in chain.\n",
+			  UVC_ENTITY_TYPE(entity));
 		return -1;
 	}
 
@@ -1427,8 +1442,8 @@ static int uvc_scan_chain_forward(struct uvc_video_chain *chain,
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
@@ -1448,8 +1463,9 @@ static int uvc_scan_chain_forward(struct uvc_video_chain *chain,
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
 
@@ -1498,9 +1514,9 @@ static int uvc_scan_chain_backward(struct uvc_video_chain *chain,
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
 
@@ -1535,8 +1551,9 @@ static int uvc_scan_chain_backward(struct uvc_video_chain *chain,
 
 	entity = uvc_entity_by_id(chain->dev, id);
 	if (entity == NULL) {
-		uvc_trace(UVC_TRACE_DESCR, "Found reference to "
-			"unknown entity %d.\n", id);
+		uvc_trace(UVC_TRACE_DESCR,
+			  "Found reference to unknown entity %d.\n",
+			  id);
 		return -EINVAL;
 	}
 
@@ -1557,8 +1574,9 @@ static int uvc_scan_chain(struct uvc_video_chain *chain,
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
 
@@ -1892,8 +1910,9 @@ static int uvc_register_video(struct uvc_device *dev,
 	 */
 	ret = uvc_video_init(stream);
 	if (ret < 0) {
-		uvc_printk(KERN_ERR, "Failed to initialize the device "
-			"(%d).\n", ret);
+		uvc_printk(KERN_ERR,
+			   "Failed to initialize the device (%d).\n",
+			   ret);
 		return ret;
 	}
 
@@ -1951,8 +1970,9 @@ static int uvc_register_terms(struct uvc_device *dev,
 
 		stream = uvc_stream_by_id(dev, term->id);
 		if (stream == NULL) {
-			uvc_printk(KERN_INFO, "No streaming interface found "
-				   "for terminal %u.", term->id);
+			uvc_printk(KERN_INFO,
+				   "No streaming interface found for terminal %u.",
+				   term->id);
 			continue;
 		}
 
@@ -1980,8 +2000,9 @@ static int uvc_register_chains(struct uvc_device *dev)
 #ifdef CONFIG_MEDIA_CONTROLLER
 		ret = uvc_mc_register_entities(chain);
 		if (ret < 0) {
-			uvc_printk(KERN_INFO, "Failed to register entites "
-				"(%d).\n", ret);
+			uvc_printk(KERN_INFO,
+				   "Failed to register entities (%d).\n",
+				   ret);
 		}
 #endif
 	}
@@ -2001,9 +2022,9 @@ static int uvc_probe(struct usb_interface *intf,
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
@@ -2035,8 +2056,8 @@ static int uvc_probe(struct usb_interface *intf,
 
 	/* Parse the Video Class control descriptor. */
 	if (uvc_parse_control(dev) < 0) {
-		uvc_trace(UVC_TRACE_PROBE, "Unable to parse UVC "
-			"descriptors.\n");
+		uvc_trace(UVC_TRACE_PROBE,
+			  "Unable to parse UVC descriptors.\n");
 		goto error;
 	}
 
@@ -2047,10 +2068,11 @@ static int uvc_probe(struct usb_interface *intf,
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
@@ -2092,9 +2114,9 @@ static int uvc_probe(struct usb_interface *intf,
 
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
@@ -2145,8 +2167,8 @@ static int uvc_suspend(struct usb_interface *intf, pm_message_t message)
 			return uvc_video_suspend(stream);
 	}
 
-	uvc_trace(UVC_TRACE_SUSPEND, "Suspend: video streaming USB interface "
-			"mismatch.\n");
+	uvc_trace(UVC_TRACE_SUSPEND,
+		  "Suspend: video streaming USB interface mismatch.\n");
 	return -EINVAL;
 }
 
@@ -2185,8 +2207,8 @@ static int __uvc_resume(struct usb_interface *intf, int reset)
 		}
 	}
 
-	uvc_trace(UVC_TRACE_SUSPEND, "Resume: video streaming USB interface "
-			"mismatch.\n");
+	uvc_trace(UVC_TRACE_SUSPEND,
+		  "Resume: video streaming USB interface mismatch.\n");
 	return -EINVAL;
 }
 
-- 
2.11.0

