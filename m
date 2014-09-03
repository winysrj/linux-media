Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34593 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754760AbaICKuL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Sep 2014 06:50:11 -0400
Message-ID: <5406F25D.3090001@iki.fi>
Date: Wed, 03 Sep 2014 13:50:05 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org, Nibble Max <nibble.max@gmail.com>,
	Olli Salonen <olli.salonen@iki.fi>,
	Evgeny Plehov <EvgenyPlehov@ukr.net>
Subject: Re: [GIT PULL FINAL 16/21] m88ts2022: rename device state (priv =>
 s)
References: <1408705093-5167-1-git-send-email-crope@iki.fi> <1408705093-5167-17-git-send-email-crope@iki.fi> <20140902155104.4b4e04dc.m.chehab@samsung.com> <54067C6D.8090804@iki.fi> <20140903073823.54daad9b.m.chehab@samsung.com>
In-Reply-To: <20140903073823.54daad9b.m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/03/2014 01:38 PM, Mauro Carvalho Chehab wrote:
> Em Wed, 03 Sep 2014 05:26:53 +0300
> Antti Palosaari <crope@iki.fi> escreveu:
>
>> On 09/02/2014 09:51 PM, Mauro Carvalho Chehab wrote:
>>> Em Fri, 22 Aug 2014 13:58:08 +0300
>>> Antti Palosaari <crope@iki.fi> escreveu:
>>>
>>>> I like short names for things which are used everywhere overall the
>>>> driver. Due to that rename device state pointer from 'priv' to 's'.
>>>
>>> Please, don't do that. "s" is generally used on several places for string.
>>> If you want a shorter name, call it "st" for example.
>>
>> huoh :/
>> st is not even much better. 'dev' seems to be the 'official' term. I
>> will start using it. There is one caveat when 'dev' is used as kernel
>> dev_foo() logging requires pointer to device, which is also called dev.
>
> Yeah, on v4l2, we generally use 'dev' for such struct on several drivers.
> Yet, it looks confusing, especially when some part of the code needs to
> work with the private structure and struct device.
>
> So, we end having things like dev->udev->dev inside them, with looks
> ugly, IMHO.

I renamed it to dev due to 2 reasons (I did quite a lot of work to find 
out which it should be):
1) it was mostly used term in kernel code base for that structure 
holding device instance state
2) it was used in book Linux Device Drivers, Third Edition

regards
Antti

-- 
http://palosaari.fi/
