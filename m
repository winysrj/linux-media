Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42538 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797AbaIFCCU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Sep 2014 22:02:20 -0400
Message-ID: <540A6B27.2010704@iki.fi>
Date: Sat, 06 Sep 2014 05:02:15 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Akihiro TSUKADA <tskd08@gmail.com>, linux-media@vger.kernel.org
CC: Matthias Schwarzott <zzam@gentoo.org>, m.chehab@samsung.com
Subject: Re: [PATCH v2 4/5] tc90522: add driver for Toshiba TC90522 quad demodulator
References: <1409153356-1887-1-git-send-email-tskd08@gmail.com> <1409153356-1887-5-git-send-email-tskd08@gmail.com> <5402F91E.7000508@gentoo.org> <540323F0.90809@gmail.com> <54037BFE.60606@iki.fi> <5404423A.3020307@gmail.com>
In-Reply-To: <5404423A.3020307@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/01/2014 12:54 PM, Akihiro TSUKADA wrote:
> Hi,
>
>> Also, I would like to see all new drivers (demod and tuner) implemented
>> as a standard kernel I2C drivers (or any other bus). I have converted
>> already quite many drivers, si2168, si2157, m88ds3103, m88ts2022,
>> it913x, tda18212, ...
>
> I wrote the code in the old style using dvb_attach()
> because (I felt) it is simpler than using i2c_new_device() by
> introducing new i2c-related data structures,
> registering to both dvb and i2c, without any new practical
> features that i2c client provides.

Of course it is simpler to do old style as you could copy & paste older 
drivers and so. However, for a long term we must get rid of all DVB 
specific hacks and use common kernel solutions. The gap between common 
kernel solutions and DVB proprietary is already too big, without any 
good reason - just a laziness of developers to find out proper solutions 
as adding hacks is easier.

I mentioned quite many reasons earlier and If you look that driver you 
will see you use dev_foo() logging, that does not even work properly 
unless you convert driver to some kernel binding model (I2C on that 
case) (as I explained earlier).

There is also review issues. For more people do own tricks and hacks the 
harder code is review and also maintain as you don't never know what 
breaks when you do small change, which due to some trick used causes 
some other error.

Here is one example I fixed recently:
https://patchwork.linuxtv.org/patch/25776/

Lets mention that I am not even now fully happy to solution, even it 
somehow now works. Proper solution is implement clock source and clock 
client. Then register client to that source. And when client needs a 
clock (or power) it makes call to enable clock.

> But if the use of dvb_attach() is (almost) deprecated and
> i2c client driver is the standard/prefered way,
> I'll convert my code.

regards
Antti

-- 
http://palosaari.fi/
