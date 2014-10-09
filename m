Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:52829 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbaJISMz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Oct 2014 14:12:55 -0400
Received: by mail-pa0-f41.google.com with SMTP id eu11so204749pac.28
        for <linux-media@vger.kernel.org>; Thu, 09 Oct 2014 11:12:55 -0700 (PDT)
Message-ID: <5436CFD4.4090400@gmail.com>
Date: Fri, 10 Oct 2014 03:11:32 +0900
From: Akihiro TSUKADA <tskd08@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 4/4] v4l-utils/dvbv5-scan: add support for ISDB-S scanning
References: <1412770181-5420-1-git-send-email-tskd08@gmail.com> <1412770181-5420-5-git-send-email-tskd08@gmail.com> <20141008130426.792d7bb7.m.chehab@samsung.com>
In-Reply-To: <20141008130426.792d7bb7.m.chehab@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2014年10月09日 01:04, Mauro Carvalho Chehab wrote:
>> @@ -251,6 +251,16 @@ static int run_scan(struct arguments *args,
>>  		if (dvb_retrieve_entry_prop(entry, DTV_POLARIZATION, &pol))
>>  			pol = POLARIZATION_OFF;
>>  
>> +		if (parms->current_sys == SYS_ISDBS) {
>> +			uint32_t tsid = 0;
>> +
>> +			dvb_store_entry_prop(entry, DTV_POLARIZATION, POLARIZATION_R);
>> +
>> +			dvb_retrieve_entry_prop(entry, DTV_STREAM_ID, &tsid);
>> +			if (!dvb_new_ts_is_needed(dvb_file->first_entry, entry,
>> +						  freq, shift, tsid))
>> +				continue;
> 
> This is likely needed for DVB-T2 and DVB-S2 too.

Should we compare channel entries by (freq, stream_id, polarization) triplet
instead of by the current (freq, polarization) or (freq, stream_id)?

>> @@ -258,6 +268,10 @@ static int run_scan(struct arguments *args,
>>  		count++;
>>  		dvb_log("Scanning frequency #%d %d", count, freq);
>>  
>> +		if (!args->lnb_name && entry->lnb &&
>> +		    (!parms->lnb || strcasecmp(entry->lnb, parms->lnb->alias)))
> 
> Shouldn't it be: !strcasecmp(entry->lnb, parms->lnb->alias)? Or maybe just
> remove this test.
I want to update parms->lnb (which was set from the prev entry)
only if it differs from entry->lnb (current one),
and don't want to linear-search all LNB types for every entries,
as lots of entries are expected to have the same LNB types.
--
akihiro 
