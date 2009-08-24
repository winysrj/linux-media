Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:51515 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451AbZHXNeJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Aug 2009 09:34:09 -0400
Message-ID: <4A9296D5.1070202@nildram.co.uk>
Date: Mon, 24 Aug 2009 14:34:13 +0100
From: Lou Otway <lotway@nildram.co.uk>
Reply-To: lotway@nildram.co.uk
MIME-Version: 1.0
To: Malcolm Caldwell <malcolm.caldwell@cdu.edu.au>
CC: linux-media@vger.kernel.org
Subject: Re: Nova-TD-500 (84xxx) problems (was Re: dib0700 diversity support)
References: <1250177934.6590.120.camel@mattotaupa.wohnung.familie-menzel.net>	 <alpine.LRH.1.10.0908140947560.14872@pub3.ifh.de>	 <1250244562.5438.3.camel@mattotaupa.wohnung.familie-menzel.net>	 <alpine.LRH.1.10.0908181052400.7725@pub1.ifh.de> <1251042115.19935.16.camel@lychee.local>
In-Reply-To: <1251042115.19935.16.camel@lychee.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Malcolm Caldwell wrote:
> Please can someone help...
> 
> I have been trying to get my nova-td-500 to work, but no matter what I
> try I get a substandard signal, with lots of errors.
> 
> This is about the same as described elsewhere on this list.
> 
> I tried this code (posted by Patrick Boettcher below), hoping it may be
> a little better but, so far, it has not improved things at all.
> 
> I have even replaced the antenna on my roof, in the hope of getting a
> better signal, but I still get errors.
> 
> I have tried the top, the bottom and both antenna connectors, but it
> does not seem to make much difference.
> 
> Is there anything else I could try?  I really want a working system
> again. (I replaced an old buggy card with this one, not knowing it would
> be such a problem)
> 
> 
> On Tue, 2009-08-18 at 10:54 +0200, Patrick Boettcher wrote:
>> Hi Paul,
>>
>> On Fri, 14 Aug 2009, Paul Menzel wrote:
>>>> I'll post a request for testing soon.
>>> I am looking forward to it.
>> Can you please try the drivers from here: 
>> http://linuxtv.org/hg/~pb/v4l-dvb/
>>
>> In the best case they improve the situation for you. In the worst case 
>> (not wanted :) ) it will degrade.
>>
>> --
>>
>> Patrick
>> http://www.kernellabs.com/
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

Have you tried adding:

dvb_usb_dib0700.force_lna_activation=1

to the modprobe options?

The device I had wouldn't tune without this.

Cheers,

Lou



