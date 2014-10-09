Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:14192 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbaJISf0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Oct 2014 14:35:26 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0ND6002F8WZ0VE70@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 09 Oct 2014 14:35:24 -0400 (EDT)
Date: Thu, 09 Oct 2014 15:35:20 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Akihiro TSUKADA <tskd08@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 4/4] v4l-utils/dvbv5-scan: add support for ISDB-S scanning
Message-id: <20141009153520.281def64.m.chehab@samsung.com>
In-reply-to: <5436CFD4.4090400@gmail.com>
References: <1412770181-5420-1-git-send-email-tskd08@gmail.com>
 <1412770181-5420-5-git-send-email-tskd08@gmail.com>
 <20141008130426.792d7bb7.m.chehab@samsung.com> <5436CFD4.4090400@gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 10 Oct 2014 03:11:32 +0900
Akihiro TSUKADA <tskd08@gmail.com> escreveu:

> On 2014年10月09日 01:04, Mauro Carvalho Chehab wrote:
> >> @@ -251,6 +251,16 @@ static int run_scan(struct arguments *args,
> >>  		if (dvb_retrieve_entry_prop(entry, DTV_POLARIZATION, &pol))
> >>  			pol = POLARIZATION_OFF;
> >>  
> >> +		if (parms->current_sys == SYS_ISDBS) {
> >> +			uint32_t tsid = 0;
> >> +
> >> +			dvb_store_entry_prop(entry, DTV_POLARIZATION, POLARIZATION_R);
> >> +
> >> +			dvb_retrieve_entry_prop(entry, DTV_STREAM_ID, &tsid);
> >> +			if (!dvb_new_ts_is_needed(dvb_file->first_entry, entry,
> >> +						  freq, shift, tsid))
> >> +				continue;
> > 
> > This is likely needed for DVB-T2 and DVB-S2 too.
> 
> Should we compare channel entries by (freq, stream_id, polarization) triplet
> instead of by the current (freq, polarization) or (freq, stream_id)?

For DVB-S2, it should likely  be (freq, stream_id, polarization) triplet
(tests needed).

For DVB-T2, (freq, stream_id) pair should work;

For ISDB-S, you likely need the (freq, stream_id, polarization) triplet
too, as you may have two polarizations there, right?

> >> @@ -258,6 +268,10 @@ static int run_scan(struct arguments *args,
> >>  		count++;
> >>  		dvb_log("Scanning frequency #%d %d", count, freq);
> >>  
> >> +		if (!args->lnb_name && entry->lnb &&
> >> +		    (!parms->lnb || strcasecmp(entry->lnb, parms->lnb->alias)))
> > 
> > Shouldn't it be: !strcasecmp(entry->lnb, parms->lnb->alias)? Or maybe just
> > remove this test.
> I want to update parms->lnb (which was set from the prev entry)
> only if it differs from entry->lnb (current one),
> and don't want to linear-search all LNB types for every entries,
> as lots of entries are expected to have the same LNB types.

Ah, ok. Please add a comment then.

> --
> akihiro 
