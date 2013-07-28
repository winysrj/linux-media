Return-path: <linux-media-owner@vger.kernel.org>
Received: from stevekez.vm.bytemark.co.uk ([80.68.91.30]:57889 "EHLO
	stevekerrison.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502Ab3G1Nlh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Jul 2013 09:41:37 -0400
Message-ID: <51F51E03.9050107@stevekerrison.com>
Date: Sun, 28 Jul 2013 14:34:59 +0100
From: Steve Kerrison <steve@stevekerrison.com>
MIME-Version: 1.0
To: Chris Rankin <rankincj@yahoo.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Very verbose message about em28174 chip.
References: <1375017565.30131.YahooMailNeo@web120305.mail.ne1.yahoo.com>
In-Reply-To: <1375017565.30131.YahooMailNeo@web120305.mail.ne1.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

It's normal for em28xx to give you that sort of information on 
device-plug - it does seem like a lot, but it's effectively "one-off" 
and you probably won't see much else during use of the device, under 
default module parameters. It's very useful log output if you have a new 
device or a slight variant of an existing one, as it takes very little 
effort to copy & paste the details here to help figure out how easy it 
is to support the device.

But as you know, that device works already, so you can just ignore it :)

Regards,
Steve.

On 28/07/13 14:19, Chris Rankin wrote:
> Hi,
>
> I plugged my PCTV 290e device into my newly compiled 3.10.3 kernel today, and found this message in the dmesg log.
>
>
> [  511.041412] usb 10-4: new high-speed USB device number 3 using ehci-pci
> [  511.216218] em28xx: New device PCTV Systems PCTV 290e @ 480 Mbps (2013:024f, interface 0, class 0)
> [  511.223916] em28xx: DVB interface 0 found: isoc
> [  511.227398] em28xx: chip ID is em28174
> [  511.548310] em28174 #0: i2c eeprom 0000: 26 00 01 00 02 09 d8 85 80 80 e5 80 f4 f5 94 90
> [  511.555554] em28174 #0: i2c eeprom 0010: 78 0d e4 f0 f5 46 12 00 5a c2 eb c2 e8 30 e9 03
> [  511.562682] em28174 #0: i2c eeprom 0020: 12 09 de 30 eb 03 12 09 10 30 ec f1 12 07 72 80
> [  511.569827] em28174 #0: i2c eeprom 0030: ec 00 60 00 e5 f5 64 01 60 09 e5 f5 64 09 60 03
> [  511.576937] em28174 #0: i2c eeprom 0040: c2 c6 22 e5 f7 b4 03 13 e5 f6 b4 87 03 02 09 92
> [  511.584138] em28174 #0: i2c eeprom 0050: e5 f6 b4 93 03 02 07 e6 c2 c6 22 c2 c6 22 12 09
> [  511.591273] em28174 #0: i2c eeprom 0060: cf 02 06 19 1a eb 67 95 13 20 4f 02 c0 13 6b 10
> [  511.598453] em28174 #0: i2c eeprom 0070: a0 1a ba 14 ce 1a 39 57 00 5c 18 00 00 00 00 00
> [  511.605572] em28174 #0: i2c eeprom 0080: 00 00 00 00 44 36 00 00 f0 10 02 00 00 00 00 00
> [  511.612694] em28174 #0: i2c eeprom 0090: 5b 23 c0 00 00 00 20 40 20 80 02 20 01 01 00 00
> [  511.619821] em28174 #0: i2c eeprom 00a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [  511.627001] em28174 #0: i2c eeprom 00b0: c6 40 00 00 00 00 a7 00 00 00 00 00 00 00 00 00
> [  511.634120] em28174 #0: i2c eeprom 00c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 38 32
> [  511.641199] em28174 #0: i2c eeprom 00d0: 34 31 30 31 31 36 36 30 31 37 31 31 32 36 58 59
> [  511.648319] em28174 #0: i2c eeprom 00e0: 56 49 00 4f 53 49 30 30 33 30 38 44 30 31 30 36
> [  511.655473] em28174 #0: i2c eeprom 00f0: 58 59 56 49 00 00 00 00 00 00 00 00 00 00 30 36
> [  511.662628] em28174 #0: i2c eeprom 0100: ... (skipped)
> [  511.666500] em28174 #0: EEPROM ID = 26 00 01 00, EEPROM hash = 0x1eb936d2
> [  511.672023] em28174 #0: EEPROM info:
> [  511.674338] em28174 #0:     microcode start address = 0x0004, boot configuration = 0x01
> [  511.705368] em28174 #0:     No audio on board.
> [  511.708286] em28174 #0:     500mA max power
> [  511.710988] em28174 #0:     Table at offset 0x00, strings=0x0000, 0x0000, 0x0000
> [  511.717120] em28174 #0: Identified as PCTV nanoStick T2 290e (card=78)
> [  511.722436] em28174 #0: v4l2 driver version 0.2.0
> [  511.731410] em28174 #0: V4L2 video device registered as video1
> [  511.736043] em28174 #0: dvb set to isoc mode.
> [  511.739638] usbcore: registered new interface driver em28xx
> [  511.821414] tda18271 7-0060: creating new instance
> [  511.829520] TDA18271HD/C2 detected @ 7-0060
> [  512.000542] DVB: registering new adapter (em28174 #0)
> [  512.004325] usb 10-4: DVB: registering adapter 0 frontend 0 (Sony CXD2820R)...
> [  512.011191] em28174 #0: Successfully loaded em28xx-dvb
> [  512.015077] Em28xx: Initialized (Em28xx dvb Extension) extension
> [  512.056753] Registered IR keymap rc-pinnacle-pctv-hd
> [  512.060784] input: em28xx IR (em28174 #0) as /devices/pci0000:00/0000:00:1d.7/usb10/10-4/rc/rc0/input16
> [  512.069167] rc0: em28xx IR (em28174 #0) as /devices/pci0000:00/0000:00:1d.7/usb10/10-4/rc/rc0
> [  512.076882] Em28xx: Initialized (Em28xx Input Extension) extension
> [  552.064828] tda18271: performing RF tracking filter calibration
> [  554.417676] tda18271: RF tracking filter calibration complete
>
>
> Presumably something this verbose is intended to be shared, so here it is. (I can't think of any other reason why this amount of information would be logged by default).
>
>
> Cheers,
> Chris
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Steve Kerrison MEng Hons.
http://www.stevekerrison.com/

