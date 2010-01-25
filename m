Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-07.arcor-online.net ([151.189.21.47]:45683 "EHLO
	mail-in-07.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752384Ab0AYVDG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2010 16:03:06 -0500
Message-ID: <4B5E06EA.40204@arcor.de>
Date: Mon, 25 Jan 2010 22:02:34 +0100
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: Terratec Cinergy Hybrid XE (TM6010 Mediachip)
References: <4B547EBF.6080105@arcor.de> <4B5DAC3A.6000408@redhat.com> <4B5DC2EA.3090706@arcor.de> <4B5DF134.7080603@redhat.com> <4B5DF360.40808@arcor.de> <4B5DF73F.9030807@redhat.com>
In-Reply-To: <4B5DF73F.9030807@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------070701080305050806060105"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070701080305050806060105
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Am 25.01.2010 20:55, schrieb Mauro Carvalho Chehab:
> Stefan Ringel wrote:
>   
>> Am 25.01.2010 20:29, schrieb Mauro Carvalho Chehab:
>>     
>>> Stefan Ringel wrote:
>>>   
>>>       
>>>> Am 25.01.2010 15:35, schrieb Mauro Carvalho Chehab:
>>>>     
>>>>         
>>>>> Stefan Ringel wrote:
>>>>>   
>>>>>       
>>>>>           
>>>>>> -----BEGIN PGP SIGNED MESSAGE-----
>>>>>> Hash: SHA1
>>>>>>  
>>>>>> Hi Davin,
>>>>>> I have a question. How are loaded the base firmware into xc3028, in
>>>>>> once or in a split ? It's importent for TM6010, the USB-Analyzer said
>>>>>> that it load it in once and then send a quitting reqeuest.
>>>>>>     
>>>>>>         
>>>>>>             
>>>>> The way the original driver for tm6000/tm6010 does varies from firmware
>>>>> version to firmware version. That part of the driver works fine for
>>>>> both tm6000 and tm6010, with the devices I used here, with firmwares 1.e 
>>>>> and 2.7. However, on tm6000, it sends the firmware on packages with
>>>>> up to 12 or 13 bytes, and it requires a delay before sending the next
>>>>> packet, otherwise the tm6000 hangs.
>>>>>
>>>>> Another problem is that the firmware load may fail (due to the bad
>>>>> implementation of the i2c on tm6000/tm6010). So, the code should ideally
>>>>> check if the firmware were loaded, by reading the firmware version at the
>>>>> end. However, reading from i2c is very problematic, since it sometimes
>>>>> read from the wrong place. On the tests I did here, the original drivers
>>>>> weren't reading back the firmware version, probably due to this bug.
>>>>>   
>>>>>       
>>>>>           
>>>> My hybrid-stick with tm6010 chip use a special request ( requests 0x32 +
>>>> 0x33) for quitting i2c transfer.
>>>>     
>>>>         
>>> Someone once commented that there are some procedures to reset I2C bank
>>> on tm6010. Maybe that's the meaning for the requests to 0x32/0x33.
>>>
>>>   
>>>       
>>>> so it can write correct the firmware
>>>> and can read tuner number and versions. Actually I tested next patch for
>>>> sync between tuner and demodulator and I have data by scanning digital
>>>> channels (one time), but  other test dos not data. I've test firmware
>>>> load 13, 64  and 3500 bytes and all works.
>>>>     
>>>>         
>>> 3500? That's weird! the maximum allowed size for URB control transfer is 80.
>>>   
>>>       
>> from xc3028 send max 3500 byte and then in i2c_xfer function it split to
>> 80 byte.
>> for example
>>
>> xc3028 --> 3500 byte  --> quit (base firmware subaddresse 0x2a 3411 byte)
>> tm6000_i2c_xfer --> 80 byte 80 byte .... 80 byte ---> quit
>>     
> Well, the better is to limit the size at xc3028 level, just like the other drivers.
> I'm afraid that letting it pass 3500 bytes will cause kernel hangups on some
> drivers that aren't prepared for it.
>
> Cheers,
> Mauro.
>   
Hi,

I found digital channel second time today, Last Saturday I found first
time. But it has over hack demodulator.

Cheers

Stefan Ringel



-- 
Stefan Ringel <stefan.ringel@arcor.de>


--------------070701080305050806060105
Content-Type: text/plain;
 name="2nd_scan_found.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="2nd_scan_found.txt"

linux-v5dy:/usr/src/src/tm6000/v4l-dvb # scan /usr/share/dvb/dvb-t/de-Berlin 
scanning /usr/share/dvb/dvb-t/de-Berlin                                      
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'           
initial transponder 177500000 1 3 9 1 2 4 0                                  
initial transponder 191500000 1 2 9 1 2 4 0                                  
initial transponder 506000000 0 2 9 1 2 4 0                                  
initial transponder 522000000 0 2 9 1 2 4 0                                  
initial transponder 570000000 0 2 9 1 2 4 0                                  
initial transponder 618000000 0 2 9 3 2 4 0                                  
initial transponder 658000000 0 2 9 1 2 4 0                                  
initial transponder 754000000 0 2 9 1 2 4 0                                  
initial transponder 778000000 0 2 9 1 2 4 0                                  
initial transponder 618000000 0 1 9 1 2 4 0                                  
>>> tune to: 177500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_16:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_NONE
WARNING: filter timeout pid 0x0011                                                                                                     
WARNING: filter timeout pid 0x0000                                                                                                     
WARNING: filter timeout pid 0x0010                                                                                                     
>>> tune to: 191500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:FEC_AUTO:QAM_16:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_NONE
WARNING: filter timeout pid 0x0011                                                                                                     
WARNING: filter timeout pid 0x0000                                                                                                     
WARNING: filter timeout pid 0x0010                                                                                                     
>>> tune to: 506000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_16:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_NONE
0x0000 0x4015: pmt_pid 0x0150 RTL World -- RTL Television (running)                                                                    
0x0000 0x4016: pmt_pid 0x0160 RTL World -- RTL2 (running)                                                                              
0x0000 0x401b: pmt_pid 0x01b0 RTL World -- Super RTL (running)                                                                         
0x0000 0x4022: pmt_pid 0x0220 RTL World -- VOX (running)                                                                               
WARNING: filter timeout pid 0x0010                                                                                                     
>>> tune to: 522000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_16:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_NONE
0x0000 0x000d: pmt_pid 0x0514 ARD -- Phoenix (running)                                                                                 
0x0000 0x000c: pmt_pid 0x04b0 ARD -- rbb Berlin (running)                                                                              
0x0000 0x000b: pmt_pid 0x044c ARD -- rbb Brandenburg (running)                                                                         
0x0000 0x000e: pmt_pid 0x0578 ARD -- Das Erste (running)                                                                               
0x0000 0x000f: pmt_pid 0x05dc ARD -- EinsExtra (running)                                                                               
Network Name 'DVB-T Berlin/Brandenburg'                                                                                                
>>> tune to: 570000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_16:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_NONE
0x0000 0x0203: pmt_pid 0x0230 ZDFmobil -- 3sat (running)                                                                               
0x0000 0x0205: pmt_pid 0x0250 ZDFmobil -- neo/KiKa (running)                                                                           
0x0000 0x0202: pmt_pid 0x0220 ZDFmobil -- ZDF (running)                                                                                
0x0000 0x0204: pmt_pid 0x0240 ZDFmobil -- ZDFinfokanal (running)                                                                       
Network Name 'ZDF'                                                                                                                     
>>> tune to: 618000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_NONE
0x0000 0x4014: pmt_pid 0x0140 MEDIA BROADCAST -- QVC (running)                                                                         
0x0000 0x402a: pmt_pid 0x02a0 MEDIA BROADCAST -- Bibel TV (running)                                                                    
0x0000 0x402e: pmt_pid 0x02e0 BetaDigital -- DAS VIERTE (running)                                                                      
0x0000 0x4030: pmt_pid 0x0300 MEDIA BROADCAST -- freies 1.Programm (running)                                                           
0x0000 0x4031: pmt_pid 0x0310 MEDIA BROADCAST -- freies 3.Programm (running)                                                           
0x0000 0x678e: pmt_pid 0x08e0 MEDIA BROADCAST -- freies 2.Programm (running)                                                           
Network Name 'MEDIA BROADCAST'                                                                                                         
>>> tune to: 658000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_16:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_NONE
0x0000 0x4018: pmt_pid 0x0180 ProSiebenSat.1 -- SAT.1 (running)                                                                        
0x0000 0x4013: pmt_pid 0x0130 ProSiebenSat.1 -- ProSieben (running)                                                                    
0x0000 0x400a: pmt_pid 0x00a0 ProSiebenSat.1 -- kabel eins (running)                                                                   
0x0000 0x400e: pmt_pid 0x00e0 ProSiebenSat.1 -- N24 (running)                                                                          
Network Name 'MEDIA BROADCAST'                                                                                                         
>>> tune to: 754000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_16:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_NONE
0x0000 0x4024: pmt_pid 0x0240 MEDIA BROADCAST -- Eurosport (running)                                                                   
0x0000 0x4011: pmt_pid 0x0110 BetaDigital -- 9Live (running)                                                                           
0x0000 0x4008: pmt_pid 0x0080 BetaDigital -- DSF (running)                                                                             
0x0000 0x40c3: pmt_pid 0x0c30 MEDIA BROADCAST -- TV.Berlin (running)                                                                   
Network Name 'MEDIA BROADCAST'                                                                                                         
>>> tune to: 778000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_16:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_NONE
Network Name 'MEDIA BROADCAST'                                                                                                         
0x0000 0x4025: pmt_pid 0x0250 MEDIA BROADCAST -- Channel 21/Euronews (running)                                                         
0x0000 0x678b: pmt_pid 0x08b0 MEDIA BROADCAST -- JayJay.FM (running)                                                                   
0x0000 0x6782: pmt_pid 0x0820 MEDIA BROADCAST -- 104.6 RTL (running)                                                                   
0x0000 0x6787: pmt_pid 0x0870 MEDIA BROADCAST -- Radio Paloma (running)                                                                
0x0000 0x678a: pmt_pid 0x08a0 MEDIA BROADCAST -- Spreeradio (running)                                                                  
0x0000 0x6026: pmt_pid 0x0260 MEDIA BROADCAST -- 104.6RTL- Best Of Modern Rock And Pop (running)                                       
0x0000 0x6013: pmt_pid 0x0130 Eurociel -- Radio Horeb (running)                                                                        
0x0000 0x4010: pmt_pid 0x0100 RTL World -- n-tv (running)
0x0000 0x6014: pmt_pid 0x0140 BetaDigital -- ERF Radio (running)
0x0000 0x6011: pmt_pid 0x0110 BetaDigital -- sunshine live (running)
0x0000 0x678e: pmt_pid 0x08e0 MEDIA BROADCAST -- JayJay.VR (running)
>>> tune to: 618000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_AUTO:QAM_16:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_NONE
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010
dumping lists (38 services)
RTL Television:506000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_16:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:337:338:16405
RTL2:506000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_16:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:353:354:16406
Super RTL:506000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_16:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:433:434:16411
VOX:506000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_16:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:545:546:16418
Das Erste:522000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:1401:1402:14
rbb Berlin:522000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:1201:1202:12
rbb Brandenburg:522000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:1201:1202:11
Phoenix:522000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:1301:1302:13
EinsExtra:522000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:1501:1502:15
ZDF:570000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:545:546:514
3sat:570000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:561:562:515
neo/KiKa:570000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:593:594:517
ZDFinfokanal:570000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:577:578:516
QVC:618000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:321:322:16404
Bibel TV:618000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:673:674:16426
DAS VIERTE:618000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:737:738:16430
freies 1.Programm:618000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:785:786:16432
freies 3.Programm:618000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:785:786:16433
freies 2.Programm:618000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:785:786:26510
SAT.1:658000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:385:386:16408
ProSieben:658000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:305:306:16403
kabel eins:658000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:161:162:16394
N24:658000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:225:226:16398
Eurosport:754000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:577:578:16420
DSF:754000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:129:130:16392
TV.Berlin:754000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:3121:3122:16579
9Live:754000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:273:274:16401
Channel 21/Euronews:778000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:593:594:16421
104.6 RTL:778000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:0:2082:26498
Radio Paloma:778000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:0:2162:26503
Spreeradio:778000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:0:2210:26506
104.6RTL- Best Of Modern Rock And Pop:778000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:0:610:24614
Radio Horeb:778000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:0:306:24595
n-tv:778000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:257:258:16400
ERF Radio:778000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:0:322:24596
sunshine live:778000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:0:274:24593
JayJay.VR:778000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:2273:2226:26510
JayJay.FM:778000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:0:2226:26507
Done.

--------------070701080305050806060105--
