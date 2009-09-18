Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway03.websitewelcome.com ([69.93.37.25]:60349 "HELO
	gateway03.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757715AbZIRS3x (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Sep 2009 14:29:53 -0400
Received: from [66.15.212.169] (port=30664 helo=[10.140.5.16])
	by gator886.hostgator.com with esmtpsa (SSLv3:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <pete@sensoray.com>)
	id 1Moi6x-0002cs-Ne
	for linux-media@vger.kernel.org; Fri, 18 Sep 2009 13:23:11 -0500
Subject: [PATCH 2/9] go7007: Fix whitespace and line lengths
From: Pete <pete@sensoray.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 18 Sep 2009 11:23:15 -0700
Message-Id: <1253298195.4314.566.camel@pete-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Trailing whitespace is removed.
Source lines wrap at 80 columns.

Priority: normal

Signed-off-by: Pete Eberlein <pete@sensoray.com>

diff -r 17bd971b5c53 -r 19c623143852 linux/drivers/staging/go7007/go7007-usb.c
--- a/linux/drivers/staging/go7007/go7007-usb.c	Fri Sep 18 09:42:18 2009 -0700
+++ b/linux/drivers/staging/go7007/go7007-usb.c	Fri Sep 18 10:22:27 2009 -0700
@@ -33,7 +33,8 @@
 
 static unsigned int assume_endura;
 module_param(assume_endura, int, 0644);
-MODULE_PARM_DESC(assume_endura, "when probing fails, hardware is a Pelco Endura");
+MODULE_PARM_DESC(assume_endura, "when probing fails, "
+				"hardware is a Pelco Endura");
 
 /* #define GO7007_USB_DEBUG */
 /* #define GO7007_I2C_DEBUG */ /* for debugging the EZ-USB I2C adapter */
@@ -44,12 +45,12 @@
 
 /*
  * Pipes on EZ-USB interface:
- * 	0 snd - Control
- * 	0 rcv - Control
- * 	2 snd - Download firmware (control)
- * 	4 rcv - Read Interrupt (interrupt)
- * 	6 rcv - Read Video (bulk)
- * 	8 rcv - Read Audio (bulk)
+ *	0 snd - Control
+ *	0 rcv - Control
+ *	2 snd - Download firmware (control)
+ *	4 rcv - Read Interrupt (interrupt)
+ *	6 rcv - Read Video (bulk)
+ *	8 rcv - Read Audio (bulk)
  */
 
 #define GO7007_USB_EZUSB		(1<<0)
@@ -97,7 +98,7 @@
 			},
 		},
 		.num_inputs	 = 2,
-		.inputs 	 = {
+		.inputs		 = {
 			{
 				.video_input	= 0,
 				.name		= "Composite",
@@ -134,7 +135,7 @@
 			},
 		},
 		.num_inputs	 = 2,
-		.inputs 	 = {
+		.inputs		 = {
 			{
 				.video_input	= 0,
 				.name		= "Composite",
@@ -172,7 +173,7 @@
 			},
 		},
 		.num_inputs	 = 2,
-		.inputs 	 = {
+		.inputs		 = {
 			{
 				.video_input	= 1,
 			/*	.audio_input	= AUDIO_EXTERN, */
@@ -228,7 +229,7 @@
 			},
 		},
 		.num_inputs	 = 3,
-		.inputs 	 = {
+		.inputs		 = {
 			{
 				.video_input	= 1,
 				.audio_input	= TVAUDIO_INPUT_EXTERN,
@@ -276,7 +277,7 @@
 			},
 		},
 		.num_inputs	  = 1,
-		.inputs 	  = {
+		.inputs		  = {
 			{
 				.name		= "Camera",
 			},
@@ -309,7 +310,7 @@
 			},
 		},
 		.num_inputs	 = 2,
-		.inputs 	 = {
+		.inputs		 = {
 			{
 				.video_input	= 2,
 				.name		= "Composite",
@@ -341,7 +342,7 @@
 					GO7007_SENSOR_SCALING,
 		.num_i2c_devs	 = 0,
 		.num_inputs	 = 1,
-		.inputs 	 = {
+		.inputs		 = {
 			{
 				.video_input	= 0,
 				.name		= "Composite",
@@ -367,7 +368,7 @@
 		.sensor_h_offset = 8,
 		.num_i2c_devs	 = 0,
 		.num_inputs	 = 1,
-		.inputs 	 = {
+		.inputs		 = {
 			{
 				.name		= "Camera",
 			},
@@ -399,7 +400,7 @@
 			},
 		},
 		.num_inputs	 = 1,
-		.inputs 	 = {
+		.inputs		 = {
 			{
 				.name		= "Composite",
 			},
@@ -430,7 +431,7 @@
 			},
 		},
 		.num_inputs	 = 2,
-		.inputs 	 = {
+		.inputs		 = {
 			{
 				.video_input	= 0,
 				.name		= "Composite",
@@ -741,7 +742,8 @@
 		return;
 	}
 	if (status) {
-		printk(KERN_ERR "go7007-usb: error in video pipe: %d\n", status);
+		printk(KERN_ERR "go7007-usb: error in video pipe: %d\n",
+			status);
 		return;
 	}
 	if (urb->actual_length != urb->transfer_buffer_length) {
@@ -762,7 +764,8 @@
 	if (!go->streaming)
 		return;
 	if (status) {
-		printk(KERN_ERR "go7007-usb: error in audio pipe: %d\n", status);
+		printk(KERN_ERR "go7007-usb: error in audio pipe: %d\n",
+			status);
 		return;
 	}
 	if (urb->actual_length != urb->transfer_buffer_length) {
@@ -1017,7 +1020,7 @@
 		break;
 	case GO7007_BOARDID_SENSORAY_2250:
 		printk(KERN_INFO "Sensoray 2250 found\n");
-		name = "Sensoray 2250/2251\n";
+		name = "Sensoray 2250/2251";
 		board = &board_sensoray_2250;
 		break;
 	default:
@@ -1096,7 +1099,7 @@
 				usb->board = board = &board_endura;
 				go->board_info = &board->main_info;
 				strncpy(go->name, "Pelco Endura",
-						sizeof(go->name));
+					sizeof(go->name));
 			} else {
 				u16 channel;
 
@@ -1154,8 +1157,7 @@
 		 * to the EZ-USB GPIO output pins */
 		if (go7007_usb_vendor_request(go, 0x40, 0x7f02, 0,
 					NULL, 0, 0) < 0) {
-			printk(KERN_ERR
-				"go7007-usb: GPIO write failed!\n");
+			printk(KERN_ERR "go7007-usb: GPIO write failed!\n");
 			goto initfail;
 		}
 	}


