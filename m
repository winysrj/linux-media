Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.kapsi.fi ([217.30.184.167] ident=Debian-exim)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1Kpkpm-0001IK-PG
	for linux-dvb@linuxtv.org; Tue, 14 Oct 2008 16:25:18 +0200
Message-ID: <48F4ABC3.5070500@iki.fi>
Date: Tue, 14 Oct 2008 17:25:07 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Ivan Kuten <ivan.kuten@promwad.com>
References: <48ED0023.8050901@promwad.com> <48F495F6.2030406@promwad.com>
In-Reply-To: <48F495F6.2030406@promwad.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] AVerMedia AverTV Hybrid Volar HX (A827) support?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Ivan Kuten wrote:
> Seems nobody is working on this.

Actually Zdenek Kabelac <zdenek.kabelac@gmail.com> was working this 
driver for times ago, but I think he has stopped his work.
Look thread for more info:
http://www.linuxtv.org/pipermail/linux-dvb/2008-April/025253.html

> Anyway here is attached usb snoop log for A827.
> I did not manage to find where is firmware loaded comparing with
> logs in af9015_firmware_cutter.tar.gz

I did some USB-protocol reverse-engineering for Zdenek. I have also 
almost fully documented USB-sniff, I can send it to you if you want hack 
driver more. It should be rather easy to make working driver (DVB-T) 
from that log.

> It seems the firmware is contained in EEPROM.

No its not. It loads firmware to af9013 from driver when stick is 
plugged. Correct firmware can be downloaded from: 
http://palosaari.fi/linux/v4l-dvb/firmware/af9013/

Your sniffs seems to be a little broken where firmware download was made.

You should hack cx88 driver for USB-bridge. There is some commands used 
in cx88 already.

Here are the USB-protocol commands I know:

i2c write     29
i2c read      2a
streaming on  36
streaming off 37
get ir code   25
power off     dc
power on      de

i2c write 1st 09

get ir code   25
000498:  OUT: 000000 ms 009978 ms BULK[00001] >>> 25
000499:  OUT: 000000 ms 009978 ms BULK[00081] <<< 00 00 00 00 00

streaming on  36
008607:  OUT: 000048 ms 014412 ms BULK[00001] >>> 36 03 00 01

streaming off 37
012176:  OUT: 000000 ms 041479 ms BULK[00001] >>> 37

i2c write     29
008622:  OUT: 000001 ms 014434 ms BULK[00001] >>> 29 00 00 1d 9b bc 00
008623:  OUT: 000001 ms 014435 ms BULK[00081] <<< 01

i2c read      2a
008624:  OUT: 000001 ms 014436 ms BULK[00001] >>> 2a 00 00 1d 01
008625:  OUT: 000074 ms 014437 ms BULK[00081] <<< 01

008616:  OUT: 000001 ms 014425 ms BULK[00001] >>> 0f 01 00 03 01 00 00
008617:  OUT: 000001 ms 014426 ms BULK[00081] <<< 01

power off     dc
012294:  OUT: 000076 ms 042795 ms BULK[00001] >>> dc 00

power on      de
000010:  OUT: 000001 ms 000135 ms BULK[00001] >>> de 00

i2c write? gpio?
000011:  OUT: 000000 ms 000136 ms BULK[00001] >>> 09 02 02 51 1f f9
000012:  OUT: 000000 ms 000136 ms BULK[00081] <<< 08 03 07

usb-controller write?
012274:  OUT: 000001 ms 042620 ms BULK[00001] >>> 0f 01 00 03 01 01 00
012275:  OUT: 000025 ms 042621 ms BULK[00081] <<< 01


> 
> Regards,
> Ivan
> 
>> Hello!
>>
>> Is anybody working on AVerMedia AverTV Hybrid Volar HX (A827) support?
>>
>> Chips in this USB stick:
>>
>>      * Cypress CY7C68013A
>>      * NXP SAA7136E
>>      * NXP TDA18271HDC1
>>      * Afatech AF9013-N1
>>
>> I'm interested in TV/Analog input (not DVB-T), am I posting to the 
>> right list?
>>
>> Regards,
>> Ivan

I don't know anything about analog...

regards
Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
