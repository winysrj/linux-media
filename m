Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nschwmtas01p.mx.bigpond.com ([61.9.189.137])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <patrick.claven@manildra.com.au>) id 1KQzyc-0003xe-IC
	for linux-dvb@linuxtv.org; Thu, 07 Aug 2008 09:32:06 +0200
Received: from nschwotgx01p.mx.bigpond.com ([121.223.222.185])
	by nschwmtas01p.mx.bigpond.com with ESMTP id
	<20080807073124.URBC19495.nschwmtas01p.mx.bigpond.com@nschwotgx01p.mx.bigpond.com>
	for <linux-dvb@linuxtv.org>; Thu, 7 Aug 2008 07:31:24 +0000
Received: from [172.20.4.99] (really [121.223.222.185])
	by nschwotgx01p.mx.bigpond.com with ESMTP
	id <20080807073122.IMCC28620.nschwotgx01p.mx.bigpond.com@[172.20.4.99]>
	for <linux-dvb@linuxtv.org>; Thu, 7 Aug 2008 07:31:22 +0000
Message-Id: <444FF4EE-E32A-4048-989E-832EC0E29595@manildra.com.au>
From: Patrick Claven <patrick.claven@manildra.com.au>
To: linux-dvb@linuxtv.org
In-Reply-To: <mailman.310.1218093013.25488.linux-dvb@linuxtv.org>
Mime-Version: 1.0 (Apple Message framework v926)
Date: Thu, 7 Aug 2008 17:31:06 +1000
References: <mailman.310.1218093013.25488.linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] DVICO Dual Express
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

this card works perfectly with Chris Pasco's patch and instructions  
found here: http://www.itee.uq.edu.au/~chrisp/Linux-DVB/DVICO/

  I am running 2 of them with no issues whatsoever.

Cheers,


Patrick


On 07/08/2008, at 5:10 PM, linux-dvb-request@linuxtv.org wrote:

> Send linux-dvb mailing list submissions to
> 	linux-dvb@linuxtv.org
>
> To subscribe or unsubscribe via the World Wide Web, visit
> 	http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> or, via email, send a message with subject or body 'help' to
> 	linux-dvb-request@linuxtv.org
>
> You can reach the person managing the list at
> 	linux-dvb-owner@linuxtv.org
>
> When replying, please edit your Subject line so it is more specific
> than "Re: Contents of linux-dvb digest..."
>
>
> Today's Topics:
>
>   1. Re: [PATCH] Add initial support for DViCO FusionHDTV DVB-T
>      Dual Express (Tim Farrington)
>   2. Re: [PATCH] Add initial support for DViCO FusionHDTV	DVB-T
>      Dual Express (David)
>   3. Re: [PATCH] Add initial support for DViCO FusionHDTV DVB-T
>      Dual Express (Tim Farrington)
>   4. Re: [PATCH] Add initial support for DViCO FusionHDTV	DVB-T
>      Dual Express (David)
>
>
> ----------------------------------------------------------------------
>
> Message: 1
> Date: Thu, 07 Aug 2008 12:34:18 +0800
> From: Tim Farrington <timf@iinet.net.au>
> Subject: Re: [linux-dvb] [PATCH] Add initial support for DViCO
> 	FusionHDTV DVB-T Dual Express
> To: David <dvb-t@iinet.com.au>
> Cc: linux-dvb@linuxtv.org
> Message-ID: <489A7B4A.4080206@iinet.net.au>
> Content-Type: text/plain; charset=ISO-8859-1; format=flowed
>
> David wrote:
>> Hi Tim
>>
>> Thanks for information.
>>
>> I obtained the driver, extracted the firmware to lib/firmware and
>> tried to scan.
>> I cannot get a lock on anything.
>>
>> dmesg shows it is loading the firmware but nothing more:
>>
>> [  192.596627] xc2028 1-0061: Loading 3 firmware images from
>> xc3028-v27.fw, type: DViCO DualDig4/Nano2 (Australia), ver 2.7
>> [  192.796658] xc2028 1-0061: Loading firmware for type=BASE F8MHZ
>> (3), id 0000000000000000.
>> [  193.965865] xc2028 1-0061: Loading firmware for type=D2620 DTV7
>> (88), id 0000000000000000.
>> [  265.268818] xc2028 2-0061: Loading 3 firmware images from
>> xc3028-v27.fw, type: DViCO DualDig4/Nano2 (Australia), ver 2.7
>> [  265.468693] xc2028 2-0061: Loading firmware for type=BASE F8MHZ
>> (3), id 0000000000000000.
>> [  266.633170] xc2028 2-0061: Loading firmware for type=D2620 DTV7
>> (88), id 0000000000000000.
>>
>>
>> Regards
>> David
>>
>>
>>
>> ----- Original Message ----- From: "Tim Farrington" <timf@iinet.net.au 
>> >
>> To: "David Porter" <dvb-t@iinet.com.au>
>> Cc: <linux-dvb@linuxtv.org>
>> Sent: Wednesday, August 06, 2008 6:51 PM
>> Subject: Re: [linux-dvb] [PATCH] Add initial support for DViCO
>> FusionHDTV DVB-T Dual Express
>>
>>
>>> David Porter wrote:
>>>> Hi
>>>>
>>>> I have one of these, saw Stevens post and thought i would give it  
>>>> a go.
>>>>
>>>> I built from : http://linuxtv.org/hg/~stoth/v4l-dvb
>>>> All seemed to go well with no errors.
>>>>
>>>> dmesg reads:
>>>>
>>>> [   31.964424] CORE cx23885[0]: subsystem: 18ac:db78, board: DViCO
>>>> FusionHDTV DVB-T Dual Express [card=11,autodetected]
>>>> [   32.104767] cx23885[0]: i2c bus 0 registered
>>>> [   32.104781] cx23885[0]: i2c bus 1 registered
>>>> [   32.104794] cx23885[0]: i2c bus 2 registered
>>>> [   32.164385] input: i2c IR (FusionHDTV) as
>>>> /devices/virtual/input/input8
>>>> [   32.422764] ir-kbd-i2c: i2c IR (FusionHDTV) detected at
>>>> i2c-1/1-006b/ir0 [cx23885[0]]
>>>> [   32.423135] cx23885[0]: cx23885 based dvb card
>>>> [   32.492021] xc2028 1-0061: creating new instance
>>>> [   32.492027] xc2028 1-0061: type set to XCeive xc2028/xc3028  
>>>> tuner
>>>> [   32.492036] DVB: registering new adapter (cx23885[0])
>>>> [   32.492040] DVB: registering frontend 0 (Zarlink ZL10353 DVB- 
>>>> T)...
>>>> [   32.492386] cx23885[0]: cx23885 based dvb card
>>>> [   32.492924] xc2028 2-0061: creating new instance
>>>> [   32.492926] xc2028 2-0061: type set to XCeive xc2028/xc3028  
>>>> tuner
>>>> [   32.492928] DVB: registering new adapter (cx23885[0])
>>>> [   32.492930] DVB: registering frontend 1 (Zarlink ZL10353 DVB- 
>>>> T)...
>>>> [   32.493228] cx23885_dev_checkrevision() Hardware revision = 0xb0
>>>> [   32.493236] cx23885[0]/0: found at 0000:02:00.0, rev: 2, irq:  
>>>> 16,
>>>> latency: 0, mmio: 0xfe800000
>>>>
>>>> But scanning, returns :
>>>>
>>>> [ 1381.214624] xc2028 1-0061: Error: firmware xc3028-v27.fw not  
>>>> found.
>>>> [ 1382.220858] xc2028 1-0061: Error: firmware xc3028-v27.fw not  
>>>> found.
>>>> [ 1382.260825] xc2028 1-0061: Error: firmware xc3028-v27.fw not  
>>>> found.
>>>> [ 1383.267724] xc2028 1-0061: Error: firmware xc3028-v27.fw not  
>>>> found.
>>>> [ 1383.276680] xc2028 1-0061: Error: firmware xc3028-v27.fw not  
>>>> found.
>>>>
>>>> I checked  /lib/firmware/ but xc3028-v27.fw is not in the  
>>>> directory ?
>>>>
>>>> Must have messed it up somewhere! Any help appreciated.
>>>>
>>>> Thanks
>>>> David
>>>>
>>>> ----- Original Message ----- From: "Steven Toth"  
>>>> <stoth@linuxtv.org>
>>>> To: "Luke Yelavich" <themuso@themuso.com>
>>>> Cc: <linux-dvb@linuxtv.org>
>>>> Sent: Wednesday, August 06, 2008 11:44 AM
>>>> Subject: Re: [linux-dvb] [PATCH] Add initial support for DViCO
>>>> FusionHDTV DVB-T Dual Express
>>>>
>>>>
>>>>
>>>>>>>> I've tested with the HVR1500Q (xc5000 based) and I'm happy  
>>>>>>>> with the
>>>>>>>> results. Can you both try the DViCO board?
>>>>>>>>
>>>>>>> It tests fine and I like how simpler things have got.
>>>>>>>
>>>>>> I pulled the above linked tree, and compiled the modules. It  
>>>>>> seems
>>>>>> at the moment for the dual express, that I have to pass the
>>>>>> parameter card=11 to the driver, for it to correctly find the  
>>>>>> card
>>>>>> and make use of all adapters. Without any module parameters, dmsg
>>>>>> complains that the card couldn't be identified, yet two adapters
>>>>>> are shown. I have two of these cards.
>>>>>>
>>>>>> Hope this helps some.
>>>>>>
>>>>> .. And they're both the same model?
>>>>>
>>>>> If so, insert one at a time and run the 'lspci -vn' command,  
>>>>> save the
>>>>> output for each card.
>>>>>
>>>>> Post the output here.
>>>>>
>>>>> Assuming you load the driver with card=11, does each card work
>>>>> correctly
>>>>> after that?
>>>>>
>>>>> - Steve
>>>>>
>>>>> _______________________________________________
>>>>> linux-dvb mailing list
>>>>> linux-dvb@linuxtv.org
>>>>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>>>>
>>>>>
>>>>
>>>> _______________________________________________
>>>> linux-dvb mailing list
>>>> linux-dvb@linuxtv.org
>>>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>>>
>>>>
>>>
>>> To obtain xc3028-v27.fw
>>>
>>> see ~/v4l-dvb/linux/Documentation/video4linux/extract_xc3028.pl
>>>
>>> Regards,
>>> Timf
>>
> Try not to top post.
>
> Best to post the results of tzap here:
>
> In Ubuntu, Debian;
> sudo apt-get install dvb-utils
> (other distros use dvb-apps)
>
> Find the scan file appropriate for your area (au-*) in:
> /usr/share/doc/dvb-utils/examples/scan/dvb-t
>
> sudo -s -H
> mkdir /root/.tzap
> scan /usr/share/doc/dvb-utils/examples/scan/dvb-t/au-* >
> /root/.tzap/channels.conf
>
> Post the output of scan to this list.
>
> Regards,
> Timf
>
>
>
> ------------------------------
>
> Message: 2
> Date: Thu, 7 Aug 2008 16:41:02 +1000
> From: "David" <dvb-t@iinet.com.au>
> Subject: Re: [linux-dvb] [PATCH] Add initial support for DViCO
> 	FusionHDTV	DVB-T Dual Express
> To: <linux-dvb@linuxtv.org>
> Message-ID: <C5551D141EAB485E8EB2F1D8E43B6676@mce>
> Content-Type: text/plain; format=flowed; charset="iso-8859-1";
> 	reply-type=response
>
> ----- Original Message -----
> From: "Tim Farrington" <timf@iinet.net.au>
> To: "David" <dvb-t@iinet.com.au>
> Cc: <linux-dvb@linuxtv.org>
> Sent: Thursday, August 07, 2008 2:34 PM
> Subject: Re: [linux-dvb] [PATCH] Add initial support for DViCO  
> FusionHDTV
> DVB-T Dual Express
>
>
>> David wrote:
>>> Hi Tim
>>>
>>> Thanks for information.
>>>
>>> I obtained the driver, extracted the firmware to lib/firmware and  
>>> tried
>>> to scan.
>>> I cannot get a lock on anything.
>>>
>>> dmesg shows it is loading the firmware but nothing more:
>>>
>>> [  192.596627] xc2028 1-0061: Loading 3 firmware images from
>>> xc3028-v27.fw, type: DViCO DualDig4/Nano2 (Australia), ver 2.7
>>> [  192.796658] xc2028 1-0061: Loading firmware for type=BASE F8MHZ  
>>> (3),
>>> id 0000000000000000.
>>> [  193.965865] xc2028 1-0061: Loading firmware for type=D2620 DTV7  
>>> (88),
>>> id 0000000000000000.
>>> [  265.268818] xc2028 2-0061: Loading 3 firmware images from
>>> xc3028-v27.fw, type: DViCO DualDig4/Nano2 (Australia), ver 2.7
>>> [  265.468693] xc2028 2-0061: Loading firmware for type=BASE F8MHZ  
>>> (3),
>>> id 0000000000000000.
>>> [  266.633170] xc2028 2-0061: Loading firmware for type=D2620 DTV7  
>>> (88),
>>> id 0000000000000000.
>>>
>>>
>>> Regards
>>> David
>>>
>>>
>>>
>>> ----- Original Message ----- From: "Tim Farrington" <timf@iinet.net.au 
>>> >
>>> To: "David Porter" <dvb-t@iinet.com.au>
>>> Cc: <linux-dvb@linuxtv.org>
>>> Sent: Wednesday, August 06, 2008 6:51 PM
>>> Subject: Re: [linux-dvb] [PATCH] Add initial support for DViCO  
>>> FusionHDTV
>>> DVB-T Dual Express
>>>
>>>
>>>> David Porter wrote:
>>>>> Hi
>>>>>
>>>>> I have one of these, saw Stevens post and thought i would give  
>>>>> it a go.
>>>>>
>>>>> I built from : http://linuxtv.org/hg/~stoth/v4l-dvb
>>>>> All seemed to go well with no errors.
>>>>>
>>>>> dmesg reads:
>>>>>
>>>>> [   31.964424] CORE cx23885[0]: subsystem: 18ac:db78, board: DViCO
>>>>> FusionHDTV DVB-T Dual Express [card=11,autodetected]
>>>>> [   32.104767] cx23885[0]: i2c bus 0 registered
>>>>> [   32.104781] cx23885[0]: i2c bus 1 registered
>>>>> [   32.104794] cx23885[0]: i2c bus 2 registered
>>>>> [   32.164385] input: i2c IR (FusionHDTV) as
>>>>> /devices/virtual/input/input8
>>>>> [   32.422764] ir-kbd-i2c: i2c IR (FusionHDTV) detected at
>>>>> i2c-1/1-006b/ir0 [cx23885[0]]
>>>>> [   32.423135] cx23885[0]: cx23885 based dvb card
>>>>> [   32.492021] xc2028 1-0061: creating new instance
>>>>> [   32.492027] xc2028 1-0061: type set to XCeive xc2028/xc3028  
>>>>> tuner
>>>>> [   32.492036] DVB: registering new adapter (cx23885[0])
>>>>> [   32.492040] DVB: registering frontend 0 (Zarlink ZL10353 DVB- 
>>>>> T)...
>>>>> [   32.492386] cx23885[0]: cx23885 based dvb card
>>>>> [   32.492924] xc2028 2-0061: creating new instance
>>>>> [   32.492926] xc2028 2-0061: type set to XCeive xc2028/xc3028  
>>>>> tuner
>>>>> [   32.492928] DVB: registering new adapter (cx23885[0])
>>>>> [   32.492930] DVB: registering frontend 1 (Zarlink ZL10353 DVB- 
>>>>> T)...
>>>>> [   32.493228] cx23885_dev_checkrevision() Hardware revision =  
>>>>> 0xb0
>>>>> [   32.493236] cx23885[0]/0: found at 0000:02:00.0, rev: 2, irq:  
>>>>> 16,
>>>>> latency: 0, mmio: 0xfe800000
>>>>>
>>>>> But scanning, returns :
>>>>>
>>>>> [ 1381.214624] xc2028 1-0061: Error: firmware xc3028-v27.fw not  
>>>>> found.
>>>>> [ 1382.220858] xc2028 1-0061: Error: firmware xc3028-v27.fw not  
>>>>> found.
>>>>> [ 1382.260825] xc2028 1-0061: Error: firmware xc3028-v27.fw not  
>>>>> found.
>>>>> [ 1383.267724] xc2028 1-0061: Error: firmware xc3028-v27.fw not  
>>>>> found.
>>>>> [ 1383.276680] xc2028 1-0061: Error: firmware xc3028-v27.fw not  
>>>>> found.
>>>>>
>>>>> I checked  /lib/firmware/ but xc3028-v27.fw is not in the  
>>>>> directory ?
>>>>>
>>>>> Must have messed it up somewhere! Any help appreciated.
>>>>>
>>>>> Thanks
>>>>> David
>>>>>
>>>>> ----- Original Message ----- From: "Steven Toth" <stoth@linuxtv.org 
>>>>> >
>>>>> To: "Luke Yelavich" <themuso@themuso.com>
>>>>> Cc: <linux-dvb@linuxtv.org>
>>>>> Sent: Wednesday, August 06, 2008 11:44 AM
>>>>> Subject: Re: [linux-dvb] [PATCH] Add initial support for DViCO
>>>>> FusionHDTV DVB-T Dual Express
>>>>>
>>>>>
>>>>>
>>>>>>>>> I've tested with the HVR1500Q (xc5000 based) and I'm happy  
>>>>>>>>> with the
>>>>>>>>> results. Can you both try the DViCO board?
>>>>>>>>>
>>>>>>>> It tests fine and I like how simpler things have got.
>>>>>>>>
>>>>>>> I pulled the above linked tree, and compiled the modules. It  
>>>>>>> seems at
>>>>>>> the moment for the dual express, that I have to pass the  
>>>>>>> parameter
>>>>>>> card=11 to the driver, for it to correctly find the card and  
>>>>>>> make use
>>>>>>> of all adapters. Without any module parameters, dmsg complains  
>>>>>>> that
>>>>>>> the card couldn't be identified, yet two adapters are shown. I  
>>>>>>> have
>>>>>>> two of these cards.
>>>>>>>
>>>>>>> Hope this helps some.
>>>>>>>
>>>>>> .. And they're both the same model?
>>>>>>
>>>>>> If so, insert one at a time and run the 'lspci -vn' command,  
>>>>>> save the
>>>>>> output for each card.
>>>>>>
>>>>>> Post the output here.
>>>>>>
>>>>>> Assuming you load the driver with card=11, does each card work
>>>>>> correctly
>>>>>> after that?
>>>>>>
>>>>>> - Steve
>>>>>>
>>>>>> _______________________________________________
>>>>>> linux-dvb mailing list
>>>>>> linux-dvb@linuxtv.org
>>>>>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>>>>>
>>>>>>
>>>>>
>>>>> _______________________________________________
>>>>> linux-dvb mailing list
>>>>> linux-dvb@linuxtv.org
>>>>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>>>>
>>>>>
>>>>
>>>> To obtain xc3028-v27.fw
>>>>
>>>> see ~/v4l-dvb/linux/Documentation/video4linux/extract_xc3028.pl
>>>>
>>>> Regards,
>>>> Timf
>>>
>> Try not to top post.
>>
>> Best to post the results of tzap here:
>>
>> In Ubuntu, Debian;
>> sudo apt-get install dvb-utils
>> (other distros use dvb-apps)
>>
>> Find the scan file appropriate for your area (au-*) in:
>> /usr/share/doc/dvb-utils/examples/scan/dvb-t
>>
>> sudo -s -H
>> mkdir /root/.tzap
>> scan /usr/share/doc/dvb-utils/examples/scan/dvb-t/au-* >
>> /root/.tzap/channels.conf
>>
>> Post the output of scan to this list.
>>
>> Regards,
>> Timf
>
> Thanks, Tim
> Doesn't look too promising :
>
> a@a-desktop:~$ scan /usr/share/doc/dvb-utils/examples/scan/dvb-t/au- 
> Brisbane
> scanning /usr/share/doc/dvb-utils/examples/scan/dvb-t/au-Brisbane
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> initial transponder 226500000 1 3 9 3 1 1 0
> initial transponder 177500000 1 2 9 3 1 2 0
> initial transponder 191625000 1 3 9 3 1 1 0
> initial transponder 219500000 1 3 9 3 1 1 0
> initial transponder 585625000 1 2 9 3 1 2 0
>>>> tune to:
>>>> 226500000 
>>>> :INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
>>>> :FEC_AUTO:QAM_64 
>>>> :TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
> WARNING: >>> tuning failed!!!
>>>> tune to:
>>>> 226500000 
>>>> :INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
>>>> :FEC_AUTO:QAM_64 
>>>> :TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
>>>> (tuning failed)
> WARNING: >>> tuning failed!!!
>>>> tune to:
>>>> 177500000 
>>>> :INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3 
>>>> :FEC_AUTO:QAM_64 
>>>> :TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE
> WARNING: >>> tuning failed!!!
>>>> tune to:
>>>> 177500000 
>>>> :INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3 
>>>> :FEC_AUTO:QAM_64 
>>>> :TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE
>>>> (tuning failed)
> WARNING: >>> tuning failed!!!
>>>> tune to:
>>>> 191625000 
>>>> :INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
>>>> :FEC_AUTO:QAM_64 
>>>> :TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
> WARNING: >>> tuning failed!!!
>>>> tune to:
>>>> 191625000 
>>>> :INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
>>>> :FEC_AUTO:QAM_64 
>>>> :TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
>>>> (tuning failed)
> WARNING: >>> tuning failed!!!
>>>> tune to:
>>>> 219500000 
>>>> :INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
>>>> :FEC_AUTO:QAM_64 
>>>> :TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
> WARNING: >>> tuning failed!!!
>>>> tune to:
>>>> 219500000 
>>>> :INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
>>>> :FEC_AUTO:QAM_64 
>>>> :TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
>>>> (tuning failed)
> WARNING: >>> tuning failed!!!
>>>> tune to:
>>>> 585625000 
>>>> :INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3 
>>>> :FEC_AUTO:QAM_64 
>>>> :TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE
> WARNING: >>> tuning failed!!!
>>>> tune to:
>>>> 585625000 
>>>> :INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3 
>>>> :FEC_AUTO:QAM_64 
>>>> :TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE
>>>> (tuning failed)
> WARNING: >>> tuning failed!!!
> ERROR: initial tuning failed
> dumping lists (0 services)
> Done.
> a@a-desktop:~$
>
> Regards
> David
>
>
>
> ------------------------------
>
> Message: 3
> Date: Thu, 07 Aug 2008 15:00:04 +0800
> From: Tim Farrington <timf@iinet.net.au>
> Subject: Re: [linux-dvb] [PATCH] Add initial support for DViCO
> 	FusionHDTV DVB-T Dual Express
> To: David <dvb-t@iinet.com.au>
> Cc: linux-dvb@linuxtv.org
> Message-ID: <489A9D74.5090501@iinet.net.au>
> Content-Type: text/plain; charset=us-ascii; format=flowed
>
> David wrote:
>> ----- Original Message -----
>> From: "Tim Farrington" <timf@iinet.net.au>
>> To: "David" <dvb-t@iinet.com.au>
>> Cc: <linux-dvb@linuxtv.org>
>> Sent: Thursday, August 07, 2008 2:34 PM
>> Subject: Re: [linux-dvb] [PATCH] Add initial support for DViCO  
>> FusionHDTV
>> DVB-T Dual Express
>>
>>
>>
>>> David wrote:
>>>
>>>> Hi Tim
>>>>
>>>> Thanks for information.
>>>>
>>>> I obtained the driver, extracted the firmware to lib/firmware and  
>>>> tried
>>>> to scan.
>>>> I cannot get a lock on anything.
>>>>
>>>> dmesg shows it is loading the firmware but nothing more:
>>>>
>>>> [  192.596627] xc2028 1-0061: Loading 3 firmware images from
>>>> xc3028-v27.fw, type: DViCO DualDig4/Nano2 (Australia), ver 2.7
>>>> [  192.796658] xc2028 1-0061: Loading firmware for type=BASE  
>>>> F8MHZ (3),
>>>> id 0000000000000000.
>>>> [  193.965865] xc2028 1-0061: Loading firmware for type=D2620  
>>>> DTV7 (88),
>>>> id 0000000000000000.
>>>> [  265.268818] xc2028 2-0061: Loading 3 firmware images from
>>>> xc3028-v27.fw, type: DViCO DualDig4/Nano2 (Australia), ver 2.7
>>>> [  265.468693] xc2028 2-0061: Loading firmware for type=BASE  
>>>> F8MHZ (3),
>>>> id 0000000000000000.
>>>> [  266.633170] xc2028 2-0061: Loading firmware for type=D2620  
>>>> DTV7 (88),
>>>> id 0000000000000000.
>>>>
>>>>
>>>> Regards
>>>> David
>>>>
>>>>
>>>>
>>>> ----- Original Message ----- From: "Tim Farrington" <timf@iinet.net.au 
>>>> >
>>>> To: "David Porter" <dvb-t@iinet.com.au>
>>>> Cc: <linux-dvb@linuxtv.org>
>>>> Sent: Wednesday, August 06, 2008 6:51 PM
>>>> Subject: Re: [linux-dvb] [PATCH] Add initial support for DViCO  
>>>> FusionHDTV
>>>> DVB-T Dual Express
>>>>
>>>>
>>>>
>>>>> David Porter wrote:
>>>>>
>>>>>> Hi
>>>>>>
>>>>>> I have one of these, saw Stevens post and thought i would give  
>>>>>> it a go.
>>>>>>
>>>>>> I built from : http://linuxtv.org/hg/~stoth/v4l-dvb
>>>>>> All seemed to go well with no errors.
>>>>>>
>>>>>> dmesg reads:
>>>>>>
>>>>>> [   31.964424] CORE cx23885[0]: subsystem: 18ac:db78, board:  
>>>>>> DViCO
>>>>>> FusionHDTV DVB-T Dual Express [card=11,autodetected]
>>>>>> [   32.104767] cx23885[0]: i2c bus 0 registered
>>>>>> [   32.104781] cx23885[0]: i2c bus 1 registered
>>>>>> [   32.104794] cx23885[0]: i2c bus 2 registered
>>>>>> [   32.164385] input: i2c IR (FusionHDTV) as
>>>>>> /devices/virtual/input/input8
>>>>>> [   32.422764] ir-kbd-i2c: i2c IR (FusionHDTV) detected at
>>>>>> i2c-1/1-006b/ir0 [cx23885[0]]
>>>>>> [   32.423135] cx23885[0]: cx23885 based dvb card
>>>>>> [   32.492021] xc2028 1-0061: creating new instance
>>>>>> [   32.492027] xc2028 1-0061: type set to XCeive xc2028/xc3028  
>>>>>> tuner
>>>>>> [   32.492036] DVB: registering new adapter (cx23885[0])
>>>>>> [   32.492040] DVB: registering frontend 0 (Zarlink ZL10353 DVB- 
>>>>>> T)...
>>>>>> [   32.492386] cx23885[0]: cx23885 based dvb card
>>>>>> [   32.492924] xc2028 2-0061: creating new instance
>>>>>> [   32.492926] xc2028 2-0061: type set to XCeive xc2028/xc3028  
>>>>>> tuner
>>>>>> [   32.492928] DVB: registering new adapter (cx23885[0])
>>>>>> [   32.492930] DVB: registering frontend 1 (Zarlink ZL10353 DVB- 
>>>>>> T)...
>>>>>> [   32.493228] cx23885_dev_checkrevision() Hardware revision =  
>>>>>> 0xb0
>>>>>> [   32.493236] cx23885[0]/0: found at 0000:02:00.0, rev: 2,  
>>>>>> irq: 16,
>>>>>> latency: 0, mmio: 0xfe800000
>>>>>>
>>>>>> But scanning, returns :
>>>>>>
>>>>>> [ 1381.214624] xc2028 1-0061: Error: firmware xc3028-v27.fw not  
>>>>>> found.
>>>>>> [ 1382.220858] xc2028 1-0061: Error: firmware xc3028-v27.fw not  
>>>>>> found.
>>>>>> [ 1382.260825] xc2028 1-0061: Error: firmware xc3028-v27.fw not  
>>>>>> found.
>>>>>> [ 1383.267724] xc2028 1-0061: Error: firmware xc3028-v27.fw not  
>>>>>> found.
>>>>>> [ 1383.276680] xc2028 1-0061: Error: firmware xc3028-v27.fw not  
>>>>>> found.
>>>>>>
>>>>>> I checked  /lib/firmware/ but xc3028-v27.fw is not in the  
>>>>>> directory ?
>>>>>>
>>>>>> Must have messed it up somewhere! Any help appreciated.
>>>>>>
>>>>>> Thanks
>>>>>> David
>>>>>>
>>>>>> ----- Original Message ----- From: "Steven Toth" <stoth@linuxtv.org 
>>>>>> >
>>>>>> To: "Luke Yelavich" <themuso@themuso.com>
>>>>>> Cc: <linux-dvb@linuxtv.org>
>>>>>> Sent: Wednesday, August 06, 2008 11:44 AM
>>>>>> Subject: Re: [linux-dvb] [PATCH] Add initial support for DViCO
>>>>>> FusionHDTV DVB-T Dual Express
>>>>>>
>>>>>>
>>>>>>
>>>>>>
>>>>>>>>>> I've tested with the HVR1500Q (xc5000 based) and I'm happy  
>>>>>>>>>> with the
>>>>>>>>>> results. Can you both try the DViCO board?
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>> It tests fine and I like how simpler things have got.
>>>>>>>>>
>>>>>>>>>
>>>>>>>> I pulled the above linked tree, and compiled the modules. It  
>>>>>>>> seems at
>>>>>>>> the moment for the dual express, that I have to pass the  
>>>>>>>> parameter
>>>>>>>> card=11 to the driver, for it to correctly find the card and  
>>>>>>>> make use
>>>>>>>> of all adapters. Without any module parameters, dmsg  
>>>>>>>> complains that
>>>>>>>> the card couldn't be identified, yet two adapters are shown.  
>>>>>>>> I have
>>>>>>>> two of these cards.
>>>>>>>>
>>>>>>>> Hope this helps some.
>>>>>>>>
>>>>>>>>
>>>>>>> .. And they're both the same model?
>>>>>>>
>>>>>>> If so, insert one at a time and run the 'lspci -vn' command,  
>>>>>>> save the
>>>>>>> output for each card.
>>>>>>>
>>>>>>> Post the output here.
>>>>>>>
>>>>>>> Assuming you load the driver with card=11, does each card work
>>>>>>> correctly
>>>>>>> after that?
>>>>>>>
>>>>>>> - Steve
>>>>>>>
>>>>>>> _______________________________________________
>>>>>>> linux-dvb mailing list
>>>>>>> linux-dvb@linuxtv.org
>>>>>>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>> _______________________________________________
>>>>>> linux-dvb mailing list
>>>>>> linux-dvb@linuxtv.org
>>>>>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>>>>>
>>>>>>
>>>>>>
>>>>> To obtain xc3028-v27.fw
>>>>>
>>>>> see ~/v4l-dvb/linux/Documentation/video4linux/extract_xc3028.pl
>>>>>
>>>>> Regards,
>>>>> Timf
>>>>>
>>> Try not to top post.
>>>
>>> Best to post the results of tzap here:
>>>
>>> In Ubuntu, Debian;
>>> sudo apt-get install dvb-utils
>>> (other distros use dvb-apps)
>>>
>>> Find the scan file appropriate for your area (au-*) in:
>>> /usr/share/doc/dvb-utils/examples/scan/dvb-t
>>>
>>> sudo -s -H
>>> mkdir /root/.tzap
>>> scan /usr/share/doc/dvb-utils/examples/scan/dvb-t/au-* >
>>> /root/.tzap/channels.conf
>>>
>>> Post the output of scan to this list.
>>>
>>> Regards,
>>> Timf
>>>
>>
>> Thanks, Tim
>> Doesn't look too promising :
>>
>> a@a-desktop:~$ scan /usr/share/doc/dvb-utils/examples/scan/dvb-t/au- 
>> Brisbane
>> scanning /usr/share/doc/dvb-utils/examples/scan/dvb-t/au-Brisbane
>> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>> initial transponder 226500000 1 3 9 3 1 1 0
>> initial transponder 177500000 1 2 9 3 1 2 0
>> initial transponder 191625000 1 3 9 3 1 1 0
>> initial transponder 219500000 1 3 9 3 1 1 0
>> initial transponder 585625000 1 2 9 3 1 2 0
>>
>>>>> tune to:
>>>>> 226500000 
>>>>> :INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
>>>>> :FEC_AUTO:QAM_64 
>>>>> :TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
>>>>>
>> WARNING: >>> tuning failed!!!
>>
>>>>> tune to:
>>>>> 226500000 
>>>>> :INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
>>>>> :FEC_AUTO:QAM_64 
>>>>> :TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
>>>>> (tuning failed)
>>>>>
>> WARNING: >>> tuning failed!!!
>>
>>>>> tune to:
>>>>> 177500000 
>>>>> :INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3 
>>>>> :FEC_AUTO:QAM_64 
>>>>> :TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE
>>>>>
>> WARNING: >>> tuning failed!!!
>>
>>>>> tune to:
>>>>> 177500000 
>>>>> :INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3 
>>>>> :FEC_AUTO:QAM_64 
>>>>> :TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE
>>>>> (tuning failed)
>>>>>
>> WARNING: >>> tuning failed!!!
>>
>>>>> tune to:
>>>>> 191625000 
>>>>> :INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
>>>>> :FEC_AUTO:QAM_64 
>>>>> :TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
>>>>>
>> WARNING: >>> tuning failed!!!
>>
>>>>> tune to:
>>>>> 191625000 
>>>>> :INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
>>>>> :FEC_AUTO:QAM_64 
>>>>> :TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
>>>>> (tuning failed)
>>>>>
>> WARNING: >>> tuning failed!!!
>>
>>>>> tune to:
>>>>> 219500000 
>>>>> :INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
>>>>> :FEC_AUTO:QAM_64 
>>>>> :TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
>>>>>
>> WARNING: >>> tuning failed!!!
>>
>>>>> tune to:
>>>>> 219500000 
>>>>> :INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
>>>>> :FEC_AUTO:QAM_64 
>>>>> :TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
>>>>> (tuning failed)
>>>>>
>> WARNING: >>> tuning failed!!!
>>
>>>>> tune to:
>>>>> 585625000 
>>>>> :INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3 
>>>>> :FEC_AUTO:QAM_64 
>>>>> :TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE
>>>>>
>> WARNING: >>> tuning failed!!!
>>
>>>>> tune to:
>>>>> 585625000 
>>>>> :INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3 
>>>>> :FEC_AUTO:QAM_64 
>>>>> :TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE
>>>>> (tuning failed)
>>>>>
>> WARNING: >>> tuning failed!!!
>> ERROR: initial tuning failed
>> dumping lists (0 services)
>> Done.
>> a@a-desktop:~$
>>
>> Regards
>> David
>>
>> _______________________________________________
>> linux-dvb mailing list
>> linux-dvb@linuxtv.org
>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>
>>
> Could be that the signal strength is too low.
> What are you using for an antenna?
> How does it go in Windows - any channels?
>
> Regards,
> Timf
>
>
>
> ------------------------------
>
> Message: 4
> Date: Thu, 7 Aug 2008 17:10:01 +1000
> From: "David" <dvb-t@iinet.com.au>
> Subject: Re: [linux-dvb] [PATCH] Add initial support for DViCO
> 	FusionHDTV	DVB-T Dual Express
> To: "Tim Farrington" <timf@iinet.net.au>
> Cc: linux-dvb@linuxtv.org
> Message-ID: <42DDE4283DB94F2580D473D5B1954CB5@mce>
> Content-Type: text/plain; format=flowed; charset="iso-8859-1";
> 	reply-type=response
>
>
> ----- Original Message -----
> From: "Tim Farrington" <timf@iinet.net.au>
> To: "David" <dvb-t@iinet.com.au>
> Cc: <linux-dvb@linuxtv.org>
> Sent: Thursday, August 07, 2008 5:00 PM
> Subject: Re: [linux-dvb] [PATCH] Add initial support for DViCO  
> FusionHDTV
> DVB-T Dual Express
>
>
>> David wrote:
>>> ----- Original Message -----
>>> From: "Tim Farrington" <timf@iinet.net.au>
>>> To: "David" <dvb-t@iinet.com.au>
>>> Cc: <linux-dvb@linuxtv.org>
>>> Sent: Thursday, August 07, 2008 2:34 PM
>>> Subject: Re: [linux-dvb] [PATCH] Add initial support for DViCO  
>>> FusionHDTV
>>> DVB-T Dual Express
>>>
>>>
>>>
>>>> David wrote:
>>>>
>>>>> Hi Tim
>>>>>
>>>>> Thanks for information.
>>>>>
>>>>> I obtained the driver, extracted the firmware to lib/firmware  
>>>>> and tried
>>>>> to scan.
>>>>> I cannot get a lock on anything.
>>>>>
>>>>> dmesg shows it is loading the firmware but nothing more:
>>>>>
>>>>> [  192.596627] xc2028 1-0061: Loading 3 firmware images from
>>>>> xc3028-v27.fw, type: DViCO DualDig4/Nano2 (Australia), ver 2.7
>>>>> [  192.796658] xc2028 1-0061: Loading firmware for type=BASE  
>>>>> F8MHZ (3),
>>>>> id 0000000000000000.
>>>>> [  193.965865] xc2028 1-0061: Loading firmware for type=D2620 DTV7
>>>>> (88), id 0000000000000000.
>>>>> [  265.268818] xc2028 2-0061: Loading 3 firmware images from
>>>>> xc3028-v27.fw, type: DViCO DualDig4/Nano2 (Australia), ver 2.7
>>>>> [  265.468693] xc2028 2-0061: Loading firmware for type=BASE  
>>>>> F8MHZ (3),
>>>>> id 0000000000000000.
>>>>> [  266.633170] xc2028 2-0061: Loading firmware for type=D2620 DTV7
>>>>> (88), id 0000000000000000.
>>>>>
>>>>>
>>>>> Regards
>>>>> David
>>>>>
>>>>>
>>>>>
>>>>> ----- Original Message ----- From: "Tim Farrington" <timf@iinet.net.au 
>>>>> >
>>>>> To: "David Porter" <dvb-t@iinet.com.au>
>>>>> Cc: <linux-dvb@linuxtv.org>
>>>>> Sent: Wednesday, August 06, 2008 6:51 PM
>>>>> Subject: Re: [linux-dvb] [PATCH] Add initial support for DViCO
>>>>> FusionHDTV DVB-T Dual Express
>>>>>
>>>>>
>>>>>
>>>>>> David Porter wrote:
>>>>>>
>>>>>>> Hi
>>>>>>>
>>>>>>> I have one of these, saw Stevens post and thought i would give  
>>>>>>> it a
>>>>>>> go.
>>>>>>>
>>>>>>> I built from : http://linuxtv.org/hg/~stoth/v4l-dvb
>>>>>>> All seemed to go well with no errors.
>>>>>>>
>>>>>>> dmesg reads:
>>>>>>>
>>>>>>> [   31.964424] CORE cx23885[0]: subsystem: 18ac:db78, board:  
>>>>>>> DViCO
>>>>>>> FusionHDTV DVB-T Dual Express [card=11,autodetected]
>>>>>>> [   32.104767] cx23885[0]: i2c bus 0 registered
>>>>>>> [   32.104781] cx23885[0]: i2c bus 1 registered
>>>>>>> [   32.104794] cx23885[0]: i2c bus 2 registered
>>>>>>> [   32.164385] input: i2c IR (FusionHDTV) as
>>>>>>> /devices/virtual/input/input8
>>>>>>> [   32.422764] ir-kbd-i2c: i2c IR (FusionHDTV) detected at
>>>>>>> i2c-1/1-006b/ir0 [cx23885[0]]
>>>>>>> [   32.423135] cx23885[0]: cx23885 based dvb card
>>>>>>> [   32.492021] xc2028 1-0061: creating new instance
>>>>>>> [   32.492027] xc2028 1-0061: type set to XCeive xc2028/xc3028  
>>>>>>> tuner
>>>>>>> [   32.492036] DVB: registering new adapter (cx23885[0])
>>>>>>> [   32.492040] DVB: registering frontend 0 (Zarlink ZL10353  
>>>>>>> DVB-T)...
>>>>>>> [   32.492386] cx23885[0]: cx23885 based dvb card
>>>>>>> [   32.492924] xc2028 2-0061: creating new instance
>>>>>>> [   32.492926] xc2028 2-0061: type set to XCeive xc2028/xc3028  
>>>>>>> tuner
>>>>>>> [   32.492928] DVB: registering new adapter (cx23885[0])
>>>>>>> [   32.492930] DVB: registering frontend 1 (Zarlink ZL10353  
>>>>>>> DVB-T)...
>>>>>>> [   32.493228] cx23885_dev_checkrevision() Hardware revision =  
>>>>>>> 0xb0
>>>>>>> [   32.493236] cx23885[0]/0: found at 0000:02:00.0, rev: 2,  
>>>>>>> irq: 16,
>>>>>>> latency: 0, mmio: 0xfe800000
>>>>>>>
>>>>>>> But scanning, returns :
>>>>>>>
>>>>>>> [ 1381.214624] xc2028 1-0061: Error: firmware xc3028-v27.fw not
>>>>>>> found.
>>>>>>> [ 1382.220858] xc2028 1-0061: Error: firmware xc3028-v27.fw not
>>>>>>> found.
>>>>>>> [ 1382.260825] xc2028 1-0061: Error: firmware xc3028-v27.fw not
>>>>>>> found.
>>>>>>> [ 1383.267724] xc2028 1-0061: Error: firmware xc3028-v27.fw not
>>>>>>> found.
>>>>>>> [ 1383.276680] xc2028 1-0061: Error: firmware xc3028-v27.fw not
>>>>>>> found.
>>>>>>>
>>>>>>> I checked  /lib/firmware/ but xc3028-v27.fw is not in the  
>>>>>>> directory ?
>>>>>>>
>>>>>>> Must have messed it up somewhere! Any help appreciated.
>>>>>>>
>>>>>>> Thanks
>>>>>>> David
>>>>>>>
>>>>>>> ----- Original Message ----- From: "Steven Toth" <stoth@linuxtv.org 
>>>>>>> >
>>>>>>> To: "Luke Yelavich" <themuso@themuso.com>
>>>>>>> Cc: <linux-dvb@linuxtv.org>
>>>>>>> Sent: Wednesday, August 06, 2008 11:44 AM
>>>>>>> Subject: Re: [linux-dvb] [PATCH] Add initial support for DViCO
>>>>>>> FusionHDTV DVB-T Dual Express
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>>>>>> I've tested with the HVR1500Q (xc5000 based) and I'm happy  
>>>>>>>>>>> with
>>>>>>>>>>> the
>>>>>>>>>>> results. Can you both try the DViCO board?
>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>> It tests fine and I like how simpler things have got.
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>> I pulled the above linked tree, and compiled the modules. It  
>>>>>>>>> seems
>>>>>>>>> at the moment for the dual express, that I have to pass the
>>>>>>>>> parameter card=11 to the driver, for it to correctly find  
>>>>>>>>> the card
>>>>>>>>> and make use of all adapters. Without any module parameters,  
>>>>>>>>> dmsg
>>>>>>>>> complains that the card couldn't be identified, yet two  
>>>>>>>>> adapters
>>>>>>>>> are shown. I have two of these cards.
>>>>>>>>>
>>>>>>>>> Hope this helps some.
>>>>>>>>>
>>>>>>>>>
>>>>>>>> .. And they're both the same model?
>>>>>>>>
>>>>>>>> If so, insert one at a time and run the 'lspci -vn' command,  
>>>>>>>> save
>>>>>>>> the
>>>>>>>> output for each card.
>>>>>>>>
>>>>>>>> Post the output here.
>>>>>>>>
>>>>>>>> Assuming you load the driver with card=11, does each card work
>>>>>>>> correctly
>>>>>>>> after that?
>>>>>>>>
>>>>>>>> - Steve
>>>>>>>>
>>>>>>>> _______________________________________________
>>>>>>>> linux-dvb mailing list
>>>>>>>> linux-dvb@linuxtv.org
>>>>>>>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>> _______________________________________________
>>>>>>> linux-dvb mailing list
>>>>>>> linux-dvb@linuxtv.org
>>>>>>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>> To obtain xc3028-v27.fw
>>>>>>
>>>>>> see ~/v4l-dvb/linux/Documentation/video4linux/extract_xc3028.pl
>>>>>>
>>>>>> Regards,
>>>>>> Timf
>>>>>>
>>>> Try not to top post.
>>>>
>>>> Best to post the results of tzap here:
>>>>
>>>> In Ubuntu, Debian;
>>>> sudo apt-get install dvb-utils
>>>> (other distros use dvb-apps)
>>>>
>>>> Find the scan file appropriate for your area (au-*) in:
>>>> /usr/share/doc/dvb-utils/examples/scan/dvb-t
>>>>
>>>> sudo -s -H
>>>> mkdir /root/.tzap
>>>> scan /usr/share/doc/dvb-utils/examples/scan/dvb-t/au-* >
>>>> /root/.tzap/channels.conf
>>>>
>>>> Post the output of scan to this list.
>>>>
>>>> Regards,
>>>> Timf
>>>>
>>>
>>> Thanks, Tim
>>> Doesn't look too promising :
>>>
>>> a@a-desktop:~$ scan
>>> /usr/share/doc/dvb-utils/examples/scan/dvb-t/au-Brisbane
>>> scanning /usr/share/doc/dvb-utils/examples/scan/dvb-t/au-Brisbane
>>> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>>> initial transponder 226500000 1 3 9 3 1 1 0
>>> initial transponder 177500000 1 2 9 3 1 2 0
>>> initial transponder 191625000 1 3 9 3 1 1 0
>>> initial transponder 219500000 1 3 9 3 1 1 0
>>> initial transponder 585625000 1 2 9 3 1 2 0
>>>
>>>>>> tune to:
>>>>>> 226500000 
>>>>>> :INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
>>>>>> :FEC_AUTO:QAM_64 
>>>>>> :TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
>>>>>>
>>> WARNING: >>> tuning failed!!!
>>>
>>>>>> tune to:
>>>>>> 226500000 
>>>>>> :INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
>>>>>> :FEC_AUTO:QAM_64 
>>>>>> :TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
>>>>>> (tuning failed)
>>>>>>
>>> WARNING: >>> tuning failed!!!
>>>
>>>>>> tune to:
>>>>>> 177500000 
>>>>>> :INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3 
>>>>>> :FEC_AUTO:QAM_64 
>>>>>> :TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE
>>>>>>
>>> WARNING: >>> tuning failed!!!
>>>
>>>>>> tune to:
>>>>>> 177500000 
>>>>>> :INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3 
>>>>>> :FEC_AUTO:QAM_64 
>>>>>> :TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE
>>>>>> (tuning failed)
>>>>>>
>>> WARNING: >>> tuning failed!!!
>>>
>>>>>> tune to:
>>>>>> 191625000 
>>>>>> :INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
>>>>>> :FEC_AUTO:QAM_64 
>>>>>> :TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
>>>>>>
>>> WARNING: >>> tuning failed!!!
>>>
>>>>>> tune to:
>>>>>> 191625000 
>>>>>> :INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
>>>>>> :FEC_AUTO:QAM_64 
>>>>>> :TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
>>>>>> (tuning failed)
>>>>>>
>>> WARNING: >>> tuning failed!!!
>>>
>>>>>> tune to:
>>>>>> 219500000 
>>>>>> :INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
>>>>>> :FEC_AUTO:QAM_64 
>>>>>> :TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
>>>>>>
>>> WARNING: >>> tuning failed!!!
>>>
>>>>>> tune to:
>>>>>> 219500000 
>>>>>> :INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
>>>>>> :FEC_AUTO:QAM_64 
>>>>>> :TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
>>>>>> (tuning failed)
>>>>>>
>>> WARNING: >>> tuning failed!!!
>>>
>>>>>> tune to:
>>>>>> 585625000 
>>>>>> :INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3 
>>>>>> :FEC_AUTO:QAM_64 
>>>>>> :TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE
>>>>>>
>>> WARNING: >>> tuning failed!!!
>>>
>>>>>> tune to:
>>>>>> 585625000 
>>>>>> :INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3 
>>>>>> :FEC_AUTO:QAM_64 
>>>>>> :TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE
>>>>>> (tuning failed)
>>>>>>
>>> WARNING: >>> tuning failed!!!
>>> ERROR: initial tuning failed
>>> dumping lists (0 services)
>>> Done.
>>> a@a-desktop:~$
>>>
>>> Regards
>>> David
>>>
>>> _______________________________________________
>>> linux-dvb mailing list
>>> linux-dvb@linuxtv.org
>>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>>
>>>
>> Could be that the signal strength is too low.
>> What are you using for an antenna?
>> How does it go in Windows - any channels?
>>
>> Regards,
>> Timf
>
> It's in a dual boot system with Vista Home Premium and is connected  
> to a
> good external antenna.
> The signal strength is > 70% and I have very good results in Vista.
>
> I had a couple of Winfast Dongle Gold Tuners on a different drive in  
> the
> same box running Ubuntu 8.04 / MythTV and they performed flawlessly.
>
> I think it has to be an error somewhere in the way I built the driver.
>
> Regards
> David
>
>
>
> ------------------------------
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
> End of linux-dvb Digest, Vol 43, Issue 32
> *****************************************


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
