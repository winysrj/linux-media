Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:49870 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753316Ab0IJLsB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Sep 2010 07:48:01 -0400
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: Antti Palosaari <crope@iki.fi>
Subject: Re: [GIT PULL FOR 2.6.37] new AF9015 devices
Date: Fri, 10 Sep 2010 13:47:51 +0200
Cc: linux-media@vger.kernel.org
References: <4C894DB8.8080908@iki.fi> <201009100254.07762.s.L-H@gmx.de> <4C8A0488.9020206@iki.fi>
In-Reply-To: <4C8A0488.9020206@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201009101347.54116.s.L-H@gmx.de>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi

On Friday 10 September 2010, Antti Palosaari wrote:
>  sure yet how to distinguish between the
> > "Cinergy T Dual" and my "Cinergy T RC MKII":
> 
> 
> > Given that keys, once pressed, remain to be stuck, using both lirc's
> > dev/input and without any dæmon trying to catch keypresses, I have not
> > reached a functional configuration.
> 
> That`s known issue. Chip configures USB HID polling interval wrongly and 
> due to that HID starts repeating usually. There is USB-ID mapped quir

Yes, now I see it. A quickly hacked test seems to improve the stuck key 
events a lot (some keys still have a tendency to get stuck, but in general 
it works):

--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -45,6 +45,7 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_TOPMAX, USB_DEVICE_ID_TOPMAX_COBRAPAD, HID_QUIRK_BADPAD },
 
 	{ USB_VENDOR_ID_AFATECH, USB_DEVICE_ID_AFATECH_AF9016, HID_QUIRK_FULLSPEED_INTERVAL },
+	{ 0x0ccd, 0x0097, HID_QUIRK_FULLSPEED_INTERVAL },
 
 	{ USB_VENDOR_ID_ETURBOTOUCH, USB_DEVICE_ID_ETURBOTOUCH, HID_QUIRK_MULTI_INPUT },
 	{ USB_VENDOR_ID_PANTHERLORD, USB_DEVICE_ID_PANTHERLORD_TWIN_USB_JOYSTICK, HID_QUIRK_MULTI_INPUT | HID_QUIRK_SKIP_OUTPUT_REPORTS },

Regards
	Stefan Lippers-Hollmann
