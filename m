Return-path: <linux-media-owner@vger.kernel.org>
Received: from psa.adit.fi ([217.112.250.17]:42403 "EHLO psa.adit.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755933Ab0BDNVu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Feb 2010 08:21:50 -0500
Message-ID: <4B6ACA4B.2030906@adit.fi>
Date: Thu, 04 Feb 2010 15:23:23 +0200
From: Pekka Sarnila <sarnila@adit.fi>
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Jiri Kosina <jkosina@suse.cz>, Antti Palosaari <crope@iki.fi>,
	mchehab@infradead.org, linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 1/1] media: dvb-usb/af9015, fix disconnection crashes
References: <1264007972-6261-1-git-send-email-jslaby@suse.cz> <4B5CDB53.6030009@iki.fi> <4B5D6098.7010700@gmail.com> <4B5DDDFB.5020907@iki.fi> <alpine.LRH.2.00.1001261406010.15694@twin.jikos.cz> <4B6AA211.1060707@gmail.com>
In-Reply-To: <4B6AA211.1060707@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Well the thing is that this device (afatech) offers two different ways 
to read the remote: vendor class bulk endpoint (0/81, used afatech 
driver) and HID class interrupt endpoint (1/83, seen as an ordinary usb 
keyboard by the usb/hid system). When I used unmodified kernel (with new 
firmware) both of these were used simultaneously. When added afatech to 
hid blacklist hid of course did not work any more, so only the bulk 
endpoint was used, and things worked trough afatech driver, nor was the 
HID FULLSPEED QUIRK needed.

The problem using vendor class is that there is no standard. Each vendor 
can define its own way using endpoints (and has done so e.g Logitech 
joysticks). Thus each usb ir receiver must have its own specific driver. 
  However then you get the raw ir codes. When using HID class, generic 
HID driver can do the job. But then you get HID key codes directly not 
ir codes.

Also this should not be seen at all as dvb question. First, not all the 
world uses dvb standard (including USA) but uses very similar tv-sticks 
with identical ir receivers and remotes. Second there are many other 
type of usb devices with ir receiver. So dvb layer should not be 
involved at all. There maybe would be need for hid-ir-remote layer (your 
code suggestion moved there). However even there IMHO better would be 
just to improve HID <-> input layer interface so that input layer could 
divert the remotes input to generic remotes layer instead of keyboard 
layer. IMHO this would be the real linux way.

The FULLSPEED thing is really not ir receiver specific problem. It can 
happen with any device with interrupt endpoint. That's the reason why I 
placed the quirk to HID driver.

However even the HID driver is logically a wrong place. Really it should 
belong to the usb/endpoint layer because this really is not HID specific 
problem but usb layer problem (as also Jiri Kosina then pointed out). 
However linux usb layer has been build so that it was technically 
impossible to put it there without completely redesigning usb <-> higher 
layer (including HID) interface. But I'm of the opinion that that 
redesign should be done anyway. Even when no quirk is needed interrupt 
endpoint handling is a usb level task not a hid level (or any other 
higher level) task. The usb layer should do the interrupt endpoint 
polling and just put up interrupt events to higher layers. Partly this 
confusion is due the poor usb/hid specifications. It really should be a 
device/endpoint-quirk.

Now the question is, how much all usb based ir receivers have in common, 
and how much they differ. This should determine on what level and in 
which way they should be handled. How much and on what level there 
should be common code and where device specific driver code would be 
needed and where and how the ir-to-code translate should take place.

IMHO all that have HID endpoint that works (either as such or with some 
generic quirk) should be handled by HID first and then conveyed to 
generic remotes layer that handles all remote controllers what ever the 
lower layers (and does translate per remote not per ir receiver). Vendor 
class should be avoided unless that's the only way to make it work 
right. But using HID is not without problems either.

Now with the two receivers that need the quirk. If they don't have 
vendor class bulk endpoint for reading ir codes, then specific driver is 
out anyway. However then changes to HID driver would be needed to make 
the translate work. The quirk just makes them work as generic usb 
keyboard with no remote specific translate. With afatech, driver loads 
the translate table to the device, different for different remotes. I 
don't know if one table could handle them all. Maybe this table should 
be loaded from a user space file. Nor do I know how it is with other 
receivers: can the table be loaded or is it fixed. In any case a generic 
secondary per remote user configurable translate would be highly 
desirable. And I don't mean lircd. This job is IMHO kernel level job and 
lircd won't work here anyway. It does ir code to key code or function 
translate not key code to key code translate. How nice it would be if 
there would be a generic usb ir receiver class that all vendors used. 
There seems to be no way to  make this well and clean.

Well it got a bit long, but the problem is not simple either, and it 
cuts trough many parts (and maintainers) of the kernel.

So what to do?

Pekka

Jiri Slaby wrote:
> On 01/26/2010 02:08 PM, Jiri Kosina wrote:
> 
>>>In my understanding the cause of the remote problem is chipset bug which sets
>>>USB2.0 polling interval to 4096ms. Therefore HID remote does not work at all
>>>or starts repeating. It is possible to implement remote as polling from the
>>>driver which works very well. But HID problem still remains. I have some hacks
>>>in my mind to test to kill HID. One is to configure HID wrongly to see if it
>>>stops outputting characters. Other way is try to read remote codes directly
>>>from the chip memory.
>>
>>Yes, Pekka Sarnila has added this workaround to the HID driver, as the 
>>device is apparently broken.
>>
>>I want to better understand why others are not hitting this with the 
>>DVB remote driver before removing the quirk from HID code completely.
> 
> 
> I think, we should go for a better way. Thanks Pekka for hints, I ended
> up with the patch in the attachment. Could you try it whether it works
> for you?
> 
> I have 2 dvb-t receivers and both of them need fullspeed quirk. Further
> disable_rc_polling (a dvb_usb module parameter) must be set to not get
> doubled characters now. And then, it works like a charm.
> 
> Note that, it's just some kind of proof of concept. A migration of
> af9015 devices from dvb-usb-remote needs to be done first.
> 
> Ideas, comments?
> 
> regards,
> 
> 
> ------------------------------------------------------------------------
> 
> diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
> index 139668d..0daf90a 100644
> --- a/drivers/hid/Kconfig
> +++ b/drivers/hid/Kconfig
> @@ -122,6 +122,13 @@ config DRAGONRISE_FF
>  	Say Y here if you want to enable force feedback support for DragonRise Inc.
>  	game controllers.
>  
> +config HID_DVB
> +	tristate "DVB remotes support" if EMBEDDED
> +	depends on USB_HID
> +	default !EMBEDDED
> +	---help---
> +	Say Y here if you have DVB remote controllers.
> +
>  config HID_EZKEY
>  	tristate "Ezkey" if EMBEDDED
>  	depends on USB_HID
> diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
> index b62d4b3..a336b2a 100644
> --- a/drivers/hid/Makefile
> +++ b/drivers/hid/Makefile
> @@ -30,6 +30,7 @@ obj-$(CONFIG_HID_CHERRY)	+= hid-cherry.o
>  obj-$(CONFIG_HID_CHICONY)	+= hid-chicony.o
>  obj-$(CONFIG_HID_CYPRESS)	+= hid-cypress.o
>  obj-$(CONFIG_HID_DRAGONRISE)	+= hid-drff.o
> +obj-$(CONFIG_HID_DVB)		+= hid-dvb.o
>  obj-$(CONFIG_HID_EZKEY)		+= hid-ezkey.o
>  obj-$(CONFIG_HID_GYRATION)	+= hid-gyration.o
>  obj-$(CONFIG_HID_KENSINGTON)	+= hid-kensington.o
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index 2dd9b28..678c553 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -1252,6 +1252,7 @@ static const struct hid_device_id hid_blacklist[] = {
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_3M, USB_DEVICE_ID_3M1968) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_A4TECH, USB_DEVICE_ID_A4TECH_WCP32PU) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_A4TECH, USB_DEVICE_ID_A4TECH_X5_005D) },
> +	{ HID_USB_DEVICE(USB_VENDOR_ID_AFATECH, USB_DEVICE_ID_AFATECH_AF9016) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ATV_IRCONTROL) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_IRCONTROL4) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_MIGHTYMOUSE) },
> @@ -1310,6 +1311,7 @@ static const struct hid_device_id hid_blacklist[] = {
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_KENSINGTON, USB_DEVICE_ID_KS_SLIMBLADE) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_ERGO_525V) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_LABTEC, USB_DEVICE_ID_LABTEC_WIRELESS_KEYBOARD) },
> +	{ HID_USB_DEVICE(USB_VENDOR_ID_LEADTEK, USB_DEVICE_ID_DTV_GOLD) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_MX3000_RECEIVER) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_S510_RECEIVER) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_S510_RECEIVER_2) },
> diff --git a/drivers/hid/hid-dvb.c b/drivers/hid/hid-dvb.c
> new file mode 100644
> index 0000000..ee94c07
> --- /dev/null
> +++ b/drivers/hid/hid-dvb.c
> @@ -0,0 +1,78 @@
> +/*
> + *  HID driver for dvb devices
> + *
> + *  Copyright (c) 2010 Jiri Slaby
> + *
> + *  Licensed under the GPLv2.
> + */
> +
> +#include <linux/device.h>
> +#include <linux/hid.h>
> +#include <linux/module.h>
> +
> +#include "hid-ids.h"
> +
> +#define FULLSPEED_INTERVAL	0x1
> +
> +static int dvb_event(struct hid_device *hdev, struct hid_field *field,
> +		struct hid_usage *usage, __s32 value)
> +{
> +	/* we won't get a "key up" event */
> +	if (value) {
> +		input_event(field->hidinput->input, usage->type, usage->code, 1);
> +		input_event(field->hidinput->input, usage->type, usage->code, 0);
> +	}
> +	return 1;
> +}
> +
> +static int dvb_probe(struct hid_device *hdev, const struct hid_device_id *id)
> +{
> +	unsigned long quirks = id->driver_data;
> +	int ret;
> +
> +	if (quirks & FULLSPEED_INTERVAL)
> +		hdev->quirks |= HID_QUIRK_FULLSPEED_INTERVAL;
> +
> +	ret = hid_parse(hdev);
> +	if (ret) {
> +		dev_err(&hdev->dev, "parse failed\n");
> +		goto end;
> +	}
> +
> +	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
> +	if (ret)
> +		dev_err(&hdev->dev, "hw start failed\n");
> +end:
> +	return ret;
> +}
> +
> +static const struct hid_device_id dvb_devices[] = {
> +	{ HID_USB_DEVICE(USB_VENDOR_ID_AFATECH, USB_DEVICE_ID_AFATECH_AF9016),
> +		.driver_data = FULLSPEED_INTERVAL },
> +	{ HID_USB_DEVICE(USB_VENDOR_ID_LEADTEK, USB_DEVICE_ID_DTV_GOLD),
> +		.driver_data = FULLSPEED_INTERVAL },
> +	{ }
> +};
> +
> +MODULE_DEVICE_TABLE(hid, dvb_devices);
> +
> +static struct hid_driver dvb_driver = {
> +	.name = "dvb",
> +	.id_table = dvb_devices,
> +	.probe = dvb_probe,
> +	.event = dvb_event,
> +};
> +
> +static int __init dvb_init(void)
> +{
> +	return hid_register_driver(&dvb_driver);
> +}
> +
> +static void __exit dvb_exit(void)
> +{
> +	hid_unregister_driver(&dvb_driver);
> +}
> +
> +module_init(dvb_init);
> +module_exit(dvb_exit);
> +MODULE_LICENSE("GPL v2");
> diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
> index 39ff98a..7a6495f 100644
> --- a/drivers/hid/hid-ids.h
> +++ b/drivers/hid/hid-ids.h
> @@ -18,6 +18,9 @@
>  #ifndef HID_IDS_H_FILE
>  #define HID_IDS_H_FILE
>  
> +#define USB_VENDOR_ID_LEADTEK		0x0413
> +#define USB_DEVICE_ID_DTV_GOLD		0x6029
> +
>  #define USB_VENDOR_ID_3M		0x0596
>  #define USB_DEVICE_ID_3M1968		0x0500
>  
> diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
> index 88a1c69..74aac20 100644
> --- a/drivers/hid/usbhid/hid-quirks.c
> +++ b/drivers/hid/usbhid/hid-quirks.c
> @@ -41,8 +41,6 @@ static const struct hid_blacklist {
>  	{ USB_VENDOR_ID_SAITEK, USB_DEVICE_ID_SAITEK_RUMBLEPAD, HID_QUIRK_BADPAD },
>  	{ USB_VENDOR_ID_TOPMAX, USB_DEVICE_ID_TOPMAX_COBRAPAD, HID_QUIRK_BADPAD },
>  
> -	{ USB_VENDOR_ID_AFATECH, USB_DEVICE_ID_AFATECH_AF9016, HID_QUIRK_FULLSPEED_INTERVAL },
> -
>  	{ USB_VENDOR_ID_ETURBOTOUCH, USB_DEVICE_ID_ETURBOTOUCH, HID_QUIRK_MULTI_INPUT },
>  	{ USB_VENDOR_ID_PANTHERLORD, USB_DEVICE_ID_PANTHERLORD_TWIN_USB_JOYSTICK, HID_QUIRK_MULTI_INPUT | HID_QUIRK_SKIP_OUTPUT_REPORTS },
>  	{ USB_VENDOR_ID_PLAYDOTCOM, USB_DEVICE_ID_PLAYDOTCOM_EMS_USBII, HID_QUIRK_MULTI_INPUT },
> diff --git a/drivers/media/dvb/dvb-usb/af9015.c b/drivers/media/dvb/dvb-usb/af9015.c
> index 650c913..239c2d0 100644
> --- a/drivers/media/dvb/dvb-usb/af9015.c
> +++ b/drivers/media/dvb/dvb-usb/af9015.c
> @@ -1613,7 +1613,10 @@ static int af9015_usb_probe(struct usb_interface *intf,
>  
>  	/* interface 0 is used by DVB-T receiver and
>  	   interface 1 is for remote controller (HID) */
> -	if (intf->cur_altsetting->desc.bInterfaceNumber == 0) {
> +	if (intf->cur_altsetting->desc.bInterfaceNumber != 0)
> +		return -ENODEV;
> +
> +	{
>  		ret = af9015_read_config(udev);
>  		if (ret)
>  			return ret;
