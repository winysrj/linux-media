Return-path: <mchehab@pedra>
Received: from smtp24.services.sfr.fr ([93.17.128.83]:61401 "EHLO
	smtp24.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab1DRUhM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Apr 2011 16:37:12 -0400
Message-ID: <4DACA0F2.3020705@sfr.fr>
Date: Mon, 18 Apr 2011 22:37:06 +0200
From: Patrice Chotard <patrice.chotard@sfr.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>
CC: Theodore Kilgore <kilgota@banach.math.auburn.edu>
Subject: [PATCH 1/5] gspca - jeilinj: suppress workqueue
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Patrice CHOTARD <patricechotard@free.fr>
---
 drivers/media/video/gspca/jeilinj.c |  194 ++++++++++++++---------------------
 1 files changed, 77 insertions(+), 117 deletions(-)

diff --git a/drivers/media/video/gspca/jeilinj.c b/drivers/media/video/gspca/jeilinj.c
index 06b777f..33de177 100644
--- a/drivers/media/video/gspca/jeilinj.c
+++ b/drivers/media/video/gspca/jeilinj.c
@@ -5,6 +5,7 @@
  * download raw JPEG data.
  *
  * Copyright (C) 2009 Theodore Kilgore
+ * Copyright (C) 2011 Patrice Chotard
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -23,7 +24,6 @@
 
 #define MODULE_NAME "jeilinj"
 
-#include <linux/workqueue.h>
 #include <linux/slab.h>
 #include "gspca.h"
 #include "jpeg.h"
@@ -38,25 +38,23 @@ MODULE_LICENSE("GPL");
 
 /* Maximum transfer size to use. */
 #define JEILINJ_MAX_TRANSFER 0x200
-
 #define FRAME_HEADER_LEN 0x10
+#define FRAME_START 0xFFFFFFFF
 
 /* Structure to hold all of our device specific stuff */
 struct sd {
 	struct gspca_dev gspca_dev;	/* !! must be the first item */
+	int blocks_left;
 	const struct v4l2_pix_format *cap_mode;
 	/* Driver stuff */
-	struct work_struct work_struct;
-	struct workqueue_struct *work_thread;
 	u8 quality;				 /* image quality */
-	u8 jpegqual;				/* webcam quality */
 	u8 jpeg_hdr[JPEG_HDR_SZ];
 };
 
-	struct jlj_command {
-		unsigned char instruction[2];
-		unsigned char ack_wanted;
-	};
+struct jlj_command {
+	unsigned char instruction[2];
+	unsigned char ack_wanted;
+};
 
 /* AFAICT these cameras will only do 320x240. */
 static struct v4l2_pix_format jlj_mode[] = {
@@ -107,6 +105,7 @@ static int jlj_start(struct gspca_dev *gspca_dev)
 	int i;
 	int retval = -1;
 	u8 response = 0xff;
+	struct sd *sd = (struct sd *) gspca_dev;
 	struct jlj_command start_commands[] = {
 		{{0x71, 0x81}, 0},
 		{{0x70, 0x05}, 0},
@@ -136,6 +135,8 @@ static int jlj_start(struct gspca_dev *gspca_dev)
 		{{0x71, 0x80}, 0},
 		{{0x70, 0x07}, 0}
 	};
+
+	sd->blocks_left = 0;
 	for (i = 0; i < ARRAY_SIZE(start_commands); i++) {
 		retval = jlj_write2(gspca_dev, start_commands[i].instruction);
 		if (retval < 0)
@@ -149,104 +150,47 @@ static int jlj_start(struct gspca_dev *gspca_dev)
 	return retval;
 }
 
-static int jlj_stop(struct gspca_dev *gspca_dev)
-{
-	int i;
-	int retval;
-	struct jlj_command stop_commands[] = {
-		{{0x71, 0x00}, 0},
-		{{0x70, 0x09}, 0},
-		{{0x71, 0x80}, 0},
-		{{0x70, 0x05}, 0}
-	};
-	for (i = 0; i < ARRAY_SIZE(stop_commands); i++) {
-		retval = jlj_write2(gspca_dev, stop_commands[i].instruction);
-		if (retval < 0)
-			return retval;
-	}
-	return retval;
-}
-
-/* This function is called as a workqueue function and runs whenever the camera
- * is streaming data. Because it is a workqueue function it is allowed to sleep
- * so we can use synchronous USB calls. To avoid possible collisions with other
- * threads attempting to use the camera's USB interface the gspca usb_lock is
- * used when performing the one USB control operation inside the workqueue,
- * which tells the camera to close the stream. In practice the only thing
- * which needs to be protected against is the usb_set_interface call that
- * gspca makes during stream_off. Otherwise the camera doesn't provide any
- * controls that the user could try to change.
- */
-
-static void jlj_dostream(struct work_struct *work)
+static void sd_pkt_scan(struct gspca_dev *gspca_dev,
+			u8 *data, int len)
 {
-	struct sd *dev = container_of(work, struct sd, work_struct);
-	struct gspca_dev *gspca_dev = &dev->gspca_dev;
-	int blocks_left; /* 0x200-sized blocks remaining in current frame. */
-	int size_in_blocks;
-	int act_len;
+	struct sd *sd = (struct sd *) gspca_dev;
 	int packet_type;
-	int ret;
-	u8 *buffer;
+	u32 header_marker;
 
-	buffer = kmalloc(JEILINJ_MAX_TRANSFER, GFP_KERNEL | GFP_DMA);
-	if (!buffer) {
-		err("Couldn't allocate USB buffer");
-		goto quit_stream;
+	PDEBUG(D_STREAM, "Got %d bytes out of %d for Block 0",
+			len, JEILINJ_MAX_TRANSFER);
+	if (len != JEILINJ_MAX_TRANSFER) {
+		PDEBUG(D_PACK, "bad length");
+		goto discard;
 	}
-	while (gspca_dev->present && gspca_dev->streaming) {
-		/*
-		 * Now request data block 0. Line 0 reports the size
-		 * to download, in blocks of size 0x200, and also tells the
-		 * "actual" data size, in bytes, which seems best to ignore.
-		 */
-		ret = usb_bulk_msg(gspca_dev->dev,
-				usb_rcvbulkpipe(gspca_dev->dev, 0x82),
-				buffer, JEILINJ_MAX_TRANSFER, &act_len,
-				JEILINJ_DATA_TIMEOUT);
-		PDEBUG(D_STREAM,
-			"Got %d bytes out of %d for Block 0",
-			act_len, JEILINJ_MAX_TRANSFER);
-		if (ret < 0 || act_len < FRAME_HEADER_LEN)
-			goto quit_stream;
-		size_in_blocks = buffer[0x0a];
-		blocks_left = buffer[0x0a] - 1;
-		PDEBUG(D_STREAM, "blocks_left = 0x%x", blocks_left);
-
+	/* check if it's start of frame */
+	header_marker = ((u32 *)data)[0];
+	if (header_marker == FRAME_START) {
+		sd->blocks_left = data[0x0a] - 1;
+		PDEBUG(D_STREAM, "blocks_left = 0x%x", sd->blocks_left);
 		/* Start a new frame, and add the JPEG header, first thing */
 		gspca_frame_add(gspca_dev, FIRST_PACKET,
-				dev->jpeg_hdr, JPEG_HDR_SZ);
+				sd->jpeg_hdr, JPEG_HDR_SZ);
 		/* Toss line 0 of data block 0, keep the rest. */
 		gspca_frame_add(gspca_dev, INTER_PACKET,
-				buffer + FRAME_HEADER_LEN,
+				data + FRAME_HEADER_LEN,
 				JEILINJ_MAX_TRANSFER - FRAME_HEADER_LEN);
-
-		while (blocks_left > 0) {
-			if (!gspca_dev->present)
-				goto quit_stream;
-			ret = usb_bulk_msg(gspca_dev->dev,
-				usb_rcvbulkpipe(gspca_dev->dev, 0x82),
-				buffer, JEILINJ_MAX_TRANSFER, &act_len,
-				JEILINJ_DATA_TIMEOUT);
-			if (ret < 0 || act_len < JEILINJ_MAX_TRANSFER)
-				goto quit_stream;
-			PDEBUG(D_STREAM,
-				"%d blocks remaining for frame", blocks_left);
-			blocks_left -= 1;
-			if (blocks_left == 0)
-				packet_type = LAST_PACKET;
-			else
-				packet_type = INTER_PACKET;
-			gspca_frame_add(gspca_dev, packet_type,
-					buffer, JEILINJ_MAX_TRANSFER);
-		}
-	}
-quit_stream:
-	mutex_lock(&gspca_dev->usb_lock);
-	if (gspca_dev->present)
-		jlj_stop(gspca_dev);
-	mutex_unlock(&gspca_dev->usb_lock);
-	kfree(buffer);
+	} else if (sd->blocks_left > 0) {
+		PDEBUG(D_STREAM, "%d blocks remaining for frame",
+				sd->blocks_left);
+		sd->blocks_left -= 1;
+		if (sd->blocks_left == 0)
+			packet_type = LAST_PACKET;
+		else
+			packet_type = INTER_PACKET;
+		gspca_frame_add(gspca_dev, packet_type,
+				data, JEILINJ_MAX_TRANSFER);
+	} else
+		goto discard;
+	return;
+discard:
+	/* Discard data until a new frame starts. */
+	gspca_dev->last_packet_type = DISCARD_PACKET;
 }
 
 /* This function is called at probe time just before sd_init */
@@ -257,31 +201,50 @@ static int sd_config(struct gspca_dev *gspca_dev,
 	struct sd *dev  = (struct sd *) gspca_dev;
 
 	dev->quality  = 85;
-	dev->jpegqual = 85;
 	PDEBUG(D_PROBE,
 		"JEILINJ camera detected"
 		" (vid/pid 0x%04X:0x%04X)", id->idVendor, id->idProduct);
 	cam->cam_mode = jlj_mode;
 	cam->nmodes = 1;
 	cam->bulk = 1;
-	/* We don't use the buffer gspca allocates so make it small. */
-	cam->bulk_size = 32;
-	INIT_WORK(&dev->work_struct, jlj_dostream);
+	cam->bulk_nurbs = 1;
+	cam->bulk_size = JEILINJ_MAX_TRANSFER;
 	return 0;
 }
 
-/* called on streamoff with alt==0 and on disconnect */
-/* the usb_lock is held at entry - restore on exit */
-static void sd_stop0(struct gspca_dev *gspca_dev)
+static void sd_stopN(struct gspca_dev *gspca_dev)
 {
-	struct sd *dev = (struct sd *) gspca_dev;
+	int i;
+	u8 *buf;
+	u8 stop_commands[][2] = {
+		{0x71, 0x00},
+		{0x70, 0x09},
+		{0x71, 0x80},
+		{0x70, 0x05}
+	};
+
+	for (;;) {
+		/* get the image remaining blocks */
+		usb_bulk_msg(gspca_dev->dev,
+				gspca_dev->urb[0]->pipe,
+				gspca_dev->urb[0]->transfer_buffer,
+				JEILINJ_MAX_TRANSFER, NULL,
+				JEILINJ_DATA_TIMEOUT);
 
-	/* wait for the work queue to terminate */
-	mutex_unlock(&gspca_dev->usb_lock);
-	/* This waits for jlj_dostream to finish */
-	destroy_workqueue(dev->work_thread);
-	dev->work_thread = NULL;
-	mutex_lock(&gspca_dev->usb_lock);
+		/* search for 0xff 0xd9  (EOF for JPEG) */
+		i = 0;
+		buf = gspca_dev->urb[0]->transfer_buffer;
+		while ((i < (JEILINJ_MAX_TRANSFER - 1)) &&
+			((buf[i] != 0xff) || (buf[i+1] != 0xd9)))
+			i++;
+
+		if (i != (JEILINJ_MAX_TRANSFER - 1))
+			/* last remaining block found */
+			break;
+		}
+
+	for (i = 0; i < ARRAY_SIZE(stop_commands); i++)
+		jlj_write2(gspca_dev, stop_commands[i]);
 }
 
 /* this function is called at probe and resume time */
@@ -306,10 +269,6 @@ static int sd_start(struct gspca_dev *gspca_dev)
 		PDEBUG(D_ERR, "Start streaming command failed");
 		return ret;
 	}
-	/* Start the workqueue function to do the streaming */
-	dev->work_thread = create_singlethread_workqueue(MODULE_NAME);
-	queue_work(dev->work_thread, &dev->work_struct);
-
 	return 0;
 }
 
@@ -327,7 +286,8 @@ static const struct sd_desc sd_desc = {
 	.config = sd_config,
 	.init   = sd_init,
 	.start  = sd_start,
-	.stop0  = sd_stop0,
+	.stopN  = sd_stopN,
+	.pkt_scan = sd_pkt_scan,
 };
 
 /* -- device connect -- */
-- 
1.7.0.4

