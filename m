Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:59695 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756168AbaLHSyO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Dec 2014 13:54:14 -0500
Message-ID: <5485F3D3.50403@southpole.se>
Date: Mon, 08 Dec 2014 19:54:11 +0100
From: Benjamin Larsson <benjamin@southpole.se>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/2] mn88472: fix firmware loading
References: <1417990203-758-1-git-send-email-benjamin@southpole.se> <1417990203-758-2-git-send-email-benjamin@southpole.se> <5484D666.6060605@iki.fi> <5485CC0E.2090201@southpole.se> <5485E3E4.80005@iki.fi>
In-Reply-To: <5485E3E4.80005@iki.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/08/2014 06:46 PM, Antti Palosaari wrote:
> Hello!
> [...]
>> regmap_bulk_write(): Write multiple registers to the device
>>
>> In this case we want to write multiple bytes to the same register. So I
>> think that my patch is correct in principle.
>
> You haven't make any test whether it is possible to write that 
> firmware in a large chunks *or* writing one byte (smallest possible 
> ~chuck) at the time? I think it does not matter. I suspect you could 
> even download whole firmware as one go - but rtl2832p I2C adapter does 
> support only 22 bytes on one xfer.
>
> Even those are written to one register, chip knows how many bytes one 
> message has and could increase its internal address counter. That is 
> usually called register address auto-increment.
>
> A) writing:
> f6 00
> f6 01
> f6 02
> f6 03
> f6 04
> f6 05
> f6 06
> f6 07
> f6 08
> f6 09
>
> B) writing:
> f6 00 01 02 03 04
> f6 05 06 07 08 09
>
> will likely end up same. B is better as only 2 xfers are done - much 
> less IO.
>
> regards
> Antti
>
Hello Antti.

I have now tried the following patch on top of my load defaults patch.

index a7d35bb..fd9796d
--- a/drivers/staging/media/mn88472/mn88472.c
+++ b/drivers/staging/media/mn88472/mn88472.c
@@ -467,7 +467,7 @@ static int mn88472_probe(struct i2c_client *client,
                 goto err;
         }

-       dev->i2c_wr_max = config->i2c_wr_max;
+       dev->i2c_wr_max = 2;
         dev->xtal = config->xtal;
         dev->ts_mode = config->ts_mode;
         dev->ts_clock = config->ts_clock;

With this patch I get data, without it I don't. Based on that info I 
started testing different i2c wr max values.

When I got to 18 it stopped working. So it seams like both you and me 
where right. We can write several
values at once but only a maximum of 16.

I have a patch that adds parity check of the firmware and all the times 
the check succeeded but the demodulator
didn't deliver data. So I guess that the parity checker is before the 16 
byte buffer and if you write more the data is
just ignored.

I will send an updated patch based on this.

MvH
Benjamin Larsson
