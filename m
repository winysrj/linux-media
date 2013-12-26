Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60953 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753522Ab3LZSEy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Dec 2013 13:04:54 -0500
Message-ID: <52BC6FC3.6060307@iki.fi>
Date: Thu, 26 Dec 2013 20:04:51 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: jana1972@centrum.cz, linux-media@vger.kernel.org
Subject: Re: A list of Linux drivers
References: <52BC1AF4.30282.3DD8741B@jana1972.centrum.cz>, <CA+MoWDr+U5wuMF8MPh_mWaesTKG7CQLq+jsvDuzoT7D+MQu9Xw@mail.gmail.com> <52BC3A45.19032.3E52CAB5@jana1972.centrum.cz>
In-Reply-To: <52BC3A45.19032.3E52CAB5@jana1972.centrum.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moi Jahn
There is not very many suitable alternatives that are available on 
market as of today. Maybe PCTV 460e/461e only?. 460e is older one which 
is replaced by 461e. I think it is currently bigger change to get new 
461e if you order one.
460e is em28xx + tda10071
461e is em28xx + m88ds3103

460e has been supported ages, but 461e was added recently. That means 
you will need to compile 461e drivers separately.

And I am not even sure if it works for MIPS. I have simply no hardware 
to test. Anyhow, possible fix should be rather easy.

regards
Antti


On 26.12.2013 15:16, Jahn wrote:
> Peter,
> Thank you for the reply.
> But I would like to use a USB tuner with my satelite receiver( as the second tuner)
> and not sure which tuner will suit the best  my needs.
> So I wonder if there is a list of tuners (with Linux drivers)  that I can choose from .
> Or can anyone advice a good/cheap DVB-S2 USB tuner?
> Preferably with open source driver
>
> Thank you for  your reply.
>
>> Check the file: drivers/media/tuners/Kconfig
>>
>> On Thu, Dec 26, 2013 at 12:03 PM, Jahn <jana1972@centrum.cz> wrote: >
>> Is there  available a list of tuners that are supported  in Linux (
>> those that have a driver) > preferably in MIPS Linux ? > Thanks > > --
>>> To unsubscribe from this list: send the line "unsubscribe
>> linux-media" in > the body of a message to majordomo@vger.kernel.org >
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>>
>> --
>> Peter
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media"
>> in the body of a message to majordomo@vger.kernel.org More majordomo
>> info at  http://vger.kernel.org/majordomo-info.html
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
http://palosaari.fi/
