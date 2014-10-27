Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:57168 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965AbaJ0OiW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Oct 2014 10:38:22 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NE300CDIXZXQT60@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 27 Oct 2014 10:38:21 -0400 (EDT)
Date: Mon, 27 Oct 2014 12:38:17 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: tskd08@gmail.com
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 2/7] v4l-utils/libdvbv5: add support for ISDB-S tuning
Message-id: <20141027123817.3e13030f.m.chehab@samsung.com>
In-reply-to: <1414323983-15996-3-git-send-email-tskd08@gmail.com>
References: <1414323983-15996-1-git-send-email-tskd08@gmail.com>
 <1414323983-15996-3-git-send-email-tskd08@gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 26 Oct 2014 20:46:18 +0900
tskd08@gmail.com escreveu:

> From: Akihiro Tsukada <tskd08@gmail.com>
> 
> Added LNB support for Japanese satellites.
> Currently tested with dvbv5-zap, dvb-fe-tool.
> At least the charset conversion and the parser of
> extended event descriptors are not implemented now,
> as they require some ISDB-S(/T) specific modification.

Patch looks OK. You just forgot to add your Signed-off-by :)

We also use SOBs for the library, just like the Kernel.

Could you please send your SOBs for the patches on this series?

Thanks!
Mauro

> ---
>  lib/libdvbv5/dvb-sat.c    | 9 +++++++++
>  lib/libdvbv5/dvb-v5-std.c | 4 ----
>  2 files changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/lib/libdvbv5/dvb-sat.c b/lib/libdvbv5/dvb-sat.c
> index e8df06b..010aebe 100644
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
> +			{ 11710, 12751 }
> +		}
>  	},
>  };
>  
> @@ -304,6 +311,8 @@ static int dvbsat_diseqc_set_input(struct dvb_v5_fe_parms_priv *parms,
>  		 */
>  		pol_v = 0;
>  		high_band = 1;
> +		if (parms->p.current_sys == SYS_ISDBS)
> +			vol_high = 1;
>  	} else {
>  		/* Adjust voltage/tone accordingly */
>  		if (parms->p.sat_number < 2) {
> diff --git a/lib/libdvbv5/dvb-v5-std.c b/lib/libdvbv5/dvb-v5-std.c
> index 871de95..50365cb 100644
> --- a/lib/libdvbv5/dvb-v5-std.c
> +++ b/lib/libdvbv5/dvb-v5-std.c
> @@ -154,11 +154,7 @@ const unsigned int sys_turbo_props[] = {
>  
>  const unsigned int sys_isdbs_props[] = {
>  	DTV_FREQUENCY,
> -	DTV_INVERSION,
> -	DTV_SYMBOL_RATE,
> -	DTV_INNER_FEC,
>  	DTV_STREAM_ID,
> -	DTV_POLARIZATION,
>  	0
>  };
>  
