Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from mail10.syd.optusnet.com.au ([211.29.132.191])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <russell@kliese.wattle.id.au>) id 1JNH22-0003OJ-Mx
	for linux-dvb@linuxtv.org; Fri, 08 Feb 2008 01:23:55 +0100
Received: from [192.168.0.4] (c220-239-70-96.rochd3.qld.optusnet.com.au
	[220.239.70.96]) (authenticated sender russell.kliese)
	by mail10.syd.optusnet.com.au (8.13.1/8.13.1) with ESMTP id
	m180Nk0F030157
	for <linux-dvb@linuxtv.org>; Fri, 8 Feb 2008 11:23:48 +1100
Message-ID: <47ABA2B8.8000004@kliese.wattle.id.au>
Date: Fri, 08 Feb 2008 10:30:48 +1000
From: Russell Kliese <russell@kliese.wattle.id.au>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <47AB0A20.2020000@kliese.wattle.id.au>	<200802071443.17432.Nicola.Sabbi@poste.it>
	<47AB1705.7020905@kliese.wattle.id.au>
	<47AB7844.5040706@t-online.de>
In-Reply-To: <47AB7844.5040706@t-online.de>
Subject: Re: [linux-dvb] MSI TV@nywhere A/D v1.1 mostly working
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hartmut Hackmann wrote:
> Hi, all
>
> Russell Kliese schrieb:
>   
>> Nico Sabbi wrote:
>>     
>>> On Thursday 07 February 2008 14:39:44 Russell Kliese wrote:
>>>
>>>   
>>>       
>>>> Analog TV worked without a problem (even with the older drivers).
>>>>
>>>> There is still a problem with the digital decoder. Sometimes it
>>>> works fine (I can scan for channels and can run tzap to view a
>>>> channel using mplayer). However, sometimes these commands don't
>>>> work. I've noticed the following when running dmesg:
>>>>
>>>>
>>>> [ 6318.055521] tda1004x: found firmware revision 20 -- ok
>>>>
>>>> I suspect that the card is failing to work because the firmware
>>>> sometimes isn't being uploaded for some reason. Does anybody have
>>>> any ideas why or what I could do to try and fix this?
>>>>
>>>> Hopefully this problem can be sorted out and another card can be
>>>> added to the list of supported DVB-T cards. Yay!
>>>>     
>>>>         
>>> afaik the last fw for the 10046 demodulator is version 29, that
>>> you can extract from the lifeview drivers
>>>   
>>>       
>> Thanks for pointing that out. I grabbed the version 29 firmware using 
>> get_dvb_firmware tda10046lifeview and copied this into the appropriate 
>> place. However, I'm still having the same sort of problem:
>>
>> [ 2095.281620] tda1004x: timeout waiting for DSP ready
>> [ 2095.321600] tda1004x: found firmware revision 0 -- invalid
>> [ 2095.321614] tda1004x: trying to boot from eeprom
>> [ 2097.648360] tda1004x: timeout waiting for DSP ready
>> [ 2097.688338] tda1004x: found firmware revision 0 -- invalid
>> [ 2097.688346] tda1004x: waiting for firmware upload...
>> [ 2110.173699] tda1004x: found firmware revision 29 -- ok
>> [ 2121.531804] tda1004x: setting up plls for 48MHz sampling clock
>> [ 2121.727550] tda1004x: found firmware revision 29 -- ok
>> [ 2513.011736] tda1004x: setting up plls for 48MHz sampling clock
>> [ 2513.199286] tda1004x: found firmware revision 33 -- invalid
>> [ 2513.199294] tda1004x: trying to boot from eeprom
>> [ 2513.567098] tda1004x: found firmware revision 33 -- invalid
>> [ 2513.567110] tda1004x: waiting for firmware upload...
>> [ 2526.044456] tda1004x: found firmware revision 33 -- invalid
>> [ 2526.044469] tda1004x: firmware upload failed
>> [ 2534.743826] tda1004x: setting up plls for 48MHz sampling clock
>> [ 2534.885955] tda1004x: found firmware revision ff -- invalid
>> [ 2534.885968] tda1004x: trying to boot from eeprom
>> [ 2535.211575] tda1004x: found firmware revision 0 -- invalid
>> [ 2535.211582] tda1004x: waiting for firmware upload...
>> [ 2535.217254] tda1004x: Error during firmware upload
>> [ 2535.224898] tda1004x: found firmware revision ff -- invalid
>> [ 2535.224911] tda1004x: firmware upload failed
>>
>> Cheers,
>>
>> Russell
>>
>>     
> This is not only a question of the firmware revision.
> Many cards have an eeprom with the firmware on the board. The TDA10046
> automatically tries to boot from this. The eeprom address is controlled
> with a GPIO pin. IF this pin changes while the chip boots, it will crash
> and possibly not recover. This entrie mechanism is hard to control.
> The card specific configuration structures tda1004x_config in saa7134-dvb.c
> have a entry .gpio_config. Please change this to TDA10046_GP01_I or try
> card type 81.
>   

The symptoms I'm having of unreliable firmware loading sounds like it
could indeed be caused by GPIO pins changing during operation of the
card and affecting subsequent firmware loads.

I tried setting .gpio_config to DA10046_GP01_I (the default for
card=109), DA10046_GP00_I and DA10046_GP11_I. None of these solved the
problem. I also tried card=81, but this didn't help either.

Are there any other configuration options that could be affecting the
reliable upload or loading of firmware?

Cheers,

Russell


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
