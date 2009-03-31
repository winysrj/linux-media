Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail21.extendcp.co.uk ([79.170.40.21])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mailing-lists@enginuities.com>) id 1LoeYS-0002ms-Bn
	for linux-dvb@linuxtv.org; Tue, 31 Mar 2009 16:03:05 +0200
Received: from 220-244-170-229.static.tpgi.com.au ([220.244.170.229]
	helo=cobra.localnet) by mail21.extendcp.com with esmtpa (Exim 4.63)
	id 1LoeYN-0006t8-Uc
	for linux-dvb@linuxtv.org; Tue, 31 Mar 2009 15:03:00 +0100
From: Stuart <mailing-lists@enginuities.com>
To: linux-dvb@linuxtv.org
Date: Wed, 1 Apr 2009 01:04:03 +1100
References: <200903140506.00723.mailing-lists@enginuities.com>
	<49CCEEAF.4000703@iki.fi> <49D13111.9020300@iki.fi>
In-Reply-To: <49D13111.9020300@iki.fi>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904010104.06886.mailing-lists@enginuities.com>
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

Hi Antti,

> Could you make patch asap to get support for remote?

I'm still working on why the remote doesn't work with usbhid. I've included two 
patches, one applies to af9015 (b0ba0a6dfca1) and the other to kernel 2.6.29 (to 
stop HID from claiming the device and repeating key presses) which will allow 
the remote to work as the AzureWave remote through polling. I haven't fixed up 
the ir/key tables in af9015.h yet.

> take sniff:
> http://www.pcausa.com/Utilities/UsbSnoop/default.htm
> use parser to sniff:
> v4l2-apps/util/parse-sniffusb2.pl
> and try to look parsed log. You can see USB-protocol rather easily by 
> comparing driver code and sniff.

I've taken some usb sniffs, unfortunately parse-sniffusb2.pl didn't give any 
output (so I'm not sure what it should look like) but here's a snippet from 
the remote when pressing '1':

[369218 ms]  <<<  URB 13 coming back  <<<
    00000000: 00 00 1e 00 00 00 00 00
[369218 ms]  >>>  URB 15 going down  >>>
[369218 ms]  <<<  URB 14 coming back  <<<
    00000000: 00 00 1e 00 00 00 00 00
[369218 ms]  >>>  URB 16 going down  >>>
[369308 ms]  <<<  URB 15 coming back  <<<
    00000000: 00 00 00 00 00 00 00 00
[369308 ms]  >>>  URB 17 going down  >>>

>From a usb keyboard I get this:

[16732 ms]  <<<  URB 7 coming back  <<<
    00000000: 00 00 1e 00 00 00 00 00
[16732 ms]  >>>  URB 10 going down  >>>
[16820 ms]  <<<  URB 8 coming back  <<<
    00000000: 00 00 00 00 00 00 00 00
[16820 ms]  >>>  URB 11 going down  >>>

Obviously the incoming URB with '1e' is a key press corresponding to '1' and the 
incoming URB with all '00' is a key release.

> I haven't looked repeating issue yet... and it even does not rise up in
> my Linux box. Don't know why. I have Fedora 10 x86_64 2.7.27.

I've been looking in to this and the further I look the more complicated it 
seems to become!

Using usbmon/debugfs I can see the same behaviour in Windows/Linux for the usb 
keyboard, the remote on the other hand has a lot of traffic from the polling and 
only showed packets corresponding to key presses (no key releases in Linux).

It seems that when a key is pressed on either the keyboard or the remote at some 
point 'hid_irq_in' is called in drivers/hid/usbhid/hid-core.c which in turn 
calls 'hid_input_report' from drivers/hid/hid-core.c which calls 
'hid_report_raw_event' in the same file, this in turn calls the various drivers 
that have claimed the device (input, dev, raw).

If I add the TinyTwin device to hid_blacklist in drivers/hid/hid-core.c and 
write a driver providing a function for raw_event so it is called instead of 
'hid_report_raw_event' I can provide a 'fake' key release which to a degree 
worked, only I would see the keys pressed twice because the af9015 driver 
still generated events as well.

If I disable polling with:

echo "1" > /sys/module/dvb_usb/parameters/disable_rc_polling

I find that pressing a key on the remote generates a key press and then ~17.5 
seconds later the remote generates a key release. Any key presses (pressing any 
key on the remote) before the key release generates another key press for the 
first key, not the one actually pressed!

So far I've found a minor difference between the two firmware sent to the device 
and I'm going through usb sniffs to see what it does under Windows to see if 
this has any effect on the remote....

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
