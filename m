Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:47084 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199Ab0BWNMK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2010 08:12:10 -0500
Received: by wwf26 with SMTP id 26so732342wwf.19
        for <linux-media@vger.kernel.org>; Tue, 23 Feb 2010 05:12:08 -0800 (PST)
Message-ID: <4B83D425.6060803@gmail.com>
Date: Tue, 23 Feb 2010 13:12:05 +0000
From: Nameer Kazzaz <nameer.kazzaz@gmail.com>
MIME-Version: 1.0
To: Hendrik Skarpeid <skarp@online.no>
CC: "Igor M. Liplianin" <liplianin@me.by>, linux-media@vger.kernel.org
Subject: Re: DM1105: could not attach frontend 195d:1105
References: <4B7D83B2.4030709@online.no> <201002201949.36612.liplianin@me.by> <4B82EF6D.2000707@gmail.com> <4B83C6C0.5020708@online.no>
In-Reply-To: <4B83C6C0.5020708@online.no>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sounds cool, let me know if I can help you with anything.

Thanks
Nameer

Hendrik Skarpeid wrote:
> No luck here either, still working on it.
> My plan is to solder som wires on strategic points on the board and 
> debug i2c and other activity with an oscilloscope. Will probably start 
> next week.
>
> Nameer Kazzaz wrote:
>> Hey Igor,
>> I'm getting the same error:
>> dm1105 0000:04:0b.0: could not attach frontend
>>
>> Did you get your one to work.
>>
>> Thanks
>> Nameer
>>
>> Igor M. Liplianin wrote:
>>> On 18 февраля 2010, liplianin@me.by wrote:
>>>  
>>>> I also got the unbranded dm1105 card. I tried the four possible i2c
>>>> addresses, just i case. Noen worked of course. Then I traced the i2c
>>>> pins on the tuner to pins 100 and 101 on the DM1105.
>>>> These are GPIO pins, so bit-banging i2c on these pins seems to be the
>>>> solution.
>>>>
>>>> scl = p101 = gpio14
>>>> sda = p100 = gpio13
>>>>     
>>> Here is the patch to test. Use option card=4.
>>>     modprobe dm1105 card=4
>>>   
>>
>>
>>
>

