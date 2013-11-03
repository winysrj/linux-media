Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55553 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753216Ab3KCRlf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 3 Nov 2013 12:41:35 -0500
Message-ID: <52768ACE.2040108@iki.fi>
Date: Sun, 03 Nov 2013 19:41:34 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: CrazyCat <crazycat69@narod.ru>, linux-media@vger.kernel.org
Subject: Re: [PATCH] cxd2820r_c: Fix if_ctl calculation
References: <527568E6.2000600@narod.ru> <5276856E.3000209@iki.fi>
In-Reply-To: <5276856E.3000209@iki.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03.11.2013 19:18, Antti Palosaari wrote:
> CrazyCat,
>
> Could you fix your mailer? Or tell me the command I can import that
> patch to my local git tree for testing?
>
> git send-email is at least know to break patches.

*not* to break patches!

>
>
> I will manually applying that patch and testing, but..
>
>
>
> error: drivers/media/dvb-frontends/cxd2820r_c.c: patch does not apply


I tested it, by manually copy & pasting that single line. I didn't 
noticed any change to existing behavior, but I have no reason to suspect 
patch is wrong.

I am not going to apply that via my tree as patch fails.

It is up to subsystem maintainers to pick it up.


Acked-by: Antti Palosaari <crope@iki.fi>
Reviewed-by: Antti Palosaari <crope@iki.fi>
Tested-by: Antti Palosaari <crope@iki.fi>


regards
Antti



>
> On 02.11.2013 23:04, CrazyCat wrote:
>> Fix tune for DVB-C.
>>
>> Signed-off-by: Evgeny Plehov <EvgenyPlehov@ukr.net>
>> diff --git a/drivers/media/dvb-frontends/cxd2820r_c.c
>> b/drivers/media/dvb-frontends/cxd2820r_c.c
>> index 125a440..5c6ab49 100644
>> --- a/drivers/media/dvb-frontends/cxd2820r_c.c
>> +++ b/drivers/media/dvb-frontends/cxd2820r_c.c
>> @@ -78,7 +78,7 @@ int cxd2820r_set_frontend_c(struct dvb_frontend *fe)
>>
>>       num = if_freq / 1000; /* Hz => kHz */
>>       num *= 0x4000;
>> -    if_ctl = cxd2820r_div_u64_round_closest(num, 41000);
>> +    if_ctl = 0x4000 - cxd2820r_div_u64_round_closest(num, 41000);
>>       buf[0] = (if_ctl >> 8) & 0x3f;
>>       buf[1] = (if_ctl >> 0) & 0xff;
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


-- 
http://palosaari.fi/
