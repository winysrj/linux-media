Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38651 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756161AbbBCSeH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Feb 2015 13:34:07 -0500
Message-ID: <54D11499.6080800@iki.fi>
Date: Tue, 03 Feb 2015 20:34:01 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Wolfram Sang <wsa@the-dreams.de>
CC: Mark Brown <broonie@kernel.org>,
	Lars-Peter Clausen <lars@metafoo.de>,
	linux-i2c@vger.kernel.org, linux-media@vger.kernel.org,
	Jean Delvare <jdelvare@suse.de>
Subject: Re: [PATCH 21/66] rtl2830: implement own I2C locking
References: <1419367799-14263-1-git-send-email-crope@iki.fi>	<1419367799-14263-21-git-send-email-crope@iki.fi>	<20150202180726.454dc878@recife.lan>	<54CFDCCC.3030006@iki.fi>	<20150202203324.GA11486@katana> <20150203155301.7ba63776@recife.lan>
In-Reply-To: <20150203155301.7ba63776@recife.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 02/03/2015 07:53 PM, Mauro Carvalho Chehab wrote:
> Em Mon, 02 Feb 2015 21:33:24 +0100
> Wolfram Sang <wsa@the-dreams.de> escreveu:
>
>>
>>>> Ok, this may eventually work ok for now, but a further change at the I2C
>>>> core could easily break it. So, we need to double check about such
>>>> patch with the I2C maintainer.
>>>>
>>>> Jean,
>>>>
>>>> Are you ok with such patch? If so, please ack.
>>
>> Jean handed over I2C to me in late 2012 :)
>
> Sorry for the mess... I mis-read MAINTAINERS.
>
>>> Basic problem here is that I2C-mux itself is controlled by same I2C device
>>> which implements I2C adapter for tuner.
>>>
>>> Here is what connections looks like:
>>>   ___________         ____________         ____________
>>> |  USB IF   |       |   demod    |       |    tuner   |
>>> |-----------|       |------------|       |------------|
>>> |           |--I2C--|-----/ -----|--I2C--|            |
>>> |I2C master |       |  I2C mux   |       | I2C slave  |
>>> |___________|       |____________|       |____________|
>>>
>>>
>>> So when tuner is called via I2C, it needs recursively call same I2C adapter
>>> which is already locked. More elegant solution would be indeed nice.
>>
>> So, AFAIU this is the same problem that I2C based mux devices have (like
>> drivers/i2c/muxes/i2c-mux-pca954x.c)? They also use the unlocked
>> transfers...
>
> If I understood your comment correct, you're ok with this approach,
> right? I'll then merge the remaining of this 66-patch series.
>
> If latter a better way to lock the I2C mux appears, we can reverse
> this change.

More I am worried about next patch in a serie, which converts all that 
to regmap API... Same recursive mux register access comes to problem 
there, which I work-arounded by defining own I2C IO... And in that case 
I used i2c_lock_adapter/i2c_unlock_adapter so adapter is locked properly.

[PATCH 22/66] rtl2830: convert to regmap API
http://www.spinics.net/lists/linux-media/msg84969.html

regards
Antti

-- 
http://palosaari.fi/
