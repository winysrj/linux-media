Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:15117 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593AbaJHN6D (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Oct 2014 09:58:03 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0ND400KAXPGPO040@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 08 Oct 2014 09:58:01 -0400 (EDT)
Date: Wed, 08 Oct 2014 10:57:54 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: tskd08@gmail.com
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/4] v4l-utils/libdvbv5: add support for ISDB-S tuning
Message-id: <20141008105754.5009ff4b.m.chehab@samsung.com>
In-reply-to: <1412770181-5420-3-git-send-email-tskd08@gmail.com>
References: <1412770181-5420-1-git-send-email-tskd08@gmail.com>
 <1412770181-5420-3-git-send-email-tskd08@gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 08 Oct 2014 21:09:39 +0900
tskd08@gmail.com escreveu:

> From: Akihiro Tsukada <tskd08@gmail.com>
> 
> Added LNB support for Japanese satellites.
> Currently tested with dvbv5-zap, dvb-fe-tool.
> 
> Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
> ---
>  lib/libdvbv5/dvb-sat.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/lib/libdvbv5/dvb-sat.c b/lib/libdvbv5/dvb-sat.c
> index e8df06b..70b1021 100644
> --- a/lib/libdvbv5/dvb-sat.c
> +++ b/lib/libdvbv5/dvb-sat.c
> @@ -91,6 +91,13 @@ static const struct dvb_sat_lnb lnb[] = {
>  		.freqrange = {
>  			{ 12200, 12700 }
>  		}
> +	}, {
> +		.name = "Japan 110BS/CS LNBf",
> +		.alias = "110BS",
> +		.lowfreq = 10678,
> +		.freqrange = {
> +			{ 11727, 12731 }
> +		}

Hmm... a quick search for 110BS gave me this datasheet:
	http://www.sesl-sharp.com/Products/pdf/rf201309_e.pdf

Frequencies there are a little broader. If this datasheet is
right, .freqrange should be:
		{ 11710, 12751 }

>  	},
>  };
>  
> @@ -304,6 +311,8 @@ static int dvbsat_diseqc_set_input(struct dvb_v5_fe_parms_priv *parms,
>  		 */
>  		pol_v = 0;
>  		high_band = 1;
> +		if (lnb == &lnb[8])
> +			vol_high = 1;

I don't like the idea of using an index here. It would be easy
to have this broken. 

Also, probably the best would be to add another field and/or a libdvbv5
property to indicate the DiSEqC specific stuff as found in Japan.

What kind of DiSEqC switch are you using (if any)?

>  	} else {
>  		/* Adjust voltage/tone accordingly */
>  		if (parms->p.sat_number < 2) {
> @@ -316,6 +325,8 @@ static int dvbsat_diseqc_set_input(struct dvb_v5_fe_parms_priv *parms,
>  	rc = dvb_fe_sec_voltage(&parms->p, 1, vol_high);
>  	if (rc)
>  		return rc;
> +	if (parms->p.current_sys == SYS_ISDBS)
> +		return 0;

Are you sure that this need is due to ISDB-S, and not due to a
different DiSEqC switch or satellite system arrangement?

>  	if (parms->p.sat_number > 0) {
>  		rc = dvb_fe_sec_tone(&parms->p, SEC_TONE_OFF);
