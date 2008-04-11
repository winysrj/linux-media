Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mailout02.t-online.de ([194.25.134.17])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hartmut.hackmann@t-online.de>) id 1JkQim-0004ev-3B
	for linux-dvb@linuxtv.org; Fri, 11 Apr 2008 23:23:45 +0200
Message-ID: <47FFD6DB.6060908@t-online.de>
Date: Fri, 11 Apr 2008 23:23:39 +0200
From: Hartmut Hackmann <hartmut.hackmann@t-online.de>
MIME-Version: 1.0
To: hermann pitton <hermann-pitton@arcor.de>
References: <47FE3ECC.8020209@iinet.net.au> <47FE8FD1.3050004@t-online.de>
	<1207870241.17744.8.camel@pc08.localdom.local>
In-Reply-To: <1207870241.17744.8.camel@pc08.localdom.local>
Cc: linux-dvb@linuxtv.org
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

Hi, Hermann

hermann pitton schrieb:
> Am Freitag, den 11.04.2008, 00:08 +0200 schrieb Hartmut Hackmann:
>> HI, Tim
>>
>> timf schrieb:
>>> Hi Hartmut,
>>> OK, found some more spare time, but very, very frustrated!
>>>
>>> 1) Tried ubuntu 7.04, 7.10, 8.04
>>>     Tried with just modules that exist in kernel (no v4l-dvb)
>>>    Tried v4l-dvb from June 2007 and tried current v4l-dvb
>>>    Tried with/without Hartmut patch - changeset 7376    49ba58715fe0
>>>    Tried with .gpio_config   = TDA10046_GP11_I, or .gpio_config   = 
>>> TDA10046_GP01_I,
>>>    Tried using configs in saa7134-dvb.c matching tiger, tiger_s, 
>>> pinnacle 310i, twinhan 3056
>>>
>>>     # Australia / Perth (Roleystone transmitter)
>>>     # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
>>>     # SBS
>>>     T 704500000 7MHz 2/3 NONE QAM64 8k 1/8 NONE
>>>     # ABC
>>>     T 725500000 7MHz 3/4 NONE QAM64 8k 1/16 NONE
>>>     # Seven
>>>     T 746500000 7MHz 2/3 NONE QAM64 8k 1/16 NONE
>>>     # Nine
>>>     T 767500000 7MHz 3/4 NONE QAM64 8k 1/16 NONE
>>>     # Ten
>>>     T 788500000 7MHz 3/4 NONE QAM64 8k 1/16 NONE
>>>
>>> 2) I have these saa7134 cards:
>>>     - pinnacle 310i
>>>     - kworld 210
>>>
>>>     This cx88 card:
>>>     - dvico DVB-T Pro hybrid (analog tv not work)
>>>
>>> -   problem only occurs with kworld 210 in linux (works fine in WinXP)
>>>
>>> 3) In WinXP, all channels, both analog tv and dvb-t found
>>>
>>> 4) In linux, if start dvb-t first, never scans SBS - dmesg1
>>>
>>> 5) In linux, if start analog tv first, stop, then start dvb-t, scan 
>>> finds SBS - dmesg2
>>>
>> a) The pinnacle 310i finds everything?
>>     It has the same chipset, but an almost perfectly handled tuner chip...
>>     This means that your initial config file is ok...
>> b) Does this mean that in case 4, all other channels are found?
>> c) Case 5: This finds everything?
>> d) What happens if you use the scan data of the pinnacle card?
>>     Does it tune SBS? Does it just take more time to stabilize?
>>     This can be understood.
>> e) Just to be sure: did you clarify the open point with .antenna_switch
>>     (i think so)
>> f) the kernel logs are as expected.
>> <snip>
>>
>>
>>> 6) Herman mentioned something called a "mode-switch" in the archives, 
>>> but not any description.
>> I guess he meant the switching between analog, radio and dvb-t. This is the
>> GPIO handling and card depending.
> 
> Tim must have it from when I mentioned the special case of card=87 and
> 94.
> 
>>> I tried to find some data sheets for tda8275 tda8290 but only found the 
>>> publicity pdf file from Phillips,
>>> so at least I can see they go together, so I presume this "mode-switch" 
>>> is coded into those modules.
>>> But those modules work for all other cards, so now I'm lost again.
>>>
>>> What else should I try?
>>>
>> If my assumptions above are wrong, there is one other chance:
>> Recently i saw another card that does the (unusual) mode switching
>> like card 87. So to be sure, you might try to force this card type (be
>> aware of the antenna inputs, if in doubt, try both.
>>
>> Best regards
>>    Hartmut
>>
> 
> For the Medion8800 Quad and CTX948 also showing this issue, needs to
> tune analog first to have good recepton on DVB-T, they are a little
> weaker on analog than other cards, but after that on DVB-T, they are as
> good than known good others.
> 
> Cheers,
> Hermann
> 

Is this problem still there with the recent v4l-dvb code?
I found a problem with the GPIO initialization and fixed
this in patch 49ba58715fe0 3 weeks ago (The gpiomask was
not set until analog tuning occured).

Best regards
   Hartmut

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
