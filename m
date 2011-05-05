Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:38143 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755788Ab1EETBu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 May 2011 15:01:50 -0400
Message-ID: <4DC2F416.90404@infradead.org>
Date: Thu, 05 May 2011 16:01:42 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: "Igor M. Liplianin" <liplianin@me.by>
CC: Hendrik Skarpeid <skarp@online.no>, linux-media@vger.kernel.org,
	Nameer Kazzaz <nameer.kazzaz@gmail.com>
Subject: Re: DM1105: could not attach frontend 195d:1105
References: <201105052141.26877.liplianin@me.by>
In-Reply-To: <201105052141.26877.liplianin@me.by>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 05-05-2011 15:41, Igor M. Liplianin escreveu:
> В сообщении от 4 мая 2011 00:33:51 автор Mauro Carvalho Chehab написал:
>> Hi Igor,
>>
>> Em 23-10-2010 07:20, Igor M. Liplianin escreveu:
>>> В сообщении от 10 марта 2010 14:15:49 автор Hendrik Skarpeid написал:
>>>> Igor M. Liplianin skrev:
>>>>> On 3 марта 2010 18:42:42 Hendrik Skarpeid wrote:
>>>>>> Igor M. Liplianin wrote:
>>>>>>> Now to find GPIO's for LNB power control and ... watch TV :)
>>>>>>
>>>>>> Yep. No succesful tuning at the moment. There might also be an issue
>>>>>> with the reset signal and writing to GPIOCTR, as the module at the
>>>>>> moment loads succesfully only once.
>>>>>> As far as I can make out, the LNB power control is probably GPIO 16
>>>>>> and 17, not sure which is which, and how they work.
>>>>>> GPIO15 is wired to tuner #reset
>>>>>
>>>>> New patch to test
>>>>
>>>> I think the LNB voltage may be a little to high on my card, 14.5V and
>>>> 20V. I would be a little more happy if they were 14 and 19, 13 and 18
>>>> would be perfect.
>>>> Anyways, as Igor pointet out, I don't have any signal from the LNB,
>>>> checked with another tuner card. It's a quad LNB, and the other outputs
>>>> are fine. Maybe it's' toasted from to high supply voltage! I little word
>>>> of warning then.
>>>> Anyways, here's my tweaked driver.
>>>
>>> Here is reworked patch for clear GPIO's handling.
>>> It allows to support I2C on GPIO's and per board LNB control through
>>> GPIO's. Also incuded support for Hendrik's card.
>>> I think it is clear how to change and test GPIO's for LNB and other stuff
>>> now.
>>>
>>> To Hendrik:
>>> 	Not shure, but there is maybe GPIO for raise/down LNB voltage a little
>>> 	(~1v). It is used for long coaxial lines to compensate voltage
>>> 	dropping.
>>>
>>> Signed-off-by: Igor M. Liplianin <liplianin@me.by>
>>
>> I'm not sure if this patch is still valid or not, and if it should or not
>> be applied, as there were several discussions around it. As a reference,
>> it is stored at patchwork with:
>> 	X-Patchwork-Id: 279091
>>
>> And still applies fine (yet, patchwork lost patch history/comments and
>> SOB).
>>
>> Igor, could you please update me if I should apply this patch or if the
>> patch got rejected/superseeded?
>>
>> Thanks!
>> Mauro.
> Hi Mauro,
> The patch should be applied.
> Do I need to do something, it means apply to a tree and send pull request? 

I could just apply it, as your email is an ack for it, but, as it is not
properly documented, I prefer if you can send an email to the mailing list
with the patch properly described.

Thanks!
Mauro.
