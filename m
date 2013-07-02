Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f177.google.com ([209.85.215.177]:48067 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623Ab3GBS3a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Jul 2013 14:29:30 -0400
Received: by mail-ea0-f177.google.com with SMTP id j14so2914348eak.36
        for <linux-media@vger.kernel.org>; Tue, 02 Jul 2013 11:29:29 -0700 (PDT)
Received: from myon.exnihilo (51-213.60-188.cust.bluewin.ch. [188.60.213.51])
        by mx.google.com with ESMTPSA id l42sm38173991eeo.14.2013.07.02.11.29.28
        for <linux-media@vger.kernel.org>
        (version=SSLv3 cipher=RC4-SHA bits=128/128);
        Tue, 02 Jul 2013 11:29:28 -0700 (PDT)
Date: Tue, 2 Jul 2013 20:29:26 +0200
From: =?UTF-8?B?QW5kcsOp?= Roth <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/6] libdvbv5: Add parsing of POLARIZATION
Message-ID: <20130702202926.79f682a2@myon.exnihilo>
In-Reply-To: <9815a1c1f366563e7c20e19bea0703e0afb2ef51.1371561676.git.gmsoft@tuxicoman.be>
References: <cover.1371561676.git.gmsoft@tuxicoman.be>
	<9815a1c1f366563e7c20e19bea0703e0afb2ef51.1371561676.git.gmsoft@tuxicoman.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Acked-by: André Roth <neolynx@gmail.com>


On Tue, 18 Jun 2013 16:19:05 +0200
Guy Martin <gmsoft@tuxicoman.be> wrote:

> This patch add parsing support for the POLARIZATION parameter for the DVBv5 file format.
> 
> Signed-off-by: Guy Martin <gmsoft@tuxicoman.be>
> ---
>  lib/include/dvb-file.h  |  1 -
>  lib/libdvbv5/dvb-file.c | 65 ++++++++++++++++++++++---------------------------
>  2 files changed, 29 insertions(+), 37 deletions(-)
> 
> diff --git a/lib/include/dvb-file.h b/lib/include/dvb-file.h
> index ea76080..e38fe85 100644
> --- a/lib/include/dvb-file.h
> +++ b/lib/include/dvb-file.h
> @@ -35,7 +35,6 @@ struct dvb_entry {
>  
>  	char *location;
>  
> -//	enum dvbsat_polarization pol;
>  	int sat_number;
>  	unsigned freq_bpf;
>  	unsigned diseqc_wait;
> diff --git a/lib/libdvbv5/dvb-file.c b/lib/libdvbv5/dvb-file.c
> index aa42a37..02b28e7 100644
> --- a/lib/libdvbv5/dvb-file.c
> +++ b/lib/libdvbv5/dvb-file.c
> @@ -357,6 +357,29 @@ error:
>  	return -1;
>  }
>  
> +static int store_entry_prop(struct dvb_entry *entry,
> +			    uint32_t cmd, uint32_t value)
> +{
> +	int i;
> +
> +	for (i = 0; i < entry->n_props; i++) {
> +		if (cmd == entry->props[i].cmd)
> +			break;
> +	}
> +	if (i == entry->n_props) {
> +		if (i == DTV_MAX_COMMAND) {
> +			fprintf(stderr, "Can't add property %s\n",
> +			       dvb_v5_name[cmd]);
> +			return -1;
> +		}
> +		entry->n_props++;
> +		entry->props[i].cmd = cmd;
> +	}
> +
> +	entry->props[i].u.data = value;
> +
> +	return 0;
> +}
>  
>  #define CHANNEL "CHANNEL"
>  
> @@ -428,16 +451,15 @@ static int fill_entry(struct dvb_entry *entry, char *key, char *value)
>  		is_video = 1;
>  	else if (!strcasecmp(key, "AUDIO_PID"))
>  		is_audio = 1;
> -	/*else if (!strcasecmp(key, "POLARIZATION")) {
> -		entry->service_id = atol(value);
> -		for (j = 0; ARRAY_SIZE(pol_name); j++)
> -			if (!strcasecmp(value, pol_name[j]))
> +	else if (!strcasecmp(key, "POLARIZATION")) {
> +		for (j = 0; ARRAY_SIZE(dvb_sat_pol_name); j++)
> +			if (!strcasecmp(value, dvb_sat_pol_name[j]))
>  				break;
> -		if (j == ARRAY_SIZE(pol_name))
> +		if (j == ARRAY_SIZE(dvb_sat_pol_name))
>  			return -2;
> -		entry->pol = j;
> +		store_entry_prop(entry, DTV_POLARIZATION, j);
>  		return 0;
> -	}*/ else if (!strncasecmp(key,"PID_", 4)){
> +	} else if (!strncasecmp(key,"PID_", 4)){
>  		type = strtol(&key[4], NULL, 16);
>  		if (!type)
>  			return 0;
> @@ -647,11 +669,6 @@ int write_dvb_file(const char *fname, struct dvb_file *dvb_file)
>  			fprintf(fp, "\n");
>  		}
>  
> -		/*if (entry->pol != POLARIZATION_OFF) {*/
> -			/*fprintf(fp, "\tPOLARIZATION = %s\n",*/
> -				/*pol_name[entry->pol]);*/
> -		/*}*/
> -
>  		if (entry->sat_number >= 0) {
>  			fprintf(fp, "\tSAT_NUMBER = %d\n",
>  				entry->sat_number);
> @@ -751,29 +768,6 @@ char *dvb_vchannel(struct dvb_v5_descriptors *dvb_desc,
>  	return buf;
>  }
>  
> -static int store_entry_prop(struct dvb_entry *entry,
> -			    uint32_t cmd, uint32_t value)
> -{
> -	int i;
> -
> -	for (i = 0; i < entry->n_props; i++) {
> -		if (cmd == entry->props[i].cmd)
> -			break;
> -	}
> -	if (i == entry->n_props) {
> -		if (i == DTV_MAX_COMMAND) {
> -			fprintf(stderr, "Can't add property %s\n",
> -			       dvb_v5_name[cmd]);
> -			return -1;
> -		}
> -		entry->n_props++;
> -	}
> -
> -	entry->props[i].u.data = value;
> -
> -	return 0;
> -}
> -
>  static void handle_std_specific_parms(struct dvb_entry *entry,
>  				      struct dvb_v5_descriptors *dvb_desc)
>  {
> @@ -812,7 +806,6 @@ static void handle_std_specific_parms(struct dvb_entry *entry,
>  				 nit_table->frequency[0]);
>  		store_entry_prop(entry, DTV_MODULATION,
>  				 nit_table->modulation);
> -		/*entry->pol = nit_table->pol;*/
>  		store_entry_prop(entry, DTV_POLARIZATION,
>  				 nit_table->pol);
>  		store_entry_prop(entry, DTV_DELIVERY_SYSTEM,
