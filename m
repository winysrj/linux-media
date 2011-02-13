Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:60598 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754339Ab1BMReS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Feb 2011 12:34:18 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1DHYIc9024103
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 13 Feb 2011 12:34:18 -0500
Received: from pedra (vpn-239-52.phx2.redhat.com [10.3.239.52])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p1DHT5kQ015438
	for <linux-media@vger.kernel.org>; Sun, 13 Feb 2011 12:34:17 -0500
Date: Sun, 13 Feb 2011 15:28:56 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 3/5] [media] cx231xx: Use parameters to describe some board
 variants
Message-ID: <20110213152856.2f8c01f9@pedra>
In-Reply-To: <cover.1297617986.git.mchehab@redhat.com>
References: <cover.1297617986.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Instead of per-model tests all over the code, use some parameters
at the board entries to describe the model variants for:
	- devices with 417 MPEG encoder;
	- devices that use external AV;
	- devices where vbi VANC endpoint doesn't work;
	- devices with xc5000 that require different IF
	  initialization (and probably will cover also
	  xc3028).
	- devices with xceive tuner that require a reset
	  during init.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/cx231xx/cx231xx-avcore.c b/drivers/media/video/cx231xx/cx231xx-avcore.c
index c53e972..b80bccf 100644
--- a/drivers/media/video/cx231xx/cx231xx-avcore.c
+++ b/drivers/media/video/cx231xx/cx231xx-avcore.c
@@ -759,11 +759,8 @@ int cx231xx_set_decoder_video_input(struct cx231xx *dev,
 	case CX231XX_VMUX_TELEVISION:
 	case CX231XX_VMUX_CABLE:
 	default:
-		switch (dev->model) {
-		case CX231XX_BOARD_CNXT_CARRAERA:
-		case CX231XX_BOARD_CNXT_RDE_250:
-		case CX231XX_BOARD_CNXT_SHELBY:
-		case CX231XX_BOARD_CNXT_RDU_250:
+		/* TODO: Test if this is also needed for xc2028/xc3028 */
+		if (dev->board.tuner_type == TUNER_XC5000) {
 			/* Disable the use of  DIF   */
 
 			status = vid_blk_read_word(dev, AFE_CTRL, &value);
@@ -820,8 +817,7 @@ int cx231xx_set_decoder_video_input(struct cx231xx *dev,
 				MODE_CTRL, FLD_INPUT_MODE,
 				cx231xx_set_field(FLD_INPUT_MODE,
 						INPUT_MODE_CVBS_0));
-			break;
-		default:
+		} else {
 			/* Enable the DIF for the tuner */
 
 			/* Reinitialize the DIF */
@@ -2550,7 +2546,7 @@ int cx231xx_initialize_stream_xfer(struct cx231xx *dev, u32 media_type)
 		case 4:	/* ts1 */
 			cx231xx_info("%s: set ts1 registers", __func__);
 
-		if (dev->model == CX231XX_BOARD_CNXT_VIDEO_GRABBER) {
+		if (dev->board.has_417) {
 			cx231xx_info(" MPEG\n");
 			value &= 0xFFFFFFFC;
 			value |= 0x3;
diff --git a/drivers/media/video/cx231xx/cx231xx-cards.c b/drivers/media/video/cx231xx/cx231xx-cards.c
index ca2b24b..e04c955 100644
--- a/drivers/media/video/cx231xx/cx231xx-cards.c
+++ b/drivers/media/video/cx231xx/cx231xx-cards.c
@@ -261,6 +261,9 @@ struct cx231xx_board cx231xx_boards[] = {
 		.agc_analog_digital_select_gpio = 0x1c,
 		.gpio_pin_status_mask = 0x4001000,
 		.norm = V4L2_STD_PAL,
+		.no_alt_vanc = 1,
+		.external_av = 1,
+		.has_417 = 1,
 
 		.input = {{
 				.type = CX231XX_VMUX_COMPOSITE1,
@@ -382,6 +385,8 @@ struct cx231xx_board cx231xx_boards[] = {
 		.agc_analog_digital_select_gpio = 0x0c,
 		.gpio_pin_status_mask = 0x4001000,
 		.norm = V4L2_STD_NTSC,
+		.no_alt_vanc = 1,
+		.external_av = 1,
 		.input = {{
 			.type = CX231XX_VMUX_COMPOSITE1,
 			.vmux = CX231XX_VIN_2_1,
@@ -772,7 +777,7 @@ static int cx231xx_init_dev(struct cx231xx **devhandle, struct usb_device *udev,
 	/* Reset other chips required if they are tied up with GPIO pins */
 	cx231xx_add_into_devlist(dev);
 
-	if (dev->model == CX231XX_BOARD_CNXT_VIDEO_GRABBER) {
+	if (dev->board.has_417) {
 		printk(KERN_INFO "attach 417 %d\n", dev->model);
 		if (cx231xx_417_register(dev) < 0) {
 			printk(KERN_ERR
diff --git a/drivers/media/video/cx231xx/cx231xx-core.c b/drivers/media/video/cx231xx/cx231xx-core.c
index 7d62d58..abe500f 100644
--- a/drivers/media/video/cx231xx/cx231xx-core.c
+++ b/drivers/media/video/cx231xx/cx231xx-core.c
@@ -571,6 +571,8 @@ int cx231xx_set_alt_setting(struct cx231xx *dev, u8 index, u8 alt)
 							     alt];
 		break;
 	case INDEX_VANC:
+		if (dev->board.no_alt_vanc)
+			return 0;
 		usb_interface_index =
 		    dev->current_pcb_config.hs_config_info[0].interface_info.
 		    vanc_index + 1;
@@ -600,8 +602,7 @@ int cx231xx_set_alt_setting(struct cx231xx *dev, u8 index, u8 alt)
 		usb_interface_index, alt);
 		/*To workaround error number=-71 on EP0 for videograbber,
 		 need add following codes.*/
-		if (dev->model != CX231XX_BOARD_CNXT_VIDEO_GRABBER &&
-		    dev->model != CX231XX_BOARD_HAUPPAUGE_USBLIVE2)
+		if (dev->board.no_alt_vanc)
 			return -1;
 	}
 
@@ -1301,8 +1302,7 @@ int cx231xx_dev_init(struct cx231xx *dev)
 	/* init hardware */
 	/* Note : with out calling set power mode function,
 	afe can not be set up correctly */
-	if (dev->model == CX231XX_BOARD_CNXT_VIDEO_GRABBER ||
-	    dev->model == CX231XX_BOARD_HAUPPAUGE_USBLIVE2) {
+	if (dev->board.external_av) {
 		errCode = cx231xx_set_power_mode(dev,
 				 POLARIS_AVMODE_ENXTERNAL_AV);
 		if (errCode < 0) {
@@ -1322,11 +1322,9 @@ int cx231xx_dev_init(struct cx231xx *dev)
 		}
 	}
 
-	/* reset the Tuner */
-	if ((dev->model == CX231XX_BOARD_CNXT_CARRAERA) ||
-		(dev->model == CX231XX_BOARD_CNXT_RDE_250) ||
-		(dev->model == CX231XX_BOARD_CNXT_SHELBY) ||
-		(dev->model == CX231XX_BOARD_CNXT_RDU_250))
+	/* reset the Tuner, if it is a Xceive tuner */
+	if ((dev->board.tuner_type == TUNER_XC5000) ||
+	    (dev->board.tuner_type == TUNER_XC2028))
 			cx231xx_gpio_set(dev, dev->board.tuner_gpio);
 
 	/* initialize Colibri block */
diff --git a/drivers/media/video/cx231xx/cx231xx-video.c b/drivers/media/video/cx231xx/cx231xx-video.c
index 7e3e8c4..ffd5af9 100644
--- a/drivers/media/video/cx231xx/cx231xx-video.c
+++ b/drivers/media/video/cx231xx/cx231xx-video.c
@@ -2190,8 +2190,7 @@ static int cx231xx_v4l2_open(struct file *filp)
 		dev->height = norm_maxh(dev);
 
 		/* Power up in Analog TV mode */
-		if (dev->model == CX231XX_BOARD_CNXT_VIDEO_GRABBER ||
-		    dev->model == CX231XX_BOARD_HAUPPAUGE_USBLIVE2)
+		if (dev->board.external_av)
 			cx231xx_set_power_mode(dev,
 				 POLARIS_AVMODE_ENXTERNAL_AV);
 		else
@@ -2231,9 +2230,7 @@ static int cx231xx_v4l2_open(struct file *filp)
 	if (fh->type == V4L2_BUF_TYPE_VBI_CAPTURE) {
 		/* Set the required alternate setting  VBI interface works in
 		   Bulk mode only */
-		if (dev->model != CX231XX_BOARD_CNXT_VIDEO_GRABBER &&
-		    dev->model != CX231XX_BOARD_HAUPPAUGE_USBLIVE2)
-			cx231xx_set_alt_setting(dev, INDEX_VANC, 0);
+		cx231xx_set_alt_setting(dev, INDEX_VANC, 0);
 
 		videobuf_queue_vmalloc_init(&fh->vb_vidq, &cx231xx_vbi_qops,
 					    NULL, &dev->vbi_mode.slock,
@@ -2275,7 +2272,7 @@ void cx231xx_release_analog_resources(struct cx231xx *dev)
 		cx231xx_info("V4L2 device %s deregistered\n",
 			     video_device_node_name(dev->vdev));
 
-		if (dev->model == CX231XX_BOARD_CNXT_VIDEO_GRABBER)
+		if (dev->board.has_417)
 			cx231xx_417_unregister(dev);
 
 		if (video_is_registered(dev->vdev))
@@ -2302,10 +2299,13 @@ static int cx231xx_v4l2_close(struct file *filp)
 	if (res_check(fh))
 		res_free(fh);
 
-	/*To workaround error number=-71 on EP0 for VideoGrabber,
-		 need exclude following.*/
-	if (dev->model != CX231XX_BOARD_CNXT_VIDEO_GRABBER &&
-	    dev->model != CX231XX_BOARD_HAUPPAUGE_USBLIVE2)
+	/*
+	 * To workaround error number=-71 on EP0 for VideoGrabber,
+	 *	 need exclude following.
+	 * FIXME: It is probably safe to remove most of these, as we're
+	 * now avoiding the alternate setting for INDEX_VANC
+	 */
+	if (!dev->board.no_alt_vanc)
 		if (fh->type == V4L2_BUF_TYPE_VBI_CAPTURE) {
 			videobuf_stop(&fh->vb_vidq);
 			videobuf_mmap_free(&fh->vb_vidq);
diff --git a/drivers/media/video/cx231xx/cx231xx.h b/drivers/media/video/cx231xx/cx231xx.h
index 72bbea2..b72503d 100644
--- a/drivers/media/video/cx231xx/cx231xx.h
+++ b/drivers/media/video/cx231xx/cx231xx.h
@@ -353,7 +353,10 @@ struct cx231xx_board {
 
 	unsigned int max_range_640_480:1;
 	unsigned int has_dvb:1;
+	unsigned int has_417:1;
 	unsigned int valid:1;
+	unsigned int no_alt_vanc:1;
+	unsigned int external_av:1;
 
 	unsigned char xclk, i2c_speed;
 
-- 
1.7.1


