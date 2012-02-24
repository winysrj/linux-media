Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:65384 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757222Ab2BXPYk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Feb 2012 10:24:40 -0500
Received: by yhoo21 with SMTP id o21so1155342yho.19
        for <linux-media@vger.kernel.org>; Fri, 24 Feb 2012 07:24:39 -0800 (PST)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: mchehab@infradead.org, gregkh@linuxfoundation.org
Cc: tomas.winkler@intel.com, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org, dan.carpenter@oracle.com,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH 1/9] staging: easycap: Split device struct alloc and retrieval code
Date: Fri, 24 Feb 2012 12:24:14 -0300
Message-Id: <1330097062-31663-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When the device is probed a driver struct is either
allocated or retrieved.
This operation is logically splitted in several functions.

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/staging/media/easycap/easycap_main.c |  384 +++++++++++++++-----------
 1 files changed, 216 insertions(+), 168 deletions(-)

diff --git a/drivers/staging/media/easycap/easycap_main.c b/drivers/staging/media/easycap/easycap_main.c
index d0fe34a..c4198be 100644
--- a/drivers/staging/media/easycap/easycap_main.c
+++ b/drivers/staging/media/easycap/easycap_main.c
@@ -2842,6 +2842,209 @@ static void easycap_complete(struct urb *purb)
 	return;
 }
 
+static struct easycap *alloc_easycap(u8 bInterfaceNumber)
+{
+	struct easycap *peasycap;
+	int i;
+
+	peasycap = kzalloc(sizeof(struct easycap), GFP_KERNEL);
+	if (!peasycap) {
+		SAY("ERROR: Could not allocate peasycap\n");
+		return NULL;
+	}
+
+	if (mutex_lock_interruptible(&mutex_dongle)) {
+		SAY("ERROR: cannot lock mutex_dongle\n");
+		kfree(peasycap);
+		return NULL;
+	}
+
+	/* Find a free dongle in easycapdc60_dongle array */
+	for (i = 0; i < DONGLE_MANY; i++) {
+
+		if ((!easycapdc60_dongle[i].peasycap) &&
+		    (!mutex_is_locked(&easycapdc60_dongle[i].mutex_video)) &&
+		    (!mutex_is_locked(&easycapdc60_dongle[i].mutex_audio))) {
+
+			easycapdc60_dongle[i].peasycap = peasycap;
+			peasycap->isdongle = i;
+			JOM(8, "intf[%i]: peasycap-->easycap"
+				"_dongle[%i].peasycap\n",
+				bInterfaceNumber, i);
+			break;
+		}
+	}
+
+	mutex_unlock(&mutex_dongle);
+
+	if (i >= DONGLE_MANY) {
+		SAM("ERROR: too many dongles\n");
+		kfree(peasycap);
+		return NULL;
+	}
+
+	return peasycap;
+}
+
+/*
+ * FIXME: Identify the appropriate pointer peasycap for interfaces
+ * 1 and 2. The address of peasycap->pusb_device is reluctantly used
+ * for this purpose.
+ */
+static struct easycap *get_easycap(struct usb_device *usbdev,
+				   u8 bInterfaceNumber)
+{
+	int i;
+	struct easycap *peasycap;
+
+	for (i = 0; i < DONGLE_MANY; i++) {
+		if (easycapdc60_dongle[i].peasycap->pusb_device == usbdev) {
+			peasycap = easycapdc60_dongle[i].peasycap;
+			JOT(8, "intf[%i]: dongle[%i].peasycap\n",
+					bInterfaceNumber, i);
+			break;
+		}
+	}
+	if (i >= DONGLE_MANY) {
+		SAY("ERROR: peasycap is unknown when probing interface %i\n",
+			bInterfaceNumber);
+		return NULL;
+	}
+	if (!peasycap) {
+		SAY("ERROR: peasycap is NULL when probing interface %i\n",
+			bInterfaceNumber);
+		return NULL;
+	}
+
+	return peasycap;
+}
+
+static void init_easycap(struct easycap *peasycap,
+			 struct usb_device *usbdev,
+			 struct usb_interface *intf,
+			 u8 bInterfaceNumber)
+{
+	/* Save usb_device and usb_interface */
+	peasycap->pusb_device = usbdev;
+	peasycap->pusb_interface = intf;
+
+	peasycap->minor = -1;
+	kref_init(&peasycap->kref);
+	JOM(8, "intf[%i]: after kref_init(..._video) "
+		"%i=peasycap->kref.refcount.counter\n",
+		bInterfaceNumber, peasycap->kref.refcount.counter);
+
+	/* module params */
+	peasycap->gain = (s8)clamp(easycap_gain, 0, 31);
+
+	init_waitqueue_head(&peasycap->wq_video);
+	init_waitqueue_head(&peasycap->wq_audio);
+	init_waitqueue_head(&peasycap->wq_trigger);
+
+	peasycap->allocation_video_struct = sizeof(struct easycap);
+
+	peasycap->microphone = false;
+
+	peasycap->video_interface = -1;
+	peasycap->video_altsetting_on = -1;
+	peasycap->video_altsetting_off = -1;
+	peasycap->video_endpointnumber = -1;
+	peasycap->video_isoc_maxframesize = -1;
+	peasycap->video_isoc_buffer_size = -1;
+
+	peasycap->audio_interface = -1;
+	peasycap->audio_altsetting_on = -1;
+	peasycap->audio_altsetting_off = -1;
+	peasycap->audio_endpointnumber = -1;
+	peasycap->audio_isoc_maxframesize = -1;
+	peasycap->audio_isoc_buffer_size = -1;
+
+	peasycap->frame_buffer_many = FRAME_BUFFER_MANY;
+}
+
+static int populate_inputset(struct easycap *peasycap)
+{
+	struct inputset *inputset;
+	struct easycap_format *peasycap_format;
+	struct v4l2_pix_format *pix;
+	int m, i, k, mask, fmtidx;
+	s32 value;
+
+	inputset = peasycap->inputset;
+
+	/* FIXME: peasycap->ntsc is not yet initialized */
+	fmtidx = peasycap->ntsc ? NTSC_M : PAL_BGHIN;
+
+	m = 0;
+	mask = 0;
+	for (i = 0; easycap_standard[i].mask != 0xffff; i++) {
+		if (fmtidx == easycap_standard[i].v4l2_standard.index) {
+			m++;
+			for (k = 0; k < INPUT_MANY; k++)
+				inputset[k].standard_offset = i;
+			mask = easycap_standard[i].mask;
+		}
+	}
+
+	if (m != 1) {
+		SAM("ERROR: inputset->standard_offset unpopulated, %i=m\n", m);
+		return -ENOENT;
+	}
+
+	peasycap_format = &easycap_format[0];
+	m = 0;
+	for (i = 0; peasycap_format->v4l2_format.fmt.pix.width; i++) {
+		pix = &peasycap_format->v4l2_format.fmt.pix;
+		if (((peasycap_format->mask & 0x0F) == (mask & 0x0F))
+			&& pix->field == V4L2_FIELD_NONE
+			&& pix->pixelformat == V4L2_PIX_FMT_UYVY
+			&& pix->width  == 640 && pix->height == 480) {
+			m++;
+			for (k = 0; k < INPUT_MANY; k++)
+				inputset[k].format_offset = i;
+			break;
+		}
+		peasycap_format++;
+	}
+	if (m != 1) {
+		SAM("ERROR: inputset[]->format_offset unpopulated\n");
+		return -ENOENT;
+	}
+
+	m = 0;
+	for (i = 0; easycap_control[i].id != 0xffffffff; i++) {
+		value = easycap_control[i].default_value;
+		if (V4L2_CID_BRIGHTNESS == easycap_control[i].id) {
+			m++;
+			for (k = 0; k < INPUT_MANY; k++)
+				inputset[k].brightness = value;
+		} else if (V4L2_CID_CONTRAST == easycap_control[i].id) {
+			m++;
+			for (k = 0; k < INPUT_MANY; k++)
+				inputset[k].contrast = value;
+		} else if (V4L2_CID_SATURATION == easycap_control[i].id) {
+			m++;
+			for (k = 0; k < INPUT_MANY; k++)
+				inputset[k].saturation = value;
+		} else if (V4L2_CID_HUE == easycap_control[i].id) {
+			m++;
+			for (k = 0; k < INPUT_MANY; k++)
+				inputset[k].hue = value;
+		}
+	}
+
+	if (m != 4) {
+		SAM("ERROR: inputset[]->brightness underpopulated\n");
+		return -ENOENT;
+	}
+
+	for (k = 0; k < INPUT_MANY; k++)
+		inputset[k].input = k;
+	JOM(4, "populated inputset[]\n");
+
+	return 0;
+}
+
 static const struct v4l2_file_operations v4l2_fops = {
 	.owner		= THIS_MODULE,
 	.open		= easycap_open_noinode,
@@ -2863,7 +3066,6 @@ static int easycap_usb_probe(struct usb_interface *intf,
 	struct usb_interface_descriptor *interface;
 	struct urb *purb;
 	struct easycap *peasycap;
-	int ndong;
 	struct data_urb *pdata_urb;
 	int i, j, k, m, rc;
 	u8 bInterfaceNumber;
@@ -2874,11 +3076,6 @@ static int easycap_usb_probe(struct usb_interface *intf,
 	int okepn[8];
 	int okmps[8];
 	int maxpacketsize;
-	u16 mask;
-	s32 value;
-	struct easycap_format *peasycap_format;
-	int fmtidx;
-	struct inputset *inputset;
 
 	usbdev = interface_to_usbdev(intf);
 
@@ -2916,76 +3113,16 @@ static int easycap_usb_probe(struct usb_interface *intf,
 	 * interfaces 1 and 2 are probed.
 	 */
 	if (0 == bInterfaceNumber) {
-		peasycap = kzalloc(sizeof(struct easycap), GFP_KERNEL);
-		if (!peasycap) {
-			SAY("ERROR: Could not allocate peasycap\n");
-			return -ENOMEM;
-		}
-
-		/* Perform urgent initializations */
-		peasycap->minor = -1;
-		kref_init(&peasycap->kref);
-		JOM(8, "intf[%i]: after kref_init(..._video) "
-				"%i=peasycap->kref.refcount.counter\n",
-				bInterfaceNumber, peasycap->kref.refcount.counter);
-
-		/* module params */
-		peasycap->gain = (s8)clamp(easycap_gain, 0, 31);
-
-		init_waitqueue_head(&peasycap->wq_video);
-		init_waitqueue_head(&peasycap->wq_audio);
-		init_waitqueue_head(&peasycap->wq_trigger);
-
-		if (mutex_lock_interruptible(&mutex_dongle)) {
-			SAY("ERROR: cannot down mutex_dongle\n");
-			return -ERESTARTSYS;
-		}
-
-		for (ndong = 0; ndong < DONGLE_MANY; ndong++) {
-			if ((!easycapdc60_dongle[ndong].peasycap) &&
-					(!mutex_is_locked(&easycapdc60_dongle
-						[ndong].mutex_video)) &&
-					(!mutex_is_locked(&easycapdc60_dongle
-						[ndong].mutex_audio))) {
-				easycapdc60_dongle[ndong].peasycap = peasycap;
-				peasycap->isdongle = ndong;
-				JOM(8, "intf[%i]: peasycap-->easycap"
-						"_dongle[%i].peasycap\n",
-						bInterfaceNumber, ndong);
-				break;
-			}
-		}
-
-		if (DONGLE_MANY <= ndong) {
-			SAM("ERROR: too many dongles\n");
-			mutex_unlock(&mutex_dongle);
+		/*
+		 * Alloc structure and save it in a free slot in
+		 * easycapdc60_dongle array
+		 */
+		peasycap = alloc_easycap(bInterfaceNumber);
+		if (!peasycap)
 			return -ENOMEM;
-		}
-		mutex_unlock(&mutex_dongle);
 
-		peasycap->allocation_video_struct = sizeof(struct easycap);
-
-		/* and further initialize the structure */
-		peasycap->pusb_device = usbdev;
-		peasycap->pusb_interface = intf;
-
-		peasycap->microphone = false;
-
-		peasycap->video_interface = -1;
-		peasycap->video_altsetting_on = -1;
-		peasycap->video_altsetting_off = -1;
-		peasycap->video_endpointnumber = -1;
-		peasycap->video_isoc_maxframesize = -1;
-		peasycap->video_isoc_buffer_size = -1;
-
-		peasycap->audio_interface = -1;
-		peasycap->audio_altsetting_on = -1;
-		peasycap->audio_altsetting_off = -1;
-		peasycap->audio_endpointnumber = -1;
-		peasycap->audio_isoc_maxframesize = -1;
-		peasycap->audio_isoc_buffer_size = -1;
-
-		peasycap->frame_buffer_many = FRAME_BUFFER_MANY;
+		/* Perform basic struct initialization */
+		init_easycap(peasycap, usbdev, intf, bInterfaceNumber);
 
 		/* Dynamically fill in the available formats */
 		rc = easycap_video_fillin_formats();
@@ -2996,103 +3133,14 @@ static int easycap_usb_probe(struct usb_interface *intf,
 		JOM(4, "%i formats available\n", rc);
 
 		/* Populate easycap.inputset[] */
-		inputset = peasycap->inputset;
-		fmtidx = peasycap->ntsc ? NTSC_M : PAL_BGHIN;
-		m = 0;
-		mask = 0;
-		for (i = 0; 0xFFFF != easycap_standard[i].mask; i++) {
-			if (fmtidx == easycap_standard[i].v4l2_standard.index) {
-				m++;
-				for (k = 0; k < INPUT_MANY; k++)
-					inputset[k].standard_offset = i;
-
-				mask = easycap_standard[i].mask;
-			}
-		}
-		if (1 != m) {
-			SAM("ERROR: "
-			    "inputset->standard_offset unpopulated, %i=m\n", m);
-			return -ENOENT;
-		}
-
-		peasycap_format = &easycap_format[0];
-		m = 0;
-		for (i = 0; peasycap_format->v4l2_format.fmt.pix.width; i++) {
-			struct v4l2_pix_format *pix =
-				&peasycap_format->v4l2_format.fmt.pix;
-			if (((peasycap_format->mask & 0x0F) == (mask & 0x0F)) &&
-			    pix->field == V4L2_FIELD_NONE &&
-			    pix->pixelformat == V4L2_PIX_FMT_UYVY &&
-			    pix->width  == 640 && pix->height == 480) {
-				m++;
-				for (k = 0; k < INPUT_MANY; k++)
-					inputset[k].format_offset = i;
-				break;
-			}
-			peasycap_format++;
-		}
-		if (1 != m) {
-			SAM("ERROR: inputset[]->format_offset unpopulated\n");
-			return -ENOENT;
-		}
-
-		m = 0;
-		for (i = 0; 0xFFFFFFFF != easycap_control[i].id; i++) {
-			value = easycap_control[i].default_value;
-			if (V4L2_CID_BRIGHTNESS == easycap_control[i].id) {
-				m++;
-				for (k = 0; k < INPUT_MANY; k++)
-					inputset[k].brightness = value;
-			} else if (V4L2_CID_CONTRAST == easycap_control[i].id) {
-				m++;
-				for (k = 0; k < INPUT_MANY; k++)
-					inputset[k].contrast = value;
-			} else if (V4L2_CID_SATURATION == easycap_control[i].id) {
-				m++;
-				for (k = 0; k < INPUT_MANY; k++)
-					inputset[k].saturation = value;
-			} else if (V4L2_CID_HUE == easycap_control[i].id) {
-				m++;
-				for (k = 0; k < INPUT_MANY; k++)
-					inputset[k].hue = value;
-			}
-		}
-
-		if (4 != m) {
-			SAM("ERROR: inputset[]->brightness underpopulated\n");
-			return -ENOENT;
-		}
-		for (k = 0; k < INPUT_MANY; k++)
-			inputset[k].input = k;
-		JOM(4, "populated inputset[]\n");
+		rc = populate_inputset(peasycap);
+		if (rc < 0)
+			return rc;
 		JOM(4, "finished initialization\n");
 	} else {
-
-		/*
-		 * FIXME: Identify the appropriate pointer
-		 * peasycap for interfaces 1 and 2.
-		 * The address of peasycap->pusb_device
-		 * is reluctantly used for this purpose.
-		 */
-		for (ndong = 0; ndong < DONGLE_MANY; ndong++) {
-			if (usbdev == easycapdc60_dongle[ndong].peasycap->
-									pusb_device) {
-				peasycap = easycapdc60_dongle[ndong].peasycap;
-				JOT(8, "intf[%i]: dongle[%i].peasycap\n",
-						bInterfaceNumber, ndong);
-				break;
-			}
-		}
-		if (DONGLE_MANY <= ndong) {
-			SAY("ERROR: peasycap is unknown when probing interface %i\n",
-								bInterfaceNumber);
+		peasycap = get_easycap(usbdev, bInterfaceNumber);
+		if (!peasycap)
 			return -ENODEV;
-		}
-		if (!peasycap) {
-			SAY("ERROR: peasycap is NULL when probing interface %i\n",
-								bInterfaceNumber);
-			return -ENODEV;
-		}
 	}
 
 	if ((USB_CLASS_VIDEO == bInterfaceClass) ||
-- 
1.7.3.4

