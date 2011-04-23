Return-path: <mchehab@pedra>
Received: from cmsout01.mbox.net ([165.212.64.31]:45688 "EHLO
	cmsout01.mbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268Ab1DWTc7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Apr 2011 15:32:59 -0400
Message-ID: <4DB32946.1080803@usa.net>
Date: Sat, 23 Apr 2011 21:32:22 +0200
From: Issa Gorissen <flop.m@usa.net>
MIME-Version: 1.0
To: Lutz Sammer <johns98@gmx.net>
CC: linux-media@vger.kernel.org
Subject: [PATCH] Fixes stb0899 not locking
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

> Fixes stb0899 not locking.

> See http://www.spinics.net/lists/linux-media/msg30486.html ...
>
> When stb0899_check_data is entered, it could happen, that the data is
> already locked and the data search looped.  stb0899_check_data fails to
> lock on a good frequency.  stb0899_search_data uses an extrem big search
> step and fails to lock.
>
> The new code checks for lock before starting a new search.
> The first read ignores the loop bit, for the case that the loop bit is
> set during the search setup.  I also added the msleep to reduce the
> traffic on the i2c bus.
>
> Johns
>
> Signed-off-by: Lutz Sammer <johns98 <at> gmx.net>
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

Hi Johns,

I've tried your path but I had to remove the last } that you added after
the msleep(1);

The patch had not make any better the tuning of transponders on HB13E
for me.

Thanks anyway.
--
Issa

