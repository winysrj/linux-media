Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f50.google.com ([209.85.219.50]:38252 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756514Ab3A1O11 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jan 2013 09:27:27 -0500
Received: by mail-oa0-f50.google.com with SMTP id n16so2796917oag.37
        for <linux-media@vger.kernel.org>; Mon, 28 Jan 2013 06:27:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALGqSbsA9fUCVcBf3F_r7O-CbLPnjj==voy5sZ8Nf8f1MLPT9w@mail.gmail.com>
References: <CALGqSbsA9fUCVcBf3F_r7O-CbLPnjj==voy5sZ8Nf8f1MLPT9w@mail.gmail.com>
Date: Mon, 28 Jan 2013 17:27:26 +0300
Message-ID: <CALW4P+KS_ntnDW75Eoh979jRzpA=uRUTRH9FCWT13jgRK5bjTQ@mail.gmail.com>
Subject: Re: HI
From: Alexey Klimov <klimov.linux@gmail.com>
To: Igor Stamatovski <stamatovski@gmail.com>
Cc: linux-media@vger.kernel.org, Tobias Lorenz <tobias.lorenz@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Igor,

On Mon, Jan 28, 2013 at 3:14 AM, Igor Stamatovski <stamatovski@gmail.com> wrote:
> Im trying to use ADS tech instantFM music USB card.
>
> dmesg reports this after machine reset (USB stays on machine)
>
> [    6.387624] USB radio driver for Si470x FM Radio Receivers, Version 1.0.10
> [    6.930228] radio-si470x 1-1.2:1.2: DeviceID=0xffff ChipID=0xffff
> [    7.172429] radio-si470x 1-1.2:1.2: software version 0, hardware version 7
> [    7.355485] radio-si470x 1-1.2:1.2: This driver is known to work
> with software version 7,
> [    7.532554] radio-si470x 1-1.2:1.2: but the device has software version 0.
> [    7.644091] radio-si470x 1-1.2:1.2: If you have some trouble using
> this driver,
> [    7.728735] radio-si470x 1-1.2:1.2: please report to V4L ML at
> linux-media@vger.kernel.org
> [    7.840415] usbcore: registered new interface driver radio-si470x
> [    8.465398] usbcore: registered new interface driver snd-usb-audio
>
> i can note the deviceID and ChipID are not recognised but still some
> modules load for the card...
>
> after reinsert same USB card reports this
>
> [  102.460158] usb 1-1.2: USB disconnect, device number 4
> [  102.464721] radio-si470x 1-1.2:1.2: si470x_set_report:
> usb_control_msg returned -19
> [  106.535669] usb 1-1.2: new full-speed USB device number 6 using dwc_otg
> [  106.638514] usb 1-1.2: New USB device found, idVendor=06e1, idProduct=a155
> [  106.638545] usb 1-1.2: New USB device strings: Mfr=1, Product=2,
> SerialNumber=0
> [  106.638562] usb 1-1.2: Product: ADS InstantFM Music
> [  106.638576] usb 1-1.2: Manufacturer: ADS TECH
> [  106.644537] radio-si470x 1-1.2:1.2: DeviceID=0x1242 ChipID=0x0a0f
> [  106.645257] radio-si470x 1-1.2:1.2: software version 0, hardware version 7
> [  106.645288] radio-si470x 1-1.2:1.2: This driver is known to work
> with software version 7,
> [  106.645306] radio-si470x 1-1.2:1.2: but the device has software version 0.
> [  106.645321] radio-si470x 1-1.2:1.2: If you have some trouble using
> this driver,
> [  106.645337] radio-si470x 1-1.2:1.2: please report to V4L ML at
> linux-media@vger.kernel.org
>
> the radio can scan local radios and create config file with the radio
> application.
> using arecord piped to aplay does nothing.

Could you please give more details here? How do you scan local radios
and create config file? May i miss some information and this driver
can create config file by itself.

Could you please try other ways to catch sound using
Documentation/video4linux/si470x.txt file ?
There are also few possible ways described in this file:

[quote]
Audio Listing
=============
USB Audio is provided by the ALSA snd_usb_audio module. It is recommended to
also select SND_USB_AUDIO, as this is required to get sound from the radio. For
listing you have to redirect the sound, for example using one of the following
commands. Please adjust the audio devices to your needs (/dev/dsp* and hw:x,x).

If you just want to test audio (very poor quality):
cat /dev/dsp1 > /dev/dsp

If you use OSS try:
sox -2 --endian little -r 96000 -t oss /dev/dsp1 -t oss /dev/dsp

If you use arts try:
arecord -D hw:1,0 -r96000 -c2 -f S16_LE | artsdsp aplay -B -

If you use mplayer try:
mplayer -radio adevice=hw=1.0:arate=96000 \
        -rawaudio rate=96000 \
        radio://<frequency>/capture

[/quote]

> i wanted to know how do i update software version 0 to software
> version 7 and try this driver?

I don't know much about such update. May be doc file can be checked
for this also and i added Tobias (author) in c/c.

-- 
Best regards, Klimov Alexey
