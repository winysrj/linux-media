Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp206.alice.it ([82.57.200.102]:44084 "EHLO smtp206.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753546AbaFYJ3V (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jun 2014 05:29:21 -0400
From: Antonio Ospite <ao2@ao2.it>
To: linux-media@vger.kernel.org
Cc: Antonio Ospite <ao2@ao2.it>, Hans de Goede <hdegoede@redhat.com>,
	Alexander Sosna <alexander@xxor.de>
Subject: [PATCH 2/2] gspca_kinect: add support for the depth stream
Date: Wed, 25 Jun 2014 11:27:57 +0200
Message-Id: <1403688477-30408-3-git-send-email-ao2@ao2.it>
In-Reply-To: <1403688477-30408-1-git-send-email-ao2@ao2.it>
References: <1401913499-6475-1-git-send-email-ao2@ao2.it>
 <1403688477-30408-1-git-send-email-ao2@ao2.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for the depth stream at 10bpp, for now use a 'depth_mode'
command line parameter to switch between video and depth mode.

Signed-off-by: Alexander Sosna <alexander@xxor.de>
Signed-off-by: Antonio Ospite <ao2@ao2.it>
---
 drivers/media/usb/gspca/kinect.c | 98 +++++++++++++++++++++++++++++++++++-----
 1 file changed, 87 insertions(+), 11 deletions(-)

diff --git a/drivers/media/usb/gspca/kinect.c b/drivers/media/usb/gspca/kinect.c
index 081f051..45bc1f5 100644
--- a/drivers/media/usb/gspca/kinect.c
+++ b/drivers/media/usb/gspca/kinect.c
@@ -36,6 +36,8 @@ MODULE_AUTHOR("Antonio Ospite <ospite@studenti.unina.it>");
 MODULE_DESCRIPTION("GSPCA/Kinect Sensor Device USB Camera Driver");
 MODULE_LICENSE("GPL");
 
+static bool depth_mode;
+
 struct pkt_hdr {
 	uint8_t magic[2];
 	uint8_t pad;
@@ -73,6 +75,14 @@ struct sd {
 
 #define FPS_HIGH       0x0100
 
+static const struct v4l2_pix_format depth_camera_mode[] = {
+	{640, 480, V4L2_PIX_FMT_Y10BPACK, V4L2_FIELD_NONE,
+	 .bytesperline = 640 * 10 / 8,
+	 .sizeimage =  640 * 480 * 10 / 8,
+	 .colorspace = V4L2_COLORSPACE_SRGB,
+	 .priv = MODE_640x488 | FORMAT_Y10B},
+};
+
 static const struct v4l2_pix_format video_camera_mode[] = {
 	{640, 480, V4L2_PIX_FMT_SGRBG8, V4L2_FIELD_NONE,
 	 .bytesperline = 640,
@@ -219,7 +229,7 @@ static int write_register(struct gspca_dev *gspca_dev, uint16_t reg,
 }
 
 /* this function is called at probe time */
-static int sd_config(struct gspca_dev *gspca_dev,
+static int sd_config_video(struct gspca_dev *gspca_dev,
 		     const struct usb_device_id *id)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
@@ -227,8 +237,6 @@ static int sd_config(struct gspca_dev *gspca_dev,
 
 	sd->cam_tag = 0;
 
-	/* Only video stream is supported for now,
-	 * which has stream flag = 0x80 */
 	sd->stream_flag = 0x80;
 
 	cam = &gspca_dev->cam;
@@ -236,6 +244,8 @@ static int sd_config(struct gspca_dev *gspca_dev,
 	cam->cam_mode = video_camera_mode;
 	cam->nmodes = ARRAY_SIZE(video_camera_mode);
 
+	gspca_dev->xfer_ep = 0x81;
+
 #if 0
 	/* Setting those values is not needed for video stream */
 	cam->npkt = 15;
@@ -245,6 +255,26 @@ static int sd_config(struct gspca_dev *gspca_dev,
 	return 0;
 }
 
+static int sd_config_depth(struct gspca_dev *gspca_dev,
+		     const struct usb_device_id *id)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	struct cam *cam;
+
+	sd->cam_tag = 0;
+
+	sd->stream_flag = 0x70;
+
+	cam = &gspca_dev->cam;
+
+	cam->cam_mode = depth_camera_mode;
+	cam->nmodes = ARRAY_SIZE(depth_camera_mode);
+
+	gspca_dev->xfer_ep = 0x82;
+
+	return 0;
+}
+
 /* this function is called at probe and resume time */
 static int sd_init(struct gspca_dev *gspca_dev)
 {
@@ -253,7 +283,7 @@ static int sd_init(struct gspca_dev *gspca_dev)
 	return 0;
 }
 
-static int sd_start(struct gspca_dev *gspca_dev)
+static int sd_start_video(struct gspca_dev *gspca_dev)
 {
 	int mode;
 	uint8_t fmt_reg, fmt_val;
@@ -325,12 +355,39 @@ static int sd_start(struct gspca_dev *gspca_dev)
 	return 0;
 }
 
-static void sd_stopN(struct gspca_dev *gspca_dev)
+static int sd_start_depth(struct gspca_dev *gspca_dev)
+{
+	/* turn off IR-reset function */
+	write_register(gspca_dev, 0x105, 0x00);
+
+	/* reset depth stream */
+	write_register(gspca_dev, 0x06, 0x00);
+	/* Depth Stream Format 0x03: 11 bit stream | 0x02: 10 bit */
+	write_register(gspca_dev, 0x12, 0x02);
+	/* Depth Stream Resolution 1: standard (640x480) */
+	write_register(gspca_dev, 0x13, 0x01);
+	/* Depth Framerate / 0x1e (30): 30 fps */
+	write_register(gspca_dev, 0x14, 0x1e);
+	/* Depth Stream Control  / 2: Open Depth Stream */
+	write_register(gspca_dev, 0x06, 0x02);
+	/* disable depth hflip / LSB = 0: Smoothing Disabled */
+	write_register(gspca_dev, 0x17, 0x00);
+
+	return 0;
+}
+
+static void sd_stopN_video(struct gspca_dev *gspca_dev)
 {
 	/* reset video stream */
 	write_register(gspca_dev, 0x05, 0x00);
 }
 
+static void sd_stopN_depth(struct gspca_dev *gspca_dev)
+{
+	/* reset depth stream */
+	write_register(gspca_dev, 0x06, 0x00);
+}
+
 static void sd_pkt_scan(struct gspca_dev *gspca_dev, u8 *__data, int len)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
@@ -366,12 +423,24 @@ static void sd_pkt_scan(struct gspca_dev *gspca_dev, u8 *__data, int len)
 }
 
 /* sub-driver description */
-static const struct sd_desc sd_desc = {
+static const struct sd_desc sd_desc_video = {
 	.name      = MODULE_NAME,
-	.config    = sd_config,
+	.config    = sd_config_video,
 	.init      = sd_init,
-	.start     = sd_start,
-	.stopN     = sd_stopN,
+	.start     = sd_start_video,
+	.stopN     = sd_stopN_video,
+	.pkt_scan  = sd_pkt_scan,
+	/*
+	.get_streamparm = sd_get_streamparm,
+	.set_streamparm = sd_set_streamparm,
+	*/
+};
+static const struct sd_desc sd_desc_depth = {
+	.name      = MODULE_NAME,
+	.config    = sd_config_depth,
+	.init      = sd_init,
+	.start     = sd_start_depth,
+	.stopN     = sd_stopN_depth,
 	.pkt_scan  = sd_pkt_scan,
 	/*
 	.get_streamparm = sd_get_streamparm,
@@ -391,8 +460,12 @@ MODULE_DEVICE_TABLE(usb, device_table);
 /* -- device connect -- */
 static int sd_probe(struct usb_interface *intf, const struct usb_device_id *id)
 {
-	return gspca_dev_probe(intf, id, &sd_desc, sizeof(struct sd),
-				THIS_MODULE);
+	if (depth_mode)
+		return gspca_dev_probe(intf, id, &sd_desc_depth,
+				       sizeof(struct sd), THIS_MODULE);
+	else
+		return gspca_dev_probe(intf, id, &sd_desc_video,
+				       sizeof(struct sd), THIS_MODULE);
 }
 
 static struct usb_driver sd_driver = {
@@ -408,3 +481,6 @@ static struct usb_driver sd_driver = {
 };
 
 module_usb_driver(sd_driver);
+
+module_param(depth_mode, bool, 0644);
+MODULE_PARM_DESC(depth_mode, "0=video 1=depth");
-- 
2.0.0

