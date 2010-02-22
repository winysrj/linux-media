Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:46391 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754336Ab0BVU4U (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 15:56:20 -0500
Received: by ewy28 with SMTP id 28so3236873ewy.28
        for <linux-media@vger.kernel.org>; Mon, 22 Feb 2010 12:56:19 -0800 (PST)
Message-ID: <4B82EF6D.2000707@gmail.com>
Date: Mon, 22 Feb 2010 20:56:13 +0000
From: Nameer Kazzaz <nameer.kazzaz@gmail.com>
MIME-Version: 1.0
To: "Igor M. Liplianin" <liplianin@me.by>
CC: Hendrik Skarpeid <skarp@online.no>, linux-media@vger.kernel.org
Subject: Re: DM1105: could not attach frontend 195d:1105
References: <4B7D83B2.4030709@online.no> <201002201949.36612.liplianin@me.by>
In-Reply-To: <201002201949.36612.liplianin@me.by>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hey Igor,
I'm getting the same error:
dm1105 0000:04:0b.0: could not attach frontend

Did you get your one to work.

Thanks
Nameer

Igor M. Liplianin wrote:
> On 18 февраля 2010, liplianin@me.by wrote:
>   
>> I also got the unbranded dm1105 card. I tried the four possible i2c
>> addresses, just i case. Noen worked of course. Then I traced the i2c
>> pins on the tuner to pins 100 and 101 on the DM1105.
>> These are GPIO pins, so bit-banging i2c on these pins seems to be the
>> solution.
>>
>> scl = p101 = gpio14
>> sda = p100 = gpio13
>>     
> Here is the patch to test. Use option card=4.
> 	modprobe dm1105 card=4
>   

