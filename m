Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <timf@iinet.net.au>) id 1KQekW-0002cl-B6
	for linux-dvb@linuxtv.org; Wed, 06 Aug 2008 10:52:06 +0200
Message-ID: <48996623.4010703@iinet.net.au>
Date: Wed, 06 Aug 2008 16:51:47 +0800
From: Tim Farrington <timf@iinet.net.au>
MIME-Version: 1.0
To: David Porter <dvb-t@iinet.com.au>
References: <20080801034025.C0EC947808F@ws1-5.us4.outblaze.com><4897AC24.3040006@linuxtv.org>	<20080805214339.GA7314@kryten><20080805234129.GD11008@brainz.yelavich.home>	<4899020C.50000@linuxtv.org>
	<41A3723BDBA947399F2CBD960E4AFB94@mce>
In-Reply-To: <41A3723BDBA947399F2CBD960E4AFB94@mce>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] Add initial support for DViCO FusionHDTV
 DVB-T Dual Express
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

David Porter wrote:
> Hi
>
> I have one of these, saw Stevens post and thought i would give it a go.
>
> I built from : http://linuxtv.org/hg/~stoth/v4l-dvb
> All seemed to go well with no errors.
>
> dmesg reads:
>
> [   31.964424] CORE cx23885[0]: subsystem: 18ac:db78, board: DViCO 
> FusionHDTV DVB-T Dual Express [card=11,autodetected]
> [   32.104767] cx23885[0]: i2c bus 0 registered
> [   32.104781] cx23885[0]: i2c bus 1 registered
> [   32.104794] cx23885[0]: i2c bus 2 registered
> [   32.164385] input: i2c IR (FusionHDTV) as /devices/virtual/input/input8
> [   32.422764] ir-kbd-i2c: i2c IR (FusionHDTV) detected at i2c-1/1-006b/ir0 
> [cx23885[0]]
> [   32.423135] cx23885[0]: cx23885 based dvb card
> [   32.492021] xc2028 1-0061: creating new instance
> [   32.492027] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
> [   32.492036] DVB: registering new adapter (cx23885[0])
> [   32.492040] DVB: registering frontend 0 (Zarlink ZL10353 DVB-T)...
> [   32.492386] cx23885[0]: cx23885 based dvb card
> [   32.492924] xc2028 2-0061: creating new instance
> [   32.492926] xc2028 2-0061: type set to XCeive xc2028/xc3028 tuner
> [   32.492928] DVB: registering new adapter (cx23885[0])
> [   32.492930] DVB: registering frontend 1 (Zarlink ZL10353 DVB-T)...
> [   32.493228] cx23885_dev_checkrevision() Hardware revision = 0xb0
> [   32.493236] cx23885[0]/0: found at 0000:02:00.0, rev: 2, irq: 16, 
> latency: 0, mmio: 0xfe800000
>
> But scanning, returns :
>
> [ 1381.214624] xc2028 1-0061: Error: firmware xc3028-v27.fw not found.
> [ 1382.220858] xc2028 1-0061: Error: firmware xc3028-v27.fw not found.
> [ 1382.260825] xc2028 1-0061: Error: firmware xc3028-v27.fw not found.
> [ 1383.267724] xc2028 1-0061: Error: firmware xc3028-v27.fw not found.
> [ 1383.276680] xc2028 1-0061: Error: firmware xc3028-v27.fw not found.
>
> I checked  /lib/firmware/ but xc3028-v27.fw is not in the directory ?
>
> Must have messed it up somewhere! Any help appreciated.
>
> Thanks
> David
>
> ----- Original Message ----- 
> From: "Steven Toth" <stoth@linuxtv.org>
> To: "Luke Yelavich" <themuso@themuso.com>
> Cc: <linux-dvb@linuxtv.org>
> Sent: Wednesday, August 06, 2008 11:44 AM
> Subject: Re: [linux-dvb] [PATCH] Add initial support for DViCO FusionHDTV 
> DVB-T Dual Express
>
>
>   
>>>>> I've tested with the HVR1500Q (xc5000 based) and I'm happy with the
>>>>> results. Can you both try the DViCO board?
>>>>>           
>>>> It tests fine and I like how simpler things have got.
>>>>         
>>> I pulled the above linked tree, and compiled the modules. It seems at the 
>>> moment for the dual express, that I have to pass the parameter card=11 to 
>>> the driver, for it to correctly find the card and make use of all 
>>> adapters. Without any module parameters, dmsg complains that the card 
>>> couldn't be identified, yet two adapters are shown. I have two of these 
>>> cards.
>>>
>>> Hope this helps some.
>>>       
>> .. And they're both the same model?
>>
>> If so, insert one at a time and run the 'lspci -vn' command, save the
>> output for each card.
>>
>> Post the output here.
>>
>> Assuming you load the driver with card=11, does each card work correctly
>> after that?
>>
>> - Steve
>>
>> _______________________________________________
>> linux-dvb mailing list
>> linux-dvb@linuxtv.org
>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>
>>     
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
>   

To obtain xc3028-v27.fw

see ~/v4l-dvb/linux/Documentation/video4linux/extract_xc3028.pl

Regards,
Timf

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
