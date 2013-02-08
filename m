Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33289 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946899Ab3BHTkv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Feb 2013 14:40:51 -0500
Message-ID: <5115549B.80106@iki.fi>
Date: Fri, 08 Feb 2013 21:40:11 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Michael Krufky <mkrufky@linuxtv.org>
CC: linux-media@vger.kernel.org, linuxtv-commits@linuxtv.org,
	Jose Alberto Reguero <jareguero@telefonica.net>
Subject: Re: [git:v4l-dvb/for_v3.9] [media] [PATH, 1/2] mxl5007 move reset
 to attach
References: <E1U3sYh-0001KV-Eo@www.linuxtv.org> <CAOcJUbyOQKFvaGfBFb9w3nZeg-428EeYGw2gvAfDAdhRswtonQ@mail.gmail.com>
In-Reply-To: <CAOcJUbyOQKFvaGfBFb9w3nZeg-428EeYGw2gvAfDAdhRswtonQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Could you explain what is wrong with that patch?

Antti

On 02/08/2013 09:23 PM, Michael Krufky wrote:
> Mauro,
>
> This isn't ready for merge yet.  Please revert it.  This needs more
> work as I explained on the mailing list.
>
> -Mike Krufky
>
> On Fri, Feb 8, 2013 at 12:37 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> This is an automatic generated email to let you know that the following patch were queued at the
>> http://git.linuxtv.org/media_tree.git tree:
>>
>> Subject: [media] [PATH,1/2] mxl5007 move reset to attach
>> Author:  Jose Alberto Reguero <jareguero@telefonica.net>
>> Date:    Sun Feb 3 18:30:38 2013 -0300
>>
>> This patch move the soft reset to the attach function because with dual
>> tuners, when one tuner do reset, the other one is perturbed, and the
>> stream has errors.
>>
>> Signed-off-by: Jose Alberto Reguero <jareguero@telefonica.net>
>> Reviewed-by: Antti Palosaari <crope@iki.fi>
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>>
>>   drivers/media/tuners/mxl5007t.c |   17 +++++++++++++----
>>   1 files changed, 13 insertions(+), 4 deletions(-)
>>
>> ---
>>
>> http://git.linuxtv.org/media_tree.git?a=commitdiff;h=0a3237704dec476be3cdfbe8fc9df9cc65b14442
>>
>> diff --git a/drivers/media/tuners/mxl5007t.c b/drivers/media/tuners/mxl5007t.c
>> index 69e453e..eb61304 100644
>> --- a/drivers/media/tuners/mxl5007t.c
>> +++ b/drivers/media/tuners/mxl5007t.c
>> @@ -531,10 +531,6 @@ static int mxl5007t_tuner_init(struct mxl5007t_state *state,
>>          struct reg_pair_t *init_regs;
>>          int ret;
>>
>> -       ret = mxl5007t_soft_reset(state);
>> -       if (mxl_fail(ret))
>> -               goto fail;
>> -
>>          /* calculate initialization reg array */
>>          init_regs = mxl5007t_calc_init_regs(state, mode);
>>
>> @@ -900,7 +896,20 @@ struct dvb_frontend *mxl5007t_attach(struct dvb_frontend *fe,
>>                  /* existing tuner instance */
>>                  break;
>>          }
>> +
>> +       if (fe->ops.i2c_gate_ctrl)
>> +               fe->ops.i2c_gate_ctrl(fe, 1);
>> +
>> +       ret = mxl5007t_soft_reset(state);
>> +
>> +       if (fe->ops.i2c_gate_ctrl)
>> +               fe->ops.i2c_gate_ctrl(fe, 0);
>> +
>> +       if (mxl_fail(ret))
>> +               goto fail;
>> +
>>          fe->tuner_priv = state;
>> +
>>          mutex_unlock(&mxl5007t_list_mutex);
>>
>>          memcpy(&fe->ops.tuner_ops, &mxl5007t_tuner_ops,
>>
>> _______________________________________________
>> linuxtv-commits mailing list
>> linuxtv-commits@linuxtv.org
>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linuxtv-commits


-- 
http://palosaari.fi/
