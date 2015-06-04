Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm7-vm5.access.bullet.mail.gq1.yahoo.com ([216.39.63.125]:38868
	"EHLO nm7-vm5.access.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753381AbbFDB3A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Jun 2015 21:29:00 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Thu, 04 Jun 2015 13:22:25 +1200
From: faulkner-ball <faulkner-ball@xtra.co.nz>
To: Stephen Allan <stephena@intellectit.com.au>
Cc: linux-media@vger.kernel.org, linux-media-owner@vger.kernel.org
Subject: RE: Hauppauge WinTV-HVR2205 driver feedback
Reply-To: faulkner-ball@xtra.co.nz
In-Reply-To: <d5b30de9fc234bd7b4bbf3d1cbcc8ffc@IITMAIL.intellectit.local>
References: <b69d68a858a946c59bb1e292111504ad@IITMAIL.intellectit.local>
 <556EB2F7.506@iki.fi> <556EB4B0.8050505@iki.fi>
 <d5b30de9fc234bd7b4bbf3d1cbcc8ffc@IITMAIL.intellectit.local>
Message-ID: <8b2be8c2a67eb3b6a4d15f2449735d8f@faulkner-ball.ddns.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The board has multiple "chips", each of which are detected and 
configured as part of the driver loading.

saa7164
This chip requires firmware which appears to load correctly at 20.240637


si2168
This chip requires firmware
The chip is detected and "loaded" but the chip version is not 
identified, so the firmware load does not occur.
As this is a dual tuner card, there are 2 of these chips.


si2157
this is the actual tuner chip, again there are 2 chips on the card, and 
it does not need to load any firmware.
The firmware version already in the chip is reported at 165512.480559 
and 165518.024867

both of the si21xx chips don't get the firmware loaded until the tuner 
is accessed by an application, so the card appears to be loading 
correctly, but will not tune.


See my other post for a workaround.
I'm sure one of the developers will provide a more elegant/correct 
solution soon.


Regards
Peter


On 04/06/2015 12:38 pm, Stephen Allan wrote:
> Hi,
> 
> Just thought I'd clarify that in my case I haven't ever used this
> board with Windows.  See a more detailed dmesg output below for
> "saa7168" and "si21xx" messages.  From what I am seeing the firmware
> is loading correctly.  However I may be wrong.
> 
> dmesg | grep 'saa7164\|si21'
> [   18.112439] saa7164 driver loaded
> [   18.113429] CORE saa7164[0]: subsystem: 0070:f120, board: Hauppauge
> WinTV-HVR2205 [card=13,autodetected]
> [   18.113435] saa7164[0]/0: found at 0000:03:00.0, rev: 129, irq: 16,
> latency: 0, mmio: 0xf7800000
> [   18.113470] saa7164 0000:03:00.0: irq 46 for MSI/MSI-X
> [   18.270310] saa7164_downloadfirmware() no first image
> [   18.270322] saa7164_downloadfirmware() Waiting for firmware upload
> (NXP7164-2010-03-10.1.fw)
> [   20.240635] saa7164_downloadfirmware() firmware read 4019072 bytes.
> [   20.240637] saa7164_downloadfirmware() firmware loaded.
> [   20.240642] saa7164_downloadfirmware() SecBootLoader.FileSize = 
> 4019072
> [   20.240648] saa7164_downloadfirmware() FirmwareSize = 0x1fd6
> [   20.240649] saa7164_downloadfirmware() BSLSize = 0x0
> [   20.240650] saa7164_downloadfirmware() Reserved = 0x0
> [   20.240650] saa7164_downloadfirmware() Version = 0x1661c00
> [   27.096269] saa7164_downloadimage() Image downloaded, booting...
> [   27.200300] saa7164_downloadimage() Image booted successfully.
> [   29.936962] saa7164_downloadimage() Image downloaded, booting...
> [   31.705407] saa7164_downloadimage() Image booted successfully.
> [   31.750358] saa7164[0]: Hauppauge eeprom: model=151609
> [   31.776446] si2168 22-0064: Silicon Labs Si2168 successfully 
> attached
> [   31.781307] si2157 20-0060: Silicon Labs Si2147/2148/2157/2158
> successfully attached
> [   31.781695] DVB: registering new adapter (saa7164)
> [   31.781698] saa7164 0000:03:00.0: DVB: registering adapter 4
> frontend 0 (Silicon Labs Si2168)...
> [   31.782652] si2168 22-0066: Silicon Labs Si2168 successfully 
> attached
> [   31.785961] si2157 21-0060: Silicon Labs Si2147/2148/2157/2158
> successfully attached
> [   31.786340] DVB: registering new adapter (saa7164)
> [   31.786342] saa7164 0000:03:00.0: DVB: registering adapter 5
> frontend 0 (Silicon Labs Si2168)...
> [   31.786562] saa7164[0]: registered device video1 [mpeg]
> [   32.021659] saa7164[0]: registered device video2 [mpeg]
> [   32.238336] saa7164[0]: registered device vbi0 [vbi]
> [   32.238389] saa7164[0]: registered device vbi1 [vbi]
> [165512.436662] si2168 22-0066: unknown chip version Si2168-
> [165512.450315] si2157 21-0060: found a 'Silicon Labs Si2157-A30'
> [165512.480559] si2157 21-0060: firmware version: 3.0.5
> [165517.981155] si2168 22-0064: unknown chip version Si2168-
> [165517.994620] si2157 20-0060: found a 'Silicon Labs Si2157-A30'
> [165518.024867] si2157 20-0060: firmware version: 3.0.5
> [165682.334171] si2168 22-0064: unknown chip version Si2168-
> [165730.579085] si2168 22-0064: unknown chip version Si2168-
> [165838.420693] si2168 22-0064: unknown chip version Si2168-
> [166337.342437] si2168 22-0064: unknown chip version Si2168-
> [167305.393572] si2168 22-0064: unknown chip version Si2168-
> [170762.907071] si2168 22-0064: unknown chip version Si2168-
> 
> -----Original Message-----
> From: Antti Palosaari [mailto:crope@iki.fi]
> Sent: Wednesday, June 3, 2015 6:03 PM
> To: Stephen Allan; linux-media@vger.kernel.org
> Subject: Re: Hauppauge WinTV-HVR2205 driver feedback
> 
> On 06/03/2015 10:55 AM, Antti Palosaari wrote:
>> On 06/03/2015 06:55 AM, Stephen Allan wrote:
>>> I am aware that there is some development going on for the saa7164
>>> driver to support the Hauppauge WinTV-HVR2205.  I thought I would
>>> post some feedback.  I have recently compiled the driver as at
>>> 2015-05-31 using "media build tree".  I am unable to tune a channel.
>>> When running the following w_scan command:
>>> 
>>> w_scan -a4 -ft -cAU -t 3 -X > /tmp/tzap/channels.conf
>>> 
>>> I get the following error after scanning the frequency range for
>>> Australia.
>>> 
>>> ERROR: Sorry - i couldn't get any working frequency/transponder
>>>   Nothing to scan!!
>>> 
>>> At the same time I get the following messages being logged to the
>>> Linux console.
>>> 
>>> dmesg
>>> [165512.436662] si2168 22-0066: unknown chip version Si2168-
>>> [165512.450315] si2157 21-0060: found a 'Silicon Labs Si2157-A30'
>>> [165512.480559] si2157 21-0060: firmware version: 3.0.5
>>> [165517.981155] si2168 22-0064: unknown chip version Si2168-
>>> [165517.994620] si2157 20-0060: found a 'Silicon Labs Si2157-A30'
>>> [165518.024867] si2157 20-0060: firmware version: 3.0.5
>>> [165682.334171] si2168 22-0064: unknown chip version Si2168-
>>> [165730.579085] si2168 22-0064: unknown chip version Si2168-
>>> [165838.420693] si2168 22-0064: unknown chip version Si2168-
>>> [166337.342437] si2168 22-0064: unknown chip version Si2168-
>>> [167305.393572] si2168 22-0064: unknown chip version Si2168-
>>> 
>>> 
>>> Many thanks to the developers for all of your hard work.
>> 
>> Let me guess they have changed Si2168 chip to latest "C" version.
>> Driver supports only A and B (A20, A30 and B40). I have never seen C 
>> version.
> 
> gah, looking the driver I think that is not issue - it will likely
> print "unknown chip version Si2168-C.." on that case already. However,
> I remember I have seen that kind of issue earlier too, but don't
> remember what was actual reason. Probably something to do with
> firmware, wrong firmware and loading has failed? Could you make cold
> boot, remove socket from the wallet and wait minute it really powers
> down, then boot and look what happens.
> 
> regards
> Antti
> 
> 
> 
> --
> http://palosaari.fi/
> N�����r��y���b�X��ǧv�^�)޺{.n�+����{���b�{ay�ʇڙ�,j��f���h���z��w����+zf���h���~����i���z��w���?����&�)ߢ
