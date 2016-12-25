Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:57493 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751674AbcLYSeA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Dec 2016 13:34:00 -0500
Subject: [PATCH 04/19] [media] uvc_driver: Adjust 28 checks for null pointers
To: linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <47aa4314-74ec-b2bf-ee3b-aad4d6e9f0a2@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <8adac30a-d655-0e85-e80d-831ab10694a3@users.sourceforge.net>
Date: Sun, 25 Dec 2016 19:33:44 +0100
MIME-Version: 1.0
In-Reply-To: <47aa4314-74ec-b2bf-ee3b-aad4d6e9f0a2@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 25 Dec 2016 09:40:21 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The script "checkpatch.pl" pointed information out like the following.

Comparison to NULL could be written …

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/uvc/uvc_driver.c | 54 +++++++++++++++++++-------------------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index bddaf98ef828..32d39404c1cb 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -254,7 +254,7 @@ void uvc_simplify_fraction(uint32_t *numerator, uint32_t *denominator,
 	unsigned int i, n;
 
 	an = kmalloc_array(n_terms, sizeof(*an), GFP_KERNEL);
-	if (an == NULL)
+	if (!an)
 		return;
 
 	/* Convert the fraction to a simple continued fraction. See
@@ -340,7 +340,7 @@ static struct uvc_entity *uvc_entity_by_reference(struct uvc_device *dev,
 {
 	unsigned int i;
 
-	if (entity == NULL)
+	if (!entity)
 		entity = list_entry(&dev->entities, struct uvc_entity, list);
 
 	list_for_each_entry_continue(entity, &dev->entities, list) {
@@ -400,7 +400,7 @@ static int uvc_parse_format(struct uvc_device *dev,
 		/* Find the format descriptor from its GUID. */
 		fmtdesc = uvc_format_by_guid(&buffer[5]);
 
-		if (fmtdesc != NULL) {
+		if (fmtdesc) {
 			strlcpy(format->name, fmtdesc->name,
 				sizeof format->name);
 			format->fcc = fmtdesc->fcc;
@@ -661,7 +661,7 @@ static int uvc_parse_streaming(struct uvc_device *dev,
 	}
 
 	streaming = kzalloc(sizeof *streaming, GFP_KERNEL);
-	if (streaming == NULL) {
+	if (!streaming) {
 		usb_driver_release_interface(&uvc_driver.driver, intf);
 		return -EINVAL;
 	}
@@ -749,7 +749,7 @@ static int uvc_parse_streaming(struct uvc_device *dev,
 
 	streaming->header.bmaControls = kmemdup(&buffer[size], p * n,
 						GFP_KERNEL);
-	if (streaming->header.bmaControls == NULL) {
+	if (!streaming->header.bmaControls) {
 		ret = -ENOMEM;
 		goto error;
 	}
@@ -815,7 +815,7 @@ static int uvc_parse_streaming(struct uvc_device *dev,
 	size = nformats * sizeof *format + nframes * sizeof *frame
 	     + nintervals * sizeof *interval;
 	format = kzalloc(size, GFP_KERNEL);
-	if (format == NULL) {
+	if (!format) {
 		ret = -ENOMEM;
 		goto error;
 	}
@@ -867,7 +867,7 @@ static int uvc_parse_streaming(struct uvc_device *dev,
 		alts = &intf->altsetting[i];
 		ep = uvc_find_endpoint(alts,
 				streaming->header.bEndpointAddress);
-		if (ep == NULL)
+		if (!ep)
 			continue;
 
 		psize = le16_to_cpu(ep->desc.wMaxPacketSize);
@@ -901,7 +901,7 @@ static struct uvc_entity *uvc_alloc_entity(u16 type, u8 id,
 	size = sizeof(*entity) + extra_size + sizeof(*entity->pads) * num_pads
 	     + num_inputs;
 	entity = kzalloc(size, GFP_KERNEL);
-	if (entity == NULL)
+	if (!entity)
 		return NULL;
 
 	entity->id = id;
@@ -975,7 +975,7 @@ static int uvc_parse_vendor_control(struct uvc_device *dev,
 
 		unit = uvc_alloc_entity(UVC_VC_EXTENSION_UNIT, buffer[3],
 					p + 1, 2*n);
-		if (unit == NULL)
+		if (!unit)
 			return -ENOMEM;
 
 		memcpy(unit->extension.guidExtensionCode, &buffer[4], 16);
@@ -1028,7 +1028,7 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 		/* Parse all USB Video Streaming interfaces. */
 		for (i = 0; i < n; ++i) {
 			intf = usb_ifnum_to_if(udev, buffer[12+i]);
-			if (intf == NULL) {
+			if (!intf) {
 				uvc_trace(UVC_TRACE_DESCR,
 					  "device %d interface %d doesn't exists\n",
 					  udev->devnum, i);
@@ -1084,7 +1084,7 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 
 		term = uvc_alloc_entity(type | UVC_TERM_INPUT, buffer[3],
 					1, n + p);
-		if (term == NULL)
+		if (!term)
 			return -ENOMEM;
 
 		if (UVC_ENTITY_TYPE(term) == UVC_ITT_CAMERA) {
@@ -1145,7 +1145,7 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 
 		term = uvc_alloc_entity(type | UVC_TERM_OUTPUT, buffer[3],
 					1, 0);
-		if (term == NULL)
+		if (!term)
 			return -ENOMEM;
 
 		memcpy(term->baSourceID, &buffer[7], 1);
@@ -1170,7 +1170,7 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 		}
 
 		unit = uvc_alloc_entity(buffer[2], buffer[3], p + 1, 0);
-		if (unit == NULL)
+		if (!unit)
 			return -ENOMEM;
 
 		memcpy(unit->baSourceID, &buffer[5], p);
@@ -1196,7 +1196,7 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 		}
 
 		unit = uvc_alloc_entity(buffer[2], buffer[3], 2, n);
-		if (unit == NULL)
+		if (!unit)
 			return -ENOMEM;
 
 		memcpy(unit->baSourceID, &buffer[4], 1);
@@ -1229,7 +1229,7 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 		}
 
 		unit = uvc_alloc_entity(buffer[2], buffer[3], p + 1, n);
-		if (unit == NULL)
+		if (!unit)
 			return -ENOMEM;
 
 		memcpy(unit->extension.guidExtensionCode, &buffer[4], 16);
@@ -1358,7 +1358,7 @@ static int uvc_scan_chain_entity(struct uvc_video_chain *chain,
 		if (uvc_trace_param & UVC_TRACE_PROBE)
 			printk(KERN_CONT " <- PU %d", entity->id);
 
-		if (chain->processing != NULL) {
+		if (chain->processing) {
 			uvc_trace(UVC_TRACE_DESCR,
 				  "Found multiple Processing Units in chain.\n");
 			return -1;
@@ -1375,7 +1375,7 @@ static int uvc_scan_chain_entity(struct uvc_video_chain *chain,
 		if (entity->bNrInPins == 1)
 			break;
 
-		if (chain->selector != NULL) {
+		if (chain->selector) {
 			uvc_trace(UVC_TRACE_DESCR,
 				  "Found multiple Selector Units in chain.\n");
 			return -1;
@@ -1435,7 +1435,7 @@ static int uvc_scan_chain_forward(struct uvc_video_chain *chain,
 	while (1) {
 		forward = uvc_entity_by_reference(chain->dev, entity->id,
 			forward);
-		if (forward == NULL)
+		if (!forward)
 			break;
 		if (forward == prev)
 			continue;
@@ -1514,7 +1514,7 @@ static int uvc_scan_chain_backward(struct uvc_video_chain *chain,
 		for (i = 0; i < entity->bNrInPins; ++i) {
 			id = entity->baSourceID[i];
 			term = uvc_entity_by_id(chain->dev, id);
-			if (term == NULL || !UVC_ENTITY_IS_ITERM(term)) {
+			if (!term || !UVC_ENTITY_IS_ITERM(term)) {
 				uvc_trace(UVC_TRACE_DESCR,
 					  "Selector unit %d input %d isn't connected to an input terminal\n",
 					  entity->id, i);
@@ -1551,7 +1551,7 @@ static int uvc_scan_chain_backward(struct uvc_video_chain *chain,
 	}
 
 	entity = uvc_entity_by_id(chain->dev, id);
-	if (entity == NULL) {
+	if (!entity) {
 		uvc_trace(UVC_TRACE_DESCR,
 			  "Found reference to unknown entity %d.\n",
 			  id);
@@ -1572,7 +1572,7 @@ static int uvc_scan_chain(struct uvc_video_chain *chain,
 	entity = term;
 	prev = NULL;
 
-	while (entity != NULL) {
+	while (entity) {
 		/* Entity must not be part of an existing chain */
 		if (entity->chain.next || entity->chain.prev) {
 			uvc_trace(UVC_TRACE_DESCR,
@@ -1639,7 +1639,7 @@ static struct uvc_video_chain *uvc_alloc_chain(struct uvc_device *dev)
 	struct uvc_video_chain *chain;
 
 	chain = kzalloc(sizeof(*chain), GFP_KERNEL);
-	if (chain == NULL)
+	if (!chain)
 		return NULL;
 
 	INIT_LIST_HEAD(&chain->entities);
@@ -1689,12 +1689,12 @@ static int uvc_scan_fallback(struct uvc_device *dev)
 		}
 	}
 
-	if (iterm == NULL || oterm == NULL)
+	if (!iterm || !oterm)
 		return -EINVAL;
 
 	/* Allocate the chain and fill it. */
 	chain = uvc_alloc_chain(dev);
-	if (chain == NULL)
+	if (!chain)
 		return -ENOMEM;
 
 	if (uvc_scan_chain_entity(chain, oterm) < 0)
@@ -1765,7 +1765,7 @@ static int uvc_scan_device(struct uvc_device *dev)
 			continue;
 
 		chain = uvc_alloc_chain(dev);
-		if (chain == NULL)
+		if (!chain)
 			return -ENOMEM;
 
 		term->flags |= UVC_ENTITY_FLAG_DEFAULT;
@@ -1970,7 +1970,7 @@ static int uvc_register_terms(struct uvc_device *dev,
 			continue;
 
 		stream = uvc_stream_by_id(dev, term->id);
-		if (stream == NULL) {
+		if (!stream) {
 			uvc_printk(KERN_INFO,
 				   "No streaming interface found for terminal %u.",
 				   term->id);
@@ -2048,7 +2048,7 @@ static int uvc_probe(struct usb_interface *intf,
 	dev->quirks = (uvc_quirks_param == -1)
 		    ? id->driver_info : uvc_quirks_param;
 
-	if (udev->product != NULL)
+	if (udev->product)
 		strlcpy(dev->name, udev->product, sizeof dev->name);
 	else
 		snprintf(dev->name, sizeof dev->name,
-- 
2.11.0

