Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57109 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbaLNIfU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Dec 2014 03:35:20 -0500
Message-ID: <548D4BC6.5030701@iki.fi>
Date: Sun, 14 Dec 2014 10:35:18 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Benjamin Larsson <benjamin@southpole.se>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 4/4] mn88472: implemented ber reporting
References: <1418429925-16342-1-git-send-email-benjamin@southpole.se> <1418429925-16342-4-git-send-email-benjamin@southpole.se> <548BBD4D.3060001@iki.fi> <548C1F19.1060809@southpole.se>
In-Reply-To: <548C1F19.1060809@southpole.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/13/2014 01:12 PM, Benjamin Larsson wrote:
> On 12/13/2014 05:15 AM, Antti Palosaari wrote:
>> On 12/13/2014 02:18 AM, Benjamin Larsson wrote:
>>> Signed-off-by: Benjamin Larsson <benjamin@southpole.se>
>>
>> Reviewed-by: Antti Palosaari <crope@iki.fi>
>>
>>
>> Even I could accept that, as a staging driver, I see there some issues:
>>
>> * missing commit message (ok, it is trivial and patch subject says)
>>
>> * it is legacy DVBv3 API BER reporting, whilst driver is DVBv5 mostly
>> due to DVB-T2... So DVBv5 statistics are preferred.
>>
>> * dynamic debugs has unneded __func__,  see
>> Documentation/dynamic-debug-howto.txt
>>
>> * there should be spaces used around binary and ternary calculation
>> operators, see Documentation/CodingStyle for more info how it should be.
>>
>>
>> Could you read overall these two docs before make new patches:
>> Documentation/CodingStyle
>> Documentation/dynamic-debug-howto.txt
>>
>> also use scripts/checkpatch.pl to verify patch, like that
>> git diff | ./scripts/checkpatch.pl -
>>
>> regards
>> Antti
>
> I will read those. Can you recommend a driver as template for DVBv5
> statistics ?

I just posted set of rtl2830 driver patches where is one example. 
Another example is af9035 and si2168. DVBv5 stats works so that you 
periodically update values in property cache, which are then returned to 
application if app request. Values are updated to cache even none is 
using those.

regards
Antti

-- 
http://palosaari.fi/
