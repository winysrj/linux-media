Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f176.google.com ([209.85.217.176]:35011 "EHLO
        mail-ua0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751252AbdAQUnP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Jan 2017 15:43:15 -0500
Received: by mail-ua0-f176.google.com with SMTP id y9so112458620uae.2
        for <linux-media@vger.kernel.org>; Tue, 17 Jan 2017 12:43:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <dcdc9f56-7127-47f8-3ff0-1206e4f4bada@iki.fi>
References: <20170116232934.8230-1-crope@iki.fi> <dcdc9f56-7127-47f8-3ff0-1206e4f4bada@iki.fi>
From: Chris Rankin <rankincj@gmail.com>
Date: Tue, 17 Jan 2017 20:43:13 +0000
Message-ID: <CAK2bqVJ=SbycQN4w11NxzMAD2+hVCUz_+kui9EfGjS8_yvm07g@mail.gmail.com>
Subject: Re: [PATCH] cxd2820r: fix gpio null pointer dereference
To: Antti Palosaari <crope@iki.fi>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        =?UTF-8?B?SMOla2FuIExlbm5lc3TDpWw=?= <hakan.lennestal@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 16 January 2017 at 23:40, Antti Palosaari <crope@iki.fi> wrote:
> Chris and H=C3=A5kan, test please without Kconfig CONFIG_GPIOLIB option. =
I cannot
> test it properly as there seems to quite many drivers selecting this opti=
on
> by default.

Works here :-)

Tested-by: Chris Rankin <rankincj@gmail.com>

[  125.162762] usb 4-4: new high-speed USB device number 4 using ehci-pci
[  125.326832] em28xx: New device PCTV Systems PCTV 290e @ 480 Mbps
(2013:024f, interface 0, class 0)
[  125.334573] em28xx: DVB interface 0 found: isoc
[  125.337981] em28xx: chip ID is em28174
[  125.674813] em28174 #0: EEPROM ID =3D 26 00 01 00, EEPROM hash =3D 0x1eb=
936d2
[  125.680331] em28174 #0: EEPROM info:
[  125.682610] em28174 #0:      microcode start address =3D 0x0004, boot
configuration =3D 0x01
[  125.716963] em28174 #0:      No audio on board.
[  125.719856] em28174 #0:      500mA max power
[  125.722495] em28174 #0:      Table at offset 0x39, strings=3D0x1aa0,
0x14ba, 0x1ace
[  125.728384] em28174 #0: Identified as PCTV nanoStick T2 290e (card=3D78)
[  125.733669] em28174 #0: dvb set to isoc mode.
[  125.736863] usbcore: registered new interface driver em28xx
[  125.751373] em28174 #0: Binding DVB extension
[  125.763306] cxd2820r 11-006c: Sony CXD2820R successfully identified
[  125.770763] tda18271 11-0060: creating new instance
[  125.783435] tda18271: TDA18271HD/C2 detected @ 11-0060
[  125.980162] DVB: registering new adapter (em28174 #0)
[  125.983923] usb 4-4: DVB: registering adapter 0 frontend 0 (Sony CXD2820=
R)...
[  125.991316] em28174 #0: DVB extension successfully initialized
[  125.995962] em28xx: Registered (Em28xx dvb Extension) extension
[  126.003999] em28174 #0: Registering input extension
[  126.035656] Registered IR keymap rc-pinnacle-pctv-hd
[  126.039589] input: em28xx IR (em28174 #0) as
/devices/pci0000:00/0000:00:1d.7/usb4/4-4/rc/rc0/input23
[  126.047940] rc rc0: em28xx IR (em28174 #0) as
/devices/pci0000:00/0000:00:1d.7/usb4/4-4/rc/rc0
[  126.056022] em28174 #0: Input extension successfully initalized
[  126.060706] em28xx: Registered (Em28xx Input Extension) extension

Cheers,
Chris
