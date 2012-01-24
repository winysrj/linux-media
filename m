Return-path: <linux-media-owner@vger.kernel.org>
Received: from racoon.tvdr.de ([188.40.50.18]:48718 "EHLO racoon.tvdr.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754642Ab2AXJeC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jan 2012 04:34:02 -0500
Received: from dolphin.tvdr.de (dolphin.tvdr.de [192.168.100.2])
	by racoon.tvdr.de (8.14.3/8.14.3) with ESMTP id q0O9YD3J006218
	for <linux-media@vger.kernel.org>; Tue, 24 Jan 2012 10:34:14 +0100
Received: from [192.168.100.10] (hawk.tvdr.de [192.168.100.10])
	by dolphin.tvdr.de (8.14.4/8.14.4) with ESMTP id q0O9XrTa010973
	for <linux-media@vger.kernel.org>; Tue, 24 Jan 2012 10:33:54 +0100
Message-ID: <4F1E7B01.2050602@tvdr.de>
Date: Tue, 24 Jan 2012 10:33:53 +0100
From: Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [linux-media] Re: [PATCH] stb0899: fix the limits for signal
 strength values
References: <4F18555D.3000205@tvdr.de> <4F1DB873.20206@redhat.com>
In-Reply-To: <4F1DB873.20206@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------020705030101040801010701"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020705030101040801010701
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 23.01.2012 20:43, Mauro Carvalho Chehab wrote:
> Hi Klaus,
>
> The patch didn't apply. It seems to be due to your emailer that mangled the
> whitespaces.

Sorry about that. Here it is again as an attachment.

> The patch looks correct on my eyes. Yet, I'd like to have Manu's ack on it.
>
> Em 19-01-2012 15:39, Klaus Schmidinger escreveu:
>> stb0899_read_signal_strength() adds an offset to the result of the table lookup.
>> That offset must correspond to the lowest value in the lookup table, to make sure
>> the result doesn't get below 0, which would mean a "very high" value since the
>> parameter is unsigned.
>> 'strength' and 'snr' need to be initialized to 0 to make sure they have a
>> defined result in case there is no "internal->lock".
>>
>> Signed-off-by: Klaus Schmidinger<Klaus.Schmidinger@tvdr.de>
>>
>> --- a/linux/drivers/media/dvb/frontends/stb0899_drv.c   2011-06-11 16:54:32.000000000 +0200
>> +++ b/linux/drivers/media/dvb/frontends/stb0899_drv.c   2011-06-11 16:23:00.000000000 +0200
>> @@ -67,7 +67,7 @@
>>    * Crude linear extrapolation below -84.8dBm and above -8.0dBm.
>>    */
>>   static const struct stb0899_tab stb0899_dvbsrf_tab[] = {
>> -       { -950, -128 },
>> +       { -750, -128 },
>>          { -748,  -94 },
>>          { -745,  -92 },
>>          { -735,  -90 },
>> @@ -131,7 +131,7 @@
>>          { -730, 13645 },
>>          { -750, 13909 },
>>          { -766, 14153 },
>> -       { -999, 16383 }
>> +       { -950, 16383 }
>>   };
>>
>>   /* DVB-S2 Es/N0 quant in dB/100 vs read value * 100*/
>> @@ -964,6 +964,7 @@
>>
>>          int val;
>>          u32 reg;
>> +       *strength = 0;
>
> This is not needed, as strength is not initialized only on invalid delivery systems,
> where -EINVAL is returned.

What about the 'if' conditions within the valid delivery system cases?
For instance

         case SYS_DSS:
                 if (internal->lock) {
                         ...
                         if (STB0899_GETFIELD(VSTATUS_LOCKEDVIT, reg)) {
                            ...
                                 *strength = ...
                         }
                 }
                 break;

So there may be cases where strength has an undefined value, even
if this function returns 0.

>>          switch (state->delsys) {
>>          case SYS_DVBS:
>>          case SYS_DSS:
>> @@ -987,7 +988,7 @@
>>                          val = STB0899_GETFIELD(IF_AGC_GAIN, reg);
>>
>>                          *strength = stb0899_table_lookup(stb0899_dvbs2rf_tab, ARRAY_SIZE(stb0899_dvbs2rf_tab) - 1, val);
>> -                       *strength += 750;
>> +                       *strength += 950;
>>                          dprintk(state->verbose, FE_DEBUG, 1, "IF_AGC_GAIN = 0x%04x, C = %d * 0.1 dBm",
>>                                  val&  0x3fff, *strength);
>>                  }
>> @@ -1009,6 +1010,7 @@
>>          u8 buf[2];
>>          u32 reg;
>>
>> +       *snr = 0;
>
> This is not needed, as strength is not initialized only on invalid delivery systems,
> where -EINVAL is returned.

See above.

>>          reg  = stb0899_read_reg(state, STB0899_VSTATUS);
>>          switch (state->delsys) {
>>          case SYS_DVBS:
>
> PS.: Another alternative for it would be the enclosed patch,
> wich will be a little simpler, and will also preserve the slope
> on the boundary values, used at the stb0899_table_lookup()
> interpolation logic.

Well, as long as there are no negative values for strength...
However, I don't quite see why the range is 750 - 950 for DVB-S
and 750 - 999 for DVB-S2. Shouldn't this be the same maximum
value in both cases?

Klaus

> [PATCH] stb0899: fix the limits for signal strength values
>
> The current minimal measures for strengh is 750 - 950, for table
> stb0899_dvbsrf_tab[], and 750 - 999, for stb0899_dvbs2rf_tab[].
> Both are negative values. However, the strength measure is unsigned.
>
> Don't allow negative values for strengh to underflow. Instead,
> shift the scale, in order to have 0 as the lowest strength.
>
> Signed-off-by: Mauro Carvalho Chehab<mchehab@redhat.com>
>
> diff --git a/drivers/media/dvb/frontends/stb0899_drv.c b/drivers/media/dvb/frontends/stb0899_drv.c
> index 38565be..9cfdcb2 100644
> --- a/drivers/media/dvb/frontends/stb0899_drv.c
> +++ b/drivers/media/dvb/frontends/stb0899_drv.c
> @@ -975,7 +975,7 @@ static int stb0899_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
>   				val = (s32)(s8)STB0899_GETFIELD(AGCIQVALUE, reg);
>
>   				*strength = stb0899_table_lookup(stb0899_dvbsrf_tab, ARRAY_SIZE(stb0899_dvbsrf_tab) - 1, val);
> -				*strength += 750;
> +				*strength += 950;
>   				dprintk(state->verbose, FE_DEBUG, 1, "AGCIQVALUE = 0x%02x, C = %d * 0.1 dBm",
>   					val&  0xff, *strength);
>   			}
> @@ -987,7 +987,7 @@ static int stb0899_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
>   			val = STB0899_GETFIELD(IF_AGC_GAIN, reg);
>
>   			*strength = stb0899_table_lookup(stb0899_dvbs2rf_tab, ARRAY_SIZE(stb0899_dvbs2rf_tab) - 1, val);
> -			*strength += 750;
> +			*strength += 999;
>   			dprintk(state->verbose, FE_DEBUG, 1, "IF_AGC_GAIN = 0x%04x, C = %d * 0.1 dBm",
>   				val&  0x3fff, *strength);
>   		}

--------------020705030101040801010701
Content-Type: text/x-patch;
 name="03-stb0899_signal_strength_limits.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="03-stb0899_signal_strength_limits.diff"

stb0899: fix the limits for signal strength values

stb0899_read_signal_strength() adds an offset to the result of the table lookup.
That offset must correspond to the lowest value in the lookup table, to make sure
the result doesn't get below 0, which would mean a "very high" value since the
parameter is unsigned.
'strength' and 'snr' need to be initialized to 0 to make sure they have a
defined result in case there is no "internal->lock".

Signed-off-by: Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>

--- a/linux/drivers/media/dvb/frontends/stb0899_drv.c	2011-06-11 16:54:32.000000000 +0200
+++ b/linux/drivers/media/dvb/frontends/stb0899_drv.c	2011-06-11 16:23:00.000000000 +0200
@@ -67,7 +67,7 @@
  * Crude linear extrapolation below -84.8dBm and above -8.0dBm.
  */
 static const struct stb0899_tab stb0899_dvbsrf_tab[] = {
-	{ -950,	-128 },
+	{ -750,	-128 },
 	{ -748,	 -94 },
 	{ -745,	 -92 },
 	{ -735,	 -90 },
@@ -131,7 +131,7 @@
 	{ -730,	13645 },
 	{ -750,	13909 },
 	{ -766,	14153 },
-	{ -999,	16383 }
+	{ -950,	16383 }
 };
 
 /* DVB-S2 Es/N0 quant in dB/100 vs read value * 100*/
@@ -964,6 +964,7 @@
 
 	int val;
 	u32 reg;
+	*strength = 0;
 	switch (state->delsys) {
 	case SYS_DVBS:
 	case SYS_DSS:
@@ -987,7 +988,7 @@
 			val = STB0899_GETFIELD(IF_AGC_GAIN, reg);
 
 			*strength = stb0899_table_lookup(stb0899_dvbs2rf_tab, ARRAY_SIZE(stb0899_dvbs2rf_tab) - 1, val);
-			*strength += 750;
+			*strength += 950;
 			dprintk(state->verbose, FE_DEBUG, 1, "IF_AGC_GAIN = 0x%04x, C = %d * 0.1 dBm",
 				val & 0x3fff, *strength);
 		}
@@ -1009,6 +1010,7 @@
 	u8 buf[2];
 	u32 reg;
 
+	*snr = 0;
 	reg  = stb0899_read_reg(state, STB0899_VSTATUS);
 	switch (state->delsys) {
 	case SYS_DVBS:

--------------020705030101040801010701--
