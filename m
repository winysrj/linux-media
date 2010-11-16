Return-path: <mchehab@pedra>
Received: from mx1.polytechnique.org ([129.104.30.34]:35196 "EHLO
	mx1.polytechnique.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014Ab0KPU0i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Nov 2010 15:26:38 -0500
Message-ID: <4CE2E8FE.2030004@free.fr>
Date: Tue, 16 Nov 2010 21:26:38 +0100
From: Massis Sirapian <msirapian@free.fr>
MIME-Version: 1.0
To: Stefan Ringel <stefan.ringel@arcor.de>
CC: Richard Zidlicky <rz@linux-m68k.org>, linux-media@vger.kernel.org
Subject: Re: HVR900H : IR Remote Control
References: <4CDFF446.2000403@free.fr> <4CE0047D.8060401@arcor.de> <4CE03704.4070300@free.fr> <20101115091544.GA23490@linux-m68k.org> <4CE1715B.2070403@arcor.de> <4CE19F86.3010901@free.fr> <4CE1A13C.9000707@arcor.de>
In-Reply-To: <4CE1A13C.9000707@arcor.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Le 15/11/2010 22:08, Stefan Ringel a écrit :
> Am 15.11.2010 22:00, schrieb Massis Sirapian:
>> Le 15/11/2010 18:43, Stefan Ringel a écrit :
>>> Am 15.11.2010 10:15, schrieb Richard Zidlicky:
>>>> On Sun, Nov 14, 2010 at 08:22:44PM +0100, Massis Sirapian wrote:
>>>>
>>>>> Thanks Stefan. I've checked the /drivers/media/IR/keymaps of the
>>>>> kernel
>>>>> source directory, but nothing seems to fit my remote, which is a
>>>>> DSR-0012 : http://lirc.sourceforge.net/remotes/hauppauge/DSR-0112.jpg.
>>>> FYI, this remote is identical to that shipped with (most?) Haupauge
>>>> Ministicks
>>>> and the codes reportedly match the rc-dib0700-rc5.c keymap. However I
>>>> have not figured
>>>> out how to make the userspace work with the new ir-code yet.
>>>>
>>>> Richard
>>> With my terratec cinergy hybrid xe (equal yours hvr900h) I have this:
>>>
>>> localhost:/usr/src/src/tm6000_alsa/utils/v4l-utils # ir-keytable
>>> Found /sys/class/rc/rc0/ (/dev/input/event5) with:
>>> Driver tm6000, table rc-nec-terratec-cinergy-xs
>>> Supported protocols: NEC RC-5 Enabled protocols: NEC
>>>
>>> I can change outside the keytable.
>>>
>>>
>> Just loading tm6000-dvb, I have this :
>> [ 253.829422] IR NEC protocol handler initialized
>> [ 253.846608] IR RC5(x) protocol handler initialized
>> [ 253.883882] tm6000: module is from the staging directory, the
>> quality is unknown, you have been warned.
>> [ 253.886611] tm6000 v4l2 driver version 0.0.2 loaded
>> [ 253.887558] tm6000: alt 0, interface 0, class 255
>> [ 253.887574] tm6000: alt 0, interface 0, class 255
>> [ 253.887575] tm6000: Bulk IN endpoint: 0x82 (max size=512 bytes)
>> [ 253.887577] tm6000: alt 0, interface 0, class 255
>> [ 253.887578] tm6000: alt 1, interface 0, class 255
>> [ 253.887579] tm6000: ISOC IN endpoint: 0x81 (max size=3072 bytes)
>> [ 253.887580] tm6000: alt 1, interface 0, class 255
>> [ 253.887581] tm6000: alt 1, interface 0, class 255
>> [ 253.887582] tm6000: INT IN endpoint: 0x83 (max size=4 bytes)
>> [ 253.887583] tm6000: alt 2, interface 0, class 255
>> [ 253.887584] tm6000: alt 2, interface 0, class 255
>> [ 253.887586] tm6000: alt 2, interface 0, class 255
>> [ 253.887587] tm6000: alt 3, interface 0, class 255
>> [ 253.887588] tm6000: alt 3, interface 0, class 255
>> [ 253.887589] tm6000: alt 3, interface 0, class 255
>> [ 253.887590] tm6000: New video device @ 480 Mbps (2040:6600, ifnum 0)
>> [ 253.887591] tm6000: Found Hauppauge WinTV HVR-900H / WinTV USB2-Stick
>> [ 253.888848] IR RC6 protocol handler initialized
>> [ 253.890209] IR JVC protocol handler initialized
>> [ 253.891515] IR Sony protocol handler initialized
>> [ 253.893815] lirc_dev: IR Remote Control driver registered, major 250
>> [ 253.894722] IR LIRC bridge handler initialized
>> [ 254.806122] Board version = 0x67980bf4
>> [ 255.197098] board=0x67980bf4
>> [ 255.320786] tm6000 #0: i2c eeprom 00: 01 59 54 45 12 01 00 02 00 00
>> 00 40 40 20 00 66 .YTE.......@@ .f
>> [ 255.512277] tm6000 #0: i2c eeprom 10: 69 00 10 20 40 01 02 03 48 00
>> 79 00 62 00 72 00 i.. @...H.y.b.r.
>> [ 255.703783] tm6000 #0: i2c eeprom 20: ff 00 64 ff ff ff ff ff ff ff
>> ff ff ff ff ff ff ..d.............
>> [ 255.895281] tm6000 #0: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff
>> ff ff ff ff ff ff ................
>> [ 256.086786] tm6000 #0: i2c eeprom 40: 10 03 48 00 56 00 52 00 39 00
>> 30 00 30 00 48 00 ..H.V.R.9.0.0.H.
>> [ 256.278289] tm6000 #0: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff
>> ff ff ff ff ff ff ................
>> [ 256.469783] tm6000 #0: i2c eeprom 60: 30 ff ff ff 0f ff ff ff ff ff
>> 0a 03 32 00 2e 00 0...........2...
>> [ 256.661287] tm6000 #0: i2c eeprom 70: 3f 00 ff ff ff ff ff ff ff ff
>> ff ff ff ff ff ff ?...............
>> [ 256.852786] tm6000 #0: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff
>> ff ff ff ff ff ff ................
>> [ 257.044307] tm6000 #0: i2c eeprom 90: 30 ff ff ff 16 03 34 00 30 00
>> 33 00 32 00 32 00 0.....4.0.3.2.2.
>> [ 257.235798] tm6000 #0: i2c eeprom a0: 33 00 36 00 39 00 30 00 35 00
>> 00 00 77 00 ff ff 3.6.9.0.5...w...
>> [ 257.427295] tm6000 #0: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff
>> ff ff ff ff ff ff ................
>> [ 257.618794] tm6000 #0: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff
>> ff ff ff ff ff ff ................
>> [ 257.810303] tm6000 #0: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff
>> ff ff ff ff ff ff ................
>> [ 258.001810] tm6000 #0: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff
>> ff ff ff ff ff ff ................
>> [ 258.193291] tm6000 #0: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff
>> ff ff ff ff ff ff ................
>> [ 258.372825] ................
>> [ 258.378849] tuner 4-0061: chip found @ 0xc2 (tm6000 #0)
>> [ 258.400777] xc2028 4-0061: creating new instance
>> [ 258.400779] xc2028 4-0061: type set to XCeive xc2028/xc3028 tuner
>> [ 258.400781] Setting firmware parameters for xc2028
>> [ 258.427221] xc2028 4-0061: Loading 81 firmware images from
>> xc3028L-v36.fw, type: xc2028 firmware, ver 3.6
>> [ 258.668063] xc2028 4-0061: Loading firmware for type=BASE (1), id
>> 0000000000000000.
>> [ 333.245767] xc2028 4-0061: Loading firmware for type=(0), id
>> 000000000000b700.
>> [ 334.510473] SCODE (20000000), id 000000000000b700:
>> [ 334.510476] xc2028 4-0061: Loading SCODE for type=MONO SCODE
>> HAS_IF_4320 (60008000), id 0000000000008000.
>> [ 335.783252] Trident TVMaster TM5600/TM6000/TM6010 USB2 board (Load
>> status: 0)
>> [ 335.783271] usbcore: registered new interface driver tm6000
>> [ 335.784191] tm6000: open called (dev=video1)
>> [ 335.815994] tm6000_dvb: module is from the staging directory, the
>> quality is unknown, you have been warned.
>> [ 335.854973] DVB: registering new adapter (Trident TVMaster 6000 DVB-T)
>> [ 335.854976] DVB: registering adapter 0 frontend 0 (Zarlink ZL10353
>> DVB-T)...
>> [ 335.855087] xc2028 4-0061: attaching existing instance
>> [ 335.855088] xc2028 4-0061: type set to XCeive xc2028/xc3028 tuner
>> [ 335.855090] tm6000: XC2028/3028 asked to be attached to frontend!
>> [ 335.855343] tm6000 #0: Initialized (TM6000 dvb Extension) extension
>> [ 337.338951] tm6000: open called (dev=video1)
>>
>> Then, ir-keytable complains : "Couldn't find any node at
>> /sys/class/rc/rc*."
>>
>> So it looks Jarod is right : tm6000 is loading, it calls lirc_dev and
>> a bunch of protocol modules, but the IR doesn't seem to be handled.
>>
>> I saw some ir lines in tm6000-cards.c for the HVR900H and thought the
>> IR receiver was supported. It's a bit disturbing if the cinergy stick
>> you evoke is equivalent to HVR900H and works, while HVR900H's IR part
>> isn't implemented ?
>>
>> Massis
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
> add this line with the right map name
>
> .ir_codes = RC_MAP_NEC_TERRATEC_CINERGY_XS,
>
> in this struct
>
> [TM6010_BOARD_HAUPPAUGE_900H] = {
> .name = "Hauppauge WinTV HVR-900H / WinTV USB2-Stick",
> .tuner_type = TUNER_XC2028, /* has a XC3028 */
> .tuner_addr = 0xc2 >> 1,
> .demod_addr = 0x1e >> 1,
> .type = TM6010,
> .caps = {
> .has_tuner = 1,
> .has_dvb = 1,
> .has_zl10353 = 1,
> .has_eeprom = 1,
> .has_remote = 1,
> },
> .gpio = {
> .tuner_reset = TM6010_GPIO_2,
> .tuner_on = TM6010_GPIO_3,
> .demod_reset = TM6010_GPIO_1,
> .demod_on = TM6010_GPIO_4,
> .power_led = TM6010_GPIO_7,
> .dvb_led = TM6010_GPIO_5,
> .ir = TM6010_GPIO_0,
> },
>
> Stefan
>
Thank you Stefan, I've added .ir_codes = RC_MAP_DIB0700_RC5_TABLE (as 
you suggested to use the right map name and as Richard understated that 
the RC are similar) to the struct, and now, dmesg gives :

[  206.350288] Registered IR keymap rc-dib0700-rc5
[  206.350442] input: tm5600/60x0 IR (tm6000 #0) as 
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.4/rc/rc0/input7
[  206.350489] rc0: tm5600/60x0 IR (tm6000 #0) as 
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.4/rc/rc0

ir-keytable comes : found /sys/class/rc/rc0/ (/dev/input/event7) with:
         Driver tm6000, table rc-dib0700-rc5
         Supported protocols: NEC RC-5   Enabled protocols: RC-5

However, when I press some RC buttons, I hhave no output on the screen ; 
with lircd --driver=devinput --device=/dev/input/event7 and irw, nothing 
happens when I use the RC. I've tried to switch protocol from RC5 to 
NEC, but nothing occurs anyway.

Does it mean I have to test with another RC_MAPs in the tm6000-cards.c ? 
How to use the created input device?

Thanks

Massis

