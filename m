Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59320 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272AbaIXNiH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Sep 2014 09:38:07 -0400
Message-ID: <5422C93A.2050203@iki.fi>
Date: Wed, 24 Sep 2014 16:38:02 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Akihiro TSUKADA <tskd08@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] [media] qm1d1c0042: fix compilation on 32 bits
References: <aee9cf18e96ed8384a04bd3eda69c7b9e888ee5b.1411522264.git.mchehab@osg.samsung.com>	<5422B8CD.8050302@gmail.com> <20140924103445.31aeca91@recife.lan>
In-Reply-To: <20140924103445.31aeca91@recife.lan>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 09/24/2014 04:34 PM, Mauro Carvalho Chehab wrote:
> Em Wed, 24 Sep 2014 21:27:57 +0900
> Akihiro TSUKADA <tskd08@gmail.com> escreveu:
>
>>> -	b = (((s64) freq) << 20) / state->cfg.xtal_freq - (((s64) a) << 20);
>>> +	b = (s32)div64_s64(((s64) freq) << 20,
>>> +			   state->cfg.xtal_freq - (((s64) a) << 20));
>>> +
>>
>> I'm afraid it should be like the following.
>>> +	b = (s32)(div64_s64(((s64) freq) << 20, state->cfg.xtal_freq)
>>> +			- (((s64) a) << 20));
>
> Are you talking about coding style?

It is calculation order of operators. '/' vs. '-'

>
> Instead of using something like:
>
> 	var = foo_func(a, c
> 		- b);
>
> We generally use:
> 	var = foo_func(a,
> 		       c - b);
>
> As it is quicker for reviewers to read.
>
>>
>> regads,
>> akihiro
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

-- 
http://palosaari.fi/
