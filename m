Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35233 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753031Ab3DLOtb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Apr 2013 10:49:31 -0400
Message-ID: <51681ED4.4050601@iki.fi>
Date: Fri, 12 Apr 2013 17:48:52 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jakob Haufe <sur5r@sur5r.net>
CC: linux-media@vger.kernel.org
Subject: Re: Delock 61959
References: <CALS5Gh60mV5UiOeNPf98QrhmY_j5MDi2T1xsjRn7DzdAYj7fQg@mail.gmail.com> <CALS5Gh7=UTEz8GDq0XK97_=Uaf4gVfifweY+v50XX0AUjoHBNg@mail.gmail.com> <514EFB5E.3010808@iki.fi> <20130409144805.6dbbe71d@samsa.lan> <20130412161728.6795c609@samsa.lan>
In-Reply-To: <20130412161728.6795c609@samsa.lan>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/12/2013 05:17 PM, Jakob Haufe wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On Tue, 9 Apr 2013 14:48:05 +0200
> Jakob Haufe <sur5r@sur5r.net> wrote:
>
>> Will do so tonight and report back.
>
> Took a little longer but it worked as expected. Patch follows in a separate
> mail.
>
> dmesg output:
>
> [19.474818] em28xx: New device  USB 2875 Device @ 480 Mbps (1b80:e1cc, interface 0, class 0)
> [19.484245] em28xx: DVB interface 0 found: isoc
> [19.493626] em28xx: chip ID is em2874
> [19.771843] em2874 #0: i2c eeprom 0000: 26 00 01 00 02 08 c8 e5 f5 64 01 60 09 e5 f5 64
> [19.781820] em2874 #0: i2c eeprom 0010: 09 60 03 c2 c6 22 e5 f7 b4 03 13 e5 f6 b4 87 03
> [19.791682] em2874 #0: i2c eeprom 0020: 02 08 63 e5 f6 b4 93 03 02 06 f7 c2 c6 22 c2 c6
> [19.801429] em2874 #0: i2c eeprom 0030: 22 00 60 00 90 00 60 12 06 29 7b 95 7a 67 79 eb
> [19.810955] em2874 #0: i2c eeprom 0040: 78 1a c3 12 06 18 70 03 d3 80 01 c3 92 02 90 78
> [19.820345] em2874 #0: i2c eeprom 0050: 0b 74 96 f0 74 82 f0 90 78 5d 74 05 f0 a3 f0 22
> [19.829532] em2874 #0: i2c eeprom 0060: 00 00 00 00 1a eb 67 95 80 1b cc e1 f0 93 6b 00
> [19.838768] em2874 #0: i2c eeprom 0070: 6a 20 00 00 00 00 04 57 4e 07 09 00 00 00 00 00
> [19.848037] em2874 #0: i2c eeprom 0080: 00 00 00 00 4e 00 12 00 f0 10 44 89 88 00 00 00
> [19.857240] em2874 #0: i2c eeprom 0090: 5b 81 c0 00 00 00 20 40 20 80 02 20 01 01 00 00
> [19.866452] em2874 #0: i2c eeprom 00a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [19.875663] em2874 #0: i2c eeprom 00b0: c6 40 00 00 00 00 87 00 00 00 00 00 00 40 00 00
> [19.884863] em2874 #0: i2c eeprom 00c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 20 03
> [19.894000] em2874 #0: i2c eeprom 00d0: 55 00 53 00 42 00 20 00 32 00 38 00 37 00 35 00
> [19.903174] em2874 #0: i2c eeprom 00e0: 20 00 44 00 65 00 76 00 69 00 63 00 65 00 04 03
> [19.912282] em2874 #0: i2c eeprom 00f0: 31 00 00 00 33 00 34 00 35 00 36 00 37 00 38 00
> [19.921329] em2874 #0: i2c eeprom 0100: ... (skipped)
> [19.930134] em2874 #0: EEPROM ID = 26 00 01 00, EEPROM hash = 0xde1f879b
> [19.938967] em2874 #0: EEPROM info:
> [19.947590] em2874 #0:       microcode start address = 0x0004, boot configuration = 0x01
> [19.964171] em2874 #0:       No audio on board.
> [19.972548] em2874 #0:       500mA max power
> [19.980912] em2874 #0:       Table at offset 0x00, strings=0x0000, 0x0000, 0x0000
> [19.989859] em2874 #0: Identified as MaxMedia UB425-TC (card=84)
> [19.998518] em2874 #0: v4l2 driver version 0.2.0
> [20.012548] em2874 #0: V4L2 video device registered as video0
> [20.021268] em2874 #0: dvb set to isoc mode.
> [20.066662] drxk: status = 0x439130d9
> [20.075896] drxk: detected a drx-3913k, spin A2, xtal 20.250 MHz
> [20.158282] DRXK driver version 0.9.4300
> [20.184878] drxk: frontend initialized.
> [22.025707] em2874 #0: MaxMedia UB425-TC: only DVB-C supported by that driver version

IIRC you mentioned (on IRC?) it works well for DVB-T too? In that case 
there is likely newer DRX-K chip (with newer inbuild firmware) than 
device I added that board originally. Anyhow, it is only that log 
printing so let it be...

> [22.035149] DVB: registering new adapter (em2874 #0)
> [22.044967] usb 1-1: DVB: registering adapter 0 frontend 0 (DRXK DVB-C DVB-T)...
> [22.061012] em2874 #0: Successfully loaded em28xx-dvb
>
> I then ran tvheadend for a couple of hours and it worked without problems.
>
> I'm just wondering how to get the IR remote to work. As the UB425-TC comes
> with a remote as well I kind of expected that the codes will be the same.

I didn't add remote keytable as I was lazy at the time.

Here is pictures from my device, look if it is similar.
https://plus.google.com/photos/117997283802118441421/albums/5721245288768209697

> Would trying different values for .ir_codes make sense or is there some other
> way to find this out?

Use em28xx ir debug to dump raw codes. Then look all existing remote 
keytables if there is already correct table.

regards
Antti


-- 
http://palosaari.fi/
