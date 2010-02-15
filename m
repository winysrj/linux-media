Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-15.arcor-online.net ([151.189.21.55]:38483 "EHLO
	mail-in-15.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756494Ab0BOUak (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2010 15:30:40 -0500
Message-ID: <4B79AEC4.5010808@arcor.de>
Date: Mon, 15 Feb 2010 21:29:56 +0100
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: linux-media@vger.kernel.org, mchehab@redhat.com
Subject: Re: [PATCH 01/11] xc2028: tm6000: bugfix firmware xc3028L-v36.fw
 used 	with Zarlink and DTV78 or DTV8 no shift
References: <1266255444-7422-1-git-send-email-stefan.ringel@arcor.de> <829197381002151036w2cbfa8f7t59fc097f9c692631@mail.gmail.com> <4B799E5B.8090208@arcor.de>
In-Reply-To: <4B799E5B.8090208@arcor.de>
Content-Type: multipart/mixed;
 boundary="------------080702090601090609080006"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080702090601090609080006
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Am 15.02.2010 20:19, schrieb Stefan Ringel:
> Am 15.02.2010 19:36, schrieb Devin Heitmueller:
>   
>> On Mon, Feb 15, 2010 at 12:37 PM,  <stefan.ringel@arcor.de> wrote:
>>   
>>     
>>> From: Stefan Ringel <stefan.ringel@arcor.de>
>>>
>>> Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
>>>
>>> diff --git a/drivers/media/common/tuners/tuner-xc2028.c b/drivers/media/common/tuners/tuner-xc2028.c
>>> index ed50168..e051caa 100644
>>> --- a/drivers/media/common/tuners/tuner-xc2028.c
>>> +++ b/drivers/media/common/tuners/tuner-xc2028.c
>>> @@ -1114,7 +1114,12 @@ static int xc2028_set_params(struct dvb_frontend *fe,
>>>
>>>        /* All S-code tables need a 200kHz shift */
>>>        if (priv->ctrl.demod) {
>>> -               demod = priv->ctrl.demod + 200;
>>> +               if ((priv->firm_version == 0x0306) &&
>>> +                       (priv->ctrl.demod == XC3028_FE_ZARLINK456) &&
>>> +                               ((type & DTV78) || (type & DTV8)))
>>> +                       demod = priv->ctrl.demod;
>>> +               else
>>> +                       demod = priv->ctrl.demod + 200;
>>>                /*
>>>                 * The DTV7 S-code table needs a 700 kHz shift.
>>>                 * Thanks to Terry Wu <terrywu2009@gmail.com> for reporting this
>>>     
>>>       
>> I would still like to better understand the origin of this change.
>> Was the tm6000 board not locking without it?  Was this change based on
>> any documented source?  What basis are you using when deciding this
>> issue is specific only to the zl10353 and not all boards using the
>> xc3028L?
>>
>> We've got a number of boards already supported which use the xc3028L,
>> so we need to ensure there is no regression introduced in those boards
>> just to get yours working.
>>
>> Devin
>>
>>   
>>     
> Devin here in attachment the firmware table. You see, that it is has two
> entries  for ZARLINK456, one for QAM, DTV6 and DTV7, and one for DTV78
> and DTV8. The first have a shift from +200, the second doesn't. I can
> test for you without this patch to see what for demodulator status is has.
>
> Stefan Ringel
>
>   
Darvin,
I have the test result. The first once is with my patch and the second
without my patch.


-- 
Stefan Ringel <stefan.ringel@arcor.de>


--------------080702090601090609080006
Content-Type: text/plain;
 name="test1.txt"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename="test1.txt"

with this patch

linux-v5dy:/usr/src/src/tm6000/v4l-dvb # scan /usr/share/dvb/dvb-t/de-Berlin                                                                                                                                                                                                                                                      
scanning /usr/share/dvb/dvb-t/de-Berlin                                                                                                                                                                                                                                                                                           
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'                                                                                                                                                                                                                                                                
initial transponder 177500000 1 3 9 1 1 2 0                                                                                                                                                                                                                                                                                       
initial transponder 191500000 1 2 9 1 1 2 0                                                                                                                                                                                                                                                                                       
initial transponder 506000000 0 2 9 1 1 2 0                                                                                                                                                                                                                                                                                       
initial transponder 522000000 0 2 9 1 1 2 0                                                                                                                                                                                                                                                                                       
initial transponder 570000000 0 2 9 1 1 3 0                                                                                                                                                                                                                                                                                       
initial transponder 618000000 0 2 9 3 1 3 0                                                                                                                                                                                                                                                                                       
initial transponder 658000000 0 2 9 1 1 2 0                                                                                                                                                                                                                                                                                       
initial transponder 754000000 0 2 9 1 1 2 0                                                                                                                                                                                                                                                                                       
initial transponder 778000000 0 2 9 1 1 2 0                                                                                                                                                                                                                                                                                       
>>> tune to: 177500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE                                                                                                                                                                                              
0x0000 0x000f: pmt_pid 0x00f0 ARD -- WDR K�ln (running)                                                                                                                                                                                                                                                                           
0x0000 0x0010: pmt_pid 0x0100 ARD -- S�dwest BW/RP (running)                                                                                                                                                                                                                                                                      
0x0000 0x4003: pmt_pid 0x0030 MEDIA BROADCAST -- HSE24 (running)                                                                                                                                                                                                                                                                  
0x0000 0x401d: pmt_pid 0x01d0 MEDIA BROADCAST -- TELE 5 (running)                                                                                                                                                                                                                                                                 
Network Name 'MEDIA BROADCAST'                                                                                                                                                                                                                                                                                                    
>>> tune to: 191500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:FEC_AUTO:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE                                                                                                                                                                                              
0x0000 0x0009: pmt_pid 0x0384 ARD -- ARD-Data-1 (running)                                                                                                                                                                                                                                                                         
0x0000 0x0002: pmt_pid 0x00c8 ARD -- arte (running)                                                                                                                                                                                                                                                                               
0x0000 0x0001: pmt_pid 0x0064 ARD -- MDR Sachsen (running)                                                                                                                                                                                                                                                                        
0x0000 0x0003: pmt_pid 0x012c ARD -- NDR FERNSEHEN (running)                                                                                                                                                                                                                                                                      
0x0000 0x000a: pmt_pid 0x03e8 ARD -- ARD-Data-2 (running)                                                                                                                                                                                                                                                                         
Network Name 'RBB-Brbg1 '                                                                                                                                                                                                                                                                                                         
>>> tune to: 506000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE                                                                                                                                                                                              
0x0000 0x4015: pmt_pid 0x0150 RTL World -- RTL Television (running)                                                                                                                                                                                                                                                               
0x0000 0x4016: pmt_pid 0x0160 RTL World -- RTL2 (running)                                                                                                                                                                                                                                                                         
0x0000 0x401b: pmt_pid 0x01b0 RTL World -- Super RTL (running)                                                                                                                                                                                                                                                                    
0x0000 0x4022: pmt_pid 0x0220 RTL World -- VOX (running)                                                                                                                                                                                                                                                                          
Network Name 'MEDIA BROADCAST'                                                                                                                                                                                                                                                                                                    
>>> tune to: 522000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE                                                                                                                                                                                               
0x0102 0x000d: pmt_pid 0x0514 ARD -- Phoenix (running)                                                                                                                                                                                                                                                                            
0x0102 0x000c: pmt_pid 0x04b0 ARD -- rbb Berlin (running)                                                                                                                                                                                                                                                                         
0x0102 0x000b: pmt_pid 0x044c ARD -- rbb Brandenburg (running)                                                                                                                                                                                                                                                                    
0x0102 0x000e: pmt_pid 0x0578 ARD -- Das Erste (running)                                                                                                                                                                                                                                                                          
0x0102 0x000f: pmt_pid 0x05dc ARD -- EinsExtra (running)                                                                                                                                                                                                                                                                          
Network Name 'DVB-T Berlin/Brandenburg'                                                                                                                                                                                                                                                                                           
>>> tune to: 570000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE                                                                                                                                                                                              
0x0000 0x0203: pmt_pid 0x0230 ZDFmobil -- 3sat (running)                                                                                                                                                                                                                                                                          
0x0000 0x0205: pmt_pid 0x0250 ZDFmobil -- neo/KiKa (running)                                                                                                                                                                                                                                                                      
0x0000 0x0202: pmt_pid 0x0220 ZDFmobil -- ZDF (running)                                                                                                                                                                                                                                                                           
0x0000 0x0204: pmt_pid 0x0240 ZDFmobil -- ZDFinfokanal (running)                                                                                                                                                                                                                                                                  
Network Name 'ZDF'                                                                                                                                                                                                                                                                                                                
>>> tune to: 618000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE                                                                                                                                                                                              
0x0000 0x4014: pmt_pid 0x0140 MEDIA BROADCAST -- QVC (running)                                                                                                                                                                                                                                                                    
0x0000 0x402a: pmt_pid 0x02a0 MEDIA BROADCAST -- Bibel TV (running)                                                                                                                                                                                                                                                               
0x0000 0x402e: pmt_pid 0x02e0 BetaDigital -- DAS VIERTE (running)                                                                                                                                                                                                                                                                 
0x0000 0x4030: pmt_pid 0x0300 MEDIA BROADCAST -- freies 1.Programm (running)                                                                                                                                                                                                                                                      
0x0000 0x4031: pmt_pid 0x0310 MEDIA BROADCAST -- freies 3.Programm (running)                                                                                                                                                                                                                                                      
0x0000 0x678e: pmt_pid 0x08e0 MEDIA BROADCAST -- freies 2.Programm (running)                                                                                                                                                                                                                                                      
Network Name 'MEDIA BROADCAST'                                                                                                                                                                                                                                                                                                    
>>> tune to: 658000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE                                                                                                                                                                                              
0x0000 0x4018: pmt_pid 0x0180 ProSiebenSat.1 -- SAT.1 (running)                                                                                                                                                                                                                                                                   
0x0000 0x4013: pmt_pid 0x0130 ProSiebenSat.1 -- ProSieben (running)                                                                                                                                                                                                                                                               
0x0000 0x400a: pmt_pid 0x00a0 ProSiebenSat.1 -- kabel eins (running)                                                                                                                                                                                                                                                              
0x0000 0x400e: pmt_pid 0x00e0 ProSiebenSat.1 -- N24 (running)                                                                                                                                                                                                                                                                     
Network Name 'MEDIA BROADCAST'                                                                                                                                                                                                                                                                                                    
>>> tune to: 754000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE                                                                                                                                                                                              
0x0000 0x4024: pmt_pid 0x0240 MEDIA BROADCAST -- Eurosport (running)                                                                                                                                                                                                                                                              
0x0000 0x4011: pmt_pid 0x0110 BetaDigital -- 9Live (running)                                                                                                                                                                                                                                                                      
0x0000 0x4008: pmt_pid 0x0080 BetaDigital -- DSF (running)                                                                                                                                                                                                                                                                        
0x0000 0x40c3: pmt_pid 0x0c30 MEDIA BROADCAST -- TV.Berlin (running)                                                                                                                                                                                                                                                              
Network Name 'MEDIA BROADCAST'                                                                                                                                                                                                                                                                                                    
>>> tune to: 778000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE                                                                                                                                                                                              
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
Network Name 'MEDIA BROADCAST'                                                                                                                                                                                                                                                                                                    
dumping lists (47 services)                                                                                                                                                                                                                                                                                                       
WDR K�ln:177500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_1_2:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:241:242:15                                                                                                                                                                                        
S�dwest BW/RP:177500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_1_2:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:257:258:16
HSE24:177500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_1_2:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:49:50:16387
TELE 5:177500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_1_2:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:465:466:16413
MDR Sachsen:191500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:FEC_1_2:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:101:102:1
ARD-Data-2:191500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:FEC_1_2:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:0:0:10
ARD-Data-1:191500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:FEC_1_2:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:0:0:9
NDR FERNSEHEN:191500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:FEC_1_2:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:301:302:3
arte:191500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:FEC_1_2:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:201:202:2
RTL Television:506000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:337:338:16405
RTL2:506000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:353:354:16406
Super RTL:506000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:433:434:16411
VOX:506000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:545:546:16418
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


linux-v5dy:/home/stefan/Dokumente # femon
FE: Zarlink ZL10353 DVB-T (DVBT)
status       | signal a2c8 | snr 7d7d | ber 00000000 | unc 0000189c |
status  CVYL | signal a358 | snr 9191 | ber 00000000 | unc 000018a0 | FE_HAS_LOCK
status  CVYL | signal a3cc | snr bdbd | ber 00000000 | unc 000018a0 | FE_HAS_LOCK
status  CVYL | signal a390 | snr d2d2 | ber 00000000 | unc 000018a0 | FE_HAS_LOCK
status  CVYL | signal a428 | snr bfbf | ber 00000000 | unc 000018a0 | FE_HAS_LOCK
status  CVYL | signal a3cc | snr aeae | ber 00000000 | unc 000018a3 | FE_HAS_LOCK
status  CVYL | signal a45c | snr bfbf | ber 00000000 | unc 000018a3 | FE_HAS_LOCK
status  CVYL | signal a490 | snr a4a4 | ber 00000000 | unc 000018a3 | FE_HAS_LOCK



without this  patch

linux-v5dy:/usr/src/src/tm6000/v4l-dvb # scan /usr/share/dvb/dvb-t/de-Berlin                                                                                                                                                                                                                                                     
scanning /usr/share/dvb/dvb-t/de-Berlin                                                                                                                                                                                                                                                                                          
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'                                                                                                                                                                                                                                                               
initial transponder 177500000 1 3 9 1 1 2 0                                                                                                                                                                                                                                                                                      
initial transponder 191500000 1 2 9 1 1 2 0                                                                                                                                                                                                                                                                                      
initial transponder 506000000 0 2 9 1 1 2 0                                                                                                                                                                                                                                                                                      
initial transponder 522000000 0 2 9 1 1 2 0                                                                                                                                                                                                                                                                                      
initial transponder 570000000 0 2 9 1 1 3 0                                                                                                                                                                                                                                                                                      
initial transponder 618000000 0 2 9 3 1 3 0                                                                                                                                                                                                                                                                                      
initial transponder 658000000 0 2 9 1 1 2 0                                                                                                                                                                                                                                                                                      
initial transponder 754000000 0 2 9 1 1 2 0                                                                                                                                                                                                                                                                                      
initial transponder 778000000 0 2 9 1 1 2 0                                                                                                                                                                                                                                                                                      
>>> tune to: 177500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE                                                                                                                                                                                             
WARNING: filter timeout pid 0x0011                                                                                                                                                                                                                                                                                               
WARNING: filter timeout pid 0x0010                                                                                                                                                                                                                                                                                               
>>> tune to: 191500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:FEC_AUTO:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE                                                                                                                                                                                             
WARNING: filter timeout pid 0x0011                                                                                                                                                                                                                                                                                               
WARNING: filter timeout pid 0x0000                                                                                                                                                                                                                                                                                               
WARNING: filter timeout pid 0x0010                                                                                                                                                                                                                                                                                               
>>> tune to: 506000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE                                                                                                                                                                                             
0x0000 0x4015: pmt_pid 0x0150 RTL World -- RTL Television (running)                                                                                                                                                                                                                                                              
0x0000 0x4016: pmt_pid 0x0160 RTL World -- RTL2 (running)                                                                                                                                                                                                                                                                        
0x0000 0x401b: pmt_pid 0x01b0 RTL World -- Super RTL (running)                                                                                                                                                                                                                                                                   
0x0000 0x4022: pmt_pid 0x0220 RTL World -- VOX (running)                                                                                                                                                                                                                                                                         
Network Name 'MEDIA BROADCAST'                                                                                                                                                                                                                                                                                                   
>>> tune to: 522000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE                                                                                                                                                                                             
0x0000 0x000d: pmt_pid 0x0514 ARD -- Phoenix (running)                                                                                                                                                                                                                                                                           
0x0000 0x000c: pmt_pid 0x04b0 ARD -- rbb Berlin (running)                                                                                                                                                                                                                                                                        
0x0000 0x000b: pmt_pid 0x044c ARD -- rbb Brandenburg (running)                                                                                                                                                                                                                                                                   
0x0000 0x000e: pmt_pid 0x0578 ARD -- Das Erste (running)                                                                                                                                                                                                                                                                         
0x0000 0x000f: pmt_pid 0x05dc ARD -- EinsExtra (running)                                                                                                                                                                                                                                                                         
Network Name 'DVB-T Berlin/Brandenburg'                                                                                                                                                                                                                                                                                          
>>> tune to: 570000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE                                                                                                                                                                                             
0x0000 0x0203: pmt_pid 0x0230 ZDFmobil -- 3sat (running)                                                                                                                                                                                                                                                                         
0x0000 0x0205: pmt_pid 0x0250 ZDFmobil -- neo/KiKa (running)                                                                                                                                                                                                                                                                     
0x0000 0x0202: pmt_pid 0x0220 ZDFmobil -- ZDF (running)                                                                                                                                                                                                                                                                          
0x0000 0x0204: pmt_pid 0x0240 ZDFmobil -- ZDFinfokanal (running)                                                                                                                                                                                                                                                                 
Network Name 'ZDF'                                                                                                                                                                                                                                                                                                               
>>> tune to: 618000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE                                                                                                                                                                                             
0x0000 0x4014: pmt_pid 0x0140 MEDIA BROADCAST -- QVC (running)                                                                                                                                                                                                                                                                   
0x0000 0x402a: pmt_pid 0x02a0 MEDIA BROADCAST -- Bibel TV (running)                                                                                                                                                                                                                                                              
0x0000 0x402e: pmt_pid 0x02e0 BetaDigital -- DAS VIERTE (running)                                                                                                                                                                                                                                                                
0x0000 0x4030: pmt_pid 0x0300 MEDIA BROADCAST -- freies 1.Programm (running)                                                                                                                                                                                                                                                     
0x0000 0x4031: pmt_pid 0x0310 MEDIA BROADCAST -- freies 3.Programm (running)                                                                                                                                                                                                                                                     
0x0000 0x678e: pmt_pid 0x08e0 MEDIA BROADCAST -- freies 2.Programm (running)                                                                                                                                                                                                                                                     
Network Name 'MEDIA BROADCAST'                                                                                                                                                                                                                                                                                                   
>>> tune to: 658000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE                                                                                                                                                                                             
0x0000 0x4018: pmt_pid 0x0180 ProSiebenSat.1 -- SAT.1 (running)                                                                                                                                                                                                                                                                  
0x0000 0x4013: pmt_pid 0x0130 ProSiebenSat.1 -- ProSieben (running)                                                                                                                                                                                                                                                              
0x0000 0x400a: pmt_pid 0x00a0 ProSiebenSat.1 -- kabel eins (running)                                                                                                                                                                                                                                                             
0x0000 0x400e: pmt_pid 0x00e0 ProSiebenSat.1 -- N24 (running)                                                                                                                                                                                                                                                                    
Network Name 'MEDIA BROADCAST'                                                                                                                                                                                                                                                                                                   
>>> tune to: 754000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE                                                                                                                                                                                             
0x0000 0x4024: pmt_pid 0x0240 MEDIA BROADCAST -- Eurosport (running)                                                                                                                                                                                                                                                             
0x0000 0x4011: pmt_pid 0x0110 BetaDigital -- 9Live (running)                                                                                                                                                                                                                                                                     
0x0000 0x4008: pmt_pid 0x0080 BetaDigital -- DSF (running)                                                                                                                                                                                                                                                                       
0x0000 0x40c3: pmt_pid 0x0c30 MEDIA BROADCAST -- TV.Berlin (running)                                                                                                                                                                                                                                                             
Network Name 'MEDIA BROADCAST'                                                                                                                                                                                                                                                                                                   
>>> tune to: 778000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE                                                                                                                                                                                             
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
Network Name 'MEDIA BROADCAST'
dumping lists (42 services)
[000f]:177500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:241:242:15
[0010]:177500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:257:258:16
[4003]:177500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:49:50:16387
[401d]:177500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:465:466:16413
RTL Television:506000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:337:338:16405
RTL2:506000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:353:354:16406
Super RTL:506000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:433:434:16411
VOX:506000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:545:546:16418
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


linux-v5dy:/home/stefan/Dokumente # femon
FE: Zarlink ZL10353 DVB-T (DVBT)
status       | signal a0e8 | snr 4444 | ber 00000000 | unc 0000041a |
status  CVYL | signal a134 | snr 7a7a | ber 00000000 | unc 00002eb5 | FE_HAS_LOCK
status  CVYL | signal a14c | snr 7b7b | ber 00000000 | unc 0000ba4c | FE_HAS_LOCK
status  CV   | signal a194 | snr 3737 | ber 00000000 | unc 0001583a |
status  CVYL | signal a1a4 | snr a9a9 | ber 00000000 | unc 0001583a | FE_HAS_LOCK
status  CVYL | signal a194 | snr c3c3 | ber 00000000 | unc 0001583a | FE_HAS_LOCK
status  CVYL | signal a210 | snr bbbb | ber 00000000 | unc 0001583a | FE_HAS_LOCK
status  CVYL | signal a13c | snr 9999 | ber 00000000 | unc 00015e93 | FE_HAS_LOCK
status  CVYL | signal a2bc | snr b1b1 | ber 00000000 | unc 00015e93 | FE_HAS_LOCK
status  CVYL | signal a274 | snr 8b8b | ber 00000000 | unc 00015e93 | FE_HAS_LOCK
status  CVYL | signal a248 | snr a6a6 | ber 00000000 | unc 00015ff2 | FE_HAS_LOCK

--------------080702090601090609080006--
