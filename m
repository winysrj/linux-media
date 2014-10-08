Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:21530 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaJHQEb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Oct 2014 12:04:31 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0ND400L0AVBINI70@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 08 Oct 2014 12:04:30 -0400 (EDT)
Date: Wed, 08 Oct 2014 13:04:26 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: tskd08@gmail.com
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 4/4] v4l-utils/dvbv5-scan: add support for ISDB-S scanning
Message-id: <20141008130426.792d7bb7.m.chehab@samsung.com>
In-reply-to: <1412770181-5420-5-git-send-email-tskd08@gmail.com>
References: <1412770181-5420-1-git-send-email-tskd08@gmail.com>
 <1412770181-5420-5-git-send-email-tskd08@gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 08 Oct 2014 21:09:41 +0900
tskd08@gmail.com escreveu:

> From: Akihiro Tsukada <tskd08@gmail.com>
> 
> Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
> ---
>  utils/dvb/dvb-format-convert.c |  3 ++-
>  utils/dvb/dvbv5-scan.c         | 14 ++++++++++++++
>  2 files changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/utils/dvb/dvb-format-convert.c b/utils/dvb/dvb-format-convert.c
> index 4f0e075..bf37945 100644
> --- a/utils/dvb/dvb-format-convert.c
> +++ b/utils/dvb/dvb-format-convert.c
> @@ -125,7 +125,8 @@ int main(int argc, char **argv)
>  		fprintf(stderr, "ERROR: Please specify a valid output file\n");
>  		missing = 1;
>  	} else if (((args.input_format == FILE_ZAP) ||
> -		   (args.output_format == FILE_ZAP)) && args.delsys <= 0) {
> +		   (args.output_format == FILE_ZAP)) &&
> +		   (args.delsys <= 0 || args.delsys == SYS_ISDBS)) {
>  		fprintf(stderr, "ERROR: Please specify a valid delivery system for ZAP format\n");
>  		missing = 1;
>  	}
> diff --git a/utils/dvb/dvbv5-scan.c b/utils/dvb/dvbv5-scan.c
> index cdc82ec..0ef95f3 100644
> --- a/utils/dvb/dvbv5-scan.c
> +++ b/utils/dvb/dvbv5-scan.c
> @@ -251,6 +251,16 @@ static int run_scan(struct arguments *args,
>  		if (dvb_retrieve_entry_prop(entry, DTV_POLARIZATION, &pol))
>  			pol = POLARIZATION_OFF;
>  
> +		if (parms->current_sys == SYS_ISDBS) {
> +			uint32_t tsid = 0;
> +
> +			dvb_store_entry_prop(entry, DTV_POLARIZATION, POLARIZATION_R);
> +
> +			dvb_retrieve_entry_prop(entry, DTV_STREAM_ID, &tsid);
> +			if (!dvb_new_ts_is_needed(dvb_file->first_entry, entry,
> +						  freq, shift, tsid))
> +				continue;

This is likely needed for DVB-T2 and DVB-S2 too.

> +		} else
>  		if (!dvb_new_freq_is_needed(dvb_file->first_entry, entry,
>  					    freq, pol, shift))

Just coding style:
		} else if (!dvb_new_freq_is_needed(dvb_file->first_entry, entry,
  					    freq, pol, shift))

We use the same coding style here as the one defined at the Kernel.

>  			continue;
> @@ -258,6 +268,10 @@ static int run_scan(struct arguments *args,
>  		count++;
>  		dvb_log("Scanning frequency #%d %d", count, freq);
>  
> +		if (!args->lnb_name && entry->lnb &&
> +		    (!parms->lnb || strcasecmp(entry->lnb, parms->lnb->alias)))

Shouldn't it be: !strcasecmp(entry->lnb, parms->lnb->alias)? Or maybe just
remove this test.

> +			parms->lnb = dvb_sat_get_lnb(dvb_sat_search_lnb(entry->lnb));
> +
>  		/*
>  		 * Run the scanning logic
>  		 */

Regards,
Mauro
