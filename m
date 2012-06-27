Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:35393 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757339Ab2F0P1P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jun 2012 11:27:15 -0400
Received: by wibhm11 with SMTP id hm11so5449203wib.1
        for <linux-media@vger.kernel.org>; Wed, 27 Jun 2012 08:27:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHFNz9JdJYmpYyvwDwzdJ4Arw5PR9vpJDBnc-oh-CdO5fANMVg@mail.gmail.com>
References: <E1Sjr0W-0006Pc-Bz@www.linuxtv.org>
	<CAHFNz9JdJYmpYyvwDwzdJ4Arw5PR9vpJDBnc-oh-CdO5fANMVg@mail.gmail.com>
Date: Wed, 27 Jun 2012 12:27:13 -0300
Message-ID: <CA+MoWDpSF8EHbpMdXS=1JbqhMqDn9Z59CNrzDJ8CYgK0VjR3Xg@mail.gmail.com>
Subject: Re: [git:v4l-dvb/for_v3.6] [media] stv090x: variable 'no_signal' set
 but not used
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linuxtv-commits@linuxtv.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Manu,

On Wed, Jun 27, 2012 at 9:59 AM, Manu Abraham <abraham.manu@gmail.com> wrote:
> Wonderful, instead of ignoring the return value, you ignored the whole
> function
> itself. Most of the demodulator registers are R-M-x registers. The patch
> brings
> in unwanted side-effects of R-M-x.

Sorry for that. I'll send V2 of this patch just ignoring the return
value. Can you please send me some reference about R-M-x registers?

>
> Please revert this patch.
>
> Thanks,
> Manu

Thanks,

Peter

>
>
> On Fri, Jun 22, 2012 at 2:28 AM, Mauro Carvalho Chehab <mchehab@redhat.com>
> wrote:
>>
>> This is an automatic generated email to let you know that the following
>> patch were queued at the
>> http://git.linuxtv.org/media_tree.git tree:
>>
>> Subject: [media] stv090x: variable 'no_signal' set but not used
>> Author:  Peter Senna Tschudin <peter.senna@gmail.com>
>> Date:    Thu Jun 14 13:58:15 2012 -0300
>>
>> Tested by compilation only.
>>
>> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>>
>>  drivers/media/dvb/frontends/stv090x.c |    7 +++----
>>  1 files changed, 3 insertions(+), 4 deletions(-)
>>
>> ---
>>
>>
>> http://git.linuxtv.org/media_tree.git?a=commitdiff;h=59f6a93fae656409042c8a55e8b9088893c40378
>>
>> diff --git a/drivers/media/dvb/frontends/stv090x.c
>> b/drivers/media/dvb/frontends/stv090x.c
>> index d79e69f..d229dba 100644
>> --- a/drivers/media/dvb/frontends/stv090x.c
>> +++ b/drivers/media/dvb/frontends/stv090x.c
>> @@ -3172,7 +3172,7 @@ static enum stv090x_signal_state stv090x_algo(struct
>> stv090x_state *state)
>>        enum stv090x_signal_state signal_state = STV090x_NOCARRIER;
>>        u32 reg;
>>        s32 agc1_power, power_iq = 0, i;
>> -       int lock = 0, low_sr = 0, no_signal = 0;
>> +       int lock = 0, low_sr = 0;
>>
>>        reg = STV090x_READ_DEMOD(state, TSCFGH);
>>        STV090x_SETFIELD_Px(reg, RST_HWARE_FIELD, 1); /* Stop path 1 stream
>> merger */
>> @@ -3411,10 +3411,9 @@ static enum stv090x_signal_state
>> stv090x_algo(struct stv090x_state *state)
>>                        /* Reset the packet Error counter2 */
>>                        if (STV090x_WRITE_DEMOD(state, ERRCTRL2, 0xc1) < 0)
>>                                goto err;
>> -               } else {
>> +               } else
>>                        signal_state = STV090x_NODATA;
>> -                       no_signal = stv090x_chk_signal(state);
>> -               }
>> +
>>        }
>>        return signal_state;
>>
>>
>> _______________________________________________
>> linuxtv-commits mailing list
>> linuxtv-commits@linuxtv.org
>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linuxtv-commits
>
>



-- 
Peter Senna Tschudin
peter.senna@gmail.com
gpg id: 48274C36
