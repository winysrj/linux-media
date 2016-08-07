Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:57766
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbcHGMK4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Aug 2016 08:10:56 -0400
Date: Sun, 7 Aug 2016 09:10:50 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Georg Wild <georg.wild@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Segfault in dvbv5-scan
Message-ID: <20160807091050.1cb01cff@recife.lan>
In-Reply-To: <4767396.pAn5xf8Txs@acerpc.lan>
References: <4767396.pAn5xf8Txs@acerpc.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 06 Aug 2016 22:34:30 +0200
Georg Wild <georg.wild@gmx.de> escreveu:

> Hello,
> 
> I recently got segmentation faults when using dvbv5-scan (dvbv5-scan 
> -l UNIVERSAL -S1 /usr/share/dvbv5/dvb-s/Astra-19.2E).
> 
> I found out that this happened due to (d->length < len) in int isdbt_desc_delivery_init for some transponder, which results in irrealistic d->num_freqs. I did not trace back why this happens, but suggest the patch below to get at least rid of the segfault.

That's weird... why a DVB-S channel would be initializing such descriptor
(descriptor 0xfa) as it is an ISDB-T descriptor. My wild guess is that
either they're using it for some private usage or this ARIB descriptor
number were reused by something else at the DVB-S/S2 spec.

The right fix would be to check if the descriptor is valid for a given
digital TV standard, adding such logic won't be trivial, as the 
delsys "hint" can only be used when the library knows the standard.
However, the library was designed to also allow getting some stored TS
and parsing it. On such case, there's no way to know what's the standard.

Also, if we ever need parsing the 0xfa descriptor with a different
meaning, we would need to add some extra logic at the descriptor's
dispatcher to allow overriding this in a standard-dependent way.

The fix is still valid, though and should be enough for now. So,
I applied it, with a few adjustments.

While you didn't mention on this e-mail, it seems you found another
source of troubles with the VCT descriptors. I added a separate
patch to address that upstream.

> 
> Additionally I found a memory leak:
> 1. dvb-dev.c, dvb_dev_alloc: dvb is alloc'd, dvb->d is returned, the rest is never freed.

Yes. This is a new file, still under development. I fixed this one,
together with another memory leak.

> 
> 
> Regards
> Georg
> 
> 
> 
> ---------------- lib/libdvbv5/descriptors/desc_isdbt_delivery.c ----------------
> index 4a0f294..6623ca4 100644
> @@ -36,7 +36,12 @@ int isdbt_desc_delivery_init(struct dvb_v5_fe_parms *parms,
>  
>  	bswap16(d->bitfield);
>  
> -	d->num_freqs = (d->length - len)/ sizeof(uint16_t);
> +	if (d->length < len) {
> +		dvb_perror("d->length>len!!");
> +		d->num_freqs=0;
> +	}
> +	else
> +	  d->num_freqs = (d->length - len)/ sizeof(uint16_t);
>  	if (!d->num_freqs)
>  		return 0;
>  	d->frequency = malloc(d->num_freqs * sizeof(*d->frequency));
> 
> --------------------------- lib/libdvbv5/dvb-file.c ---------------------------
> index 33481e5..169c0b5 100644
> @@ -1274,6 +1274,7 @@ int dvb_store_channel(struct dvb_file **dvb_file,
>  			return 0;
>  	}
>  
> +	if (dvb_scan_handler->sdt->service)
>  	dvb_sdt_service_foreach(service, dvb_scan_handler->sdt) {
>  		char *channel = NULL;
>  		char *vchannel = NULL;
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



Thanks,
Mauro
