Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43519 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757222Ab2BXPYn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Feb 2012 10:24:43 -0500
Received: by ggnh1 with SMTP id h1so1169999ggn.19
        for <linux-media@vger.kernel.org>; Fri, 24 Feb 2012 07:24:42 -0800 (PST)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: mchehab@infradead.org, gregkh@linuxfoundation.org
Cc: tomas.winkler@intel.com, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org, dan.carpenter@oracle.com,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH 2/9] staging: easycap: Split buffer and video urb allocation
Date: Fri, 24 Feb 2012 12:24:15 -0300
Message-Id: <1330097062-31663-2-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1330097062-31663-1-git-send-email-elezegarcia@gmail.com>
References: <1330097062-31663-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When the device is probed, this driver allocates
frame buffers, field buffers, isoc buffers and urbs.
This patch just split this into separate functions,
which helps clearing the currently gigantic probe function.

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/staging/media/easycap/easycap_main.c |  375 +++++++++++++++-----------
 1 files changed, 211 insertions(+), 164 deletions(-)

diff --git a/drivers/staging/media/easycap/easycap_main.c b/drivers/staging/media/easycap/easycap_main.c
index c4198be..6d7cdef 100644
--- a/drivers/staging/media/easycap/easycap_main.c
+++ b/drivers/staging/media/easycap/easycap_main.c
@@ -3045,6 +3045,203 @@ static int populate_inputset(struct easycap *peasycap)
 	return 0;
 }
 
+static int alloc_framebuffers(struct easycap *peasycap)
+{
+	int i, j;
+	void *pbuf;
+
+	JOM(4, "allocating %i frame buffers of size %li\n",
+			FRAME_BUFFER_MANY, (long int)FRAME_BUFFER_SIZE);
+	JOM(4, ".... each scattered over %li pages\n",
+			FRAME_BUFFER_SIZE/PAGE_SIZE);
+
+	for (i = 0; i < FRAME_BUFFER_MANY; i++) {
+		for (j = 0; j < FRAME_BUFFER_SIZE/PAGE_SIZE; j++) {
+			if (peasycap->frame_buffer[i][j].pgo)
+				SAM("attempting to reallocate framebuffers\n");
+			else {
+				pbuf = (void *)__get_free_page(GFP_KERNEL);
+				if (!pbuf) {
+					SAM("ERROR: Could not allocate "
+					"framebuffer %i page %i\n", i, j);
+					return -ENOMEM;
+				}
+				peasycap->allocation_video_page += 1;
+				peasycap->frame_buffer[i][j].pgo = pbuf;
+			}
+			peasycap->frame_buffer[i][j].pto =
+			    peasycap->frame_buffer[i][j].pgo;
+		}
+	}
+
+	peasycap->frame_fill = 0;
+	peasycap->frame_read = 0;
+	JOM(4, "allocation of frame buffers done: %i pages\n", i*j);
+
+	return 0;
+}
+
+static int alloc_fieldbuffers(struct easycap *peasycap)
+{
+	int i, j;
+	void *pbuf;
+
+	JOM(4, "allocating %i field buffers of size %li\n",
+			FIELD_BUFFER_MANY, (long int)FIELD_BUFFER_SIZE);
+	JOM(4, ".... each scattered over %li pages\n",
+			FIELD_BUFFER_SIZE/PAGE_SIZE);
+
+	for (i = 0; i < FIELD_BUFFER_MANY; i++) {
+		for (j = 0; j < FIELD_BUFFER_SIZE/PAGE_SIZE; j++) {
+			if (peasycap->field_buffer[i][j].pgo) {
+				SAM("ERROR: attempting to reallocate "
+					"fieldbuffers\n");
+			} else {
+				pbuf = (void *) __get_free_page(GFP_KERNEL);
+				if (!pbuf) {
+					SAM("ERROR: Could not allocate "
+					"fieldbuffer %i page %i\n", i, j);
+					return -ENOMEM;
+				}
+				peasycap->allocation_video_page += 1;
+				peasycap->field_buffer[i][j].pgo = pbuf;
+			}
+			peasycap->field_buffer[i][j].pto =
+				peasycap->field_buffer[i][j].pgo;
+		}
+		/* TODO: Hardcoded 0x0200 meaning? */
+		peasycap->field_buffer[i][0].kount = 0x0200;
+	}
+	peasycap->field_fill = 0;
+	peasycap->field_page = 0;
+	peasycap->field_read = 0;
+	JOM(4, "allocation of field buffers done:  %i pages\n", i*j);
+
+	return 0;
+}
+
+static int alloc_isocbuffers(struct easycap *peasycap)
+{
+	int i;
+	void *pbuf;
+
+	JOM(4, "allocating %i isoc video buffers of size %i\n",
+			VIDEO_ISOC_BUFFER_MANY,
+			peasycap->video_isoc_buffer_size);
+	JOM(4, ".... each occupying contiguous memory pages\n");
+
+	for (i = 0; i < VIDEO_ISOC_BUFFER_MANY; i++) {
+		pbuf = (void *)__get_free_pages(GFP_KERNEL,
+				VIDEO_ISOC_ORDER);
+		if (!pbuf) {
+			SAM("ERROR: Could not allocate isoc "
+				"video buffer %i\n", i);
+			return -ENOMEM;
+		}
+		peasycap->allocation_video_page += BIT(VIDEO_ISOC_ORDER);
+
+		peasycap->video_isoc_buffer[i].pgo = pbuf;
+		peasycap->video_isoc_buffer[i].pto =
+			pbuf + peasycap->video_isoc_buffer_size;
+		peasycap->video_isoc_buffer[i].kount = i;
+	}
+	JOM(4, "allocation of isoc video buffers done: %i pages\n",
+			i * (0x01 << VIDEO_ISOC_ORDER));
+	return 0;
+}
+
+static int create_video_urbs(struct easycap *peasycap)
+{
+	struct urb *purb;
+	struct data_urb *pdata_urb;
+	int i, j;
+
+	JOM(4, "allocating %i struct urb.\n", VIDEO_ISOC_BUFFER_MANY);
+	JOM(4, "using %i=peasycap->video_isoc_framesperdesc\n",
+			peasycap->video_isoc_framesperdesc);
+	JOM(4, "using %i=peasycap->video_isoc_maxframesize\n",
+			peasycap->video_isoc_maxframesize);
+	JOM(4, "using %i=peasycap->video_isoc_buffer_sizen",
+			peasycap->video_isoc_buffer_size);
+
+	for (i = 0; i < VIDEO_ISOC_BUFFER_MANY; i++) {
+		purb = usb_alloc_urb(peasycap->video_isoc_framesperdesc,
+				GFP_KERNEL);
+		if (!purb) {
+			SAM("ERROR: usb_alloc_urb returned NULL for buffer "
+				"%i\n", i);
+			return -ENOMEM;
+		}
+
+		peasycap->allocation_video_urb += 1;
+		pdata_urb = kzalloc(sizeof(struct data_urb), GFP_KERNEL);
+		if (!pdata_urb) {
+			SAM("ERROR: Could not allocate struct data_urb.\n");
+			return -ENOMEM;
+		}
+
+		peasycap->allocation_video_struct +=
+			sizeof(struct data_urb);
+
+		pdata_urb->purb = purb;
+		pdata_urb->isbuf = i;
+		pdata_urb->length = 0;
+		list_add_tail(&(pdata_urb->list_head),
+				peasycap->purb_video_head);
+
+		if (!i) {
+			JOM(4, "initializing video urbs thus:\n");
+			JOM(4, "  purb->interval = 1;\n");
+			JOM(4, "  purb->dev = peasycap->pusb_device;\n");
+			JOM(4, "  purb->pipe = usb_rcvisocpipe"
+					"(peasycap->pusb_device,%i);\n",
+					peasycap->video_endpointnumber);
+			JOM(4, "  purb->transfer_flags = URB_ISO_ASAP;\n");
+			JOM(4, "  purb->transfer_buffer = peasycap->"
+					"video_isoc_buffer[.].pgo;\n");
+			JOM(4, "  purb->transfer_buffer_length = %i;\n",
+					peasycap->video_isoc_buffer_size);
+			JOM(4, "  purb->complete = easycap_complete;\n");
+			JOM(4, "  purb->context = peasycap;\n");
+			JOM(4, "  purb->start_frame = 0;\n");
+			JOM(4, "  purb->number_of_packets = %i;\n",
+					peasycap->video_isoc_framesperdesc);
+			JOM(4, "  for (j = 0; j < %i; j++)\n",
+					peasycap->video_isoc_framesperdesc);
+			JOM(4, "    {\n");
+			JOM(4, "    purb->iso_frame_desc[j].offset = j*%i;\n",
+					peasycap->video_isoc_maxframesize);
+			JOM(4, "    purb->iso_frame_desc[j].length = %i;\n",
+					peasycap->video_isoc_maxframesize);
+			JOM(4, "    }\n");
+		}
+
+		purb->interval = 1;
+		purb->dev = peasycap->pusb_device;
+		purb->pipe = usb_rcvisocpipe(peasycap->pusb_device,
+				peasycap->video_endpointnumber);
+
+		purb->transfer_flags = URB_ISO_ASAP;
+		purb->transfer_buffer = peasycap->video_isoc_buffer[i].pgo;
+		purb->transfer_buffer_length =
+			peasycap->video_isoc_buffer_size;
+
+		purb->complete = easycap_complete;
+		purb->context = peasycap;
+		purb->start_frame = 0;
+		purb->number_of_packets = peasycap->video_isoc_framesperdesc;
+
+		for (j = 0; j < peasycap->video_isoc_framesperdesc; j++) {
+			purb->iso_frame_desc[j].offset =
+				j * peasycap->video_isoc_maxframesize;
+			purb->iso_frame_desc[j].length =
+				peasycap->video_isoc_maxframesize;
+		}
+	}
+	JOM(4, "allocation of %i struct urb done.\n", i);
+	return 0;
+}
+
 static const struct v4l2_file_operations v4l2_fops = {
 	.owner		= THIS_MODULE,
 	.open		= easycap_open_noinode,
@@ -3067,7 +3264,7 @@ static int easycap_usb_probe(struct usb_interface *intf,
 	struct urb *purb;
 	struct easycap *peasycap;
 	struct data_urb *pdata_urb;
-	int i, j, k, m, rc;
+	int i, j, k, rc;
 	u8 bInterfaceNumber;
 	u8 bInterfaceClass;
 	u8 bInterfaceSubClass;
@@ -3416,173 +3613,23 @@ static int easycap_usb_probe(struct usb_interface *intf,
 		 */
 		INIT_LIST_HEAD(&(peasycap->urb_video_head));
 		peasycap->purb_video_head = &(peasycap->urb_video_head);
-		JOM(4, "allocating %i frame buffers of size %li\n",
-				FRAME_BUFFER_MANY, (long int)FRAME_BUFFER_SIZE);
-		JOM(4, ".... each scattered over %li pages\n",
-							FRAME_BUFFER_SIZE/PAGE_SIZE);
-
-		for (k = 0;  k < FRAME_BUFFER_MANY;  k++) {
-			for (m = 0;  m < FRAME_BUFFER_SIZE/PAGE_SIZE;  m++) {
-				if (peasycap->frame_buffer[k][m].pgo)
-					SAM("attempting to reallocate frame "
-									" buffers\n");
-				else {
-					pbuf = (void *)__get_free_page(GFP_KERNEL);
-					if (!pbuf) {
-						SAM("ERROR: Could not allocate frame "
-							"buffer %i page %i\n", k, m);
-						return -ENOMEM;
-					}
-
-					peasycap->allocation_video_page += 1;
-					peasycap->frame_buffer[k][m].pgo = pbuf;
-				}
-				peasycap->frame_buffer[k][m].pto =
-						peasycap->frame_buffer[k][m].pgo;
-			}
-		}
 
-		peasycap->frame_fill = 0;
-		peasycap->frame_read = 0;
-		JOM(4, "allocation of frame buffers done:  %i pages\n", k *
-									m);
-		JOM(4, "allocating %i field buffers of size %li\n",
-				FIELD_BUFFER_MANY, (long int)FIELD_BUFFER_SIZE);
-		JOM(4, ".... each scattered over %li pages\n",
-						FIELD_BUFFER_SIZE/PAGE_SIZE);
-
-		for (k = 0;  k < FIELD_BUFFER_MANY;  k++) {
-			for (m = 0;  m < FIELD_BUFFER_SIZE/PAGE_SIZE;  m++) {
-				if (peasycap->field_buffer[k][m].pgo) {
-					SAM("ERROR: attempting to reallocate "
-								"field buffers\n");
-				} else {
-					pbuf = (void *) __get_free_page(GFP_KERNEL);
-					if (!pbuf) {
-						SAM("ERROR: Could not allocate field"
-							" buffer %i page %i\n", k, m);
-						return -ENOMEM;
-					}
-
-					peasycap->allocation_video_page += 1;
-					peasycap->field_buffer[k][m].pgo = pbuf;
-				}
-				peasycap->field_buffer[k][m].pto =
-						peasycap->field_buffer[k][m].pgo;
-			}
-			peasycap->field_buffer[k][0].kount = 0x0200;
-		}
-		peasycap->field_fill = 0;
-		peasycap->field_page = 0;
-		peasycap->field_read = 0;
-		JOM(4, "allocation of field buffers done:  %i pages\n", k *
-									m);
-		JOM(4, "allocating %i isoc video buffers of size %i\n",
-						VIDEO_ISOC_BUFFER_MANY,
-						peasycap->video_isoc_buffer_size);
-		JOM(4, ".... each occupying contiguous memory pages\n");
-
-		for (k = 0;  k < VIDEO_ISOC_BUFFER_MANY; k++) {
-			pbuf = (void *)__get_free_pages(GFP_KERNEL,
-							VIDEO_ISOC_ORDER);
-			if (!pbuf) {
-				SAM("ERROR: Could not allocate isoc video buffer "
-									"%i\n", k);
-				return -ENOMEM;
-			}
-			peasycap->allocation_video_page +=
-						BIT(VIDEO_ISOC_ORDER);
-
-			peasycap->video_isoc_buffer[k].pgo = pbuf;
-			peasycap->video_isoc_buffer[k].pto =
-				pbuf + peasycap->video_isoc_buffer_size;
-			peasycap->video_isoc_buffer[k].kount = k;
-		}
-		JOM(4, "allocation of isoc video buffers done: %i pages\n",
-						k * (0x01 << VIDEO_ISOC_ORDER));
-
-		/* Allocate and initialize multiple struct usb */
-		JOM(4, "allocating %i struct urb.\n", VIDEO_ISOC_BUFFER_MANY);
-		JOM(4, "using %i=peasycap->video_isoc_framesperdesc\n",
-						peasycap->video_isoc_framesperdesc);
-		JOM(4, "using %i=peasycap->video_isoc_maxframesize\n",
-						peasycap->video_isoc_maxframesize);
-		JOM(4, "using %i=peasycap->video_isoc_buffer_sizen",
-						peasycap->video_isoc_buffer_size);
-
-		for (k = 0;  k < VIDEO_ISOC_BUFFER_MANY; k++) {
-			purb = usb_alloc_urb(peasycap->video_isoc_framesperdesc,
-									GFP_KERNEL);
-			if (!purb) {
-				SAM("ERROR: usb_alloc_urb returned NULL for buffer "
-									"%i\n", k);
-				return -ENOMEM;
-			}
-
-			peasycap->allocation_video_urb += 1;
-			pdata_urb = kzalloc(sizeof(struct data_urb), GFP_KERNEL);
-			if (!pdata_urb) {
-				SAM("ERROR: Could not allocate struct data_urb.\n");
-				return -ENOMEM;
-			}
-
-			peasycap->allocation_video_struct +=
-							sizeof(struct data_urb);
+		rc = alloc_framebuffers(peasycap);
+		if (rc < 0)
+			return rc;
 
-			pdata_urb->purb = purb;
-			pdata_urb->isbuf = k;
-			pdata_urb->length = 0;
-			list_add_tail(&(pdata_urb->list_head),
-							peasycap->purb_video_head);
+		rc = alloc_fieldbuffers(peasycap);
+		if (rc < 0)
+			return rc;
 
-			/* Initialize allocated urbs */
-			if (!k) {
-				JOM(4, "initializing video urbs thus:\n");
-				JOM(4, "  purb->interval = 1;\n");
-				JOM(4, "  purb->dev = peasycap->pusb_device;\n");
-				JOM(4, "  purb->pipe = usb_rcvisocpipe"
-						"(peasycap->pusb_device,%i);\n",
-						peasycap->video_endpointnumber);
-				JOM(4, "  purb->transfer_flags = URB_ISO_ASAP;\n");
-				JOM(4, "  purb->transfer_buffer = peasycap->"
-						"video_isoc_buffer[.].pgo;\n");
-				JOM(4, "  purb->transfer_buffer_length = %i;\n",
-						peasycap->video_isoc_buffer_size);
-				JOM(4, "  purb->complete = easycap_complete;\n");
-				JOM(4, "  purb->context = peasycap;\n");
-				JOM(4, "  purb->start_frame = 0;\n");
-				JOM(4, "  purb->number_of_packets = %i;\n",
-						peasycap->video_isoc_framesperdesc);
-				JOM(4, "  for (j = 0; j < %i; j++)\n",
-						peasycap->video_isoc_framesperdesc);
-				JOM(4, "    {\n");
-				JOM(4, "    purb->iso_frame_desc[j].offset = j*%i;\n",
-						peasycap->video_isoc_maxframesize);
-				JOM(4, "    purb->iso_frame_desc[j].length = %i;\n",
-						peasycap->video_isoc_maxframesize);
-				JOM(4, "    }\n");
-			}
+		rc = alloc_isocbuffers(peasycap);
+		if (rc < 0)
+			return rc;
 
-			purb->interval = 1;
-			purb->dev = peasycap->pusb_device;
-			purb->pipe = usb_rcvisocpipe(peasycap->pusb_device,
-						peasycap->video_endpointnumber);
-			purb->transfer_flags = URB_ISO_ASAP;
-			purb->transfer_buffer = peasycap->video_isoc_buffer[k].pgo;
-			purb->transfer_buffer_length =
-						peasycap->video_isoc_buffer_size;
-			purb->complete = easycap_complete;
-			purb->context = peasycap;
-			purb->start_frame = 0;
-			purb->number_of_packets = peasycap->video_isoc_framesperdesc;
-			for (j = 0;  j < peasycap->video_isoc_framesperdesc; j++) {
-				purb->iso_frame_desc[j].offset = j *
-						peasycap->video_isoc_maxframesize;
-				purb->iso_frame_desc[j].length =
-						peasycap->video_isoc_maxframesize;
-			}
-		}
-		JOM(4, "allocation of %i struct urb done.\n", k);
+		/* Allocate and initialize video urbs */
+		rc = create_video_urbs(peasycap);
+		if (rc < 0)
+			return rc;
 
 		/* Save pointer peasycap in this interface */
 		usb_set_intfdata(intf, peasycap);
-- 
1.7.3.4

