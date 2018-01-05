Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:41143 "EHLO
        homiemail-a121.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751196AbeAEBeR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 4 Jan 2018 20:34:17 -0500
Subject: Re: [PATCH 8/9] lgdt3306a: QAM streaming improvement
To: Michael Ira Krufky <mkrufky@linuxtv.org>
Cc: linux-media <linux-media@vger.kernel.org>
References: <1515110659-20145-1-git-send-email-brad@nextdimension.cc>
 <1515110659-20145-9-git-send-email-brad@nextdimension.cc>
 <CAOcJUbwi5s_TUpw1Jx9qt8ugh9bRTv5SBrWbSpKoAY5j8moWqg@mail.gmail.com>
From: Brad Love <brad@nextdimension.cc>
Message-ID: <a6527c51-f6fc-53d9-27a3-632ccc06a5d0@nextdimension.cc>
Date: Thu, 4 Jan 2018 19:34:16 -0600
MIME-Version: 1.0
In-Reply-To: <CAOcJUbwi5s_TUpw1Jx9qt8ugh9bRTv5SBrWbSpKoAY5j8moWqg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 2018-01-04 18:26, Michael Ira Krufky wrote:
> On Thu, Jan 4, 2018 at 7:04 PM, Brad Love <brad@nextdimension.cc> wrote:
>> Add some register updates required for stable viewing
>> on Cablevision in NY. Does not adversely affect other providers.
>>
>> Signed-off-by: Brad Love <brad@nextdimension.cc>
>> ---
>>  drivers/media/dvb-frontends/lgdt3306a.c | 22 ++++++++++++++++++++++
>>  1 file changed, 22 insertions(+)
>>
>> diff --git a/drivers/media/dvb-frontends/lgdt3306a.c b/drivers/media/dvb-frontends/lgdt3306a.c
>> index d2477ed..2f540f1 100644
>> --- a/drivers/media/dvb-frontends/lgdt3306a.c
>> +++ b/drivers/media/dvb-frontends/lgdt3306a.c
>> @@ -598,6 +598,28 @@ static int lgdt3306a_set_qam(struct lgdt3306a_state *state, int modulation)
>>         if (lg_chkerr(ret))
>>                 goto fail;
>>
>> +       /* 5.1 V0.36 SRDCHKALWAYS : For better QAM detection */
>> +       ret = lgdt3306a_read_reg(state, 0x000A, &val);
>> +       val &= 0xFD;
>> +       val |= 0x02;
>> +       ret = lgdt3306a_write_reg(state, 0x000A, val);
>> +       if (lg_chkerr(ret))
>> +               goto fail;
>> +
>> +       /* 5.2 V0.36 Control of "no signal" detector function */
>> +       ret = lgdt3306a_read_reg(state, 0x2849, &val);
>> +       val &= 0xDF;
>> +       ret = lgdt3306a_write_reg(state, 0x2849, val);
>> +       if (lg_chkerr(ret))
>> +               goto fail;
>> +
>> +       /* 5.3 Fix for Blonder Tongue HDE-2H-QAM and AQM modulators */
>> +       ret = lgdt3306a_read_reg(state, 0x302B, &val);
>> +       val &= 0x7F;  /* SELFSYNCFINDEN_CQS=0; disable auto reset */
>> +       ret = lgdt3306a_write_reg(state, 0x302B, val);
>> +       if (lg_chkerr(ret))
>> +               goto fail;
>> +
>>         /* 6. Reset */
>>         ret = lgdt3306a_soft_reset(state);
>>         if (lg_chkerr(ret))
> Brad,
>
> The change looks good, but can you resubmit this using lowercase hex?
>
> Cheers,
>
> Michael Ira Krufky

Done, v2 submitted.
