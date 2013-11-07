Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3742 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab3KGHk4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Nov 2013 02:40:56 -0500
Message-ID: <527B43DD.1050405@xs4all.nl>
Date: Thu, 07 Nov 2013 08:40:13 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: "edubezval@gmail.com" <edubezval@gmail.com>
CC: Dinesh Ram <dinesh.ram@cern.ch>,
	Linux-Media <linux-media@vger.kernel.org>,
	d ram <dinesh.ram086@gmail.com>
Subject: Re: [REVIEW PATCH 6/9] si4713 : Added the USB driver for Si4713
References: <1e0bb141e349db9335a7d874cb3d900ec5837c66.1381850640.git.dinesh.ram@cern.ch> <fdfb8ed831d89ee82fd79ddefeefbd8873b6abdc.1381850640.git.dinesh.ram@cern.ch> <CAC-25o_X+Pgi3C5TKK5WpViEH=t4AdVRd072xkYmmiYmbscAYQ@mail.gmail.com>
In-Reply-To: <CAC-25o_X+Pgi3C5TKK5WpViEH=t4AdVRd072xkYmmiYmbscAYQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/05/2013 03:18 PM, edubezval@gmail.com wrote:
> Dinesh
> 
> On Tue, Oct 15, 2013 at 11:24 AM, Dinesh Ram <dinesh.ram@cern.ch> wrote:
>> This is the USB driver for the Silicon Labs development board.
>> It contains the Si4713 FM transmitter chip.
>>
> 
> I tried this driver again. The system attempts to probe the device but
> it fails because the product revision read out of the USB device is
> wrong.
> [  220.855158] usb 2-1.3.3: new full-speed USB device number 10 using ehci-pci
> [  220.949677] usb 2-1.3.3: New USB device found, idVendor=10c4, idProduct=8244
> [  220.949683] usb 2-1.3.3: New USB device strings: Mfr=1, Product=2,
> SerialNumber=3
> [  220.949688] usb 2-1.3.3: Product: Si47xx Baseboard
> [  220.949691] usb 2-1.3.3: Manufacturer: SILICON LABORATORIES INC.
> [  220.949695] usb 2-1.3.3: SerialNumber: CBDA8-00-0
> [  220.950157] usbhid 2-1.3.3:1.0: couldn't find an input interrupt endpoint
> [ 1014.981012] radio-usb-si4713 2-1.3.3:1.0: Si4713 development board
> discovered: (10C4:8244)
> [ 1015.870984] si4713 12-0063: IRQ not configured. Using timeouts.
> [ 1015.943551] si4713 12-0063: Invalid product number   <<< Here is
> the code without modification
> [ 1015.943556] si4713 12-0063: Failed to probe device information.
> [ 1015.943568] si4713: probe of 12-0063 failed with error -22
> [ 1015.943613] radio-usb-si4713 2-1.3.3:1.0: cannot get v4l2 subdevice
> [ 1015.943672] usbcore: registered new interface driver radio-usb-si4713
> [ 1274.419987] perf samples too long (2504 > 2500), lowering
> kernel.perf_event_max_sample_rate to 50000
> [ 1308.851059] usbcore: deregistering interface driver radio-usb-si4713
> [ 1500.478308] radio-usb-si4713 2-1.3.3:1.0: Si4713 development board
> discovered: (10C4:8244)
> [ 1500.612240] si4713 12-0063: IRQ not configured. Using timeouts.
> [ 1500.683489] si4713 12-0063: Invalid product number 0x15 <<< Here it
> prints the PN read
> [ 1500.683495] si4713 12-0063: Failed to probe device information.
> [ 1500.683509] si4713: probe of 12-0063 failed with error -22
> [ 1500.683558] radio-usb-si4713 2-1.3.3:1.0: cannot get v4l2 subdevice
> [ 1500.683624] usbcore: registered new interface driver radio-usb-si4713
> 
> Here is simple diff of what I used to print the PN value:
> diff --git a/drivers/media/radio/si4713/si4713.c
> b/drivers/media/radio/si4713/si4713.c
> index aadecb5..ee53584 100644
> --- a/drivers/media/radio/si4713/si4713.c
> +++ b/drivers/media/radio/si4713/si4713.c
> @@ -464,7 +464,7 @@ static int si4713_checkrev(struct si4713_device *sdev)
>                 v4l2_info(&sdev->sd, "chip found @ 0x%02x (%s)\n",
>                                 client->addr << 1, client->adapter->name);
>         } else {
> -               v4l2_err(&sdev->sd, "Invalid product number\n");
> +               v4l2_err(&sdev->sd, "Invalid product number 0x%X\n", resp[1]);
>                 rval = -EINVAL;
>         }
>         return rval;
> 
> It is expected to be 0x0D  instead of 0x15, if I am not mistaken.

What are the markings on the si471x chip on your USB board? Perhaps you have
a slightly different version of the chip?

A value of 0x15 suggests a si4721 transceiver instead of a si4713 transmitter.
Which might actually still work with this driver (although with the TX
functionality only, of course), so you might try accepting the 0x15 value.

Regards,

	Hans

> 
>> Signed-off-by: Dinesh Ram <dinesh.ram@cern.ch>
>> ---
>>  drivers/media/radio/si4713/Kconfig            |   15 +
>>  drivers/media/radio/si4713/Makefile           |    1 +
>>  drivers/media/radio/si4713/radio-usb-si4713.c |  540 +++++++++++++++++++++++++
>>  3 files changed, 556 insertions(+)
>>  create mode 100644 drivers/media/radio/si4713/radio-usb-si4713.c

