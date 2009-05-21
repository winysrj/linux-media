Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:55563 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010AbZEUON1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2009 10:13:27 -0400
Received: by fxm2 with SMTP id 2so1063534fxm.37
        for <linux-media@vger.kernel.org>; Thu, 21 May 2009 07:13:27 -0700 (PDT)
Message-ID: <4A156184.1070501@gmail.com>
Date: Thu, 21 May 2009 16:13:24 +0200
From: Antonio Beamud Montero <antonio.beamud@gmail.com>
MIME-Version: 1.0
To: Michael Krufky <mkrufky@kernellabs.com>
CC: Linux and Kernel Video <video4linux-list@redhat.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: Hauppauge HVR 1110 and DVB
References: <4A128A19.40601@gmail.com>	 <37219a840905200608q42b4fc0fife8f9aad7056145b@mail.gmail.com>	 <4A1424F8.9010706@gmail.com> <37219a840905201219x576fe229g6d95f1cf7dc80a08@mail.gmail.com>
In-Reply-To: <37219a840905201219x576fe229g6d95f1cf7dc80a08@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Michael Krufky escribió:
> On Wed, May 20, 2009 at 11:42 AM, Antonio Beamud Montero
> <antonio.beamud@gmail.com> wrote:
>   
>> Michael Krufky escribió:
>>     
>>> On Tue, May 19, 2009 at 6:29 AM, Antonio Beamud Montero
>>>  Hello,
>>>
>>> I specifically left out the DVB support for this device.
>>>
>>> To be honest, I didn't know that this board was available for purchase
>>> already.  Where did you get it?  (just curious)
>>>
>>>       
>> It seems that here in spain is available :)
>>
>>
>>     
>>> If something happens sooner than that, I'll append another email to this
>>> thread.
>>>
>>>       
>> Ok, If you need a tester, I'm your man ;)
>>
>> Thank you.
>>
>> Greetings.
>>     
>
> (i am sending this a second time -- first message got rejected by vger)
>
> You're in luck -- I resolved the problem today...  If you'd like to
> test, please try out this repository:
>
> http://kernellabs.com/hg/~mk/hvr1110
>
> Please let me know how this works for you.
>
>   
Thanks for the patch. Seems to load fine, the problem arises when try 
load the firmware.

--------
saa7133[0]: found at 0000:0f:03.0, rev: 209, irq: 65, latency: 32, mmio: 
0xfc4ff800
saa7133[0]: subsystem: 0070:6707, board: Hauppauge WinTV-HVR1110r3 
DVB-T/Hybrid [card=156,autodetected]
saa7133[0]: board init: gpio is 440100
tuner 0-004b: chip found @ 0x96 (saa7133[0])
saa7133[0]: i2c eeprom 00: 70 00 07 67 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
saa7133[0]: i2c eeprom 10: ff ff ff 0e ff 20 ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 20: 01 40 01 32 32 01 01 33 88 ff 00 b0 ff ff ff ff
saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 40: ff 35 00 c0 96 10 06 32 97 04 00 20 00 ff ff ff
saa7133[0]: i2c eeprom 50: ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
saa7133[0]: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
saa7133[0]: i2c eeprom 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
saa7133[0]: i2c eeprom 80: 84 09 00 04 20 77 00 40 08 79 5e f0 73 05 29 00
saa7133[0]: i2c eeprom 90: 84 08 00 06 89 06 01 00 95 19 8d 72 07 70 73 09
saa7133[0]: i2c eeprom a0: 23 5f 73 0a f4 9b 72 0b 2f 72 0e 01 72 0f 01 72
saa7133[0]: i2c eeprom b0: 10 01 72 11 ff 73 13 a2 69 79 1a 00 00 00 00 00
saa7133[0]: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
saa7133[0]: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
saa7133[0]: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
saa7133[0]: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
tveeprom 0-0050: Hauppauge model 67209, rev C1F5, serial# 6191368
tveeprom 0-0050: MAC address is 00-0D-FE-5E-79-08
tveeprom 0-0050: tuner model is NXP 18271C2 (idx 155, type 54)
tveeprom 0-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L') PAL(D/D1/K) 
ATSC/DVB Digital (eeprom 0xf4)
tveeprom 0-0050: audio processor is SAA7131 (idx 41)
tveeprom 0-0050: decoder processor is SAA7131 (idx 35)
tveeprom 0-0050: has radio, has IR receiver, has no IR transmitter
saa7133[0]: hauppauge eeprom: model=67209
tda829x 0-004b: setting tuner address to 60
tda18271 0-0060: creating new instance
TDA18271HD/C2 detected @ 0-0060
tda18271: performing RF tracking filter calibration
tda18271: RF tracking filter calibration complete
tda829x 0-004b: type set to tda8290+18271
saa7133[0]: registered device video0 [v4l2]
saa7133[0]: registered device vbi0
saa7133[0]: registered device radio0
dvb_init() allocating 1 frontend
tda829x 0-004b: type set to tda8290
tda18271 0-0060: attaching existing instance
DVB: registering new adapter (saa7133[0])
DVB: registering adapter 0 frontend 0 (NXP TDA10048HN DVB-T)...
tda10048_firmware_upload: waiting for firmware upload 
(dvb-fe-tda10048-1.0.fw)...
tda10048_firmware_upload: firmware read 24878 bytes.
tda10048_firmware_upload: firmware uploading
tda10048_firmware_upload: firmware upload failed
saa7134 ALSA driver for DMA sound loaded
saa7133[0]/alsa: saa7133[0] at 0xfc4ff800 irq 65 registered as card -1

---

I've tried to extract the firmware from the windows drivers, but all my 
experiments failed.
How I can get the correct firmware?

Thanks for all again.


