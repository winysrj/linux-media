Return-path: <linux-media-owner@vger.kernel.org>
Received: from vip1scan.telenor.net ([148.123.15.75]:47387 "EHLO sv07.e.nsc.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752764Ab0CaLBD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Mar 2010 07:01:03 -0400
Message-ID: <4BB32826.8060103@skarpeid.com>
Date: Wed, 31 Mar 2010 12:47:02 +0200
From: Hendrik Skarpeid <hendrik@skarpeid.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: "Igor M. Liplianin" <liplianin@me.by>,
	Nameer Kazzaz <nameer.kazzaz@gmail.com>
Subject: Re: DM1105: could not attach frontend 195d:1105
References: <4B7D83B2.4030709@online.no> <201003031749.24261.liplianin@me.by> <4B8E9182.2010906@online.no> <201003032105.06263.liplianin@me.by> <4B978D75.5080501@online.no>
In-Reply-To: <4B978D75.5080501@online.no>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A little update on the matter.

These cards are broken!

It seems that the card is designed for a different NIM than what is 
actually on the cards.
The worst problem is 3.3V power supply for the digital portion of the 
NIM. This powers the 3.3V IO on the Si2109, and it is unconnected! This 
effectively disables all the IO that is not open drain like i2c. That is 
why you will not get any 22khz tone from these cards.

Luckily, I think I have found a way to fix it. The card is now tuning, 
and the 22khz tone is working.
The LNB voltage is a little high, but that can be fixed by adding or 
replacing a resistor.
I have not tried to watch TV yet, so I am not certain if it is at all 
possible to get these cards into working order.

I will try the fix on a couple of boards and test them, and if it is 
successful, I will post a howto on the v4l wiki. Be warned though, it 
will involve the use of a soldering iron.

Hendrik Skarpeid wrote:
> Igor M. Liplianin wrote:
>> On 3 марта 2010 18:42:42 Hendrik Skarpeid wrote:
>>  
>>> Igor M. Liplianin wrote:
>>>    
>>>> Now to find GPIO's for LNB power control and ... watch TV :)
>>>>       
>>> Yep. No succesful tuning at the moment. There might also be an issue
>>> with the reset signal and writing to GPIOCTR, as the module at the
>>> moment loads succesfully only once.
>>> As far as I can make out, the LNB power control is probably GPIO 16 and
>>> 17, not sure which is which, and how they work.
>>> GPIO15 is wired to tuner #reset
>>>     
>> New patch to test
>>   
> I think the LNB voltage may be a little to high on my card, 14.5V and 
> 20V. I would be a little more happy if they were 14 and 19, 13 and 18 
> would be perfect.
> Anyways, as Igor pointet out, I don't have any signal from the LNB, 
> checked with another tuner card. It's a quad LNB, and the other 
> outputs are fine. Maybe it's' toasted from to high supply voltage! I 
> little word of warning then.
> Anyways, here's my tweaked driver.
>
>

