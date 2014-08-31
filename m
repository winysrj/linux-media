Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47822 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498AbaHaTsT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Aug 2014 15:48:19 -0400
Message-ID: <54037BFE.60606@iki.fi>
Date: Sun, 31 Aug 2014 22:48:14 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Akihiro TSUKADA <tskd08@gmail.com>,
	Matthias Schwarzott <zzam@gentoo.org>,
	linux-media@vger.kernel.org
CC: m.chehab@samsung.com
Subject: Re: [PATCH v2 4/5] tc90522: add driver for Toshiba TC90522 quad demodulator
References: <1409153356-1887-1-git-send-email-tskd08@gmail.com> <1409153356-1887-5-git-send-email-tskd08@gmail.com> <5402F91E.7000508@gentoo.org> <540323F0.90809@gmail.com>
In-Reply-To: <540323F0.90809@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/31/2014 04:32 PM, Akihiro TSUKADA wrote:
> Hi Matthias,
> thanks for the comment.
>
>> it sounds wrong to export a second function besides tc90522_attach.
>> This way there is a hard dependency of the bridge driver to the demod
>> driver.
>> In this case it is the only possible demod, but in general it violates
>> the design of demod drivers and their connection to bridge drivers.
>
> I agree. I missed that point.
>
>>
>> si2168_probe at least has a solution for this:
>> Write the pointer to the new i2c adapter into location stored in "struct
>> i2c_adapter **" in the config structure.
>
> I'll look into the si2168 code and update tc90522 in v3.

Also, I would like to see all new drivers (demod and tuner) implemented 
as a standard kernel I2C drivers (or any other bus). I have converted 
already quite many drivers, si2168, si2157, m88ds3103, m88ts2022, 
it913x, tda18212, ...
When drivers are using proper kernel driver models, it allows using 
kernel services. For example dev_ / pr_ logging (it does not work 
properly without), RegMap API, I2C client, I2C multiplex, and so...

Here is few recent examples:
https://patchwork.linuxtv.org/patch/25495/
https://patchwork.linuxtv.org/patch/25152/
https://patchwork.linuxtv.org/patch/25146/

regards
Antti

-- 
http://palosaari.fi/
