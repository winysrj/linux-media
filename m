Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:56113 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758009Ab1FAPAx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Jun 2011 11:00:53 -0400
Message-ID: <4DE65418.1050508@redhat.com>
Date: Wed, 01 Jun 2011 12:00:40 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Lutz Sammer <johns98@gmx.net>
CC: linux-media@vger.kernel.org, Manu Abraham <abraham.manu@gmail.com>
Subject: Re: [PATCH] stb0899: Fix not locking DVB-S transponder
References: <4DC135E5.40805@gmx.net>
In-Reply-To: <4DC135E5.40805@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Manu,

Please review.

Lutz,

scripts/checkpatch.pl complains about a few bad style used on your patches:

ERROR: space prohibited after that open parenthesis '('
#42: FILE: drivers/media/dvb/frontends/stb0899_algo.c:343:
+	if ( !lock ) {

ERROR: space prohibited before that close parenthesis ')'
#42: FILE: drivers/media/dvb/frontends/stb0899_algo.c:343:
+	if ( !lock ) {

WARNING: msleep < 20ms can sleep for up to 20ms; see Documentation/timers/timers-howto.txt
+		msleep(1);
WARNING: line over 80 characters
#90: FILE: drivers/media/dvb/frontends/stb0899_algo.c:365:
+		stb0899_write_reg(state, STB0899_DSTATUS2, 0x00); /* force search loop	*/

WARNING: line over 80 characters
#92: FILE: drivers/media/dvb/frontends/stb0899_algo.c:367:
+			/* WARNING! VIT LOCKED has to be tested before VIT_END_LOOOP	*/

ERROR: trailing whitespace
#96: FILE: drivers/media/dvb/frontends/stb0899_algo.c:371:
+^I$

WARNING: msleep < 20ms can sleep for up to 20ms; see Documentation/timers/timers-howto.txt
+			msleep(1);
total: 3 errors, 4 warnings, 69 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

The warnings are trivial. I can fix it when applying it, after having Manu's
ack on that patch, but the better is for you to always check your patches with
checkpatch.pl.


Em 04-05-2011 08:17, Lutz Sammer escreveu:
> stb0899: Fix not locking DVB-S transponder
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
> Resend, last version seems to be broken by email-client.
> 
> Johns
> 
> Signed-off-by: Lutz Sammer <johns98@gmx.net>
> 
> 
> stb0899_not_locking_fix.diff
> 
> 
> diff --git a/drivers/media/dvb/frontends/stb0899_algo.c b/drivers/media/dvb/frontends/stb0899_algo.c
> index 2da55ec..55f0c4e 100644
> --- a/drivers/media/dvb/frontends/stb0899_algo.c
> +++ b/drivers/media/dvb/frontends/stb0899_algo.c
> @@ -338,36 +338,42 @@ static enum stb0899_status stb0899_check_data(struct stb0899_state *state)
>  	int lock = 0, index = 0, dataTime = 500, loop;
>  	u8 reg;
>  
> -	internal->status = NODATA;
> +	reg = stb0899_read_reg(state, STB0899_VSTATUS);
> +	lock = STB0899_GETFIELD(VSTATUS_LOCKEDVIT, reg);
> +	if ( !lock ) {
>  
> -	/* RESET FEC	*/
> -	reg = stb0899_read_reg(state, STB0899_TSTRES);
> -	STB0899_SETFIELD_VAL(FRESACS, reg, 1);
> -	stb0899_write_reg(state, STB0899_TSTRES, reg);
> -	msleep(1);
> -	reg = stb0899_read_reg(state, STB0899_TSTRES);
> -	STB0899_SETFIELD_VAL(FRESACS, reg, 0);
> -	stb0899_write_reg(state, STB0899_TSTRES, reg);
> +		internal->status = NODATA;
>  
> -	if (params->srate <= 2000000)
> -		dataTime = 2000;
> -	else if (params->srate <= 5000000)
> -		dataTime = 1500;
> -	else if (params->srate <= 15000000)
> -		dataTime = 1000;
> -	else
> -		dataTime = 500;
> -
> -	stb0899_write_reg(state, STB0899_DSTATUS2, 0x00); /* force search loop	*/
> -	while (1) {
> -		/* WARNING! VIT LOCKED has to be tested before VIT_END_LOOOP	*/
> -		reg = stb0899_read_reg(state, STB0899_VSTATUS);
> -		lock = STB0899_GETFIELD(VSTATUS_LOCKEDVIT, reg);
> -		loop = STB0899_GETFIELD(VSTATUS_END_LOOPVIT, reg);
> +		/* RESET FEC	*/
> +		reg = stb0899_read_reg(state, STB0899_TSTRES);
> +		STB0899_SETFIELD_VAL(FRESACS, reg, 1);
> +		stb0899_write_reg(state, STB0899_TSTRES, reg);
> +		msleep(1);
> +		reg = stb0899_read_reg(state, STB0899_TSTRES);
> +		STB0899_SETFIELD_VAL(FRESACS, reg, 0);
> +		stb0899_write_reg(state, STB0899_TSTRES, reg);
>  
> -		if (lock || loop || (index > dataTime))
> -			break;
> -		index++;
> +		if (params->srate <= 2000000)
> +			dataTime = 2000;
> +		else if (params->srate <= 5000000)
> +			dataTime = 1500;
> +		else if (params->srate <= 15000000)
> +			dataTime = 1000;
> +		else
> +			dataTime = 500;
> +
> +		stb0899_write_reg(state, STB0899_DSTATUS2, 0x00); /* force search loop	*/
> +		while (1) {
> +			/* WARNING! VIT LOCKED has to be tested before VIT_END_LOOOP	*/
> +			reg = stb0899_read_reg(state, STB0899_VSTATUS);
> +			lock = STB0899_GETFIELD(VSTATUS_LOCKEDVIT, reg);
> +			loop = STB0899_GETFIELD(VSTATUS_END_LOOPVIT, reg);
> +	
> +			if (lock || (loop && index) || (index > dataTime))
> +				break;
> +			index++;
> +			msleep(1);
> +		}
>  	}
>  
>  	if (lock) {	/* DATA LOCK indicator	*/

