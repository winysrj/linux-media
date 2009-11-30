Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f215.google.com ([209.85.219.215]:38479 "EHLO
	mail-ew0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbZK3Fbq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Nov 2009 00:31:46 -0500
Received: by ewy7 with SMTP id 7so4085016ewy.28
        for <linux-media@vger.kernel.org>; Sun, 29 Nov 2009 21:31:51 -0800 (PST)
Message-ID: <4B1358C4.2010509@gmail.com>
Date: Mon, 30 Nov 2009 06:31:48 +0100
From: "tomlohave@gmail.com" <tomlohave@gmail.com>
MIME-Version: 1.0
To: hermann pitton <hermann-pitton@arcor.de>
CC: linux-media@vger.kernel.org, jpnews13@free.fr
Subject: Re: saa7134  (not very) new board 5168:0307
References: <4B03F15D.1090907@gmail.com>	 <1258585719.3275.14.camel@pc07.localdom.local> <4B1101B0.5010008@gmail.com> <1259543353.4436.21.camel@pc07.localdom.local>
In-Reply-To: <1259543353.4436.21.camel@pc07.localdom.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hermann pitton a écrit :
>>>
>>>       
>
> Hi Thomas,
>    
>   
>> Hi  Hermann,
>> thanks for informations ...
>> This card is not mine so physically inspect it is not possible and the 
>> owner is at 700 kms from me...
>> However, it seems there is only one hybrid tuner. The card is referenced as
>> AR307 rev N (seen on photos) and i found a link about this card :
>> http://www.pchub.com/uph/model/0--13652-1/LR307-parts.html
>>     
>
> yes, if another one is not at the backisde, under the huge shielding of
> the frontside is only one.
>
>   
>> searching on LR307, i found a previous mail where you talked about a 
>> LR307- rev q
>> http://osdir.com/ml/linux-media/2009-09/msg00744.html
>>     
>
> The bttv-gallery.de has a LR307 Revision Q too. It has an extra sticker
> for some LNA version on it. Also gpio init and eeprom data differ.
>
>   
>> I modified a little the patch found in this mail (subvendor) and i have 
>> partial result :
>> - dvb tune work partially, not all channels are found
>> - dvb  channel in kaffeine works (image and sound) for few seconds and 
>> then nothing
>>     
>
> Then at least some little progress with antenna_config = 2 and gpio 21
> high for RF routing for DVB it seems.
>
>   
>> - nothing for analogic stations
>>     
>
> That's a little strange somehow, since if only one RF connector and no
> radio, RF for analog should come through as well, because gpio 21 was
> high in that test patch for analog TV too.
>
> Maybe some unknown LNA circuitry.
>
>   
>> with others cards like 81,104,105 and 109, same results, kaffeine works 
>> and then hangs
>>     
>
> With the HVR1110 you have a card with LNA config = 1 there, known issues
> with that on some Pinnacle 310i, a older setup did exist. 
>
>   
>> What do you want to help this card to be supported ?
>>     
>
> Hard to say, but since the hvr1110 does not have the antenna_switch = 2
> and the RF input routing, you also did not really test &tda827x_cfg_1
> yet.
>
> Might be worth a try.
>
> Cheers,
> Hermann
>
>
>   
>> Thanks in advance
>>
>> Cheers,
>>
>> Thomas
>>
>>
>>     
>
>
>   
Hi Hermann,

We will try what you suggest.

2 things :

- when kaffeine hangs , the owner try the analogic part with kdetv , no 
results,
but after that, trying  kaffeine, dvb works for another few seconds and 
so on ...

-we replace tda10046.fw by tda10046livefiew and before rev in log was 20 
with 3 attempts, after, rev 23 at the first time


Will post dmesg with gpio-tracking

Cheers,

Thomas
