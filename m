Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.domeneshop.no ([194.63.248.54]:51699 "EHLO
	smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905Ab0CBTWH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Mar 2010 14:22:07 -0500
Message-ID: <4B8D6270.70803@online.no>
Date: Tue, 02 Mar 2010 20:09:36 +0100
From: Hendrik Skarpeid <skarp@online.no>
MIME-Version: 1.0
To: "Igor M. Liplianin" <liplianin@me.by>
CC: Nameer Kazzaz <nameer.kazzaz@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: DM1105: could not attach frontend 195d:1105
References: <4B7D83B2.4030709@online.no> <4B83C6C0.5020708@online.no> <4B83D425.6060803@gmail.com> <201002231940.13385.liplianin@me.by>
In-Reply-To: <201002231940.13385.liplianin@me.by>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Igor M. Liplianin skrev:
> On 23 февраля 2010 15:12:05 Nameer Kazzaz wrote:
>   
>> Sounds cool, let me know if I can help you with anything.
>>
>> Thanks
>> Nameer
>>
>> Hendrik Skarpeid wrote:
>>     
>>> No luck here either, still working on it.
>>> My plan is to solder som wires on strategic points on the board and
>>> debug i2c and other activity with an oscilloscope. Will probably start
>>> next week.
>>>
>>> Nameer Kazzaz wrote:
>>>       
>>>> Hey Igor,
>>>> I'm getting the same error:
>>>> dm1105 0000:04:0b.0: could not attach frontend
>>>>
>>>> Did you get your one to work.
>>>>
>>>> Thanks
>>>> Nameer
>>>>
>>>> Igor M. Liplianin wrote:
>>>>         
>>>>> On 18 февраля 2010, liplianin@me.by wrote:
>>>>>           
>>>>>> I also got the unbranded dm1105 card. I tried the four possible i2c
>>>>>> addresses, just i case. Noen worked of course. Then I traced the i2c
>>>>>> pins on the tuner to pins 100 and 101 on the DM1105.
>>>>>> These are GPIO pins, so bit-banging i2c on these pins seems to be the
>>>>>> solution.
>>>>>>
>>>>>> scl = p101 = gpio14
>>>>>> sda = p100 = gpio13
>>>>>>             
>>>>> Here is the patch to test. Use option card=4.
>>>>>     modprobe dm1105 card=4
>>>>>           
> I didn't test patch in real hardware.
> But I can connect GPIO14 and GPIO13 to SCL and SDA in any dm1105 card and test whether it works.
> Then I will ask you to test also.
>
>   
> ------------------------------------------------------------------------
>
>
> No virus found in this incoming message.
> Checked by AVG - www.avg.com 
> Version: 9.0.733 / Virus Database: 271.1.1/2708 - Release Date: 02/24/10 20:34:00
>
>   

Think I solved it.
The dm1105_getsda and dm1105_getscl functions need to mask out the other 
GPIO bits.
I hacked the code to return 1 if corresponding GPIO set, and 0 if not 
set. That did the trick. Now the frontend registers and /dev/dvb is 
populated. :)
Haven't done any tuning yet.
