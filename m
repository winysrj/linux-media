Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33848 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016Ab2GFJed (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Jul 2012 05:34:33 -0400
Message-ID: <4FF6B121.6010105@iki.fi>
Date: Fri, 06 Jul 2012 12:34:25 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Marx <acc.for.news@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: pctv452e
References: <4FF4697C.8080602@nexusuk.org> <4FF46DC4.4070204@iki.fi> <4FF4911B.9090600@web.de> <4FF4931B.7000708@iki.fi> <gjggc9-dl4.ln1@wuwek.kopernik.gliwice.pl> <4FF5A350.9070509@iki.fi> <r8cic9-ht4.ln1@wuwek.kopernik.gliwice.pl>
In-Reply-To: <r8cic9-ht4.ln1@wuwek.kopernik.gliwice.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/06/2012 09:13 AM, Marx wrote:
> On 05.07.2012 16:23, Antti Palosaari wrote:
>> Check if those modules are enabled, in file .config
>> CONFIG_DVB_USB_V2=m
>> CONFIG_DVB_USB_PCTV452E=m
>>
>> use make menuconfig to enable if disabled. Then make && make
>> install_modules && make install as usually.
>
> You were right, I didn't have this options anabled. I've enabled both
> via 'make menuconfig' and recompiled kernel. Driver loaded succesfully,
> I haven time to test only a few SD channels, and they were working, but
> some encrypted and HD didn't. I have to check yet why.

Did I missed something? PCTV device does not support CI/CAM and thus no 
support for encrypted channels. Is there still CI slot?

> Anyway when using card logs are full of i2c errors

Argh! But this must be issue of earlier driver too.

I debug it and it seems to be totally clueless implementation of 
stb6100_read_reg() as it sets device address like "device address + 
register address". This makes stb6100 I2C address of tuner set for that 
request 0x66 whilst it should be 0x60. Is that code never tested...

pctv452e DVB USB driver behaves just correctly as it says this is not 
valid and returns error.

Also pctv452e I2C adapter supports only I2C operations that are done 
with repeated STOP condition - but I cannot see there is logic to sent 
STOP after last message. I suspect it is not correct as logically but 
will work - very common mistake with many I2C adapters we have.

> Jul  6 07:04:19 wuwek kernel: [    6.087199] input: HDA ATI SB Line Out
> Front as /devices/pci0000:00/0000:00:14.2/sound/card
> 1/input8
> Jul  6 07:04:19 wuwek kernel: [    6.108046] stb6100_attach: Attaching
> STB6100
> Jul  6 07:04:19 wuwek kernel: [    6.108054] pctv452e_power_ctrl: 0
> Jul  6 07:04:19 wuwek kernel: [    6.108063] usb 1-4: dvb_usbv2: 'PCTV
> HDTV USB' successfully initialized and connected
> Jul  6 07:04:19 wuwek kernel: [    7.659462] Adding 2097148k swap on
> /dev/sda2.  Priority:-1 extents:1 across:2097148k
> Jul  6 07:04:19 wuwek kernel: [    7.707592] EXT4-fs (sda1): re-mounted.
> Opts: (null)
>
> (...)
>
> Jul  6 07:04:21 wuwek kernel: [   45.112483] Bluetooth: BNEP (Ethernet
> Emulation) ver 1.3
> Jul  6 07:04:21 wuwek kernel: [   45.112496] Bluetooth: BNEP filters:
> protocol multicast
> Jul  6 07:04:40 wuwek kernel: [   64.367411] pctv452e_power_ctrl: 1
> Jul  6 07:04:48 wuwek kernel: [   72.693972] I2C error -121; AA 0B  CC
> 00 01 -> 55 0B  CC 00 00.
> Jul  6 07:04:59 wuwek kernel: [   83.605643] I2C error -121; AA 49  CC
> 00 01 -> 55 49  CC 00 00.
> Jul  6 07:05:10 wuwek kernel: [   94.565805] I2C error -121; AA EE  CC
> 00 01 -> 55 EE  CC 00 00.
> Jul  6 07:05:10 wuwek kernel: [   94.578295] I2C error -121; AA 05  CC
> 00 01 -> 55 05  CC 00 00.
> Jul  6 07:05:10 wuwek kernel: [   94.637539] I2C error -121; AA 20  CC
> 00 01 -> 55 20  CC 00 00.
> Jul  6 07:05:18 wuwek kernel: [  102.525868] I2C error -121; AA 08  CC
> 00 01 -> 55 08  CC 00 00.
> Jul  6 07:05:18 wuwek kernel: [  102.538359] I2C error -121; AA 1F  CC
> 00 01 -> 55 1F  CC 00 00.
> Jul  6 07:05:18 wuwek kernel: [  102.597603] I2C error -121; AA 3A  CC
> 00 01 -> 55 3A  CC 00 00.
> Jul  6 07:05:29 wuwek kernel: [  113.765372] I2C error -121; AA F5  CC
> 00 01 -> 55 F5  CC 00 00.
> Jul  6 07:05:29 wuwek kernel: [  113.777986] I2C error -121; AA 0C  CC
> 00 01 -> 55 0C  CC 00 00.
> Jul  6 07:05:29 wuwek kernel: [  113.837480] I2C error -121; AA 27  CC
> 00 01 -> 55 27  CC 00 00.
> Jul  6 07:05:35 wuwek kernel: [  120.069153] I2C error -121; AA CF  CC
> 00 01 -> 55 CF  CC 00 00.
> Jul  6 07:05:37 wuwek kernel: [  121.325610] I2C error -121; AA A7  CC
> 00 01 -> 55 A7  CC 00 00.
> Jul  6 07:05:38 wuwek kernel: [  122.581565] I2C error -121; AA 7F  CC
> 00 01 -> 55 7F  CC 00 00.
> Jul  6 07:05:39 wuwek kernel: [  123.841526] I2C error -121; AA 57  CC
> 00 01 -> 55 57  CC 00 00.
> Jul  6 07:05:40 wuwek kernel: [  125.096979] I2C error -121; AA 2F  CC
> 00 01 -> 55 2F  CC 00 00.
> Jul  6 07:05:42 wuwek kernel: [  126.353689] I2C error -121; AA 07  CC
> 00 01 -> 55 07  CC 00 00.

Regardless of those errors it still works?

> I will test tonight when I have more time
> Marx

regards
Antti

-- 
http://palosaari.fi/


