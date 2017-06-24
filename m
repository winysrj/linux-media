Return-path: <linux-media-owner@vger.kernel.org>
Received: from imap.netup.ru ([77.72.80.14]:48710 "EHLO imap.netup.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751355AbdFXSlM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Jun 2017 14:41:12 -0400
Received: from mail-ot0-f174.google.com (mail-ot0-f174.google.com [74.125.82.174])
        by imap.netup.ru (Postfix) with ESMTPSA id CFBD88C2DBC
        for <linux-media@vger.kernel.org>; Sat, 24 Jun 2017 21:41:10 +0300 (MSK)
Received: by mail-ot0-f174.google.com with SMTP id y47so48923081oty.0
        for <linux-media@vger.kernel.org>; Sat, 24 Jun 2017 11:41:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170624153538.711af53a@vento.lan>
References: <20170622200328.5387-1-d.scheller.oss@gmail.com> <20170624153538.711af53a@vento.lan>
From: Abylay Ospan <aospan@netup.ru>
Date: Sat, 24 Jun 2017 14:40:48 -0400
Message-ID: <CAK3bHNWuBU+4465rvCE2Yot_XrMBhxOqXq2+-LT=MUPMGAavEQ@mail.gmail.com>
Subject: Re: [PATCH] [media] dvb-frontends/cxd2841er: require FE_HAS_SYNC for
 agc readout
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Daniel Scheller <d.scheller.oss@gmail.com>,
        linux-media <linux-media@vger.kernel.org>,
        Kozlov Sergey <serjk@netup.ru>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Yes, make sense.

2017-06-24 14:35 GMT-04:00 Mauro Carvalho Chehab <mchehab@s-opensource.com>:
> Em Thu, 22 Jun 2017 22:03:28 +0200
> Daniel Scheller <d.scheller.oss@gmail.com> escreveu:
>
>> From: Daniel Scheller <d.scheller@gmx.net>
>>
>> When the demod driver puts the demod into sleep or shutdown state and it's
>> status is then polled e.g. via "dvb-fe-tool -m", i2c errors are printed
>> to the kernel log. If the last delsys was DVB-T/T2:
>>
>>   cxd2841er: i2c wr failed=-5 addr=6c reg=00 len=1
>>   cxd2841er: i2c rd failed=-5 addr=6c reg=26
>>
>> and if it was DVB-C:
>>
>>   cxd2841er: i2c wr failed=-5 addr=6c reg=00 len=1
>>   cxd2841er: i2c rd failed=-5 addr=6c reg=49
>>
>> This happens when read_status unconditionally calls into the
>> read_signal_strength() function which triggers the read_agc_gain_*()
>> functions, where these registered are polled.
>>
>> This isn't a critical thing since when the demod is active again, no more
>> such errors are logged, however this might make users suspecting defects.
>>
>> Fix this by requiring fe_status FE_HAS_SYNC to be sure the demod is not
>> put asleep or shut down. If FE_HAS_SYNC isn't set, additionally set the
>> strength scale to NOT_AVAILABLE.
>
> Requiring full lock for signal strength seems too much, as people usually
> rely on signal strength to adjust antenna.
>
> You should, instead, just check if the demod is shut down.
>
> Regards,
> Mauro
>
>>
>> Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
>> ---
>>  drivers/media/dvb-frontends/cxd2841er.c | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
>> index 08f67d60a7d9..9fff031436f1 100644
>> --- a/drivers/media/dvb-frontends/cxd2841er.c
>> +++ b/drivers/media/dvb-frontends/cxd2841er.c
>> @@ -3279,7 +3279,10 @@ static int cxd2841er_get_frontend(struct dvb_frontend *fe,
>>       else if (priv->state == STATE_ACTIVE_TC)
>>               cxd2841er_read_status_tc(fe, &status);
>>
>> -     cxd2841er_read_signal_strength(fe);
>> +     if (status & FE_HAS_SYNC)
>> +             cxd2841er_read_signal_strength(fe);
>> +     else
>> +             p->strength.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
>>
>>       if (status & FE_HAS_LOCK) {
>>               cxd2841er_read_snr(fe);
>
>
>
> Thanks,
> Mauro



-- 
Abylay Ospan,
NetUP Inc.
http://www.netup.tv
