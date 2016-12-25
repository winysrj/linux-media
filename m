Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:55488 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752274AbcLYSgr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Dec 2016 13:36:47 -0500
Subject: [PATCH 06/19] [media] uvc_driver: Add some spaces for better code
 readability
To: linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <47aa4314-74ec-b2bf-ee3b-aad4d6e9f0a2@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, trivial@kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <3cc215d8-5903-18ba-b32a-d710ed75f691@users.sourceforge.net>
Date: Sun, 25 Dec 2016 19:36:38 +0100
MIME-Version: 1.0
In-Reply-To: <47aa4314-74ec-b2bf-ee3b-aad4d6e9f0a2@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 25 Dec 2016 10:37:17 +0100

Use space characters at some source code places according to
the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/uvc/uvc_driver.c | 62 +++++++++++++++++++-------------------
 1 file changed, 31 insertions(+), 31 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index c05ba4bdec2d..563b51d0b398 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -284,7 +284,7 @@ void uvc_simplify_fraction(uint32_t *numerator, uint32_t *denominator,
 
 	for (i = n; i > 0; --i) {
 		r = y;
-		y = an[i-1] * y + x;
+		y = an[i - 1] * y + x;
 		x = r;
 	}
 
@@ -303,7 +303,7 @@ uint32_t uvc_fraction_to_interval(uint32_t numerator, uint32_t denominator)
 
 	/* Saturate the result if the operation would overflow. */
 	if (denominator == 0 ||
-	    numerator/denominator >= ((uint32_t)-1)/10000000)
+	    numerator / denominator >= ((uint32_t)-1) / 10000000)
 		return (uint32_t)-1;
 
 	/* Divide both the denominator and the multiplier by two until
@@ -311,7 +311,7 @@ uint32_t uvc_fraction_to_interval(uint32_t numerator, uint32_t denominator)
 	 * algorithm please let me know.
 	 */
 	multiplier = 10000000;
-	while (numerator > ((uint32_t)-1)/multiplier) {
+	while (numerator > ((uint32_t)-1) / multiplier) {
 		multiplier /= 2;
 		denominator /= 2;
 	}
@@ -527,7 +527,7 @@ static int uvc_parse_format(struct uvc_device *dev,
 
 		n = n ? n : 3;
 
-		if (buflen < 26 + 4*n) {
+		if (buflen < 26 + 4 * n) {
 			uvc_trace(UVC_TRACE_DESCR,
 				  "device %d videostreaming interface %d FRAME error\n",
 				  dev->udev->devnum,
@@ -574,7 +574,7 @@ static int uvc_parse_format(struct uvc_device *dev,
 		 * some other divisions by zero that could happen.
 		 */
 		for (i = 0; i < n; ++i) {
-			interval = get_unaligned_le32(&buffer[26+4*i]);
+			interval = get_unaligned_le32(&buffer[26 + 4 * i]);
 			*(*intervals)++ = interval ? interval : 1;
 		}
 
@@ -594,9 +594,9 @@ static int uvc_parse_format(struct uvc_device *dev,
 		}
 
 		uvc_trace(UVC_TRACE_DESCR, "- %ux%u (%u.%u fps)\n",
-			frame->wWidth, frame->wHeight,
-			10000000/frame->dwDefaultFrameInterval,
-			(100000000/frame->dwDefaultFrameInterval)%10);
+			  frame->wWidth, frame->wHeight,
+			  10000000 / frame->dwDefaultFrameInterval,
+			  (100000000 / frame->dwDefaultFrameInterval) % 10);
 
 		format->nframes++;
 		buflen -= buffer[0];
@@ -725,9 +725,9 @@ static int uvc_parse_streaming(struct uvc_device *dev,
 	}
 
 	p = buflen >= 4 ? buffer[3] : 0;
-	n = buflen >= size ? buffer[size-1] : 0;
+	n = buflen >= size ? buffer[size - 1] : 0;
 
-	if (buflen < size + p*n) {
+	if (buflen < size + p * n) {
 		uvc_trace(UVC_TRACE_DESCR,
 			  "device %d videostreaming interface %d HEADER descriptor is invalid.\n",
 			  dev->udev->devnum, alts->desc.bInterfaceNumber);
@@ -914,7 +914,7 @@ static struct uvc_entity *uvc_alloc_entity(u16 type, u8 id,
 	for (i = 0; i < num_inputs; ++i)
 		entity->pads[i].flags = MEDIA_PAD_FL_SINK;
 	if (!UVC_ENTITY_IS_OTERM(entity))
-		entity->pads[num_pads-1].flags = MEDIA_PAD_FL_SOURCE;
+		entity->pads[num_pads - 1].flags = MEDIA_PAD_FL_SOURCE;
 
 	entity->bNrInPins = num_inputs;
 	entity->baSourceID = (__u8 *)(&entity->pads[num_pads]);
@@ -964,9 +964,9 @@ static int uvc_parse_vendor_control(struct uvc_device *dev,
 		 * ----------------------------------------------------------
 		 */
 		p = buflen >= 22 ? buffer[21] : 0;
-		n = buflen >= 25 + p ? buffer[22+p] : 0;
+		n = buflen >= 25 + p ? buffer[22 + p] : 0;
 
-		if (buflen < 25 + p + 2*n) {
+		if (buflen < 25 + p + 2 * n) {
 			uvc_trace(UVC_TRACE_DESCR,
 				  "device %d videocontrol interface %d EXTENSION_UNIT error\n",
 				  udev->devnum, alts->desc.bInterfaceNumber);
@@ -974,21 +974,21 @@ static int uvc_parse_vendor_control(struct uvc_device *dev,
 		}
 
 		unit = uvc_alloc_entity(UVC_VC_EXTENSION_UNIT, buffer[3],
-					p + 1, 2*n);
+					p + 1, 2 * n);
 		if (!unit)
 			return -ENOMEM;
 
 		memcpy(unit->extension.guidExtensionCode, &buffer[4], 16);
 		unit->extension.bNumControls = buffer[20];
 		memcpy(unit->baSourceID, &buffer[22], p);
-		unit->extension.bControlSize = buffer[22+p];
+		unit->extension.bControlSize = buffer[22 + p];
 		unit->extension.bmControls = (__u8 *)unit + sizeof(*unit);
 		unit->extension.bmControlsType = (__u8 *)unit + sizeof(*unit)
 					       + n;
-		memcpy(unit->extension.bmControls, &buffer[23+p], 2*n);
+		memcpy(unit->extension.bmControls, &buffer[23 + p], 2 * n);
 
-		if (buffer[24+p+2*n] != 0)
-			usb_string(udev, buffer[24+p+2*n], unit->name,
+		if (buffer[24 + p + 2 * n] != 0)
+			usb_string(udev, buffer[24 + p + 2 * n], unit->name,
 				   sizeof(unit->name));
 		else
 			sprintf(unit->name, "Extension %u", buffer[3]);
@@ -1027,7 +1027,7 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 
 		/* Parse all USB Video Streaming interfaces. */
 		for (i = 0; i < n; ++i) {
-			intf = usb_ifnum_to_if(udev, buffer[12+i]);
+			intf = usb_ifnum_to_if(udev, buffer[12 + i]);
 			if (!intf) {
 				uvc_trace(UVC_TRACE_DESCR,
 					  "device %d interface %d doesn't exists\n",
@@ -1071,7 +1071,7 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 
 		} else if (type == UVC_ITT_MEDIA_TRANSPORT_INPUT) {
 			n = buflen >= 9 ? buffer[8] : 0;
-			p = buflen >= 10 + n ? buffer[9+n] : 0;
+			p = buflen >= 10 + n ? buffer[9 + n] : 0;
 			len = 10;
 		}
 
@@ -1105,7 +1105,7 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 			term->media.bmTransportModes = (__u8 *)term
 						       + sizeof(*term) + n;
 			memcpy(term->media.bmControls, &buffer[9], n);
-			memcpy(term->media.bmTransportModes, &buffer[10+n], p);
+			memcpy(term->media.bmTransportModes, &buffer[10 + n], p);
 		}
 
 		if (buffer[7] != 0)
@@ -1175,8 +1175,8 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 
 		memcpy(unit->baSourceID, &buffer[5], p);
 
-		if (buffer[5+p] != 0)
-			usb_string(udev, buffer[5+p], unit->name,
+		if (buffer[5 + p] != 0)
+			usb_string(udev, buffer[5 + p], unit->name,
 				   sizeof(unit->name));
 		else
 			sprintf(unit->name, "Selector %u", buffer[3]);
@@ -1206,10 +1206,10 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 		unit->processing.bmControls = (__u8 *)unit + sizeof(*unit);
 		memcpy(unit->processing.bmControls, &buffer[8], n);
 		if (dev->uvc_version >= 0x0110)
-			unit->processing.bmVideoStandards = buffer[9+n];
+			unit->processing.bmVideoStandards = buffer[9 + n];
 
-		if (buffer[8+n] != 0)
-			usb_string(udev, buffer[8+n], unit->name,
+		if (buffer[8 + n] != 0)
+			usb_string(udev, buffer[8 + n], unit->name,
 				   sizeof(unit->name));
 		else
 			sprintf(unit->name, "Processing %u", buffer[3]);
@@ -1219,7 +1219,7 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 
 	case UVC_VC_EXTENSION_UNIT:
 		p = buflen >= 22 ? buffer[21] : 0;
-		n = buflen >= 24 + p ? buffer[22+p] : 0;
+		n = buflen >= 24 + p ? buffer[22 + p] : 0;
 
 		if (buflen < 24 + p + n) {
 			uvc_trace(UVC_TRACE_DESCR,
@@ -1235,12 +1235,12 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 		memcpy(unit->extension.guidExtensionCode, &buffer[4], 16);
 		unit->extension.bNumControls = buffer[20];
 		memcpy(unit->baSourceID, &buffer[22], p);
-		unit->extension.bControlSize = buffer[22+p];
+		unit->extension.bControlSize = buffer[22 + p];
 		unit->extension.bmControls = (__u8 *)unit + sizeof(*unit);
-		memcpy(unit->extension.bmControls, &buffer[23+p], n);
+		memcpy(unit->extension.bmControls, &buffer[23 + p], n);
 
-		if (buffer[23+p+n] != 0)
-			usb_string(udev, buffer[23+p+n], unit->name,
+		if (buffer[23 + p + n] != 0)
+			usb_string(udev, buffer[23 + p + n], unit->name,
 				   sizeof(unit->name));
 		else
 			sprintf(unit->name, "Extension %u", buffer[3]);
-- 
2.11.0

