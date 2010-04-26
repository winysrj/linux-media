Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.195]:61860 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752244Ab0DZTup (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Apr 2010 15:50:45 -0400
Message-ID: <4BD5EE8E.5070603@vorgon.com>
Date: Mon, 26 Apr 2010 12:50:38 -0700
From: "Timothy D. Lenz" <tlenz@vorgon.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: tuner XC5000 race condition??
References: <20100426104446.01bca601@glory.loctelecom.ru> <1272243610.3060.6.camel@palomino.walls.org> <4BD5E1FF.8030704@vorgon.com>
In-Reply-To: <4BD5E1FF.8030704@vorgon.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 4/26/2010 11:57 AM, Timothy D. Lenz wrote:
>
>
> On 4/25/2010 6:00 PM, Andy Walls wrote:
>> On Mon, 2010-04-26 at 10:44 +1000, Dmitri Belimov wrote:
>>> Hi
>>>
>>> Sometimes tuner XC5000 crashed on boot. This PC is dual-core.
>>> It can be race condition or multi-core depend problem.
>>>
>>> Add mutex for solve this problem is correct?
>>
>> Dmitri,
>>
>> This problem may be related to the firmware loading race described here:
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=15294
>>
>> I still have not fixed that bug yet.
>>
>> But for your problem, perhaps you can try:
>>
>> echo 120> /sys/class/firmware/timeout
>>
>> as root in the initialization scripts to lengthen the firmware loading
>> timeout to 120 seconds. Maybe that will work around the crash.
>>
>> I'll try and look at what is going on in your crash dumps, if I have
>> time.
>>
>> Regards,
>> Andy
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>
>
> Could this problem also be related to the tuner problem I've been having
> with one tuner stop tuning? Because it is on a Athlon64 x2 (dual core).
> I put up logs with debug on. First set was I think about 24hrs with no
> crash, then the file ext new and new2 where each copied out after the
> tuner was found crashed.
>
> http://24.255.17.209:2400/vdr/logs/
>
> The computer hosting these logs, I hope to take down for a short while,
> maybe a few hours to switch it over to raid boot. So if you can't
> connect, try again later.

Keep forgetting, reply on this list doesn't go to the list unless you 
reply all or manually change the address:(

Could this problem also be related to the tuner problem I've been having 
with one tuner stop tuning? Because it is on a Athlon64 x2 (dual core). 
I put up logs with debug on. First set was I think about 24hrs with no 
crash, then the file ext new and new2 where each copied out after the 
tuner was found crashed.
