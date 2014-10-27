Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:9006 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbaJ0ROS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Oct 2014 13:14:18 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NE400GB457TKIA0@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 27 Oct 2014 13:14:17 -0400 (EDT)
Date: Mon, 27 Oct 2014 15:14:13 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: tskd08@gmail.com
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 7/7] v4l-utils/libdvbv5,
 dvbv5-scan: generalize channel duplication check
Message-id: <20141027151413.68ac45cd.m.chehab@samsung.com>
In-reply-to: <1414323983-15996-8-git-send-email-tskd08@gmail.com>
References: <1414323983-15996-1-git-send-email-tskd08@gmail.com>
 <1414323983-15996-8-git-send-email-tskd08@gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 26 Oct 2014 20:46:23 +0900
tskd08@gmail.com escreveu:

> From: Akihiro Tsukada <tskd08@gmail.com>
> 
> include stream id to duplication check

Please add a better description.

I'll review it latter after you fix the issues on the other patches
and send them with the proper SOBs.

I would prefer to apply this patch and look on it more deeply, but
I need first to be able to apply the remaining ones.

> ---
>  lib/include/libdvbv5/dvb-scan.h |  11 ++--
>  lib/libdvbv5/dvb-scan.c         | 132 ++++++++++++----------------------------
>  utils/dvb/dvbv5-scan.c          |  16 ++---
>  3 files changed, 49 insertions(+), 110 deletions(-)
> 
> diff --git a/lib/include/libdvbv5/dvb-scan.h b/lib/include/libdvbv5/dvb-scan.h
> index e3a0d24..aad6d01 100644
> --- a/lib/include/libdvbv5/dvb-scan.h
> +++ b/lib/include/libdvbv5/dvb-scan.h
> @@ -385,16 +385,17 @@ void dvb_add_scaned_transponders(struct dvb_v5_fe_parms *parms,
>   */
>  int dvb_estimate_freq_shift(struct dvb_v5_fe_parms *parms);
>  
> -int dvb_new_freq_is_needed(struct dvb_entry *entry, struct dvb_entry *last_entry,
> -			   uint32_t freq, enum dvb_sat_polarization pol, int shift);
> -int dvb_new_ts_is_needed(struct dvb_entry *entry, struct dvb_entry *last_entry,
> -			   uint32_t freq, int shift, uint32_t ts_id);
> +int dvb_new_entry_is_needed(struct dvb_entry *entry,
> +			   struct dvb_entry *last_entry,
> +			   uint32_t freq, int shift,
> +			   enum dvb_sat_polarization pol, uint32_t stream_id);
>  
>  struct dvb_entry *dvb_scan_add_entry(struct dvb_v5_fe_parms *parms,
>  				     struct dvb_entry *first_entry,
>  			             struct dvb_entry *entry,
>  			             uint32_t freq, uint32_t shift,
> -			             enum dvb_sat_polarization pol);
> +			             enum dvb_sat_polarization pol,
> +			             uint32_t stream_id);
>  
>  void dvb_update_transponders(struct dvb_v5_fe_parms *parms,
>  			     struct dvb_v5_descriptors *dvb_scan_handler,
> diff --git a/lib/libdvbv5/dvb-scan.c b/lib/libdvbv5/dvb-scan.c
> index f265f97..e11a915 100644
> --- a/lib/libdvbv5/dvb-scan.c
> +++ b/lib/libdvbv5/dvb-scan.c
> @@ -693,93 +693,32 @@ int dvb_estimate_freq_shift(struct dvb_v5_fe_parms *__p)
>  	return shift;
>  }
>  
> -int dvb_new_freq_is_needed(struct dvb_entry *entry, struct dvb_entry *last_entry,
> -			   uint32_t freq, enum dvb_sat_polarization pol, int shift)
> +int dvb_new_entry_is_needed(struct dvb_entry *entry,
> +			    struct dvb_entry *last_entry,
> +			    uint32_t freq, int shift,
> +			    enum dvb_sat_polarization pol, uint32_t stream_id)
>  {
> -	int i;
> -	uint32_t data;
> -
>  	for (; entry != last_entry; entry = entry->next) {
> -		for (i = 0; i < entry->n_props; i++) {
> -			data = entry->props[i].u.data;
> -			if (entry->props[i].cmd == DTV_POLARIZATION) {
> -				if (data != pol)
> -					continue;
> -			}
> -			if (entry->props[i].cmd == DTV_FREQUENCY) {
> -				if (( freq >= data - shift) && (freq <= data + shift))
> -					return 0;
> -			}
> -		}
> -	}
> -
> -	return 1;
> -}
> -
> -struct dvb_entry *dvb_scan_add_entry(struct dvb_v5_fe_parms *__p,
> -				     struct dvb_entry *first_entry,
> -			             struct dvb_entry *entry,
> -			             uint32_t freq, uint32_t shift,
> -			             enum dvb_sat_polarization pol)
> -{
> -	struct dvb_v5_fe_parms_priv *parms = (void *)__p;
> -	struct dvb_entry *new_entry;
> -	int i, n = 2;
> -
> -	if (!dvb_new_freq_is_needed(first_entry, NULL, freq, pol, shift))
> -		return NULL;
> -
> -	/* Clone the current entry into a new entry */
> -	new_entry = calloc(sizeof(*new_entry), 1);
> -	if (!new_entry) {
> -		dvb_perror("not enough memory for a new scanning frequency");
> -		return NULL;
> -	}
> +		int i;
>  
> -	memcpy(new_entry, entry, sizeof(*entry));
> +		for (i = 0; i < entry->n_props; i++) {
> +			uint32_t data = entry->props[i].u.data;
>  
> -	/*
> -	 * The frequency should change to the new one. Seek for it and
> -	 * replace its value to the desired one.
> -	 */
> -	for (i = 0; i < new_entry->n_props; i++) {
> -		if (new_entry->props[i].cmd == DTV_FREQUENCY) {
> -			new_entry->props[i].u.data = freq;
> -			/* Navigate to the end of the entry list */
> -			while (entry->next) {
> -				entry = entry->next;
> -				n++;
> +			if (entry->props[i].cmd == DTV_FREQUENCY) {
> +				if (freq < data - shift || freq > data + shift)
> +					break;
>  			}
> -			dvb_log("New transponder/channel found: #%d: %d",
> -			        n, freq);
> -			entry->next = new_entry;
> -			new_entry->next = NULL;
> -			return new_entry;
> -		}
> -	}
> -
> -	/* This should never happen */
> -	dvb_logerr("BUG: Couldn't add %d to the scan frequency list.", freq);
> -	free(new_entry);
> -
> -	return NULL;
> -}
> -
> -int dvb_new_ts_is_needed(struct dvb_entry *entry, struct dvb_entry *last_entry,
> -			 uint32_t freq, int shift, uint32_t ts_id)
> -{
> -	int i;
> -	uint32_t data;
> -
> -	for (; entry != last_entry; entry = entry->next) {
> -		for (i = 0; i < entry->n_props; i++) {
> -			data = entry->props[i].u.data;
> -			if (entry->props[i].cmd == DTV_STREAM_ID) {
> -				if (data != ts_id)
> +			if (pol != POLARIZATION_OFF
> +			    && entry->props[i].cmd == DTV_POLARIZATION) {
> +				if (data != pol)
>  					break;
>  			}
> -			if (entry->props[i].cmd == DTV_FREQUENCY) {
> -				if (freq < data - shift || freq > data + shift)
> +			/* NO_STREAM_ID_FILTER: stream_id is not used.
> +			 * 0: unspecified/auto. libdvbv5 default value.
> +			 */
> +			if (stream_id != NO_STREAM_ID_FILTER && stream_id != 0
> +			    && entry->props[i].cmd == DTV_STREAM_ID) {
> +				if (data != stream_id)
>  					break;
>  			}
>  		}
> @@ -790,16 +729,19 @@ int dvb_new_ts_is_needed(struct dvb_entry *entry, struct dvb_entry *last_entry,
>  	return 1;
>  }
>  
> -static struct dvb_entry *
> -dvb_scan_add_entry_isdbs(struct dvb_v5_fe_parms *__p,
> -			 struct dvb_entry *first_entry, struct dvb_entry *entry,
> -			 uint32_t freq, uint32_t shift, uint32_t ts_id)
> +struct dvb_entry *dvb_scan_add_entry(struct dvb_v5_fe_parms *__p,
> +				     struct dvb_entry *first_entry,
> +			             struct dvb_entry *entry,
> +			             uint32_t freq, uint32_t shift,
> +			             enum dvb_sat_polarization pol,
> +				     uint32_t stream_id)
>  {
>  	struct dvb_v5_fe_parms_priv *parms = (void *)__p;
>  	struct dvb_entry *new_entry;
>  	int i, n = 2;
>  
> -	if (!dvb_new_ts_is_needed(first_entry, NULL, freq, shift, ts_id))
> +	if (!dvb_new_entry_is_needed(first_entry, NULL, freq, shift, pol,
> +				     stream_id))
>  		return NULL;
>  
>  	/* Clone the current entry into a new entry */
> @@ -874,7 +816,7 @@ static void add_update_nit_dvbc(struct dvb_table_nit *nit,
>  		new = tr->entry;
>  	} else {
>  		new = dvb_scan_add_entry(tr->parms, tr->first_entry, tr->entry,
> -					 d->frequency, tr->shift, tr->pol);
> +					 d->frequency, tr->shift, tr->pol, 0);
>  		if (!new)
>  			return;
>  	}
> @@ -908,7 +850,8 @@ static void add_update_nit_isdbt(struct dvb_table_nit *nit,
>  
>  	for (i = 0; i < d->num_freqs; i++) {
>  		new = dvb_scan_add_entry(tr->parms, tr->first_entry, tr->entry,
> -					 d->frequency[i], tr->shift, tr->pol);
> +					 d->frequency[i], tr->shift,
> +					 tr->pol, 0);
>  		if (!new)
>  			return;
>  	}
> @@ -984,9 +927,9 @@ static void add_update_nit_dvbt2(struct dvb_table_nit *nit,
>  	for (i = 0; i < t2->frequency_loop_length; i++) {
>  		new = dvb_scan_add_entry(tr->parms, tr->first_entry, tr->entry,
>  					 t2->centre_frequency[i] * 10,
> -					 tr->shift, tr->pol);
> +					 tr->shift, tr->pol, t2->plp_id);
>  		if (!new)
> -			return;
> +			continue;
>  
>  		dvb_store_entry_prop(new, DTV_DELIVERY_SYSTEM,
>  				     SYS_DVBT2);
> @@ -1014,7 +957,8 @@ static void add_update_nit_dvbt(struct dvb_table_nit *nit,
>  		return;
>  
>  	new = dvb_scan_add_entry(tr->parms, tr->first_entry, tr->entry,
> -				d->centre_frequency * 10, tr->shift, tr->pol);
> +				d->centre_frequency * 10, tr->shift,
> +				tr->pol, 0);
>  	if (!new)
>  		return;
>  
> @@ -1053,7 +997,7 @@ static void add_update_nit_dvbs(struct dvb_table_nit *nit,
>  		new = tr->entry;
>  	} else {
>  		new = dvb_scan_add_entry(tr->parms, tr->first_entry, tr->entry,
> -					 d->frequency, tr->shift, tr->pol);
> +					 d->frequency, tr->shift, tr->pol, 0);
>  		if (!new)
>  			return;
>  	}
> @@ -1094,9 +1038,9 @@ static void add_update_nit_isdbs(struct dvb_table_nit *nit,
>  	if (tr->update)
>  		return;
>  
> -        ts_id = tran->transport_id;
> -	new = dvb_scan_add_entry_isdbs(tr->parms, tr->first_entry, tr->entry,
> -				       d->frequency, tr->shift, ts_id);
> +	ts_id = tran->transport_id;
> +	new = dvb_scan_add_entry(tr->parms, tr->first_entry, tr->entry,
> +				 d->frequency, tr->shift, tr->pol, ts_id);
>  	if (!new)
>  		return;
>  
> diff --git a/utils/dvb/dvbv5-scan.c b/utils/dvb/dvbv5-scan.c
> index e87c983..ef2b3ab 100644
> --- a/utils/dvb/dvbv5-scan.c
> +++ b/utils/dvb/dvbv5-scan.c
> @@ -241,6 +241,7 @@ static int run_scan(struct arguments *args,
>  
>  	for (entry = dvb_file->first_entry; entry != NULL; entry = entry->next) {
>  		struct dvb_v5_descriptors *dvb_scan_handler = NULL;
> +		uint32_t stream_id;
>  
>  		/*
>  		 * If the channel file has duplicated frequencies, or some
> @@ -254,18 +255,11 @@ static int run_scan(struct arguments *args,
>  		if (dvb_retrieve_entry_prop(entry, DTV_POLARIZATION, &pol))
>  			pol = POLARIZATION_OFF;
>  
> -		if (parms->current_sys == SYS_ISDBS) {
> -			uint32_t tsid = 0;
> +		if (dvb_retrieve_entry_prop(entry, DTV_STREAM_ID, &stream_id))
> +			stream_id = NO_STREAM_ID_FILTER;
>  
> -			dvb_store_entry_prop(entry, DTV_POLARIZATION, POLARIZATION_R);
> -
> -			dvb_retrieve_entry_prop(entry, DTV_STREAM_ID, &tsid);
> -			if (!dvb_new_ts_is_needed(dvb_file->first_entry, entry,
> -						  freq, shift, tsid))
> -				continue;
> -		} else
> -		if (!dvb_new_freq_is_needed(dvb_file->first_entry, entry,
> -					    freq, pol, shift))
> +		if (!dvb_new_entry_is_needed(dvb_file->first_entry, entry,
> +						  freq, shift, pol, stream_id))
>  			continue;
>  
>  		count++;
