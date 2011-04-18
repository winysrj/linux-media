Return-path: <mchehab@pedra>
Received: from smtp24.services.sfr.fr ([93.17.128.83]:63433 "EHLO
	smtp24.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab1DRUii (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Apr 2011 16:38:38 -0400
Message-ID: <4DACA14D.1020706@sfr.fr>
Date: Mon, 18 Apr 2011 22:38:37 +0200
From: Patrice Chotard <patrice.chotard@sfr.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>
CC: Theodore Kilgore <kilgota@banach.math.auburn.edu>
Subject: [PATCH 2/5] gspca - jeilinj: use gspca_dev->usb_err to forward error
 to upper layer
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Patrice CHOTARD <patricechotard@free.fr>
---
 drivers/media/video/gspca/jeilinj.c |   43 ++++++++++++++++------------------
 1 files changed, 20 insertions(+), 23 deletions(-)

diff --git a/drivers/media/video/gspca/jeilinj.c b/drivers/media/video/gspca/jeilinj.c
index 33de177..32494fb 100644
--- a/drivers/media/video/gspca/jeilinj.c
+++ b/drivers/media/video/gspca/jeilinj.c
@@ -71,39 +71,44 @@ static struct v4l2_pix_format jlj_mode[] = {
  */
 
 /* All commands are two bytes only */
-static int jlj_write2(struct gspca_dev *gspca_dev, unsigned char *command)
+static void jlj_write2(struct gspca_dev *gspca_dev, unsigned char *command)
 {
 	int retval;
 
+	if (gspca_dev->usb_err < 0)
+		return;
 	memcpy(gspca_dev->usb_buf, command, 2);
 	retval = usb_bulk_msg(gspca_dev->dev,
 			usb_sndbulkpipe(gspca_dev->dev, 3),
 			gspca_dev->usb_buf, 2, NULL, 500);
-	if (retval < 0)
+	if (retval < 0) {
 		err("command write [%02x] error %d",
 				gspca_dev->usb_buf[0], retval);
-	return retval;
+		gspca_dev->usb_err = retval;
+	}
 }
 
 /* Responses are one byte only */
-static int jlj_read1(struct gspca_dev *gspca_dev, unsigned char response)
+static void jlj_read1(struct gspca_dev *gspca_dev, unsigned char response)
 {
 	int retval;
 
+	if (gspca_dev->usb_err < 0)
+		return;
 	retval = usb_bulk_msg(gspca_dev->dev,
 	usb_rcvbulkpipe(gspca_dev->dev, 0x84),
 				gspca_dev->usb_buf, 1, NULL, 500);
 	response = gspca_dev->usb_buf[0];
-	if (retval < 0)
+	if (retval < 0) {
 		err("read command [%02x] error %d",
 				gspca_dev->usb_buf[0], retval);
-	return retval;
+		gspca_dev->usb_err = retval;
+	}
 }
 
 static int jlj_start(struct gspca_dev *gspca_dev)
 {
 	int i;
-	int retval = -1;
 	u8 response = 0xff;
 	struct sd *sd = (struct sd *) gspca_dev;
 	struct jlj_command start_commands[] = {
@@ -138,16 +143,13 @@ static int jlj_start(struct gspca_dev *gspca_dev)
 
 	sd->blocks_left = 0;
 	for (i = 0; i < ARRAY_SIZE(start_commands); i++) {
-		retval = jlj_write2(gspca_dev, start_commands[i].instruction);
-		if (retval < 0)
-			return retval;
+		jlj_write2(gspca_dev, start_commands[i].instruction);
 		if (start_commands[i].ack_wanted)
-			retval = jlj_read1(gspca_dev, response);
-		if (retval < 0)
-			return retval;
+			jlj_read1(gspca_dev, response);
 	}
-	PDEBUG(D_ERR, "jlj_start retval is %d", retval);
-	return retval;
+	if (gspca_dev->usb_err < 0)
+		PDEBUG(D_ERR, "Start streaming command failed");
+	return gspca_dev->usb_err;
 }
 
 static void sd_pkt_scan(struct gspca_dev *gspca_dev,
@@ -250,26 +252,21 @@ static void sd_stopN(struct gspca_dev *gspca_dev)
 /* this function is called at probe and resume time */
 static int sd_init(struct gspca_dev *gspca_dev)
 {
-	return 0;
+	return gspca_dev->usb_err;
 }
 
 /* Set up for getting frames. */
 static int sd_start(struct gspca_dev *gspca_dev)
 {
 	struct sd *dev = (struct sd *) gspca_dev;
-	int ret;
 
 	/* create the JPEG header */
 	jpeg_define(dev->jpeg_hdr, gspca_dev->height, gspca_dev->width,
 			0x21);          /* JPEG 422 */
 	jpeg_set_qual(dev->jpeg_hdr, dev->quality);
 	PDEBUG(D_STREAM, "Start streaming at 320x240");
-	ret = jlj_start(gspca_dev);
-	if (ret < 0) {
-		PDEBUG(D_ERR, "Start streaming command failed");
-		return ret;
-	}
-	return 0;
+	jlj_start(gspca_dev);
+	return gspca_dev->usb_err;
 }
 
 /* Table of supported USB devices */
-- 
1.7.0.4

