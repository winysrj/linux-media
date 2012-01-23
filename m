Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52858 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753974Ab2AWToA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jan 2012 14:44:00 -0500
Message-ID: <4F1DB873.20206@redhat.com>
Date: Mon, 23 Jan 2012 17:43:47 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>
CC: linux-media@vger.kernel.org, Manu Abraham <abraham.manu@gmail.com>
Subject: Re: [PATCH] stb0899: fix the limits for signal strength values
References: <4F18555D.3000205@tvdr.de>
In-Reply-To: <4F18555D.3000205@tvdr.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Klaus,

The patch didn't apply. It seems to be due to your emailer that mangled the
whitespaces. 

The patch looks correct on my eyes. Yet, I'd like to have Manu's ack on it.

Em 19-01-2012 15:39, Klaus Schmidinger escreveu:
> stb0899_read_signal_strength() adds an offset to the result of the table lookup.
> That offset must correspond to the lowest value in the lookup table, to make sure
> the result doesn't get below 0, which would mean a "very high" value since the
> parameter is unsigned.
> 'strength' and 'snr' need to be initialized to 0 to make sure they have a
> defined result in case there is no "internal->lock".
> 
> Signed-off-by: Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>
> 
> --- a/linux/drivers/media/dvb/frontends/stb0899_drv.c   2011-06-11 16:54:32.000000000 +0200
> +++ b/linux/drivers/media/dvb/frontends/stb0899_drv.c   2011-06-11 16:23:00.000000000 +0200
> @@ -67,7 +67,7 @@
>   * Crude linear extrapolation below -84.8dBm and above -8.0dBm.
>   */
>  static const struct stb0899_tab stb0899_dvbsrf_tab[] = {
> -       { -950, -128 },
> +       { -750, -128 },
>         { -748,  -94 },
>         { -745,  -92 },
>         { -735,  -90 },
> @@ -131,7 +131,7 @@
>         { -730, 13645 },
>         { -750, 13909 },
>         { -766, 14153 },
> -       { -999, 16383 }
> +       { -950, 16383 }
>  };
> 
>  /* DVB-S2 Es/N0 quant in dB/100 vs read value * 100*/
> @@ -964,6 +964,7 @@
> 
>         int val;
>         u32 reg;
> +       *strength = 0;

This is not needed, as strength is not initialized only on invalid delivery systems,
where -EINVAL is returned.

>         switch (state->delsys) {
>         case SYS_DVBS:
>         case SYS_DSS:
> @@ -987,7 +988,7 @@
>                         val = STB0899_GETFIELD(IF_AGC_GAIN, reg);
> 
>                         *strength = stb0899_table_lookup(stb0899_dvbs2rf_tab, ARRAY_SIZE(stb0899_dvbs2rf_tab) - 1, val);
> -                       *strength += 750;
> +                       *strength += 950;
>                         dprintk(state->verbose, FE_DEBUG, 1, "IF_AGC_GAIN = 0x%04x, C = %d * 0.1 dBm",
>                                 val & 0x3fff, *strength);
>                 }
> @@ -1009,6 +1010,7 @@
>         u8 buf[2];
>         u32 reg;
> 
> +       *snr = 0;

This is not needed, as strength is not initialized only on invalid delivery systems,
where -EINVAL is returned.


>         reg  = stb0899_read_reg(state, STB0899_VSTATUS);
>         switch (state->delsys) {
>         case SYS_DVBS:

PS.: Another alternative for it would be the enclosed patch,
wich will be a little simpler, and will also preserve the slope 
on the boundary values, used at the stb0899_table_lookup()
interpolation logic.

Regards,
Mauro

-

[PATCH] stb0899: fix the limits for signal strength values

The current minimal measures for strengh is 750 - 950, for table
stb0899_dvbsrf_tab[], and 750 - 999, for stb0899_dvbs2rf_tab[].
Both are negative values. However, the strength measure is unsigned.

Don't allow negative values for strengh to underflow. Instead,
shift the scale, in order to have 0 as the lowest strength.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/frontends/stb0899_drv.c b/drivers/media/dvb/frontends/stb0899_drv.c
index 38565be..9cfdcb2 100644
--- a/drivers/media/dvb/frontends/stb0899_drv.c
+++ b/drivers/media/dvb/frontends/stb0899_drv.c
@@ -975,7 +975,7 @@ static int stb0899_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
 				val = (s32)(s8)STB0899_GETFIELD(AGCIQVALUE, reg);
 
 				*strength = stb0899_table_lookup(stb0899_dvbsrf_tab, ARRAY_SIZE(stb0899_dvbsrf_tab) - 1, val);
-				*strength += 750;
+				*strength += 950;
 				dprintk(state->verbose, FE_DEBUG, 1, "AGCIQVALUE = 0x%02x, C = %d * 0.1 dBm",
 					val & 0xff, *strength);
 			}
@@ -987,7 +987,7 @@ static int stb0899_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
 			val = STB0899_GETFIELD(IF_AGC_GAIN, reg);
 
 			*strength = stb0899_table_lookup(stb0899_dvbs2rf_tab, ARRAY_SIZE(stb0899_dvbs2rf_tab) - 1, val);
-			*strength += 750;
+			*strength += 999;
 			dprintk(state->verbose, FE_DEBUG, 1, "IF_AGC_GAIN = 0x%04x, C = %d * 0.1 dBm",
 				val & 0x3fff, *strength);
 		}


