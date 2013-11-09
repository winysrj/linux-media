Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39340 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757949Ab3KICsI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Nov 2013 21:48:08 -0500
Message-ID: <527DA266.2030903@iki.fi>
Date: Sat, 09 Nov 2013 04:48:06 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 3/8] Montage M88DS3103 DVB-S/S2 demodulator driver
References: <1383760655-11388-1-git-send-email-crope@iki.fi>	<1383760655-11388-4-git-send-email-crope@iki.fi> <CAHFNz9KKajctZphw5bNCoYAyG15Bo+SDWNY=TXR0o337dXyzKA@mail.gmail.com>
In-Reply-To: <CAHFNz9KKajctZphw5bNCoYAyG15Bo+SDWNY=TXR0o337dXyzKA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09.11.2013 04:35, Manu Abraham wrote:
> On Wed, Nov 6, 2013 at 11:27 PM, Antti Palosaari <crope@iki.fi> wrote:


>> +/*
>> + * Driver implements own I2C-adapter for tuner I2C access. That's since chip
>> + * has I2C-gate control which closes gate automatically after I2C transfer.
>> + * Using own I2C adapter we can workaround that.
>> + */
>
>
> Why should the demodulator implement it's own adapter for tuner access ?

In order to implement it properly.


> DS3103 is identical to DS3002, DS3000 which is similar to all other
> dvb demodulators. Comparing datsheets of these demodulators
> with others, I can't see any difference in the repeater setup, except
> for an additional bit field to control the repeater block itself.
>
> Also, from what I see, the vendor; Montage has a driver, which appears
> to be more code complete looking at this url. http://goo.gl/biaPYu
>
> Do you still think the DS3103 is much different in comparison ?

There was even some patches, maybe 2 years, ago in order to mainline 
that but it never happened.

More complete is here 53 vs. 86 register writes, so yes it is more ~40 
more complete if you like to compare it like that.

regards
Antti

-- 
http://palosaari.fi/
