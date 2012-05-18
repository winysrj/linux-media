Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57417 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966793Ab2ERTQi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 May 2012 15:16:38 -0400
Message-ID: <4FB6A014.8000706@iki.fi>
Date: Fri, 18 May 2012 22:16:36 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Thomas Mair <thomas.mair86@googlemail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/5] rtl2832 ver 0.3: suport for RTL2832 demodulator revised
 version
References: <1336846109-30070-1-git-send-email-thomas.mair86@googlemail.com> <1336846109-30070-2-git-send-email-thomas.mair86@googlemail.com> <4FB061C2.90006@iki.fi>
In-Reply-To: <4FB061C2.90006@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 14.05.2012 04:37, Antti Palosaari wrote:
>
>> +    else {
>> +        /* if_agc is read as a 10bit binary */
>> +        ret = rtl2832_rd_demod_reg(priv, DVBT_IF_AGC_VAL,&if_agc_raw);
>> +        if (ret)
>> +            goto err;
>> +
>> +            if (if_agc_raw<  (1<<  9))
>> +                if_agc = if_agc_raw;
>> +            else
>> +                if_agc = -(~(if_agc_raw-1)&  0x1ff);
>> +
>> +            *strength = 55 - if_agc / 182;
>> +            *strength |= *strength<<  8;
>
> That calculation shows doubtful. Why not to scale directly to the
> counter. Now you divide it by 182 and after that multiply 256 (<< 8
> means same as multiply by 256). It is stupid calculation.

I was playing with RTL2830 statistics and thus it is quite similar I 
ended up looking that again. It is not so wrong as I commented. The idea 
of whole calculation is to underflow unsigned 8 bit value to the 
*strength. But it goes wrong here because you don't cast it as unsigned 
char (this should be *strength = (u8) (55 - if_agc / 182);.

I implemented that rather similarly for the RTL2830. But it is very poor 
resolution for some reason... :-(

regards
Antti
-- 
http://palosaari.fi/
