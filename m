Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f46.google.com ([209.85.213.46]:36708 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749Ab3EJErY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 May 2013 00:47:24 -0400
Received: by mail-yh0-f46.google.com with SMTP id v1so945846yhn.5
        for <linux-media@vger.kernel.org>; Thu, 09 May 2013 21:47:23 -0700 (PDT)
Received: from [172.10.1.100] (201-42-217-105.dsl.telesp.net.br. [201.42.217.105])
        by mx.google.com with ESMTPSA id d51sm1593247yho.14.2013.05.09.21.47.22
        for <linux-media@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Thu, 09 May 2013 21:47:22 -0700 (PDT)
Message-ID: <518C7BD8.2060100@gmail.com>
Date: Fri, 10 May 2013 01:47:20 -0300
From: William Schorck <mudgebr@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: STK8096-PVR Dibcom support code added
Content-Type: multipart/mixed;
 boundary="------------070106000003000806000003"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070106000003000806000003
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Added support code for STK8096-PVR device.
Manufactured by Geniatch.


Signed-off-by: William Schorck <mudgebr@gmail.com>

--------------070106000003000806000003
Content-Type: text/x-patch;
 name="dib0700_devices.c.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dib0700_devices.c.patch"

+++ /usr/src/linux-3.9.1/drivers/media/usb/dvb-usb/dib0700_devices.c	2013-05-08 00:58:03.000000000 -0300
--- /home/neutrin0/src/kernel/dibcom/dib0700_devices.c	2013-05-10 01:18:02.699865121 -0300
@@ -5,6 +5,7 @@
  *	Software Foundation, version 2.
  *
  *  Copyright (C) 2005-9 DiBcom, SA et al
+ *
  */
 #include "dib0700.h"
 
@@ -3570,6 +3571,7 @@ struct usb_device_id dib0700_usb_id_tabl
 	{ USB_DEVICE(USB_VID_DIBCOM,    USB_PID_DIBCOM_TFE7790E) },
 /* 80 */{ USB_DEVICE(USB_VID_DIBCOM,    USB_PID_DIBCOM_TFE8096P) },
 	{ USB_DEVICE(USB_VID_ELGATO,	USB_PID_ELGATO_EYETV_DTT_2) },
+	{ USB_DEVICE(USB_VID_DIBCOM,    USB_PID_DIBCOM_STK8096PVR) },  /* [82] usb_id_table */
 	{ 0 }		/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, dib0700_usb_id_table);
@@ -4420,13 +4422,19 @@ struct dvb_usb_device_properties dib0700
 			},
 		},
 
-		.num_device_descs = 1,
+		.num_device_descs = 2,
 		.devices = {
 			{   "DiBcom STK8096GP reference design",
 				{ &dib0700_usb_id_table[67], NULL },
 				{ NULL },
 			},
 		},
+		.devices = {
+			{   "DiBcom STK8096-PVR reference design",
+				{ &dib0700_usb_id_table[82], NULL },
+				{ NULL },
+			},
+		},
 
 		.rc.core = {
 			.rc_interval      = DEFAULT_RC_INTERVAL,
@@ -4439,7 +4447,7 @@ struct dvb_usb_device_properties dib0700
 			.change_protocol  = dib0700_change_protocol,
 		},
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
-		.num_adapters = 1,
+		.num_adapters = 2,
 		.adapter = {
 			{
 			.num_frontends = 1,
@@ -4456,6 +4464,22 @@ struct dvb_usb_device_properties dib0700
 			}},
 				.size_of_priv =
 					sizeof(struct dib0700_adapter_state),
+			},
+			{
+			.num_frontends = 2, /* Dual band */
+			.fe = {{
+				.caps  = DVB_USB_ADAP_HAS_PID_FILTER |
+					DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
+				.pid_filter_count = 32,
+				.pid_filter = dib90x0_pid_filter,
+				.pid_filter_ctrl = dib90x0_pid_filter_ctrl,
+				.frontend_attach  = stk9090m_frontend_attach,
+				.tuner_attach     = dib9090_tuner_attach,
+
+				DIB0700_DEFAULT_STREAMING_CONFIG(0x03),
+			}},
+				.size_of_priv =
+					sizeof(struct dib0700_adapter_state),
 			},
 		},
 

--------------070106000003000806000003
Content-Type: text/x-patch;
 name="dvb-usb-ids.h.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dvb-usb-ids.h.patch"

+++ /usr/src/linux-3.9.1/drivers/media/dvb-core/dvb-usb-ids.h	2013-05-08 00:58:03.000000000 -0300
--- /home/neutrin0/src/kernel/dibcom/dvb-usb-ids.h	2013-05-10 01:17:07.892634029 -0300
@@ -5,6 +5,7 @@
  *
  * a header file containing define's for the USB device supported by the
  * various drivers.
+ *
  */
 #ifndef _DVB_USB_IDS_H_
 #define _DVB_USB_IDS_H_
@@ -118,6 +119,7 @@
 #define USB_PID_DIBCOM_STK807XP				0x1f90
 #define USB_PID_DIBCOM_STK807XPVR			0x1f98
 #define USB_PID_DIBCOM_STK8096GP                        0x1fa0
+
 #define USB_PID_DIBCOM_NIM8096MD                        0x1fa8
 #define USB_PID_DIBCOM_TFE8096P				0x1f9C
 #define USB_PID_DIBCOM_ANCHOR_2135_COLD			0x2131
@@ -368,4 +370,5 @@
 #define USB_PID_TECHNISAT_USB2_HDCI_V2			0x0002
 #define USB_PID_TECHNISAT_AIRSTAR_TELESTICK_2		0x0004
 #define USB_PID_TECHNISAT_USB2_DVB_S2			0x0500
+#define USB_PID_DIBCOM_STK8096PVR                       0x1faa
 #endif

--------------070106000003000806000003--
