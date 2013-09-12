Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f177.google.com ([209.85.215.177]:50998 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756460Ab3ILXcp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Sep 2013 19:32:45 -0400
Received: by mail-ea0-f177.google.com with SMTP id f15so220588eak.8
        for <linux-media@vger.kernel.org>; Thu, 12 Sep 2013 16:32:44 -0700 (PDT)
Date: Fri, 13 Sep 2013 01:32:41 +0200
From: =?UTF-8?B?QW5kcsOp?= Roth <neolynx@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 3/3] [media] siano: Fix initialization for Stellar
 models
Message-ID: <20130913013241.6861324b@neutrino.exnihilo>
In-Reply-To: <1379016000-19577-4-git-send-email-m.chehab@samsung.com>
References: <1379016000-19577-1-git-send-email-m.chehab@samsung.com>
	<1379016000-19577-4-git-send-email-m.chehab@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 12 Sep 2013 17:00:00 -0300
Mauro Carvalho Chehab <m.chehab@samsung.com> wrote:

Tested-by: André Roth <neolynx@gmail.com>


> Since kernel 3.8, the initialization for Stellar (sms1000)
> devices are broken.
> 
> Those devices have a behaviour different than usual sms1100
> and sms2270: they start with one USB ID (devices in cold state),
> but after firmware load, they get a different USB ID.
> 
> This weren't docummented at the driver. So, the patches that added
> support for sms2270 broke it.
> 
> Properly documment it, and provide a debug log that allows to
> follow all phases of the device initialization:
> 
> 	smsusb_probe: board id=13, interface number 0
> 	smsusb_probe: interface 0 won't be used. Expecting interface 1 to popup
> 	smsusb_probe: board id=13, interface number 1
> 	smsusb_probe: smsusb_probe 1
> 	smsusb_probe: endpoint 0 81 02 64
> 	smsusb_probe: endpoint 1 02 02 64
> 	smsusb_probe: stellar device in cold state was found at usb\4-2.
> 	smsusb1_load_firmware: sent 38144(38144) bytes, rc 0
> 	smsusb1_load_firmware: read FW dvbt_bda_stellar_usb.inp, size=38144
> 	smsusb_probe: stellar device now in warm state
> 	usbcore: registered new interface driver smsusb
> 	usb 4-2: USB disconnect, device number 52
> 	usb 4-2: new full-speed USB device number 53 using uhci_hcd
> 	usb 4-2: New USB device found, idVendor=187f, idProduct=0100
> 	usb 4-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> 	usb 4-2: Product: SMS DVBT-BDA Receiver
> 	usb 4-2: Manufacturer: Siano Mobile Silicon
> 	smsusb_probe: board id=1, interface number 0
> 	smsusb_probe: smsusb_probe 0
> 	smsusb_probe: endpoint 0 81 02 64
> 	smsusb_probe: endpoint 1 02 02 64
> 	smsusb_init_device: in_ep = 81, out_ep = 02
> 	smscore_register_device: allocated 50 buffers
> 	smscore_register_device: device ffff88012a00bc00 created
> 	smsusb_init_device: smsusb_start_streaming(...).
> 	smscore_set_device_mode: set device mode to 4
> 	smsusb1_detectmode: 4 "SMS DVBT-BDA Receiver"
> 	smsusb_sendrequest: sending MSG_SMS_INIT_DEVICE_REQ(578) size: 12
> 	smsusb_onresponse: received MSG_SMS_INIT_DEVICE_RES(579) size: 12
> 	smscore_set_device_mode: Success setting device mode.
> 	smscore_init_ir: IR port has not been detected
> 	smscore_start_device: device ffff88012a00bc00 started, rc 0
> 	smsusb_init_device: device 0xffff88002cfa6000 created
> 	smsusb_probe: Device initialized with return code 0
> 	DVB: registering new adapter (Siano Stellar Digital Receiver)
> 	usb 4-2: DVB: registering adapter 0 frontend 0 (Siano Mobile Digital MDTV Receiver)...
> 	smscore_register_client: ffff88012174a000 693 1
> 	sms_board_dvb3_event: DVB3_EVENT_HOTPLUG
> 	smsdvb_hotplug: success
> 	smsdvb_module_init:
> 
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> ---
>  drivers/media/usb/siano/smsusb.c | 22 ++++++++++++++++++----
>  1 file changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/usb/siano/smsusb.c b/drivers/media/usb/siano/smsusb.c
> index 74236b8..33f3575 100644
> --- a/drivers/media/usb/siano/smsusb.c
> +++ b/drivers/media/usb/siano/smsusb.c
> @@ -491,15 +491,26 @@ static int smsusb_probe(struct usb_interface *intf,
>  	}
>  
>  	if (id->driver_info == SMS1XXX_BOARD_SIANO_STELLAR_ROM) {
> +		/* Detected a Siano Stellar uninitialized */
> +
>  		snprintf(devpath, sizeof(devpath), "usb\\%d-%s",
>  			 udev->bus->busnum, udev->devpath);
> -		sms_info("stellar device was found.");
> -		return smsusb1_load_firmware(
> +		sms_info("stellar device in cold state was found at %s.", devpath);
> +		rc = smsusb1_load_firmware(
>  				udev, smscore_registry_getmode(devpath),
>  				id->driver_info);
> +
> +		/* This device will reset and gain another USB ID */
> +		if (!rc)
> +			sms_info("stellar device now in warm state");
> +		else
> +			sms_err("Failed to put stellar in warm state. Error: %d", rc);
> +
> +		return rc;
> +	} else {
> +		rc = smsusb_init_device(intf, id->driver_info);
>  	}
>  
> -	rc = smsusb_init_device(intf, id->driver_info);
>  	sms_info("Device initialized with return code %d", rc);
>  	sms_board_load_modules(id->driver_info);
>  	return rc;
> @@ -552,10 +563,13 @@ static int smsusb_resume(struct usb_interface *intf)
>  }
>  
>  static const struct usb_device_id smsusb_id_table[] = {
> +	/* This device is only present before firmware load */
>  	{ USB_DEVICE(0x187f, 0x0010),
> -		.driver_info = SMS1XXX_BOARD_SIANO_STELLAR },
> +		.driver_info = SMS1XXX_BOARD_SIANO_STELLAR_ROM },
> +	/* This device pops up after firmware load */
>  	{ USB_DEVICE(0x187f, 0x0100),
>  		.driver_info = SMS1XXX_BOARD_SIANO_STELLAR },
> +
>  	{ USB_DEVICE(0x187f, 0x0200),
>  		.driver_info = SMS1XXX_BOARD_SIANO_NOVA_A },
>  	{ USB_DEVICE(0x187f, 0x0201),
