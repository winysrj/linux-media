Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail21.extendcp.co.uk ([79.170.40.21])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mailing-lists@enginuities.com>) id 1LpBWz-0006DX-H5
	for linux-dvb@linuxtv.org; Thu, 02 Apr 2009 03:15:47 +0200
Received: from [220.245.35.222] (helo=cobra.localnet)
	by mail21.extendcp.com with esmtpa (Exim 4.69) id 1LpBWv-0006Np-Iz
	for linux-dvb@linuxtv.org; Thu, 02 Apr 2009 02:15:41 +0100
From: Stuart <mailing-lists@enginuities.com>
To: linux-dvb@linuxtv.org
Date: Thu, 2 Apr 2009 12:17:08 +1100
References: <200903140506.00723.mailing-lists@enginuities.com>
	<200904020043.48389.mailing-lists@enginuities.com>
	<49D3ECE4.4030008@iki.fi>
In-Reply-To: <49D3ECE4.4030008@iki.fi>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904021217.09037.mailing-lists@enginuities.com>
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

Patch to provide basic support for DigitalNow TinyTwin Remote.

Signed-off-by: Stuart Hall <mailing-lists@enginuities.com>

af9015-b0ba0a6dfca1_tinytwin_remote.patch
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


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
