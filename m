Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:57105
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752296AbdCECnc (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 4 Mar 2017 21:43:32 -0500
Date: Sat, 4 Mar 2017 23:43:25 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Bill Murphy <gc2majortom@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] dvb-sat: add support for North American Standard Ku LNB
 This is the standard LNB used in North America. It is designed with L.O.
 Freq of 10750 MHz. Intended for the North American FSS Ku Band, 11700 to
 12200 MHz.
Message-ID: <20170304234325.04853137@vento.lan>
In-Reply-To: <1488676171-11800-1-git-send-email-gc2majortom@gmail.com>
References: <1488676171-11800-1-git-send-email-gc2majortom@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat,  4 Mar 2017 20:09:31 -0500
Bill Murphy <gc2majortom@gmail.com> escreveu:

> Signed-off-by: Bill Murphy <gc2majortom@gmail.com>
> ---
>  lib/libdvbv5/dvb-sat.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/lib/libdvbv5/dvb-sat.c b/lib/libdvbv5/dvb-sat.c
> index 59cb7a6..acac73a 100644
> --- a/lib/libdvbv5/dvb-sat.c
> +++ b/lib/libdvbv5/dvb-sat.c
> @@ -113,6 +113,19 @@ static const struct dvb_sat_lnb_priv lnb[] = {
>  		},
>  	}, {
>  		.desc = {
> +			.name = N_("Standard, North America"),
> +			.alias = "NA STANDARD",
> +			// Legacy fields - kept just to avoid API/ABI breakages
> +			.lowfreq = ,
> +			.freqrange = {
> +				{ 11700, 12200 }
> +			},
> +		},
> +		.freqrange = {
> +			{ 11700, 12200, 10750, 0 }
> +		},
> +	}, {
> +		.desc = {
>  			.name = N_("L10700"),
>  			.alias = "L10700",
>  			// Legacy fields - kept just to avoid API/ABI breakages


The patch it self looks good. The only thing that I'm not comfortable is
the name of the LNBf, as "STANDARD" means that it was standardized by
some telecommunications organism.

A quick google seek for "lnbf ku band united states" pointed to this site:
	http://www.galaxy-marketing.com/ku_band_lnbf.htm

With describes different models for K-band satellites within North America
and United States. I might be wrong, but it doesn't seem that someone
standardized it.

Instead, it seems to be a de-facto standard made by the hardware
industry, and that not every single LNBf used there follows it, as
some of them use different LO frequencies.

Anyway, if this was standardized by some organism, the better would
be to name it after such organism, e. g. supposing that this was
standardized by ATSC as "type 1", it could be called as
"ATSC type 1".

Otherwise, would be better to name it with something like
"North America LO10750", in order to reduce possible future
conflicts as we need to add more LNBf for US there.


Thanks,
Mauro
