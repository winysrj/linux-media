Return-path: <linux-media-owner@vger.kernel.org>
Received: from iris.cdu.edu.au ([138.80.130.6]:53009 "HELO iris.cdu.edu.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751080AbZHXPjB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Aug 2009 11:39:01 -0400
Cc: <linux-media@vger.kernel.org>
Message-ID: <A971DB9B-7353-4BD1-AFF3-6B30239533DF@cdu.edu.au>
From: "Malcolm Caldwell" <Malcolm.Caldwell@cdu.edu.au>
To: <lotway@nildram.co.uk>
In-Reply-To: <4A9296D5.1070202@nildram.co.uk>
Content-Type: text/plain;
	format=flowed;
	delsp=yes;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Subject: Re: Nova-TD-500 (84xxx) problems (was Re: dib0700 diversity support)
MIME-Version: 1.0 (iPhone Mail 7A341)
Date: Tue, 25 Aug 2009 00:36:18 +0930
References: <1250177934.6590.120.camel@mattotaupa.wohnung.familie-menzel.net>	 <alpine.LRH.1.10.0908140947560.14872@pub3.ifh.de>	 <1250244562.5438.3.camel@mattotaupa.wohnung.familie-menzel.net>	 <alpine.LRH.1.10.0908181052400.7725@pub1.ifh.de> <1251042115.19935.16.camel@lychee.local> <4A9296D5.1070202@nildram.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 24/08/2009, at 23:04, "Lou Otway" <lotway@nildram.co.uk> wrote:

> Malcolm Caldwell wrote:
>> Please can someone help...
>> I have been trying to get my nova-td-500 to work, but no matter  
>> what I
>> try I get a substandard signal, with lots of errors.
>> This is about the same as described elsewhere on this list.
>> I tried this code (posted by Patrick Boettcher below), hoping it  
>> may be
>> a little better but, so far, it has not improved things at all.
>> I have even replaced the antenna on my roof, in the hope of getting a
>> better signal, but I still get errors.
>> I have tried the top, the bottom and both antenna connectors, but it
>> does not seem to make much difference.
>> Is there anything else I could try?  I really want a working system
>> again. (I replaced an old buggy card with this one, not knowing it  
>> would
>> be such a problem)
>> On Tue, 2009-08-18 at 10:54 +0200, Patrick Boettcher wrote:
>>> Hi Paul,
>>>
>>> On Fri, 14 Aug 2009, Paul Menzel wrote:
>>>>> I'll post a request for testing soon.
>>>> I am looking forward to it.
>>> Can you please try the drivers from here: http://linuxtv.org/hg/~pb/v4l-dvb/
>>>
>>> In the best case they improve the situation for you. In the worst  
>>> case (not wanted :) ) it will degrade.
>>>
>>> --
>>>
>>> Patrick
>>> http://www.kernellabs.com/
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux- 
>>> media" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux- 
>> media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> Have you tried adding:
>
> dvb_usb_dib0700.force_lna_activation=1
>
> to the modprobe options?
>
> The device I had wouldn't tune without this.

I should have mentioned that I have tried this and buggy sfn  
workaround for the relavent modules.

>
> Cheers,
>
> Lou
>
>
>
