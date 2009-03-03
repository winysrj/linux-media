Return-path: <linux-media-owner@vger.kernel.org>
Received: from mk-outboundfilter-6.mail.uk.tiscali.com ([212.74.114.14]:5068
	"EHLO mk-outboundfilter-6.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752641AbZCCXUx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Mar 2009 18:20:53 -0500
From: Adam Baker <linux@baker-net.org.uk>
To: "Jean-Francois Moine" <moinejf@free.fr>
Subject: [PATCH] Support alternate resolutions for sq905
Date: Tue, 3 Mar 2009 23:20:47 +0000
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903032320.48037.linux@baker-net.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for the alternate resolutions offered by SQ-905 based cameras. As
well as 320x240 all cameras can do 160x120 and some can do 640x480.

Signed-off-by: Adam Baker <linux@baker-net.org.uk>
---
The patch to detect orientation needs to follow this as that is also simplified by
the modified identity check that this introduces.
---
diff -r 332a4d374f56 linux/drivers/media/video/gspca/sq905.c
--- a/linux/drivers/media/video/gspca/sq905.c	Sat Feb 28 11:49:32 2009 +0100
+++ b/linux/drivers/media/video/gspca/sq905.c	Tue Mar 03 21:20:02 2009 +0000
@@ -60,23 +60,29 @@ MODULE_LICENSE("GPL");
 #define SQ905_PING	0x07	/* when reading an "idling" command */
 #define SQ905_READ_DONE 0xc0    /* ack bulk read completed */
 
+/* Any non-zero value in the bottom 2 bits of the 2nd byte of
+ * the ID appears to indicate the camera can do 640*480. If the
+ * LSB of that byte is set the image is just upside down, otherwise
+ * it is rotated 180 degrees. */
+#define SQ905_HIRES_MASK	0x00000300
+#define SQ905_ORIENTATION_MASK	0x00000100
+
 /* Some command codes. These go in the "index" slot. */
 
 #define SQ905_ID      0xf0	/* asks for model string */
 #define SQ905_CONFIG  0x20	/* gets photo alloc. table, not used here */
 #define SQ905_DATA    0x30	/* accesses photo data, not used here */
 #define SQ905_CLEAR   0xa0	/* clear everything */
-#define SQ905_CAPTURE_LOW 0x60	/* Starts capture at 160x120 */
-#define SQ905_CAPTURE_MED 0x61	/* Starts capture at 320x240 */
+#define SQ905_CAPTURE_LOW  0x60	/* Starts capture at 160x120 */
+#define SQ905_CAPTURE_MED  0x61	/* Starts capture at 320x240 */
+#define SQ905_CAPTURE_HIGH 0x62	/* Starts capture at 640x480 (some cams only) */
 /* note that the capture command also controls the output dimensions */
-/* 0x60 -> 160x120, 0x61 -> 320x240 0x62 -> 640x480 depends on camera */
-/* 0x62 is not correct, at least for some cams. Should be 0x63 ? */
 
 /* Structure to hold all of our device specific stuff */
 struct sd {
 	struct gspca_dev gspca_dev;	/* !! must be the first item */
 
-	u8 cam_type;
+	const struct v4l2_pix_format *cap_mode;
 
 	/*
 	 * Driver stuff
@@ -85,31 +91,22 @@ struct sd {
 	struct workqueue_struct *work_thread;
 };
 
-/* The driver only supports 320x240 so far. */
-static struct v4l2_pix_format sq905_mode[1] = {
+static struct v4l2_pix_format sq905_mode[] = {
+	{ 160, 120, V4L2_PIX_FMT_SBGGR8, V4L2_FIELD_NONE,
+		.bytesperline = 160,
+		.sizeimage = 160 * 120,
+		.colorspace = V4L2_COLORSPACE_SRGB,
+		.priv = 0},
 	{ 320, 240, V4L2_PIX_FMT_SBGGR8, V4L2_FIELD_NONE,
 		.bytesperline = 320,
 		.sizeimage = 320 * 240,
 		.colorspace = V4L2_COLORSPACE_SRGB,
+		.priv = 0},
+	{ 640, 480, V4L2_PIX_FMT_SBGGR8, V4L2_FIELD_NONE,
+		.bytesperline = 640,
+		.sizeimage = 640 * 480,
+		.colorspace = V4L2_COLORSPACE_SRGB,
 		.priv = 0}
-};
-
-struct cam_type {
-	u32 ident_word;
-	char *name;
-	struct v4l2_pix_format *min_mode;
-	u8 num_modes;
-	u8 sensor_flags;
-};
-
-#define SQ905_FLIP_HORIZ (1 << 0)
-#define SQ905_FLIP_VERT  (1 << 1)
-
-/* Last entry is default if nothing else matches */
-static struct cam_type cam_types[] = {
-	{ 0x19010509, "PocketCam", &sq905_mode[0], 1, SQ905_FLIP_HORIZ },
-	{ 0x32010509, "Magpix", &sq905_mode[0], 1, SQ905_FLIP_HORIZ },
-	{ 0, "Default", &sq905_mode[0], 1, SQ905_FLIP_HORIZ | SQ905_FLIP_VERT }
 };
 
 /*
@@ -240,7 +237,7 @@ static void sq905_dostream(struct work_s
 
 		/* request some data and then read it until we have
 		 * a complete frame. */
-		bytes_left = sq905_mode[0].sizeimage + FRAME_HEADER_LEN;
+		bytes_left = dev->cap_mode->sizeimage + FRAME_HEADER_LEN;
 		header_read = 0;
 		discarding = 0;
 
@@ -272,11 +269,18 @@ static void sq905_dostream(struct work_s
 				packet_type = INTER_PACKET;
 			}
 			frame = gspca_get_i_frame(gspca_dev);
-			if (frame && !discarding)
+			if (frame && !discarding) {
 				gspca_frame_add(gspca_dev, packet_type,
 						frame, data, data_len);
-			else
+				/* If entire frame fits in one packet we still
+				   need to add a LAST_PACKET */
+				if ((packet_type == FIRST_PACKET) &&
+				    (bytes_left == 0))
+					gspca_frame_add(gspca_dev, LAST_PACKET,
+							frame, data, 0);
+			} else {
 				discarding = 1;
+			}
 		}
 		/* acknowledge the frame */
 		mutex_lock(&gspca_dev->usb_lock);
@@ -301,8 +305,6 @@ static int sd_config(struct gspca_dev *g
 	struct cam *cam = &gspca_dev->cam;
 	struct sd *dev = (struct sd *) gspca_dev;
 
-	cam->cam_mode = sq905_mode;
-	cam->nmodes = 1;
 	/* We don't use the buffer gspca allocates so make it small. */
 	cam->bulk_size = 64;
 
@@ -328,7 +330,6 @@ static void sd_stop0(struct gspca_dev *g
 /* this function is called at probe and resume time */
 static int sd_init(struct gspca_dev *gspca_dev)
 {
-	struct sd *dev = (struct sd *) gspca_dev;
 	u32 ident;
 	int ret;
 
@@ -344,17 +345,18 @@ static int sd_init(struct gspca_dev *gsp
 	ret = sq905_read_data(gspca_dev, gspca_dev->usb_buf, 4);
 	if (ret < 0)
 		return ret;
-	/* usb_buf is allocated with kmalloc so is aligned. */
-	ident = le32_to_cpup((u32 *)gspca_dev->usb_buf);
+	/* usb_buf is allocated with kmalloc so is aligned.
+	 * Camera model number is the right way round if we assume this
+	 * reverse engineered ID is supposed to be big endian. */
+	ident = be32_to_cpup((__be32 *)gspca_dev->usb_buf);
 	ret = sq905_command(gspca_dev, SQ905_CLEAR);
 	if (ret < 0)
 		return ret;
-	dev->cam_type = 0;
-	while (dev->cam_type < ARRAY_SIZE(cam_types) - 1 &&
-	       ident != cam_types[dev->cam_type].ident_word)
-		dev->cam_type++;
-	PDEBUG(D_CONF, "SQ905 camera %s, ID %08x detected",
-	       cam_types[dev->cam_type].name, ident);
+	PDEBUG(D_CONF, "SQ905 camera ID %08x detected", ident);
+	gspca_dev->cam.cam_mode = sq905_mode;
+	gspca_dev->cam.nmodes = ARRAY_SIZE(sq905_mode);
+	if (!(ident & SQ905_HIRES_MASK))
+		gspca_dev->cam.nmodes--;
 	return 0;
 }
 
@@ -364,13 +366,29 @@ static int sd_start(struct gspca_dev *gs
 	struct sd *dev = (struct sd *) gspca_dev;
 	int ret;
 
+	/* Set capture mode based on selected resolution. */
+	dev->cap_mode = gspca_dev->cam.cam_mode;
 	/* "Open the shutter" and set size, to start capture */
-	ret = sq905_command(&dev->gspca_dev, SQ905_CAPTURE_MED);
+	switch (gspca_dev->width) {
+	case 640:
+		PDEBUG(D_STREAM, "Start streaming at high resolution");
+		dev->cap_mode += 2;
+		ret = sq905_command(&dev->gspca_dev, SQ905_CAPTURE_HIGH);
+		break;
+	case 320:
+		PDEBUG(D_STREAM, "Start streaming at medium resolution");
+		dev->cap_mode++;
+		ret = sq905_command(&dev->gspca_dev, SQ905_CAPTURE_MED);
+		break;
+	default:
+		PDEBUG(D_STREAM, "Start streaming at low resolution");
+		ret = sq905_command(&dev->gspca_dev, SQ905_CAPTURE_LOW);
+	}
+
 	if (ret < 0) {
 		PDEBUG(D_ERR, "Start streaming command failed");
 		return ret;
 	}
-
 	/* Start the workqueue function to do the streaming */
 	dev->work_thread = create_singlethread_workqueue(MODULE_NAME);
 	queue_work(dev->work_thread, &dev->work_struct);
