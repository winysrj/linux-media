Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail21.extendcp.co.uk ([79.170.40.21])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mailing-lists@enginuities.com>) id 1Lp0i3-0006YG-Th
	for linux-dvb@linuxtv.org; Wed, 01 Apr 2009 15:42:29 +0200
Received: from 220-244-237-138-qld-pppoe.tpgi.com.au ([220.244.237.138]
	helo=cobra.localnet) by mail21.extendcp.com with esmtpa (Exim 4.63)
	id 1Lp0hz-0004Q9-NV
	for linux-dvb@linuxtv.org; Wed, 01 Apr 2009 14:42:24 +0100
From: Stuart <mailing-lists@enginuities.com>
To: linux-dvb@linuxtv.org
Date: Thu, 2 Apr 2009 00:43:47 +1100
References: <200903140506.00723.mailing-lists@enginuities.com>
	<49D23920.5010903@iki.fi> <49D24315.8020107@iki.fi>
In-Reply-To: <49D24315.8020107@iki.fi>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904020043.48389.mailing-lists@enginuities.com>
Subject: Re: [linux-dvb] Patch for DigitalNow TinyTwin remote.
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

> But the reason I pressure you is that merge window for 2.6.30 is open
> only few days. After that we cannot put new code / functionality until
> 2.6.31 opens and it is very many months from that day.
>
> 1.) I suggest that you make very small patch adding basic support for
> TinyTwin remote (mainly add device IDs to same places as TwinHan).

There are two patches in my last email which I believe achieve this. One simply 
removes the if statement so that the AzureWave IR tables are assigned for the 
TinyTwin. The other adds the TinyTwin to the HID ignore list so that there are 
no repeat key presses. I've included them at the end of this email as well.

> 2.) Make other patch *later* that fix repeating issue. This one can be
> added to the  2.6.30 later (there many release candidates in next
> months) as bug fix.

I've been looking through usb sniffs when plugging the TinyTwin in and can't see 
much that's different. There's a slight difference in the first 4 bytes of each 
packet sent for the firmware, for example the first packet for each:

Linux:   00 51 00 00
Windows: 38 51 00 c0

The IR table download is also sent slightly differently, in Linux it's:

21 .. 00 9a 56 00 00 01 00

from

struct req_t req = {WRITE_MEMORY, 0, 0, 0, 0, 1, NULL};
req.addr = 0x9a56

While Windows is:

21 .. 38 9a 56 4e 80 01 00

which would be

struct req_t req = {WRITE_MEMORY, AF9015_I2C_DEMOD, 0, 4e, 80, 1, NULL};
req.addr = 0x9a56

I'm not sure what req.mbox = 0x4e or req.addr_len = 0x80 mean.

There are also a few addresses either different or missing (0xd508, 0xd73a, 
0xaeff, ...) in various . I'm not sure if any of them could have anything to do 
with how the IR behaves...

I'll try and check these to see if they make any difference when I get a chance.

Regards,

Stuart

af9015-b0ba0a6dfca1_tinytwin_remote.patch:
--- orig/drivers/media/dvb/dvb-usb/af9015.c	2009-03-31 07:57:51.000000000 +1100
+++ new/drivers/media/dvb/dvb-usb/af9015.c	2009-03-31 11:44:16.000000000 +1100
@@ -785,17 +785,14 @@ static int af9015_read_config(struct usb
 				  ARRAY_SIZE(af9015_ir_table_leadtek);
 				break;
 			case USB_VID_VISIONPLUS:
-				if (udev->descriptor.idProduct ==
-				cpu_to_le16(USB_PID_AZUREWAVE_AD_TU700)) {
-					af9015_properties[i].rc_key_map =
-					  af9015_rc_keys_twinhan;
-					af9015_properties[i].rc_key_map_size =
-					  ARRAY_SIZE(af9015_rc_keys_twinhan);
-					af9015_config.ir_table =
-					  af9015_ir_table_twinhan;
-					af9015_config.ir_table_size =
-					  ARRAY_SIZE(af9015_ir_table_twinhan);
-				}
+				af9015_properties[i].rc_key_map =
+				  af9015_rc_keys_twinhan;
+				af9015_properties[i].rc_key_map_size =
+				  ARRAY_SIZE(af9015_rc_keys_twinhan);
+				af9015_config.ir_table =
+				  af9015_ir_table_twinhan;
+				af9015_config.ir_table_size =
+				  ARRAY_SIZE(af9015_ir_table_twinhan);
 				break;
 			case USB_VID_KWORLD_2:
 				/* TODO: use correct rc keys */

kernel-2.6.29_tinytwin_remote_patch.diff:
--- orig/drivers/hid/hid-core.c	2009-03-24 10:12:14.000000000 +1100
+++ new/drivers/hid/hid-core.c	2009-03-31 15:08:13.000000000 +1100
@@ -1629,6 +1629,7 @@ static const struct hid_device_id hid_ig
 	{ HID_USB_DEVICE(USB_VENDOR_ID_WISEGROUP, USB_DEVICE_ID_1_PHIDGETSERVO_20) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_WISEGROUP, USB_DEVICE_ID_8_8_4_IF_KIT) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_YEALINK, USB_DEVICE_ID_YEALINK_P1K_P4K_B2K) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_DIGITALNOW, USB_DEVICE_ID_DIGITALNOW_TINYTWIN) 
},
 	{ }
 };
 
--- orig/drivers/hid/hid-ids.h	2009-03-24 10:12:14.000000000 +1100
+++ new/drivers/hid/hid-ids.h	2009-03-31 15:09:05.000000000 +1100
@@ -420,4 +420,7 @@
 #define USB_VENDOR_ID_KYE		0x0458
 #define USB_DEVICE_ID_KYE_GPEN_560	0x5003
 
+#define USB_VENDOR_ID_DIGITALNOW	0x13d3
+#define USB_DEVICE_ID_DIGITALNOW_TINYTWIN	0x3226
+
 #endif


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
