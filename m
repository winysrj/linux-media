Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mailout01.sul.t-online.de ([194.25.134.80])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hartmut.hackmann@t-online.de>) id 1Jc7Y0-0006O9-P2
	for linux-dvb@linuxtv.org; Thu, 20 Mar 2008 00:18:18 +0100
Message-ID: <47E19F2B.1070302@t-online.de>
Date: Thu, 20 Mar 2008 00:18:03 +0100
From: Hartmut Hackmann <hartmut.hackmann@t-online.de>
MIME-Version: 1.0
To: timf <timf@iinet.net.au>
References: <1204893775.10536.4.camel@ubuntu>
	<47D1A65B.3080900@t-online.de>	<1205480517.5913.8.camel@ubuntu>
	<47DEE11F.6060301@t-online.de>	<1205851252.11231.7.camel@ubuntu>
	<47E048A4.4070904@t-online.de> <1205899404.6577.0.camel@ubuntu>
In-Reply-To: <1205899404.6577.0.camel@ubuntu>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Kworld DVB-T 210 - dvb tuning problem
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

Hi, Tim

timf schrieb:
> Hi Hartmut,
> 
> On Tue, 2008-03-18 at 23:56 +0100, Hartmut Hackmann wrote:
>> Hi, Tim
>>
>> timf schrieb:
>>> Hi Hartmut,
>>>
>>>
>>> Apologies for the length of this msg, I'm not sure what info you may
>>> need, so I'm trying to show you that all is not right.
>>>
>>> 1) New install of ubuntu 7.10 i386.
>>>
>>> 2) Install Me-tv, Tvtime.
>>> Me-tv, in the absence of a channels.conf, scans
>>> via /usr/share/doc/dvb-utils/examples/scan/dvb-t
>>>
>>> 3) I placed au-Perth_roleystone
>>> into /usr/share/doc/dvb-utils/examples/scan/dvb-t:
>>>
>>> # Australia / Perth (Roleystone transmitter)
>>> # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
>>> # SBS
>>> T 704500000 7MHz 2/3 NONE QAM64 8k 1/8 NONE
>>> # ABC
>>> T 725500000 7MHz 3/4 NONE QAM64 8k 1/16 NONE
>>> # Seven
>>> T 746500000 7MHz 2/3 NONE QAM64 8k 1/16 NONE
>>> # Nine
>>> T 767500000 7MHz 3/4 NONE QAM64 8k 1/16 NONE
>>> # Ten
>>> T 788500000 7MHz 3/4 NONE QAM64 8k 1/16 NONE
>>>
>> Hm, is that right? The transmitter at 704.5MHz has a different configuration
>> from all others? That's unusual...
>> There is a speciality with this channel decoder: If you define a parameter
>> like the GI, it takes this serious while many others ignore it.
>>
>> <snip>
>>> 13) Most times, "tda1004x: found firmware revision 20 -- ok" appears
>>> from a new install of ubuntu.
>>> Shouldn't have to but will copy firmware into /lib...
>>>
>> And here we have the problem: as long as the firmware download is not
>> reliable, the board is unusable.
>> There must be somehing wrong with the board configuration.
>> In saa7134-dvb.c, line 744, please try to excange:
>> 	.gpio_config   = TDA10046_GP11_I,
>> with
>> 	.gpio_config   = TDA10046_GP01_I,
>> does this make the firmware load stable?
>>
>> Best regards
>>   Hartmut
> 
> 
> Improved, I think.
> 
> With Me-tv, using au-Perth_roleystone:
> (SBS is on 704500000)
> 
> Failed to tune to transponder at 704500000
> Found channel: SBS HD
> Found channel: SBS
> Found channel: SBS NEWS
> Found channel: SBS 2
> Found channel: SBS RADIO 1
> Found channel: SBS RADIO 2
> Found channel: ABC HDTV
> Found channel: ABC1
> Found channel: ABC2
> Found channel: ABC1
> Found channel: ABC3
> Found channel: ABC DiG Radio
> Found channel: ABC DiG Jazz
> Found channel: 7 Digital
> Found channel: 7 HD Digital
> Found channel: 7 Digital 1
> Found channel: 7 Digital 2
> Found channel: 7 Digital 3
> Found channel: 7 Program Guide
> Found channel: Nine Digital
> Found channel: Nine HD
> Found channel: TEN HD
> Found channel: TEN Digital
> Found channel: TEN HD
> 
> However, with Kaffeine channels.dvb:
> 
> #Generated by Kaffeine 0.5
> TV|7 Digital|1537(2)|1538(eng),|1540|1376|1286|Terrestrial|177500|0|v|
> 34|-1|64|34|7|8|16|0|1|||
> TV|7 Digital 1|1537(2)|1538(eng),|1540|1377|1286|Terrestrial|177500|0|v|
> 34|-1|64|34|7|8|16|0|2|||
> TV|7 Digital 2|1537(2)|1538(eng),|1540|1378|1286|Terrestrial|177500|0|v|
> 34|-1|64|34|7|8|16|0|3|||
> TV|7 Digital 3|1537(2)|1538(eng),|1540|1379|1286|Terrestrial|177500|0|v|
> 34|-1|64|34|7|8|16|0|4|||
> TV|Nine Digital|512(2)|650(eng),651(ac3),|576|1025|1104|Terrestrial|
> 191625|0|v|34|-1|64|12|7|8|16|0|5|||
> TV|Nine HD|522(2)|750(ac3),|576|1030|1104|Terrestrial|191625|0|v|34|-1|
> 64|12|7|8|16|0|6|||
> TV|7 HD Digital|1601(2)|1603(ac3),|0|1380|1286|Terrestrial|177500|0|v|
> 34|-1|64|34|7|8|16|0|7|||
> TV|7 Program Guide|1633(2)|1634,|0|1382|1286|Terrestrial|177500|0|v|
> 34|-1|64|34|7|8|16|0|8|||
> TV|TEN Digital|512(2)|650(eng),651(ac3),|576|1669|1543|Terrestrial|
> 219500|0|v|34|-1|64|12|7|8|16|0|9|||
> TV|TEN HD|514(2)|672(ac3),|577|1672|1543|Terrestrial|788500|0|v|34|-1|
> 64|-1|7|8|16|0|10|||
> TV|TEN HD-1|514(2)|672(ac3),|577|1665|1543|Terrestrial|788500|0|v|34|-1|
> 64|-1|7|8|16|0|11|||
> 
> So Kaffeine is not happy now.
> 
> dmesg
> <snip>
> [   43.751473] Linux video capture interface: v2.00
> [   43.780417] nvidia: module license 'NVIDIA' taints kernel.
> <snip>
> [   44.101925] saa7133[0]: found at 0000:05:01.0, rev: 209, irq: 17,
> latency: 64, mmio: 0xfebff800
> [   44.101931] saa7133[0]: subsystem: 17de:7250, board: KWorld DVB-T 210
> [card=114,autodetected]
> [   44.101940] saa7133[0]: board init: gpio is 100
> [   44.250022] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level,
> low) -> IRQ 22
> [   44.250500] PCI: Setting latency timer of device 0000:00:1b.0 to 64
> [   44.259010] saa7133[0]: i2c eeprom 00: de 17 50 72 ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   44.259023] saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   44.259034] saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   44.259045] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   44.259056] saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   44.259066] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   44.259077] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   44.259088] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   44.259099] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   44.259110] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   44.259121] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   44.259131] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   44.259142] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   44.259153] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   44.259164] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   44.259174] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   44.372044] tuner' 0-004b: chip found @ 0x96 (saa7133[0])
> [   44.456848] tda829x 0-004b: setting tuner address to 61
> [   44.460864] hda_codec: Unknown model for ALC883, trying auto-probe
> from BIOS...
> [   44.537235] tda829x 0-004b: type set to tda8290+75a
> [   48.498066] saa7133[0]: registered device video0 [v4l2]
> [   48.498214] saa7133[0]: registered device vbi0
> [   48.498363] saa7133[0]: registered device radio0
> [   48.582667] saa7134 ALSA driver for DMA sound loaded
> [   48.582699] saa7133[0]/alsa: saa7133[0] at 0xfebff800 irq 17
> registered as card -2
> [   48.846762] DVB: registering new adapter (saa7133[0])
> [   48.846768] DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
> [   48.918706] tda1004x: setting up plls for 48MHz sampling clock
> [   49.202699] tda1004x: found firmware revision 20 -- ok
> <snip>
> ......
> <snip>
> [  152.485617] tda1004x: setting up plls for 48MHz sampling clock
> [  152.681710] tda1004x: found firmware revision 20 -- ok
> [  431.669193] tda1004x: setting up plls for 48MHz sampling clock
> [  431.868920] tda1004x: found firmware revision 20 -- ok
> [  477.103776] tda1004x: setting up plls for 48MHz sampling clock
> [  477.299645] tda1004x: found firmware revision 20 -- ok
> [  490.469730] tda1004x: setting up plls for 48MHz sampling clock
> [  490.693412] tda1004x: found firmware revision 20 -- ok
> timf@ubuntu:~$ 
> 
> I also have a Pinnacle 310i, so I can do a test for your new personal
> repo.
> (I have never been able to get the remote going with this card.)
> 
> Best regards,
> Tim
> 
Your situation improved when you changed the GPIO setting?
Regarding the scanning:
1) Did you try to change the GI setting as i recommended last time?
2) Regarding kaffeine i noticed different transmitter frequencies
Are you sure you used the right config file?

It is VERY unlikely that your card works with one application but not
with another. All upper layers of the driver are card independent and
saa7134-dvb is known to work with kaffeine.

May i ask you to have a look with the Pinnacle card? This one is affected
by the recent patch.


Best regards
  Hartmut

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
