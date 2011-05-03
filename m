Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:46162 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507Ab1ECXQP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 May 2011 19:16:15 -0400
Message-ID: <4DC08CB8.3020105@redhat.com>
Date: Tue, 03 May 2011 20:16:08 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Lutz Sammer <johns98@gmx.net>
CC: linux-media@vger.kernel.org, Manu Abraham <abraham.manu@gmail.com>
Subject: Re: TT-budget S2-3200 cannot tune on HB13E DVBS2 transponder
References: <4DA63A66.1070300@gmx.net>
In-Reply-To: <4DA63A66.1070300@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 13-04-2011 21:05, Lutz Sammer escreveu:
>> On 05/04/11 21:07, Steffen Barszus wrote:
>>> On Tue, 05 Apr 2011 13:00:14 +0200
>>> "Issa Gorissen" <flop.m@xxxxxxx> wrote:
>>>
>>>> Hi,
>>>>
>>>> Eutelsat made a recent migration from DVB-S to DVB-S2 (since
>>>> 31/3/2011) on two transponders on HB13E
>>>>
>>>> - HOT BIRD 6 13� Est TP 159 Freq 11,681 Ghz DVB-S2 FEC 3/4 27500
>>>> Msymb/s 0.2 Pilot off Polar H
>>>>
>>>> - HOT BIRD 9 13� Est TP 99 Freq 12,692 Ghz DVB-S2 FEC 3/4 27500
>>>> Msymb/s 0.2 Pilot off Polar H
>>>>
>>>>
>>>> Before those changes, with my TT S2 3200, I was able to watch TV on
>>>> those transponders. Now, I cannot even tune on those transponders. I
>>>> have tried with scan-s2 and w_scan and the latest drivers from git.
>>>> They both find the transponders but cannot tune onto it.
>>>>
>>>> Something noteworthy is that my other card, a DuoFlex S2 can tune
>>>> fine on those transponders.
>>>>
>>>> My question is; can someone try this as well with a TT S2 3200 and
>>>> post the results ?
>>> i read something about it lately here (german!): 
>>> http://www.vdr-portal.de/board16-video-disk-recorder/board85-hdtv-dvb-s2/p977938-stb0899-fec-3-4-tester-gesucht/#post977938
>>>
>>> It says in stb0899_drv.c function:
>>> static void stb0899_set_iterations(struct stb0899_state *state) 
>>>
>>> This:
>>> reg = STB0899_READ_S2REG(STB0899_S2DEMOD, MAX_ITER);
>>> STB0899_SETFIELD_VAL(MAX_ITERATIONS, reg, iter_scale);
>>> stb0899_write_s2reg(state, STB0899_S2DEMOD, STB0899_BASE_MAX_ITER, STB0899_OFF0_MAX_ITER, reg);
>>>
>>> should be replaced with this:
>>>
>>> reg = STB0899_READ_S2REG(STB0899_S2FEC, MAX_ITER);
>>> STB0899_SETFIELD_VAL(MAX_ITERATIONS, reg, iter_scale);
>>> stb0899_write_s2reg(state, STB0899_S2FEC, STB0899_BASE_MAX_ITER, STB0899_OFF0_MAX_ITER, reg);
>>>
>>> Basically replace STB0899_S2DEMOD with STB0899_S2FEC in this 2 lines
>>> affected.
>>>
>>> Kind Regards 
>>>
>>> Steffen
>> Hi Steffen,
>>
>> Unfortunately, it does not help in my case. Thx anyway.
> 
> Try my locking fix. With above patch I can lock the
> channels without problem.

Can someone confirm that such patch would fix the issue? If so, please
forward it in a way that it could be applied (patch is currently line-wrapped),
and submit with some comments/description and your SOB.

As the patch is currently broken, I'm just marking it as rejected at patchwork.

Manu,

Please take a look on this trouble report.

Thanks!
Mauro.

> 
> Johns
> 
> diff --git a/drivers/media/dvb/frontends/stb0899_algo.c
> b/drivers/media/dvb/frontends/stb0899_algo.c
> index 2da55ec..55f0c4e 100644
> --- a/drivers/media/dvb/frontends/stb0899_algo.c
> +++ b/drivers/media/dvb/frontends/stb0899_algo.c
> @@ -338,36 +338,42 @@ static enum stb0899_status
> stb0899_check_data(struct stb0899_state *state)
>         int lock = 0, index = 0, dataTime = 500, loop;
>         u8 reg;
> 
> -       internal->status = NODATA;
> +       reg = stb0899_read_reg(state, STB0899_VSTATUS);
> +       lock = STB0899_GETFIELD(VSTATUS_LOCKEDVIT, reg);
> +       if ( !lock ) {
> 
> -       /* RESET FEC    */
> -       reg = stb0899_read_reg(state, STB0899_TSTRES);
> -       STB0899_SETFIELD_VAL(FRESACS, reg, 1);
> -       stb0899_write_reg(state, STB0899_TSTRES, reg);
> -       msleep(1);
> -       reg = stb0899_read_reg(state, STB0899_TSTRES);
> -       STB0899_SETFIELD_VAL(FRESACS, reg, 0);
> -       stb0899_write_reg(state, STB0899_TSTRES, reg);
> +               internal->status = NODATA;
> 
> -       if (params->srate <= 2000000)
> -               dataTime = 2000;
> -       else if (params->srate <= 5000000)
> -               dataTime = 1500;
> -       else if (params->srate <= 15000000)
> -               dataTime = 1000;
> -       else
> -               dataTime = 500;
> -
> -       stb0899_write_reg(state, STB0899_DSTATUS2, 0x00); /* force
> search loop  */
> -       while (1) {
> -               /* WARNING! VIT LOCKED has to be tested before
> VIT_END_LOOOP    */
> -               reg = stb0899_read_reg(state, STB0899_VSTATUS);
> -               lock = STB0899_GETFIELD(VSTATUS_LOCKEDVIT, reg);
> -               loop = STB0899_GETFIELD(VSTATUS_END_LOOPVIT, reg);
> +               /* RESET FEC    */
> +               reg = stb0899_read_reg(state, STB0899_TSTRES);
> +               STB0899_SETFIELD_VAL(FRESACS, reg, 1);
> +               stb0899_write_reg(state, STB0899_TSTRES, reg);
> +               msleep(1);
> +               reg = stb0899_read_reg(state, STB0899_TSTRES);
> +               STB0899_SETFIELD_VAL(FRESACS, reg, 0);
> +               stb0899_write_reg(state, STB0899_TSTRES, reg);
> 
> -               if (lock || loop || (index > dataTime))
> -                       break;
> -               index++;
> +                       msleep(1);
> +               }
>         }
> 
>         if (lock) {     /* DATA LOCK indicator  */
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

