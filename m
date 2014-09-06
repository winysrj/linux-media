Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:41562 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804AbaIFHNV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Sep 2014 03:13:21 -0400
Message-ID: <540AB40B.9020508@iki.fi>
Date: Sat, 06 Sep 2014 10:13:15 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Akihiro TSUKADA <tskd08@gmail.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org, Matthias Schwarzott <zzam@gentoo.org>
Subject: Re: [PATCH v2 4/5] tc90522: add driver for Toshiba TC90522 quad demodulator
References: <1409153356-1887-1-git-send-email-tskd08@gmail.com> <1409153356-1887-5-git-send-email-tskd08@gmail.com> <5402F91E.7000508@gentoo.org> <540323F0.90809@gmail.com> <54037BFE.60606@iki.fi> <5404423A.3020307@gmail.com> <540A6B27.2010704@iki.fi> <20140905232758.36946673.m.chehab@samsung.com> <540AA4FD.5000703@gmail.com>
In-Reply-To: <540AA4FD.5000703@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/06/2014 09:09 AM, Akihiro TSUKADA wrote:
> 3. Should I also use RegMap API for register access?
> I tried using it but gave up,
> because it does not fit well to one of my use-case,
> where (only) reads must be done via 0xfb register, like
>     READ(reg, buf, len) -> [addr/w, 0xfb, reg], [addr/r, buf[0]...],
>     WRITE(reg, buf, len) -> [addr/w, reg, buf[0]...],
> and regmap looked to me overkill for 8bit-reg, 8bit-val cases
> and did not simplify the code.
> so I'd like to go without RegMap if possible,
> since I'm already puzzled enough by I2C binding, regmap, clock source,
> as well as dvb-core, PCI ;)

That is MaxLinear MxL301RF tuner I2C. Problem is there that it uses 
write + STOP + write, so you should not even do that as a one I2C 
i2c_transfer. All I2C messages send using i2c_transfer are send so 
called REPEATED START condition.

I ran that same problem ears ago in a case of, surprise, MxL5007 tuner.
https://patchwork.linuxtv.org/patch/17847/

I think you could just write wanted register to command register 0xfb. 
And after that all the reads are coming from that active register until 
you change it.

RegMap API cannot handle I2C command format like that, it relies 
repeated start for reads.

Si2157 / Si2168 are using I2C access with STOP condition - but it is 
otherwise bad example as there is firmware API, not register API. Look 
still as a example.

regards
Antti

-- 
http://palosaari.fi/
