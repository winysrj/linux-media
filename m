Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:53697 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932449Ab2HQSwz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Aug 2012 14:52:55 -0400
Received: by lbbgj3 with SMTP id gj3so2298179lbb.19
        for <linux-media@vger.kernel.org>; Fri, 17 Aug 2012 11:52:53 -0700 (PDT)
Message-ID: <502E92F6.6060509@iki.fi>
Date: Fri, 17 Aug 2012 21:52:38 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: CrazyCat <crazycat69@yandex.ru>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] dvb_frontend: Multistream support
References: <53381345139167@web11e.yandex.ru> <502D37CF.7030608@iki.fi> <839331345224097@web14d.yandex.ru>
In-Reply-To: <839331345224097@web14d.yandex.ru>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/17/2012 08:21 PM, CrazyCat wrote:
>
> 16.08.2012, 21:11, "Antti Palosaari" <crope@iki.fi>:
>>>   - /* ISDB-T specifics */
>>>   - u32 isdbs_ts_id;
>>>   -
>>>   - /* DVB-T2 specifics */
>>>   - u32                     dvbt2_plp_id;
>>>   + /* Multistream specifics */
>>>   + u32 stream_id;
>>
>> u32 == 32 bit long unsigned number. See next comment.
>>>
>>>   - c->isdbs_ts_id = 0;
>>>   - c->dvbt2_plp_id = 0;
>>>   + c->stream_id = -1;
>>
>> unsigned number cannot be -1. It can be only 0 or bigger. Due to that
>> this is wrong.
>
> so maybe better declare in as int ? depend from standard valid stream id (for DVB is 0-255) and any another value (-1) disable stream filtering in demod.

I agree that. Actually I was thinking same. For DVB-T2 valid values are 
0-255, I haven't looked others but surely int maximum should enough for all.

regards
Antti

-- 
http://palosaari.fi/
