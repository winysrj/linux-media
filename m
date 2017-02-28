Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:36638 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751323AbdB1Rrp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Feb 2017 12:47:45 -0500
Received: by mail-wr0-f173.google.com with SMTP id u108so13959714wrb.3
        for <linux-media@vger.kernel.org>; Tue, 28 Feb 2017 09:47:44 -0800 (PST)
Subject: Re: em28xx: new board id [1d19:6901]
To: =?UTF-8?Q?=c5=81ukasz_Strzeszkowski?=
        <lukasz.strzeszkowski@gmail.com>, linux-media@vger.kernel.org
References: <69E7B5B4-6359-4AD6-8F36-5E1A33A05C1D@gmail.com>
From: =?UTF-8?Q?Frank_Sch=c3=a4fer?= <fschaefer.oss@googlemail.com>
Message-ID: <90b137be-c567-c238-9af1-7b5c7b731fb0@googlemail.com>
Date: Tue, 28 Feb 2017 18:40:49 +0100
MIME-Version: 1.0
In-Reply-To: <69E7B5B4-6359-4AD6-8F36-5E1A33A05C1D@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 27.02.2017 um 21:21 schrieb Łukasz Strzeszkowski:
> Hi,
>
> 	I’ve found a new device which is not listed
>
> model: LogiLink VG0011
> vendor/product: [1d19:6901] Dexatek Technology Ltd.
>
> mode: analog
>
> I am unable to load a driver, because there is no such vendor in driver list.
>
> dmesg output:
> [ 1232.506295] usb 2-4: new high-speed USB device number 4 using xhci_hcd
> [ 1232.637496] usb 2-4: New USB device found, idVendor=1d19, idProduct=6901
> [ 1232.637500] usb 2-4: New USB device strings: Mfr=0, Product=1, SerialNumber=0
> [ 1232.637502] usb 2-4: Product: USB 2861 Video
> [ 1232.660061] usbcore: registered new interface driver snd-usb-audio
>
>
> Regards
> Łukasz Strzeszkowski

You can (temporarily) add the device id to the em28xx driver at runtime:

modprobe em28xx
echo 1d19 6901 > /sys/module/em28xx/drivers/usb:em28xx/new_id

Then plug in the device and see what happens.

HTH,
Frank
