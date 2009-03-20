Return-path: <linux-media-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:61694 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798AbZCTOZ0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Mar 2009 10:25:26 -0400
Received: by yx-out-2324.google.com with SMTP id 31so998894yxl.1
        for <linux-media@vger.kernel.org>; Fri, 20 Mar 2009 07:25:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49C3A5E4.9010908@linuxtv.org>
References: <878323.51314.qm@web56803.mail.re3.yahoo.com>
	 <49C3A5E4.9010908@linuxtv.org>
Date: Fri, 20 Mar 2009 10:25:23 -0400
Message-ID: <412bdbff0903200725k699a2b40xdfa69e9113239c0d@mail.gmail.com>
Subject: Re: [linux-dvb] Linux driver for Hauppauge WinTV-HVR 950Q
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: linux-media@vger.kernel.org
Cc: ZhanMa <zhan@digilinksoftware.com>,
	linux-dvb <linux-dvb@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 20, 2009 at 10:19 AM, Steven Toth <stoth@linuxtv.org> wrote:
>
> ZhanMa wrote:
>> Hi Steven,
>>
>> I am working on porting the Hauppauge WinTV-Hvr 950Q tuner driver to a
>> TI DaVinci platform which uses linux kernel 2.6.18 (MontaVista). After I
>> pluged in the tuner into the board's usb port, I got the following
>> message. It looks that the registration procedure finished but I saw the
>> message that xc5000 firmware not load yet (I already put the firmware,
>> dvb-fe-xc5000-1.1.fw, under /lib/firmware).
>>
>> So I believe it should load the firmware, otherwise the tuner would not
>> work, right? But why it didn't load?
>>
>> Please advise me how I can fix this problem, thank you so much!!
>>
>> Jason Ma
>>
>>
>>
>>
>> root@192.168.1.208:~#
>> usb 1-1.1: new high speed USB device using musb_hdrc and address 4
>> usb 1-1.1: Product: WinTV HVR-950
>> usb 1-1.1: Manufacturer: Hauppauge
>> usb 1-1.1: SerialNumber: 4031281567
>> usb 1-1.1: configuration #1 chosen from 1 choice
>> au0828_init() Debugging is enabled
>> au0828_init() USB Debugging is enabled
>> au0828 driver loaded
>> au0828_usb_probe() vendor id 0x2040
>> au0828_usb_probe() device id 0x7200
>> au0828_gpio_setup()
>> au0828_i2c_register()
>> davinci_i2c_probe_adapter: 0xc06fe858
>> davinci_evm_expander1 i2c attach [addr=0x3a,client=davinci_evm_expander1]
>>  board_i2c_expander_setup=0xc001ae8c, 0xc001ae8c
>> aic3x I2C Codec i2c attach [addr=0x1b,client=AIC3X]
>> asoc: aic3x <-> davinci-i2s mapping ok
>> au0828: i2c bus registered
>>  [au0828_usb_probe], au0828_card_setup
>> i2c_readbytes()
>>  [hauppauge_eeprom]
>> tveeprom 1-0050: Hauppauge model 72001, rev B3F0, serial# 4749727
>> tveeprom 1-0050: MAC address is 00-0D-FE-48-79-9F
>> tveeprom 1-0050: tuner model is Xceive XC5000 (idx 150, type 4)
>> tveeprom 1-0050: TV standards NTSC(M) ATSC/DVB Digital (eeprom 0x88)
>> tveeprom 1-0050: audio processor is AU8522 (idx 44)
>> tveeprom 1-0050: decoder processor is AU8522 (idx 42)
>> tveeprom 1-0050: has no radio, has IR receiver, has no IR transmitter
>> hauppauge_eeprom: hauppauge eeprom: model=72001
>> xc5000_attach()
>> xc5000 1-0061: creating new instance
>> xc5000_attach() new tuner instance
>> xc5000: Successfully identified at address 0x61
>> xc5000: Firmware has not been loaded previously
>> DVB: registering new adapter (au0828)
>> DVB: registering adapter 0 frontend -8388625 (Auvitek AU8522 QAM/8VSB
>> Frontend)...
>> Registered device AU0828 [Hauppauge HVR950Q]
>>  Registered device AU0828 [Hauppauge HVR950Q]
>> usbcore: registered new driver au0828
>>  [au0828_init], usb_register success, ret=0
>>
>>
>>
>> root@192.168.1.208:~# lsusb
>> Bus 001 Device 004: ID 2040:7200
>> Bus 001 Device 003: ID 0596:0001 MicroTouch Systems, Inc. Touchscreen
>> Bus 001 Device 002: ID 04b4:6560 Cypress Semiconductor Corp. CY7C65640
>> USB-2.0 "TetraHub"
>> Bus 001 Device 001: ID 0000:0000
>>
>>
>
> Hi,
>
> What makes you think the firmware has not loaded?
>
> - Steve
>
>
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

Hello Steven,

Perhaps he got confused by the "has not been loaded previously".  It
might also be good to find out what version of the code he is running,
since it looks like the analog support isn't being loaded.

> DVB: registering adapter 0 frontend -8388625

Also, looks like perhaps a kalloc() was done instead of a kzalloc() [I
have seen this with s5h1411 as well].

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
