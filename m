Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:34465 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751344AbdB0VMm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Feb 2017 16:12:42 -0500
Received: by mail-lf0-f67.google.com with SMTP id a198so4403661lfb.1
        for <linux-media@vger.kernel.org>; Mon, 27 Feb 2017 13:12:21 -0800 (PST)
Received: from [192.168.0.15] (78-11-165-59.static.ip.netia.com.pl. [78.11.165.59])
        by smtp.gmail.com with ESMTPSA id t125sm2838001lff.31.2017.02.27.12.21.25
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Feb 2017 12:21:25 -0800 (PST)
From: =?utf-8?Q?=C5=81ukasz_Strzeszkowski?=
        <lukasz.strzeszkowski@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Subject: em28xx: new board id [1d19:6901]
Message-Id: <69E7B5B4-6359-4AD6-8F36-5E1A33A05C1D@gmail.com>
Date: Mon, 27 Feb 2017 21:21:24 +0100
To: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

	I=E2=80=99ve found a new device which is not listed

model: LogiLink VG0011
vendor/product: [1d19:6901] Dexatek Technology Ltd.

mode: analog

I am unable to load a driver, because there is no such vendor in driver =
list.

dmesg output:
[ 1232.506295] usb 2-4: new high-speed USB device number 4 using =
xhci_hcd
[ 1232.637496] usb 2-4: New USB device found, idVendor=3D1d19, =
idProduct=3D6901
[ 1232.637500] usb 2-4: New USB device strings: Mfr=3D0, Product=3D1, =
SerialNumber=3D0
[ 1232.637502] usb 2-4: Product: USB 2861 Video
[ 1232.660061] usbcore: registered new interface driver snd-usb-audio


Regards
=C5=81ukasz Strzeszkowski=
