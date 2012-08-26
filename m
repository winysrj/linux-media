Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:16479 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754034Ab2HZQQS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Aug 2012 12:16:18 -0400
Date: Sun, 26 Aug 2012 18:16:16 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
To: Antti Palosaari <crope@iki.fi>
cc: Andy Walls <awalls@md.metrocast.net>,
	Julia Lawall <julia.lawall@lip6.fr>, mchehab@infradead.org,
	linux-media@vger.kernel.org
Subject: Re: question about drivers/media/dvb-frontends/rtl2830.c
In-Reply-To: <503A4988.70205@iki.fi>
Message-ID: <alpine.DEB.2.02.1208261815590.2065@localhost6.localdomain6>
References: <alpine.DEB.2.02.1208260923570.2065@localhost6.localdomain6> <c67025bd-4c41-462f-88ee-b534b733d320@email.android.com> <503A4988.70205@iki.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 26 Aug 2012, Antti Palosaari wrote:

> On 08/26/2012 02:20 PM, Andy Walls wrote:
>> Julia Lawall <julia.lawall@lip6.fr> wrote:
>> 
>>> The function rtl2830_init contains the code:
>>>
>>>          buf[0] = tmp << 6;
>>>          buf[0] = (if_ctl >> 16) & 0x3f;
>>>          buf[1] = (if_ctl >>  8) & 0xff;
>>>          buf[2] = (if_ctl >>  0) & 0xff;
>>> 
>>> Is there any purpose to initializing buf[0] twice?
>>> 
>>> julia
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-media"
>>> in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> 
>> Hmm.  Since 0x3f is the lowest 6 bits, it looks like the second line should 
>> use |= instead of = .   I don't know anything about the rt2830 though.
>> 
>> -Andy
>
> Andy is correct. If you look few lines just before that you could see that 
> logic. Patch is welcome.

Done.  Thanks for the quick responses.

julia
