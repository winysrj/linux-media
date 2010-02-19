Return-path: <linux-media-owner@vger.kernel.org>
Received: from acorn.exetel.com.au ([220.233.0.21]:53942 "EHLO
	acorn.exetel.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118Ab0BSGeB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Feb 2010 01:34:01 -0500
Message-ID: <50541.115.186.195.130.1266559953.squirrel@webmail.exetel.com.au>
In-Reply-To: <4B7E1931.3090007@redhat.com>
References: <33305.64.213.30.2.1259216241.squirrel@webmail.exetel.com.au>
    <2088.115.70.135.213.1262579258.squirrel@webmail.exetel.com.au>
    <1262658469.3054.48.camel@palomino.walls.org>
    <1262661512.3054.67.camel@palomino.walls.org>
    <55306.115.70.135.213.1262748017.squirrel@webmail.exetel.com.au>
    <1262829099.3065.61.camel@palomino.walls.org>
    <1128.115.70.135.213.1262840633.squirrel@webmail.exetel.com.au>
    <6ab2c27e1001070548y1a96f390uc7b7fbd18a78a564@mail.gmail.com>
    <6ab2c27e1001070604m323ccb02g10a8c302c3edee79@mail.gmail.com>
    <6ab2c27e1001070618ud7019b9s69180353010a1c96@mail.gmail.com>
    <6ab2c27e1001070642k4d5bd81cud404fe77bc7a6bc5@mail.gmail.com>
    <1197.115.70.135.213.1262917283.squirrel@webmail.exetel.com.au>
    <4B7E1931.3090007@redhat.com>
Date: Fri, 19 Feb 2010 17:12:33 +1100 (EST)
Subject: Re: [RESEND] Re: DViCO FusionHDTV DVB-T Dual Digital 4 (rev 1)     
           tuning  regression
From: "Robert Lowery" <rglowery@exemail.com.au>
To: "Mauro Carvalho Chehab" <mchehab@redhat.com>
Cc: "Terry Wu" <terrywu2009@gmail.com>,
	"Andy Walls" <awalls@radix.net>,
	"Devin Heitmueller" <dheitmueller@kernellabs.com>,
	"Vincent McIntyre" <vincent.mcintyre@gmail.com>,
	linux-media@vger.kernel.org,
	"Stefan Ringel" <stefan.ringel@arcor.de>,
	"Steven Toth" <stoth@kernellabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Robert Lowery wrote:
>> Mauro's new code does the 500000 offset unconditionally for DTV7 by
>> setting offset = 2250000, not just when the ZARLINK456 or DIBCOM52
>> tables
>> were explicitly selected.  This change is what appears to cause issues
>> for
>> me.
>
> I've reviewed all information and troubles we have with xc3028 tuning,
> including the reports related to newer firmwares for XC3028L. I think
> that the right fix is the one provided on this patch.
>
> Could you all please verify if this patch fixes the issues, without
> causing
> any regression?

Thanks Mauro,  I'll test this ASAP.

I suspect there will still be issues with the "demod + 500" shift in my
scenario as I had to remove this in the past when changing the offset back
to 2750000 or else I could not get a tuning lock.

I'll let you know.

-Rob
>
> Cheers,
> Mauro.
>
> ---
>
> V4L/DVB: tuner-xc2028: fix tuning logic
>
> There's one reported regression in Australia (DTV7) and some
> reported troubles with newer firmwares. Rework the logic to improve
> tuner on those cases.
>
> Thanks-to: Robert Lowery <rglowery@exemail.com.au>
> Thanks-to: Stefan Ringel <stefan.ringel@arcor.de>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>  drivers/media/common/tuners/tuner-xc2028.c |   51
> ++++++++++++++++++++--------
>  1 files changed, 37 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/media/common/tuners/tuner-xc2028.c
> b/drivers/media/common/tuners/tuner-xc2028.c
> index ed50168..eb782a0 100644
> --- a/drivers/media/common/tuners/tuner-xc2028.c
> +++ b/drivers/media/common/tuners/tuner-xc2028.c
> @@ -932,30 +932,49 @@ static int generic_set_freq(struct dvb_frontend *fe,
> u32 freq /* in HZ */,
>  	 * that xc2028 will be in a safe state.
>  	 * Maybe this might also be needed for DTV.
>  	 */
> -	if (new_mode == T_ANALOG_TV)
> +	if (new_mode == T_ANALOG_TV) {
>  		rc = send_seq(priv, {0x00, 0x00});
>
> -	/*
> -	 * Digital modes require an offset to adjust to the
> -	 * proper frequency.
> -	 * Analog modes require offset = 0
> -	 */
> -	if (new_mode == T_DIGITAL_TV) {
> -		/* Sets the offset according with firmware */
> +		/* Analog modes require offset = 0 */
> +	} else {
> +		/*
> +		 * Digital modes require an offset to adjust to the
> +		 * proper frequency. The offset depends on what
> +		 * firmware version is used.
> +		 */
> +
> +		/*
> +		 * Adjust to the center frequency. This is calculated by the
> +		 * formula: offset = 1.25MHz - BW/2
> +		 * For DTV 7/8, the firmware uses BW = 8000, so it needs a
> +		 * further adjustment to get the frequency center on VHF
> +		 */
>  		if (priv->cur_fw.type & DTV6)
>  			offset = 1750000;
>  		else if (priv->cur_fw.type & DTV7)
>  			offset = 2250000;
>  		else	/* DTV8 or DTV78 */
>  			offset = 2750000;
> +		if ((priv->cur_fw.type & DTV78) && freq < 470000000)
> +			offset -= 500000;
>
>  		/*
> -		 * We must adjust the offset by 500kHz  when
> -		 * tuning a 7MHz VHF channel with DTV78 firmware
> -		 * (used in Australia, Italy and Germany)
> +		 * xc3028 additional "magic"
> +		 * Depending on the firmware version, it needs some adjustments
> +		 * to properly centralize the frequency. This seems to be
> +		 * needed to compensate the SCODE table adjustments made by
> +		 * newer firmwares
>  		 */
> -		if ((priv->cur_fw.type & DTV78) && freq < 470000000)
> -			offset -= 500000;
> +
> +		if (priv->firm_version >= 0x0302) {
> +			if (priv->cur_fw.type & DTV7)
> +				offset -= 300000;
> +			else if (type != ATSC) /* DVB @6MHz, DTV 8 and DTV 7/8 */
> +				offset += 200000;
> +		} else {
> +			if (priv->cur_fw.type & DTV7)
> +				offset -= 500000;
> +		}
>  	}
>
>  	div = (freq - offset + DIV / 2) / DIV;
> @@ -1114,7 +1133,11 @@ static int xc2028_set_params(struct dvb_frontend
> *fe,
>
>  	/* All S-code tables need a 200kHz shift */
>  	if (priv->ctrl.demod) {
> -		demod = priv->ctrl.demod + 200;
> +		/*
> +		 * Newer firmwares require a 200 kHz offset only for ATSC
> +		 */
> +		if (type == ATSC || priv->firm_version < 0x0302)
> +			demod = priv->ctrl.demod + 200;
>  		/*
>  		 * The DTV7 S-code table needs a 700 kHz shift.
>  		 * Thanks to Terry Wu <terrywu2009@gmail.com> for reporting this
> --
> 1.6.6.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


