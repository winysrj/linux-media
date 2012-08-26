Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:33012 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751114Ab2HZQGv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Aug 2012 12:06:51 -0400
Received: by lagy9 with SMTP id y9so2080361lag.19
        for <linux-media@vger.kernel.org>; Sun, 26 Aug 2012 09:06:49 -0700 (PDT)
Message-ID: <503A4988.70205@iki.fi>
Date: Sun, 26 Aug 2012 19:06:32 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>,
	Julia Lawall <julia.lawall@lip6.fr>
CC: mchehab@infradead.org, linux-media@vger.kernel.org
Subject: Re: question about drivers/media/dvb-frontends/rtl2830.c
References: <alpine.DEB.2.02.1208260923570.2065@localhost6.localdomain6> <c67025bd-4c41-462f-88ee-b534b733d320@email.android.com>
In-Reply-To: <c67025bd-4c41-462f-88ee-b534b733d320@email.android.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/26/2012 02:20 PM, Andy Walls wrote:
> Julia Lawall <julia.lawall@lip6.fr> wrote:
>
>> The function rtl2830_init contains the code:
>>
>>          buf[0] = tmp << 6;
>>          buf[0] = (if_ctl >> 16) & 0x3f;
>>          buf[1] = (if_ctl >>  8) & 0xff;
>>          buf[2] = (if_ctl >>  0) & 0xff;
>>
>> Is there any purpose to initializing buf[0] twice?
>>
>> julia
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> Hmm.  Since 0x3f is the lowest 6 bits, it looks like the second line should use |= instead of = .   I don't know anything about the rt2830 though.
>
> -Andy

Andy is correct. If you look few lines just before that you could see 
that logic. Patch is welcome.

regards
Antti


-- 
http://palosaari.fi/
