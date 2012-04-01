Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37434 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297Ab2DAM3K (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Apr 2012 08:29:10 -0400
Message-ID: <4F784A13.5000704@iki.fi>
Date: Sun, 01 Apr 2012 15:29:07 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <m@bues.ch>
CC: linux-media@vger.kernel.org,
	=?UTF-8?B?RGFuaWVsIEdsw7Zja25lcg==?= <daniel-gl@gmx.net>
Subject: Re: [GIT PULL FOR 3.5] AF9035/AF9033/TUA9001 => TerraTec Cinergy
 T Stick [0ccd:0093]
References: <4F75A7FE.8090405@iki.fi> <20120330234545.45f4e2e8@milhouse> <4F762CF5.9010303@iki.fi> <20120331001458.33f12d82@milhouse> <20120331160445.71cd1e78@milhouse> <4F771496.8080305@iki.fi> <20120331182925.3b85d2bc@milhouse> <4F77320F.8050009@iki.fi> <4F773562.6010008@iki.fi> <20120331185217.2c82c4ad@milhouse> <4F77DED5.2040103@iki.fi> <20120401103315.1149d6bf@milhouse> <20120401141940.04e5220c@milhouse>
In-Reply-To: <20120401141940.04e5220c@milhouse>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01.04.2012 15:19, Michael Büsch wrote:
>> Great work. I'll rebase my tree on the new branch and check those firmware files asap.
> Hm, none of these firmwares fix the problem. Maybe it's not a firmware
> problem after all, but just incorrectly setup tuner-i2c.
>
> Here's the dmesg log:
[...]
> [  132.018549] af9033: firmware version: LINK=11.10.10.0 OFDM=5.33.10.0
> [  132.018566] DVB: registering adapter 0 frontend 0 (Afatech AF9033 (DVB-T))...
> [  132.028370] i2c i2c-8: Fitipower FC0011 tuner attached
> [  132.028388] dvb-usb: Afatech Technologies DVB-T stick successfully initialized and connected.
> [  132.028405] af9035_init: USB speed=3 frame_size=0ff9 packet_size=80
> [  132.040019] usbcore: registered new interface driver dvb_usb_af9035
> [  145.407991] af9035_ctrl_msg: command=03 failed fw error=2
> [  145.408008] i2c i2c-8: I2C write reg failed, reg: 07, val: 0f
>
> I also tried the other firmware. Same result.

It must then be I2C adapter or I2C client issue.
Adapter code is here, and it known to work with TUA9001. TUA9001 sends 
1x byte register and then followed 2xbytes data.

u8 buf[4 + msg[0].len];
struct usb_req req = { CMD_I2C_WR, 0, sizeof(buf), buf, 0, NULL };
buf[0] = msg[0].len;
buf[1] = msg[0].addr << 1;
buf[2] = 0x01;
buf[3] = 0x00;
memcpy(&buf[4], msg[0].buf, msg[0].len);
ret = af9035_ctrl_msg(d->udev, &req);

Maybe you have given I2C address as a "8bit" format? Maybe adapter bytes 
buf[2] and buf[3] are wrong? If you have taken sniffs from windows it is 
very easy to see what is wrong.

regards
Antti
-- 
http://palosaari.fi/
