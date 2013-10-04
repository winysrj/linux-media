Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:57608 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754936Ab3JDPfa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Oct 2013 11:35:30 -0400
Received: by mail-pa0-f52.google.com with SMTP id kl14so4271857pab.25
        for <linux-media@vger.kernel.org>; Fri, 04 Oct 2013 08:35:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <524ED436.6030001@iki.fi>
References: <1380895312-30863-1-git-send-email-hverkuil@xs4all.nl>
	<1380895312-30863-7-git-send-email-hverkuil@xs4all.nl>
	<524ED436.6030001@iki.fi>
Date: Fri, 4 Oct 2013 11:35:30 -0400
Message-ID: <CAOcJUbxNrvjTsFsY2QBV++J4-p=u6j2VxP97XVc5Anm9Vvo7-g@mail.gmail.com>
Subject: Re: [PATCH 06/14] drxd_hard: fix sparse warnings
From: Michael Krufky <mkrufky@linuxtv.org>
To: Antti Palosaari <crope@iki.fi>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 4, 2013 at 10:44 AM, Antti Palosaari <crope@iki.fi> wrote:
> On 04.10.2013 17:01, Hans Verkuil wrote:
>>
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> drivers/media/dvb-frontends/drxd_hard.c:1017:70: warning: Using plain
>> integer as NULL pointer
>> drivers/media/dvb-frontends/drxd_hard.c:1038:69: warning: Using plain
>> integer as NULL pointer
>> drivers/media/dvb-frontends/drxd_hard.c:2836:33: warning: Using plain
>> integer as NULL pointer
>> drivers/media/dvb-frontends/drxd_hard.c:2972:30: warning: Using plain
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
>>   drivers/media/dvb-frontends/drxd_hard.c | 8 ++++----
>>   1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/media/dvb-frontends/drxd_hard.c
>> b/drivers/media/dvb-frontends/drxd_hard.c
>> index cbd7c92..959ae36 100644
>> --- a/drivers/media/dvb-frontends/drxd_hard.c
>> +++ b/drivers/media/dvb-frontends/drxd_hard.c
>> @@ -1014,7 +1014,7 @@ static int HI_CfgCommand(struct drxd_state *state)
>>                 status = Write16(state, HI_RA_RAM_SRV_CMD__A,
>>                                  HI_RA_RAM_SRV_CMD_CONFIG, 0);
>>         else
>> -               status = HI_Command(state, HI_RA_RAM_SRV_CMD_CONFIG, 0);
>> +               status = HI_Command(state, HI_RA_RAM_SRV_CMD_CONFIG,
>> NULL);
>>         mutex_unlock(&state->mutex);
>>         return status;
>>   }
>> @@ -1035,7 +1035,7 @@ static int HI_ResetCommand(struct drxd_state *state)
>>         status = Write16(state, HI_RA_RAM_SRV_RST_KEY__A,
>>                          HI_RA_RAM_SRV_RST_KEY_ACT, 0);
>>         if (status == 0)
>> -               status = HI_Command(state, HI_RA_RAM_SRV_CMD_RESET, 0);
>> +               status = HI_Command(state, HI_RA_RAM_SRV_CMD_RESET, NULL);
>>         mutex_unlock(&state->mutex);
>>         msleep(1);
>>         return status;
>> @@ -2833,7 +2833,7 @@ static int drxd_init(struct dvb_frontend *fe)
>>         int err = 0;
>>
>>   /*    if (request_firmware(&state->fw, "drxd.fw", state->dev)<0) */
>> -       return DRXD_init(state, 0, 0);
>> +       return DRXD_init(state, NULL, 0);
>>
>>         err = DRXD_init(state, state->fw->data, state->fw->size);
>>         release_firmware(state->fw);
>> @@ -2969,7 +2969,7 @@ struct dvb_frontend *drxd_attach(const struct
>> drxd_config *config,
>>
>>         mutex_init(&state->mutex);
>>
>> -       if (Read16(state, 0, 0, 0) < 0)
>> +       if (Read16(state, 0, NULL, 0) < 0)
>>                 goto error;
>>
>>         state->frontend.ops = drxd_ops;
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
