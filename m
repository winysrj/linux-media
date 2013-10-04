Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:53874 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136Ab3JDPfs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Oct 2013 11:35:48 -0400
Received: by mail-pb0-f50.google.com with SMTP id uo5so4174173pbc.9
        for <linux-media@vger.kernel.org>; Fri, 04 Oct 2013 08:35:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <524ED372.2080504@iki.fi>
References: <1380895312-30863-1-git-send-email-hverkuil@xs4all.nl>
	<1380895312-30863-8-git-send-email-hverkuil@xs4all.nl>
	<524ED372.2080504@iki.fi>
Date: Fri, 4 Oct 2013 11:35:48 -0400
Message-ID: <CAOcJUbzW5ECna0RnNMZGGoW439pXnNK4V+NB1AL+By8tAL+FbQ@mail.gmail.com>
Subject: Re: [PATCH 07/14] drxk_hard: fix sparse warnings
From: Michael Krufky <mkrufky@linuxtv.org>
To: Antti Palosaari <crope@iki.fi>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 4, 2013 at 10:40 AM, Antti Palosaari <crope@iki.fi> wrote:
> On 04.10.2013 17:01, Hans Verkuil wrote:
>>
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> drivers/media/dvb-frontends/drxk_hard.c:1086:62: warning: Using plain
>> integer as NULL pointer
>> drivers/media/dvb-frontends/drxk_hard.c:2784:63: warning: Using plain
>> integer as NULL pointer
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>
>
> Reviewed-by: Antti Palosaari <crope@iki.fi>
>
>
>
>> Cc: Antti Palosaari <crope@iki.fi>
>> ---
>>   drivers/media/dvb-frontends/drxk_hard.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/media/dvb-frontends/drxk_hard.c
>> b/drivers/media/dvb-frontends/drxk_hard.c
>> index 082014d..d416c15 100644
>> --- a/drivers/media/dvb-frontends/drxk_hard.c
>> +++ b/drivers/media/dvb-frontends/drxk_hard.c
>> @@ -1083,7 +1083,7 @@ static int hi_cfg_command(struct drxk_state *state)
>>                          SIO_HI_RA_RAM_PAR_1_PAR1_SEC_KEY);
>>         if (status < 0)
>>                 goto error;
>> -       status = hi_command(state, SIO_HI_RA_RAM_CMD_CONFIG, 0);
>> +       status = hi_command(state, SIO_HI_RA_RAM_CMD_CONFIG, NULL);
>>         if (status < 0)
>>                 goto error;
>>
>> @@ -2781,7 +2781,7 @@ static int ConfigureI2CBridge(struct drxk_state
>> *state, bool b_enable_bridge)
>>                         goto error;
>>         }
>>
>> -       status = hi_command(state, SIO_HI_RA_RAM_CMD_BRDCTRL, 0);
>> +       status = hi_command(state, SIO_HI_RA_RAM_CMD_BRDCTRL, NULL);
>>
>>   error:
>>         if (status < 0)
>>
>
>
> --
> http://palosaari.fi/
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Reviewed-by: Michael Krufky <mkrufky@linuxtv.org>
