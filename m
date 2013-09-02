Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:54418 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659Ab3IBTIr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Sep 2013 15:08:47 -0400
Received: from [192.168.1.101] ([146.52.61.147]) by mail.gmx.com (mrgmx103)
 with ESMTPSA (Nemesis) id 0LjquD-1Vs7IS3fGT-00bt5D for
 <linux-media@vger.kernel.org>; Mon, 02 Sep 2013 21:08:46 +0200
Message-ID: <5224E23C.3060006@gmx.net>
Date: Mon, 02 Sep 2013 21:08:44 +0200
From: Jan Taegert <jantaegert@gmx.net>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org, Jacek Konieczny <jajcus@jajcus.net>,
	Torsten Seyffarth <t.seyffarth@gmx.de>,
	Damien CABROL <cabrol.damien@free.fr>
Subject: Re: [PATCH] e4000: fix PLL calc error in 32-bit arch
References: <1378138669-22302-1-git-send-email-crope@iki.fi> <5224BC2D.2040909@iki.fi>
In-Reply-To: <5224BC2D.2040909@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks! Works like a charm here with TerraTec Cinergy T Stick RC (Rev. 
3). And you're right, I'm running 32-bit.

Regards,
jan.


Am 02.09.2013 18:26, schrieb Antti Palosaari:
> Testers?
>
> Here is tree:
> http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/e4000_fix_3.11
>
>
> I assume all of you have been running 32-bit arch as that bug is related
> to 32-bit overflow.
>
> regards
> Antti
>
>
> On 09/02/2013 07:17 PM, Antti Palosaari wrote:
>> Fix long-lasting error that causes tuning failure to some frequencies
>> on 32-bit arch.
>>
>> Special thanks goes to Damien CABROL who finally find root of the bug.
>> Also big thanks to Jacek Konieczny for donating non-working device.
>>
>> Reported-by: Jacek Konieczny <jajcus@jajcus.net>
>> Reported-by: Torsten Seyffarth <t.seyffarth@gmx.de>
>> Reported-by: Jan Taegert <jantaegert@gmx.net>
>> Reported-by: Damien CABROL <cabrol.damien@free.fr>
>> Tested-by: Damien CABROL <cabrol.damien@free.fr>
>> Signed-off-by: Antti Palosaari <crope@iki.fi>
>> ---
>>   drivers/media/tuners/e4000.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/tuners/e4000.c b/drivers/media/tuners/e4000.c
>> index 1b33ed3..a88f757 100644
>> --- a/drivers/media/tuners/e4000.c
>> +++ b/drivers/media/tuners/e4000.c
>> @@ -232,7 +232,7 @@ static int e4000_set_params(struct dvb_frontend *fe)
>>        * or more.
>>        */
>>       f_VCO = c->frequency * e4000_pll_lut[i].mul;
>> -    sigma_delta = 0x10000UL * (f_VCO % priv->cfg->clock) /
>> priv->cfg->clock;
>> +    sigma_delta = div_u64(0x10000ULL * (f_VCO % priv->cfg->clock),
>> priv->cfg->clock);
>>       buf[0] = f_VCO / priv->cfg->clock;
>>       buf[1] = (sigma_delta >> 0) & 0xff;
>>       buf[2] = (sigma_delta >> 8) & 0xff;
>>
>
>

