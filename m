Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:46808 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752703Ab2IIWZy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Sep 2012 18:25:54 -0400
Message-ID: <504D17AA.8020807@schinagl.nl>
Date: Mon, 10 Sep 2012 00:26:50 +0200
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Support for Asus MyCinema U3100Mini Plus
References: <1347223647-645-1-git-send-email-oliver+list@schinagl.nl> <504D00BC.4040109@schinagl.nl> <504D0F44.6030706@iki.fi>
In-Reply-To: <504D0F44.6030706@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/09/12 23:51, Antti Palosaari wrote:
> On 09/09/2012 11:49 PM, Oliver Schinagl wrote:
>> Hi All/Antti,
>>
>> I used Antti's previous patch to try to get some support in for the Asus
>> MyCinema U3100Mini Plus as it uses a supported driver (af9035) and now
>> supported tuner (FCI FC2580).
>>
>> It compiles fine and almost works :(
>>
>> Here's what I get, which I have no idea what causes it.
>>
>> dmesg output:
>> [ 380.677434] usb 1-3: New USB device found, idVendor=0b05,
>> idProduct=1779
>> [ 380.677445] usb 1-3: New USB device strings: Mfr=1, Product=2,
>> SerialNumber=3
>> [ 380.677452] usb 1-3: Product: AF9035A USB Device
>> [ 380.677458] usb 1-3: Manufacturer: Afa Technologies Inc.
>> [ 380.677463] usb 1-3: SerialNumber: AF01020abcdef12301
>> [ 380.683361] input: Afa Technologies Inc. AF9035A USB Device as
>> /devices/pci0000:00/0000:00:12.2/usb1/1-3/1-3:1.1/input/input15
>> [ 380.683505] hid-generic 0003:0B05:1779.0004: input: USB HID v1.01
>> Keyboard [Afa Technologies Inc. AF9035A USB Device] on
>> usb-0000:00:12.2-3/input1
>> [ 380.703807] usbcore: registered new interface driver dvb_usb_af9035
>> [ 380.704553] usb 1-3: dvb_usbv2: found a 'Asus U3100Mini Plus' in cold
>> state
>> [ 380.705075] usb 1-3: dvb_usbv2: downloading firmware from file
>> 'dvb-usb-af9035-02.fw'
>> [ 381.014996] dvb_usb_af9035: firmware version=11.5.9.0
>> [ 381.015018] usb 1-3: dvb_usbv2: found a 'Asus U3100Mini Plus' in warm
>> state
>> [ 381.017172] usb 1-3: dvb_usbv2: will pass the complete MPEG2
>> transport stream to the software demuxer
>> [ 381.017242] DVB: registering new adapter (Asus U3100Mini Plus)
>> [ 381.037184] af9033: firmware version: LINK=11.5.9.0 OFDM=5.17.9.1
>> [ 381.037200] usb 1-3: DVB: registering adapter 0 frontend 0 (Afatech
>> AF9033 (DVB-T))...
>> [ 381.044197] i2c i2c-1: fc2580: i2c rd failed=-5 reg=01 len=1
>> [ 381.044357] usb 1-3: dvb_usbv2: 'Asus U3100Mini Plus' error while
>> loading driver (-19)
>
> I2C communication to tuner chip does not work at all. It tries to read
> chip id register but fails. If you enable debugs you will see which
> error status af9035 reports.
CONFIG_DVB_USB_DEBUG was enabled, but nothing extra :(

>
> There is likely 3 possibilities:
> 1) wrong I2C address
Well as linked before, I used it from the 'official' driver, where it says:
#define FC2580_ADDRESS 0xAC

grepping the entire source of theirs, I then found this in FC2580.c
TunerDescription tuner_FC2580 = {
    FC2580_open,                /** Function to open tuner.            */
    FC2580_close,               /** Function to close tuner.           */
    FC2580_set,                 /** Function set frequency.            */
    FC2580_scripts,             /** Scripts.                           */
    FC2580_scriptSets,          /** Length of scripts.                 */
    FC2580_ADDRESS,             /** The I2C address of tuner.          */
    1,                          /** Valid length of tuner register.    */
    0,                          /** IF frequency of tuner.             */
    True,                       /** Spectrum inversion.                */
    0x32,                       /** tuner id                           */
};

The only other thing that I recognize is the scripts, which is some init 
code (which I asked about below, which should also be right, unless I 
made a typo) and the tuner id, which is the first thing in the script 
and in my patch defined as AF9033_TUNER_FC2580. No idea of its 
significance :)

> 2) wrong GPIOs
> * tuner is not powered on or it is on standby
How/where would I check that?

> 3) wrong firmware
> * it very unlikely that even wrong firmware fails basic I2C...
I know there's a few versions right? the 01 02 etc? But that is mostly 
in relation with the af9035 mostly right?

>
>> using the following modules.
>> fc2580 4189 -1
>> af9033 10266 0
>> dvb_usb_af9035 8924 0
>> dvb_usbv2 11388 1 dvb_usb_af9035
>> dvb_core 71756 1 dvb_usbv2
>> rc_core 10583 2 dvb_usbv2,dvb_usb_af9035
>>
>> I'm supprised though that dvb-pll isn't there. Wasn't that a
>> requirement? [1]
>
> No. dvb-pll is used for old simple 4-byte PLLs. FCI FC2580 is modern
> silicon tuner. There is PLL used inside FC2580 for frequency synthesizer
> but no dvb-pll needed as all calculations are done inside that driver.
> Silicon tuners are so much more complicated to program than old 4-byte
> PLLs, thus own driver is needed for each silicon tuner chip.
Ah, well then the wiki needs a small update ;)
>
>> For the tuner 'script' firmware/init bit, I used the 'official' driver
>> [2].
>>
>> Also the i2c-addr and clock comes from these files.
>
> Aaah, now I see. At least I2C address is wrong. You use 0xac but should
> be 0x56. There is wrong "8-bit" address used. 0xac >> 1 == 0x56.
That I don't understand (as I wrote above) 0xac 'should' be the correct, 
but appearantly it needs to be shifted. Why?

>
>
> 16384000 (16.384MHz) is FC2580 internal clock what I understand. It
> should be OK. I suspect that everyone uses it for DVB-T to save
> components / make design simple.
I would assume so, since also that is in the original sources; fc2580.c 
lists it as:
#define FREQ_XTAL	16384	//16.384MHz

>
>> One minor questions I have regarding the recently submitted RTL and
>> AF9033 drivers, is one uses AF9033_TUNER_* whereas the other uses
>> TUNER_RTL2832_*. Any reason for this? It just confused me is all.
>
> It is just naming issue driver, driver author decision. Usually names
> start with driver name letters (in that case RTL28XXU_). It is not big
> issue for variable names unless it is too "general" to conflict some
> library. For function names driver names prefix (rtl28xxu_) should be
> used as it eases debugging (example ooops is dumped showing function
> names).

Ok I will test the shifted i2c address and try that.
>
>
> Antti
>
>>
>> Oliver
>>
>> [1] http://linuxtv.org/wiki/index.php/DVB_via_USB#Introduction
>> [2] http://git.schinagl.nl/AF903x_SRC.git/tree/api/FCI_FC2580_Script.h
<snipped patch>
