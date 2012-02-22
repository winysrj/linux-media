Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46288 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab2BVWqk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Feb 2012 17:46:40 -0500
Received: by yenm8 with SMTP id m8so348769yen.19
        for <linux-media@vger.kernel.org>; Wed, 22 Feb 2012 14:46:39 -0800 (PST)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: mchehab@infradead.org, gregkh@linuxfoundation.org
Cc: tomas.winkler@intel.com, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org, dan.carpenter@oracle.com,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH V2 1/2] staging: easycap: Clean comment style in easycap_usb_probe()
Date: Wed, 22 Feb 2012 19:46:14 -0300
Message-Id: <1329950775-2059-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some of these comments may still need to be reviewed.
This patch only cleans the comment style.

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
V2: Fix comment style and resend patch to proper maintainers.

 drivers/staging/media/easycap/easycap_main.c |  243 +++++++++-----------------
 1 files changed, 79 insertions(+), 164 deletions(-)

diff --git a/drivers/staging/media/easycap/easycap_main.c b/drivers/staging/media/easycap/easycap_main.c
index 3d439b7..95f3cc1 100644
--- a/drivers/staging/media/easycap/easycap_main.c
+++ b/drivers/staging/media/easycap/easycap_main.c
@@ -2849,13 +2849,11 @@ static const struct v4l2_file_operations v4l2_fops = {
 	.poll		= easycap_poll,
 	.mmap		= easycap_mmap,
 };
-/*****************************************************************************/
-/*---------------------------------------------------------------------------*/
+
 /*
- *  WHEN THE EasyCAP IS PHYSICALLY PLUGGED IN, THIS FUNCTION IS CALLED THREE
- *  TIMES, ONCE FOR EACH OF THE THREE INTERFACES.  BEWARE.
+ * When the device is plugged, this function is called three times,
+ * one for each interface.
  */
-/*---------------------------------------------------------------------------*/
 static int easycap_usb_probe(struct usb_interface *intf,
 			    const struct usb_device_id *id)
 {
@@ -2884,7 +2882,6 @@ static int easycap_usb_probe(struct usb_interface *intf,
 
 	usbdev = interface_to_usbdev(intf);
 
-/*---------------------------------------------------------------------------*/
 	alt = usb_altnum_to_altsetting(intf, 0);
 	if (!alt) {
 		SAY("ERROR: usb_host_interface not found\n");
@@ -2896,11 +2893,8 @@ static int easycap_usb_probe(struct usb_interface *intf,
 		SAY("ERROR: intf_descriptor is NULL\n");
 		return -EFAULT;
 	}
-/*---------------------------------------------------------------------------*/
-/*
- *  GET PROPERTIES OF PROBED INTERFACE
- */
-/*---------------------------------------------------------------------------*/
+
+	/* Get properties of probed interface */
 	bInterfaceNumber = interface->bInterfaceNumber;
 	bInterfaceClass = interface->bInterfaceClass;
 	bInterfaceSubClass = interface->bInterfaceSubClass;
@@ -2912,28 +2906,23 @@ static int easycap_usb_probe(struct usb_interface *intf,
 		(long int)(intf->cur_altsetting - intf->altsetting));
 	JOT(4, "intf[%i]: bInterfaceClass=0x%02X bInterfaceSubClass=0x%02X\n",
 			bInterfaceNumber, bInterfaceClass, bInterfaceSubClass);
-/*---------------------------------------------------------------------------*/
-/*
- *  A NEW struct easycap IS ALWAYS ALLOCATED WHEN INTERFACE 0 IS PROBED.
- *  IT IS NOT POSSIBLE HERE TO FREE ANY EXISTING struct easycap.  THIS
- *  SHOULD HAVE BEEN DONE BY easycap_delete() WHEN THE EasyCAP WAS
- *  PHYSICALLY UNPLUGGED.
- *
- *  THE POINTER peasycap TO THE struct easycap IS REMEMBERED WHEN
- *  INTERFACES 1 AND 2 ARE PROBED.
-*/
-/*---------------------------------------------------------------------------*/
+
+	/*
+	 * A new struct easycap is always allocated when interface 0 is probed.
+	 * It is not possible here to free any existing struct easycap.
+	 * This should have been done by easycap_delete() when the device was
+	 * physically unplugged.
+	 * The allocated struct easycap is saved for later usage when
+	 * interfaces 1 and 2 are probed.
+	 */
 	if (0 == bInterfaceNumber) {
 		peasycap = kzalloc(sizeof(struct easycap), GFP_KERNEL);
 		if (!peasycap) {
 			SAY("ERROR: Could not allocate peasycap\n");
 			return -ENOMEM;
 		}
-/*---------------------------------------------------------------------------*/
-/*
- *  PERFORM URGENT INTIALIZATIONS ...
-*/
-/*---------------------------------------------------------------------------*/
+
+		/* Perform urgent initializations */
 		peasycap->minor = -1;
 		kref_init(&peasycap->kref);
 		JOM(8, "intf[%i]: after kref_init(..._video) "
@@ -2976,11 +2965,7 @@ static int easycap_usb_probe(struct usb_interface *intf,
 
 		peasycap->allocation_video_struct = sizeof(struct easycap);
 
-/*---------------------------------------------------------------------------*/
-/*
- *  ... AND FURTHER INITIALIZE THE STRUCTURE
-*/
-/*---------------------------------------------------------------------------*/
+		/* and further initialize the structure */
 		peasycap->pusb_device = usbdev;
 		peasycap->pusb_interface = intf;
 
@@ -3002,11 +2987,7 @@ static int easycap_usb_probe(struct usb_interface *intf,
 
 		peasycap->frame_buffer_many = FRAME_BUFFER_MANY;
 
-/*---------------------------------------------------------------------------*/
-/*
- *  DYNAMICALLY FILL IN THE AVAILABLE FORMATS ...
- */
-/*---------------------------------------------------------------------------*/
+		/* Dynamically fill in the available formats */
 		rc = easycap_video_fillin_formats();
 		if (0 > rc) {
 			SAM("ERROR: fillin_formats() rc = %i\n", rc);
@@ -3014,10 +2995,8 @@ static int easycap_usb_probe(struct usb_interface *intf,
 		}
 		JOM(4, "%i formats available\n", rc);
 
-		/*  ... AND POPULATE easycap.inputset[] */
-
+		/* Populate easycap.inputset[] */
 		inputset = peasycap->inputset;
-
 		fmtidx = peasycap->ntsc ? NTSC_M : PAL_BGHIN;
 		m = 0;
 		mask = 0;
@@ -3030,7 +3009,6 @@ static int easycap_usb_probe(struct usb_interface *intf,
 				mask = easycap_standard[i].mask;
 			}
 		}
-
 		if (1 != m) {
 			SAM("ERROR: "
 			    "inputset->standard_offset unpopulated, %i=m\n", m);
@@ -3089,14 +3067,13 @@ static int easycap_usb_probe(struct usb_interface *intf,
 		JOM(4, "populated inputset[]\n");
 		JOM(4, "finished initialization\n");
 	} else {
-/*---------------------------------------------------------------------------*/
-/*
- *                                 FIXME
- *
- *  IDENTIFY THE APPROPRIATE POINTER peasycap FOR INTERFACES 1 AND 2.
- *  THE ADDRESS OF peasycap->pusb_device IS RELUCTANTLY USED FOR THIS PURPOSE.
- */
-/*---------------------------------------------------------------------------*/
+
+		/*
+		 * FIXME: Identify the appropriate pointer
+		 * peasycap for interfaces 1 and 2.
+		 * The address of peasycap->pusb_device
+		 * is reluctantly used for this purpose.
+		 */
 		for (ndong = 0; ndong < DONGLE_MANY; ndong++) {
 			if (usbdev == easycapdc60_dongle[ndong].peasycap->
 									pusb_device) {
@@ -3117,7 +3094,7 @@ static int easycap_usb_probe(struct usb_interface *intf,
 			return -ENODEV;
 		}
 	}
-/*---------------------------------------------------------------------------*/
+
 	if ((USB_CLASS_VIDEO == bInterfaceClass) ||
 	    (USB_CLASS_VENDOR_SPEC == bInterfaceClass)) {
 		if (-1 == peasycap->video_interface) {
@@ -3149,14 +3126,12 @@ static int easycap_usb_probe(struct usb_interface *intf,
 			}
 		}
 	}
-/*---------------------------------------------------------------------------*/
-/*
- *  INVESTIGATE ALL ALTSETTINGS.
- *  DONE IN DETAIL BECAUSE USB DEVICE 05e1:0408 HAS DISPARATE INCARNATIONS.
- */
-/*---------------------------------------------------------------------------*/
-	isokalt = 0;
 
+	/*
+	 * Investigate all altsettings. This is done in detail
+	 * because USB device 05e1:0408 has disparate incarnations.
+	 */
+	isokalt = 0;
 	for (i = 0; i < intf->num_altsetting; i++) {
 		alt = usb_altnum_to_altsetting(intf, i);
 		if (!alt) {
@@ -3172,7 +3147,6 @@ static int easycap_usb_probe(struct usb_interface *intf,
 		if (0 == interface->bNumEndpoints)
 			JOM(4, "intf[%i]alt[%i] has no endpoints\n",
 						bInterfaceNumber, i);
-/*---------------------------------------------------------------------------*/
 		for (j = 0; j < interface->bNumEndpoints; j++) {
 			ep = &alt->endpoint[j].desc;
 			if (!ep) {
@@ -3312,19 +3286,12 @@ static int easycap_usb_probe(struct usb_interface *intf,
 			}
 		}
 	}
-/*---------------------------------------------------------------------------*/
-/*
- *  PERFORM INITIALIZATION OF THE PROBED INTERFACE
- */
-/*---------------------------------------------------------------------------*/
+
+	/* Perform initialization of the probed interface */
 	JOM(4, "initialization begins for interface %i\n",
 		interface->bInterfaceNumber);
 	switch (bInterfaceNumber) {
-/*---------------------------------------------------------------------------*/
-/*
- *  INTERFACE 0 IS THE VIDEO INTERFACE
- */
-/*---------------------------------------------------------------------------*/
+	/* 0: Video interface */
 	case 0: {
 		if (!peasycap) {
 			SAM("MISTAKE: peasycap is NULL\n");
@@ -3337,11 +3304,8 @@ static int easycap_usb_probe(struct usb_interface *intf,
 		peasycap->video_altsetting_on = okalt[isokalt - 1];
 		JOM(4, "%i=video_altsetting_on <====\n",
 					peasycap->video_altsetting_on);
-/*---------------------------------------------------------------------------*/
-/*
- *  DECIDE THE VIDEO STREAMING PARAMETERS
- */
-/*---------------------------------------------------------------------------*/
+
+		/* Decide video streaming parameters */
 		peasycap->video_endpointnumber = okepn[isokalt - 1];
 		JOM(4, "%i=video_endpointnumber\n", peasycap->video_endpointnumber);
 		maxpacketsize = okmps[isokalt - 1];
@@ -3373,7 +3337,6 @@ static int easycap_usb_probe(struct usb_interface *intf,
 			SAM("MISTAKE: peasycap->video_isoc_buffer_size too big\n");
 			return -EFAULT;
 		}
-/*---------------------------------------------------------------------------*/
 		if (-1 == peasycap->video_interface) {
 			SAM("MISTAKE:  video_interface is unset\n");
 			return -EFAULT;
@@ -3398,14 +3361,13 @@ static int easycap_usb_probe(struct usb_interface *intf,
 			SAM("MISTAKE:  video_isoc_buffer_size is unset\n");
 			return -EFAULT;
 		}
-/*---------------------------------------------------------------------------*/
-/*
- *  ALLOCATE MEMORY FOR VIDEO BUFFERS.  LISTS MUST BE INITIALIZED FIRST.
- */
-/*---------------------------------------------------------------------------*/
+
+		/*
+		 * Allocate memory for video buffers.
+		 * Lists must be initialized first.
+		 */
 		INIT_LIST_HEAD(&(peasycap->urb_video_head));
 		peasycap->purb_video_head = &(peasycap->urb_video_head);
-/*---------------------------------------------------------------------------*/
 		JOM(4, "allocating %i frame buffers of size %li\n",
 				FRAME_BUFFER_MANY, (long int)FRAME_BUFFER_SIZE);
 		JOM(4, ".... each scattered over %li pages\n",
@@ -3436,7 +3398,6 @@ static int easycap_usb_probe(struct usb_interface *intf,
 		peasycap->frame_read = 0;
 		JOM(4, "allocation of frame buffers done:  %i pages\n", k *
 									m);
-/*---------------------------------------------------------------------------*/
 		JOM(4, "allocating %i field buffers of size %li\n",
 				FIELD_BUFFER_MANY, (long int)FIELD_BUFFER_SIZE);
 		JOM(4, ".... each scattered over %li pages\n",
@@ -3468,7 +3429,6 @@ static int easycap_usb_probe(struct usb_interface *intf,
 		peasycap->field_read = 0;
 		JOM(4, "allocation of field buffers done:  %i pages\n", k *
 									m);
-/*---------------------------------------------------------------------------*/
 		JOM(4, "allocating %i isoc video buffers of size %i\n",
 						VIDEO_ISOC_BUFFER_MANY,
 						peasycap->video_isoc_buffer_size);
@@ -3492,11 +3452,8 @@ static int easycap_usb_probe(struct usb_interface *intf,
 		}
 		JOM(4, "allocation of isoc video buffers done: %i pages\n",
 						k * (0x01 << VIDEO_ISOC_ORDER));
-/*---------------------------------------------------------------------------*/
-/*
- *  ALLOCATE AND INITIALIZE MULTIPLE struct urb ...
- */
-/*---------------------------------------------------------------------------*/
+
+		/* Allocate and initialize multiple struct usb */
 		JOM(4, "allocating %i struct urb.\n", VIDEO_ISOC_BUFFER_MANY);
 		JOM(4, "using %i=peasycap->video_isoc_framesperdesc\n",
 						peasycap->video_isoc_framesperdesc);
@@ -3515,7 +3472,6 @@ static int easycap_usb_probe(struct usb_interface *intf,
 			}
 
 			peasycap->allocation_video_urb += 1;
-/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
 			pdata_urb = kzalloc(sizeof(struct data_urb), GFP_KERNEL);
 			if (!pdata_urb) {
 				SAM("ERROR: Could not allocate struct data_urb.\n");
@@ -3530,11 +3486,8 @@ static int easycap_usb_probe(struct usb_interface *intf,
 			pdata_urb->length = 0;
 			list_add_tail(&(pdata_urb->list_head),
 							peasycap->purb_video_head);
-/*---------------------------------------------------------------------------*/
-/*
- *  ... AND INITIALIZE THEM
- */
-/*---------------------------------------------------------------------------*/
+
+			/* Initialize allocated urbs */
 			if (!k) {
 				JOM(4, "initializing video urbs thus:\n");
 				JOM(4, "  purb->interval = 1;\n");
@@ -3582,20 +3535,17 @@ static int easycap_usb_probe(struct usb_interface *intf,
 			}
 		}
 		JOM(4, "allocation of %i struct urb done.\n", k);
-/*--------------------------------------------------------------------------*/
-/*
- *  SAVE POINTER peasycap IN THIS INTERFACE.
- */
-/*--------------------------------------------------------------------------*/
+
+		/* Save pointer peasycap in this interface */
 		usb_set_intfdata(intf, peasycap);
-/*---------------------------------------------------------------------------*/
-/*
- *  IT IS ESSENTIAL TO INITIALIZE THE HARDWARE BEFORE, RATHER THAN AFTER,
- *  THE DEVICE IS REGISTERED, BECAUSE SOME VERSIONS OF THE videodev MODULE
- *  CALL easycap_open() IMMEDIATELY AFTER REGISTRATION, CAUSING A CLASH.
- *  BEWARE.
-*/
-/*---------------------------------------------------------------------------*/
+
+		/*
+		 * It is essential to initialize the hardware before,
+		 * rather than after, the device is registered,
+		 * because some versions of the videodev module
+		 * call easycap_open() immediately after registration,
+		 * causing a clash.
+		 */
 		peasycap->ntsc = easycap_ntsc;
 		JOM(8, "defaulting initially to %s\n",
 			easycap_ntsc ? "NTSC" : "PAL");
@@ -3604,27 +3554,20 @@ static int easycap_usb_probe(struct usb_interface *intf,
 			SAM("ERROR: reset() rc = %i\n", rc);
 			return -EFAULT;
 		}
-/*--------------------------------------------------------------------------*/
-/*
- *  THE VIDEO DEVICE CAN BE REGISTERED NOW, AS IT IS READY.
- */
-/*--------------------------------------------------------------------------*/
+
+		/* The video device can now be registered */
 		if (v4l2_device_register(&intf->dev, &peasycap->v4l2_device)) {
 			SAM("v4l2_device_register() failed\n");
 			return -ENODEV;
 		}
 		JOM(4, "registered device instance: %s\n",
 			peasycap->v4l2_device.name);
-/*---------------------------------------------------------------------------*/
-/*
- *                                 FIXME
- *
- *
- *  THIS IS BELIEVED TO BE HARMLESS, BUT MAY WELL BE UNNECESSARY OR WRONG:
-*/
-/*---------------------------------------------------------------------------*/
+
+		/*
+		 * FIXME: This is believed to be harmless,
+		 * but may well be unnecessary or wrong.
+		 */
 		peasycap->video_device.v4l2_dev = NULL;
-/*---------------------------------------------------------------------------*/
 
 
 		strcpy(&peasycap->video_device.name[0], "easycapdc60");
@@ -3648,28 +3591,19 @@ static int easycap_usb_probe(struct usb_interface *intf,
 
 		break;
 	}
-/*--------------------------------------------------------------------------*/
-/*
- *  INTERFACE 1 IS THE AUDIO CONTROL INTERFACE
- *  INTERFACE 2 IS THE AUDIO STREAMING INTERFACE
- */
-/*--------------------------------------------------------------------------*/
+	/* 1: Audio control */
 	case 1: {
 		if (!peasycap) {
 			SAM("MISTAKE: peasycap is NULL\n");
 			return -EFAULT;
 		}
-/*--------------------------------------------------------------------------*/
-/*
- *  SAVE POINTER peasycap IN INTERFACE 1
- */
-/*--------------------------------------------------------------------------*/
+		/* Save pointer peasycap in this interface */
 		usb_set_intfdata(intf, peasycap);
 		JOM(4, "no initialization required for interface %i\n",
 					interface->bInterfaceNumber);
 		break;
 	}
-/*--------------------------------------------------------------------------*/
+	/* 2: Audio streaming */
 	case 2: {
 		if (!peasycap) {
 			SAM("MISTAKE: peasycap is NULL\n");
@@ -3769,15 +3703,14 @@ static int easycap_usb_probe(struct usb_interface *intf,
 			SAM("MISTAKE:  audio_isoc_buffer_size is unset\n");
 			return -EFAULT;
 		}
-/*---------------------------------------------------------------------------*/
-/*
- *  ALLOCATE MEMORY FOR AUDIO BUFFERS.  LISTS MUST BE INITIALIZED FIRST.
- */
-/*---------------------------------------------------------------------------*/
+
+		/*
+		 * Allocate memory for audio buffers.
+		 * Lists must be initialized first.
+		 */
 		INIT_LIST_HEAD(&(peasycap->urb_audio_head));
 		peasycap->purb_audio_head = &(peasycap->urb_audio_head);
 
-/*---------------------------------------------------------------------------*/
 		JOM(4, "allocating %i isoc audio buffers of size %i\n",
 			AUDIO_ISOC_BUFFER_MANY,
 			peasycap->audio_isoc_buffer_size);
@@ -3800,11 +3733,8 @@ static int easycap_usb_probe(struct usb_interface *intf,
 			peasycap->audio_isoc_buffer[k].kount = k;
 		}
 		JOM(4, "allocation of isoc audio buffers done.\n");
-/*---------------------------------------------------------------------------*/
-/*
- *  ALLOCATE AND INITIALIZE MULTIPLE struct urb ...
- */
-/*---------------------------------------------------------------------------*/
+
+		/* Allocate and initialize urbs */
 		JOM(4, "allocating %i struct urb.\n", AUDIO_ISOC_BUFFER_MANY);
 		JOM(4, "using %i=peasycap->audio_isoc_framesperdesc\n",
 					peasycap->audio_isoc_framesperdesc);
@@ -3822,7 +3752,6 @@ static int easycap_usb_probe(struct usb_interface *intf,
 				return -ENOMEM;
 			}
 			peasycap->allocation_audio_urb += 1 ;
-/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
 			pdata_urb = kzalloc(sizeof(struct data_urb), GFP_KERNEL);
 			if (!pdata_urb) {
 				usb_free_urb(purb);
@@ -3837,11 +3766,7 @@ static int easycap_usb_probe(struct usb_interface *intf,
 			pdata_urb->length = 0;
 			list_add_tail(&(pdata_urb->list_head),
 							peasycap->purb_audio_head);
-/*---------------------------------------------------------------------------*/
-/*
- *  ... AND INITIALIZE THEM
- */
-/*---------------------------------------------------------------------------*/
+
 			if (!k) {
 				JOM(4, "initializing audio urbs thus:\n");
 				JOM(4, "  purb->interval = 1;\n");
@@ -3889,17 +3814,11 @@ static int easycap_usb_probe(struct usb_interface *intf,
 			}
 		}
 		JOM(4, "allocation of %i struct urb done.\n", k);
-/*---------------------------------------------------------------------------*/
-/*
- *  SAVE POINTER peasycap IN THIS INTERFACE.
- */
-/*---------------------------------------------------------------------------*/
+
+		/* Save pointer peasycap in this interface */
 		usb_set_intfdata(intf, peasycap);
-/*---------------------------------------------------------------------------*/
-/*
- *  THE AUDIO DEVICE CAN BE REGISTERED NOW, AS IT IS READY.
- */
-/*---------------------------------------------------------------------------*/
+
+		/* The audio device can now be registered */
 		JOM(4, "initializing ALSA card\n");
 
 		rc = easycap_alsa_probe(peasycap);
@@ -3915,11 +3834,7 @@ static int easycap_usb_probe(struct usb_interface *intf,
 		peasycap->registered_audio++;
 		break;
 	}
-/*---------------------------------------------------------------------------*/
-/*
- *  INTERFACES OTHER THAN 0, 1 AND 2 ARE UNEXPECTED
- */
-/*---------------------------------------------------------------------------*/
+	/* Interfaces other than 0,1,2 are unexpected */
 	default:
 		JOM(4, "ERROR: unexpected interface %i\n", bInterfaceNumber);
 		return -EINVAL;
-- 
1.7.3.4

