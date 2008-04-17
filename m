Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mailout11.t-online.de ([194.25.134.85])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hartmut.hackmann@t-online.de>) id 1JmaWB-0001TC-Tg
	for linux-dvb@linuxtv.org; Thu, 17 Apr 2008 22:15:40 +0200
Message-ID: <4807AFE2.40400@t-online.de>
Date: Thu, 17 Apr 2008 22:15:30 +0200
From: Hartmut Hackmann <hartmut.hackmann@t-online.de>
MIME-Version: 1.0
To: Stephen Dawkins <elfarto@elfarto.com>
References: <1160.81.96.162.238.1208023139.squirrel@webmail.elfarto.com>
	<200804130349.15215@orion.escape-edv.de>	<4801DED3.4020804@elfarto.com>
	<4803C2FA.1010408@hot.ee> <48065CB6.50709@elfarto.com>
	<1208422406.12385.295.camel@rommel.snap.tv>
	<34260.217.8.27.117.1208427888.squirrel@webmail.elfarto.com>
In-Reply-To: <34260.217.8.27.117.1208427888.squirrel@webmail.elfarto.com>
Cc: linux-dvb@linuxtv.org, Arthur Konovalov <kasjas@hot.ee>
Subject: Re: [linux-dvb] TT-Budget C-1501
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

Hi,

Sorry folks, i did not immedeately notice that you asked me...

Stephen Dawkins schrieb:
> Hi
> 
>> Hi,
>>
>> I have also added support for this card based on the little change you
>> showed here and some looking around in other drivers. I have gotten
>> information from technotrend that the proper i2c address for the tuner
>> is 0x61 (or 0xc2 as these adresses sometimes appear shifted for some
>> reason). With this address and the tuner driver loaded in debug mode I
>> seem to get some more response from the tuner, but still no lock.
>>
> 
> Yes, I notice this last night. The demod is on 0x0c (altho I was told
> 0x18, which is 0x0c shift left 1 position) and the tuner is on 0x61 (which
> is 0xc2 shift left 1 pos).
> 
Jep, this is inconsistent all over the planet. The i2c address is 8 bits,
the read / write flag is the LSB. So it depends on whether you count this as
an address bit...

>> Now looking at the tda827x.c sources it seems this driver was
>> specifically written for dvb-t usage, and I'm uncertain wether it would
>> work out of the box for dvb-c. There are also some parts of the code I
>> don't understand, for instance the agcf callback. Harmut, do you know
>> anything more about this? The AGC2 gain value that is printed in debug
>> usually show 4 or 5 now, does this indicate a good signal or a bad
>> signal?
>>

You should be ok with the dvb-t tuning code. An AGC2 gain value of 4 is
perfect.

> 
> This is exactly what I am getting at the moment.
> 
>> Also there is still the occational i2c timeouts that Stephen reported.
> 
> I'm still seeing these.
> 
> Regards
> Stephen
> 
>> I'm not sure wether they are caused by the tuner or the demod, but they
>> appear to come so seldom that it should be able to complete a tuning
>> cycle. Any feedback on this would be welcome as well. Maybe Oliver has
>> some suggestions how to debug this?
>>
>> Best regards
>>
>> Sigmund Augdal
>>
>> ons, 16.04.2008 kl. 21.08 +0100, skrev Stephen Dawkins:
>>> Arthur Konovalov wrote:
>>>> Stephen Dawkins wrote:
>>>>
>>>>>>> I'm not entirely sure what I need todo next to get it working, any
>>> help
>>>>>>> will be greatly appreciated.
>>>>>> See m920x.c or saa7134-dvb.c for drivers using tda10046 and/or
>>> tda827x.
>>>>> I will take a look at them.
>>>>>
>>>> Hi,
>>>> do You have progress in that direction?
>>>> I'll very concerned, because I have this card too.
>>>>
>>>> Arthur
>>>>
>>> Not yet I'm afraid.
>>>
>>> Regards
>>> Stephen
>>>
I did not follow the thread yet. Which channel demodulator are you talking
about?

BTW: You need to be careful to not mix up the a- and non-a versions of
the tuner. They are *not* software compatible.

Best regards
   Hartmut

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
