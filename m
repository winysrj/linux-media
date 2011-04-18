Return-path: <mchehab@pedra>
Received: from smtp24.services.sfr.fr ([93.17.128.83]:2784 "EHLO
	smtp24.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab1DRUkz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Apr 2011 16:40:55 -0400
Message-ID: <4DACA1D6.3050400@sfr.fr>
Date: Mon, 18 Apr 2011 22:40:54 +0200
From: Patrice Chotard <patrice.chotard@sfr.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>
CC: Theodore Kilgore <kilgota@banach.math.auburn.edu>
Subject: [PATCH 4/5] gspca - jeilinj: Add SPORTSCAM_DV15 camera support
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Patrice CHOTARD <patricechotard@free.fr>
---
 Documentation/video4linux/gspca.txt |    1 +
 drivers/media/video/gspca/jeilinj.c |   98 ++++++++++++++++++++++++-----------
 2 files changed, 68 insertions(+), 31 deletions(-)

diff --git a/Documentation/video4linux/gspca.txt b/Documentation/video4linux/gspca.txt
index 56ba7bb..6b85f4f 100644
--- a/Documentation/video4linux/gspca.txt
+++ b/Documentation/video4linux/gspca.txt
@@ -265,6 +265,7 @@ pac7302		093a:2629	Genious iSlim 300
 pac7302		093a:262a	Webcam 300k
 pac7302		093a:262c	Philips SPC 230 NC
 jeilinj		0979:0280	Sakar 57379
+jeilinj		0979:0280	Sportscam DV15
 zc3xx		0ac8:0302	Z-star Vimicro zc0302
 vc032x		0ac8:0321	Vimicro generic vc0321
 vc032x		0ac8:0323	Vimicro Vc0323
diff --git a/drivers/media/video/gspca/jeilinj.c b/drivers/media/video/gspca/jeilinj.c
index 51b68db..da92867 100644
--- a/drivers/media/video/gspca/jeilinj.c
+++ b/drivers/media/video/gspca/jeilinj.c
@@ -34,6 +34,7 @@ MODULE_LICENSE("GPL");
 
 /* Default timeouts, in ms */
 #define JEILINJ_CMD_TIMEOUT 500
+#define JEILINJ_CMD_DELAY 160
 #define JEILINJ_DATA_TIMEOUT 1000
 
 /* Maximum transfer size to use. */
@@ -41,12 +42,17 @@ MODULE_LICENSE("GPL");
 #define FRAME_HEADER_LEN 0x10
 #define FRAME_START 0xFFFFFFFF
 
+enum {
+	SAKAR_57379,
+	SPORTSCAM_DV15,
+};
 /* Structure to hold all of our device specific stuff */
 struct sd {
 	struct gspca_dev gspca_dev;	/* !! must be the first item */
 	int blocks_left;
 	const struct v4l2_pix_format *cap_mode;
 	/* Driver stuff */
+	u8 type;
 	u8 quality;				 /* image quality */
 	u8 jpeg_hdr[JPEG_HDR_SZ];
 };
@@ -54,6 +60,7 @@ struct sd {
 struct jlj_command {
 	unsigned char instruction[2];
 	unsigned char ack_wanted;
+	unsigned char delay;
 };
 
 /* AFAICT these cameras will only do 320x240. */
@@ -114,41 +121,53 @@ static void jlj_read1(struct gspca_dev *gspca_dev, unsigned char response)
 static int jlj_start(struct gspca_dev *gspca_dev)
 {
 	int i;
+	int start_commands_size;
 	u8 response = 0xff;
 	struct sd *sd = (struct sd *) gspca_dev;
 	struct jlj_command start_commands[] = {
-		{{0x71, 0x81}, 0},
-		{{0x70, 0x05}, 0},
-		{{0x95, 0x70}, 1},
-		{{0x71, 0x81}, 0},
-		{{0x70, 0x04}, 0},
-		{{0x95, 0x70}, 1},
-		{{0x71, 0x00}, 0},
-		{{0x70, 0x08}, 0},
-		{{0x95, 0x70}, 1},
-		{{0x94, 0x02}, 0},
-		{{0xde, 0x24}, 0},
-		{{0x94, 0x02}, 0},
-		{{0xdd, 0xf0}, 0},
-		{{0x94, 0x02}, 0},
-		{{0xe3, 0x2c}, 0},
-		{{0x94, 0x02}, 0},
-		{{0xe4, 0x00}, 0},
-		{{0x94, 0x02}, 0},
-		{{0xe5, 0x00}, 0},
-		{{0x94, 0x02}, 0},
-		{{0xe6, 0x2c}, 0},
-		{{0x94, 0x03}, 0},
-		{{0xaa, 0x00}, 0},
-		{{0x71, 0x1e}, 0},
-		{{0x70, 0x06}, 0},
-		{{0x71, 0x80}, 0},
-		{{0x70, 0x07}, 0}
+		{{0x71, 0x81}, 0, 0},
+		{{0x70, 0x05}, 0, JEILINJ_CMD_DELAY},
+		{{0x95, 0x70}, 1, 0},
+		{{0x71, 0x81 - gspca_dev->curr_mode}, 0, 0},
+		{{0x70, 0x04}, 0, JEILINJ_CMD_DELAY},
+		{{0x95, 0x70}, 1, 0},
+		{{0x71, 0x00}, 0, 0},   /* start streaming ??*/
+		{{0x70, 0x08}, 0, JEILINJ_CMD_DELAY},
+		{{0x95, 0x70}, 1, 0},
+#define SPORTSCAM_DV15_CMD_SIZE 9
+		{{0x94, 0x02}, 0, 0},
+		{{0xde, 0x24}, 0, 0},
+		{{0x94, 0x02}, 0, 0},
+		{{0xdd, 0xf0}, 0, 0},
+		{{0x94, 0x02}, 0, 0},
+		{{0xe3, 0x2c}, 0, 0},
+		{{0x94, 0x02}, 0, 0},
+		{{0xe4, 0x00}, 0, 0},
+		{{0x94, 0x02}, 0, 0},
+		{{0xe5, 0x00}, 0, 0},
+		{{0x94, 0x02}, 0, 0},
+		{{0xe6, 0x2c}, 0, 0},
+		{{0x94, 0x03}, 0, 0},
+		{{0xaa, 0x00}, 0, 0},
+		{{0x71, 0x1e}, 0, 0},
+		{{0x70, 0x06}, 0, 0},
+		{{0x71, 0x80}, 0, 0},
+		{{0x70, 0x07}, 0, 0}
 	};
 
 	sd->blocks_left = 0;
-	for (i = 0; i < ARRAY_SIZE(start_commands); i++) {
+	/* Under Windows, USB spy shows that only the 9 first start
+	 * commands are used for SPORTSCAM_DV15 webcam
+	 */
+	if (sd->type == SPORTSCAM_DV15)
+		start_commands_size = SPORTSCAM_DV15_CMD_SIZE;
+	else
+		start_commands_size = ARRAY_SIZE(start_commands);
+
+	for (i = 0; i < start_commands_size; i++) {
 		jlj_write2(gspca_dev, start_commands[i].instruction);
+		if (start_commands[i].delay)
+			msleep(start_commands[i].delay);
 		if (start_commands[i].ack_wanted)
 			jlj_read1(gspca_dev, response);
 	}
@@ -207,6 +226,7 @@ static int sd_config(struct gspca_dev *gspca_dev,
 	struct cam *cam = &gspca_dev->cam;
 	struct sd *dev  = (struct sd *) gspca_dev;
 
+	dev->type = id->driver_info;
 	dev->quality  = 85;
 	PDEBUG(D_PROBE,
 		"JEILINJ camera detected"
@@ -277,14 +297,25 @@ static int sd_start(struct gspca_dev *gspca_dev)
 
 /* Table of supported USB devices */
 static const struct usb_device_id device_table[] = {
-	{USB_DEVICE(0x0979, 0x0280)},
+	{USB_DEVICE(0x0979, 0x0280), .driver_info = SAKAR_57379},
+	{USB_DEVICE(0x0979, 0x0270), .driver_info = SPORTSCAM_DV15},
 	{}
 };
 
 MODULE_DEVICE_TABLE(usb, device_table);
 
 /* sub-driver description */
-static const struct sd_desc sd_desc = {
+static const struct sd_desc sd_desc_sakar_57379 = {
+	.name   = MODULE_NAME,
+	.config = sd_config,
+	.init   = sd_init,
+	.start  = sd_start,
+	.stopN  = sd_stopN,
+	.pkt_scan = sd_pkt_scan,
+};
+
+/* sub-driver description */
+static const struct sd_desc sd_desc_sportscam_dv15 = {
 	.name   = MODULE_NAME,
 	.config = sd_config,
 	.init   = sd_init,
@@ -293,12 +324,17 @@ static const struct sd_desc sd_desc = {
 	.pkt_scan = sd_pkt_scan,
 };
 
+static const struct sd_desc *sd_desc[2] = {
+	&sd_desc_sakar_57379,
+	&sd_desc_sportscam_dv15
+};
+
 /* -- device connect -- */
 static int sd_probe(struct usb_interface *intf,
 		const struct usb_device_id *id)
 {
 	return gspca_dev_probe(intf, id,
-			&sd_desc,
+			sd_desc[id->driver_info],
 			sizeof(struct sd),
 			THIS_MODULE);
 }
-- 
1.7.0.4

