Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:58409 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757198Ab2BXPYy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Feb 2012 10:24:54 -0500
Received: by ghrr11 with SMTP id r11so1161035ghr.19
        for <linux-media@vger.kernel.org>; Fri, 24 Feb 2012 07:24:54 -0800 (PST)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: mchehab@infradead.org, gregkh@linuxfoundation.org
Cc: tomas.winkler@intel.com, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org, dan.carpenter@oracle.com,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH 6/9] staging: easycap: Split audio buffer and urb allocation
Date: Fri, 24 Feb 2012 12:24:19 -0300
Message-Id: <1330097062-31663-6-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1330097062-31663-1-git-send-email-elezegarcia@gmail.com>
References: <1330097062-31663-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When the device is probed, this driver allocates
audio buffers, and audio urbs.
This patch just split this into separate functions,
which helps clearing the currently gigantic probe function.

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/staging/media/easycap/easycap_main.c |  229 ++++++++++++++------------
 1 files changed, 124 insertions(+), 105 deletions(-)

diff --git a/drivers/staging/media/easycap/easycap_main.c b/drivers/staging/media/easycap/easycap_main.c
index 68af1a2..6e1734d 100644
--- a/drivers/staging/media/easycap/easycap_main.c
+++ b/drivers/staging/media/easycap/easycap_main.c
@@ -3245,6 +3245,123 @@ static int create_video_urbs(struct easycap *peasycap)
 	return 0;
 }
 
+static int alloc_audio_buffers(struct easycap *peasycap)
+{
+	void *pbuf;
+	int k;
+
+	JOM(4, "allocating %i isoc audio buffers of size %i\n",
+		AUDIO_ISOC_BUFFER_MANY,
+		peasycap->audio_isoc_buffer_size);
+	JOM(4, ".... each occupying contiguous memory pages\n");
+
+	for (k = 0;  k < AUDIO_ISOC_BUFFER_MANY;  k++) {
+		pbuf = (void *)__get_free_pages(GFP_KERNEL, AUDIO_ISOC_ORDER);
+		if (!pbuf) {
+			SAM("ERROR: Could not allocate isoc audio buffer %i\n",
+			    k);
+				return -ENOMEM;
+		}
+		peasycap->allocation_audio_page += BIT(AUDIO_ISOC_ORDER);
+
+		peasycap->audio_isoc_buffer[k].pgo = pbuf;
+		peasycap->audio_isoc_buffer[k].pto =
+			pbuf + peasycap->audio_isoc_buffer_size;
+		peasycap->audio_isoc_buffer[k].kount = k;
+	}
+
+	JOM(4, "allocation of isoc audio buffers done.\n");
+	return 0;
+}
+
+static int create_audio_urbs(struct easycap *peasycap)
+{
+	struct urb *purb;
+	struct data_urb *pdata_urb;
+	int k, j;
+
+	JOM(4, "allocating %i struct urb.\n", AUDIO_ISOC_BUFFER_MANY);
+	JOM(4, "using %i=peasycap->audio_isoc_framesperdesc\n",
+		peasycap->audio_isoc_framesperdesc);
+	JOM(4, "using %i=peasycap->audio_isoc_maxframesize\n",
+		peasycap->audio_isoc_maxframesize);
+	JOM(4, "using %i=peasycap->audio_isoc_buffer_size\n",
+		peasycap->audio_isoc_buffer_size);
+
+	for (k = 0;  k < AUDIO_ISOC_BUFFER_MANY; k++) {
+		purb = usb_alloc_urb(peasycap->audio_isoc_framesperdesc,
+				     GFP_KERNEL);
+		if (!purb) {
+			SAM("ERROR: usb_alloc_urb returned NULL for buffer "
+			     "%i\n", k);
+			return -ENOMEM;
+		}
+		peasycap->allocation_audio_urb += 1 ;
+		pdata_urb = kzalloc(sizeof(struct data_urb), GFP_KERNEL);
+		if (!pdata_urb) {
+			usb_free_urb(purb);
+			SAM("ERROR: Could not allocate struct data_urb.\n");
+			return -ENOMEM;
+		}
+		peasycap->allocation_audio_struct +=
+			sizeof(struct data_urb);
+
+		pdata_urb->purb = purb;
+		pdata_urb->isbuf = k;
+		pdata_urb->length = 0;
+		list_add_tail(&(pdata_urb->list_head),
+				peasycap->purb_audio_head);
+
+		if (!k) {
+			JOM(4, "initializing audio urbs thus:\n");
+			JOM(4, "  purb->interval = 1;\n");
+			JOM(4, "  purb->dev = peasycap->pusb_device;\n");
+			JOM(4, "  purb->pipe = usb_rcvisocpipe(peasycap->"
+				"pusb_device,%i);\n",
+				peasycap->audio_endpointnumber);
+			JOM(4, "  purb->transfer_flags = URB_ISO_ASAP;\n");
+			JOM(4, "  purb->transfer_buffer = "
+				"peasycap->audio_isoc_buffer[.].pgo;\n");
+			JOM(4, "  purb->transfer_buffer_length = %i;\n",
+				peasycap->audio_isoc_buffer_size);
+			JOM(4, "  purb->complete = easycap_alsa_complete;\n");
+			JOM(4, "  purb->context = peasycap;\n");
+			JOM(4, "  purb->start_frame = 0;\n");
+			JOM(4, "  purb->number_of_packets = %i;\n",
+				peasycap->audio_isoc_framesperdesc);
+			JOM(4, "  for (j = 0; j < %i; j++)\n",
+				peasycap->audio_isoc_framesperdesc);
+			JOM(4, "    {\n");
+			JOM(4, "    purb->iso_frame_desc[j].offset = j*%i;\n",
+				peasycap->audio_isoc_maxframesize);
+			JOM(4, "    purb->iso_frame_desc[j].length = %i;\n",
+				peasycap->audio_isoc_maxframesize);
+			JOM(4, "    }\n");
+		}
+
+		purb->interval = 1;
+		purb->dev = peasycap->pusb_device;
+		purb->pipe = usb_rcvisocpipe(peasycap->pusb_device,
+					     peasycap->audio_endpointnumber);
+		purb->transfer_flags = URB_ISO_ASAP;
+		purb->transfer_buffer = peasycap->audio_isoc_buffer[k].pgo;
+		purb->transfer_buffer_length =
+			peasycap->audio_isoc_buffer_size;
+		purb->complete = easycap_alsa_complete;
+		purb->context = peasycap;
+		purb->start_frame = 0;
+		purb->number_of_packets = peasycap->audio_isoc_framesperdesc;
+		for (j = 0;  j < peasycap->audio_isoc_framesperdesc; j++) {
+			purb->iso_frame_desc[j].offset =
+				j * peasycap->audio_isoc_maxframesize;
+			purb->iso_frame_desc[j].length =
+				peasycap->audio_isoc_maxframesize;
+		}
+	}
+	JOM(4, "allocation of %i struct urb done.\n", k);
+	return 0;
+}
+
 static void config_easycap(struct easycap *peasycap,
 			   u8 bInterfaceNumber,
 			   u8 bInterfaceClass,
@@ -3333,14 +3450,11 @@ static int easycap_usb_probe(struct usb_interface *intf,
 	struct usb_host_interface *alt;
 	struct usb_endpoint_descriptor *ep;
 	struct usb_interface_descriptor *interface;
-	struct urb *purb;
 	struct easycap *peasycap;
-	struct data_urb *pdata_urb;
-	int i, j, k, rc;
+	int i, j, rc;
 	u8 bInterfaceNumber;
 	u8 bInterfaceClass;
 	u8 bInterfaceSubClass;
-	void *pbuf;
 	int okalt[8], isokalt;
 	int okepn[8];
 	int okmps[8];
@@ -3823,109 +3937,14 @@ static int easycap_usb_probe(struct usb_interface *intf,
 		INIT_LIST_HEAD(&(peasycap->urb_audio_head));
 		peasycap->purb_audio_head = &(peasycap->urb_audio_head);
 
-		JOM(4, "allocating %i isoc audio buffers of size %i\n",
-			AUDIO_ISOC_BUFFER_MANY,
-			peasycap->audio_isoc_buffer_size);
-		JOM(4, ".... each occupying contiguous memory pages\n");
-
-		for (k = 0;  k < AUDIO_ISOC_BUFFER_MANY;  k++) {
-			pbuf = (void *)__get_free_pages(GFP_KERNEL,
-							AUDIO_ISOC_ORDER);
-			if (!pbuf) {
-				SAM("ERROR: Could not allocate isoc audio buffer "
-								"%i\n", k);
-				return -ENOMEM;
-			}
-			peasycap->allocation_audio_page +=
-						BIT(AUDIO_ISOC_ORDER);
-
-			peasycap->audio_isoc_buffer[k].pgo = pbuf;
-			peasycap->audio_isoc_buffer[k].pto = pbuf +
-			peasycap->audio_isoc_buffer_size;
-			peasycap->audio_isoc_buffer[k].kount = k;
-		}
-		JOM(4, "allocation of isoc audio buffers done.\n");
+		alloc_audio_buffers(peasycap);
+		if (rc < 0)
+			return rc;
 
 		/* Allocate and initialize urbs */
-		JOM(4, "allocating %i struct urb.\n", AUDIO_ISOC_BUFFER_MANY);
-		JOM(4, "using %i=peasycap->audio_isoc_framesperdesc\n",
-					peasycap->audio_isoc_framesperdesc);
-		JOM(4, "using %i=peasycap->audio_isoc_maxframesize\n",
-					peasycap->audio_isoc_maxframesize);
-		JOM(4, "using %i=peasycap->audio_isoc_buffer_size\n",
-					peasycap->audio_isoc_buffer_size);
-
-		for (k = 0;  k < AUDIO_ISOC_BUFFER_MANY; k++) {
-			purb = usb_alloc_urb(peasycap->audio_isoc_framesperdesc,
-								GFP_KERNEL);
-			if (!purb) {
-				SAM("ERROR: usb_alloc_urb returned NULL for buffer "
-								"%i\n", k);
-				return -ENOMEM;
-			}
-			peasycap->allocation_audio_urb += 1 ;
-			pdata_urb = kzalloc(sizeof(struct data_urb), GFP_KERNEL);
-			if (!pdata_urb) {
-				usb_free_urb(purb);
-				SAM("ERROR: Could not allocate struct data_urb.\n");
-				return -ENOMEM;
-			}
-			peasycap->allocation_audio_struct +=
-						sizeof(struct data_urb);
-
-			pdata_urb->purb = purb;
-			pdata_urb->isbuf = k;
-			pdata_urb->length = 0;
-			list_add_tail(&(pdata_urb->list_head),
-							peasycap->purb_audio_head);
-
-			if (!k) {
-				JOM(4, "initializing audio urbs thus:\n");
-				JOM(4, "  purb->interval = 1;\n");
-				JOM(4, "  purb->dev = peasycap->pusb_device;\n");
-				JOM(4, "  purb->pipe = usb_rcvisocpipe(peasycap->"
-						"pusb_device,%i);\n",
-						peasycap->audio_endpointnumber);
-				JOM(4, "  purb->transfer_flags = URB_ISO_ASAP;\n");
-				JOM(4, "  purb->transfer_buffer = "
-					"peasycap->audio_isoc_buffer[.].pgo;\n");
-				JOM(4, "  purb->transfer_buffer_length = %i;\n",
-					peasycap->audio_isoc_buffer_size);
-				JOM(4, "  purb->complete = easycap_alsa_complete;\n");
-				JOM(4, "  purb->context = peasycap;\n");
-				JOM(4, "  purb->start_frame = 0;\n");
-				JOM(4, "  purb->number_of_packets = %i;\n",
-						peasycap->audio_isoc_framesperdesc);
-				JOM(4, "  for (j = 0; j < %i; j++)\n",
-						peasycap->audio_isoc_framesperdesc);
-				JOM(4, "    {\n");
-				JOM(4, "    purb->iso_frame_desc[j].offset = j*%i;\n",
-					peasycap->audio_isoc_maxframesize);
-				JOM(4, "    purb->iso_frame_desc[j].length = %i;\n",
-					peasycap->audio_isoc_maxframesize);
-				JOM(4, "    }\n");
-			}
-
-			purb->interval = 1;
-			purb->dev = peasycap->pusb_device;
-			purb->pipe = usb_rcvisocpipe(peasycap->pusb_device,
-						peasycap->audio_endpointnumber);
-			purb->transfer_flags = URB_ISO_ASAP;
-			purb->transfer_buffer = peasycap->audio_isoc_buffer[k].pgo;
-			purb->transfer_buffer_length =
-						peasycap->audio_isoc_buffer_size;
-			purb->complete = easycap_alsa_complete;
-			purb->context = peasycap;
-			purb->start_frame = 0;
-			purb->number_of_packets = peasycap->audio_isoc_framesperdesc;
-			for (j = 0;  j < peasycap->audio_isoc_framesperdesc; j++) {
-				purb->iso_frame_desc[j].offset = j *
-						peasycap->audio_isoc_maxframesize;
-				purb->iso_frame_desc[j].length =
-						peasycap->audio_isoc_maxframesize;
-			}
-		}
-		JOM(4, "allocation of %i struct urb done.\n", k);
+		rc = create_audio_urbs(peasycap);
+		if (rc < 0)
+			return rc;
 
 		/* Save pointer peasycap in this interface */
 		usb_set_intfdata(intf, peasycap);
-- 
1.7.3.4

