Return-path: <mchehab@pedra>
Received: from 5571f1ba.dsl.concepts.nl ([85.113.241.186]:42101 "EHLO
	his10.thuis.hoogenraad.info" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932111Ab1FUKBB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jun 2011 06:01:01 -0400
Message-ID: <4E006BDB.8060000@hoogenraad.net>
Date: Tue, 21 Jun 2011 12:00:59 +0200
From: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
MIME-Version: 1.0
To: Maxim Levitsky <maximlevitsky@gmail.com>
CC: Antti Palosaari <crope@iki.fi>,
	=?UTF-8?B?U2FzY2hhIFfDvHN0ZW1hbm4=?= <sascha@killerhippy.de>,
	linux-media@vger.kernel.org,
	Thomas Holzeisen <thomas@holzeisen.de>, stybla@turnovfree.net
Subject: Re: RTL2831U driver updates
References: <4DF9BCAA.3030301@holzeisen.de>	 <4DF9EA62.2040008@killerhippy.de> <4DFA7748.6000704@hoogenraad.net>	 <4DFFC82B.10402@iki.fi> <1308649292.3635.2.camel@maxim-laptop>
In-Reply-To: <1308649292.3635.2.camel@maxim-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Can I put this somewhere in the git archive at the linuxtv site, so that 
we can share and have version control ?

Maxim Levitsky wrote:
> On Tue, 2011-06-21 at 01:22 +0300, Antti Palosaari wrote:
>> It is Maxim who have been hacking with RTL2832/RTL2832U lately. But I
>> think he have given up since no noise anymore.
>>
>> I have taken now it again up to my desk and have been hacking two days
>> now. Currently I am working with RTL2830 demod driver, I started it from
>> scratch. Take sniffs, make scripts to generate code from USB traffic,
>> copy pasted that to driver skeleton and now I have picture. Just
>> implement all one-by-one until ready :-) I think I will implement it as
>> minimum possible, no any signal statistic counters - lets add those
>> later if someone wants to do that.
>>
>> USB-bridge part is rather OK as I did earlier and it is working with
>> RTL2831U and RTL2832U at least. No remote support yet.
>>
>> I hope someone else would make missing driver for RTL2832U demod still...
>>
>
> Fine!
>
> In about month, after exams, I hope I will work on this to finish at
> least RTL2832/FC0012.
>
> For reference, this is the code I did so far.
>
>
> Best regards,
> Maxim Levitsky


-- 
Jan Hoogenraad
Hoogenraad Interface Services
Postbus 2717
3500 GS Utrecht
