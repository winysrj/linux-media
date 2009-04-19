Return-path: <linux-media-owner@vger.kernel.org>
Received: from waikiki.ops.eusc.inter.net ([84.23.254.155]:61885 "EHLO
	waikiki.ops.eusc.inter.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755184AbZDSSW0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Apr 2009 14:22:26 -0400
Received: from waikiki.ops.eusc.inter.net ([10.155.10.19] helo=localhost)
	by waikiki.ops.eusc.inter.net with esmtpsa (Exim 4.69)
	id 1LvbHT-000Lit-IL
	for linux-media@vger.kernel.org; Sun, 19 Apr 2009 19:58:15 +0200
Message-Id: <E63C5667-D18B-4D13-9D88-15293E1B12B2@snafu.de>
From: Armin Schenker <sar@snafu.de>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1; format=flowed; delsp=yes
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Add Elgato EyeTV DTT deluxe to dibcom driver
Date: Sun, 19 Apr 2009 19:58:14 +0200
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch introduces support for DVB-T for the following dibcom based  
card:
Elgato EyeTV DTT deluxe (USB-ID: 0fd9:0020)

Patch tested with Ubuntu 8.10 and Totem/gstream for watching TV in  
Berlin, see also  following log:
Apr 19 17:05:30 parallels-ubuntu kernel: [ 1320.452301] usb 1-1: new  
high speed USB device using ehci_hcd and address 4
Apr 19 17:05:30 parallels-ubuntu kernel: [ 1320.630760] usb 1-1:  
configuration #1 chosen from 1 choice
Apr 19 17:05:30 parallels-ubuntu kernel: [ 1320.676135] dvb-usb: found  
a 'Elgato EyeTV Dtt Dlx PD378S' in warm state.
Apr 19 17:05:30 parallels-ubuntu kernel: [ 1320.686115] dvb-usb: will  
pass the complete MPEG2 transport stream to the software demuxer.
Apr 19 17:05:30 parallels-ubuntu kernel: [ 1320.689773] DVB:  
registering new adapter (Elgato EyeTV Dtt Dlx PD378S)
Apr 19 17:05:31 parallels-ubuntu kernel: [ 1321.401068] DVB:  
registering adapter 0 frontend 0 (DiBcom 7000PC)...
Apr 19 17:05:32 parallels-ubuntu kernel: [ 1322.039172] DiB0070:  
successfully identified
Apr 19 17:05:32 parallels-ubuntu kernel: [ 1322.052382] input: IR- 
receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:1d. 
7/usb1/1-1/input/input6
Apr 19 17:05:32 parallels-ubuntu kernel: [ 1322.076363] dvb-usb:  
schedule remote query interval to 50 msecs.
Apr 19 17:05:32 parallels-ubuntu kernel: [ 1322.076373] dvb-usb:  
Elgato EyeTV Dtt Dlx PD378S successfully initialized and connected.




--- a/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c	2009-04-19  
19:26:33.000000000 +0200
+++ b/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c	2009-04-19  
10:58:16.000000000 +0200
@@ -1497,6 +1497,7 @@ struct usb_device_id dib0700_usb_id_tabl
  	{ USB_DEVICE(USB_VID_HAUPPAUGE, USB_PID_HAUPPAUGE_TIGER_ATSC_B210) },
  	{ USB_DEVICE(USB_VID_YUAN,	USB_PID_YUAN_MC770) },
  	{ USB_DEVICE(USB_VID_ELGATO,	USB_PID_ELGATO_EYETV_DTT) },
+	{ USB_DEVICE(USB_VID_ELGATO,	USB_PID_ELGATO_EYETV_DTT_Dlx) },
  	{ 0 }		/* Terminating entry */
  };
  MODULE_DEVICE_TABLE(usb, dib0700_usb_id_table);
@@ -1696,7 +1697,7 @@ struct dvb_usb_device_properties dib0700
  			},
  		},

-		.num_device_descs = 11,
+		.num_device_descs = 12,
  		.devices = {
  			{   "DiBcom STK7070P reference design",
  				{ &dib0700_usb_id_table[15], NULL },
@@ -1742,6 +1743,10 @@ struct dvb_usb_device_properties dib0700
  				{ &dib0700_usb_id_table[45], NULL },
  				{ NULL },
  			},
+			{   "Elgato EyeTV Dtt Dlx PD378S",
+				{ &dib0700_usb_id_table[50], NULL },
+				{ NULL },
+			},
  		},

  		.rc_interval      = DEFAULT_RC_INTERVAL,

--- a/linux/drivers/media/dvb/dvb-usb/dvb-usb.h	2009-04-19  
19:26:08.000000000 +0200
+++ b/linux/drivers/media/dvb/dvb-usb/dvb-usb.h	2009-04-19  
11:02:54.000000000 +0200
@@ -224,7 +224,7 @@ struct dvb_usb_device_properties {
  	int generic_bulk_ctrl_endpoint;

  	int num_device_descs;
-	struct dvb_usb_device_description devices[11];
+	struct dvb_usb_device_description devices[12];
  };

  /**


--- a/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	2009-04-19  
19:24:49.000000000 +0200
+++ b/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	2009-04-19  
10:39:18.000000000 +0200
@@ -253,5 +253,6 @@
  #define USB_PID_MSI_DIGI_VOX_MINI_III                   0x8807
  #define USB_PID_SONY_PLAYTV				0x0003
  #define USB_PID_ELGATO_EYETV_DTT			0x0021
+#define USB_PID_ELGATO_EYETV_DTT_Dlx			0x0020

  #endif



---
Grüße Armin Schenker
sar@snafu.de



