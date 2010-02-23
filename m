Return-path: <linux-media-owner@vger.kernel.org>
Received: from vip1scan.telenor.net ([148.123.15.75]:15131 "EHLO sv02.e.nsc.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751564Ab0BWM3A (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2010 07:29:00 -0500
Message-ID: <4B83C6C0.5020708@online.no>
Date: Tue, 23 Feb 2010 13:14:56 +0100
From: Hendrik Skarpeid <skarp@online.no>
MIME-Version: 1.0
To: Nameer Kazzaz <nameer.kazzaz@gmail.com>
CC: "Igor M. Liplianin" <liplianin@me.by>, linux-media@vger.kernel.org
Subject: Re: DM1105: could not attach frontend 195d:1105
References: <4B7D83B2.4030709@online.no> <201002201949.36612.liplianin@me.by> <4B82EF6D.2000707@gmail.com>
In-Reply-To: <4B82EF6D.2000707@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

No luck here either, still working on it.
My plan is to solder som wires on strategic points on the board and 
debug i2c and other activity with an oscilloscope. Will probably start 
next week.

Nameer Kazzaz wrote:
> Hey Igor,
> I'm getting the same error:
> dm1105 0000:04:0b.0: could not attach frontend
>
> Did you get your one to work.
>
> Thanks
> Nameer
>
> Igor M. Liplianin wrote:
>> On 18 февраля 2010, liplianin@me.by wrote:
>>  
>>> I also got the unbranded dm1105 card. I tried the four possible i2c
>>> addresses, just i case. Noen worked of course. Then I traced the i2c
>>> pins on the tuner to pins 100 and 101 on the DM1105.
>>> These are GPIO pins, so bit-banging i2c on these pins seems to be the
>>> solution.
>>>
>>> scl = p101 = gpio14
>>> sda = p100 = gpio13
>>>     
>> Here is the patch to test. Use option card=4.
>>     modprobe dm1105 card=4
>>   
>
>
>

